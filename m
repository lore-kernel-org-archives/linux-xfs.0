Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25964 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751324AbdJaTad (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 15:30:33 -0400
Date: Tue, 31 Oct 2017 12:30:26 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: remove inode log format typedef
Message-ID: <20171031193026.GF4911@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove xfs_inode_log_format_t now that xfs_inode_log_format is
explicitly padded and therefore is a real on-disk structure.  This
enables xfs/122 to check the size of the structure.

(No functional changes, this is for benefit of xfsprogs)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_log_format.h |    4 ++--
 fs/xfs/xfs_inode_item.h        |    2 +-
 fs/xfs/xfs_log_recover.c       |   10 +++++-----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index a7ab6ad..996f035 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -264,7 +264,7 @@ typedef struct xfs_trans_header {
  * (if any) is indicated in the ilf_dsize field.  Changes to this structure
  * must be added on to the end.
  */
-typedef struct xfs_inode_log_format {
+struct xfs_inode_log_format {
 	uint16_t		ilf_type;	/* inode log item type */
 	uint16_t		ilf_size;	/* size of this item */
 	uint32_t		ilf_fields;	/* flags for fields logged */
@@ -279,7 +279,7 @@ typedef struct xfs_inode_log_format {
 	int64_t			ilf_blkno;	/* blkno of inode buffer */
 	int32_t			ilf_len;	/* len of inode buffer */
 	int32_t			ilf_boffset;	/* off of inode in buffer */
-} xfs_inode_log_format_t;
+};
 
 /*
  * Old 32 bit systems will log in this format without the 64 bit
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index 4c7722e..b72373a 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -48,7 +48,7 @@ extern void xfs_iflush_done(struct xfs_buf *, struct xfs_log_item *);
 extern void xfs_istale_done(struct xfs_buf *, struct xfs_log_item *);
 extern void xfs_iflush_abort(struct xfs_inode *, bool);
 extern int xfs_inode_item_format_convert(xfs_log_iovec_t *,
-					 xfs_inode_log_format_t *);
+					 struct xfs_inode_log_format *);
 
 extern struct kmem_zone	*xfs_ili_zone;
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index f809dee..6e0e38b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2985,7 +2985,7 @@ xlog_recover_inode_pass2(
 	struct xlog_recover_item	*item,
 	xfs_lsn_t			current_lsn)
 {
-	xfs_inode_log_format_t	*in_f;
+	struct xfs_inode_log_format	*in_f;
 	xfs_mount_t		*mp = log->l_mp;
 	xfs_buf_t		*bp;
 	xfs_dinode_t		*dip;
@@ -2999,10 +2999,10 @@ xlog_recover_inode_pass2(
 	uint			isize;
 	int			need_free = 0;
 
-	if (item->ri_buf[0].i_len == sizeof(xfs_inode_log_format_t)) {
+	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
 		in_f = item->ri_buf[0].i_addr;
 	} else {
-		in_f = kmem_alloc(sizeof(xfs_inode_log_format_t), KM_SLEEP);
+		in_f = kmem_alloc(sizeof(struct xfs_inode_log_format), KM_SLEEP);
 		need_free = 1;
 		error = xfs_inode_item_format_convert(&item->ri_buf[0], in_f);
 		if (error)
@@ -4299,7 +4299,7 @@ xlog_recover_add_to_trans(
 	char			*dp,
 	int			len)
 {
-	xfs_inode_log_format_t	*in_f;			/* any will do */
+	struct xfs_inode_log_format	*in_f;			/* any will do */
 	xlog_recover_item_t	*item;
 	char			*ptr;
 
@@ -4333,7 +4333,7 @@ xlog_recover_add_to_trans(
 
 	ptr = kmem_alloc(len, KM_SLEEP);
 	memcpy(ptr, dp, len);
-	in_f = (xfs_inode_log_format_t *)ptr;
+	in_f = (struct xfs_inode_log_format *)ptr;
 
 	/* take the tail entry */
 	item = list_entry(trans->r_itemq.prev, xlog_recover_item_t, ri_list);
