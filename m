Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3717C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:47:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB5E9601FD
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:47:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbhGZLHS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 07:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbhGZLHR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 07:07:17 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5FFC061757
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:47:45 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso6499586pjo.1
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dtxvKEJ+o5ItSJMGy2HbfTVEo6DK2uET6FJJyaR85Kk=;
        b=ZPkhV/vhsV5WLmr4VQcTa1AXMApvOn7gG1i83oAty6wloN8ndYs+r7xUyAYaCrtr+q
         hkn557cW7BSqTHgQIKFDUZ1W8uxnZgv74HU8BgTQs82M+ODkvIPIpod0NBvsq/HodTBj
         dPxt0PJZFV/7Yo250Iv2H67lxG+4bSidqlobIQXwkqFdTX7WB58hIV+Ggjuics/hTJLM
         92Al6FV3OxMbdZiZZtIqNGeWZsSQ0PIshEpNnjee4vgIZo2rS/1S5k49b5n1ZZ7V2y5R
         mCCOKBxTwCIC9W0AdwAOMRJPbHgj7SdCBIE7tUvP5MvDhT80J5RpWaRfxSSdCLOrPDhV
         w/KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dtxvKEJ+o5ItSJMGy2HbfTVEo6DK2uET6FJJyaR85Kk=;
        b=dwBZtJl3ONgYt5nt7x4vII74hZ2cB0nHQ7bw48668xRXc5qSiqDgOFoHXFvNGc8GOA
         a8PytolEKxgi1G37mIEaj2zf6UVYm/mUqaBhlbHKCoqb4Urrk5Ox/nzTDqDByTAtquBf
         2iB3/G9CV9Nu1R66HTo5uulXEr3JBQjfNxWACgwWOkRAGT4y31M5rYrFkQ0ovsvlhv2X
         viALTvHb2jPRNTWWW0tWsGYnvkJ4eMUnh5xnXWyAabjIabqTLhf3AbJ9dgJla7MOpoh1
         LCEo05r7u6/sxa5c165lyWbBDYVudq0tqlXgaUixjaId684ECCJudhLeNB6SMKBKa+4f
         vEuQ==
X-Gm-Message-State: AOAM532XNHUdjaBCziP/fJAVoZckjtSPiUJ0cSK16ywMtpJ6A7DXXbKe
        6Ygbs/P/UXYjW5SHwYbHOdIyPP3vwGk=
X-Google-Smtp-Source: ABdhPJzvMZmAXxeCLKddLEqNJJW34sGwhLM9josEy0pt0XZxm9u95Hw3uVl5tgeE8WCEG1cxvuhOGA==
X-Received: by 2002:a17:902:8c83:b029:11b:3f49:f88c with SMTP id t3-20020a1709028c83b029011b3f49f88cmr13920732plo.63.1627300065148;
        Mon, 26 Jul 2021 04:47:45 -0700 (PDT)
Received: from localhost.localdomain ([122.179.41.55])
        by smtp.gmail.com with ESMTPSA id y10sm35936900pjy.18.2021.07.26.04.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 04:47:44 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org
Subject: [PATCH V2 06/12] xfsprogs: xfs_dfork_nextents: Return extent count via an out argument
Date:   Mon, 26 Jul 2021 17:17:18 +0530
Message-Id: <20210726114724.24956-7-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726114724.24956-1-chandanrlinux@gmail.com>
References: <20210726114724.24956-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit changes xfs_dfork_nextents() to return an error code. The extent
count itself is now returned through an out argument. This facility will be
used by a future commit to indicate an inconsistent ondisk extent count.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 db/bmap.c               | 19 +++++++++-----
 db/btdump.c             | 11 +++++---
 db/check.c              | 23 ++++++++++++++---
 db/frag.c               |  7 ++---
 db/inode.c              | 28 +++++++++++++++-----
 db/metadump.c           | 12 +++++++--
 libxfs/xfs_inode_buf.c  | 29 +++++++++++++--------
 libxfs/xfs_inode_buf.h  |  4 +--
 libxfs/xfs_inode_fork.c | 26 ++++++++++++++-----
 repair/attr_repair.c    | 11 +++++---
 repair/bmap_repair.c    | 12 +++++++--
 repair/dinode.c         | 57 +++++++++++++++++++++++++++++++----------
 repair/prefetch.c       |  7 +++--
 13 files changed, 181 insertions(+), 65 deletions(-)

