Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A535C12EBED
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 15:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711552077; cv=none; b=kHNQJTXldIVqoQV/FAiNNAbvXn5FaeJcC+86w7huLekwPu4HnIFYB+zql7Kt2VKOypIJF2SckdYMYYBtyNwtqjXdgImmLKOrzWEH0TdB0lLVUAn5bnqigTJOF67EYEXogZEbuqA0135ejDdMfdOOjzBj8eLG44CUfgmDlhOM99I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711552077; c=relaxed/simple;
	bh=g0NTT4AuILZDDHV0yhh/vmFcoipBH+CTNtBWxDJL0nc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YQofGfNs4QvBHUJlFTxNNNeuqiI9wBMtfvsfoNwfVpMuOc531wRZdq2WkEMVj1brGAojCOhLP3Hn3xum4yWs0qqpg8iM3hYQs+a88IcFAsv0eBAnsjib2tu43efUZNKfjyXtraBONbAHHwfDtn+r6T6gDL5Q2i7xkxAcZ/w5zlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cCgjNea5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cCgjNea5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23341C433C7;
	Wed, 27 Mar 2024 15:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711552077;
	bh=g0NTT4AuILZDDHV0yhh/vmFcoipBH+CTNtBWxDJL0nc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cCgjNea5CqdIMUMKFVQ8hXqqOgPnQ3LBv6Lc2HbKeRyoVwTjwuSUgMALxma0PdvRv
	 CzUJXP8o++ul0Af/7Co2QtcPGb+rX06UGobvWaAgNe4tHRFjgb2n/QWdtRhpeYuKWa
	 +JGncUn7lXmk61xGgfsx3ba25VgpTM7S4ENWuN708UJ++JIJ6jbqyk/5k0K3/Tepbu
	 uaq9P5iTywL9CV+j2r37xub+U+sfwA/JDVo2xAvCRtNvIkRjX3c/8ql+bmj6trcLO0
	 9LOwQ8Hcry9zR4EbynalWy55hcsyknuWwT8PyDYZy2EaDSRsXqy6nASRRvX+u50YvW
	 60D9IqNZtywYw==
Date: Wed, 27 Mar 2024 08:07:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/13] xfs: move RT inode locking out of __xfs_bunmapi
Message-ID: <20240327150755.GX6390@frogsfrogsfrogs>
References: <20240327110318.2776850-1-hch@lst.de>
 <20240327110318.2776850-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327110318.2776850-5-hch@lst.de>

On Wed, Mar 27, 2024 at 12:03:09PM +0100, Christoph Hellwig wrote:
> __xfs_bunmapi is a bit of an odd place to lock the rtbitmap and rtsummary
> inodes given that it is very high level code.  While this only looks ugly
> right now, it will become a problem when supporting delayed allocations
> for RT inodes as __xfs_bunmapi might end up deleting only delalloc extents
> and thus never unlock the rt inodes.
> 
> Move the locking into xfs_bmap_del_extent_real just before the call to
> xfs_rtfree_blocks instead and use a new flag in the transaction to ensure
> that the locking happens only once.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c   | 15 ++++++++-------
>  fs/xfs/libxfs/xfs_shared.h |  3 +++
>  2 files changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 282b44deb9f864..e5e199d325982f 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5305,6 +5305,14 @@ xfs_bmap_del_extent_real(
>  		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
>  			xfs_refcount_decrease_extent(tp, del);
>  		} else if (xfs_ifork_is_realtime(ip, whichfork)) {
> +			/*
> +			 * Ensure the bitmap and summary inodes are locked
> +			 * and joined to the transaction before modifying them.
> +			 */
> +			if (!(tp->t_flags & XFS_TRANS_RTBITMAP_LOCKED)) {
> +				tp->t_flags |= XFS_TRANS_RTBITMAP_LOCKED;

How does it happen that xfs_rtfree_blocks gets called more than once in
the same transaction?  Is that simply the effect of xfs_bunmapi_range
and xfs_unmap_exten calling __xfs_bunmapi with
nextents == XFS_ITRUNC_MAX_EXTENTS==2?

What if we simply didn't unmap multiple extents per bunmapi call for
realtime files?  Would that eliminate the need for
XFS_TRANS_RTBITMAP_LOCKED?

--D

> +				xfs_rtbitmap_lock(tp, mp);
> +			}
>  			error = xfs_rtfree_blocks(tp, del->br_startblock,
>  					del->br_blockcount);
>  		} else {
> @@ -5406,13 +5414,6 @@ __xfs_bunmapi(
>  	} else
>  		cur = NULL;
>  
> -	if (isrt) {
> -		/*
> -		 * Synchronize by locking the realtime bitmap.
> -		 */
> -		xfs_rtbitmap_lock(tp, mp);
> -	}
> -
>  	extno = 0;
>  	while (end != (xfs_fileoff_t)-1 && end >= start &&
>  	       (nexts == 0 || extno < nexts)) {
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index f35640ad3e7fe4..34f104ed372c09 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -137,6 +137,9 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
>   */
>  #define XFS_TRANS_LOWMODE		(1u << 8)
>  
> +/* Transaction has locked the rtbitmap and rtsum inodes */
> +#define XFS_TRANS_RTBITMAP_LOCKED	(1u << 9)
> +
>  /*
>   * Field values for xfs_trans_mod_sb.
>   */
> -- 
> 2.39.2
> 
> 
