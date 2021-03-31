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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42DE1C433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 06:02:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22D6661935
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 06:02:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbhCaGCD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Mar 2021 02:02:03 -0400
Received: from sonic312-25.consmr.mail.gq1.yahoo.com ([98.137.69.206]:44802
        "EHLO sonic312-25.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233731AbhCaGBg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Mar 2021 02:01:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1617170495; bh=zhVB4g6LGbwzKv4Cl52Xh+NEV+mE7B3cm4bqqbPqkaM=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=Oq5GZ7DGw3oV3o+GsZJqmAgbmsleWJXr9HLfAocFoBkjO0CujwLiorA0nMcLgd96wZraZzwvyjtEv8G2G3OIax/jxt150b1UdPLawJjLhTvzJkwbPGvXEU16WEBEAEZ1mvpECrxJYieF4pgnRhGwFXF2kqv+bNjoKICRR5dmpTS9fQg+16ULL/zXfVPOLClQORhcBTrpVaIRnqW0dOFZV6hLS5krkk6MmpD1xup1NZ5gOrGEgp19ghhPtboKDK37KyKAYgnUDyXKbgPl7lNVR+HCMRI0hNJc5o27sv6a0TWuuu5z4vTADjlTobnD5Wn8o7dyKqD1gTDANarpr0QRFA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1617170495; bh=lYW2vzgdZHP1EGoyU2wFyzXucgIVBaLS5R85JGXd+iN=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=k0Io+ou0nfE9PwNUuz/LqtFetIZvDaclcS5QyIvgsZ9LtENTOl8Pxx7OmxrTC/+zVu+OjPJwTynTYyGcNHgwszg7P9u/CqwVvYffSqdLJHndVm4ZYxILsKk8ulJ5pk5RuDCoIkrUU20PoWOg3UnY808+yzXXNLBoo+7r9Xy4ZhItQs/4QOOcrq8OG3XmlXYMqw+459f4VlgdPkwkG9JwDIm6CI1mld08qPqkCHnoHGnUwc0+twrsis0Kvh6+JRaxdvMo/zDegxroJkoK/1DuRsalaYK7WC7jKaX011QLL4zKI1uvLzgSol014fr1+jOksKaeSuoaSmXZvH7kTCbcXA==
X-YMail-OSG: _fpea04VM1kH.t2PlLfF5SzhbJQcGtVH0B8duV1MGWUTuAhUHy9_as_MaI.aazD
 4eTRxtHUYMWbnAJQHH5Ss2w63n1VocoTlmCIByqVKfurTsF5wiwipYQAESRVVlD0hv5xO_I1TSJn
 V62DBKWI_BT.PdXMlcgmuWkxatL9AU6.ARgZ0_zu2qZriIW.Gd3CjnAAthVlIv_pbEjfnchoIgnW
 rybjDLqxjSaaCa7VwsFhOeNJoqqZ2_F7xXTp9PNTuGkeHjCD2ebcrXOd64iJ13w4pHi70D5Oxr28
 miSST5qmQE5duNR.ngSp94p6FYxW9Vpwe2bltZWaeb_E3.OGC8XZRc7yX1r9Nj._Q5nZZuB6MHtu
 ooazKCsDwPaeoBQCIxbSOYl43QBs5clYyxnaJ1veCnQHsCZv0_ZpCYux68nrxxwn57S7w._cjvKW
 LuwV5c0PnOzk01BTd51vD_Hs2xvNjoi8fGEo3osWUBr93kts3TOOACC3z2eYGG..OxWYWwIhnY9f
 qXY48u7jQ54ZqZXwgOLOt4dBUNxnuuLyfWyOIyO7_ubY6APQUrdoDvSiG5MOQxLfxTT.zqE5GObZ
 fL0hw_kTzh2ZjzVymriuhHc6Ec.rCBNaaL.QbxwE92Fh2W2vAtdpxCIr560s08KK1NNMXZZ_YMs_
 5u5UWBFJaOFA_EaOFQEI2bMQ0oC90zOW8sei2T7whhfRXhAGLjWizbfEZfwv8oUmDeAYtyopEN0z
 uI8CDwFX43rQEj1dEZteDhX7r36RGmBvr8Ng_vHQDwDlJKgidcZhajYyRPQLSe53xB7Gd8n4TE0u
 BrD58w_47nmh85zFlMxxFc5Bm5LVtK.uq8BzgwmyD1_JBaInoBZbSRtWGB.b5PMnacrniE7b5lmY
 hPbCJF3Vg0v6rwv5febgYY1FIq00D5sWxQOpUCoZGwmPxmNXN_UpbosO0iIRo3qk9TyH0StRRQ4m
 WRd84.L8GaXcp4ZRcqqKQ5N2JkZGwh0f6SVb7GP8uB8RDilaJBGgu_pY834994d8kSV5aHB463UF
 S16U2pxpyrdRpu0r1InbemxTp2CYinYcUTXhpnLHDQadtKS5wJiiBfTxrgWyXYT5JVqVk7x5ZNjO
 wJuAm9RcS.EkxPFls0grK__LXP3AINwZz7eQtMd.okDNg8RjKEArvnkNW.eo4C9sA0PPtQKKF7fi
 Wb3qFmMnoQxB3yJoq20Ro2_66trltu5uCpr4qTrphIx3sH_5hrDNuyv3otcsaahInYVmbQYJFTJP
 48CGfH_lZMq6QZYxGo5xV37eLnn0iw7TiKXFhkxyC.KYBEsjvBc7MHEto8xwnJLaCezmkq4nP1Gz
 kF7ro5FB7.2ABmyjlYUEKXHyW51xHVD7c7mJYfOaIVdjdEhK5Ypz0thDHH15AZipcOWJ.t813r_Q
 eBtB4SoSsePKnB7.a_lsUxQfuwORGwdu_yJtdQRd7s7T9efAEu3cVJolTzhNlVMkLAkPvobfjjaj
 mV5lUhulQEkgkWW5Cp5sq_vFB.SxFR_mZEDRVbUUgEU4jjMJRm2yad4XPkaHpwQUChtg7D6Owdhm
 P2bR43wqDysocKIFG7z5epfw7zbSYECYPTQu4XagInGWw7aTfdE5Sj0AkM33iocU2x0uOiHTsF6A
 5cXWmKvO3DVkTEvrkcEMueAEGshhQdQFr6zc234i6BKmxCPvDKiuO3fvwlVxngC99DNNl_dZsURJ
 KV4V0vjZQrgsdlUH7zRbj23JYQMADiCiM6OiX.giD8FCPdowYgGWCG_hn53IlkhgEi86t_p_Lvpt
 q47F1JXohYtbHjfBwl1SNlsUgcS9dztt_IlIoprclsYft6.1urSdRqp5G_4p_WozNXQwdvqvSeNV
 jRlcd9TAQhiTprOFcWAAo1TA6zMyRTfz4EPu19YGGQ92OMUBlEwLMThOYlamq7FZB8pMYL3geUum
 dNeYojqx1ryPDiB9rhNg17qwMSaauDAR1IbD3xqnnI1dEfQvcXNdsOYBTMIpcMNa9fvaHYBdiqDn
 hL7qWxDRjY8IvrcdESJbCrKJCS2PdxazVC52duscGlOOcBHjvMgp51dH5o7X6WKX_MSsHb_FyFaU
 x_P.kCfwQgbe0moIFO2UmUlq1x9sa0Q9gnyhJB1bOb57et1ic5VBUd260Hdl5YkpBl72vYlwcFYq
 fXl8fnAjyuAHN9ESJEshV_vIKNrTJwF3toIkXmcIijoiROSUXAdXrvcJagQLt7xiXT4b92VDUMTZ
 FTUmVuDaLU_7GdxqfJe4MrTjW1e3fzz6IK5hmT1ibIQ2tBHx5BGH26GoIkw417oaldO9RDGxXa3p
 SWTe7BiWyS0lsNaa5bA73ToZjpiv3MerAjqotPxjgxvXrH2YWROPMAIr.oFYt4GZpiY1LjTTq2b4
 j4qpU2R3o8KI55J6Vxqv_NjBE4PBfBDvGJSdAnL8kU0_c3ApS3QA5uGSTqZ7jtwDr2wdohdBkcY_
 ._Eo_zy6Km9saEwRg6u6mSt66DfpOWsvGArXH5daq1cIX_HqQ0ND1hJYmn3wAEiN3lWAiAoG_KDJ
 8kp9HLPkjA2VAxyTDZ21o1RmXxSrK4mXpYcn1y9PM6NHq9jEjAphh0X7Kg.4TC4i8T2I71jt_8K.
 T873zM_W9jHNYlX6._2mR7x1rNYCefjXB0beb4FPr_6f3_LYRRYtzI.ZNEyoCI4GvIZj3u4fxID5
 XZzJWEF1il9.tu4a33HwDTl_vrgm2wboe
X-Sonic-MF: <hsiangkao@aol.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.gq1.yahoo.com with HTTP; Wed, 31 Mar 2021 06:01:35 +0000
Received: by kubenode525.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 190a809d5456af9661811acc5a61b089;
          Wed, 31 Mar 2021 06:01:32 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v4 3/7] repair: protect inode chunk tree records with a mutex
Date:   Wed, 31 Mar 2021 14:01:13 +0800
Message-Id: <20210331060117.28159-4-hsiangkao@aol.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210331060117.28159-1-hsiangkao@aol.com>
References: <20210331060117.28159-1-hsiangkao@aol.com>
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