diff --git a/db/bmap.c b/db/bmap.c
index 5e1ab9258..5846e2c83 100644
--- a/db/bmap.c
+++ b/db/bmap.c
@@ -68,11 +68,13 @@ bmap(
 	ASSERT(fmt == XFS_DINODE_FMT_LOCAL || fmt == XFS_DINODE_FMT_EXTENTS ||
 		fmt == XFS_DINODE_FMT_BTREE);
 	if (fmt == XFS_DINODE_FMT_EXTENTS) {
-		nextents = xfs_dfork_nextents(mp, dip, whichfork);
-		xp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
-		for (ep = xp; ep < &xp[nextents] && n < nex; ep++) {
-			if (!bmap_one_extent(ep, &curoffset, eoffset, &n, bep))
-				break;
+		if (!xfs_dfork_nextents(mp, dip, whichfork, &nextents)) {
+			xp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
+			for (ep = xp; ep < &xp[nextents] && n < nex; ep++) {
+				if (!bmap_one_extent(ep, &curoffset, eoffset,
+						&n, bep))
+					break;
+			}
 		}
 	} else if (fmt == XFS_DINODE_FMT_BTREE) {
 		push_cur();
@@ -155,12 +157,15 @@ bmap_f(
 		}
 	}
 	if (afork + dfork == 0) {
+		xfs_extnum_t nextents;
 		push_cur();
 		set_cur_inode(iocur_top->ino);
 		dip = iocur_top->data;
-		if (xfs_dfork_nextents(mp, dip, XFS_DATA_FORK))
+		if (!xfs_dfork_nextents(mp, dip, XFS_DATA_FORK, &nextents) &&
+		    nextents)
 			dfork = 1;
-		if (xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK))
+		if (!xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK, &nextents) &&
+		    nextents)
 			afork = 1;
 		pop_cur();
 	}
