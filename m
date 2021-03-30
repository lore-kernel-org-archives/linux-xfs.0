Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B98A4C433E2
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 14:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82AC2619CE
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 14:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbhC3O0V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 10:26:21 -0400
Received: from sonic317-20.consmr.mail.gq1.yahoo.com ([98.137.66.146]:39323
        "EHLO sonic317-20.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232052AbhC3O0E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Mar 2021 10:26:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1617114364; bh=7IUf5etUR4dCzujJK/Mt7eksviSNatZqAHagCErASOE=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=cTomG97eW62f9eU7z0jz/9Ye6ZwDaZleTx87mh2ih2gfjfRTeKya1bfLeWVElSFbPlo7LR1zkQSdaRMeTUqQeCNv5RBuv/MqD3/k2vqQ3kihu47hw02gEl1Aqo4LQC0A00e9II+YYe9gFu+pKFwVnziFEOPD/n39H2V/l9M1JkpgD/YDYheG2TVhIN6wfreCzswEdA+diw9+3iiu8fZ8TdT2UO4vqtyxkJ80sd/98JatvpWx2EMqQbDifzbWuPCtr+9hWqvc0e5wwsEtQgg+4W+5N8gDP9m3GsxuQ54ti0uu/d9lbd43VqTCeqOOEfM+6pShUm1stkr9gVZOL7gBfg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1617114364; bh=cSwaUqid39JtRnWUE1jI6sLx3Fs6p9sHpFDvFShunA+=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=LUvq2v0mjIOXT+SFMfQrU6wqf14AqPs9n20CP+nQTQ4RoQIuBiqdNmoj1s9XntfV7lMOH+GIUl+uciCEaQ/mlGtGRXYjtaiYr/8NtRy7snMgGBMBxpSuv7lzKKbT9b7yyd906yvtZvrKKs+h4sUBjhHJjasfZkFfHPL51jL+9gZdOCJ3sMhhb1MAJBV1SRU0x0MkwiRqW9v+i6f/O8ztD1iI5D/pzAo/W3cpQGJO+JqVH/d3o+u8OA7GoLszB8xfkd8twfq7+3YEUIt6ykDzVDNAJaxF0KEYhvaAVS76/+Q3Cx5929VBdR5VB6fC+b5xiPeGbTc3PNu5A9WE9O3e6Q==
X-YMail-OSG: 5XF_w48VM1lYD.wST.kcIJBYzwU1V3hiHtOszogKiN6c8J3m1hIUuJ9RR5Hn2Jn
 D4wvgQcAhO4Bl.oe9Pvs3q0fkD.INFNFJzg2Ay0BV08w.lWSvu07BvBtlUM_DXv943CpdGjRguzp
 9EutonImQ4l4Choe2Pba_gHRr.4I2cdgXKoY4aFAKp8HlKX907.n_gZdRzQATL.dm3DjYjGB2EXn
 tVshi1lNU1A2PXI5.vUppNvDI3Y38uUd5Znfpm0ad9YgbQ0FX9TZNXen9nXwvPBLuMmnVWliqaxt
 kgL0UOP.5br85fRZ4q_geh3h2pm1RVjYBvtjiLJbs3S7ck9Hm86gyKaM0Zoid4GH3QxwNEXUhmG7
 jyH3gXyBYYZjii4SFPcM6Mdeqn70FgMPLuiN7TTaQNA8PMYpQ4tA.gSCGm900zRD3ETGBq8dkZq8
 zK.6o8hBwPf3GqN6rXtRZpS7CGpMqvHiP0rb6iud3Uv8CJeSzVmqtYLplbSIdyxTwrbgdiVo0wlN
 KKa2cbX3bc4Z33Rd3F8R9wV12xZbvHE57VaZ_6H4593DNThgEeDNlYQ3KtsnwfMxtCHjDmHgAW13
 gnvPGjxpbhojgXx7pFmWneo1t0yLIJi1vk_NtvhPeCmyRkL15LN7nZVk5gXY_wWYUOrGyFEu787y
 Tul3gBDHo9gwrMK601R9iJTK6PEoJ8Gl5WCAQdDOvjz4SIbto0_lG5IC4ObCXZ32lOkDRWdntDsI
 rEXg33tfO7h677wIImXf9VSim.yO7qmf1x5_zntWhLb41PRKS3GpflGst9_fl5HR4JOiie3bDTi2
 eCH70XwDgYuvdhSh4_SYe37lHk2O4emUXvLe7nWhpuZC_BDpDxcEvml9fXFqrsgkcOPEhkxFgPbw
 vD3NYefF2dCXWJwVlvs6oRS_ZSA5HtXCGK6QKa8kWOjyo2A_ayhHOLZd5k3.0yH9xlneWjVNGzwQ
 cEAywnea9dv6bHGUZ0xRDNBNgRQRBwqJ.OCIpIuHilii70SHE3QpDk9gN.Es4JavtuCoD6ZKsnSP
 n5cv0fC3kgfQccAYBQBeRJFOA3h9JR7Yk2At9ZzcsZMjgAdfRvuGF_FZZB_pm65DvMBEBhpjxoKi
 TLBx9E9Gy8S0GwLt.v0tmF8pq_bhGu6JjRAfXiBzBdUctNbJAyyUCQARwiewsV03AibXnfY02BxN
 A3QeEPXKs9mUcevRENWaeNAhRJe2bHZpAXSUSAzrRXlc9mCN1aAA4JgZy2x89wgl3X46TEiPZakt
 G4_1CVDGcQ20u7IeYxr1U9S2D2DFA_5ZL7kOhmgovLIHTLnJGkcGbuEGFqaltO..8BJ7idZZK2pm
 S_xgfkJaONk7EY.ZQWYHlDtb7tvmoB.95I0MZYv4MfLekPY54t8VI9wRefDWFmHB1f_UD.M7NSTF
 CnRiQEVcJ2joPCKCFdXz1YXLPNDnANauO.zB9AZhQMbWlXWhLrhwA1XHGmc2JEsXFuvXaXVAyGcp
 Iv5hCuyEOvXUQwM_buUu8nVAfhuWScxsrh5YOgsi7nCj2gYR8Qeo1IfQCRz1C.IiPguU6TPjFT.u
 k8cXSswOhhP71Ms_OgGlmIvTuCOKnIchsJq_fXJVuq4I1vqh8GB9RETJR.aVt8EAU399sXFeMLqs
 PG..EADpjg_gOWuA86Dqs4L52t2xg5uCZCMARHECFwXuQ1tx1yxKy3bDDAIDFZqn1cghb4LANdmh
 BNtCewgOBbhhZH3XUDRewPQbqEFuO0OWy3fRicKmg0FalXrgqt.QXAWCr9G34DcyF2nLz7_5QYTy
 2Q49maLOTpp_OJ8KAygCz1nx5FnpwK_05pb5ILs1GDCEbtrYZaWv60TGdRg708Lj.5gKeoNxtr_4
 aLlqNhYgT4BbvV2wYFBCPStYGDA2lUhR8qV7V3.KxsjcZoyY0BF2jiYM0cIOQKDsAn_MhXoOIRrD
 j0jZzngKbBzCRbRRoW6yqXHmBvHb.Fi05.LrUYLLa9QglsSCGvnrVBfewHvenjebCTBg32NVwOid
 lG0_hGXcrSi0BIGUdq.v0UB9ooGBZmO7bgntUUkSs3HD77EwYy4uIB6DdVUDkoNR0YK_Uo4eHMDQ
 ZBj.Mq.cplfaKjZBei3Un.pAqRpxrF8iE9iLGFL0kMslvT0KRX7EkTUZedNKn.jykf9vX6J.3Aqs
 bnelocq8ZXeaLCz2NCr_BCxPspGUXdPfOpfAlDzQ7qrUV6JWlCoNZLyFLcy2TxiAJA84X65Th12w
 3_rLfjApQTXjjysSBTbMVdvVMis8DB5Mf08kxYs5MxmIMwo1IhY8tbOqDwdX1wnotrdsKZkTRM7J
 lB.vTJTFbrn0WmXbdaAtZqj8p3a99Q6mOgP17DAcRJaujd5uj9ARJsRAtepzckLXcXRCLkWrMXR1
 6WBQoa8zpWkjQAL82bRrUrO8tH55N92v1OJguc64nVa59BicZQoADhWSJ5_DeUKti4nRCdzI3ZuH
 gENkiy1fyOEBVXNSgTHDKbvgirBmTbuS4uFkrsl0mkvChsn35ZIAI6FK95TpsmzTra7JI.DtdK6I
 UreuAOQOc3mGpYRkYEZElKL2jtHsQ9zKa_HnSanl8C_R1pzobHxuPAOtqrofoAwkNUvSQP.0lNLj
 5TKz3zzxepm1Yg0V0n7OJpKQwoaAEquXStsB5dB6ATNnRWEzoPYieF2bB6ueI
X-Sonic-MF: <hsiangkao@aol.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.gq1.yahoo.com with HTTP; Tue, 30 Mar 2021 14:26:04 +0000
Received: by kubenode575.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID d17ac850f756223f45b54c36ad526fbe;
          Tue, 30 Mar 2021 14:26:02 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v3 7/8] repair: convert the dir byaddr hash to a radix tree
