Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04573AEF22
	for <linux-xfs@vger.kernel.org>; Mon,  9 Mar 2026 16:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773074678; cv=none; b=NlpcFV6nPpRz3gjBZFfke1YDX283vsLYp1+1UyKMolsLaCubzvE24IoBB3d0Mgd4ksAdGRcaG36xAva7qKLri/xsSKtSFXrY3tWITG5j8MftOuWFnzrEkes8yr54LFJa4EJozUdHR3zuvOWgFU+3WMgOg9JQ2ke6Y8Jl8P1I1+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773074678; c=relaxed/simple;
	bh=JJj4Bj0W7L/yoL7L8v9aX1hypXY3tQEkeoyyNySevPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dlEJPuAtyXGXplqJUrk1Uym7/6lV+O1gGCw21EBSwv5BibWDgVClgc/+fQm9yGCY22UYis5RR9R1sCasvKlJIkomFlebgkLCA4zd6TZ0MZ/oUadJ85nCDAxjiGFFS0KRkDqqoS498XabdmYZLsptZZEWTGUM34YhktVMWwSdOKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Izxu2mwy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Izxu2mwy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75939C4CEF7;
	Mon,  9 Mar 2026 16:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773074678;
	bh=JJj4Bj0W7L/yoL7L8v9aX1hypXY3tQEkeoyyNySevPU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Izxu2mwyEb8d30doe5Ti/d/n3oea6mrcqDJM6GetZV9EpIsAJraUOlF/UyxMHNMX4
	 iP9CYxo0qAJt8gAnEz9AhOXDkIoyCqhC77Mlog3X2EFZtNZDfmguIzGfOHhRwgqEpf
	 RcX4a70VnOlhvCclLl7QLxvhJuCnhkZcVBn7jVw3t4CdoCvaCRmEoOphMyUM64wakd
	 G5HBPlzQ36qRuR5QqA9lDAN/NT5tG+J+sna+M41oItDbctYtV+1IKQ2Z+4XpwhgoM1
	 YYRRukXKx+Wr3O1QvYJ0sDIPbgmOZh02mjvHubLlIDdf840SXcCizsUSogknsebE4N
	 lEKvpc93gZGMw==
Date: Mon, 9 Mar 2026 09:44:37 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	lonuxli.64@gmail.com
Subject: Re: [PATCH 3/4] xfs: factor out xfs_attr3_leaf_init
Message-ID: <20260309164437.GJ6033@frogsfrogsfrogs>
References: <20260309082752.2039861-1-leo.lilong@huawei.com>
 <20260309082752.2039861-4-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309082752.2039861-4-leo.lilong@huawei.com>

On Mon, Mar 09, 2026 at 04:27:51PM +0800, Long Li wrote:
> Factor out wrapper xfs_attr3_leaf_init function, which exported for
> external use.
> 
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 20 ++++++++++++++++++++
>  fs/xfs/libxfs/xfs_attr_leaf.h |  3 +++
>  2 files changed, 23 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 47f48ae555c0..6599b53f4822 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -1415,6 +1415,26 @@ xfs_attr3_leaf_create(
>  	return 0;
>  }
>  
> +/*
> + * Wrapper function of initializing contents of a leaf, export for external use.
> + */
> +int
> +xfs_attr3_leaf_init(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*dp,
> +	xfs_dablk_t		blkno)
> +{
> +	struct xfs_buf		*bp = NULL;
> +	struct xfs_da_args	args;

Same thing as previous patch:

	struct xfs_da_args	args = {
		.trans		= tp,
		...
	};

Also I think this should just go in whichever patch uses the new
function since this is pretty trivial.

> +
> +	memset(&args, 0, sizeof(args));
> +	args.trans = tp;
> +	args.dp = dp;
> +	args.owner = dp->i_ino;
> +	args.geo = dp->i_mount->m_attr_geo;
> +
> +	return xfs_attr3_leaf_create(&args, blkno, &bp);

Ummm ... who releases the returned xfs_buf pointer?

--D

> +}
>  /*
>   * Split the leaf node, rebalance, then add the new entry.
>   *
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index aca46da2bc50..72639efe6ac3 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -87,6 +87,9 @@ int	xfs_attr3_leaf_list_int(struct xfs_buf *bp,
>  /*
>   * Routines used for shrinking the Btree.
>   */
> +
> +int	xfs_attr3_leaf_init(struct xfs_trans *tp, struct xfs_inode *dp,
> +				xfs_dablk_t blkno);
>  int	xfs_attr3_leaf_toosmall(struct xfs_da_state *state, int *retval);
>  void	xfs_attr3_leaf_unbalance(struct xfs_da_state *state,
>  				       struct xfs_da_state_blk *drop_blk,
> -- 
> 2.39.2
> 
> 
