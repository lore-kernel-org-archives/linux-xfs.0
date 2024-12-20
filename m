Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5D33B784
	for <linux-xfs@vger.kernel.org>; Fri, 20 Dec 2024 15:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734706878; cv=none; b=K9D7bF3a4acM4T4S2RALACFbEXKamtJMN0RkcPyCe7d75vdfvlCW3VqzpLidbF0W4PqiP8IQV97xqlM1R+wGa+pEszExgwTavcDCRNImKzDHznAnSKkrE5vS5EPBHbNjsQMeDIgQOgvFjnj5HQhDyCx2B1HBurkoFhZYPcpbnM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734706878; c=relaxed/simple;
	bh=uZAGQEduzOd1HCqZw8s9XFiVXR1sCT+K2hpes1LSjHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=npUqJiKtTu8Ecw5PIK4X22cB6mQsmsXI4T4FeuFQ5mm7jNTwN4jatFYdQ2JTzo51NM057hO0p08mU3neJIKxQ2+d9fRDxdx+X5QHFzQFbXjaBGaMidqeOnqDsgkdEkwkhIirJT54WYBeKENJF3l1nQizM6WtW0DQJvht51hjINo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fJhFJLUB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fJhFJLUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 171EFC4CECD;
	Fri, 20 Dec 2024 15:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734706878;
	bh=uZAGQEduzOd1HCqZw8s9XFiVXR1sCT+K2hpes1LSjHI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fJhFJLUBCdCkYyYQxh2pP7oeQo7Y6dksDAaLAjsOulgM78OfbKF978Eq1kVB9Nv+F
	 cLJZUn4x2gt3D0DayOB+ii3Lvq4FXGAyqat5N1dCtoUHjm4qZ7Tx9WyUoX8h1/40/p
	 +GI2wtHX17gPwBI9W0FBQFAZkvzs6QAy5ogcnPGVVhbMJ2qQLxIg5mBjBEN8tfmtPH
	 6bQyzD2YLGxBLvzop76Z7GQzBNwv71folc+0/Qd6k+id1G+TP6X0MFboXYnItN6THP
	 tdSCQvFiaLmFsi2+ddubmlWxuRBQH5bWkQUZHOYvWLIdtKp/NvRP7Zh9cL3SusGvXo
	 /gknmC8GVaDFg==
Date: Fri, 20 Dec 2024 16:01:14 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/3] xfs_db: drop the metadata checking code from blockget
Message-ID: <dqtxbeznqi57eqhflshbht5wold5h4ujxova3tqkessuatmenm@yglmhapzil54>
References: <173463582894.1574879.10113776916850781634.stgit@frogsfrogsfrogs>
 <173463582913.1574879.1807844163819986251.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173463582913.1574879.1807844163819986251.stgit@frogsfrogsfrogs>

On 2024-12-19 11:44:29, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Drop the check subcommand and all the metadata checking code from
> xfs_db.  We haven't shipped xfs_check in xfsprogs in a decade and the
> last known user (fstests) stopped calling it back in July 2024.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

LGTM
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