Date:   Tue, 30 Mar 2021 22:25:30 +0800
Message-Id: <20210330142531.19809-8-hsiangkao@aol.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210330142531.19809-1-hsiangkao@aol.com>
References: <20210330142531.19809-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Phase 6 uses a hash table to track the data segment addresses of the
entries it has seen in a directory. This is indexed by the offset
into the data segment for the dirent, and is used to check if the
entry exists, is a duplicate or has a bad hash value. The lookup
operations involve walking long hash chains on large directories and
they are done for every entry in the directory. This means certain
operations have O(n^2) scalability (or worse!) and hence hurt on
very large directories.

It is also used to determine if the directory has unseen entries,
which involves a full hash traversal that is very expensive on large
directories. Hence the directory checking for unseen ends up being
roughly a O(n^2 + n) algorithm.

Switch the byaddr indexing to a radix tree. While a radix tree will
burn more memory than the linked list, it gives us O(log n) lookup
operations instead of O(n) on large directories, and use for tags
gives us O(1) determination of whether all entries have been seen or
not. This brings the "entry seen" algorithm scalability back to
O(nlog n) and so is a major improvement for processing large
directories.

Given a filesystem with 10M empty files in a single directory, we
see:

5.6.0:

  97.56%  xfs_repair              [.] dir_hash_add.lto_priv.0
   0.38%  xfs_repair              [.] avl_ino_start.lto_priv.0
   0.37%  libc-2.31.so            [.] malloc
   0.34%  xfs_repair              [.] longform_dir2_entry_check_data.lto_priv.0

