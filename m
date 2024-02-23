Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E9A12EBC6
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 17:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708709124; cv=none; b=cPlE5FtJb8++U/3BvXXxim9Vve7uJuwlU3Dr8F5MywYZVvrZOrKb4aZbxpp3RNL/+eCRBlwgZxFeYF68CRNJtKOMEijZyhBDHfgJaQZYrgCARdkePi43x+iAhp55eCW59s83afAYHCddYgBwUP2GwUpD+siId4Et4Gjxk1kOAF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708709124; c=relaxed/simple;
	bh=KhANuhU77EEBNMamw0DgdNgcu//anNkJUuHL8giO46U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jGZACXsX1Rqo2hnictHmEINPts+JhYpmBG6uqgVfTAS/azpP8yfWBGsI+J6FyU1ixCWhZ3YZDtATdkz6ZeDipLk2MGM1e0gRIqHOE2L8vvPMOYzrp8HWGg0ndhyXYEgTY0wwpuM4mgX0LGd9OxEdrgQ6Kxu2hNa4CpSSGzSPT4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G1AmlIXZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G1AmlIXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3D1C433F1;
	Fri, 23 Feb 2024 17:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708709123;
	bh=KhANuhU77EEBNMamw0DgdNgcu//anNkJUuHL8giO46U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G1AmlIXZz2ARu/4WHPY0bJ+71ITwe/O9AaKo4h0+vIqBjz+S4JEdY6CYLFXzmVLrl
	 2QEL0nXQ3fnN/TJna9BQde73B9KZO1ZL3cluG+x/nxsqBm2rVgtQ5tO6zwY/uJnMtZ
	 vNNxRnK5ltWEdsSV+kiXwkmiq4qnkVugLHH/DRC4XjwCC6AR43HDL9tbbmrDyWEqGJ
	 qorMHUJdsXoU70Ma0EHwMd2k3q90AgdJhiJKXF87B9F8fG5n4OiMEUBvl2EmaDVbOX
	 mYxpf5D0n3A6tOZb3YqqE/syPzYgz4/EBcfBagJQ60bEju+FgbuYmag1F6rWS6KImJ
	 2AzqYVcXDJpng==
Date: Fri, 23 Feb 2024 09:25:23 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/10] xfs: stop the steal (of data blocks for RT
 indirect blocks)
Message-ID: <20240223172523.GV616564@frogsfrogsfrogs>
References: <20240223071506.3968029-1-hch@lst.de>
 <20240223071506.3968029-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223071506.3968029-10-hch@lst.de>

On Fri, Feb 23, 2024 at 08:15:05AM +0100, Christoph Hellwig wrote:
> When xfs_bmap_del_extent_delay has to split an indirect block it tries
> to steal blocks from the the part that gets unmapped to increase the
> indirect block reservation that now needs to cover for two extents
> instead of one.
> 
> This works perfectly fine on the data device, where the data and
> indirect blocks come from the same pool.  It has no chance of working
> when the inode sits on the RT device.  To support re-enabling delalloc
> for inodes on the RT device, make this behavior conditional on not
> beeing for rt extents.  For an RT extent try allocate new blocks or
> otherwise just give up.
> 
> Note that split of delalloc extents should only happen on writeback
> failure, as for other kinds of hole punching we first write back all
> data and thus convert the delalloc reservations covering the hole to
> a real allocation.
> 
> Note that restoring a quota reservation is always a bit problematic,
> but the force flag should take care of it.  That is, if we actually
> supported quota with the RT volume, which seems to not be the case
> at the moment.

...and for anyone following along at home, this should address that
problem:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-quotas_2024-02-21

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 27 ++++++++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index d7fda286a4eaa0..4fa178087073b1 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4912,6 +4912,30 @@ xfs_bmap_del_extent_delay(
>  		WARN_ON_ONCE(!got_indlen || !new_indlen);
>  		stolen = xfs_bmap_split_indlen(da_old, &got_indlen, &new_indlen,
>  						       del->br_blockcount);
> +		if (isrt && stolen) {
> +			/*
> +			 * Ugg, we can't just steal reservations from the data
> +			 * blocks as the data blocks come from a different pool.
> +			 *
> +			 * So we have to try to increase out reservations here,

"...try to increase our reservation here..."

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +			 * and if that fails we have to fail the unmap.  To
> +			 * avoid that as much as possible dip into the reserve
> +			 * pool.
> +			 *
> +			 * Note that in theory the user/group/project could
> +			 * be over the quota limit in the meantime, thus we
> +			 * force the quota accounting even if it was over the
> +			 * limit.
> +			 */
> +			error = xfs_dec_fdblocks(mp, stolen, true);
> +			if (error) {
> +				ip->i_delayed_blks += del->br_blockcount;
> +				xfs_trans_reserve_quota_nblks(NULL, ip, 0,
> +						del->br_blockcount, true);
> +				return error;
> +			}
> +			xfs_mod_delalloc(ip, 0, stolen);
> +		}
>  
>  		got->br_startblock = nullstartblock((int)got_indlen);
>  
> @@ -4924,7 +4948,8 @@ xfs_bmap_del_extent_delay(
>  		xfs_iext_insert(ip, icur, &new, state);
>  
>  		da_new = got_indlen + new_indlen - stolen;
> -		del->br_blockcount -= stolen;
> +		if (!isrt)
> +			del->br_blockcount -= stolen;
>  		break;
>  	}
>  
> -- 
> 2.39.2
> 
> 
