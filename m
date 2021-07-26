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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91F55C432BE
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:46:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7971A601FD
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:46:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233534AbhGZLFf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 07:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233529AbhGZLFf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 07:05:35 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E3BC061757
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:46:03 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id i10so8135746pla.3
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F+r72Te+F8cUTUcRAmXJ3uWdLTbuw0R9WiR1Ocn6a+A=;
        b=fXHTuMNDTXj1NPJOQ6YI/LDooRGEsMpen0eufFxYBqPEBPm3Xzx9fpl8tzY6P8PZo+
         IT5sw1KZJk3sHTMXL5kUA6Sc/9I2/8TbEK5+xeUNjoILed1A0yVNeVP0CddyBOCD3czC
         objAOcePEdYmJ4M/hScVfl9reWfeC7lS/hdgK+QT0ZAoivNMQlc8QGy+XkHHUOeO3u/8
         rYBRL3sVTYWVGVv6+Jj/E5NM+47U29PDvgMlt+ZKZT+qXWwACU2tWZ0xBfBNzw1nEkRi
         Cs9uVSaG2MuOgyFtUhgks8sqsn1SMw+m8V8LI653F2+FfBUpA0qiHlxsPTz1qNaPa7Wy
         IHOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F+r72Te+F8cUTUcRAmXJ3uWdLTbuw0R9WiR1Ocn6a+A=;
        b=ihMw+NQ41bc+kGisNx0MPqtQSTWAU8+vvKYIBzKS8XtDB1WYGw0n0jNC2ceIi26DdX
         epAKDODSSEZHHI9pNbH9VzICRyKso6Co+rxDrjL90K7KdrAuAd4ZskkW0IiRm3MeGPv4
         ejgmXfi1xHqy1wrl43tWz2+HrZue36tCLH5WQ3ki+msA+gSLsfirlA13Z0GTM762X2uc
         GS4Uen6Kzpnpmold1U5+kn93Wtqb7xi9vZSD6RUeASJ8G3iHwfN8fGL/zY9UQF1qen3L
         H8N7buOL85bpFOtAvAd/TRqP9MbO5vJh3bvYEkXgHE9i0shsiKPfH5nhtpPX27Tow87v
         kKiw==
X-Gm-Message-State: AOAM53048mQmfv8aKRoNm8yMoRXwrwg8eFPDtu7/JyTvsgV60dGqdkrS
        /fWBBigv09jHpORAWyfc5213f2lcCQc=
X-Google-Smtp-Source: ABdhPJw15JE87XCntKGbglwOqO8clyBa7tnvBoIGcJqfTxpEmBo6Rfs8uFhQNVSgPcEv/57rOqGnIw==
X-Received: by 2002:a62:5a86:0:b029:334:567b:d80e with SMTP id o128-20020a625a860000b0290334567bd80emr17478914pfb.44.1627299962564;
        Mon, 26 Jul 2021 04:46:02 -0700 (PDT)
Received: from localhost.localdomain ([122.179.41.55])
        by smtp.gmail.com with ESMTPSA id k8sm50833919pgr.91.2021.07.26.04.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 04:46:02 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org
