Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2D17D29E06
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 17:34:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B9A15AC002
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 15:34:38 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id CWshTHwprsNuAgvG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Jul 2015 15:34:37 -0700 (PDT)
Subject: [PATCH 15/24] xfs: handle directio copy-on-write for reflinked blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 29 Jul 2015 15:34:35 -0700
Message-ID: <20150729223435.17414.67288.stgit@birch.djwong.org>
In-Reply-To: <20150729223258.17414.91354.stgit@birch.djwong.org>
References: <20150729223258.17414.91354.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

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
index 7332d72..bf4b408 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1494,6 +1494,12 @@ __xfs_get_blocks(
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
index 981b028..211052a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -869,10 +869,18 @@ xfs_file_write_iter(
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
index 263f30b..f841a1a 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -406,6 +406,40 @@ advloop:
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
