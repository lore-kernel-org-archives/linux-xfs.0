Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15EF5C433E5
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 06:02:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC663619D9
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 06:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233733AbhCaGCE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Mar 2021 02:02:04 -0400
Received: from sonic303-23.consmr.mail.gq1.yahoo.com ([98.137.64.204]:39022
        "EHLO sonic303-23.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233670AbhCaGBn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Mar 2021 02:01:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1617170503; bh=jQFLtUMpum7DIShm1LZrwbac5hctvXo9TuoGTQbQLxQ=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=Foj2VuGsQKbRxsDHg2XR6XpegaWJOv1wdA6G0B473z+IXGsbr/COwCEKiJFdZMqMki2o2pfiCjr3/u5AaKVwPS3X2AOI2BwUfxcu7LH2l9vQF/meGGvQTWGNX4mfZ5/kXfhB6fC5eLIfYgmPOR/HXKmhagQbMNdE/MmgwvCQuJ3S3d1LEyMIcXL/dyuC5lplsTJGxrUO5yz4ZxwO6R52mOWmaYVVAFFhUe0EWie/8WoRULQxTJtzWQlzql69y0GxDv5d9YtoN6qsYA+vMnQ3avA/k23X+Riq/fHFlSFP/A/JkFyZrNGlL/d+QH7/TJTqXohKf/kbHEx5uOV/mfQLbA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1617170503; bh=pPOeJwU0Ib+wDzw1XSBEKThHdbUkjXVcJJI+pRJJ1hN=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=W+IDSdKAOEkLntKdxR6L+PHZjT/XoI84uXgoq8AK3FpJ4FiwkCGYNIp/DHfj3syKP3SDAhKuqMCqfCP28nU9P3QPkkKKk+C053bynBO1nCGPucTttfzl9P2l5s+zC+s5NadOD+HpMIcJb0mEULxpsBO4zPhGRZ62DwKZga0Rp/HEcLTwhONUIi6U152WlDfLxCmMdR0Sruj3DvqQhTba2MCwpTscFlHT/FkWJvXsgfiEY0nf1gvV8m11B99YYa4YOg+//IlalQJi21gCiqSqQIJ6Nohp49LSAFNjX2zeaQ1B7UiHp6K9rUTRSBG6Ox6dAxjTuWq80Qf7dcpM8BR2Pg==
X-YMail-OSG: Y2O17P8VM1lUTvPb8RYfUf0sggTfYIFmIkj3QGC3tvFCpU6giSJy2w8svse75uR
 tADt_lQO32m4L.R7aN9ZqYoo5yhVJOI8d2Tva338Fvqi88TgFpUUmOMjAHeZZBN8.o9SDLNqokjT
 zUwxGQNCWtpZOAF5qEkuMECHSXZirgSWtq1kqVRMRRs6vWONuHVWtc0emvmL73kUIBkJ.lKCIDY8
 fGgC4vVBo00.BqMelXNOr1TaqHWSHjA_QQ5TCJKMFnhtDPCx.7OeXSw.ZrINeXd39_ThRdaKGBhm
 9DC24KWPIJyJSjc51U.hi5RwF3XxKaz6KWijE.vBhYKOxTAcNIMQdol.EAzTlk0eQ62rXt.PtdoK
 gPqd6BfHaut4zbThnxyIdgD1ckEhDWWzK8QJ0s_I2w2JENhS2h.TLYowSA6bO3AT3vtBMVPr1D8e
 vIWbWdE3jnJJEzBflFjx0m9mJQtm53DZA49TUR9x1bZLB.SetOKT471bbNAfLOxy7GG_raEQ7FtH
 rW7Xh0s.4a6.s_Mn5GjLRXs1ByKkpTGIUi59uBXkxZhYY9SJSEv8gTj57pUu90oOeLDAfk6Nbfss
 pWJfak2UnN6Mrt1Z0kbuWb0pbjEN1PgFPRTIyO2Qggq7ws5.sB0AwqZEtBeidzCTODPtR4FLg.YM
 iaMX_UaKihTJLeI7yTc1n5APSTvuxRFuwZrq6s1_85Z_Fb6BAqs3My2GJdZzxW2_GgQ2iONOUj1y
 QTyL82609EyzemF4gLSLBBAVN5GDjcfrNuOYWyTtxErprdMvwKuCiq5wOE1HgcOlzu2fKjV2zFMG
 WWTcfD91lxmVReL9QzIpM08li9GCx_Cu7XUkTlajryOm3rUk6rFCwvMuiy4zMILPFPcrfa4VwfPr
 lAnCQsOcxX17hZck1H.uwBIK1ngNxrPD.n_z31RnvYNW8w2daqrTW7Bp3lBmFq7x4X0Zo.JGPhjd
 1EhyHOnfsp16pL8lBSubRBKxdMWF.q80QvA0cYb5V7CXoC4O5OpZPkWuuxVrPbztc1l9UQoVdCtl
 EslZz8bM7kPSUGqk_X9gpSADh_mFrGyl4sjzjkxhjiluT8XUd29HxuFNWLyZAfd7yBD_z3utvfX.
 dObx5VtUMCwYiJZZHR92YJ2bTRLG668qRBtmc7SVlwfDYSI_s1b3SBWG2hrJkemnohhxJcWTKyHq
 eAXu0h66o2dwVFpx2d5Wat71PoXcbrl.UAQ6F_aGZCqTlBlioSH49tAFXyBVObtUfE9FQGZL3Wzo
 a2RID1HrM8wFxpjHpp8Uc_kja2vkAhGs0UcphSx6RcgmwdEGrIpWTgcKfmyyUAgSmrHKDm.NAvUs
 Eppq24Rtvfva5fbse1oOxdDTSec8cFLikmL8c.iQZfE2MktNbX8KDlUOaiVnB61Jce3i7b6ePtyv
 cQQRYLGSXuWfDO.1Y3iwq75YbZQXVF6WAraw4MA2cewjplskO8LmCuajuhVQudS1jQbKMr87Qw1N
 2.tYnAdhB.iQ_KfkXyt0CqzdLUIzhvrcRYnq4S38vRvRrOYR7dfO6WP6HNPSiOX4cDFp3qxSQ.tR
 rZoBXVv5FMxgeHp3aklUAKAgVWEGHF60j2x10LhvkKxHM8vEnT.nuO0XAp6jNnxMS2STMV9g99Lj
 gZU0N.Boqv.ry9bcb_K32adnim1Es7v4y9cqcy_dhW24eIpGScRq5bHjYIONtXt_UfhRTGf3scZ5
 7FbVZOiZSmmtci9kiIBFOW5l41ReWUE2EattfALj_BrFRqnVpXEi3R4WtlpVVBUUnUT_5HWGTmvX
 E5suovTZ75OD4aw61sH7jAnZ7HDt0zDdOyFQ4JLe99Xc_qN9CVqgvHb9fAaoECsuAS3fDsAD1n79
 1cIc0HPqbJJsijeflPSBj5elZCFFESXoKujYNdVZNrir.jKowwy5w5H7ZPAPcsH.NG_Z_e0rWKjN
 Wi1VmeQWBTdYFbNt0uTqA_0FbIAUd_osrvA4u.n46xD0znSTj8pCuv6UmYR3qUl_nWyGrikelKYg
 4u7yA3bbAbhjNPEcR9Wz.73cdbwb5SqyvxWbL51zGBeucaaDhEqJSCo8aaY9Rz4X_a474fxrC5Rw
 sdfpOdFQdPW.hg0MBTyWSBKHbiHqE_8PwAOlcROZ98r_EeXBS9oy2NiIa1Cyue_Q2LCKqXqFDqi8
 ZyXaKxi8jhoNXMUZmAtcVkWYnlM_oJuaicvVfrfnQ.848ZD2WR8HJPSB7Um3yW..QImmCjFB4K3t
 lp3kaEHy_X_nwHrQaDQ39q.4X4V1U5WuLHcntWD1c.ozklcB_kZSTnDqpA0xY0bQYT72xE7rfSS6
 J6ShN1gXuv1tNHO3EdM_AfUNQNQCSKokMdMMAZsHk7RRMtwGdLQkSK7tK5o0IecpFQxX4fCij6nJ
 BagovMrSbc3eKYIEgZQ6KVG.pdc98QvQ0Z5MDOm0uUdGa4e6rCUN2AwxxiWTbdKY4PuqfteK10PQ
 UFKS4KfaUsRKkdeoEzNycqGAnU.vEo.RtotH8NVVuLp29f88ITFXQducSBdlyr1CtuNua5kUPXRS
 JxlTnPXzxLnh03vzLjW0bZQ8pPj7lW2_nvfVez7cnCGInQKk1C1RDzMD9bwaRpUGRS0c9CN_XUbo
 05ugw94OK0dBBZ69_Nz6284fYIpP57CKL.4ny6tFYkVSbvA7o4X9U6UEMbJV77K._WZ8YaQ7wstb
 yz_PD24tUJv0vKg--
X-Sonic-MF: <hsiangkao@aol.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.gq1.yahoo.com with HTTP; Wed, 31 Mar 2021 06:01:43 +0000
Received: by kubenode525.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 190a809d5456af9661811acc5a61b089;
          Wed, 31 Mar 2021 06:01:37 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v4 5/7] repair: don't duplicate names in phase 6
