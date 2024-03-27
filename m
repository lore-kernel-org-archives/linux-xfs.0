Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FE412DDB1
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 15:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711552731; cv=none; b=sDJVbzAg/hIEuilfILNZ76kZZcsPVQtjO0/LQ4VcTocJu6JYPLD7HqGaPEsR4E4EL1uYG4X8swhg29K7CVpESxShA/SpquBOTMmPgHJgUiGV/2lJeto0/dBm3cuhHcoGlJOe7GeTc/c0mS0mkuCoyfdA9wFTdVqGFduuZ1RxjTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711552731; c=relaxed/simple;
	bh=Dqx1PgK6etWW+VQ8jL7xEdiF4kFZH7zkXsNgYeLd/b8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lcUGRU1wzgp48xLFOpcDnImEv3fK5r4MANTKy0Dv6M3ned28y12yqNxYsK0BpgMRbN0wnk9liTiSNh3g0ObK62758vUj1oL5Nbrhb8dLiOthB/IOt9fRHabvbx/i7J9IUbJWx/dH53Usp9UI9NLsvGvh9HSTSgYsgmTsknFHhF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hZLvyq8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hZLvyq8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46905C433C7;
	Wed, 27 Mar 2024 15:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711552731;
	bh=Dqx1PgK6etWW+VQ8jL7xEdiF4kFZH7zkXsNgYeLd/b8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hZLvyq8MHKrHufRwBUcnGBrd6vK249SsOy9DamwFm511rSRpi00H3jCPaSscXcHOG
	 eSoW/AWjwVTI/fUFZz1UI2gTJLne2a1VeXceHxTulvxyMxb7bnS41To+tXgixE797t
	 aAZgIV21D0qJiOTycDCjuaXzJ1YJAYz2UU6mdByMgyJIBj0BTvUD+DWNpqKBXexqPu
	 kvPTp3eB8T5Ub5aWpMdSNOuhQGjuYLKDGPeBYegbJ5CTu/A1NrZ+ntJFld8mK7ghVl
	 oOzG03JDKj0KUkI+iirYCiLt+jbQYacEVLOa28Clh5sB142WPN+RPCbvtHzEnHWmnl
	 dIfadrXTGqUSQ==
Date: Wed, 27 Mar 2024 08:18:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/13] xfs: stop the steal (of data blocks for RT
 indirect blocks)
Message-ID: <20240327151850.GA6390@frogsfrogsfrogs>
References: <20240327110318.2776850-1-hch@lst.de>
 <20240327110318.2776850-13-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327110318.2776850-13-hch@lst.de>

On Wed, Mar 27, 2024 at 12:03:17PM +0100, Christoph Hellwig wrote:
> When xfs_bmap_del_extent_delay has to split an indirect block it tries
> to steal blocks from the the part that gets unmapped to increase the
> indirect block reservation that now needs to cover for two extents
> instead of one.
> 
> This works perfectly fine on the data device, where the data and
> indirect blocks come from the same pool.  It has no chance of working
> when the inode sits on the RT device.  To support re-enabling delalloc
> for inodes on the RT device, make this behavior conditional on not
> beeing for rt extents.

  being

> Note that split of delalloc extents should only happen on writeback
> failure, as for other kinds of hole punching we first write back all
> data and thus convert the delalloc reservations covering the hole to
> a real allocation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

With that one spelling fix,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 9d0b7caa9a036c..ef34738fb0fedd 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4981,9 +4981,14 @@ xfs_bmap_del_extent_delay(
>  		/*
>  		 * Steal as many blocks as we can to try and satisfy the worst
>  		 * case indlen for both new extents.
> +		 *
> +		 * However, we can't just steal reservations from the data
> +		 * blocks if this is an RT inodes as the data and metadata
> +		 * blocks come from different pools.  We'll have to live with
> +		 * under-filled indirect reservation in this case.
>  		 */
>  		da_new = got_indlen + new_indlen;
> -		if (da_new > da_old) {
> +		if (da_new > da_old && !isrt) {
>  			stolen = XFS_FILBLKS_MIN(da_new - da_old,
>  						 del->br_blockcount);
>  			da_old += stolen;
> -- 
> 2.39.2
> 
> 
