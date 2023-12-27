Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973381362
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qIbWcroM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6512EC433C8;
	Mon,  1 Jan 2024 00:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069176;
	bh=f9cvCI3+B9bxCGdX68bJ2tVgFJyUvvbitOL2FDz60aM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qIbWcroMpraa7lqg6khSfsLiU4AQFQhhxjifhbsHh4NUArCJYAkmIUAOjtvzhBZNe
	 Z/LQs1uwjAEd0Q2DPlGOYiQf7TRohzuf5qL0UWOwU4C+LfEoxLT5rWZaXAN1gyUnQA
	 GYa119rmVdX5rHMsHTIyuU7yOI8/eTsMI/5w52PYXUMmbYx4BWeaKT90Fmx684WsDb
	 r5zgYEZtRpt3Oax2LMC/nsSGrzT7/TWsCvJKxVvwWijH4Ic1ubVvSBSrHpLz84JlJS
	 FQT60JxmgnNMZz2UL780q4jA5BnO/NAGk9Qwy/P3TLRAx7LYYvA8BK3vBhiA/H4uxG
	 xOZtLfUsy2ZfQ==
Date: Sun, 31 Dec 2023 16:32:55 +9900
Subject: [PATCH 26/42] xfs_db: widen block type mask to 64 bits
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017473.1817107.5258820405739265308.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

We're about to enlarge enum dbm beyond 32 items, so we need to widen the
block type mask to 64 bits to avoid problems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c |   72 ++++++++++++++++++++++++++++++------------------------------
 1 file changed, 36 insertions(+), 36 deletions(-)


diff --git a/db/check.c b/db/check.c
index 351bb94a48e..4ef24c20d79 100644
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
@@ -1812,7 +1812,7 @@ checknot_dbmap(
 	xfs_agnumber_t	agno,
 	xfs_agblock_t	agbno,
 	xfs_extlen_t	len,
-	int		typemask)
+	uint64_t	typemask)
 {
 	xfs_extlen_t	i;
 	char		*p;
@@ -1820,7 +1820,7 @@ checknot_dbmap(
 	if (!check_range(agno, agbno, len))
 		return;
 	for (i = 0, p = &dbmap[agno][agbno]; i < len; i++, p++) {
-		if ((1 << *p) & typemask) {
+		if ((1ULL << *p) & typemask) {
 			if (!sflag || CHECK_BLISTA(agno, agbno + i))
 				dbprintf(_("block %u/%u type %s not expected\n"),
 					agno, agbno + i, typename[(dbm_t)*p]);
@@ -1833,7 +1833,7 @@ static void
 checknot_rdbmap(
 	xfs_rfsblock_t	bno,
 	xfs_extlen_t	len,
-	int		typemask)
+	uint64_t	typemask)
 {
 	xfs_extlen_t	i;
 	char		*p;
@@ -1841,7 +1841,7 @@ checknot_rdbmap(
 	if (!check_rrange(bno, len))
 		return;
 	for (i = 0, p = &dbmap[mp->m_sb.sb_agcount][bno]; i < len; i++, p++) {
-		if ((1 << *p) & typemask) {
+		if ((1ULL << *p) & typemask) {
 			if (!sflag || CHECK_BLIST(bno + i))
 				dbprintf(_("rtblock %llu type %s not expected\n"),
 					bno + i, typename[(dbm_t)*p]);