Date:   Wed, 31 Mar 2021 14:01:15 +0800
Message-Id: <20210331060117.28159-6-hsiangkao@aol.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210331060117.28159-1-hsiangkao@aol.com>
References: <20210331060117.28159-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The name hash in phase 6 is constructed by using names that point
directly into the directory buffers. Hence before the buffers can be
released, the constructed name hash has to duplicate all those names
into meory it owns via dir_hash_dup_names().

Given that the structure that holds the name is dynamically
allocated, it makes no sense to store a pointer to the name
dir_hash_add() and then later have dynamically allocate the name.

Extend the name hash allocation to contain space for the name
itself, and copy the name into the name hash structure in
dir_hash_add(). This allows us to get rid of dir_hash_dup_names(),
and the directory checking code no longer needs to hold all the
directory buffers in memory until the entire directory walk is
complete and the names duplicated.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 repair/phase6.c | 101 ++++++++++++++----------------------------------
 1 file changed, 29 insertions(+), 72 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index e51784521d28..df8db146c187 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -72,15 +72,15 @@ typedef struct dir_hash_ent {
 	struct dir_hash_ent	*nextbyorder;	/* next in order added */
 	xfs_dahash_t		hashval;	/* hash value of name */
 	uint32_t		address;	/* offset of data entry */
-	xfs_ino_t 		inum;		/* inode num of entry */
+	xfs_ino_t		inum;		/* inode num of entry */
 	short			junkit;		/* name starts with / */
 	short			seen;		/* have seen leaf entry */
 	struct xfs_name		name;
+	unsigned char		namebuf[];
 } dir_hash_ent_t;
 
 typedef struct dir_hash_tab {
 	int			size;		/* size of hash tables */
-	int			names_duped;	/* 1 = ent names malloced */
 	dir_hash_ent_t		*first;		/* ptr to first added entry */
 	dir_hash_ent_t		*last;		/* ptr to last added entry */
 	dir_hash_ent_t		**byhash;	/* ptr to name hash buckets */
@@ -171,8 +171,6 @@ dir_hash_add(
 	short			junk;
 	struct xfs_name		xname;
 
-	ASSERT(!hashtab->names_duped);
-
 	xname.name = name;
 	xname.len = namelen;
 	xname.type = ftype;
@@ -199,7 +197,12 @@ dir_hash_add(
 		}
 	}
 
-	if ((p = malloc(sizeof(*p))) == NULL)
+	/*
+	 * Allocate enough space for the hash entry and the name in a single
+	 * allocation so we can store our own copy of the name for later use.
+	 */
+	p = calloc(1, sizeof(*p) + namelen + 1);
+	if (!p)
 		do_error(_("malloc failed in dir_hash_add (%zu bytes)\n"),
 			sizeof(*p));
 
@@ -220,8 +223,12 @@ dir_hash_add(
 	p->address = addr;
 	p->inum = inum;
 	p->seen = 0;
-	p->name = xname;
 
+	/* Set up the name in the region trailing the hash entry. */
+	memcpy(p->namebuf, name, namelen);
+	p->name.name = p->namebuf;
+	p->name.len = namelen;
+	p->name.type = ftype;
 	return !dup;
 }
 
@@ -287,8 +294,6 @@ dir_hash_done(
 	for (i = 0; i < hashtab->size; i++) {
 		for (p = hashtab->byaddr[i]; p; p = n) {
 			n = p->nextbyaddr;
-			if (hashtab->names_duped)
-				free((void *)p->name.name);
 			free(p);
 		}
 	}
@@ -385,27 +390,6 @@ dir_hash_see_all(
 	return j == stale ? DIR_HASH_CK_OK : DIR_HASH_CK_BADSTALE;
 }
 
-/*
- * Convert name pointers into locally allocated memory.
- * This must only be done after all the entries have been added.
- */
-static void
-dir_hash_dup_names(dir_hash_tab_t *hashtab)
-{
-	unsigned char		*name;
-	dir_hash_ent_t		*p;
-
-	if (hashtab->names_duped)
-		return;
-
-	for (p = hashtab->first; p; p = p->nextbyorder) {
-		name = malloc(p->name.len);
-		memcpy(name, p->name.name, p->name.len);
-		p->name.name = name;
-	}
-	hashtab->names_duped = 1;
-}
-
 /*
  * Given a block number in a fork, return the next valid block number (not a
  * hole).  If this is the last block number then NULLFILEOFF is returned.
@@ -1383,6 +1367,7 @@ dir2_kill_block(
 		res_failed(error);
 	libxfs_trans_ijoin(tp, ip, 0);
 	libxfs_trans_bjoin(tp, bp);
+	libxfs_trans_bhold(tp, bp);
 	memset(&args, 0, sizeof(args));
 	args.dp = ip;
 	args.trans = tp;
@@ -1414,7 +1399,7 @@ longform_dir2_entry_check_data(
 	int			*need_dot,
 	ino_tree_node_t		*current_irec,
 	int			current_ino_offset,
-	struct xfs_buf		**bpp,
+	struct xfs_buf		*bp,
 	dir_hash_tab_t		*hashtab,
 	freetab_t		**freetabp,
 	xfs_dablk_t		da_bno,
@@ -1422,7 +1407,6 @@ longform_dir2_entry_check_data(
 {
 	xfs_dir2_dataptr_t	addr;
 	xfs_dir2_leaf_entry_t	*blp;
-	struct xfs_buf		*bp;
 	xfs_dir2_block_tail_t	*btp;
 	struct xfs_dir2_data_hdr *d;
 	xfs_dir2_db_t		db;
@@ -1453,7 +1437,6 @@ longform_dir2_entry_check_data(
 	};
 
 
-	bp = *bpp;
 	d = bp->b_addr;
 	ptr = (char *)d + mp->m_dir_geo->data_entry_offset;
 	nbad = 0;
@@ -1554,10 +1537,8 @@ longform_dir2_entry_check_data(
 			dir2_kill_block(mp, ip, da_bno, bp);
 		} else {
 			do_warn(_("would junk block\n"));
-			libxfs_buf_relse(bp);
 		}
 		freetab->ents[db].v = NULLDATAOFF;
-		*bpp = NULL;
 		return;
 	}
 
@@ -2215,17 +2196,15 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 			int		ino_offset,
 			dir_hash_tab_t	*hashtab)
 {
-	struct xfs_buf		**bplist;
+	struct xfs_buf		*bp;
 	xfs_dablk_t		da_bno;
 	freetab_t		*freetab;
-	int			num_bps;
 	int			i;
 	int			isblock;
 	int			isleaf;
 	xfs_fileoff_t		next_da_bno;
 	int			seeval;
 	int			fixit = 0;
-	xfs_dir2_db_t		db;
 	struct xfs_da_args	args;
 
 	*need_dot = 1;
@@ -2242,11 +2221,6 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 		freetab->ents[i].v = NULLDATAOFF;
 		freetab->ents[i].s = 0;
 	}
-	num_bps = freetab->naents;
-	bplist = calloc(num_bps, sizeof(struct xfs_buf*));
-	if (!bplist)
-		do_error(_("calloc failed in %s (%zu bytes)\n"),
-			__func__, num_bps * sizeof(struct xfs_buf*));
 
 	/* is this a block, leaf, or node directory? */
 	args.dp = ip;
@@ -2275,28 +2249,12 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 			break;
 		}
 
-		db = xfs_dir2_da_to_db(mp->m_dir_geo, da_bno);
-		if (db >= num_bps) {
-			int last_size = num_bps;
-
-			/* more data blocks than expected */
-			num_bps = db + 1;
-			bplist = realloc(bplist, num_bps * sizeof(struct xfs_buf*));
-			if (!bplist)
-				do_error(_("realloc failed in %s (%zu bytes)\n"),
-					__func__,
-					num_bps * sizeof(struct xfs_buf*));
-			/* Initialize the new elements */
-			for (i = last_size; i < num_bps; i++)
-				bplist[i] = NULL;
-		}
-
 		if (isblock)
 			ops = &xfs_dir3_block_buf_ops;
 		else
 			ops = &xfs_dir3_data_buf_ops;
 
-		error = dir_read_buf(ip, da_bno, &bplist[db], ops, &fixit);
+		error = dir_read_buf(ip, da_bno, &bp, ops, &fixit);
 		if (error) {
 			do_warn(
 	_("can't read data block %u for directory inode %" PRIu64 " error %d\n"),
@@ -2316,21 +2274,25 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 		}
 
 		/* check v5 metadata */
-		d = bplist[db]->b_addr;
+		d = bp->b_addr;
 		if (be32_to_cpu(d->magic) == XFS_DIR3_BLOCK_MAGIC ||
 		    be32_to_cpu(d->magic) == XFS_DIR3_DATA_MAGIC) {
-			struct xfs_buf		 *bp = bplist[db];
-
 			error = check_dir3_header(mp, bp, ino);
 			if (error) {
 				fixit++;
+				if (isblock)
+					goto out_fix;
 				continue;
 			}
 		}
 
 		longform_dir2_entry_check_data(mp, ip, num_illegal, need_dot,
-				irec, ino_offset, &bplist[db], hashtab,
+				irec, ino_offset, bp, hashtab,
 				&freetab, da_bno, isblock);
+		if (isblock)
+			break;
+
+		libxfs_buf_relse(bp);
 	}
 	fixit |= (*num_illegal != 0) || dir2_is_badino(ino) || *need_dot;
 
@@ -2341,7 +2303,7 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 			xfs_dir2_block_tail_t	*btp;
 			xfs_dir2_leaf_entry_t	*blp;
 
-			block = bplist[0]->b_addr;
+			block = bp->b_addr;
 			btp = xfs_dir2_block_tail_p(mp->m_dir_geo, block);
 			blp = xfs_dir2_block_leaf_p(btp);
 			seeval = dir_hash_see_all(hashtab, blp,
@@ -2358,11 +2320,10 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 		}
 	}
 out_fix:
+	if (isblock && bp)
+		libxfs_buf_relse(bp);
+
 	if (!no_modify && (fixit || dotdot_update)) {
-		dir_hash_dup_names(hashtab);
-		for (i = 0; i < num_bps; i++)
-			if (bplist[i])
-				libxfs_buf_relse(bplist[i]);
 		longform_dir2_rebuild(mp, ino, ip, irec, ino_offset, hashtab);
 		*num_illegal = 0;
 		*need_dot = 0;
@@ -2370,12 +2331,8 @@ out_fix:
 		if (fixit || dotdot_update)
 			do_warn(
 	_("would rebuild directory inode %" PRIu64 "\n"), ino);
-		for (i = 0; i < num_bps; i++)
-			if (bplist[i])
-				libxfs_buf_relse(bplist[i]);
 	}
 
-	free(bplist);
 	free(freetab);
 }
 
-- 
2.20.1

