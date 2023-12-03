Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2404F28E1
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 19:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KKLlsXKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F68C433C7;
	Sun,  3 Dec 2023 19:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701630591;
	bh=EgqN46+GaUk00ZRhhxLX+mSBvbfugLiSZ9aQqe6sboM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KKLlsXKZRusHvQRq1WXh+ty3rDc/THJ9RhxNPwTr09ZGw1o98kUee7isuccTZn92o
	 No3cog1mmk2mE6J+hd9YSGndui9sOWU9UthCO5S0e1pstiP3kR7X7zBq9B8rGkDWED
	 vlqCFSxkbg1FJjiZ9T++ogp8EpQzUTmEs8Bgy3uweetivQgAoGgpZtkyX99fJNV7xp
	 e8NIkDMe9r5ChkA4qSWh8lAQOgl4XlR+YUTBGtWe06U5AZ+pmAwaD41Kl2mkaopt93
	 6eKe+JYwVqcFv5ccmwY50lUTIUaHvNgqPChwY3Eno75StPvHMoDVBAVj8sgeSLQZX8
	 MAPzJSQ2kZVAQ==
Date: Sun, 3 Dec 2023 11:09:51 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: don't allow overly small or large realtime
 volumes
Message-ID: <20231203190951.GV361584@frogsfrogsfrogs>
References: <170162990622.3038044.5313475096294285406.stgit@frogsfrogsfrogs>
 <170162990673.3038044.6698602496725473343.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170162990673.3038044.6698602496725473343.stgit@frogsfrogsfrogs>

On Sun, Dec 03, 2023 at 11:05:50AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Don't allow realtime volumes that are less than one rt extent long.
> This has been broken across 4 LTS kernels with nobody noticing, so let's
> just disable it.
> 
> Per the previous patch, I also observed integer overflows in calculating
> rextslog (the number of rt summary levels) when the rtextent count
> exceeds 2^32.  If you're lucky, this means that mkfs will fail to format
> the filesystem; if not, then the fs will go down due to corruption
> errors.  Prohibit those too; larger volume support will return with
> rtgroups.

....aaand I forgot to update the commit message on this one, sorry.
Strike the previous paragraph, please.

--D

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_rtbitmap.h |   12 ++++++++++++
>  fs/xfs/libxfs/xfs_sb.c       |    3 ++-
>  fs/xfs/xfs_rtalloc.c         |    2 ++
>  3 files changed, 16 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
> index 1610d0e4a04c..411de3b889ae 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.h
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.h
> @@ -353,6 +353,18 @@ int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
>  
>  uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
>  
> +/* Do we support an rt volume having this number of rtextents? */
> +static inline bool
> +xfs_validate_rtextents(
> +	xfs_rtbxlen_t		rtextents)
> +{
> +	/* No runt rt volumes */
> +	if (rtextents == 0)
> +		return false;
> +
> +	return true;
> +}
> +
>  xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t
>  		rtextents);
>  unsigned long long xfs_rtbitmap_wordcount(struct xfs_mount *mp,
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index df12bf82ed18..4a9e8588f4c9 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -509,7 +509,8 @@ xfs_validate_sb_common(
>  		rbmblocks = howmany_64(sbp->sb_rextents,
>  				       NBBY * sbp->sb_blocksize);
>  
> -		if (sbp->sb_rextents != rexts ||
> +		if (!xfs_validate_rtextents(rexts) ||
> +		    sbp->sb_rextents != rexts ||
>  		    sbp->sb_rextslog != xfs_compute_rextslog(rexts) ||
>  		    sbp->sb_rbmblocks != rbmblocks) {
>  			xfs_notice(mp,
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 7c5a50163d2d..8feb58c6241c 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -963,6 +963,8 @@ xfs_growfs_rt(
>  	 */
>  	nrextents = nrblocks;
>  	do_div(nrextents, in->extsize);
> +	if (!xfs_validate_rtextents(nrextents))
> +		return -EINVAL;
>  	nrbmblocks = xfs_rtbitmap_blockcount(mp, nrextents);
>  	nrextslog = xfs_compute_rextslog(nrextents);
>  	nrsumlevels = nrextslog + 1;
> 
> 
