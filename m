Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:63819 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727151AbeJ3UOA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Oct 2018 16:14:00 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gHS4l-0005bx-1I
        for linux-xfs@vger.kernel.org; Tue, 30 Oct 2018 22:20:47 +1100
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1gHS4k-0001jm-W3
        for linux-xfs@vger.kernel.org; Tue, 30 Oct 2018 22:20:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/7] repair: protect inode chunk tree records with a mutex
Date: Tue, 30 Oct 2018 22:20:42 +1100
Message-Id: <20181030112043.6034-7-david@fromorbit.com>
In-Reply-To: <20181030112043.6034-1-david@fromorbit.com>
References: <20181030112043.6034-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Phase 6 accesses inode chunk records mostly in an isolated manner.
However, when it finds a corruption in a directory or there are
multiple hardlinks to an inode, there can be concurrent access
to the inode chunk record to update state.

Hence the inode record itself needs a mutex. This protects all state
changes within the inode chunk record, as well as inode link counts
and chunk references. That allows us to process multiple chunks at
once, providing concurrency within an AG as well as across AGs.

The inode chunk tree itself is not modified in phase 6 - it's built
in phases 3 and 4  - and so we do not need to worry about locking
for AVL tree lookups to find the inode chunk records themselves.
hence internal locking is all we need here.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/incore.h     | 23 +++++++++++++++++++++++
 repair/incore_ino.c | 15 +++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/repair/incore.h b/repair/incore.h
index 5b29d5d1efd8..6564e0d38963 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -282,6 +282,7 @@ typedef struct ino_tree_node  {
 		parent_list_t	*plist;		/* phases 2-5 */
 	} ino_un;
 	uint8_t			*ftypes;	/* phases 3,6 */
+	pthread_mutex_t		lock;
 } ino_tree_node_t;
 
 #define INOS_PER_IREC	(sizeof(uint64_t) * NBBY)
@@ -412,7 +413,9 @@ next_free_ino_rec(ino_tree_node_t *ino_rec)
  */
 static inline void add_inode_refchecked(struct ino_tree_node *irec, int offset)
 {
+	pthread_mutex_lock(&irec->lock);
 	irec->ino_un.ex_data->ino_processed |= IREC_MASK(offset);
+	pthread_mutex_unlock(&irec->lock);
 }
 
 static inline int is_inode_refchecked(struct ino_tree_node *irec, int offset)
@@ -438,12 +441,16 @@ static inline int is_inode_confirmed(struct ino_tree_node *irec, int offset)
  */
 static inline void set_inode_isadir(struct ino_tree_node *irec, int offset)
 {
+	pthread_mutex_lock(&irec->lock);
 	irec->ino_isa_dir |= IREC_MASK(offset);
+	pthread_mutex_unlock(&irec->lock);
 }
 
 static inline void clear_inode_isadir(struct ino_tree_node *irec, int offset)
 {
+	pthread_mutex_lock(&irec->lock);
 	irec->ino_isa_dir &= ~IREC_MASK(offset);
+	pthread_mutex_unlock(&irec->lock);
 }
 
 static inline int inode_isadir(struct ino_tree_node *irec, int offset)
@@ -456,15 +463,19 @@ static inline int inode_isadir(struct ino_tree_node *irec, int offset)
  */
 static inline void set_inode_free(struct ino_tree_node *irec, int offset)
 {
+	pthread_mutex_lock(&irec->lock);
 	set_inode_confirmed(irec, offset);
 	irec->ir_free |= XFS_INOBT_MASK(offset);
+	pthread_mutex_unlock(&irec->lock);
 
 }
 
 static inline void set_inode_used(struct ino_tree_node *irec, int offset)
 {
+	pthread_mutex_lock(&irec->lock);
 	set_inode_confirmed(irec, offset);
 	irec->ir_free &= ~XFS_INOBT_MASK(offset);
+	pthread_mutex_unlock(&irec->lock);
 }
 
 static inline int is_inode_free(struct ino_tree_node *irec, int offset)
@@ -477,7 +488,9 @@ static inline int is_inode_free(struct ino_tree_node *irec, int offset)
  */
 static inline void set_inode_sparse(struct ino_tree_node *irec, int offset)
 {
+	pthread_mutex_lock(&irec->lock);
 	irec->ir_sparse |= XFS_INOBT_MASK(offset);
+	pthread_mutex_unlock(&irec->lock);
 }
 
 static inline bool is_inode_sparse(struct ino_tree_node *irec, int offset)
@@ -490,12 +503,16 @@ static inline bool is_inode_sparse(struct ino_tree_node *irec, int offset)
  */
 static inline void set_inode_was_rl(struct ino_tree_node *irec, int offset)
 {
+	pthread_mutex_lock(&irec->lock);
 	irec->ino_was_rl |= IREC_MASK(offset);
+	pthread_mutex_unlock(&irec->lock);
 }
 
 static inline void clear_inode_was_rl(struct ino_tree_node *irec, int offset)
 {
+	pthread_mutex_lock(&irec->lock);
 	irec->ino_was_rl &= ~IREC_MASK(offset);
+	pthread_mutex_unlock(&irec->lock);
 }
 
 static inline int inode_was_rl(struct ino_tree_node *irec, int offset)
@@ -508,12 +525,16 @@ static inline int inode_was_rl(struct ino_tree_node *irec, int offset)
  */
 static inline void set_inode_is_rl(struct ino_tree_node *irec, int offset)
 {
+	pthread_mutex_lock(&irec->lock);
 	irec->ino_is_rl |= IREC_MASK(offset);
+	pthread_mutex_unlock(&irec->lock);
 }
 
 static inline void clear_inode_is_rl(struct ino_tree_node *irec, int offset)
 {
+	pthread_mutex_lock(&irec->lock);
 	irec->ino_is_rl &= ~IREC_MASK(offset);
+	pthread_mutex_unlock(&irec->lock);
 }
 
 static inline int inode_is_rl(struct ino_tree_node *irec, int offset)
