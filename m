Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 107A67F99
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 18:40:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 806AFAC001
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 16:40:05 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 2dghFNCAjY8hD8Ua (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jun 2015 16:40:04 -0700 (PDT)
Subject: [PATCH 07/14] xfs: handle directio copy-on-write for reflinked blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Jun 2015 16:39:57 -0700
Message-ID: <20150625233956.4992.14605.stgit@birch.djwong.org>
In-Reply-To: <20150625233909.4992.68314.stgit@birch.djwong.org>
References: <20150625233909.4992.68314.stgit@birch.djwong.org>
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
 fs/xfs/xfs_aops.c    |   17 +++++++++++++++++
 fs/xfs/xfs_file.c    |   12 ++++++++++--
 fs/xfs/xfs_reflink.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |    3 +++
 4 files changed, 75 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index be57e5d..73986ca 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1487,6 +1487,23 @@ __xfs_get_blocks(
 	if (imap.br_startblock != HOLESTARTBLOCK &&
 	    imap.br_startblock != DELAYSTARTBLOCK &&
 	    (create || !ISUNWRITTEN(&imap))) {
+		/*
+		 * Are we doing a DIO write to a reflinked block?  In the
+		 * ideal world we at least would fork full blocks, but for now
+		 * just fall back to buffered mode.  Yuck.  Use -EREMCHG
+		 * ("remote address changed") to signal this, since in general
+		 * XFS doesn't do this sort of fallback.
+		 */
+		if (create && direct && !ISUNWRITTEN(&imap)) {
+			bool type = false;
+
+			error = xfs_reflink_should_fork_block(ip, &imap,
+							      offset, &type);
+			if (error)
+				return error;
+			if (type)
+				return -EREMCHG;
+		}
 		xfs_map_buffer(inode, bh_result, &imap, offset);
 		if (ISUNWRITTEN(&imap))
 			set_buffer_unwritten(bh_result);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 97d92c1..898c492 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -858,10 +858,18 @@ xfs_file_write_iter(
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
index 39b29a4..3f4d9a3 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -634,3 +634,48 @@ xfs_reflink_end_io(
 
 	return error;
 }
+
+/**
+ * xfs_reflink_should_fork_block() - determine if a block should be forked
+ *
+ * @ip: XFS inode object
+ * @imap: the fileoff:fsblock mapping that we might fork
+ * @offset: the file offset of the block we're examining
+ * @type: set to 1 if reflinked, 0 otherwise.
+ */
+int
+xfs_reflink_should_fork_block(
+	struct xfs_inode	*ip,		/* xfs inode object */
+	xfs_bmbt_irec_t		*imap,		/* block mapping */
+	xfs_off_t		offset,		/* file offset */
+	bool			*type)		/* out: is this reflinked? */
+{
+	xfs_fsblock_t		fsbno;
+	xfs_off_t		iomap_offset;
+	xfs_agnumber_t		agno;		/* allocation group number */
+	xfs_agblock_t		agbno;		/* ag start of range to free */
+	xfs_extlen_t		len;
+	xfs_nlink_t		nr;
+	int			error;
+	struct xfs_mount	*mp = ip->i_mount;
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb)) {
+		*type = false;
+		return 0;
+	}
+
+	iomap_offset = XFS_FSB_TO_B(mp, imap->br_startoff);
+	fsbno = imap->br_startblock + XFS_B_TO_FSB(mp, offset - iomap_offset);
+	agno = XFS_FSB_TO_AGNO(mp, fsbno);
+	agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
+	CHECK_AG_NUMBER(mp, agno);
+	CHECK_AG_EXTENT(mp, agbno, 1);
+	ASSERT(imap->br_state == XFS_EXT_NORM);
+
+	error = xfs_reflink_get_refcount(mp, agno, agbno, &len, &nr);
+	if (error)
+		return error;
+	ASSERT(len != 0);
+	*type = (nr > 1);
+	return error;
+}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 40a6576..295a9c7 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -36,4 +36,7 @@ extern int xfs_reflink_fork_block(struct xfs_inode *ip, xfs_bmbt_irec_t *imap,
 extern int xfs_reflink_end_io(struct xfs_mount *mp, struct xfs_inode *ip,
 	xfs_ioend_t *ioend);
 
+extern int xfs_reflink_should_fork_block(struct xfs_inode *ip,
+	xfs_bmbt_irec_t *imap, xfs_off_t offset, bool *type);
+
 #endif /* __XFS_REFLINK_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
