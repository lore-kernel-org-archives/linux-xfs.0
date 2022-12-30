Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB28C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236248AbiLaDA7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiLaDA6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:00:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9954B15816
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:00:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2180AB81E7F
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2548C433EF;
        Sat, 31 Dec 2022 03:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455654;
        bh=1zaIc3M3fGQt14oeh83e+Zs9tLq8zY803hY34cUFoj4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CImMDGa1PQzHn/E0EHMFFuSooQJAIbA3lAaDTpJhlMIvU1mJOxZX/WeIBZq7Ld2Yz
         1crk+zq4Xp6Eq+4D0O04MmOIGYk3ZGC2xjx1CilAuknfw3t/vco+d47AYSJfHIh9GT
         ibF2VMcUFMmUNlonaGCgGMyHiVqIvYX1q1iYapn/7wiiej4PoNfV7C8728Gj0FHTdk
         o19CBFgPTkbTjO2/zzfd+uuXXfZd+7+KWBvN+Iurg5rrvsj5QPKAQT3CnXis3bwoZ/
         b8tUX0KG198/0hkSw6E/YQpG/Uw7STXFIIuD5pEebcbHjgslkY5oMVwkxeSU7R0ix6
         wGx2Ws3jtvaFQ==
Subject: [PATCH 26/41] xfs_db: widen block type mask to 64 bits
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:11 -0800
Message-ID: <167243881114.734096.6280183746465506353.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

We're about to enlarge enum dbm beyond 32 items, so we need to widen the
block type mask to 64 bits to avoid problems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c |   72 ++++++++++++++++++++++++++++++------------------------------
 1 file changed, 36 insertions(+), 36 deletions(-)


diff --git a/db/check.c b/db/check.c
index 79f26b0e789..6c92b961283 100644
--- a/db/check.c
+++ b/db/check.c
@@ -282,9 +282,9 @@ static void		check_set_rdbmap(xfs_rfsblock_t bno, xfs_extlen_t len,
 					 dbm_t type1, dbm_t type2);
 static void		check_summary(void);
 static void		checknot_dbmap(xfs_agnumber_t agno, xfs_agblock_t agbno,
-				       xfs_extlen_t len, int typemask);
+				       xfs_extlen_t len, uint64_t typemask);
 static void		checknot_rdbmap(xfs_rfsblock_t bno, xfs_extlen_t len,
-					int typemask);
+					uint64_t typemask);
 static void		dir_hash_add(xfs_dahash_t hash,
 				     xfs_dir2_dataptr_t addr);
 static void		dir_hash_check(inodata_t *id, int v);
@@ -904,7 +904,7 @@ blockget_f(
 	if (!tflag) {	/* are we in test mode, faking out freespace? */
 		for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)
 			checknot_dbmap(agno, 0, mp->m_sb.sb_agblocks,
-				(1 << DBM_UNKNOWN) | (1 << DBM_FREE1));
+				(1ULL << DBM_UNKNOWN) | (1ULL << DBM_FREE1));
 	}
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)
 		check_linkcounts(agno);
