Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E971C3C0C
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990625; cv=none; b=XW2+ZHAPYIjRJG7Lrud3M50K6zXPTPN4JQ6iteSsXgNJlDqJhVgoasK3pnxTvIPCyRHPJoE+wLmptsSpvOpAJ3Ftqc1bnckYtLI+OTEMUEW+VUKtu+kmDE+aBj9eVwR1boEkaA8maX4YQvuxkSxdydtUpjG3VTFo6kvT/3xZqrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990625; c=relaxed/simple;
	bh=2/qQYtXxwLeQQBf6NujhinMTFv/wz8H+mrpO1jlXooU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K3iFW+DxVoSlO6KGyUhuFuUNgsvOofKpMASgt0xEZxAMchzJLsgR1vJOyU24SN9KPcsrIBCAFSwMpgtW4Vh0tETTj6Ij0TBWismH/prv265bf3BNwzIP/yqq9YGhBpS6H4mWXZZcd2Q3VRgKs4/eEBzu60nJWigEHjnXokUuzn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JpV/Iiok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JpV/Iiok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A1EC4CED3;
	Mon, 23 Dec 2024 21:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990624;
	bh=2/qQYtXxwLeQQBf6NujhinMTFv/wz8H+mrpO1jlXooU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JpV/IiokPHPs3RhjJVN61oUV56s6H67U9InhDpi09FDV5W0PnsxphNAXwCJfoDCVq
	 m5QZIMHQkop1Ma3+CiXTaDGvX2Ml0Y8RUn3+8fyrwQVYqR0IZlGdnJYEedLr3ZDj+t
	 p61uJmCCaay/VozFaBx9t5Dlyzrg2s3zZylaFOXBKOba2ogqEqPsQPG2dLbnWfxINV
	 0Z/afDCqygS6YFF1xQ5/L2Eo8N4h0yZ6N5slsnL5eitbJFFO8rok7U1EWr4IHK1tNp
	 cIrGd/43LtS/7t4Fa6+EWDzc8ThkMdLl1xQfUjgOccifTYX7uWhC+ubGL1fkuHgXl+
	 3kcKKqzWr5HeA==
Date: Mon, 23 Dec 2024 13:50:24 -0800
Subject: [PATCH 15/41] xfs_db: drop the metadata checking code from blockget
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941198.2294268.3459139823957282491.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Drop the check subcommand and all the metadata checking code from
xfs_db.  We haven't shipped xfs_check in xfsprogs in a decade and the
last known user (fstests) stopped calling it back in July 2024.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/check.c        |  294 -----------------------------------------------------
 man/man8/xfs_db.8 |   12 +-
 2 files changed, 5 insertions(+), 301 deletions(-)


diff --git a/db/check.c b/db/check.c
index 37306bd7a6ac2d..4f7785c64f5b49 100644
--- a/db/check.c
+++ b/db/check.c
@@ -236,14 +236,12 @@ static void		check_dbmap(xfs_agnumber_t agno, xfs_agblock_t agbno,
 				    int ignore_reflink);
 static int		check_inomap(xfs_agnumber_t agno, xfs_agblock_t agbno,
 				     xfs_extlen_t len, xfs_ino_t c_ino);
-static void		check_linkcounts(xfs_agnumber_t agno);
 static int		check_range(xfs_agnumber_t agno, xfs_agblock_t agbno,
 				    xfs_extlen_t len);
 static void		check_rdbmap(xfs_rfsblock_t bno, xfs_extlen_t len,
 				     dbm_t type);
 static int		check_rinomap(xfs_rfsblock_t bno, xfs_extlen_t len,
 				      xfs_ino_t c_ino);
