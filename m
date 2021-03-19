Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FF9DC433E6
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 01:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 563FD64E81
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 01:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhCSBeV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 21:34:21 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:34580 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230049AbhCSBeD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Mar 2021 21:34:03 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 23F9A1AE2DE;
        Fri, 19 Mar 2021 12:34:02 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lN41U-0048oC-2i; Fri, 19 Mar 2021 12:33:56 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lN41T-003Ft9-RO; Fri, 19 Mar 2021 12:33:55 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     hsiangkao@redhat.com
Subject: [PATCH 3/7] repair: protect inode chunk tree records with a mutex
Date:   Fri, 19 Mar 2021 12:33:51 +1100
Message-Id: <20210319013355.776008-4-david@fromorbit.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210319013355.776008-1-david@fromorbit.com>
References: <20210319013355.776008-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=UqzBNiQEfBF_k0VGQjQA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Phase 6 accesses inode chunk records mostly in an isolated manner.
However, when it finds a corruption in a directory or there are
multiple hardlinks to an inode, there can be concurrent access
to the inode chunk record to update state.

Hence the inode record itself needs a mutex. This protects all state
changes within the inode chunk record, as well as inode link counts
and chunk references. That allows us to process multiple chunks at
once, providing concurrency within an AG as well as across AGs.

The inode chunk tree itself is not modified in the directory
scanning and rebuilding part of phase 6 which we are making
concurrent, hence we do not need to worry about locking for AVL tree
lookups to find the inode chunk records themselves. Therefore
internal locking is all we need here.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/incore.h     | 23 +++++++++++++++++++++++
 repair/incore_ino.c | 15 +++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/repair/incore.h b/repair/incore.h
index 977e5dd04336..d64315fd2585 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -281,6 +281,7 @@ typedef struct ino_tree_node  {
 		parent_list_t	*plist;		/* phases 2-5 */
 	} ino_un;
 	uint8_t			*ftypes;	/* phases 3,6 */
+	pthread_mutex_t		lock;
 } ino_tree_node_t;
 
 #define INOS_PER_IREC	(sizeof(uint64_t) * NBBY)
@@ -411,7 +412,9 @@ next_free_ino_rec(ino_tree_node_t *ino_rec)
  */
 static inline void add_inode_refchecked(struct ino_tree_node *irec, int offset)
 {
+	pthread_mutex_lock(&irec->lock);
 	irec->ino_un.ex_data->ino_processed |= IREC_MASK(offset);
+	pthread_mutex_unlock(&irec->lock);
 }
 
 static inline int is_inode_refchecked(struct ino_tree_node *irec, int offset)
@@ -437,12 +440,16 @@ static inline int is_inode_confirmed(struct ino_tree_node *irec, int offset)
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
@@ -455,15 +462,19 @@ static inline int inode_isadir(struct ino_tree_node *irec, int offset)
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
@@ -476,7 +487,9 @@ static inline int is_inode_free(struct ino_tree_node *irec, int offset)
  */
 static inline void set_inode_sparse(struct ino_tree_node *irec, int offset)
 {
+	pthread_mutex_lock(&irec->lock);
 	irec->ir_sparse |= XFS_INOBT_MASK(offset);
+	pthread_mutex_unlock(&irec->lock);
 }
 
 static inline bool is_inode_sparse(struct ino_tree_node *irec, int offset)
@@ -489,12 +502,16 @@ static inline bool is_inode_sparse(struct ino_tree_node *irec, int offset)
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
@@ -507,12 +524,16 @@ static inline int inode_was_rl(struct ino_tree_node *irec, int offset)
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
@@ -545,7 +566,9 @@ static inline int is_inode_reached(struct ino_tree_node *irec, int offset)
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
2.30.1