@@ -912,7 +912,7 @@ blockget_f(
 		checknot_rdbmap(0,
 			(xfs_extlen_t)(mp->m_sb.sb_rextents *
 				       mp->m_sb.sb_rextsize),
-			1 << DBM_UNKNOWN);
+			1ULL << DBM_UNKNOWN);
 		check_summary();
 	}
 	if (mp->m_sb.sb_icount != icount) {
@@ -1083,7 +1083,7 @@ blocktrash_f(
 	int		c;
 	int		count;
 	int		done;
-	int		goodmask;
+	uint64_t	goodmask;
 	int		i;
 	ltab_t		*lentab;
 	int		lentablen;
@@ -1095,7 +1095,7 @@ blocktrash_f(
 	xfs_rfsblock_t	randb;
 	uint		seed;
 	int		sopt;
-	int		tmask;
+	uint64_t	tmask;
 	bool		this_block = false;
 	int		bit_offset = -1;
 
@@ -1108,27 +1108,27 @@ blocktrash_f(
 	seed = (unsigned int)(now.tv_sec ^ now.tv_usec);
 	sopt = 0;
 	tmask = 0;
-	goodmask = (1 << DBM_AGF) |
-		   (1 << DBM_AGFL) |
-		   (1 << DBM_AGI) |
-		   (1 << DBM_ATTR) |
-		   (1 << DBM_BTBMAPA) |
-		   (1 << DBM_BTBMAPD) |
-		   (1 << DBM_BTBNO) |
-		   (1 << DBM_BTCNT) |
-		   (1 << DBM_BTINO) |
-		   (1 << DBM_DIR) |
-		   (1 << DBM_INODE) |
-		   (1 << DBM_LOG) |
-		   (1 << DBM_QUOTA) |
-		   (1 << DBM_RTBITMAP) |
-		   (1 << DBM_RTSUM) |
-		   (1 << DBM_BTRTRMAP) |
-		   (1 << DBM_SYMLINK) |
-		   (1 << DBM_BTFINO) |
-		   (1 << DBM_BTRMAP) |
-		   (1 << DBM_BTREFC) |
-		   (1 << DBM_SB);
+	goodmask = (1ULL << DBM_AGF) |
+		   (1ULL << DBM_AGFL) |
+		   (1ULL << DBM_AGI) |
+		   (1ULL << DBM_ATTR) |
+		   (1ULL << DBM_BTBMAPA) |
+		   (1ULL << DBM_BTBMAPD) |
+		   (1ULL << DBM_BTBNO) |
+		   (1ULL << DBM_BTCNT) |
+		   (1ULL << DBM_BTINO) |
+		   (1ULL << DBM_DIR) |
+		   (1ULL << DBM_INODE) |
+		   (1ULL << DBM_LOG) |
+		   (1ULL << DBM_QUOTA) |
+		   (1ULL << DBM_RTBITMAP) |
+		   (1ULL << DBM_RTSUM) |
+		   (1ULL << DBM_BTRTRMAP) |
+		   (1ULL << DBM_SYMLINK) |
+		   (1ULL << DBM_BTFINO) |
+		   (1ULL << DBM_BTRMAP) |
+		   (1ULL << DBM_BTREFC) |
+		   (1ULL << DBM_SB);
 	while ((c = getopt(argc, argv, "0123n:o:s:t:x:y:z")) != EOF) {
 		switch (c) {
 		case '0':
@@ -1174,11 +1174,11 @@ blocktrash_f(
 				if (strcmp(typename[i], optarg) == 0)
 					break;
 			}
-			if (!typename[i] || (((1 << i) & goodmask) == 0)) {
+			if (!typename[i] || (((1ULL << i) & goodmask) == 0)) {
 				dbprintf(_("bad blocktrash type %s\n"), optarg);
 				return 0;
 			}
-			tmask |= 1 << i;
+			tmask |= 1ULL << i;
 			break;
 		case 'x':
 			min = (int)strtol(optarg, &p, 0);
@@ -1217,7 +1217,7 @@ blocktrash_f(
 		return 0;
 	}
 	if (tmask == 0)
-		tmask = goodmask & ~((1 << DBM_LOG) | (1 << DBM_SB));
+		tmask = goodmask & ~((1ULL << DBM_LOG) | (1ULL << DBM_SB));
 	lentab = xmalloc(sizeof(ltab_t));
 	lentab->min = lentab->max = min;
 	lentablen = 1;
@@ -1242,7 +1242,7 @@ blocktrash_f(
 		for (agbno = 0, p = dbmap[agno];
 		     agbno < mp->m_sb.sb_agblocks;
 		     agbno++, p++) {
-			if ((1 << *p) & tmask)
+			if ((1ULL << *p) & tmask)
 				blocks++;
 		}
 	}
@@ -1259,7 +1259,7 @@ blocktrash_f(
 			for (agbno = 0, p = dbmap[agno];
 			     agbno < mp->m_sb.sb_agblocks;
 			     agbno++, p++) {
-				if (!((1 << *p) & tmask))
+				if (!((1ULL << *p) & tmask))
 					continue;
 				if (bi++ < randb)
 					continue;
@@ -1802,7 +1802,7 @@ checknot_dbmap(
 	xfs_agnumber_t	agno,
 	xfs_agblock_t	agbno,
 	xfs_extlen_t	len,
-	int		typemask)
+	uint64_t	typemask)
 {
 	xfs_extlen_t	i;
 	char		*p;
@@ -1810,7 +1810,7 @@ checknot_dbmap(
 	if (!check_range(agno, agbno, len))
 		return;
 	for (i = 0, p = &dbmap[agno][agbno]; i < len; i++, p++) {
-		if ((1 << *p) & typemask) {
+		if ((1ULL << *p) & typemask) {
 			if (!sflag || CHECK_BLISTA(agno, agbno + i))
 				dbprintf(_("block %u/%u type %s not expected\n"),
 					agno, agbno + i, typename[(dbm_t)*p]);
@@ -1823,7 +1823,7 @@ static void
 checknot_rdbmap(
 	xfs_rfsblock_t	bno,
 	xfs_extlen_t	len,
-	int		typemask)
+	uint64_t	typemask)
 {
 	xfs_extlen_t	i;
 	char		*p;
@@ -1831,7 +1831,7 @@ checknot_rdbmap(
 	if (!check_rrange(bno, len))
 		return;
 	for (i = 0, p = &dbmap[mp->m_sb.sb_agcount][bno]; i < len; i++, p++) {
-		if ((1 << *p) & typemask) {
+		if ((1ULL << *p) & typemask) {
 			if (!sflag || CHECK_BLIST(bno + i))
 				dbprintf(_("rtblock %llu type %s not expected\n"),
 					bno + i, typename[(dbm_t)*p]);

