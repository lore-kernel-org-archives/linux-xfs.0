Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48110 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727652AbeJELAN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Oct 2018 07:00:13 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 13/15] libxfs: export unused nonstatic functions to quiet static checkers
Date: Thu,  4 Oct 2018 23:03:14 -0500
Message-Id: <1538712196-13625-14-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
References: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

libxfs functions which aren't used or exported get flagged as
"should be static" but we stay in sync with kernelspace, which has other
headers which export them.  Export the lot of them in libxfs_priv.h to
shut up sparse.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 libxfs/libxfs_priv.h | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index b4bdc64..b29e887 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -606,5 +606,59 @@ static inline int test_bit(int nr, const volatile unsigned long *addr)
 	return *p & mask;
 }
 
+/* Keep static checkers quiet about nonstatic functions by exporting */
+int xfs_inode_hasattr(struct xfs_inode *ip);
+int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
+int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
+                unsigned char *value, int *valuelenp, int flags);
+int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
+                 unsigned char *value, int valuelen, int flags);
+int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
+
+int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
+		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
+int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp,
+		      xfs_rtblock_t start, xfs_extlen_t len, int val,
+		      xfs_rtblock_t *new, int *stat);
+int xfs_rtfind_back(struct xfs_mount *mp, struct xfs_trans *tp,
+		    xfs_rtblock_t start, xfs_rtblock_t limit,
+		    xfs_rtblock_t *rtblock);
+int xfs_rtfind_forw(struct xfs_mount *mp, struct xfs_trans *tp,
+		    xfs_rtblock_t start, xfs_rtblock_t limit,
+		    xfs_rtblock_t *rtblock);
+int xfs_rtmodify_range(struct xfs_mount *mp, struct xfs_trans *tp,
+		       xfs_rtblock_t start, xfs_extlen_t len, int val);
+int xfs_rtmodify_summary_int(struct xfs_mount *mp, struct xfs_trans *tp,
+			     int log, xfs_rtblock_t bbno, int delta,
+			     xfs_buf_t **rbpp, xfs_fsblock_t *rsb,
+			     xfs_suminfo_t *sum);
+int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
+			 xfs_rtblock_t bbno, int delta, xfs_buf_t **rbpp,
+			 xfs_fsblock_t *rsb);
+int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
+		     xfs_rtblock_t start, xfs_extlen_t len,
+		     struct xfs_buf **rbpp, xfs_fsblock_t *rsb);
+int xfs_rtalloc_query_range(struct xfs_trans *tp,
+			    struct xfs_rtalloc_rec *low_rec,
+			    struct xfs_rtalloc_rec *high_rec,
+			    xfs_rtalloc_query_range_fn fn,
+			    void *priv);
+int xfs_rtalloc_query_all(struct xfs_trans *tp,
+			  xfs_rtalloc_query_range_fn fn,
+			  void *priv);
+bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
+int xfs_rtalloc_extent_is_free(struct xfs_mount *mp, struct xfs_trans *tp,
+			       xfs_rtblock_t start, xfs_extlen_t len,
+			       bool *is_free);
+/* xfs_bmap_util.h */
+struct xfs_bmalloca;
+int xfs_bmap_extsize_align(struct xfs_mount *mp, struct xfs_bmbt_irec *gotp,
+			   struct xfs_bmbt_irec *prevp, xfs_extlen_t extsz,
+			   int rt, int eof, int delay, int convert,
+			   xfs_fileoff_t *offp, xfs_extlen_t *lenp);
+void xfs_bmap_adjacent(struct xfs_bmalloca *ap);
+int xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
+			 int whichfork, struct xfs_bmbt_irec *rec,
+			 int *is_empty);
 
 #endif	/* __LIBXFS_INTERNAL_XFS_H__ */
-- 
1.8.3.1
