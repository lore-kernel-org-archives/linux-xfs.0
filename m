Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1FA8D7FA5
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2015 05:57:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2D8C6AC002
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2015 03:57:34 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id FQdCTOF7bBZT9e1l (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 17 Jun 2015 03:57:32 -0700 (PDT)
Received: from [88.128.80.44] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z5B2B-0003YT-75
	for xfs@oss.sgi.com; Wed, 17 Jun 2015 10:57:31 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/5] xfs: return a void pointer from xfs_buf_offset
Date: Wed, 17 Jun 2015 12:55:30 +0200
Message-Id: <1434538532-6566-4-git-send-email-hch@lst.de>
In-Reply-To: <1434538532-6566-1-git-send-email-hch@lst.de>
References: <1434538532-6566-1-git-send-email-hch@lst.de>
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

This avoids all kinds of unessecary casts in an envrionment like Linux where
we can assume that pointer arithmetics are support on void pointers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ialloc.h    | 3 +--
 fs/xfs/libxfs/xfs_inode_buf.c | 8 +++-----
 fs/xfs/xfs_buf.c              | 6 +++---
 fs/xfs/xfs_buf.h              | 2 +-
 fs/xfs/xfs_inode.c            | 2 +-
 fs/xfs/xfs_log_recover.c      | 9 ++++-----
 6 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 12401fe..6e450df 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -51,8 +51,7 @@ xfs_icluster_size_fsb(
 static inline struct xfs_dinode *
 xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
 {
-	return (struct xfs_dinode *)
-		(xfs_buf_offset(b, o << (mp)->m_sb.sb_inodelog));
+	return xfs_buf_offset(b, o << (mp)->m_sb.sb_inodelog);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 002b6b3..6526e76 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -46,8 +46,7 @@ xfs_inobp_check(
 	j = mp->m_inode_cluster_size >> mp->m_sb.sb_inodelog;
 
 	for (i = 0; i < j; i++) {
-		dip = (xfs_dinode_t *)xfs_buf_offset(bp,
-					i * mp->m_sb.sb_inodesize);
+		dip = xfs_buf_offset(bp, i * mp->m_sb.sb_inodesize);
 		if (!dip->di_next_unlinked)  {
 			xfs_alert(mp,
 	"Detected bogus zero next_unlinked field in inode %d buffer 0x%llx.",
@@ -86,8 +85,7 @@ xfs_inode_buf_verify(
 		int		di_ok;
 		xfs_dinode_t	*dip;
 
-		dip = (struct xfs_dinode *)xfs_buf_offset(bp,
-					(i << mp->m_sb.sb_inodelog));
+		dip = xfs_buf_offset(bp, (i << mp->m_sb.sb_inodelog));
 		di_ok = dip->di_magic == cpu_to_be16(XFS_DINODE_MAGIC) &&
 			    XFS_DINODE_GOOD_VERSION(dip->di_version);
 		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
@@ -186,7 +184,7 @@ xfs_imap_to_bp(
 	}
 
 	*bpp = bp;
-	*dipp = (struct xfs_dinode *)xfs_buf_offset(bp, imap->im_boffset);
+	*dipp = xfs_buf_offset(bp, imap->im_boffset);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 1790b00..a4b7d92 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1419,9 +1419,9 @@ xfs_buf_submit_wait(
 	return error;
 }
 
-xfs_caddr_t
+void *
 xfs_buf_offset(
-	xfs_buf_t		*bp,
+	struct xfs_buf		*bp,
 	size_t			offset)
 {
 	struct page		*page;
@@ -1431,7 +1431,7 @@ xfs_buf_offset(
 
 	offset += bp->b_offset;
 	page = bp->b_pages[offset >> PAGE_SHIFT];
-	return (xfs_caddr_t)page_address(page) + (offset & (PAGE_SIZE-1));
+	return page_address(page) + (offset & (PAGE_SIZE-1));
 }
 
 /*
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 75ff5d5..331c1cc 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -299,7 +299,7 @@ extern void xfs_buf_iomove(xfs_buf_t *, size_t, size_t, void *,
 	    xfs_buf_iomove((bp), (off), (len), NULL, XBRW_ZERO)
 
 /* Buffer Utility Routines */
-extern xfs_caddr_t xfs_buf_offset(xfs_buf_t *, size_t);
+extern void *xfs_buf_offset(struct xfs_buf *, size_t);
 
 /* Delayed Write Buffer Routines */
 extern bool xfs_buf_delwri_queue(struct xfs_buf *, struct list_head *);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a37a101..3da9f4d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3392,7 +3392,7 @@ xfs_iflush_int(
 	ASSERT(ip->i_d.di_version > 1);
 
 	/* set *dip = inode's place in the buffer */
-	dip = (xfs_dinode_t *)xfs_buf_offset(bp, ip->i_imap.im_boffset);
+	dip = xfs_buf_offset(bp, ip->i_imap.im_boffset);
 
 	if (XFS_TEST_ERROR(dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC),
 			       mp, XFS_ERRTAG_IFLUSH_1, XFS_RANDOM_IFLUSH_1)) {
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 299fbaf..214fd38 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1789,8 +1789,7 @@ xlog_recover_do_inode_buffer(
 			return -EFSCORRUPTED;
 		}
 
-		buffer_nextp = (xfs_agino_t *)xfs_buf_offset(bp,
-					      next_unlinked_offset);
+		buffer_nextp = xfs_buf_offset(bp, next_unlinked_offset);
 		*buffer_nextp = *logged_nextp;
 
 		/*
@@ -1798,7 +1797,7 @@ xlog_recover_do_inode_buffer(
 		 * have to leave the inode in a consistent state for whoever
 		 * reads it next....
 		 */
-		xfs_dinode_calc_crc(mp, (struct xfs_dinode *)
+		xfs_dinode_calc_crc(mp,
 				xfs_buf_offset(bp, i * mp->m_sb.sb_inodesize));
 
 	}
@@ -2546,7 +2545,7 @@ xlog_recover_inode_pass2(
 		goto out_release;
 	}
 	ASSERT(in_f->ilf_fields & XFS_ILOG_CORE);
-	dip = (xfs_dinode_t *)xfs_buf_offset(bp, in_f->ilf_boffset);
+	dip = xfs_buf_offset(bp, in_f->ilf_boffset);
 
 	/*
 	 * Make sure the place we're flushing out to really looks
@@ -2885,7 +2884,7 @@ xlog_recover_dquot_pass2(
 		return error;
 
 	ASSERT(bp);
-	ddq = (xfs_disk_dquot_t *)xfs_buf_offset(bp, dq_f->qlf_boffset);
+	ddq = xfs_buf_offset(bp, dq_f->qlf_boffset);
 
 	/*
 	 * If the dquot has an LSN in it, recover the dquot only if it's less
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