Subject: [PATCH V2 06/12] xfs: xfs_dfork_nextents: Return extent count via an out argument
Date:   Mon, 26 Jul 2021 17:15:35 +0530
Message-Id: <20210726114541.24898-7-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726114541.24898-1-chandanrlinux@gmail.com>
References: <20210726114541.24898-1-chandanrlinux@gmail.com>
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
 fs/xfs/libxfs/xfs_inode_buf.c  | 29 +++++++----
 fs/xfs/libxfs/xfs_inode_buf.h  |  4 +-
 fs/xfs/libxfs/xfs_inode_fork.c | 22 ++++++--
 fs/xfs/scrub/inode.c           | 94 +++++++++++++++++++++-------------
 fs/xfs/scrub/inode_repair.c    | 34 ++++++++----
 5 files changed, 119 insertions(+), 64 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 6bef0757fca4..9ed04da2e2b1 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -345,7 +345,8 @@ xfs_dinode_verify_fork(
 	xfs_extnum_t		di_nextents;
 	xfs_extnum_t		max_extents;
 
-	di_nextents = xfs_dfork_nextents(mp, dip, whichfork);
+	if (xfs_dfork_nextents(mp, dip, whichfork, &di_nextents))
+		return __this_address;
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
 	case XFS_DINODE_FMT_LOCAL:
@@ -377,29 +378,31 @@ xfs_dinode_verify_fork(
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
@@ -502,6 +505,7 @@ xfs_dinode_verify(
 	uint64_t		flags2;
 	uint64_t		di_size;
 	xfs_extnum_t            nextents;
+	xfs_extnum_t            naextents;
 	int64_t			nblocks;
 
 	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
@@ -533,8 +537,13 @@ xfs_dinode_verify(
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
@@ -595,7 +604,7 @@ xfs_dinode_verify(
 		default:
 			return __this_address;
 		}
-		if (xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK))
+		if (naextents)
 			return __this_address;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index ea2c35091609..20f796610d46 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
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
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 38dd2dfc31fa..7f7ffe29436d 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -107,13 +107,20 @@ xfs_iformat_extents(
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
+	int			error;
 	int			i;
 
+	error = xfs_dfork_nextents(mp, dip, whichfork, &nex);
+	if (error)
+		return error;
+
+	size = nex * sizeof(xfs_bmbt_rec_t);
+
 	/*
 	 * If the number of extents is unreasonable, then something is wrong and
 	 * we just bail out rather than crash in kmem_alloc() or memcpy() below.
@@ -235,7 +242,10 @@ xfs_iformat_data_fork(
 	 * depend on it.
 	 */
 	ip->i_df.if_format = dip->di_format;
-	ip->i_df.if_nextents = xfs_dfork_nextents(mp, dip, XFS_DATA_FORK);
+	error = xfs_dfork_nextents(mp, dip, XFS_DATA_FORK,
+			&ip->i_df.if_nextents);
+	if (error)
+		return error;
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFIFO:
@@ -304,9 +314,11 @@ xfs_iformat_attr_fork(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_extnum_t		nextents;
-	int			error = 0;
+	int			error;
 
-	nextents = xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK);
+	error = xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK, &nextents);
+	if (error)
+		return error;
 
 	/*
 	 * Initialize the extent count early, as the per-format routines may
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index a161dac31a6f..e9dc3749ea08 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -208,6 +208,44 @@ xchk_dinode_nsec(
 		xchk_ino_set_corrupt(sc, ino);
 }
 
+STATIC void
+xchk_dinode_fork_recs(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip,
+	xfs_ino_t		ino,
+	xfs_extnum_t		nextents,
+	int			whichfork)
+{
+	struct xfs_mount	*mp = sc->mp;
+	size_t			fork_recs;
+	unsigned char		format;
+
+	if (whichfork == XFS_DATA_FORK) {
+		fork_recs =  XFS_DFORK_DSIZE(dip, mp)
+			/ sizeof(struct xfs_bmbt_rec);
+		format = dip->di_format;
+	} else if (whichfork == XFS_ATTR_FORK) {
+		fork_recs =  XFS_DFORK_ASIZE(dip, mp)
+			/ sizeof(struct xfs_bmbt_rec);
+		format = dip->di_aformat;
+	}
+
+	switch (format) {
+	case XFS_DINODE_FMT_EXTENTS:
+		if (nextents > fork_recs)
+			xchk_ino_set_corrupt(sc, ino);
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		if (nextents <= fork_recs)
+			xchk_ino_set_corrupt(sc, ino);
+		break;
+	default:
+		if (nextents != 0)
+			xchk_ino_set_corrupt(sc, ino);
+		break;
+	}
+}
+
 /* Scrub all the ondisk inode fields. */
 STATIC void
 xchk_dinode(
@@ -216,7 +254,6 @@ xchk_dinode(
 	xfs_ino_t		ino)
 {
 	struct xfs_mount	*mp = sc->mp;
-	size_t			fork_recs;
 	unsigned long long	isize;
 	uint64_t		flags2;
 	xfs_extnum_t		nextents;
@@ -224,6 +261,7 @@ xchk_dinode(
 	prid_t			prid;
 	uint16_t		flags;
 	uint16_t		mode;
+	int			error;
 
 	flags = be16_to_cpu(dip->di_flags);
 	if (dip->di_version >= 3)
@@ -379,33 +417,22 @@ xchk_dinode(
 	xchk_inode_extsize(sc, dip, ino, mode, flags);
 
 	/* di_nextents */
-	nextents = xfs_dfork_nextents(mp, dip, XFS_DATA_FORK);
-	fork_recs =  XFS_DFORK_DSIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
-	switch (dip->di_format) {
-	case XFS_DINODE_FMT_EXTENTS:
-		if (nextents > fork_recs)
-			xchk_ino_set_corrupt(sc, ino);
-		break;
-	case XFS_DINODE_FMT_BTREE:
-		if (nextents <= fork_recs)
-			xchk_ino_set_corrupt(sc, ino);
-		break;
-	default:
-		if (nextents != 0)
-			xchk_ino_set_corrupt(sc, ino);
-		break;
-	}
-
-	naextents = xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK);
+	error = xfs_dfork_nextents(mp, dip, XFS_DATA_FORK, &nextents);
+	if (error)
+		xchk_ino_set_corrupt(sc, ino);
+	else
+		xchk_dinode_fork_recs(sc, dip, ino, nextents, XFS_DATA_FORK);
 
 	/* di_forkoff */
 	if (XFS_DFORK_APTR(dip) >= (char *)dip + mp->m_sb.sb_inodesize)
 		xchk_ino_set_corrupt(sc, ino);
-	if (naextents != 0 && dip->di_forkoff == 0)
-		xchk_ino_set_corrupt(sc, ino);
 	if (dip->di_forkoff == 0 && dip->di_aformat != XFS_DINODE_FMT_EXTENTS)
 		xchk_ino_set_corrupt(sc, ino);
 
+	error = xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK, &naextents);
+	if (error || (naextents != 0 && dip->di_forkoff == 0))
+		xchk_ino_set_corrupt(sc, ino);
+
 	/* di_aformat */
 	if (dip->di_aformat != XFS_DINODE_FMT_LOCAL &&
 	    dip->di_aformat != XFS_DINODE_FMT_EXTENTS &&
@@ -413,20 +440,8 @@ xchk_dinode(
 		xchk_ino_set_corrupt(sc, ino);
 
 	/* di_anextents */
-	fork_recs =  XFS_DFORK_ASIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
-	switch (dip->di_aformat) {
-	case XFS_DINODE_FMT_EXTENTS:
-		if (naextents > fork_recs)
-			xchk_ino_set_corrupt(sc, ino);
-		break;
-	case XFS_DINODE_FMT_BTREE:
-		if (naextents <= fork_recs)
-			xchk_ino_set_corrupt(sc, ino);
-		break;
-	default:
-		if (naextents != 0)
-			xchk_ino_set_corrupt(sc, ino);
-	}
+	if (!error)
+		xchk_dinode_fork_recs(sc, dip, ino, naextents, XFS_ATTR_FORK);
 
 	if (dip->di_version >= 3) {
 		xchk_dinode_nsec(sc, ino, dip, dip->di_crtime);
@@ -490,6 +505,7 @@ xchk_inode_xref_bmap(
 	struct xfs_dinode	*dip)
 {
 	struct xfs_mount	*mp = sc->mp;
+	xfs_extnum_t		dip_nextents;
 	xfs_extnum_t		nextents;
 	xfs_filblks_t		count;
 	xfs_filblks_t		acount;
@@ -503,14 +519,18 @@ xchk_inode_xref_bmap(
 			&nextents, &count);
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
-	if (nextents < xfs_dfork_nextents(mp, dip, XFS_DATA_FORK))
+
+	error = xfs_dfork_nextents(mp, dip, XFS_DATA_FORK, &dip_nextents);
+	if (error || nextents < dip_nextents)
 		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 
 	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
 			&nextents, &acount);
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
-	if (nextents != xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK))
+
+	error = xfs_dfork_nextents(mp, dip, XFS_ATTR_FORK, &dip_nextents);
+	if (error || nextents < dip_nextents)
 		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 
 	/* Check nblocks against the inode. */
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index bdb4685923c0..521c8df00990 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -602,7 +602,9 @@ xrep_dinode_bad_extents_fork(
 	int			i;
 	int			fork_size;
 
-	nex = xfs_dfork_nextents(sc->mp, dip, whichfork);
+	if (xfs_dfork_nextents(sc->mp, dip, whichfork, &nex))
+		return true;
+
 	fork_size = nex * sizeof(struct xfs_bmbt_rec);
 	if (fork_size < 0 || fork_size > dfork_size)
 		return true;
@@ -633,11 +635,14 @@ xrep_dinode_bad_btree_fork(
 	int			whichfork)
 {
 	struct xfs_bmdr_block	*dfp;
+	xfs_extnum_t		nextents;
 	int			nrecs;
 	int			level;
 
-	if (xfs_dfork_nextents(sc->mp, dip, whichfork) <=
-			dfork_size / sizeof(struct xfs_bmbt_rec))
+	if (xfs_dfork_nextents(sc->mp, dip, whichfork, &nextents))
+		return true;
+
+	if (nextents <= dfork_size / sizeof(struct xfs_bmbt_rec))
 		return true;
 
 	if (dfork_size < sizeof(struct xfs_bmdr_block))
@@ -774,11 +779,15 @@ xrep_dinode_check_afork(
 	struct xfs_dinode		*dip)
 {
 	struct xfs_attr_shortform	*sfp;
+	xfs_extnum_t			nextents;
 	int				size;
 
+	if (xfs_dfork_nextents(sc->mp, dip, XFS_ATTR_FORK, &nextents))
+		return true;
+
 	if (XFS_DFORK_BOFF(dip) == 0)
 		return dip->di_aformat != XFS_DINODE_FMT_EXTENTS ||
-		       dip->di_anextents != 0;
+		       nextents != 0;
 
 	size = XFS_DFORK_SIZE(dip, sc->mp, XFS_ATTR_FORK);
 	switch (XFS_DFORK_FORMAT(dip, XFS_ATTR_FORK)) {
@@ -835,11 +844,15 @@ xrep_dinode_ensure_forkoff(
 	size_t				bmdr_minsz = xfs_bmdr_space_calc(1);
 	unsigned int			lit_sz = XFS_LITINO(sc->mp);
 	unsigned int			afork_min, dfork_min;
+	int				error;
 
 	trace_xrep_dinode_ensure_forkoff(sc, dip);
 
-	dnextents = xfs_dfork_nextents(sc->mp, dip, XFS_DATA_FORK);
-	anextents = xfs_dfork_nextents(sc->mp, dip, XFS_ATTR_FORK);
+	error = xfs_dfork_nextents(sc->mp, dip, XFS_DATA_FORK, &dnextents);
+	ASSERT(error == 0);
+
+	error = xfs_dfork_nextents(sc->mp, dip, XFS_ATTR_FORK, &anextents);
+	ASSERT(error == 0);
 
 	/*
 	 * Before calling this function, xrep_dinode_core ensured that both
@@ -1027,6 +1040,7 @@ xrep_dinode_zap_forks(
 	uint16_t			mode;
 	bool				zap_datafork = false;
 	bool				zap_attrfork = false;
+	int				error;
 
 	trace_xrep_dinode_zap_forks(sc, dip);
 
@@ -1035,12 +1049,12 @@ xrep_dinode_zap_forks(
 	/* Inode counters don't make sense? */
 	nblocks = be64_to_cpu(dip->di_nblocks);
 
-	nextents = xfs_dfork_nextents(sc->mp, dip, XFS_DATA_FORK);
-	if (nextents > nblocks)
+	error = xfs_dfork_nextents(sc->mp, dip, XFS_DATA_FORK, &nextents);
+	if (error || nextents > nblocks)
 		zap_datafork = true;
 
-	naextents = xfs_dfork_nextents(sc->mp, dip, XFS_ATTR_FORK);
-	if (naextents > nblocks)
+	error = xfs_dfork_nextents(sc->mp, dip, XFS_ATTR_FORK, &naextents);
+	if (error || naextents > nblocks)
 		zap_attrfork = true;
 
 	if (nextents + naextents > nblocks)
-- 
2.30.2

