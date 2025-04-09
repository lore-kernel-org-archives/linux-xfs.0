Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFE4267386
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 16:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744215013; cv=none; b=F25elJNGxgYfSJShYomgynKTCpE/IhJIj/xKN/AVTdOvVnTHliHBYFbe0VMvD2+OsxxxV2mMmHgl72flYbRSnziaSuMKWJ6Rv44WwCkoLq111P5/CT7waTCpmME+yO1fc5Mvoim+4+88d9o8C45SODBo34H+64fy9LyB+TXdstE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744215013; c=relaxed/simple;
	bh=sfHJW5NYT1U9iafhz65GkBxH8Qf/0OOEULCroem96nk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lp+hdP7hfGz2T2nCSRujLqOjynJ/EqCLNxB7pBrXRrQUKhc4JhVs9iYumn4zhgRRE4EoF5s6jPOcXPA/ZWDtJOHNry/j0ct0A5LlMk2Z0tO+2ik2BAsLwV8y/mH2Su0Sq/hZCxDtvrkI7dBb1MS0DdfeRUxVrZ78vat1kph51dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oPxQq/DY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oPxQq/DY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12F0C4CEE2;
	Wed,  9 Apr 2025 16:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744215012;
	bh=sfHJW5NYT1U9iafhz65GkBxH8Qf/0OOEULCroem96nk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oPxQq/DYxuHvbVmuejDr709K8bc/qOIUwdvtIgycgD8gYBb3iFCxO85TDqgL9MyLV
	 Pz2+o40XloK5kJxPwakJRgeyhrqM0FgOzFg7mWfr/bR/SE4NswpbHbwYkwVMzDudrH
	 z0AhE4z+V+J+WFkLZzoT/0DJkM28Nr+XLDU6OveaJtJJskSVbYmWdeCPH6tZHADnK3
	 pUaObSqRsBlgwreZQYpOVU9RXa2Q82SNEEt/BDObYwUywqjMmGVD4wQYdxYDpi8cit
	 jBhqObnUv+35f15PCOg1wFzaonskk4kWDcWv4k0GgrDyQrfx0SkZERLmOrgGZKtJOn
	 tLlaJo8gBhaWA==
Date: Wed, 9 Apr 2025 09:10:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/45] xfs_repair: support repairing zoned file systems
Message-ID: <20250409161012.GC6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-28-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409075557.3535745-28-hch@lst.de>

On Wed, Apr 09, 2025 at 09:55:30AM +0200, Christoph Hellwig wrote:
> Note really much to do here.  Mostly ignore the validation and
> regeneration of the bitmap and summary inodes.  Eventually this
> could grow a bit of validation of the hardware zone state.

What do we actually do about the hardware zone state?  If the write
pointer is lower than wherever the rtrmapbt thinks it is, then we're
screwed, right?

Does it matter if the hw write pointer is higher than where the rtrmapbt
thinks it is?  In that case, a new write will be beyond the last write
that the filesystem knows about, but the device will tell us the disk
address so it's all good aside from the freertx counters being wrong.  I
think?

