Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF73C39CD0A;
	Fri,  4 Sep 2026 07:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788507264; cv=none; b=cmldpJb2JoY44dhYi2RMveQNZiL3wUDPogkLNQ2lLI06SGWa3UMGx5oqREVzez1gSrJHSj1cLkVVoQZfZaMAF6nSeNArBQ859YolJJPE06YLc8kinhSWlJ9U6Mt1COplufmj4P2/SvC6AK1Ebo+vYb3M2ynXgcze7hwSuKjSkyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788507264; c=relaxed/simple;
	bh=pS8o9sHFURaJwAXp7Zs9H6NyZYnvXx5V7Ah8yLAZ3Ls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X5RJXqyV0kPppg+R7tm4y5EOe+kZN/D0GLV09Fc40xIlaxaiQtezpMfiyEFoRCXYKln4HzBj95PFieCZO22vgt89JD9oG5qVY2PFx8TV84lV6veiV75xFjMnLfg3b0JYFhpnGgqai9hLMDj2KjeS+eUPeEKia4Qj94h8PbxMEd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DO3hv7OF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DO3hv7OF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48DD71F00A3E;
	Fri,  4 Sep 2026 07:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788507262;
	bh=UaxXV92IiKGBbrmfPsGocY39TqOzc5a1IZJSHEDNlyg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DO3hv7OFaPcZlNVBC5wWrqjuY+X2G86C0XZ0g4jRSDP0d85HH24BPui/fLcNxY5mL
	 ZB2VX29ssJltnreraljPqKwLMl0oFTPzmQU7Kf3t++1TzQpi0Gn4pcKNNLD4R2imUS
	 NJyfeHY772YWnDQS3Bb5qShU+aVvKnSlllth/o9+buPqqGJMU2cF+kRAUJLGLgWCga
	 IOUKpTBOfKZYdlRAMil5Xfm6S6M7IGEg25s9M+W4CbNu41xmr1hW7mM1gQ29uGkXey
	 vampYsvVAKnANt7cYiU0xy93cd9ChXHi3SCCqYKLPxT6anmO1IUKwDEROqCmPXrf0Y
	 5v1DrJurTPYqg==
Date: Fri, 4 Sep 2026 09:34:18 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: snapshot old AGFL before rewriting it
Message-ID: <app0dPu7EhgyX2OJ@andromeda.toxiclabs.cc>
References: <178850312462.1198660.3332635535003842521.stgit@frogsfrogsfrogs>
 <178850312604.1198660.10155894539984458686.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178850312604.1198660.10155894539984458686.stgit@frogsfrogsfrogs>