-static void		check_rootdir(void);
 static int		check_rrange(xfs_rfsblock_t bno, xfs_extlen_t len);
 static void		check_set_dbmap(xfs_agnumber_t agno,
 					xfs_agblock_t agbno, xfs_extlen_t len,
@@ -252,11 +250,6 @@ static void		check_set_dbmap(xfs_agnumber_t agno,
 					xfs_agblock_t c_agbno);
 static void		check_set_rdbmap(xfs_rfsblock_t bno, xfs_extlen_t len,
 					 dbm_t type1, dbm_t type2);
-static void		check_summary(void);
-static void		checknot_dbmap(xfs_agnumber_t agno, xfs_agblock_t agbno,
-				       xfs_extlen_t len, int typemask);
-static void		checknot_rdbmap(xfs_rfsblock_t bno, xfs_extlen_t len,
-					int typemask);
 static void		dir_hash_add(xfs_dahash_t hash,
 				     xfs_dir2_dataptr_t addr);
 static void		dir_hash_check(inodata_t *id, int v);
@@ -323,7 +316,6 @@ static void		quota_add(xfs_dqid_t *p, xfs_dqid_t *g, xfs_dqid_t *u,
 static void		quota_add1(qdata_t **qt, xfs_dqid_t id, int dq,
 				   xfs_qcnt_t bc, xfs_qcnt_t ic,
 				   xfs_qcnt_t rc);
-static void		quota_check(char *s, qdata_t **qt);
 static void		quota_init(void);
 static void		scan_ag(xfs_agnumber_t agno);
 static void		scan_freelist(xfs_agf_t *agf);
@@ -376,7 +368,7 @@ static const cmdinfo_t	blockfree_cmd =
 	{ "blockfree", NULL, blockfree_f, 0, 0, 0,
 	  NULL, N_("free block usage information"), NULL };
 static const cmdinfo_t	blockget_cmd =
-	{ "blockget", "check", blockget_f, 0, -1, 0,
+	{ "blockget", NULL, blockget_f, 0, -1, 0,
 	  N_("[-s|-v] [-n] [-t] [-b bno]... [-i ino] ..."),
 	  N_("get block usage and check consistency"), NULL };
 static const cmdinfo_t	blocktrash_cmd =
@@ -826,107 +818,9 @@ blockget_f(
 		blist = NULL;
 		blist_size = 0;
 	}
-	if (serious_error) {
+	if (serious_error)
 		exitcode = 2;
-		dbprefix = oldprefix;
-		return 0;
-	}
 
-	if (xfs_has_metadir(mp)) {
-		dbprefix = oldprefix;
-		return 0;
-	}
-
-	check_rootdir();
-	/*
-	 * Check that there are no blocks either
-	 * a) unaccounted for or
-	 * b) bno-free but not cnt-free
-	 */
-	if (!tflag) {	/* are we in test mode, faking out freespace? */
-		for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)
-			checknot_dbmap(agno, 0, mp->m_sb.sb_agblocks,
-				(1 << DBM_UNKNOWN) | (1 << DBM_FREE1));
-	}
-	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)
-		check_linkcounts(agno);
-	if (mp->m_sb.sb_rblocks) {
-		checknot_rdbmap(0,
-			(xfs_extlen_t)(mp->m_sb.sb_rextents *
-				       mp->m_sb.sb_rextsize),
-			1 << DBM_UNKNOWN);
-		check_summary();
-	}
-	if (mp->m_sb.sb_icount != icount) {
-		if (!sflag)
-			dbprintf(_("sb_icount %lld, counted %lld\n"),
-				mp->m_sb.sb_icount, icount);
-		error++;
-	}
-	if (mp->m_sb.sb_ifree != ifree) {
-		if (!sflag)
-			dbprintf(_("sb_ifree %lld, counted %lld\n"),
-				mp->m_sb.sb_ifree, ifree);
-		error++;
-	}
-	if (mp->m_sb.sb_fdblocks != fdblocks) {
-		if (!sflag)
-			dbprintf(_("sb_fdblocks %lld, counted %lld\n"),
-				mp->m_sb.sb_fdblocks, fdblocks);
-		error++;
-	}
-	if (lazycount && mp->m_sb.sb_fdblocks != agf_aggr_freeblks) {
-		if (!sflag)
-			dbprintf(_("sb_fdblocks %lld, aggregate AGF count %lld\n"),
-				mp->m_sb.sb_fdblocks, agf_aggr_freeblks);
-		error++;
-	}
-	if (mp->m_sb.sb_frextents != frextents) {
-		if (!sflag)
-			dbprintf(_("sb_frextents %lld, counted %lld\n"),
-				mp->m_sb.sb_frextents, frextents);
-		error++;
-	}
-	if (mp->m_sb.sb_bad_features2 != 0 &&
-			mp->m_sb.sb_bad_features2 != mp->m_sb.sb_features2) {
-		if (!sflag)
-			dbprintf(_("sb_features2 (0x%x) not same as "
-				"sb_bad_features2 (0x%x)\n"),
-				mp->m_sb.sb_features2,
-				mp->m_sb.sb_bad_features2);
-		error++;
-	}
-	if ((sbversion & XFS_SB_VERSION_ATTRBIT) &&
-					!xfs_has_attr(mp)) {
-		if (!sflag)
-			dbprintf(_("sb versionnum missing attr bit %x\n"),
-				XFS_SB_VERSION_ATTRBIT);
-		error++;
-	}
-	if ((sbversion & XFS_SB_VERSION_QUOTABIT) &&
-					!xfs_has_quota(mp)) {
-		if (!sflag)
-			dbprintf(_("sb versionnum missing quota bit %x\n"),
-				XFS_SB_VERSION_QUOTABIT);
-		error++;
-	}
-	if (!(sbversion & XFS_SB_VERSION_ALIGNBIT) &&
-					xfs_has_align(mp)) {
-		if (!sflag)
-			dbprintf(_("sb versionnum extra align bit %x\n"),
-				XFS_SB_VERSION_ALIGNBIT);
-		error++;
-	}
-	if (qudo)
-		quota_check("user", qudata);
-	if (qpdo)
-		quota_check("project", qpdata);
-	if (qgdo)
-		quota_check("group", qgdata);
-	if (sbver_err > mp->m_sb.sb_agcount / 2)
-		dbprintf(_("WARNING: this may be a newer XFS filesystem.\n"));
-	if (error)
-		exitcode = 3;
 	dbprefix = oldprefix;
 	return 0;
 }