The code changes presented here look ok to me though.

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  repair/dinode.c        |  4 +++-
>  repair/phase5.c        | 13 +++++++++++++
>  repair/phase6.c        |  6 ++++--
>  repair/rt.c            |  2 ++
>  repair/rtrmap_repair.c | 33 +++++++++++++++++++++++++++++++++
>  repair/xfs_repair.c    |  9 ++++++---
>  6 files changed, 61 insertions(+), 6 deletions(-)
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 8696a838087f..7bdd3dcf15c1 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -3585,7 +3585,9 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
>  
>  	validate_extsize(mp, dino, lino, dirty);
>  
> -	if (dino->di_version >= 3)
> +	if (dino->di_version >= 3 &&
> +	    (!xfs_has_zoned(mp) ||
> +	     dino->di_metatype != cpu_to_be16(XFS_METAFILE_RTRMAP)))
>  		validate_cowextsize(mp, dino, lino, dirty);
>  
>  	/* nsec fields cannot be larger than 1 billion */
> diff --git a/repair/phase5.c b/repair/phase5.c
> index 4cf28d8ae1a2..e350b411c243 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -630,6 +630,19 @@ void
>  check_rtmetadata(
>  	struct xfs_mount	*mp)
>  {
> +	if (xfs_has_zoned(mp)) {
> +		/*
> +		 * Here we could/should verify the zone state a bit when we are
> +		 * on actual zoned devices:
> +		 *	- compare hw write pointer to last written
> +		 *	- compare zone state to last written
> +		 *
> +		 * Note much we can do when running in zoned mode on a
> +		 * conventional device.
> +		 */
> +		return;
> +	}
> +
>  	generate_rtinfo(mp);
>  	check_rtbitmap(mp);
>  	check_rtsummary(mp);
> diff --git a/repair/phase6.c b/repair/phase6.c
> index dbc090a54139..a7187e84daae 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -3460,8 +3460,10 @@ _("        - resetting contents of realtime bitmap and summary inodes\n"));
>  		return;
>  
>  	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
> -		ensure_rtgroup_bitmap(rtg);
> -		ensure_rtgroup_summary(rtg);
> +		if (!xfs_has_zoned(mp)) {
> +			ensure_rtgroup_bitmap(rtg);
> +			ensure_rtgroup_summary(rtg);
> +		}
>  		ensure_rtgroup_rmapbt(rtg, est_fdblocks);
>  		ensure_rtgroup_refcountbt(rtg, est_fdblocks);
>  	}
> diff --git a/repair/rt.c b/repair/rt.c
> index e0a4943ee3b7..a2478fb635e3 100644
> --- a/repair/rt.c
> +++ b/repair/rt.c
> @@ -222,6 +222,8 @@ check_rtfile_contents(
>  	xfs_fileoff_t		bno = 0;
>  	int			error;
>  
> +	ASSERT(!xfs_has_zoned(mp));
> +
>  	if (!ip) {
>  		do_warn(_("unable to open %s file\n"), filename);
>  		return;
> diff --git a/repair/rtrmap_repair.c b/repair/rtrmap_repair.c
> index 2b07e8943e59..955db1738fe2 100644
> --- a/repair/rtrmap_repair.c
> +++ b/repair/rtrmap_repair.c
> @@ -141,6 +141,37 @@ xrep_rtrmap_btree_load(
>  	return error;
>  }
>  
> +static void
> +rtgroup_update_counters(
> +	struct xfs_rtgroup	*rtg)
> +{
> +	struct xfs_inode	*rmapip = rtg->rtg_inodes[XFS_RTGI_RMAP];
> +	struct xfs_mount	*mp = rtg_mount(rtg);
> +	uint64_t		end =
> +		xfs_rtbxlen_to_blen(mp, rtg->rtg_extents);
> +	xfs_agblock_t		gbno = 0;
> +	uint64_t		used = 0;
> +
> +	do {
> +		int		bstate;
> +		xfs_extlen_t	blen;
> +
> +		bstate = get_bmap_ext(rtg_rgno(rtg), gbno, end, &blen, true);
> +		switch (bstate) {
> +		case XR_E_INUSE:
> +		case XR_E_INUSE_FS:
> +			used += blen;
> +			break;
> +		default:
> +			break;
> +		}
> +
> +		gbno += blen;
> +	} while (gbno < end);
> +
> +	rmapip->i_used_blocks = used;
> +}
> +
>  /* Update the inode counters. */
>  STATIC int
>  xrep_rtrmap_reset_counters(
> @@ -153,6 +184,8 @@ xrep_rtrmap_reset_counters(
>  	 * generated.
>  	 */
>  	sc->ip->i_nblocks = rr->new_fork_info.ifake.if_blocks;
> +	if (xfs_has_zoned(sc->mp))
> +		rtgroup_update_counters(rr->rtg);
>  	libxfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
>  
>  	/* Quotas don't exist so we're done. */
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index eeaaf6434689..7bf75c09b945 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -1388,16 +1388,19 @@ main(int argc, char **argv)
>  	 * Done with the block usage maps, toss them.  Realtime metadata aren't
>  	 * rebuilt until phase 6, so we have to keep them around.
>  	 */
> -	if (mp->m_sb.sb_rblocks == 0)
> +	if (mp->m_sb.sb_rblocks == 0) {
>  		rmaps_free(mp);
> -	free_bmaps(mp);
> +		free_bmaps(mp);
> +	}
>  
>  	if (!bad_ino_btree)  {
>  		phase6(mp);
>  		phase_end(mp, 6);
>  
> -		if (mp->m_sb.sb_rblocks != 0)
> +		if (mp->m_sb.sb_rblocks != 0) {
>  			rmaps_free(mp);
> +			free_bmaps(mp);
> +		}
>  		free_rtgroup_inodes();
>  
>  		phase7(mp, phase2_threads);
> -- 
> 2.47.2
> 
> 
