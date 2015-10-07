Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4CAE27FAF
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:00:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B303FAC007
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:00:23 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id CJUEgfZhZzdgk7nH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:00:22 -0700 (PDT)
Subject: [PATCH 47/58] xfs: handle directio copy-on-write for reflinked blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:00:18 -0700
Message-ID: <20151007050018.30457.90081.stgit@birch.djwong.org>
In-Reply-To: <20151007045443.30457.47038.stgit@birch.djwong.org>
References: <20151007045443.30457.47038.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

We hope that CoW writes will be rare and that directio CoW writes will
be even more rare.  Therefore, fall-back any such write to the
buffered path.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c    |    6 ++++++
 fs/xfs/xfs_file.c    |   12 ++++++++++--
 fs/xfs/xfs_reflink.c |   34 ++++++++++++++++++++++++++++++++++
 3 files changed, 50 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 06a1d2f..4ab24fa 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1491,6 +1491,12 @@ __xfs_get_blocks(
 	if (imap.br_startblock != HOLESTARTBLOCK &&
 	    imap.br_startblock != DELAYSTARTBLOCK &&
 	    (create || !ISUNWRITTEN(&imap))) {
+		if (create && direct) {
+			error = xfs_reflink_redirect_directio_write(ip, &imap,
+					offset);
+			if (error)
+				return error;
+		}
 		xfs_map_buffer(inode, bh_result, &imap, offset);
 		if (ISUNWRITTEN(&imap))
 			set_buffer_unwritten(bh_result);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 593223f..fc5b9ea 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -876,10 +876,18 @@ xfs_file_write_iter(
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
-	if ((iocb->ki_flags & IOCB_DIRECT) || IS_DAX(inode))
+	/*
+	 * Allow DIO to fall back to buffered *only* in the case that we're
+	 * doing a reflink CoW.
+	 */
+	if ((iocb->ki_flags & IOCB_DIRECT) || IS_DAX(inode)) {
 		ret = xfs_file_dio_aio_write(iocb, from);
-	else
+		if (ret == -EREMCHG)
+			goto buffered;
+	} else {
+buffered:
 		ret = xfs_file_buffered_aio_write(iocb, from);
+	}
 
 	if (ret > 0) {
 		ssize_t err;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 1e00be2..226e23f 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -407,6 +407,40 @@ advloop:
 }
 
 /**
+ * xfs_reflink_redirect_directio_write() - bounce a directio write to a
+ *					   reflinked region down to buffered
+ *					   write mode.
+ *
+ * @ip: XFS inode object
+ * @imap: the fileoff:fsblock mapping that we might fork
+ * @offset: the file byte offset of the block we're examining
+ */
+int
+xfs_reflink_redirect_directio_write(
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*imap,
+	xfs_off_t		offset)
+{
+	bool			type = false;
+	int			error;
+
+	error = xfs_reflink_should_fork_block(ip, imap, offset, &type);
+	if (error)
+		return error;
+	if (!type)
+		return 0;
+
+	/*
+	 * Are we doing a DIO write to a reflinked block?  In the ideal world
+	 * we at least would fork full blocks, but for now just fall back to
+	 * buffered mode.  Yuck.  Use -EREMCHG ("remote address changed") to
+	 * signal this, since in general XFS doesn't do this sort of fallback.
+	 */
+	trace_xfs_reflink_bounce_direct_write(ip, imap);
+	return -EREMCHG;
+}
+
+/**
  * xfs_reflink_write_fork_block() -- find a remapping object and redirect the
  *				     write.
  *

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
