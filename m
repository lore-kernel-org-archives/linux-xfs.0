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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4B51C433E3
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 14:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93F97619C8
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 14:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbhC3O0V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 10:26:21 -0400
Received: from sonic308-54.consmr.mail.gq1.yahoo.com ([98.137.68.30]:42338
        "EHLO sonic308-54.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232050AbhC3O0C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Mar 2021 10:26:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1617114362; bh=jQFLtUMpum7DIShm1LZrwbac5hctvXo9TuoGTQbQLxQ=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=eGwAMIA34O3nFKexh4t95uEG1styvd+ohhwmVWOg3GqxyF5fvWcDCdcKTu5VowgOl99lntXLe5vfv/ZqwHSaec5cJVcJiC7rzuANmbQdiBOY/6qNglE/gXAks9duAzwf3OmMJoIZuyJedjHXw6o3tGBV1wYu05a4XeN47T5H639LcLbrpMr2v7D63ykTiKQbyw2DLjuy59lA1o6lnvEOm0XDLIw+ODurRdBuD4R+1qS84BoFsgoi5TqKATajVaMV3YNoNhnlghkziEH+ok73jkbkfqkGl3NGczTXhYcBxoZsYjk2NmLTbQtx1Th7fe8MvwHvI+n4CHmX9gCiPLHKTg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1617114362; bh=jEg4Heqb7kfan2EkVwI/z/a0gu3wKmKJkh0orzOVSVz=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=a175LXfHur4vubWEZvWNBoUqnyYoejaHqTkcvMmnM8URDWCoL8ZWgaLG3STwBuhLd4aQzCzlQPzlUyaRX0sxfLgqUVqnEwn73Xvp23l6njp2lwBKwjh25rFRcyO+/l8POXAHkdZQYbx11SupHE/SpBQjZgq1YVVAEy+2nzjkV3ZmbgqaBmq0O6UyTEebZJ26/RbhWVrtltdVXLxkR6EnceCYFf0Z1ltb/57VXyO1CK2Z4L+VuUtqHBCUtHIzuDLYCN4MQv7qg1jb3dQ+8gJgV5t+8dUlECB/Pe+vd14pFcT1P+MyNH18WU0hrKpGoVpxV3kE04V+jWQp3xMv+489HA==
X-YMail-OSG: rNQJmlIVM1kqWm0BgdOAR2npospsgNL2AZl6dbIzZreiQijLqTdQG2Kd9xApRz9
 hppSuYDOYE5JXbcZ8FL0ZjoAKIE4a0PGgN1uKYhVMs2eMZ659niYtilkmxAtLXJoDlA_B5N8spCK
 y2MC8mdmkdj6dalHkyC1p0i8YUvymHd_BPQyXgGidoB93GK1F1uaR8Kds4cmpn_cMBAQU8jm2gyY
 d_itrTr7saYWAQoc.INQwS_pKeR5_aWaSE8kNUJyXATuX_JsTK9e.Mnnl6E7wk6Ry24_RRLT7Dzd
 0FG4Kx7Txl8_TGLQCspb2x7FtX..1aGWAg.1UMlI2t1nkOxZQ3lhaZShcASrBFOcYlXL_hTswiAd
 j.l9oCp3QdNsPFCT8tRtznGcWzM2ZnKsdnD2UPeGjEsj5nUQzL4FCDfXep4mZuILAWqA5nosV1D8
 ESVhkOFgaUDuCxN0BkRdf1_rmayCDdpCLMfX8OLkyeIkfm3YKHaSkOr23X8LMLb2_wg0gamoZeo8
 VfYHNo4SsuX3K1Tf9LgMoj8WwzDVVgrkoiIcQOeOyAC0s41hyMvq8cqGU8AyZ_2VPyVTRvfaUz6k
 eOSqYzR81geDRHQ4uSmNp2xglfxhNySsr_fCcBpVHaxSZqr2.oeTKR65febK1nSwOvOlsFS3Y_W3
 e35xEZnrFcHXuiDvINrB62wLughhsej6CpiO8swLiNTL8A2M8Q7Cih_0ME4XbGfdv8OShFzPeBAV
 lAPtSjXnoxH9K10Jv0P9zx37M_TY0TdbC1.6vAVzu2RPb2J_.U7byvxiM.yEUfbn2k4EQvDFQyfl
 YKZtGOAocMtYhCFQ7rtIGcSbadr9mYLDKVJSMuPETrmP56Yw2DUEWVohq0J76VlNawMkH1CvMnsN
 epGlZhT2VMaiPhwbqn.eopkMeG8TMxO6S5oGrER.e2z1E7Hq7WAwFTRfBMzG8eJa4L5Le2xH7hHi
 _gjTP614Zu5Hyj0X.qTnZHMVc_I6m8Aj9a3fDsVkpMMDknCUzxTorek1J0oufPqO5kA61X7py4ft
 .arQt4UCtIBW1DEaCk1AlWK70hJMCi.ii4UpKpDpARRqf.D966r8jDFeoF3GI6o6KRFswi4Gp7.6
 siy5T7I3Q3xbTKgun_MAnb1ajnoE6PtsZvZ_Bkzesera4gsAdvayGXTjsKEJf9o6EmkwcA8UOeCj
 aTMF6m1qEKvA2NVmYnawHXO2VhXTLpcBFkzUXGEdsIdDn1Z9P60nzaQHTkf5OgkOMkUPDi7gz83p
 mLUXjhtUMEtbHeP25niNeBNMllQIINlXLoU5eR2_SA6qBr8wvQcEb3QtvDbKKDEVcBovcBeDvsQI
 OvU5_528LK1mHVaOKylllO7BUA6BncOqlQB3CpNQWh2ae0ep2HVdNvvOZwrstH2GirJpvSa_omN7
 isDWa9OiuEnly1urCyRnUszyFwd__JM0E6u4EaU6uJkZ2k4JzH8EzJOjCDABgHItzlJEOnOuRbFh
 Silj9cdvwVMkMH.6ZaDzE5D56ejyzO9WNmcfF30mORHfknKO1DcugO2eQ7uM3HXPWNTMJWARRUDH
 MEWofAdWGO7hIIUHCp.2M.XQegujtkWTTrgIW_Mxvo4haIU6WijGIpFVOlf.4yqrYgxgjfiX5T1O
 V58wHFMdKXGmk2b76QYG6FUaJ4VHKyr0N8JDEGLvpxsCxWiAWdbp6i6SwU9CZEbjFPaV_EjnM3rO
 HsQxX_n9vworgqKfj9xEqruycgfMDe9fnPDMOuBYevX_cEA91ZcRobAaKx5zSLL9NI0qaJDROsFi
 QnVRoyJTPeSpB9JNorgBcoBjRAlUG5BqPhOtbUOYVPDyy4fdkqADFjzeEfZO3iu3v9WguerLZuSC
 kBksDJTIu0yWr62Iccpp82PhN2DrCwj4HikeXt9sA9q2rT_ZJNgDbL6iDBhr28W.EK_sueYEVoyA
 sWMJwB_Snaxk0AflRMNS7kciRvmnLVLU9BX6p7jhcTrDd8IbjOgxK7o_wD8ilYvxaAfE1KwmM4nV
 lbDx42SesAduKL7ldVT5zwv7aW4_qS3qR9d1.06krQEKlgDgBLvB.xIfoxLRU1yAi.hcr9k9tCbm
 lBfM3fOJLaZnaGi59cfCj8w2Ql6jGZCNCQjjp5Z0Qp0voBhsNnbGdAq.lodOi766g2y.7CSsYmlA
 5gsUxCTa3sJPQ6LDoJk2e5Ga5HJZIWkoeHf_kqEvA1FWcK6u9bk8TncbSmNkXU562XR1_dBu30xF
 hZujT098J7sUAlBf7OE0sai_8NRR_MsyggOUyrWK.C_PnUH5qvAoklsCTpvJWkDSKhG.Rg386Qh_
 RXdmu1m5Af.MICnqe_UQ083ZI1KdSARstL8puZSghC863GgK3hl6QlHtiPDS4gyeEXFXL1.1hon.
 yswdTzWSB9x_lmRWmoKVDOnISyL.UXDay.HlxrvVMeKhpZOLfQH1noSetVwJPANDLg4Sr_PngPJC
 .NBSom_TM4qZb3HJHvAN_4ym7O3bRMON7_CnSlMdCXLW5bYij1zBzDqJ_kPgN0BwNiMqgwirqhlz
 p0eG6kSIKvFtWiqQ_R5khAugshVWt_uYjl6iE8tp63jpJ9jwLizuuI0Gy2ZwqvnqcXrhZEOuIEiM
 .5TjiWq7b4NmccrGD2WFd3MzSkoKD31DTi3CbGRR3kTsn9Iojhh3OqvA9pZCKLTX8NEiGCJsWrpT
 eA3ogMQ3TC4qOm4PlCGOxg_g-
X-Sonic-MF: <hsiangkao@aol.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.gq1.yahoo.com with HTTP; Tue, 30 Mar 2021 14:26:02 +0000
Received: by kubenode575.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID d17ac850f756223f45b54c36ad526fbe;
          Tue, 30 Mar 2021 14:25:59 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v3 6/8] repair: don't duplicate names in phase 6
Date:   Tue, 30 Mar 2021 22:25:29 +0800
Message-Id: <20210330142531.19809-7-hsiangkao@aol.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210330142531.19809-1-hsiangkao@aol.com>
References: <20210330142531.19809-1-hsiangkao@aol.com>
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

