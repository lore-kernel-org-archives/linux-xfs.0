Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1E5BA7F7B
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 02:52:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 08CA88F8065
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 00:52:21 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	dj4TfaK7YYJ7JwSY for <xfs@oss.sgi.com>;
	Tue, 04 Mar 2014 00:52:20 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WKl4w-0006Hg-Pc
	for xfs@oss.sgi.com; Tue, 04 Mar 2014 19:51:58 +1100
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WKl4w-00070J-On
	for xfs@oss.sgi.com; Tue, 04 Mar 2014 19:51:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 13/13] repair: phase 1 does not handle superblock CRCs
Date: Tue,  4 Mar 2014 19:51:57 +1100
Message-Id: <1393923117-9559-14-git-send-email-david@fromorbit.com>
In-Reply-To: <1393923117-9559-1-git-send-email-david@fromorbit.com>
References: <1393923117-9559-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Phase 1 of xfs_repair verifies and corrects the primary
superblock of the filesystem. It does not verify that the CRC of the
superblock that is found is correct, nor does it recalculate the CRC
of the superblock it rewrites.

This happens because phase1 does not use the libxfs buffer cache -
it just uses pread/pwrite on a memory buffer, and works directly
from that buffer. Hence we need to add CRC verification to
verify_sb(), and CRC recalculation to write_primary_sb() so that it
works correctly.

This also enables us to use get_sb() as the method of fetching the
superblock from disk after phase 1 without needing to use the libxfs
buffer cache and guessing at the sector size. This prevents a
verifier error because it attempts to CRC a superblock buffer that
is much longer than the usual sector sizes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/agheader.c   |  2 +-
 repair/globals.h    |  3 ++-
 repair/phase1.c     |  5 ++--
 repair/protos.h     |  3 ++-
 repair/sb.c         | 71 +++++++++++++++++++++++++++++------------------------
 repair/xfs_repair.c | 26 +++++++++++---------
 6 files changed, 62 insertions(+), 48 deletions(-)

