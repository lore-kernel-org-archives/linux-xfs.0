Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF5A273FD
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 20:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iI24rfD1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF728C433C8;
	Thu, 14 Dec 2023 20:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702586819;
	bh=3Nm3bM8nF8TfrgPnStINtxMztbRnkGTZUZ3Ws+itgWk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iI24rfD1XAROLs53jNqC0AGwwyIajBAwYW3tEZpPyfoKtCnpNsCWdQavFpcvvoqJp
	 DBFUIgTr6kENTVSpHrKky0ryo0aHUH7qPecVDgleyeUr8WetICtNDwP7FZLlT5rPMD
	 oiFI8RtjSvc4ErOALhSMb4QfuEi0v2hEjkoSLxAYdzM8Wdxxd7EMGVaaw8wm6p8dfl
	 H9NS4dgR+cEZc/T5UKlXzoWI7KilwSzJibYi4YGr0FZ8zcy6qqFpWF8IjPgWplsfNa
	 PuA2muOOF6sw0WhwclLKJzVy7Q3GsI4KUmq7P9WUXxEB8WcsZV3HID85xDXSkEVh1T
	 yQjprf1t2SXww==
Date: Thu, 14 Dec 2023 12:46:59 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/19] xfs: also use xfs_bmap_btalloc_accounting for RT
 allocations
Message-ID: <20231214204659.GS361584@frogsfrogsfrogs>
References: <20231214063438.290538-1-hch@lst.de>
 <20231214063438.290538-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214063438.290538-5-hch@lst.de>

On Thu, Dec 14, 2023 at 07:34:23AM +0100, Christoph Hellwig wrote:
> Make xfs_bmap_btalloc_accounting more generic by handling the RT quota
> reservations and then also use it from xfs_bmap_rtalloc instead of
> open coding the accounting logic there.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Better than the copypasta that I came up with...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 21 ++++++++++++++-------
>  fs/xfs/libxfs/xfs_bmap.h |  2 ++
>  fs/xfs/xfs_bmap_util.c   | 12 +-----------
>  3 files changed, 17 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index afdfb3455d9ebe..6722205949ad4c 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3263,10 +3263,14 @@ xfs_bmap_btalloc_select_lengths(
>  }
>  
>  /* Update all inode and quota accounting for the allocation we just did. */
> -static void
> -xfs_bmap_btalloc_accounting(
> +void
> +xfs_bmap_alloc_account(
>  	struct xfs_bmalloca	*ap)
>  {
> +	bool			isrt = XFS_IS_REALTIME_INODE(ap->ip) &&
> +					(ap->flags & XFS_BMAPI_ATTRFORK);
> +	uint			fld;
> +
>  	if (ap->flags & XFS_BMAPI_COWFORK) {
>  		/*
>  		 * COW fork blocks are in-core only and thus are treated as
> @@ -3291,7 +3295,8 @@ xfs_bmap_btalloc_accounting(
>  		 * to that of a delalloc extent.
>  		 */
>  		ap->ip->i_delayed_blks += ap->length;
> -		xfs_trans_mod_dquot_byino(ap->tp, ap->ip, XFS_TRANS_DQ_RES_BLKS,
> +		xfs_trans_mod_dquot_byino(ap->tp, ap->ip, isrt ?
> +				XFS_TRANS_DQ_RES_RTBLKS : XFS_TRANS_DQ_RES_BLKS,
>  				-(long)ap->length);
>  		return;
>  	}
> @@ -3302,10 +3307,12 @@ xfs_bmap_btalloc_accounting(
>  	if (ap->wasdel) {
>  		ap->ip->i_delayed_blks -= ap->length;
>  		xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)ap->length);
> +		fld = isrt ? XFS_TRANS_DQ_DELRTBCOUNT : XFS_TRANS_DQ_DELBCOUNT;
> +	} else {
> +		fld = isrt ? XFS_TRANS_DQ_RTBCOUNT : XFS_TRANS_DQ_BCOUNT;
>  	}
> -	xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
> -		ap->wasdel ? XFS_TRANS_DQ_DELBCOUNT : XFS_TRANS_DQ_BCOUNT,
> -		ap->length);
> +
> +	xfs_trans_mod_dquot_byino(ap->tp, ap->ip, fld, ap->length);
>  }
>  
>  static int
> @@ -3379,7 +3386,7 @@ xfs_bmap_process_allocated_extent(
>  		ap->offset = orig_offset;
>  	else if (ap->offset + ap->length < orig_offset + orig_length)
>  		ap->offset = orig_offset + orig_length - ap->length;
> -	xfs_bmap_btalloc_accounting(ap);
> +	xfs_bmap_alloc_account(ap);
>  }
>  
>  #ifdef DEBUG
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index e33470e39728d5..cb86f3d15abe9f 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -116,6 +116,8 @@ static inline int xfs_bmapi_whichfork(uint32_t bmapi_flags)
>  	return XFS_DATA_FORK;
>  }
>  
> +void xfs_bmap_alloc_account(struct xfs_bmalloca *ap);
> +
>  /*
>   * Special values for xfs_bmbt_irec_t br_startblock field.
>   */
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 731260a5af6db4..d6432a7ef2857d 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -168,17 +168,7 @@ xfs_bmap_rtalloc(
>  	if (rtx != NULLRTEXTNO) {
>  		ap->blkno = xfs_rtx_to_rtb(mp, rtx);
>  		ap->length = xfs_rtxlen_to_extlen(mp, ralen);
> -		ap->ip->i_nblocks += ap->length;
> -		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
> -		if (ap->wasdel)
> -			ap->ip->i_delayed_blks -= ap->length;
> -		/*
> -		 * Adjust the disk quota also. This was reserved
> -		 * earlier.
> -		 */
> -		xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
> -			ap->wasdel ? XFS_TRANS_DQ_DELRTBCOUNT :
> -					XFS_TRANS_DQ_RTBCOUNT, ap->length);
> +		xfs_bmap_alloc_account(ap);
>  		return 0;
>  	}
>  
> -- 
> 2.39.2
> 
> 