@@ -546,7 +567,9 @@ static inline int is_inode_reached(struct ino_tree_node *irec, int offset)
 static inline void add_inode_reached(struct ino_tree_node *irec, int offset)
 {
 	add_inode_ref(irec, offset);
+	pthread_mutex_lock(&irec->lock);
 	irec->ino_un.ex_data->ino_reached |= IREC_MASK(offset);
+	pthread_mutex_unlock(&irec->lock);
 }
 
 /*
diff --git a/repair/incore_ino.c b/repair/incore_ino.c
index 82956ae93005..299e4f949e5e 100644
--- a/repair/incore_ino.c
+++ b/repair/incore_ino.c
@@ -91,6 +91,7 @@ void add_inode_ref(struct ino_tree_node *irec, int ino_offset)
 {
 	ASSERT(irec->ino_un.ex_data != NULL);
 
+	pthread_mutex_lock(&irec->lock);
 	switch (irec->nlink_size) {
 	case sizeof(uint8_t):
 		if (irec->ino_un.ex_data->counted_nlinks.un8[ino_offset] < 0xff) {
@@ -112,6 +113,7 @@ void add_inode_ref(struct ino_tree_node *irec, int ino_offset)
 	default:
 		ASSERT(0);
 	}
+	pthread_mutex_unlock(&irec->lock);
 }
 
 void drop_inode_ref(struct ino_tree_node *irec, int ino_offset)
@@ -120,6 +122,7 @@ void drop_inode_ref(struct ino_tree_node *irec, int ino_offset)
 
 	ASSERT(irec->ino_un.ex_data != NULL);
 
+	pthread_mutex_lock(&irec->lock);
 	switch (irec->nlink_size) {
 	case sizeof(uint8_t):
 		ASSERT(irec->ino_un.ex_data->counted_nlinks.un8[ino_offset] > 0);
@@ -139,6 +142,7 @@ void drop_inode_ref(struct ino_tree_node *irec, int ino_offset)
 
 	if (refs == 0)
 		irec->ino_un.ex_data->ino_reached &= ~IREC_MASK(ino_offset);
+	pthread_mutex_unlock(&irec->lock);
 }
 
 uint32_t num_inode_references(struct ino_tree_node *irec, int ino_offset)
@@ -161,6 +165,7 @@ uint32_t num_inode_references(struct ino_tree_node *irec, int ino_offset)
 void set_inode_disk_nlinks(struct ino_tree_node *irec, int ino_offset,
 		uint32_t nlinks)
 {
+	pthread_mutex_lock(&irec->lock);
 	switch (irec->nlink_size) {
 	case sizeof(uint8_t):
 		if (nlinks < 0xff) {
@@ -182,6 +187,7 @@ void set_inode_disk_nlinks(struct ino_tree_node *irec, int ino_offset,
 	default:
 		ASSERT(0);
 	}
+	pthread_mutex_unlock(&irec->lock);
 }
 
 uint32_t get_inode_disk_nlinks(struct ino_tree_node *irec, int ino_offset)
@@ -253,6 +259,7 @@ alloc_ino_node(
 	irec->nlink_size = sizeof(uint8_t);
 	irec->disk_nlinks.un8 = alloc_nlink_array(irec->nlink_size);
 	irec->ftypes = alloc_ftypes_array(mp);
+	pthread_mutex_init(&irec->lock, NULL);
 	return irec;
 }
 
@@ -294,6 +301,7 @@ free_ino_tree_node(
 	}
 
 	free(irec->ftypes);
+	pthread_mutex_destroy(&irec->lock);
 	free(irec);
 }
 
@@ -600,6 +608,7 @@ set_inode_parent(
 	uint64_t		bitmask;
 	parent_entry_t		*tmp;
 
+	pthread_mutex_lock(&irec->lock);
 	if (full_ino_ex_data)
 		ptbl = irec->ino_un.ex_data->parents;
 	else
@@ -625,6 +634,7 @@ set_inode_parent(
 #endif
 		ptbl->pentries[0] = parent;
 
+		pthread_mutex_unlock(&irec->lock);
 		return;
 	}
 
@@ -642,6 +652,7 @@ set_inode_parent(
 #endif
 		ptbl->pentries[target] = parent;
 
+		pthread_mutex_unlock(&irec->lock);
 		return;
 	}
 
@@ -682,6 +693,7 @@ set_inode_parent(
 #endif
 	ptbl->pentries[target] = parent;
 	ptbl->pmask |= (1ULL << offset);
+	pthread_mutex_unlock(&irec->lock);
 }
 
 xfs_ino_t
@@ -692,6 +704,7 @@ get_inode_parent(ino_tree_node_t *irec, int offset)
 	int		i;
 	int		target;
 
+	pthread_mutex_lock(&irec->lock);
 	if (full_ino_ex_data)
 		ptbl = irec->ino_un.ex_data->parents;
 	else
@@ -709,9 +722,11 @@ get_inode_parent(ino_tree_node_t *irec, int offset)
 #ifdef DEBUG
 		ASSERT(target < ptbl->cnt);
 #endif
+		pthread_mutex_unlock(&irec->lock);
 		return(ptbl->pentries[target]);
 	}
 
+	pthread_mutex_unlock(&irec->lock);
 	return(0LL);
 }
 
-- 
2.19.1