@@ -1388,58 +1282,6 @@ check_inomap(
 	return rval;
 }
 
-static void
-check_linkcounts(
-	xfs_agnumber_t	agno)
-{
-	inodata_t	*ep;
-	inodata_t	**ht;
-	int		idx;
-	char		*path;
-
-	ht = inodata[agno];
-	for (idx = 0; idx < inodata_hash_size; ht++, idx++) {
-		ep = *ht;
-		while (ep) {
-			if (ep->link_set != ep->link_add || ep->link_set == 0) {
-				path = inode_name(ep->ino, NULL);
-				if (!path && ep->link_add)
-					path = xstrdup("?");
-				if (!sflag || ep->ilist) {
-					if (ep->link_add)
-						dbprintf(_("link count mismatch "
-							 "for inode %lld (name "
-							 "%s), nlink %d, "
-							 "counted %d\n"),
-							ep->ino, path,
-							ep->link_set,
-							ep->link_add);
-					else if (ep->link_set)
-						dbprintf(_("disconnected inode "
-							 "%lld, nlink %d\n"),
-							ep->ino, ep->link_set);
-					else
-						dbprintf(_("allocated inode %lld "
-							 "has 0 link count\n"),
-							ep->ino);
-				}
-				if (path)
-					xfree(path);
-				error++;
-			} else if (verbose || ep->ilist) {
-				path = inode_name(ep->ino, NULL);
-				if (path) {
-					dbprintf(_("inode %lld name %s\n"),
-						ep->ino, path);
-					xfree(path);
-				}
-			}
-			ep = ep->next;
-		}
-	}
-
-}
-
 static int
 check_range(
 	xfs_agnumber_t  agno,
@@ -1556,25 +1398,6 @@ check_rinomap(
 	return rval;
 }
 
-static void
-check_rootdir(void)
-{
-	inodata_t	*id;
-
-	id = find_inode(mp->m_sb.sb_rootino, 0);
-	if (id == NULL) {
-		if (!sflag)
-			dbprintf(_("root inode %lld is missing\n"),
-				mp->m_sb.sb_rootino);
-		error++;
-	} else if (!id->isdir) {
-		if (!sflag || id->ilist)
-			dbprintf(_("root inode %lld is not a directory\n"),
-				mp->m_sb.sb_rootino);
-		error++;
-	}
-}
-
 static inline void
 report_rrange(
 	xfs_rfsblock_t	low,
@@ -1718,77 +1541,6 @@ get_suminfo(
 	return raw->old;
 }
 
-static void
-check_summary(void)
-{
-	xfs_rfsblock_t	bno;
-	union xfs_suminfo_raw *csp;
-	union xfs_suminfo_raw *fsp;
-	int		log;
-
-	csp = sumcompute;
-	fsp = sumfile;
-	for (log = 0; log < mp->m_rsumlevels; log++) {
-		for (bno = 0;
-		     bno < mp->m_sb.sb_rbmblocks;
-		     bno++, csp++, fsp++) {
-			if (csp->old != fsp->old) {
-				if (!sflag)
-					dbprintf(_("rt summary mismatch, size %d "
-						 "block %llu, file: %d, "
-						 "computed: %d\n"),
-						log, bno,
-						get_suminfo(mp, fsp),
-						get_suminfo(mp, csp));
-				error++;
-			}
-		}
-	}
-}
-
-static void
-checknot_dbmap(
-	xfs_agnumber_t	agno,
-	xfs_agblock_t	agbno,
-	xfs_extlen_t	len,
-	int		typemask)
-{
-	xfs_extlen_t	i;
-	char		*p;
-
-	if (!check_range(agno, agbno, len))
-		return;
-	for (i = 0, p = &dbmap[agno][agbno]; i < len; i++, p++) {
-		if ((1 << *p) & typemask) {
-			if (!sflag || CHECK_BLISTA(agno, agbno + i))
-				dbprintf(_("block %u/%u type %s not expected\n"),
-					agno, agbno + i, typename[(dbm_t)*p]);
-			error++;
-		}
-	}
-}
-
-static void
-checknot_rdbmap(
-	xfs_rfsblock_t	bno,
-	xfs_extlen_t	len,
-	int		typemask)
-{
-	xfs_extlen_t	i;
-	char		*p;
-
-	if (!check_rrange(bno, len))
-		return;
-	for (i = 0, p = &dbmap[mp->m_sb.sb_agcount][bno]; i < len; i++, p++) {
-		if ((1 << *p) & typemask) {
-			if (!sflag || CHECK_BLIST(bno + i))
-				dbprintf(_("rtblock %llu type %s not expected\n"),
-					bno + i, typename[(dbm_t)*p]);
-			error++;
-		}
-	}
-}
-
 static void
 dir_hash_add(
 	xfs_dahash_t		hash,
@@ -3923,48 +3675,6 @@ quota_add1(
 	qt[qh] = qe;
 }
 
-static void
-quota_check(
-	char	*s,
-	qdata_t	**qt)
-{
-	int	i;
-	qdata_t	*next;
-	qdata_t	*qp;
-
-	for (i = 0; i < QDATA_HASH_SIZE; i++) {
-		qp = qt[i];
-		while (qp) {
-			next = qp->next;
-			if (qp->count.bc != qp->dq.bc ||
-			    qp->count.ic != qp->dq.ic ||
-			    qp->count.rc != qp->dq.rc) {
-				if (!sflag) {
-					dbprintf(_("%s quota id %u, have/exp"),
-						s, qp->id);
-					if (qp->count.bc != qp->dq.bc)
-						dbprintf(_(" bc %lld/%lld"),
-							qp->dq.bc,
-							qp->count.bc);
-					if (qp->count.ic != qp->dq.ic)
-						dbprintf(_(" ic %lld/%lld"),
-							qp->dq.ic,
-							qp->count.ic);
-					if (qp->count.rc != qp->dq.rc)
-						dbprintf(_(" rc %lld/%lld"),
-							qp->dq.rc,
-							qp->count.rc);
-					dbprintf("\n");
-				}
-				error++;
-			}
-			xfree(qp);
-			qp = next;
-		}
-	}
-	xfree(qt);
-}
-
 static void
 quota_init(void)
 {
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 066f124458b286..2325ef169ddc1b 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -345,7 +345,7 @@ .SH COMMANDS
 command can be given, presumably with different arguments than the previous one.
 .TP
 .BI "blockget [\-npvs] [\-b " bno "] ... [\-i " ino "] ..."
-Get block usage and check filesystem consistency.
+Get block usage.
 The information is saved for use by a subsequent
 .BR blockuse ", " ncheck ", or " blocktrash
 command.
@@ -564,11 +564,6 @@ .SH COMMANDS
 half full.
 .RE
 .TP
-.B check
-See the
-.B blockget
-command.
-.TP
 .BI "convert " "type number" " [" "type number" "] ... " type
 Convert from one address form to another.
 The known
@@ -2635,8 +2630,7 @@ .SH TYPES
 and printable ASCII chars.
 .SH DIAGNOSTICS
 Many messages can come from the
-.B check
-.RB ( blockget )
+.B blockget
 command.
 If the filesystem is completely corrupt, a core dump might
 be produced instead of the message
@@ -2646,7 +2640,7 @@ .SH DIAGNOSTICS
 .RE
 .PP
 If the filesystem is very large (has many files) then
-.B check
+.B blockget
 might run out of memory. In this case the message
 .RS
 .B out of memory

