Return-Path: <SRS0=ETTY=XW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D6A6C4360C
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Sep 2019 22:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7FFB21841
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Sep 2019 22:08:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbfI0WIv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Sep 2019 18:08:51 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:41349 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726033AbfI0WIu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Sep 2019 18:08:50 -0400
Received: from dread.disaster.area (pa49-181-226-196.pa.nsw.optusnet.com.au [49.181.226.196])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A0C9643E06A;
        Sat, 28 Sep 2019 08:08:46 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1iDyPt-0007YE-Le; Sat, 28 Sep 2019 08:08:45 +1000
Date:   Sat, 28 Sep 2019 08:08:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_db: calculate iext tree geometry in btheight
 command
Message-ID: <20190927220845.GL16973@dread.disaster.area>
References: <156944764785.303060.15428657522073378525.stgit@magnolia>
 <156944765991.303060.7541074919992777157.stgit@magnolia>
 <20190926214102.GK16973@dread.disaster.area>
 <20190927025857.GK9916@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190927025857.GK9916@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=dRuLqZ1tmBNts2YiI0zFQg==:117 a=dRuLqZ1tmBNts2YiI0zFQg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=20KFwNOVAAAA:8 a=pLdgXEZ1cQHZbG_sddIA:9
        a=YZMpoqTBintSDyxs:21 a=rFv0RdFGnXp3U0_4:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 26, 2019 at 07:58:57PM -0700, Darrick J. Wong wrote:
> On Fri, Sep 27, 2019 at 07:41:02AM +1000, Dave Chinner wrote:
> > On Wed, Sep 25, 2019 at 02:40:59PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > (Ab)use the btheight command to calculate the geometry of the incore
> > > extent tree.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  db/btheight.c |   87 +++++++++++++++++++++++++++++++++++++++------------------
> > >  1 file changed, 60 insertions(+), 27 deletions(-)
> > > 
> > > 
> > > diff --git a/db/btheight.c b/db/btheight.c
> > > index e2c9759f..be604ebc 100644
> > > --- a/db/btheight.c
> > > +++ b/db/btheight.c
> > > @@ -22,18 +22,37 @@ static int rmap_maxrecs(struct xfs_mount *mp, int blocklen, int leaf)
> > >  	return libxfs_rmapbt_maxrecs(blocklen, leaf);
> > >  }
> > >  
> > > +static int iext_maxrecs(struct xfs_mount *mp, int blocklen, int leaf)
> > > +{
> > > +	blocklen -= 2 * sizeof(void *);
> > > +
> > > +	return blocklen / sizeof(struct xfs_bmbt_rec);
> > > +}
> > 
> > This isn't correct for the iext nodes. They hold 16 key/ptr pairs,
> > not 15.
> > 
> > I suspect you should be lifting the iext btree format definitions
> > like this one:
> > 
> > enum {                                                                           
> >         NODE_SIZE       = 256,                                                   
> >         KEYS_PER_NODE   = NODE_SIZE / (sizeof(uint64_t) + sizeof(void *)),       
> >         RECS_PER_LEAF   = (NODE_SIZE - (2 * sizeof(struct xfs_iext_leaf *))) /   
> >                                 sizeof(struct xfs_iext_rec),                     
> > };                                                                               
> > 
> > from libxfs/xfs_iext_tree.c to a libxfs header file and then using
> > KEYS_PER_NODE and RECS_PER_LEAF here. See the patch below, lifted
> > from a varaint of my range locking prototypes...
> > 
> > However, these are not on-disk values and so are subject to change,
> > hence it may be that a warning might be needed when xfs_db is used
> > to calculate the height of this tree.
> 
> Er... I don't mind lifting the iext values, but I don't see a patch?

Ah, sorry, I realised it wouldn't apply at all - there's several
precursor patches that move stuff about (reworking the xfs_ifork
structure) and it didn't lift the enum (but could have) and so I
didn't attach it.  Of course, I then forgot to edit email... I'll
attach it anyway...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


xfs: move iext tree interfaces to separate header file

From: Dave Chinner <dchinner@redhat.com>

The iext tree is sufficiently separated from the inode fork now
that it really needs it's own header file. This will make it easier
to add new functionality that uses the tree without needing to be
intermingled with the existing inode header files.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.h       |  1 +
 fs/xfs/libxfs/xfs_iext_tree.c  | 64 ++++++++++++++-------------------------
 fs/xfs/libxfs/xfs_iext_tree.h  | 69 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_fork.h | 22 --------------
 fs/xfs/libxfs/xfs_types.h      | 16 ----------
 fs/xfs/xfs_inode.h             |  1 +
 fs/xfs/xfs_trace.h             |  1 +
 7 files changed, 94 insertions(+), 80 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 302a6079a038..3989ecca4b78 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -13,6 +13,7 @@ struct xfs_inode;
 struct xfs_mount;
 struct xfs_trans;
 struct xfs_btree_cur;
