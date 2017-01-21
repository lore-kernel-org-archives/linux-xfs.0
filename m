Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33838 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752327AbdAUAPM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jan 2017 19:15:12 -0500
Date: Fri, 20 Jan 2017 16:15:05 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v5 1/5] xfs_db: sanitize geometry on load
Message-ID: <20170121001505.GK12985@birch.djwong.org>
References: <148494391629.5256.3328772079712970611.stgit@birch.djwong.org>
 <148494392247.5256.10692618169002348643.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148494392247.5256.10692618169002348643.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

xfs_db doesn't check the filesystem geometry when it's mounting, which
means that garbage agcount values can cause OOMs when we try to allocate
all the per-AG incore metadata.  If we see geometry that looks
suspicious, try to derive the actual AG geometry to avoid crashing the
system.  This should help with xfs/1301 fuzzing.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: Only modify sb_ag{blocks,count} if they seem insane -- use local
variables to avoid screwing up the rest of the metadata.
v3: Suggest a possible agcount value, but always restrict to 1 AG.
v4: Remove the suggested agcount value and make sure we can't exit
the program with an exitcode of zero.
v5: remove global variables and unnecessary parameters
---
 db/init.c |   89 +++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 77 insertions(+), 12 deletions(-)

diff --git a/db/init.c b/db/init.c
index ec1e274..0c684a5 100644
--- a/db/init.c
+++ b/db/init.c
@@ -51,13 +51,81 @@ usage(void)
 	exit(1);
 }
 
+/* Try to load a superblock for the given agno, no verifiers. */
+static bool
+load_sb(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*sbp)
+{
+	struct xfs_buf		*bp;
+
+	bp = libxfs_readbuf(mp->m_ddev_targp, XFS_SB_DADDR,
+			    1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, NULL);
+
+	if (!bp || bp->b_error)
+		return false;
+
+	/* copy SB from buffer to in-core, converting architecture as we go */
+	libxfs_sb_from_disk(sbp, XFS_BUF_TO_SBP(bp));
+	libxfs_putbuf(bp);
+	libxfs_purgebuf(bp);
+
+	return true;
+}
+
+/*
+ * If the agcount doesn't look sane, suggest a real agcount to the user,
+ * and pretend agcount = 1 to avoid OOMing libxfs_initialize_perag.
+ * Returns true if the geometry was sane.
+ */
+static bool
+sanitize_geometry(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*sbp)
+{
+	unsigned int		blocklog;
+	unsigned int		blocksize;
+	unsigned long long	dblocks;
+
+	/* If the geometry looks ok, we're done. */
+	if (sbp->sb_blocklog >= XFS_MIN_BLOCKSIZE_LOG &&
+	    sbp->sb_blocklog <= XFS_MAX_BLOCKSIZE_LOG &&
+	    sbp->sb_blocksize == (1 << sbp->sb_blocklog) &&
+	    sbp->sb_dblocks * sbp->sb_blocksize <= x.dsize * x.dbsize &&
+	    sbp->sb_dblocks <= XFS_MAX_DBLOCKS(sbp) &&
+	    sbp->sb_dblocks >= XFS_MIN_DBLOCKS(sbp))
+		return true;
+
+	/* Check blocklog and blocksize */
+	blocklog = sbp->sb_blocklog;
+	blocksize = sbp->sb_blocksize;
+	if (blocklog < XFS_MIN_BLOCKSIZE_LOG ||
+	    blocklog > XFS_MAX_BLOCKSIZE_LOG)
+		blocklog = libxfs_log2_roundup(blocksize);
+	if (blocksize != (1 << blocklog))
+		blocksize = (1 << blocksize);
+
+	/* Clamp dblocks to the size of the device. */
+	dblocks = sbp->sb_dblocks;
+	if (dblocks > x.dsize * x.dbsize / blocksize)
+		dblocks = x.dsize * x.dbsize / blocksize;
+
+	/* Assume 1 AG to avoid OOM. */
+	fprintf(stderr,
+_("%s: device %s AG count is insane.  Limiting reads to AG 0.\n"),
+		progname, fsdevice);
+	sbp->sb_agcount = 1;
+
+	return false;
+}
+
 void
 init(
 	int		argc,
-	char		**argv)
+	char		**argv,
+	bool		*insane_agcount)
 {
 	struct xfs_sb	*sbp;
-	struct xfs_buf	*bp;
 	int		c;
 
 	setlocale(LC_ALL, "");
@@ -124,20 +192,12 @@ init(
 	 */
 	memset(&xmount, 0, sizeof(struct xfs_mount));
 	libxfs_buftarg_init(&xmount, x.ddev, x.logdev, x.rtdev);
-	bp = libxfs_readbuf(xmount.m_ddev_targp, XFS_SB_DADDR,
-			    1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, NULL);
-
-	if (!bp || bp->b_error) {
+	if (!load_sb(&xmount, &xmount.m_sb)) {
 		fprintf(stderr, _("%s: %s is invalid (cannot read first 512 "
 			"bytes)\n"), progname, fsdevice);
 		exit(1);
 	}
 
-	/* copy SB from buffer to in-core, converting architecture as we go */
-	libxfs_sb_from_disk(&xmount.m_sb, XFS_BUF_TO_SBP(bp));
-	libxfs_putbuf(bp);
-	libxfs_purgebuf(bp);
-
 	sbp = &xmount.m_sb;
 	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
 		fprintf(stderr, _("%s: %s is not a valid XFS filesystem (unexpected SB magic number 0x%08x)\n"),
@@ -148,6 +208,8 @@ init(
 		}
 	}
 
+	*insane_agcount = !sanitize_geometry(&xmount, sbp);
+
 	mp = libxfs_mount(&xmount, sbp, x.ddev, x.logdev, x.rtdev,
 			  LIBXFS_MOUNT_DEBUGGER);
 	if (!mp) {
@@ -190,10 +252,11 @@ main(
 	int	c, i, done = 0;
 	char	*input;
 	char	**v;
+	bool	insane_agcount;
 	int	start_iocur_sp;
 
 	pushfile(stdin);
-	init(argc, argv);
+	init(argc, argv, &insane_agcount);
 	start_iocur_sp = iocur_sp;
 
 	for (i = 0; !done && i < ncmdline; i++) {
@@ -230,5 +293,7 @@ main(
 		libxfs_device_close(x.logdev);
 	if (x.rtdev)
 		libxfs_device_close(x.rtdev);
+	if (insane_agcount && exitcode == 0)
+		exitcode = 1;
 	return exitcode;
 }