diff --git a/db/btdump.c b/db/btdump.c
index 59609fd2d..b1d16d919 100644
--- a/db/btdump.c
+++ b/db/btdump.c
@@ -153,6 +153,7 @@ dump_inode(
 	bool			dump_node_blocks,
 	bool			attrfork)
 {
+	xfs_extnum_t		nextents;
 	char			*prefix;
 	struct xfs_dinode	*dip;
 	int			ret = 0;
@@ -166,14 +167,16 @@ dump_inode(
 
 	dip = iocur_top->data;
 	if (attrfork) {
-		if (!xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK) ||
-		    dip->di_aformat != XFS_DINODE_FMT_BTREE) {
+		if (xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK, &nextents))
+			return -1;
+		if (!nextents || dip->di_aformat != XFS_DINODE_FMT_BTREE) {
 			dbprintf(_("attr fork not in btree format\n"));
 			return 0;
 		}
 	} else {
-		if (!xfs_dfork_nextents(mp, dip, XFS_DATA_FORK) ||
-		    dip->di_format != XFS_DINODE_FMT_BTREE) {
+		if (xfs_dfork_nextents(mp, dip, XFS_DATA_FORK, &nextents))
+			return -1;
+		if (!nextents || dip->di_format != XFS_DINODE_FMT_BTREE) {
 			dbprintf(_("data fork not in btree format\n"));
 			return 0;
 		}
diff --git a/db/check.c b/db/check.c
index fe422e0ca..45aaa8445 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2718,10 +2718,17 @@ process_exinode(
 	int			whichfork)
 {
 	xfs_bmbt_rec_t		*rp;
+	int			ret;
 
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
-	*nex = xfs_dfork_nextents(mp, dip, whichfork);
-	if (*nex < 0 || *nex > XFS_DFORK_SIZE(dip, mp, whichfork) /
+	ret = xfs_dfork_nextents(mp, dip, whichfork, nex);
+	if (ret) {
+		if (!sflag || id->ilist)
+			dbprintf(_("Corrupt extent count for inode %lld\n"),
+				id->ino);
+		error++;
+		return;
+	} else if (*nex < 0 || *nex > XFS_DFORK_SIZE(dip, mp, whichfork) /
 						sizeof(xfs_bmbt_rec_t)) {
 		if (!sflag || id->ilist)
 			dbprintf(_("bad number of extents %d for inode %lld\n"),
@@ -2881,8 +2888,16 @@ process_inode(
 		return;
 	}
 
-	dnextents = xfs_dfork_nextents(mp, dip, XFS_DATA_FORK);
-	danextents = xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK);
+	if (xfs_dfork_nextents(mp, dip, XFS_DATA_FORK, &dnextents)) {
+		if (v)
+			dbprintf(_("Corrupt extent count for inode %lld\n"),
+				id->ino);
+		error++;
+		return;
+	}
+
+	if (xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK, &danextents))
+		ASSERT(0);
 
 	if (verbose || (id && id->ilist) || CHECK_BLIST(bno))
 		dbprintf(_("inode %lld mode %#o fmt %s "
diff --git a/db/frag.c b/db/frag.c
index 3e43a9a21..f1816b32f 100644
--- a/db/frag.c
+++ b/db/frag.c
@@ -263,9 +263,11 @@ process_exinode(
 {
 	xfs_bmbt_rec_t		*rp;
 	xfs_extnum_t		nextents;
+	int			error;
 
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
-	nextents = xfs_dfork_nextents(mp, dip, whichfork);
+	error = xfs_dfork_nextents(mp, dip, whichfork, &nextents);
+	ASSERT(error == 0);
 	process_bmbt_reclist(rp, nextents, extmapp);
 }
 
@@ -277,8 +279,7 @@ process_fork(
 	extmap_t	*extmap;
 	xfs_extnum_t	nex;
 
-	nex = xfs_dfork_nextents(mp, dip, whichfork);
-	if (!nex)
+	if (xfs_dfork_nextents(mp, dip, whichfork, &nex) || !nex)
 		return;
 	extmap = extmap_alloc(nex);
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
diff --git a/db/inode.c b/db/inode.c
index 681f4f98a..e3b7d04c0 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -269,6 +269,7 @@ inode_a_bmx_count(
 	void		*obj,
 	int		startoff)
 {
+	xfs_extnum_t	nextents;
 	xfs_dinode_t	*dip;
 
 	ASSERT(bitoffs(startoff) == 0);
@@ -277,8 +278,13 @@ inode_a_bmx_count(
 	if (!dip->di_forkoff)
 		return 0;
 	ASSERT((char *)XFS_DFORK_APTR(dip) - (char *)dip == byteize(startoff));
-	return dip->di_aformat == XFS_DINODE_FMT_EXTENTS ?
-		xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK) : 0;
+
+	if (dip->di_aformat != XFS_DINODE_FMT_EXTENTS ||
+		xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK, &nextents)) {
+			nextents = 0;
+	}
+
+        return nextents;
 }
 
 static int
@@ -342,7 +348,8 @@ inode_a_size(
 		asf = (struct xfs_attr_shortform *)XFS_DFORK_APTR(dip);
 		return bitize(be16_to_cpu(asf->hdr.totsize));
 	case XFS_DINODE_FMT_EXTENTS:
-		nextents = xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK);
+		if (xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK, &nextents))
+			nextents = 0;
 		return (int)nextents * bitsz(xfs_bmbt_rec_t);
 	case XFS_DINODE_FMT_BTREE:
 		return bitize((int)XFS_DFORK_ASIZE(dip, mp));
@@ -497,14 +504,20 @@ inode_u_bmx_count(
 	void		*obj,
 	int		startoff)
 {
+	xfs_extnum_t	nextents;
 	xfs_dinode_t	*dip;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
 	dip = obj;
 	ASSERT((char *)XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
-	return dip->di_format == XFS_DINODE_FMT_EXTENTS ?
-		xfs_dfork_nextents(mp, dip, XFS_DATA_FORK) : 0;
+
+	if (dip->di_format != XFS_DINODE_FMT_EXTENTS ||
+		xfs_dfork_nextents(mp, dip, XFS_DATA_FORK, &nextents)) {
+		nextents = 0;
+	}
+
+        return nextents;
 }
 
 static int
@@ -590,7 +603,7 @@ inode_u_size(
 	int		idx)
 {
 	xfs_dinode_t	*dip;
-	xfs_extnum_t	nextents;
+	xfs_extnum_t	nextents = 0;
 
 	ASSERT(startoff == 0);
 	ASSERT(idx == 0);
@@ -601,7 +614,8 @@ inode_u_size(
 	case XFS_DINODE_FMT_LOCAL:
 		return bitize((int)be64_to_cpu(dip->di_size));
 	case XFS_DINODE_FMT_EXTENTS:
-		nextents = xfs_dfork_nextents(mp, dip, XFS_DATA_FORK);
+		if (xfs_dfork_nextents(mp, dip, XFS_DATA_FORK, &nextents))
+			nextents = 0;
 		return (int)nextents * bitsz(xfs_bmbt_rec_t);
 	case XFS_DINODE_FMT_BTREE:
 		return bitize((int)XFS_DFORK_DSIZE(dip, mp));
diff --git a/db/metadump.c b/db/metadump.c
index c194501d0..1b63b3179 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2314,7 +2314,13 @@ process_exinode(
 
 	whichfork = (itype == TYP_ATTR) ? XFS_ATTR_FORK : XFS_DATA_FORK;
 
-	nex = xfs_dfork_nextents(mp, dip, whichfork);
+	if (xfs_dfork_nextents(mp, dip, whichfork, &nex)) {
+		if (show_warnings)
+			print_warning("Corrupt extent count for inode %lld\n",
+				(long long)cur_ino);
+		return 1;
+	}
+
 	used = nex * sizeof(xfs_bmbt_rec_t);
 	if (nex < 0 || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
 		if (show_warnings)
@@ -2369,7 +2375,9 @@ static int
 process_dev_inode(
 	xfs_dinode_t		*dip)
 {
-	if (xfs_dfork_nextents(mp, dip, XFS_DATA_FORK)) {
+	xfs_extnum_t		nextents;
+
+	if (xfs_dfork_nextents(mp, dip, XFS_DATA_FORK, &nextents) || nextents) {
 		if (show_warnings)
 			print_warning("inode %llu has unexpected extents",
 				      (unsigned long long)cur_ino);
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 8d52ce186..353050365 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -342,7 +342,8 @@ xfs_dinode_verify_fork(
 	xfs_extnum_t		di_nextents;
 	xfs_extnum_t		max_extents;
 
-	di_nextents = xfs_dfork_nextents(mp, dip, whichfork);
+        if (xfs_dfork_nextents(mp, dip, whichfork, &di_nextents))
+		return __this_address;
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
 	case XFS_DINODE_FMT_LOCAL:
@@ -374,29 +375,31 @@ xfs_dinode_verify_fork(
 	return NULL;
 }
 
-xfs_extnum_t
+int
 xfs_dfork_nextents(
 	struct xfs_mount	*mp,
 	struct xfs_dinode	*dip,
-	int			whichfork)
+	int			whichfork,
+	xfs_extnum_t		*nextents)
 {
-	xfs_extnum_t		nextents = 0;
+	int			error = 0;
 
 	switch (whichfork) {
 	case XFS_DATA_FORK:
-		nextents = be32_to_cpu(dip->di_nextents);
+		*nextents = be32_to_cpu(dip->di_nextents);
 		break;
 
 	case XFS_ATTR_FORK:
-		nextents = be16_to_cpu(dip->di_anextents);
+		*nextents = be16_to_cpu(dip->di_anextents);
 		break;
 
 	default:
 		ASSERT(0);
+		error = -EINVAL;
 		break;
 	}
 
-	return nextents;
+	return error;
 }
 
 static xfs_failaddr_t
@@ -500,6 +503,7 @@ xfs_dinode_verify(
 	uint64_t		di_size;
 	uint64_t		nblocks;
 	xfs_extnum_t            nextents;
+	xfs_extnum_t            naextents;
 
 	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
 		return __this_address;
@@ -530,8 +534,13 @@ xfs_dinode_verify(
 	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
 		return __this_address;
 
-	nextents = xfs_dfork_nextents(mp, dip, XFS_DATA_FORK);
-	nextents += xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK);
+	if (xfs_dfork_nextents(mp, dip, XFS_DATA_FORK, &nextents))
+		return __this_address;
+
+	if (xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK, &naextents))
+		return __this_address;
+
+	nextents += naextents;
 	nblocks = be64_to_cpu(dip->di_nblocks);
 
         /* Fork checks carried over from xfs_iformat_fork */
@@ -592,7 +601,7 @@ xfs_dinode_verify(
 		default:
 			return __this_address;
 		}
-		if (xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK))
+		if (naextents)
 			return __this_address;
 	}
 
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index ea2c35091..20f796610 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
@@ -36,8 +36,8 @@ xfs_failaddr_t xfs_inode_validate_extsize(struct xfs_mount *mp,
 xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
 		uint32_t cowextsize, uint16_t mode, uint16_t flags,
 		uint64_t flags2);
-xfs_extnum_t xfs_dfork_nextents(struct xfs_mount *mp, struct xfs_dinode *dip,
-		int whichfork);
+int xfs_dfork_nextents(struct xfs_mount *mp, struct xfs_dinode *dip,
+		int whichfork, xfs_extnum_t *nextents);
 
 static inline uint64_t xfs_inode_encode_bigtime(struct timespec64 tv)
 {
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 831313e3a..699bac823 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -105,12 +105,19 @@ xfs_iformat_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	xfs_extnum_t		nex = xfs_dfork_nextents(mp, dip, whichfork);
-	int			size = nex * sizeof(xfs_bmbt_rec_t);
+	xfs_extnum_t		nex;
+	int			size;
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
 	struct xfs_bmbt_irec	new;
-	int			i;
+	int			error;
+	xfs_extnum_t		i;
+
+	error = xfs_dfork_nextents(mp, dip, whichfork, &nex);
+	if (error)
+		return error;
+
+	size = nex * sizeof(xfs_bmbt_rec_t);
 
 	/*
 	 * If the number of extents is unreasonable, then something is wrong and
@@ -233,7 +240,11 @@ xfs_iformat_data_fork(
 	 * depend on it.
 	 */
 	ip->i_df.if_format = dip->di_format;
-	ip->i_df.if_nextents = xfs_dfork_nextents(mp, dip, XFS_DATA_FORK);
+
+	error = xfs_dfork_nextents(mp, dip, XFS_DATA_FORK,
+		&ip->i_df.if_nextents);
+	if (error)
+		return error;
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFIFO:
@@ -304,11 +315,14 @@ xfs_iformat_attr_fork(
 	xfs_extnum_t		nextents;
 	int			error = 0;
 
-	/*
+	error = xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK, &nextents);
+	if (error)
+		return error;
+
+        /*
 	 * Initialize the extent count early, as the per-format routines may
 	 * depend on it.
 	 */
-	nextents = xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK);
 	ip->i_afp = xfs_ifork_alloc(dip->di_aformat, nextents);
 
 	switch (ip->i_afp->if_format) {
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 0a461b675..c6c30210f 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -1073,6 +1073,7 @@ process_longform_attr(
 	struct blkmap		*blkmap,
 	int			*repair) /* out - 1 if something was fixed */
 {
+	xfs_extnum_t		anextents;
 	xfs_fsblock_t		bno;
 	struct xfs_buf		*bp;
 	struct xfs_da_blkinfo	*info;
@@ -1082,9 +1083,13 @@ process_longform_attr(
 
 	bno = blkmap_get(blkmap, 0);
 	if (bno == NULLFSBLOCK) {
-		if (dip->di_aformat == XFS_DINODE_FMT_EXTENTS &&
-			xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK) == 0)
-			return(0); /* the kernel can handle this state */
+		if (dip->di_aformat == XFS_DINODE_FMT_EXTENTS) {
+			error = xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK,
+					&anextents);
+			ASSERT(error == 0);
+			if (anextents == 0)
+				return(0); /* the kernel can handle this state */
+		}
 		do_warn(
 	_("block 0 of inode %" PRIu64 " attribute fork is missing\n"),
 			ino);
diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
index 2e0475db1..84f3a7048 100644
--- a/repair/bmap_repair.c
+++ b/repair/bmap_repair.c
@@ -14,6 +14,7 @@
 #include "rmap.h"
 #include "bulkload.h"
 #include "bmap_repair.h"
+#include "xfs_inode_buf.h"
 
 #define min_t(type, x, y) ( ((type)(x)) > ((type)(y)) ? ((type)(y)) : ((type)(x)) )
 
@@ -516,6 +517,7 @@ rebuild_bmap(
 	struct xfs_buf		*bp;
 	unsigned long long	resblks;
 	xfs_daddr_t		bp_bn;
+	xfs_extnum_t		nextents;
 	int			bp_length;
 	int			error;
 
@@ -528,7 +530,10 @@ rebuild_bmap(
 	 */
 	switch (whichfork) {
 	case XFS_DATA_FORK:
-		if (!xfs_dfork_nextents(mp, *dinop, XFS_DATA_FORK))
+		error = xfs_dfork_nextents(mp, *dinop, whichfork, &nextents);
+		if (error)
+			return error;
+		if (nextents == 0)
 			return 0;
 		(*dinop)->di_format = XFS_DINODE_FMT_EXTENTS;
 		(*dinop)->di_nextents = 0;
@@ -536,7 +541,10 @@ rebuild_bmap(
 		*dirty = 1;
 		break;
 	case XFS_ATTR_FORK:
-		if (!xfs_dfork_nextents(mp, *dinop, XFS_ATTR_FORK))
+		error = xfs_dfork_nextents(mp, *dinop, whichfork, &nextents);
+		if (error)
+			return error;
+		if (nextents == 0)
 			return 0;
 		(*dinop)->di_aformat = XFS_DINODE_FMT_EXTENTS;
 		(*dinop)->di_anextents = 0;
diff --git a/repair/dinode.c b/repair/dinode.c
index 6cc5bce5c..096335191 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -60,6 +60,9 @@ get_forkname(int whichfork)
 static int
 clear_dinode_attr(xfs_mount_t *mp, xfs_dinode_t *dino, xfs_ino_t ino_num)
 {
+	xfs_extnum_t anextents;
+	int err;
+
 	ASSERT(dino->di_forkoff != 0);
 
 	if (!no_modify)
@@ -69,7 +72,10 @@ _("clearing inode %" PRIu64 " attributes\n"), ino_num);
 		fprintf(stderr,
 _("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
 
-	if (xfs_dfork_nextents(mp, dino, XFS_ATTR_FORK) != 0) {
+	err = xfs_dfork_nextents(mp, dino, XFS_ATTR_FORK, &anextents);
+	ASSERT(err == 0);
+
+	if (anextents != 0) {
 		if (no_modify)
 			return(1);
 		dino->di_anextents = cpu_to_be16(0);
@@ -973,7 +979,8 @@ process_exinode(
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
 	*tot = 0;
-	numrecs = xfs_dfork_nextents(mp, dip, whichfork);
+	ret = xfs_dfork_nextents(mp, dip, whichfork, &numrecs);
+	ASSERT(ret == 0);
 
 	/*
 	 * We've already decided on the maximum number of extents on the inode,
@@ -1053,6 +1060,7 @@ process_symlink_extlist(xfs_mount_t *mp, xfs_ino_t lino, xfs_dinode_t *dino)
 	xfs_extnum_t		numrecs;
 	int			i;
 	int			max_blocks;
+	int			ret;
 
 	if (be64_to_cpu(dino->di_size) <= XFS_DFORK_DSIZE(dino, mp)) {
 		if (dino->di_format == XFS_DINODE_FMT_LOCAL)
@@ -1072,7 +1080,8 @@ _("mismatch between format (%d) and size (%" PRId64 ") in symlink inode %" PRIu6
 	}
 
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_DPTR(dino);
-	numrecs = xfs_dfork_nextents(mp, dino, XFS_DATA_FORK);
+	ret = xfs_dfork_nextents(mp, dino, XFS_DATA_FORK, &numrecs);
+	ASSERT(ret == 0);
 
 	/*
 	 * the max # of extents in a symlink inode is equal to the
@@ -1579,6 +1588,7 @@ process_check_sb_inodes(
 	int		*dirty)
 {
 	xfs_extnum_t	nextents;
+	int		ret;
 
 	if (lino == mp->m_sb.sb_rootino) {
 		if (*type != XR_INO_DIR)  {
@@ -1635,7 +1645,9 @@ _("realtime summary inode %" PRIu64 " has bad type 0x%x, "),
 			}
 		}
 
-		nextents = xfs_dfork_nextents(mp, dinoc, XFS_DATA_FORK);
+		ret = xfs_dfork_nextents(mp, dinoc, XFS_DATA_FORK, &nextents);
+		ASSERT(ret == 0);
+
 		if (mp->m_sb.sb_rblocks == 0 && nextents != 0)  {
 			do_warn(
 _("bad # of extents (%d) for realtime summary inode %" PRIu64 "\n"),
@@ -1658,8 +1670,10 @@ _("realtime bitmap inode %" PRIu64 " has bad type 0x%x, "),
 			}
 		}
 
-		nextents = xfs_dfork_nextents(mp, dinoc, XFS_DATA_FORK);
-		if (mp->m_sb.sb_rblocks == 0 && nextents != 0)  {
+		ret = xfs_dfork_nextents(mp, dinoc, XFS_DATA_FORK, &nextents);
+		ASSERT(ret == 0);
+
+                if (mp->m_sb.sb_rblocks == 0 && nextents != 0)  {
 			do_warn(
 _("bad # of extents (%d) for realtime bitmap inode %" PRIu64 "\n"),
 				nextents, lino);
@@ -1823,6 +1837,7 @@ process_inode_blocks_and_extents(
 	int		*dirty)
 {
 	xfs_extnum_t		dnextents;
+	int			ret;
 
 	if (nblocks != be64_to_cpu(dino->di_nblocks))  {
 		if (!no_modify)  {
@@ -1847,7 +1862,9 @@ _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 		return 1;
 	}
 
-	dnextents = xfs_dfork_nextents(mp, dino, XFS_DATA_FORK);
+	ret = xfs_dfork_nextents(mp, dino, XFS_DATA_FORK, &dnextents);
+	ASSERT(ret == 0);
+
 	if (nextents != dnextents)  {
 		if (!no_modify)  {
 			do_warn(
@@ -1869,7 +1886,9 @@ _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 		return 1;
 	}
 
-	dnextents = xfs_dfork_nextents(mp, dino, XFS_ATTR_FORK);
+	ret = xfs_dfork_nextents(mp, dino, XFS_ATTR_FORK, &dnextents);
+	ASSERT(ret == 0);
+
 	if (anextents != dnextents)  {
 		if (!no_modify)  {
 			do_warn(
@@ -1920,6 +1939,7 @@ process_inode_data_fork(
 	xfs_extnum_t		nex;
 	int			err = 0;
 	int			try_rebuild = -1; /* don't know yet */
+	int			ret;
 
 retry:
 	/*
@@ -1927,7 +1947,9 @@ retry:
 	 * uses negative values in memory. hence if we see negative numbers
 	 * here, trash it!
 	 */
-	nex = xfs_dfork_nextents(mp, dino, XFS_DATA_FORK);
+	ret = xfs_dfork_nextents(mp, dino, XFS_DATA_FORK, &nex);
+	ASSERT(ret == 0);
+
 	if (nex < 0)
 		*nextents = 1;
 	else
@@ -2076,8 +2098,11 @@ retry:
 		return 0;
 	}
 
-	*anextents = xfs_dfork_nextents(mp, dino, XFS_ATTR_FORK);
-	if (*anextents > be64_to_cpu(dino->di_nblocks))
+	err = xfs_dfork_nextents(mp, dino, XFS_ATTR_FORK,
+			(xfs_extnum_t *)anextents);
+	ASSERT(err == 0);
+
+        if (*anextents > be64_to_cpu(dino->di_nblocks))
 		*anextents = 1;
 
 	switch (dino->di_aformat) {
@@ -2126,8 +2151,10 @@ retry:
 			if (try_rebuild == 1) {
 				xfs_extnum_t danextents;
 
-				danextents = xfs_dfork_nextents(mp, dino,
-						XFS_ATTR_FORK);
+				err = xfs_dfork_nextents(mp, dino,
+						XFS_ATTR_FORK, &danextents);
+				ASSERT(err == 0);
+
 				do_warn(
 _("rebuilding inode %"PRIu64" attr fork\n"),
 					lino);
@@ -2831,6 +2858,10 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 		goto clear_bad_out;
 	}
 
+	if (xfs_dfork_nextents(mp, dino, XFS_DATA_FORK,
+		(xfs_extnum_t *)&nextents))
+		goto clear_bad_out;
+
 	/*
 	 * type checks for superblock inodes
 	 */
diff --git a/repair/prefetch.c b/repair/prefetch.c
index b8d11ead0..5ba0ecaa9 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -392,8 +392,11 @@ pf_read_exinode(
 	prefetch_args_t		*args,
 	xfs_dinode_t		*dino)
 {
-	pf_read_bmbt_reclist(args, (xfs_bmbt_rec_t *)XFS_DFORK_DPTR(dino),
-			xfs_dfork_nextents(mp, dino, XFS_DATA_FORK));
+	xfs_extnum_t		nextents;
+
+	if (!xfs_dfork_nextents(mp, dino, XFS_DATA_FORK, &nextents))
+		pf_read_bmbt_reclist(args,
+			(xfs_bmbt_rec_t *)XFS_DFORK_DPTR(dino), nextents);
 }
 
 static void
-- 
2.30.2