+struct xfs_iext_cursor;
 
 extern kmem_zone_t	*xfs_bmap_free_item_zone;
 
diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index eeddb0a1e194..5b60b92b50ef 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -17,48 +17,6 @@
 #include "xfs_bmap.h"
 #include "xfs_trace.h"
 
-/*
- * Extent tree offset/length record layout:
- *
- * +-------+----------------------------+
- * | 00:53 | all 54 bits of startoff	|
- * | 54:63 | User defined		|
- * +-------+----------------------------+
- * | 00:20 | all 21 bits of length      |
- * | 21:63 | User defined		|
- * +-------+----------------------------+
- *
- * This is derived from the on-disk packing for BMBT records, so the inode
- * extent tree can be efficiently dumped into the in-core extent tree. All users
- * of this tree must use this same offset/length layout as it is used for
- * lookups into the tree. Users can use whatever units they want for offset/len
- * as long as they fit within the sizes noted above.
- */
-#define XFS_IEXT_STARTOFF_MASK		xfs_mask64lo(BMBT_STARTOFF_BITLEN)
-#define XFS_IEXT_LENGTH_MASK		xfs_mask64lo(BMBT_BLOCKCOUNT_BITLEN)
-
-/*
- * Given that the length can't be a zero, only an empty hi value indicates an
- * unused record.
- */
-static bool xfs_iext_rec_is_empty(struct xfs_iext_rec *rec)
-{
-	return rec->hi == 0;
-}
-
-static inline void xfs_iext_rec_clear(struct xfs_iext_rec *rec)
-{
-	rec->lo = 0;
-	rec->hi = 0;
-}
-
-enum {
-	NODE_SIZE	= 256,
-	KEYS_PER_NODE	= NODE_SIZE / (sizeof(uint64_t) + sizeof(void *)),
-	RECS_PER_LEAF	= (NODE_SIZE - (2 * sizeof(struct xfs_iext_leaf *))) /
-				sizeof(struct xfs_iext_rec),
-};
-
 /*
  * In-core extent btree block layout:
  *
@@ -80,6 +38,13 @@ enum {
  * Inner:	| key 1 | key 2 | key 3 | key N | ptr 1 | ptr 2 | ptr3 | ptr N |
  *		+-------+-------+-------+-------+-------+-------+------+-------+
  */
