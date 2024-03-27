Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3FC28DCA
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 14:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711551341; cv=none; b=YjeKnoUWfjI2REJQ1V9n+ODle/VMnSAaXtSAYgcVOppWmUB8QvAzeLPHMrJI/1yRc4Xb72RU2C4KKlXtehYzp0wWX+ITRT+mvcfAoDlY0R5jbRWfes1KdTuOKvUszUWQoj9nQ4988IEDb1nxXLS1akSSH8/8Xa0FIX/EiDkqbAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711551341; c=relaxed/simple;
	bh=fvvosZSnV6iNWILAbAn/TaKIoRdkrb95jqDj8I5UtuI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bvipicjBbhf8syZEVrr2QxpuYxz5pGLiLU6S79sAyTlw9RXNh2nh15OnKzGpMflSfeOmMKLAowI47Fky9d/cDJJXsQpUES73lsXwltMRMbluFnd1uEcwgKCQnxpvq+5+19FXza+smSokFLGxMy5Ztg6aun8MCuaWZu8Ue7smAqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fwg6mZEn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fwg6mZEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7D4C433C7;
	Wed, 27 Mar 2024 14:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711551341;
	bh=fvvosZSnV6iNWILAbAn/TaKIoRdkrb95jqDj8I5UtuI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fwg6mZEnNYxBWb3l2C7l6InyB8SqEkSV3rNcxZ+Mxs7aJq4M2AxgEoNXTKCVNFZLB
	 YqCF2RYZI/QYVFYrvn8IRo0gTSBV+sqHTpZBryLVUiNWNaqV10uq54kSXk0FeL84S/
	 95rSlKel2o1JBh61vY6ckgom53HeUKD+SGgd/AhveMgvm7K+Ylnak6qMys3QL3A9Kp
	 gc5Rd7pHQ8KCTnSh/J6B0il5yP1iJ9ZVUJQ85vANFQF1bLiv8BN25AiuLxRLgQ+2Am
	 C95gMqrkcT6sdJjKkijEVc4ZfteE6eJMl6csyWaIvyZLjCRxHz24aRaxaedfEiMizs
	 j/PHZ+VFl7byg==
Date: Wed, 27 Mar 2024 07:55:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/13] xfs: free RT extents after updating the bmap btree
Message-ID: <20240327145540.GW6390@frogsfrogsfrogs>
References: <20240327110318.2776850-1-hch@lst.de>
 <20240327110318.2776850-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327110318.2776850-4-hch@lst.de>

On Wed, Mar 27, 2024 at 12:03:08PM +0100, Christoph Hellwig wrote:
> Currently xfs_bmap_del_extent_real frees RT extents before updating
> the bmap btree, while it frees regular blocks after performing the bmap
> btree update.  While this behavior goes back to the original commit,
> I can't find any good reason for handling RT extent vs regular block
> freeing differently.  We use the same transaction, and unless rmaps
> or reflink are enabled (which currently aren't support for RT inodes)
> there are no transactions rolls or deferred ops that can rely on this
> ordering.

...and the realtime rmap/reflink patchsets will want to reuse the data
device's ordering (bmap -> rmap -> refcount -> efi) for the rt volume.

> Signed-off-by: Christoph Hellwig <hch@lst.de>

I'm ok with moving this now since I'm mostly going to pave over it later
anyway :)

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 26 +++++++++-----------------
>  1 file changed, 9 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 09d4b730ee9709..282b44deb9f864 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5107,8 +5107,7 @@ xfs_bmap_del_extent_real(
>  {
>  	xfs_fsblock_t		del_endblock=0;	/* first block past del */
>  	xfs_fileoff_t		del_endoff;	/* first offset past del */
> -	int			do_fx;	/* free extent at end of routine */
> -	int			error;	/* error return value */
> +	int			error = 0;	/* error return value */
>  	struct xfs_bmbt_irec	got;	/* current extent entry */
>  	xfs_fileoff_t		got_endoff;	/* first offset past got */
>  	int			i;	/* temp state */
> @@ -5151,20 +5150,10 @@ xfs_bmap_del_extent_real(
>  		return -ENOSPC;
>  
>  	*logflagsp = XFS_ILOG_CORE;
> -	if (xfs_ifork_is_realtime(ip, whichfork)) {
> -		if (!(bflags & XFS_BMAPI_REMAP)) {
> -			error = xfs_rtfree_blocks(tp, del->br_startblock,
> -					del->br_blockcount);
> -			if (error)
> -				return error;
> -		}
> -
> -		do_fx = 0;
> +	if (xfs_ifork_is_realtime(ip, whichfork))
>  		qfield = XFS_TRANS_DQ_RTBCOUNT;
> -	} else {
> -		do_fx = 1;
> +	else
>  		qfield = XFS_TRANS_DQ_BCOUNT;
> -	}
>  	nblks = del->br_blockcount;
>  
>  	del_endblock = del->br_startblock + del->br_blockcount;
> @@ -5312,18 +5301,21 @@ xfs_bmap_del_extent_real(
>  	/*
>  	 * If we need to, add to list of extents to delete.
>  	 */
> -	if (do_fx && !(bflags & XFS_BMAPI_REMAP)) {
> +	if (!(bflags & XFS_BMAPI_REMAP)) {
>  		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
>  			xfs_refcount_decrease_extent(tp, del);
> +		} else if (xfs_ifork_is_realtime(ip, whichfork)) {
> +			error = xfs_rtfree_blocks(tp, del->br_startblock,
> +					del->br_blockcount);
>  		} else {
>  			error = xfs_free_extent_later(tp, del->br_startblock,
>  					del->br_blockcount, NULL,
>  					XFS_AG_RESV_NONE,
>  					((bflags & XFS_BMAPI_NODISCARD) ||
>  					del->br_state == XFS_EXT_UNWRITTEN));
> -			if (error)
> -				return error;
>  		}
> +		if (error)
> +			return error;
>  	}
>  
>  	/*
> -- 
> 2.39.2
> 
> 