diff --git a/repair/agheader.c b/repair/agheader.c
index 53e47b6..fc5dac9 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -472,7 +472,7 @@ verify_set_agheader(xfs_mount_t *mp, xfs_buf_t *sbuf, xfs_sb_t *sb,
 	int status = XR_OK;
 	int status_sb = XR_OK;
 
-	status = verify_sb(sb, (i == 0));
+	status = verify_sb(sbuf->b_addr, sb, (i == 0));
 
 	if (status != XR_OK)  {
 		do_warn(_("bad on-disk superblock %d - %s\n"),
diff --git a/repair/globals.h b/repair/globals.h
index cbb2ce7..f6e0a22 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -49,7 +49,8 @@
 #define XR_BAD_SB_UNIT		17	/* bad stripe unit */
 #define XR_BAD_SB_WIDTH		18	/* bad stripe width */
 #define XR_BAD_SVN		19	/* bad shared version number */
-#define XR_BAD_ERR_CODE		20	/* Bad error code */
+#define XR_BAD_CRC		20	/* Bad CRC */
+#define XR_BAD_ERR_CODE		21	/* Bad error code */
 
 /* XFS filesystem (il)legal values */
 
diff --git a/repair/phase1.c b/repair/phase1.c
index 62de211..ec75ada 100644
--- a/repair/phase1.c
+++ b/repair/phase1.c
@@ -70,13 +70,14 @@ phase1(xfs_mount_t *mp)
 	ag_bp = alloc_ag_buf(MAX_SECTSIZE);
 	sb = (xfs_sb_t *) ag_bp;
 
-	if (get_sb(sb, 0LL, MAX_SECTSIZE, 0) == XR_EOF)
+	rval = get_sb(sb, 0LL, MAX_SECTSIZE, 0);
+	if (rval == XR_EOF)
 		do_error(_("error reading primary superblock\n"));
 
 	/*
 	 * is this really an sb, verify internal consistency
 	 */
-	if ((rval = verify_sb(sb, 1)) != XR_OK)  {
+	if (rval != XR_OK)  {
 		do_warn(_("bad primary superblock - %s !!!\n"),
 			err_string(rval));
 		if (!find_secondary_sb(sb))
diff --git a/repair/protos.h b/repair/protos.h
index 601f2a9..ff42fa7 100644
--- a/repair/protos.h
+++ b/repair/protos.h
@@ -18,7 +18,8 @@
 
 void	xfs_init(libxfs_init_t *args);
 
-int	verify_sb(xfs_sb_t		*sb,
+int	verify_sb(char			*sb_buf,
+		xfs_sb_t		*sb,
 		int			is_primary_sb);
 int	verify_set_primary_sb(xfs_sb_t	*root_sb,
 			int		sb_index,
diff --git a/repair/sb.c b/repair/sb.c
index c54d89b..b111aca 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -139,7 +139,7 @@ find_secondary_sb(xfs_sb_t *rsb)
 			c_bufsb = (char *)sb + i;
 			libxfs_sb_from_disk(&bufsb, (xfs_dsb_t *)c_bufsb);
 
-			if (verify_sb(&bufsb, 0) != XR_OK)
+			if (verify_sb(c_bufsb, &bufsb, 0) != XR_OK)
 				continue;
 
 			do_warn(_("found candidate secondary superblock...\n"));
@@ -245,7 +245,7 @@ sb_validate_ino_align(struct xfs_sb *sb)
  */
 
 int
-verify_sb(xfs_sb_t *sb, int is_primary_sb)
+verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 {
 	__uint32_t	bsize;
 	int		i;
@@ -263,8 +263,34 @@ verify_sb(xfs_sb_t *sb, int is_primary_sb)
 	if (is_primary_sb && sb->sb_inprogress == 1)
 		return(XR_BAD_INPROGRESS);
 
-	/* check to make sure blocksize is legal 2^N, 9 <= N <= 16 */
+	/*
+	 * before going *any further*, validate the sector size and if the
+	 * version says we should have CRCs enabled, validate that.
+	 */
+
+	/* check to make sure sectorsize is legal 2^N, 9 <= N <= 15 */
+	if (sb->sb_sectsize == 0)
+		return(XR_BAD_SECT_SIZE_DATA);
+
+	bsize = 1;
+	for (i = 0; bsize < sb->sb_sectsize &&
+		i < sizeof(sb->sb_sectsize) * NBBY; i++)  {
+		bsize <<= 1;
+	}
+
+	if (i < XFS_MIN_SECTORSIZE_LOG || i > XFS_MAX_SECTORSIZE_LOG)
+		return(XR_BAD_SECT_SIZE_DATA);
+
+	/* check sb sectorsize field against sb sectlog field */
+	if (i != sb->sb_sectlog)
+		return(XR_BAD_SECT_SIZE_DATA);
+
+	/* sector size in range - CRC check time */
+	if (xfs_sb_version_hascrc(sb) &&
+	    !xfs_verify_cksum(sb_buf, sb->sb_sectsize, XFS_SB_CRC_OFF))
+		return XR_BAD_CRC;
 
+	/* check to make sure blocksize is legal 2^N, 9 <= N <= 16 */
 	if (sb->sb_blocksize == 0)
 		return(XR_BAD_BLOCKSIZE);
 
@@ -300,26 +326,6 @@ verify_sb(xfs_sb_t *sb, int is_primary_sb)
 		sb->sb_inopblock != howmany(sb->sb_blocksize,sb->sb_inodesize))
 		return(XR_BAD_INO_SIZE_DATA);
 
-	/* check to make sure sectorsize is legal 2^N, 9 <= N <= 15 */
-
-	if (sb->sb_sectsize == 0)
-		return(XR_BAD_SECT_SIZE_DATA);
-
-	bsize = 1;
-
-	for (i = 0; bsize < sb->sb_sectsize &&
-		i < sizeof(sb->sb_sectsize) * NBBY; i++)  {
-		bsize <<= 1;
-	}
-
-	if (i < XFS_MIN_SECTORSIZE_LOG || i > XFS_MAX_SECTORSIZE_LOG)
-		return(XR_BAD_SECT_SIZE_DATA);
-
-	/* check sb sectorsize field against sb sectlog field */
-
-	if (i != sb->sb_sectlog)
-		return(XR_BAD_SECT_SIZE_DATA);
-
 	if (xfs_sb_version_hassector(sb))  {
 
 		/* check to make sure log sector is legal 2^N, 9 <= N <= 15 */
@@ -482,9 +488,11 @@ write_primary_sb(xfs_sb_t *sbp, int size)
 		do_error(_("couldn't seek to offset 0 in filesystem\n"));
 	}
 
-	
 	libxfs_sb_to_disk(buf, sbp, XFS_SB_ALL_BITS);
 
+	if (xfs_sb_version_hascrc(sbp))
+		xfs_update_cksum((char *)buf, size, XFS_SB_CRC_OFF);
+
 	if (write(x.dfd, buf, size) != size) {
 		free(buf);
 		do_error(_("primary superblock write failed!\n"));
@@ -494,7 +502,7 @@ write_primary_sb(xfs_sb_t *sbp, int size)
 }
 
 /*
- * get a possible superblock -- don't check for internal consistency
+ * get a possible superblock -- checks for internal consistency
  */
 int
 get_sb(xfs_sb_t *sbp, xfs_off_t off, int size, xfs_agnumber_t agno)
@@ -529,9 +537,10 @@ get_sb(xfs_sb_t *sbp, xfs_off_t off, int size, xfs_agnumber_t agno)
 		do_error("%s\n", strerror(error));
 	}
 	libxfs_sb_from_disk(sbp, buf);
-	free(buf);
 
-	return (verify_sb(sbp, 0));
+	rval = verify_sb((char *)buf, sbp, agno == 0);
+	free(buf);
+	return rval;
 }
 
 /* returns element on list with highest reference count */
@@ -745,13 +754,11 @@ verify_set_primary_sb(xfs_sb_t		*rsb,
 			off = (xfs_off_t)agno * rsb->sb_agblocks << rsb->sb_blocklog;
 
 			checked[agno] = 1;
-
-			if (get_sb(sb, off, size, agno) == XR_EOF)  {
-				retval = XR_EOF;
+			retval = get_sb(sb, off, size, agno);
+			if (retval == XR_EOF)
 				goto out_free_list;
-			}
 
-			if (verify_sb(sb, 0) == XR_OK)  {
+			if (retval == XR_OK) {
 				/*
 				 * save away geometry info.
 				 * don't bother checking the sb
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 6327076..08b25f0 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -137,6 +137,8 @@ err_string(int err_code)
 			_("bad stripe width in superblock");
 		err_message[XR_BAD_SVN] =
 			_("bad shared version number in superblock");
+		err_message[XR_BAD_CRC] =
+			_("bad CRC in superblock");
 		done = 1;
 	}
 
@@ -529,6 +531,8 @@ main(int argc, char **argv)
 	xfs_buf_t	*sbp;
 	xfs_mount_t	xfs_m;
 	char		*msgbuf;
+	struct xfs_sb	psb;
+	int		rval;
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
@@ -558,13 +562,12 @@ main(int argc, char **argv)
 		exit(1);
 	}
 
-	/* prepare the mount structure */
-	memset(&xfs_m, 0, sizeof(xfs_mount_t));
-	libxfs_buftarg_init(&xfs_m, x.ddev, x.logdev, x.rtdev);
-	sbp = libxfs_readbuf(xfs_m.m_ddev_targp, XFS_SB_DADDR,
-				1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0,
-				&xfs_sb_buf_ops);
-	libxfs_sb_from_disk(&xfs_m.m_sb, XFS_BUF_TO_SBP(sbp));
+	rval = get_sb(&psb, 0, XFS_MAX_SECTORSIZE, 0);
+	if (rval != XR_OK) {
+		do_warn(_("Primary superblock bad after phase 1!\n"
+			  "Exiting now.\n"));
+		exit(1);
+	}
 
 	/*
 	 * if the sector size of the filesystem we are trying to repair is
@@ -583,7 +586,7 @@ main(int argc, char **argv)
 			geom.sectsize = BBSIZE;
 		}
 
-		if (xfs_m.m_sb.sb_sectsize < geom.sectsize) {
+		if (psb.sb_sectsize < geom.sectsize) {
 			long	old_flags;
 
 			old_flags = fcntl(fd, F_GETFL, 0);
@@ -595,7 +598,10 @@ main(int argc, char **argv)
 			}
 		}
 	}
-	mp = libxfs_mount(&xfs_m, &xfs_m.m_sb, x.ddev, x.logdev, x.rtdev, 0);
+
+	/* prepare the mount structure */
+	memset(&xfs_m, 0, sizeof(xfs_mount_t));
+	mp = libxfs_mount(&xfs_m, &psb, x.ddev, x.logdev, x.rtdev, 0);
 
 	if (!mp)  {
 		fprintf(stderr,
@@ -603,8 +609,6 @@ main(int argc, char **argv)
 			progname);
 		exit(1);
 	}
-	libxfs_putbuf(sbp);
-	libxfs_purgebuf(sbp);
 
 	/*
 	 * set XFS-independent status vars from the mount/sb structure
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