Phase 6:        10/22 12:07:13  10/22 12:10:51  3 minutes, 38 seconds

Patched:

  97.11%  xfs_repair          [.] dir_hash_add
   0.38%  xfs_repair          [.] longform_dir2_entry_check_data
   0.34%  libc-2.31.so        [.] __libc_calloc
   0.32%  xfs_repair          [.] avl_ino_start

Phase 6:        10/22 12:11:40  10/22 12:14:28  2 minutes, 48 seconds

So there's some improvement, but we are clearly still CPU bound due
to the O(n^2) scalability of the duplicate name checking algorithm.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 libfrog/radix-tree.c |  46 +++++++++
 repair/phase6.c      | 222 ++++++++++++++++++++-----------------------
 2 files changed, 148 insertions(+), 120 deletions(-)

diff --git a/libfrog/radix-tree.c b/libfrog/radix-tree.c
index c1c74876964c..261fc2487de9 100644
--- a/libfrog/radix-tree.c
+++ b/libfrog/radix-tree.c
@@ -312,6 +312,52 @@ void *radix_tree_lookup_first(struct radix_tree_root *root, unsigned long *index
 
 #ifdef RADIX_TREE_TAGS
 
+/**
+ * radix_tree_tag_get - get a tag on a radix tree node
+ * @root:		radix tree root
+ * @index:		index key
+ * @tag:		tag index (< RADIX_TREE_MAX_TAGS)
+ *
+ * Return values:
+ *
+ *  0: tag not present or not set
+ *  1: tag set
+ *
+ * Note that the return value of this function may not be relied on, even if
+ * the RCU lock is held, unless tag modification and node deletion are excluded
+ * from concurrency.
+ */
+int radix_tree_tag_get(struct radix_tree_root *root,
+			unsigned long index, unsigned int tag)
+{
+	unsigned int height, shift;
+	struct radix_tree_node *slot;
+
+	height = root->height;
+	if (index > radix_tree_maxindex(height))
+		return 0;
+
+	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
+	slot = root->rnode;
+
+	while (height > 0) {
+		int offset;
+
+		if (slot == NULL)
+			return 0;
+
+		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
+		if (!tag_get(slot, tag, offset))
+			return 0;
+
+		slot = slot->slots[offset];
+		ASSERT(slot != NULL);
+		shift -= RADIX_TREE_MAP_SHIFT;
+		height--;
+	}
+	return 1;
+}
+
 /**
  *	radix_tree_tag_set - set a tag on a radix tree node
  *	@root:		radix tree root
diff --git a/repair/phase6.c b/repair/phase6.c
index df8db146c187..063329636500 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -66,8 +66,7 @@ add_dotdot_update(
  * and whether their leaf entry has been seen. Also used for name
  * duplicate checking and rebuilding step if required.
  */
-typedef struct dir_hash_ent {
-	struct dir_hash_ent	*nextbyaddr;	/* next in addr bucket */
+struct dir_hash_ent {
 	struct dir_hash_ent	*nextbyhash;	/* next in name bucket */
 	struct dir_hash_ent	*nextbyorder;	/* next in order added */
 	xfs_dahash_t		hashval;	/* hash value of name */
@@ -77,18 +76,19 @@ typedef struct dir_hash_ent {
 	short			seen;		/* have seen leaf entry */
 	struct xfs_name		name;
 	unsigned char		namebuf[];
-} dir_hash_ent_t;
+};
 
-typedef struct dir_hash_tab {
+struct dir_hash_tab {
 	int			size;		/* size of hash tables */
-	dir_hash_ent_t		*first;		/* ptr to first added entry */
-	dir_hash_ent_t		*last;		/* ptr to last added entry */
-	dir_hash_ent_t		**byhash;	/* ptr to name hash buckets */
-	dir_hash_ent_t		**byaddr;	/* ptr to addr hash buckets */
-} dir_hash_tab_t;
+	struct dir_hash_ent	*first;		/* ptr to first added entry */
+	struct dir_hash_ent	*last;		/* ptr to last added entry */
+	struct dir_hash_ent	**byhash;	/* ptr to name hash buckets */
+#define HT_UNSEEN		1
+	struct radix_tree_root	byaddr;
+};
 
 #define	DIR_HASH_TAB_SIZE(n)	\
-	(sizeof(dir_hash_tab_t) + (sizeof(dir_hash_ent_t *) * (n) * 2))
+	(sizeof(struct dir_hash_tab) + (sizeof(struct dir_hash_ent *) * (n)))
 #define	DIR_HASH_FUNC(t,a)	((a) % (t)->size)
 
 /*
@@ -155,8 +155,8 @@ dir_read_buf(
  */
 static int
 dir_hash_add(
-	xfs_mount_t		*mp,
-	dir_hash_tab_t		*hashtab,
+	struct xfs_mount	*mp,
+	struct dir_hash_tab	*hashtab,
 	uint32_t		addr,
 	xfs_ino_t		inum,
 	int			namelen,
@@ -164,19 +164,18 @@ dir_hash_add(
 	uint8_t			ftype)
 {
 	xfs_dahash_t		hash = 0;
-	int			byaddr;
 	int			byhash = 0;
-	dir_hash_ent_t		*p;
+	struct dir_hash_ent	*p;
 	int			dup;
 	short			junk;
 	struct xfs_name		xname;
+	int			error;
 
 	xname.name = name;
 	xname.len = namelen;
 	xname.type = ftype;
 
 	junk = name[0] == '/';
-	byaddr = DIR_HASH_FUNC(hashtab, addr);
 	dup = 0;
 
 	if (!junk) {
@@ -206,8 +205,14 @@ dir_hash_add(
 		do_error(_("malloc failed in dir_hash_add (%zu bytes)\n"),
 			sizeof(*p));
 
-	p->nextbyaddr = hashtab->byaddr[byaddr];
-	hashtab->byaddr[byaddr] = p;
+	error = radix_tree_insert(&hashtab->byaddr, addr, p);
+	if (error == EEXIST) {
+		do_warn(_("duplicate addrs %u in directory!\n"), addr);
+		free(p);
+		return 0;
+	}
+	radix_tree_tag_set(&hashtab->byaddr, addr, HT_UNSEEN);
+
 	if (hashtab->last)
 		hashtab->last->nextbyorder = p;
 	else
@@ -232,33 +237,14 @@ dir_hash_add(
 	return !dup;
 }
 
-/*
- * checks to see if any data entries are not in the leaf blocks
- */
-static int
-dir_hash_unseen(
-	dir_hash_tab_t	*hashtab)
-{
-	int		i;
-	dir_hash_ent_t	*p;
-
-	for (i = 0; i < hashtab->size; i++) {
-		for (p = hashtab->byaddr[i]; p; p = p->nextbyaddr) {
-			if (p->seen == 0)
-				return 1;
-		}
-	}
-	return 0;
-}
-
 static int
 dir_hash_check(
-	dir_hash_tab_t	*hashtab,
-	xfs_inode_t	*ip,
-	int		seeval)
+	struct dir_hash_tab	*hashtab,
+	struct xfs_inode	*ip,
+	int			seeval)
 {
-	static char	*seevalstr[DIR_HASH_CK_TOTAL];
-	static int	done;
+	static char		*seevalstr[DIR_HASH_CK_TOTAL];
+	static int		done;
 
 	if (!done) {
 		seevalstr[DIR_HASH_CK_OK] = _("ok");
@@ -270,7 +256,8 @@ dir_hash_check(
 		done = 1;
 	}
 
-	if (seeval == DIR_HASH_CK_OK && dir_hash_unseen(hashtab))
+	if (seeval == DIR_HASH_CK_OK &&
+	    radix_tree_tagged(&hashtab->byaddr, HT_UNSEEN))
 		seeval = DIR_HASH_CK_NOLEAF;
 	if (seeval == DIR_HASH_CK_OK)
 		return 0;
@@ -285,27 +272,28 @@ dir_hash_check(
 
 static void
 dir_hash_done(
-	dir_hash_tab_t	*hashtab)
+	struct dir_hash_tab	*hashtab)
 {
-	int		i;
-	dir_hash_ent_t	*n;
-	dir_hash_ent_t	*p;
+	int			i;
+	struct dir_hash_ent	*n;
+	struct dir_hash_ent	*p;
 
 	for (i = 0; i < hashtab->size; i++) {
-		for (p = hashtab->byaddr[i]; p; p = n) {
-			n = p->nextbyaddr;
+		for (p = hashtab->byhash[i]; p; p = n) {
+			n = p->nextbyhash;
+			radix_tree_delete(&hashtab->byaddr, p->address);
 			free(p);
 		}
 	}
 	free(hashtab);
 }
 
-static dir_hash_tab_t *
+static struct dir_hash_tab *
 dir_hash_init(
-	xfs_fsize_t	size)
+	xfs_fsize_t		size)
 {
-	dir_hash_tab_t	*hashtab;
-	int		hsize;
+	struct dir_hash_tab	*hashtab;
+	int			hsize;
 
 	hsize = size / (16 * 4);
 	if (hsize > 65536)
@@ -315,51 +303,43 @@ dir_hash_init(
 	if ((hashtab = calloc(DIR_HASH_TAB_SIZE(hsize), 1)) == NULL)
 		do_error(_("calloc failed in dir_hash_init\n"));
 	hashtab->size = hsize;
-	hashtab->byhash = (dir_hash_ent_t**)((char *)hashtab +
-		sizeof(dir_hash_tab_t));
-	hashtab->byaddr = (dir_hash_ent_t**)((char *)hashtab +
-		sizeof(dir_hash_tab_t) + sizeof(dir_hash_ent_t*) * hsize);
+	hashtab->byhash = (struct dir_hash_ent **)((char *)hashtab +
+		sizeof(struct dir_hash_tab));
+	INIT_RADIX_TREE(&hashtab->byaddr, 0);
 	return hashtab;
 }
 
 static int
 dir_hash_see(
-	dir_hash_tab_t		*hashtab,
+	struct dir_hash_tab	*hashtab,
 	xfs_dahash_t		hash,
 	xfs_dir2_dataptr_t	addr)
 {
-	int			i;
-	dir_hash_ent_t		*p;
+	struct dir_hash_ent	*p;
 
-	i = DIR_HASH_FUNC(hashtab, addr);
-	for (p = hashtab->byaddr[i]; p; p = p->nextbyaddr) {
-		if (p->address != addr)
-			continue;
-		if (p->seen)
-			return DIR_HASH_CK_DUPLEAF;
-		if (p->junkit == 0 && p->hashval != hash)
-			return DIR_HASH_CK_BADHASH;
-		p->seen = 1;
-		return DIR_HASH_CK_OK;
-	}
-	return DIR_HASH_CK_NODATA;
+	p = radix_tree_lookup(&hashtab->byaddr, addr);
+	if (!p)
+		return DIR_HASH_CK_NODATA;
+	if (!radix_tree_tag_get(&hashtab->byaddr, addr, HT_UNSEEN))
+		return DIR_HASH_CK_DUPLEAF;
+	if (p->junkit == 0 && p->hashval != hash)
+		return DIR_HASH_CK_BADHASH;
+	radix_tree_tag_clear(&hashtab->byaddr, addr, HT_UNSEEN);
+	return DIR_HASH_CK_OK;
 }
 
 static void
 dir_hash_update_ftype(
-	dir_hash_tab_t		*hashtab,
+	struct dir_hash_tab	*hashtab,
 	xfs_dir2_dataptr_t	addr,
 	uint8_t			ftype)
 {
-	int			i;
-	dir_hash_ent_t		*p;
+	struct dir_hash_ent	*p;
 
-	i = DIR_HASH_FUNC(hashtab, addr);
-	for (p = hashtab->byaddr[i]; p; p = p->nextbyaddr) {
-		if (p->address != addr)
-			continue;
-		p->name.type = ftype;
-	}
+	p = radix_tree_lookup(&hashtab->byaddr, addr);
+	if (!p)
+		return;
+	p->name.type = ftype;
 }
 
 /*
@@ -368,7 +348,7 @@ dir_hash_update_ftype(
  */
 static int
 dir_hash_see_all(
-	dir_hash_tab_t		*hashtab,
+	struct dir_hash_tab	*hashtab,
 	xfs_dir2_leaf_entry_t	*ents,
 	int			count,
 	int			stale)
@@ -1222,19 +1202,19 @@ dir_binval(
 
 static void
 longform_dir2_rebuild(
-	xfs_mount_t		*mp,
+	struct xfs_mount	*mp,
 	xfs_ino_t		ino,
-	xfs_inode_t		*ip,
-	ino_tree_node_t		*irec,
+	struct xfs_inode	*ip,
+	struct ino_tree_node	*irec,
 	int			ino_offset,
-	dir_hash_tab_t		*hashtab)
+	struct dir_hash_tab	*hashtab)
 {
 	int			error;
 	int			nres;
-	xfs_trans_t		*tp;
+	struct xfs_trans	*tp;
 	xfs_fileoff_t		lastblock;
-	xfs_inode_t		pip;
-	dir_hash_ent_t		*p;
+	struct xfs_inode	pip;
+	struct dir_hash_ent	*p;
 	int			done = 0;
 
 	/*
@@ -1393,14 +1373,14 @@ _("directory shrink failed (%d)\n"), error);
  */
 static void
 longform_dir2_entry_check_data(
-	xfs_mount_t		*mp,
-	xfs_inode_t		*ip,
+	struct xfs_mount	*mp,
+	struct xfs_inode	*ip,
 	int			*num_illegal,
 	int			*need_dot,
-	ino_tree_node_t		*current_irec,
+	struct ino_tree_node	*current_irec,
 	int			current_ino_offset,
 	struct xfs_buf		*bp,
-	dir_hash_tab_t		*hashtab,
+	struct dir_hash_tab	*hashtab,
 	freetab_t		**freetabp,
 	xfs_dablk_t		da_bno,
 	int			isblock)
@@ -1927,10 +1907,10 @@ check_dir3_header(
  */
 static int
 longform_dir2_check_leaf(
-	xfs_mount_t		*mp,
-	xfs_inode_t		*ip,
-	dir_hash_tab_t		*hashtab,
-	freetab_t		*freetab)
+	struct xfs_mount	*mp,
+	struct xfs_inode	*ip,
+	struct dir_hash_tab	*hashtab,
+	struct freetab		*freetab)
 {
 	int			badtail;
 	__be16			*bestsp;
@@ -2012,10 +1992,10 @@ longform_dir2_check_leaf(
  */
 static int
 longform_dir2_check_node(
-	xfs_mount_t		*mp,
-	xfs_inode_t		*ip,
-	dir_hash_tab_t		*hashtab,
-	freetab_t		*freetab)
+	struct xfs_mount	*mp,
+	struct xfs_inode	*ip,
+	struct dir_hash_tab	*hashtab,
+	struct freetab		*freetab)
 {
 	struct xfs_buf		*bp;
 	xfs_dablk_t		da_bno;
@@ -2187,14 +2167,15 @@ longform_dir2_check_node(
  * (ie. get libxfs to do all the grunt work)
  */
 static void
-longform_dir2_entry_check(xfs_mount_t	*mp,
-			xfs_ino_t	ino,
-			xfs_inode_t	*ip,
-			int		*num_illegal,
-			int		*need_dot,
-			ino_tree_node_t	*irec,
-			int		ino_offset,
-			dir_hash_tab_t	*hashtab)
+longform_dir2_entry_check(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	struct xfs_inode	*ip,
+	int			*num_illegal,
+	int			*need_dot,
+	struct ino_tree_node	*irec,
+	int			ino_offset,
+	struct dir_hash_tab	*hashtab)
 {
 	struct xfs_buf		*bp;
 	xfs_dablk_t		da_bno;
@@ -2397,13 +2378,14 @@ shortform_dir2_junk(
 }
 
 static void
-shortform_dir2_entry_check(xfs_mount_t	*mp,
-			xfs_ino_t	ino,
-			xfs_inode_t	*ip,
-			int		*ino_dirty,
-			ino_tree_node_t	*current_irec,
-			int		current_ino_offset,
-			dir_hash_tab_t	*hashtab)
+shortform_dir2_entry_check(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	struct xfs_inode	*ip,
+	int			*ino_dirty,
+	struct ino_tree_node	*current_irec,
+	int			current_ino_offset,
+	struct dir_hash_tab	*hashtab)
 {
 	xfs_ino_t		lino;
 	xfs_ino_t		parent;
@@ -2745,15 +2727,15 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
  */
 static void
 process_dir_inode(
-	xfs_mount_t 		*mp,
+	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
-	ino_tree_node_t		*irec,
+	struct ino_tree_node	*irec,
 	int			ino_offset)
 {
 	xfs_ino_t		ino;
-	xfs_inode_t		*ip;
-	xfs_trans_t		*tp;
-	dir_hash_tab_t		*hashtab;
+	struct xfs_inode	*ip;
+	struct xfs_trans	*tp;
+	struct dir_hash_tab	*hashtab;
 	int			need_dot;
 	int			dirty, num_illegal, error, nres;
 
-- 
2.20.1

