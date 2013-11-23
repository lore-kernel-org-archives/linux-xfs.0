Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 27D7A7F63
	for <xfs@oss.sgi.com>; Sat, 23 Nov 2013 09:15:39 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E1378304051
	for <xfs@oss.sgi.com>; Sat, 23 Nov 2013 07:15:38 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id hmEYsUWGSalyWtoj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 23 Nov 2013 07:15:34 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VkEvm-0001Rl-HS
	for xfs@oss.sgi.com; Sat, 23 Nov 2013 15:15:34 +0000
Message-Id: <20131123151534.470066699@bombadil.infradead.org>
Date: Sat, 23 Nov 2013 07:11:58 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 7/7] xfs: remove opencoded versions of xfs_bmap_cancel
References: <20131123151151.716201348@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0007-xfs-remove-opencoded-versions-of-xfs_bmap_cancel.patch
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

And fold the now otherwise unused xfs_bmap_del_free into xfs_bmap_cancel.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap.c        |   33 +++++++++------------------------
 fs/xfs/xfs_bmap_util.c   |    6 +-----
 fs/xfs/xfs_bmap_util.h   |    3 ---
 fs/xfs/xfs_log_recover.c |    8 ++------
 4 files changed, 12 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 66bf92a..3a5383f 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -646,39 +646,24 @@ xfs_bmap_add_free(
 }
 
 /*
- * Remove the entry "free" from the free item list.  Prev points to the
- * previous entry, unless "free" is the head of the list.
- */
-void
-xfs_bmap_del_free(
-	xfs_bmap_free_t		*flist,	/* free item list header */
-	xfs_bmap_free_item_t	*prev,	/* previous item on list, if any */
-	xfs_bmap_free_item_t	*free)	/* list item to be freed */
-{
-	if (prev)
-		prev->xbfi_next = free->xbfi_next;
-	else
-		flist->xbf_first = free->xbfi_next;
-	flist->xbf_count--;
-	kmem_zone_free(xfs_bmap_free_item_zone, free);
-}
-
-/*
  * Free up any items left in the list.
  */
 void
 xfs_bmap_cancel(
-	xfs_bmap_free_t		*flist)	/* list of bmap_free_items */
+	struct xfs_bmap_free	*flist)
 {
-	xfs_bmap_free_item_t	*free;	/* free list item */
-	xfs_bmap_free_item_t	*next;
+	struct xfs_bmap_free_item *free;
 
 	if (flist->xbf_count == 0)
 		return;
+
 	ASSERT(flist->xbf_first != NULL);
-	for (free = flist->xbf_first; free; free = next) {
-		next = free->xbfi_next;
-		xfs_bmap_del_free(flist, NULL, free);
+	while ((free = flist->xbf_first)) {
+		flist->xbf_first = free->xbfi_next;
+		flist->xbf_count--;
+
+		kmem_zone_free(xfs_bmap_free_item_zone, free);
+
 	}
 	ASSERT(flist->xbf_count == 0);
 }
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index d90ce2c..268dbcf 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -139,11 +139,7 @@ xfs_bmap_finish(
 	}
 
 	efd = xfs_trans_log_efd(ntp, efi, flist);
-
-	for (free = flist->xbf_first; free != NULL; free = next) {
-		next = free->xbfi_next;
-		xfs_bmap_del_free(flist, NULL, free);
-	}
+	xfs_bmap_cancel(flist);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 900747b..54f81f8 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -80,9 +80,6 @@ int	xfs_getbmap(struct xfs_inode *ip, struct getbmapx *bmv,
 		xfs_bmap_format_t formatter, void *arg);
 
 /* functions in xfs_bmap.c that are only needed by xfs_bmap_util.c */
-void	xfs_bmap_del_free(struct xfs_bmap_free *flist,
-			  struct xfs_bmap_free_item *prev,
-			  struct xfs_bmap_free_item *free);
 int	xfs_bmap_extsize_align(struct xfs_mount *mp, struct xfs_bmbt_irec *gotp,
 			       struct xfs_bmbt_irec *prevp, xfs_extlen_t extsz,
 			       int rt, int eof, int delay, int convert,
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index b679a0b..e4b2de0 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3617,7 +3617,7 @@ xlog_recover_process_efi(
 {
 	struct xfs_trans	*tp;
 	struct xfs_efd_log_item *efdp;
-	struct xfs_bmap_free_item *free, *next;
+	struct xfs_bmap_free_item *free;
 	xfs_fsblock_t		startblock_fsb;
 	int			error = 0;
 
@@ -3659,11 +3659,7 @@ xlog_recover_process_efi(
 	}
 
 	efdp = xfs_trans_log_efd(tp, efip, &efip->efi_flist);
-
-	for (free = efip->efi_flist.xbf_first; free != NULL; free = next) {
-		next = free->xbfi_next;
-		xfs_bmap_del_free(&efip->efi_flist, NULL, free);
-	}
+	xfs_bmap_cancel(&efip->efi_flist);
 
 	set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
 	error = xfs_trans_commit(tp, 0);
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