On Thu, Sep 03, 2026 at 11:27:04PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM complains that we can't undo an attempt at fixing the AGFL if
> anything goes wrong during the rewrite, so take a snapshot of the whole
> buffer so that we can restore it.  Move the xrep_agfl_update_agf call so
> that we only update the AGF if the AGFL update is 100% successful.
> 
> Cc: <stable@vger.kernel.org> # v4.19
> Fixes: 0e93d3f43ec7d3 ("xfs: repair the AGFL")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Assisted-by: LOLLM # finding obvious bugs
> ---
>  fs/xfs/scrub/agheader_repair.c |   37 ++++++++++++++++++++++++++-----------
>  1 file changed, 26 insertions(+), 11 deletions(-)

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> 
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 2104512f1ee19a..46c95354ca6438 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -668,14 +668,16 @@ xrep_agfl_init_header(
>  	struct xfs_scrub	*sc,
>  	struct xfs_buf		*agfl_bp,
>  	struct xagb_bitmap	*agfl_extents,
> -	xfs_agblock_t		flcount)
> +	xfs_agblock_t		flcount,
> +	struct xfs_agfl		*old_agfl)
>  {
>  	struct xrep_agfl_fill	af = {
>  		.sc		= sc,
>  		.flcount	= flcount,
>  	};
>  	struct xfs_mount	*mp = sc->mp;
> -	struct xfs_agfl		*agfl;
> +	struct xfs_agfl		*agfl = XFS_BUF_TO_AGFL(agfl_bp);
> +	const size_t		agfl_sz = BBTOB(agfl_bp->b_length);
>  	int			error;
>  
>  	ASSERT(flcount <= xfs_agfl_size(mp));
> @@ -684,8 +686,8 @@ xrep_agfl_init_header(
>  	 * Start rewriting the header by setting the bno[] array to
>  	 * NULLAGBLOCK, then setting AGFL header fields.
>  	 */
> -	agfl = XFS_BUF_TO_AGFL(agfl_bp);
> -	memset(agfl, 0xFF, BBTOB(agfl_bp->b_length));
> +	memcpy(old_agfl, agfl, agfl_sz);
> +	memset(agfl, 0xFF, agfl_sz);
>  	agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
>  	agfl->agfl_seqno = cpu_to_be32(pag_agno(sc->sa.pag));
>  	uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid);
> @@ -700,13 +702,18 @@ xrep_agfl_init_header(
>  	xagb_bitmap_walk(agfl_extents, xrep_agfl_fill, &af);
>  	error = xagb_bitmap_disunion(agfl_extents, &af.used_extents);
>  	if (error)
> -		return error;
> +		goto err_undo;
>  
>  	/* Write new AGFL to disk. */
>  	xfs_trans_buf_set_type(sc->tp, agfl_bp, XFS_BLFT_AGFL_BUF);
> -	xfs_trans_log_buf(sc->tp, agfl_bp, 0, BBTOB(agfl_bp->b_length) - 1);
> +	xfs_trans_log_buf(sc->tp, agfl_bp, 0, agfl_sz - 1);
>  	xagb_bitmap_destroy(&af.used_extents);
>  	return 0;
> +
> +err_undo:
> +	xagb_bitmap_destroy(&af.used_extents);
> +	memcpy(agfl, old_agfl, agfl_sz);
> +	return error;
>  }
>  
>  /* Repair the AGFL. */
> @@ -718,6 +725,7 @@ xrep_agfl(
>  	struct xfs_mount	*mp = sc->mp;
>  	struct xfs_buf		*agf_bp;
>  	struct xfs_buf		*agfl_bp;
> +	struct xfs_agfl		*old_agfl;
>  	xfs_agblock_t		flcount;
>  	int			error;
>  
> @@ -725,6 +733,10 @@ xrep_agfl(
>  	if (!xfs_has_rmapbt(mp))
>  		return -EOPNOTSUPP;
>  
> +	old_agfl = kzalloc(BBTOB(XFS_FSS_TO_BB(mp, 1)), XCHK_GFP_FLAGS);
> +	if (!old_agfl)
> +		return -ENOMEM;
> +
>  	xagb_bitmap_init(&agfl_extents);
>  
>  	/*
> @@ -734,7 +746,7 @@ xrep_agfl(
>  	 */
>  	error = xfs_alloc_read_agf(sc->sa.pag, sc->tp, 0, &agf_bp);
>  	if (error)
> -		return error;
> +		goto err_old_agfl;
>  
>  	/*
>  	 * Make sure we have the AGFL buffer, as scrub might have decided it
> @@ -745,7 +757,7 @@ xrep_agfl(
>  						XFS_AGFL_DADDR(mp)),
>  			XFS_FSS_TO_BB(mp, 1), 0, &agfl_bp, NULL);
>  	if (error)
> -		return error;
> +		goto err_old_agfl;
>  	agfl_bp->b_ops = &xfs_agfl_buf_ops;
>  
>  	/* Gather all the extents we're going to put on the new AGFL. */
> @@ -762,10 +774,11 @@ xrep_agfl(
>  	 * we adjust the AGF flcount (which can fail) so avoid updating any
>  	 * buffers until we know that part works.
>  	 */
> +	error = xrep_agfl_init_header(sc, agfl_bp, &agfl_extents, flcount,
> +			old_agfl);
> +	if (error)
> +		goto err;
>  	xrep_agfl_update_agf(sc, agf_bp, flcount);
> -	error = xrep_agfl_init_header(sc, agfl_bp, &agfl_extents, flcount);
> -	if (error)
> -		goto err;
>  
>  	/*
>  	 * Ok, the AGFL should be ready to go now.  Roll the transaction to
> @@ -785,6 +798,8 @@ xrep_agfl(
>  
>  err:
>  	xagb_bitmap_destroy(&agfl_extents);
> +err_old_agfl:
> +	kfree(old_agfl);
>  	return error;
>  }
>  
> 
> 
