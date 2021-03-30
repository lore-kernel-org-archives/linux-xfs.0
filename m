Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EF82C433C1
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 14:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AE7F619C8
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 14:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbhC3O0U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 10:26:20 -0400
Received: from sonic312-23.consmr.mail.gq1.yahoo.com ([98.137.69.204]:45008
        "EHLO sonic312-23.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232027AbhC3OZ6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Mar 2021 10:25:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1617114358; bh=zhVB4g6LGbwzKv4Cl52Xh+NEV+mE7B3cm4bqqbPqkaM=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=io50svib24yNcKB/mxERknuAj4akrWbc1EKfILwqZYSUmku9XscsUqDqC3r6bEvWLnrUoV3cVafecT98F23LwSfj+n3Vw60K3dkovHeS49TEiWVQsA7D4QDxQfGICWLFsERnLTHASBSTbevL9JmiM8IdlhnYVMFNM7ZU66HTmCUdI0rmoGTis/kv+iMhznWjUriwcbw6W49shShpZdwHm1YBUdx/V5+pvgLbgsgStGXPdFookANY0txc8m6CLyzxcZLNOAlTBcMkaybxBh+JLdjzFKBKkY70id7/215DnveyUWmLuxkIDSHuZ7ZIHKcU1vRTPL0LUA/vnXQ4cLtNdQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1617114358; bh=AThyH4QEFWmX6C0MsC3pgv08M4Pld9M+7t8Fd5t/lRR=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=XALguWIsjZXgvffbtLbLGexraQ1LwmGiCOBHqITScncGckQu4gvp4B5WAuhG6OLXjOPxmKGohcRd+bwdhERFFX2Fc5KmHF3vw5wB1czVyg2Z6wT+P2GoemK8W1+B/iDFmiE7iOVzrlWCQ/CFl7FU9P6m6EVUd2uMPHw2ujmwkYf6tJM0Z5o7AVT6ltFlOvv81kpRsSYj2cpR6US7AlDSV/HXxj724aQnInkVxAJBI6VeZfiHLCuqxLkhMWH+EOdQJ4UA9WuwtXuEcJMHx71ThK7cXFvqIbURM+A1Q/A6n+8aezsHwxeDb9Wq5j/+n8zfzyV695ZzyNaY+SPTFZBYrQ==
X-YMail-OSG: iqaZvzcVM1n8UiUzBkGPq9tDIs7WeHDvsrskqkevogjwcRAp_k35QuWE9KffiAZ
 j.6J12OvDIQIIIUOROA1x1FElUoKOJOiD_b5l7rRRKNRe5TDXOtIcGyB9sRxCBxs59vpEQWC6COv
 NNHPcPbYkHoZ3j17FLWbh0Mb9jMz1nyh9U4SBQUejuE4z_38QnKfJN_4RpNHV9DNXOi1lqmoNKom
 qoF0eBKjYcKcPQEK_3iv2.zYvSKGaOgWY5XeUIVdxSLTX8GmJNd0hKy8LYN9yvfNePV8H0znbRcd
 GillGWjFUoz5BHbbn6a5olonsTZoL2JoJ_TfnmMKqTUwSoY3xfvJSxtMXeHBGgWW1m0yfRsAhn08
 tAGr8Nz5J1C1PsAxTChU6UalpWD.EgMg.4ZCFScS6pSjXkIfgkgT8enxw5znMJGH0BjqfVBLE4TP
 wyeHFXVSS.epT4aaq73EUdP_CcGsEG8FVQ9JAUTrsi549f9S6l2p9.nX87BPslNJBRyon1m8Me3q
 VJSQAc0gSZF_RMJ9mOx4NA0kLiLSmXnW.Jy1rkdCj6GFOCEYo6Esc5DtZJqnhXOmG6KSUDL0pVRL
 DrRGogsW9YH7JOZqf84SYJbLAPpHJjPj2JERUwYHcZwFbcKJIzuI9Z7fsPiLc3AW7QNtxrph0vA6
 B6AGx58ihXb0ku2KD7xXCiOvRbX8VUgF4s65wf37D1PZUyyJOGpNT7UZHJpxajsNlb.Mpuum5vWf
 7nHKBophCqka1.JUClLBOsJD7YwyiqvLAyg.6kHGm8_WWLAsOTmp_Hb3i0f3OzlPNHDiJNG_u0ZR
 5v7XeFbJ8EfKcy6YgcQaXosXGB4LlSf3J34zftnPXz.LB2FWvhlzehHA2vxIEbebH0tWwO2FL23J
 XUYtGmYkbPHE45HBsx._CRsXpEW7zLHzSp2ZjSmqWOU1pJmiJXGb_TtScWp3zeMak3MLgJgKPeXw
 U8ZwnTsCfJkl88Wnfgf5qVn9sF9_F5JGFz2w_lm1uSkFN3hn9lnFeXQxSHuhUTIZd6PJ2ZEjrLVN
 TJ1PjLRVPeh.bB9.CNwM2KMAQhIuDfaJcR4MmoMJJzyScEQqd4XXWrX2xyNcsSo0Sc3WUX3pd7Xi
 4oGqrMUy9ceNE0X2XdMjkv6z_bmC2JGJfF2Sho0EJ_.bIjIzzVMA6SZQQz1k9VK5ZwnMxaRD_0QS
 GvC8QjGHejO60nQdWK34o4l3Dmf54qwjCLCziFTcKptiDYZN4TxYPfZ.g_YdZdO3uL_alI_GCB65
 oNA19SiWs90DKDuV.oKwL5rICPwnGz0bqCrZ9XZwyPHn35BVCbQCkBim0j_xESIqkaCWDRkpq75Q
 EEHhfDkIZtHCc.UZfpcpWK60rFJSPN4fD3PsmgeWEmwcbq0_Fscp9zQ4YWZLhz6ipk4U_crGBNVO
 TSRe0ch6Ajbg0G11SEownZ_TxssR4mM0tSBpCymwgHhy3tBQVtaYXhuxIFEk0SjL2QvMAV_vGmCP
 IZuYkTi5bkpbkmEWzsW2LS7kRzdNFgexMf3m3uJ.mJCQT4K97VeTT.RaE9oMWzBDM0TDz46Nny7N
 2JU0Mv5lavW1tjcSA8eNZMqcxDXp4CDpH8dpKjE0EEAHpy_1rKYInCjUo4cC3dxLEfN7dRs_atD2
 7.1WLYPpOOh7jkMlqLgs8C0ypBn1cvFdxc69aJDyxabf0kGsB41rTbIIdf8zB5R.wrtDJPbzt7bD
 wybqM65QTm3RACjxusd_u1IlZwycmOPi2D0ITlfNi06_ZDYBuW1q_t5SmU90j_vRYuXoHtPruwrA
 s6wUmeVT_.gNXPb8FZRyacVFiO_sPv_w5gh0GsdcPIAEKf3ZzcfwNsA7LZlSYF16Jj5trRmG96V3
 ZoLJ8UXIKVRoFTa1a307ZX1t6ZKO61Mjl9MEg97_dUU8b1z0NKiPco6y_BNdGJr.wt.zA5.tR5un
 iIApV.1ke.iMQErs0zhjxlDyMcBCbo_0mGoolcogEtaddepaZ62i_WJe4TT1UHF4Lwovp0eLfssL
 fLazqMyhY8wh5lX2hd33U9wR4PPQrG1e76lGCBG4v8bS9HDjMFVuREeaNUzsnRnrKfc1OqmMKtbM
 cr3pc6d6cyHl5gTwCLGa0jSuA9s8XY01ng1dWjBiVeJh5KeMjOmUpge1c5OjuH1Z3hkQ0kLDXl0o
 8g9Ef8j2.Mm3QiV.EqyUbwi02vA_KyUTcQkpEvWGrf8dHlgrSmG0t2SuCuyt6jlN3xQcjgtOGsTn
 GTOyCksmcGqY3JilXLgVQzujIh_tbzg_lb0F8dh1jfhlPN54VYmSe.Uy4Hg4mMRJbLF87fEN61pr
 GmSMDXCiWSxjXII8NsFMQq8pPJuyLWnIQrFdzwunOGyHNObQEaJNEJJgFqtuo8IpIif522XWikz2
 VZs5pe5YKfROzNQzlwu0HRGQhnQfnXvAP6gkFmPsqbRWFJ8XfMoc04CAQZvUU7jAy.TOscTaHcQP
 8MHt2CtbxEVDK.7vsdd7c.I1VwFQBCCRh1I2ue1tRTxCRzY2pmwMLhDX2D7uY0DZhVB3JDOb0ZDe
 dFTLauJ2K7bemrfbHkQOjF5L5YR2mijpKObLW5X8jt4tvWruUGdEMYOM.TyWCjXOOiOOvtUnPOGQ
 lacaX.QbZuRGuVFq5lC2QHFsAZknTU8vBJVUTr4I7u7JxbimJJPJol8wnSm8nfExtNpCKXZiLDC3
 oDemUYAnXVMjmTZojrKX4ObievnjXOyNZ.4KPwdea
X-Sonic-MF: <hsiangkao@aol.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.gq1.yahoo.com with HTTP; Tue, 30 Mar 2021 14:25:58 +0000
Received: by kubenode575.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID d17ac850f756223f45b54c36ad526fbe;
          Tue, 30 Mar 2021 14:25:53 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v3 4/8] repair: protect inode chunk tree records with a mutex
Date:   Tue, 30 Mar 2021 22:25:27 +0800
Message-Id: <20210330142531.19809-5-hsiangkao@aol.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210330142531.19809-1-hsiangkao@aol.com>
References: <20210330142531.19809-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
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
2.20.1

