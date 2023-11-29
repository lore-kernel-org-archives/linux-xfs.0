Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA62EEDD
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 01:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lKhbePGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E600C433C8;
	Wed, 29 Nov 2023 01:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701221039;
	bh=wYBGApJDhHriB36XYH+InpG8wbMRmxhp1tJKOrOBQwE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lKhbePGh2Y/QTvRyo54xWE0DCFvE5qrXt90o0gWoBHtk5il/vpIovOBqv52/JIfeg
	 W1NM5MM+b4XWOmYFbmbBjZtfhuMzp93uAe2qLYR7qnzZK2T4M1zii7lUABT3nlysA7
	 0x1sZ/9ixxugrU3bFKa1Fa92SC6eaGMX4aFm+qSbSNg0Ai+//EqnOXJ96Tz8rMQWAR
	 Sl2HKKVIihCo1D9r9OVEw41GWP+5t6X/xxr/2IGiV1/xnsDS2lwO6tJiLmYqG3w6Wu
	 mU5ovLT6MgVuGDGsItoMi7RwJMpU0jMK9x4+fT7yxcKuZVixn2J7vjS5sTtoCUVA3Y
	 4N3FfoxptteKA==
Date: Tue, 28 Nov 2023 17:23:58 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: check rt summary file geometry more thoroughly
Message-ID: <20231129012358.GG4167244@frogsfrogsfrogs>
References: <170086928333.2771542.10506226721850199807.stgit@frogsfrogsfrogs>
 <170086928377.2771542.14818456920992275639.stgit@frogsfrogsfrogs>
 <ZWXzvNHCV6QWeikg@infradead.org>
 <20231128233008.GF4167244@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128233008.GF4167244@frogsfrogsfrogs>

On Tue, Nov 28, 2023 at 03:30:09PM -0800, Darrick J. Wong wrote:
> On Tue, Nov 28, 2023 at 06:05:48AM -0800, Christoph Hellwig wrote:
> > > +	/*
> > > +	 * Now that we've locked the rtbitmap and rtsummary, we can't race with
> > > +	 * growfsrt trying to expand the summary or change the size of the rt
> > > +	 * volume.  Hence it is safe to compute and check the geometry values.
> > > +	 */
> > > +	rts->rextents = xfs_rtb_to_rtx(mp, mp->m_sb.sb_rblocks);
> > > +	rts->rbmblocks = xfs_rtbitmap_blockcount(mp, rts->rextents);
> > > +	rts->rsumlevels = rts->rextents ? xfs_highbit32(rts->rextents) + 1 : 0;
> > > +	rsumblocks = xfs_rtsummary_blockcount(mp, rts->rsumlevels,
> > > +			rts->rbmblocks);
> > > +	rts->rsumsize = XFS_FSB_TO_B(mp, rsumblocks);
> > 
> > Same nitpick as for the last patch.
> 
> LOL so I just tried a 64k rt volume with a 1M rextsize and mkfs crashed.
> I guess I'll go sort out what's going on there...

Oh good, XFS has been broken since the beginning of git history for the
stupid corner case where the rtblocks < rextsize.  In this case, mkfs
will set sb_rextents and sb_rextslog both to zero:

	sbp->sb_rextslog =
		(uint8_t)(rtextents ?
			libxfs_highbit32((unsigned int)rtextents) : 0);

However, that's not the check that xfs_repair uses for nonzero rtblocks:

	if (sb->sb_rextslog !=
			libxfs_highbit32((unsigned int)sb->sb_rextents))

The difference here is that xfs_highbit32 returns -1 if its argument is
zero, which means that for a runt rt volume, repair thinks the "correct"
value of rextslog is -1, even though mkfs wrote it as 0 and flags a
freshly formatted filesystem as corrupt.  Because mkfs has been writing
ondisk artifacts like this for decades, we have to accept that as
"correct".  TBH, zero rextslog for zero rtextents makes more sense to me
anyway.

Regrettably, the superblock verifier checks created in commit copied
xfs_repair even though mkfs has been writing out such filesystems for
ages.  In testing /that/ fix, I discovered that the logic above is
wrong -- rsumlevels is always rextslog + 1 when rblocks > 0, even if
rextents == 0.

IOWs, this logic needs to be:

	/*
	 * Now that we've locked the rtbitmap and rtsummary, we can't race with
	 * growfsrt trying to expand the summary or change the size of the rt
	 * volume.  Hence it is safe to compute and check the geometry values.
	 */
	if (mp->m_sb.sb_rblocks) {
		xfs_filblks_t	rsumblocks;
		int		rextslog = 0;

		rts->rextents = xfs_rtb_to_rtx(mp, mp->m_sb.sb_rblocks);
		if (rts->rextents)
			rextslog = xfs_highbit32(rts->rextents);
		rts->rsumlevels = rextslog + 1;
		rts->rbmblocks = xfs_rtbitmap_blockcount(mp, rts->rextents);
		rsumblocks = xfs_rtsummary_blockcount(mp, rts->rsumlevels,
				rts->rbmblocks);
		rts->rsumsize = XFS_FSB_TO_B(mp, rsumblocks);
	}

Yay winning.

--D

> > Otherwise looks good:
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Thanks!
> 
> --D
> 