+enum {
+	NODE_SIZE	= 256,
+	KEYS_PER_NODE	= NODE_SIZE / (sizeof(uint64_t) + sizeof(void *)),
+	RECS_PER_LEAF	= (NODE_SIZE - (2 * sizeof(struct xfs_iext_leaf *))) /
+				sizeof(struct xfs_iext_rec),
+};
+
 struct xfs_iext_node {
 	uint64_t		keys[KEYS_PER_NODE];
 #define XFS_IEXT_KEY_INVALID	(1ULL << 63)
@@ -92,6 +57,21 @@ struct xfs_iext_leaf {
 	struct xfs_iext_leaf	*next;
 };
 
+/*
+ * Given that the length can't be a zero, only an empty hi value indicates an
+ * unused record.
+ */
+static bool xfs_iext_rec_is_empty(struct xfs_iext_rec *rec)
+{
+	return rec->hi == 0;
+}
+
+static inline void xfs_iext_rec_clear(struct xfs_iext_rec *rec)
+{
+	rec->lo = 0;
+	rec->hi = 0;
+}
+
 static inline int xfs_iext_max_recs(struct xfs_iext_tree *tree)
 {
 	if (tree->height == 1)
diff --git a/fs/xfs/libxfs/xfs_iext_tree.h b/fs/xfs/libxfs/xfs_iext_tree.h
new file mode 100644
index 000000000000..c1756be83f09
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_iext_tree.h
@@ -0,0 +1,69 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2017 Christoph Hellwig.
+ * Copyright (c) 2019 Red Hat, Inc.
+ * All Rights Reserved.
+ */
+
+#ifndef __XFS_IEXT_TREE_H__
+#define	__XFS_IEXT_TREE_H__
+
+struct xfs_iext_leaf;
+
+/*
+ * Extent tree offset/length record layout:
+ *
+ * +-------+----------------------------+
+ * | 00:53 | all 54 bits of startoff	|
+ * | 54:63 | User defined		|
+ * +-------+----------------------------+
+ * | 00:20 | all 21 bits of length      |
+ * | 21:63 | User defined		|
+ * +-------+----------------------------+
+ *
+ * This is derived from the on-disk packing for BMBT records, so the inode
+ * extent tree can be efficiently dumped into the in-core extent tree. All users
+ * of this tree must use this same offset/length layout as it is used for
+ * lookups into the tree. Users can use whatever units they want for offset/len
+ * as long as they fit within the sizes noted above.
+ */
+#define XFS_IEXT_STARTOFF_MASK		xfs_mask64lo(BMBT_STARTOFF_BITLEN)
+#define XFS_IEXT_LENGTH_MASK		xfs_mask64lo(BMBT_BLOCKCOUNT_BITLEN)
+
+struct xfs_iext_rec {
+	uint64_t			lo;
+	uint64_t			hi;
+};
+
+struct xfs_iext_tree {
+	void	*root;		/* tree root block */
+	int	height;		/* tree height */
+	int	root_recs;	/* root block size when height = 1 */
+};
+
+
+struct xfs_iext_cursor {
+	struct xfs_iext_leaf	*leaf;
+	int			pos;
+};
+
+struct xfs_iext_rec *xfs_iext_cur_rec(struct xfs_iext_cursor *cur);
+void	xfs_iext_first_rec(struct xfs_iext_tree *tree,
+				struct xfs_iext_cursor *cur);
+void	xfs_iext_last_rec(struct xfs_iext_tree *tree,
+				struct xfs_iext_cursor *cur);
+void	xfs_iext_next_rec(struct xfs_iext_tree *tree,
+				struct xfs_iext_cursor *cur);
+void	xfs_iext_prev_rec(struct xfs_iext_tree *tree,
+				struct xfs_iext_cursor *cur);
+
+typedef void (*irec_fmt_f)(struct xfs_iext_rec *rec, void *irec);
+void	xfs_iext_insert_rec(struct xfs_iext_tree *tree,
+				struct xfs_iext_cursor *cur, uint64_t offset,
+				irec_fmt_f format_f, void *irec);
+void	xfs_iext_remove_rec(struct xfs_iext_tree *tree,
+				struct xfs_iext_cursor *cur);
+bool	xfs_iext_lookup_rec(struct xfs_iext_tree *tree,
+				struct xfs_iext_cursor *cur, uint64_t offset);
+
+#endif	/* __XFS_IEXT_TREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 0e81a9234b99..c1910c116e48 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -127,28 +127,6 @@ void		xfs_iext_update_extent(struct xfs_inode *ip, int state,
 			struct xfs_iext_cursor *cur,
 			struct xfs_bmbt_irec *gotp);
 
-void	xfs_iext_first_rec(struct xfs_iext_tree *tree,
-				struct xfs_iext_cursor *cur);
-void	xfs_iext_last_rec(struct xfs_iext_tree *tree,
-				struct xfs_iext_cursor *cur);
-void	xfs_iext_next_rec(struct xfs_iext_tree *tree,
-				struct xfs_iext_cursor *cur);
-void	xfs_iext_prev_rec(struct xfs_iext_tree *tree,
-				struct xfs_iext_cursor *cur);
-
-struct xfs_iext_rec *xfs_iext_cur_rec(struct xfs_iext_cursor *cur);
-
-struct xfs_iext_rec;
-typedef void (*irec_fmt_f)(struct xfs_iext_rec *rec, void *irec);
-
-void	xfs_iext_insert_rec(struct xfs_iext_tree *tree,
-				struct xfs_iext_cursor *cur, uint64_t offset,
-				irec_fmt_f format_f, void *irec);
-void	xfs_iext_remove_rec(struct xfs_iext_tree *tree,
-				struct xfs_iext_cursor *cur);
-bool	xfs_iext_lookup_rec(struct xfs_iext_tree *tree,
-				struct xfs_iext_cursor *cur, uint64_t offset);
-
 static inline void
 xfs_iext_first(struct xfs_ifork *ifp, struct xfs_iext_cursor *cur)
 {
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index c0d6d8ab63fe..dac3b0a35d08 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -152,22 +152,6 @@ typedef uint32_t	xfs_dqid_t;
 #define	XFS_NBWORD	(1 << XFS_NBWORDLOG)
 #define	XFS_WORDMASK	((1 << XFS_WORDLOG) - 1)
 
-struct xfs_iext_tree {
-	void	*root;		/* tree root block */
-	int	height;		/* tree height */
-	int	root_recs;	/* root block size when height = 1 */
-};
-
-struct xfs_iext_cursor {
-	struct xfs_iext_leaf	*leaf;
-	int			pos;
-};
-
-struct xfs_iext_rec {
-	uint64_t		lo;
-	uint64_t		hi;
-};
-
 typedef enum {
 	XFS_EXT_NORM, XFS_EXT_UNWRITTEN,
 } xfs_exntst_t;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index e62074a5257c..967c73e8292b 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -6,6 +6,7 @@
 #ifndef	__XFS_INODE_H__
 #define	__XFS_INODE_H__
 
+#include "xfs_iext_tree.h"
 #include "xfs_inode_buf.h"
 #include "xfs_inode_fork.h"
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 47fb07d86efd..3a03e289fbe0 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -30,6 +30,7 @@ struct xfs_btree_cur;
 struct xfs_refcount_irec;
 struct xfs_fsmap;
 struct xfs_rmap_irec;
+struct xfs_iext_cursor;
 
 DECLARE_EVENT_CLASS(xfs_attr_list_class,
 	TP_PROTO(struct xfs_attr_list_context *ctx),