> ---
>  db/check.c        |  294 -----------------------------------------------------
>  man/man8/xfs_db.8 |   12 +-
>  2 files changed, 5 insertions(+), 301 deletions(-)
> 
> 
> diff --git a/db/check.c b/db/check.c
> index 37306bd7a6ac2d..4f7785c64f5b49 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -236,14 +236,12 @@ static void		check_dbmap(xfs_agnumber_t agno, xfs_agblock_t agbno,
>  				    int ignore_reflink);
>  static int		check_inomap(xfs_agnumber_t agno, xfs_agblock_t agbno,
>  				     xfs_extlen_t len, xfs_ino_t c_ino);
> -static void		check_linkcounts(xfs_agnumber_t agno);
>  static int		check_range(xfs_agnumber_t agno, xfs_agblock_t agbno,
>  				    xfs_extlen_t len);
>  static void		check_rdbmap(xfs_rfsblock_t bno, xfs_extlen_t len,
>  				     dbm_t type);
>  static int		check_rinomap(xfs_rfsblock_t bno, xfs_extlen_t len,
>  				      xfs_ino_t c_ino);
> -static void		check_rootdir(void);
>  static int		check_rrange(xfs_rfsblock_t bno, xfs_extlen_t len);
>  static void		check_set_dbmap(xfs_agnumber_t agno,
>  					xfs_agblock_t agbno, xfs_extlen_t len,
> @@ -252,11 +250,6 @@ static void		check_set_dbmap(xfs_agnumber_t agno,
>  					xfs_agblock_t c_agbno);
>  static void		check_set_rdbmap(xfs_rfsblock_t bno, xfs_extlen_t len,
>  					 dbm_t type1, dbm_t type2);
> -static void		check_summary(void);
> -static void		checknot_dbmap(xfs_agnumber_t agno, xfs_agblock_t agbno,
> -				       xfs_extlen_t len, int typemask);
> -static void		checknot_rdbmap(xfs_rfsblock_t bno, xfs_extlen_t len,
> -					int typemask);
>  static void		dir_hash_add(xfs_dahash_t hash,
>  				     xfs_dir2_dataptr_t addr);
>  static void		dir_hash_check(inodata_t *id, int v);
> @@ -323,7 +316,6 @@ static void		quota_add(xfs_dqid_t *p, xfs_dqid_t *g, xfs_dqid_t *u,
>  static void		quota_add1(qdata_t **qt, xfs_dqid_t id, int dq,
>  				   xfs_qcnt_t bc, xfs_qcnt_t ic,
>  				   xfs_qcnt_t rc);
> -static void		quota_check(char *s, qdata_t **qt);
>  static void		quota_init(void);
>  static void		scan_ag(xfs_agnumber_t agno);
>  static void		scan_freelist(xfs_agf_t *agf);
> @@ -376,7 +368,7 @@ static const cmdinfo_t	blockfree_cmd =
>  	{ "blockfree", NULL, blockfree_f, 0, 0, 0,
>  	  NULL, N_("free block usage information"), NULL };
>  static const cmdinfo_t	blockget_cmd =
> -	{ "blockget", "check", blockget_f, 0, -1, 0,
> +	{ "blockget", NULL, blockget_f, 0, -1, 0,
>  	  N_("[-s|-v] [-n] [-t] [-b bno]... [-i ino] ..."),
>  	  N_("get block usage and check consistency"), NULL };
>  static const cmdinfo_t	blocktrash_cmd =
> @@ -826,107 +818,9 @@ blockget_f(
>  		blist = NULL;
>  		blist_size = 0;
>  	}
> -	if (serious_error) {
> +	if (serious_error)
>  		exitcode = 2;
> -		dbprefix = oldprefix;
> -		return 0;
> -	}
>  
> -	if (xfs_has_metadir(mp)) {
> -		dbprefix = oldprefix;
> -		return 0;
> -	}
> -
> -	check_rootdir();
> -	/*
> -	 * Check that there are no blocks either
> -	 * a) unaccounted for or
> -	 * b) bno-free but not cnt-free
> -	 */
> -	if (!tflag) {	/* are we in test mode, faking out freespace? */
> -		for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)
> -			checknot_dbmap(agno, 0, mp->m_sb.sb_agblocks,
> -				(1 << DBM_UNKNOWN) | (1 << DBM_FREE1));
> -	}
> -	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)
> -		check_linkcounts(agno);
> -	if (mp->m_sb.sb_rblocks) {
> -		checknot_rdbmap(0,
> -			(xfs_extlen_t)(mp->m_sb.sb_rextents *
> -				       mp->m_sb.sb_rextsize),
> -			1 << DBM_UNKNOWN);
> -		check_summary();
> -	}
> -	if (mp->m_sb.sb_icount != icount) {
> -		if (!sflag)
> -			dbprintf(_("sb_icount %lld, counted %lld\n"),
> -				mp->m_sb.sb_icount, icount);
> -		error++;
> -	}
> -	if (mp->m_sb.sb_ifree != ifree) {
> -		if (!sflag)
> -			dbprintf(_("sb_ifree %lld, counted %lld\n"),
> -				mp->m_sb.sb_ifree, ifree);
> -		error++;
> -	}
> -	if (mp->m_sb.sb_fdblocks != fdblocks) {
> -		if (!sflag)
> -			dbprintf(_("sb_fdblocks %lld, counted %lld\n"),
> -				mp->m_sb.sb_fdblocks, fdblocks);
> -		error++;
> -	}
> -	if (lazycount && mp->m_sb.sb_fdblocks != agf_aggr_freeblks) {
> -		if (!sflag)
> -			dbprintf(_("sb_fdblocks %lld, aggregate AGF count %lld\n"),
> -				mp->m_sb.sb_fdblocks, agf_aggr_freeblks);
> -		error++;
> -	}
> -	if (mp->m_sb.sb_frextents != frextents) {
> -		if (!sflag)
> -			dbprintf(_("sb_frextents %lld, counted %lld\n"),
> -				mp->m_sb.sb_frextents, frextents);
> -		error++;
> -	}
> -	if (mp->m_sb.sb_bad_features2 != 0 &&
> -			mp->m_sb.sb_bad_features2 != mp->m_sb.sb_features2) {
> -		if (!sflag)
> -			dbprintf(_("sb_features2 (0x%x) not same as "
> -				"sb_bad_features2 (0x%x)\n"),
> -				mp->m_sb.sb_features2,
> -				mp->m_sb.sb_bad_features2);
> -		error++;
> -	}
> -	if ((sbversion & XFS_SB_VERSION_ATTRBIT) &&
> -					!xfs_has_attr(mp)) {
> -		if (!sflag)
> -			dbprintf(_("sb versionnum missing attr bit %x\n"),
> -				XFS_SB_VERSION_ATTRBIT);
> -		error++;
> -	}
> -	if ((sbversion & XFS_SB_VERSION_QUOTABIT) &&
> -					!xfs_has_quota(mp)) {
> -		if (!sflag)
> -			dbprintf(_("sb versionnum missing quota bit %x\n"),
> -				XFS_SB_VERSION_QUOTABIT);
> -		error++;
> -	}
> -	if (!(sbversion & XFS_SB_VERSION_ALIGNBIT) &&
> -					xfs_has_align(mp)) {
> -		if (!sflag)
> -			dbprintf(_("sb versionnum extra align bit %x\n"),
> -				XFS_SB_VERSION_ALIGNBIT);
> -		error++;
> -	}
> -	if (qudo)
> -		quota_check("user", qudata);
> -	if (qpdo)
> -		quota_check("project", qpdata);
> -	if (qgdo)
> -		quota_check("group", qgdata);
> -	if (sbver_err > mp->m_sb.sb_agcount / 2)
> -		dbprintf(_("WARNING: this may be a newer XFS filesystem.\n"));
> -	if (error)
> -		exitcode = 3;
>  	dbprefix = oldprefix;
>  	return 0;
>  }
> @@ -1388,58 +1282,6 @@ check_inomap(
>  	return rval;
>  }
>  
> -static void
> -check_linkcounts(
> -	xfs_agnumber_t	agno)
> -{
> -	inodata_t	*ep;
> -	inodata_t	**ht;
> -	int		idx;
> -	char		*path;
> -
> -	ht = inodata[agno];
> -	for (idx = 0; idx < inodata_hash_size; ht++, idx++) {
> -		ep = *ht;
> -		while (ep) {
> -			if (ep->link_set != ep->link_add || ep->link_set == 0) {
> -				path = inode_name(ep->ino, NULL);
> -				if (!path && ep->link_add)
> -					path = xstrdup("?");
> -				if (!sflag || ep->ilist) {
> -					if (ep->link_add)
> -						dbprintf(_("link count mismatch "
> -							 "for inode %lld (name "
> -							 "%s), nlink %d, "
> -							 "counted %d\n"),
> -							ep->ino, path,
> -							ep->link_set,
> -							ep->link_add);
> -					else if (ep->link_set)
> -						dbprintf(_("disconnected inode "
> -							 "%lld, nlink %d\n"),
> -							ep->ino, ep->link_set);
> -					else
> -						dbprintf(_("allocated inode %lld "
> -							 "has 0 link count\n"),
> -							ep->ino);
> -				}
> -				if (path)
> -					xfree(path);
> -				error++;
> -			} else if (verbose || ep->ilist) {
> -				path = inode_name(ep->ino, NULL);
> -				if (path) {
> -					dbprintf(_("inode %lld name %s\n"),
> -						ep->ino, path);
> -					xfree(path);
> -				}
> -			}
> -			ep = ep->next;
> -		}
> -	}
> -
> -}
> -
>  static int
>  check_range(
>  	xfs_agnumber_t  agno,
> @@ -1556,25 +1398,6 @@ check_rinomap(
>  	return rval;
>  }
>  
> -static void
> -check_rootdir(void)
> -{
> -	inodata_t	*id;
> -
> -	id = find_inode(mp->m_sb.sb_rootino, 0);
> -	if (id == NULL) {
> -		if (!sflag)
> -			dbprintf(_("root inode %lld is missing\n"),
> -				mp->m_sb.sb_rootino);
> -		error++;
> -	} else if (!id->isdir) {
> -		if (!sflag || id->ilist)
> -			dbprintf(_("root inode %lld is not a directory\n"),
> -				mp->m_sb.sb_rootino);
> -		error++;
> -	}
> -}
> -
>  static inline void
>  report_rrange(
>  	xfs_rfsblock_t	low,
> @@ -1718,77 +1541,6 @@ get_suminfo(
>  	return raw->old;
>  }
>  
> -static void
> -check_summary(void)
> -{
> -	xfs_rfsblock_t	bno;
> -	union xfs_suminfo_raw *csp;
> -	union xfs_suminfo_raw *fsp;
> -	int		log;
> -
> -	csp = sumcompute;
> -	fsp = sumfile;
> -	for (log = 0; log < mp->m_rsumlevels; log++) {
> -		for (bno = 0;
> -		     bno < mp->m_sb.sb_rbmblocks;
> -		     bno++, csp++, fsp++) {
> -			if (csp->old != fsp->old) {
> -				if (!sflag)
> -					dbprintf(_("rt summary mismatch, size %d "
> -						 "block %llu, file: %d, "
> -						 "computed: %d\n"),
> -						log, bno,
> -						get_suminfo(mp, fsp),
> -						get_suminfo(mp, csp));
> -				error++;
> -			}
> -		}
> -	}
> -}
> -
> -static void
> -checknot_dbmap(
> -	xfs_agnumber_t	agno,
> -	xfs_agblock_t	agbno,
> -	xfs_extlen_t	len,
> -	int		typemask)
> -{
> -	xfs_extlen_t	i;
> -	char		*p;
> -
> -	if (!check_range(agno, agbno, len))
> -		return;
> -	for (i = 0, p = &dbmap[agno][agbno]; i < len; i++, p++) {
> -		if ((1 << *p) & typemask) {
> -			if (!sflag || CHECK_BLISTA(agno, agbno + i))
> -				dbprintf(_("block %u/%u type %s not expected\n"),
> -					agno, agbno + i, typename[(dbm_t)*p]);
> -			error++;
> -		}
> -	}
> -}
> -
> -static void
> -checknot_rdbmap(
> -	xfs_rfsblock_t	bno,
> -	xfs_extlen_t	len,
> -	int		typemask)
> -{
> -	xfs_extlen_t	i;
> -	char		*p;
> -
> -	if (!check_rrange(bno, len))
> -		return;
> -	for (i = 0, p = &dbmap[mp->m_sb.sb_agcount][bno]; i < len; i++, p++) {
> -		if ((1 << *p) & typemask) {
> -			if (!sflag || CHECK_BLIST(bno + i))
> -				dbprintf(_("rtblock %llu type %s not expected\n"),
> -					bno + i, typename[(dbm_t)*p]);
> -			error++;
> -		}
> -	}
> -}
> -
>  static void
>  dir_hash_add(
>  	xfs_dahash_t		hash,
> @@ -3923,48 +3675,6 @@ quota_add1(
>  	qt[qh] = qe;
>  }
>  
> -static void
> -quota_check(
> -	char	*s,
> -	qdata_t	**qt)
> -{
> -	int	i;
> -	qdata_t	*next;
> -	qdata_t	*qp;
> -
> -	for (i = 0; i < QDATA_HASH_SIZE; i++) {
> -		qp = qt[i];
> -		while (qp) {
> -			next = qp->next;
> -			if (qp->count.bc != qp->dq.bc ||
> -			    qp->count.ic != qp->dq.ic ||
> -			    qp->count.rc != qp->dq.rc) {
> -				if (!sflag) {
> -					dbprintf(_("%s quota id %u, have/exp"),
> -						s, qp->id);
> -					if (qp->count.bc != qp->dq.bc)
> -						dbprintf(_(" bc %lld/%lld"),
> -							qp->dq.bc,
> -							qp->count.bc);
> -					if (qp->count.ic != qp->dq.ic)
> -						dbprintf(_(" ic %lld/%lld"),
> -							qp->dq.ic,
> -							qp->count.ic);
> -					if (qp->count.rc != qp->dq.rc)
> -						dbprintf(_(" rc %lld/%lld"),
> -							qp->dq.rc,
> -							qp->count.rc);
> -					dbprintf("\n");
> -				}
> -				error++;
> -			}
> -			xfree(qp);
> -			qp = next;
> -		}
> -	}
> -	xfree(qt);
> -}
> -
>  static void
>  quota_init(void)
>  {
> diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> index 5d72de91dd6862..06f4464a928596 100644
> --- a/man/man8/xfs_db.8
> +++ b/man/man8/xfs_db.8
> @@ -345,7 +345,7 @@ .SH COMMANDS
>  command can be given, presumably with different arguments than the previous one.
>  .TP
>  .BI "blockget [\-npvs] [\-b " bno "] ... [\-i " ino "] ..."
> -Get block usage and check filesystem consistency.
> +Get block usage.
>  The information is saved for use by a subsequent
>  .BR blockuse ", " ncheck ", or " blocktrash
>  command.
> @@ -564,11 +564,6 @@ .SH COMMANDS
>  half full.
>  .RE
>  .TP
> -.B check
> -See the
> -.B blockget
> -command.
> -.TP
>  .BI "convert " "type number" " [" "type number" "] ... " type
>  Convert from one address form to another.
>  The known
> @@ -2665,8 +2660,7 @@ .SH TYPES
>  and printable ASCII chars.
>  .SH DIAGNOSTICS
>  Many messages can come from the
> -.B check
> -.RB ( blockget )
> +.B blockget
>  command.
>  If the filesystem is completely corrupt, a core dump might
>  be produced instead of the message
> @@ -2676,7 +2670,7 @@ .SH DIAGNOSTICS
>  .RE
>  .PP
>  If the filesystem is very large (has many files) then
> -.B check
> +.B blockget
>  might run out of memory. In this case the message
>  .RS
>  .B out of memory
> 
