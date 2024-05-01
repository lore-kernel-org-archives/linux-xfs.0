Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F710165FBA
	for <linux-xfs@vger.kernel.org>; Wed,  1 May 2024 21:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714599236; cv=none; b=Ru5JmgE5q8Zb88A9qwhgA1UcBDLyoQhner8BqF530EDYPgBvcw0hWax/syE3zxzbDN9cSiSCJ+6+zX9R5w4CG6B+S4zNYzvXpsAu373BcsRvThB7OCxxLS27Vc+cljPHlFBG54u0LIOurF1MyZuuYNK5Pqil3eAnBdkCiNSnCvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714599236; c=relaxed/simple;
	bh=qLAA36AwkLMjHgJ9LFVbxhcXt2eCnqjHN8qtWySGnWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jGy7vJU0P1PFFnDRs8oq2sQzZLexOM3LJMF6RzwtaVHLliHe5xMZaNyFBa6C8Llg23hYzJYs6mUbvt0wkOS0ThwQzwAYr0CTNsmgc08K67X8v4mVaIxhXIFrXub21917aI5N0v6ZSCwVywRBsk+ASBkRO7u+8495P3VW4E51XrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JYASjvG8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JYASjvG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB213C072AA;
	Wed,  1 May 2024 21:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714599235;
	bh=qLAA36AwkLMjHgJ9LFVbxhcXt2eCnqjHN8qtWySGnWc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JYASjvG8DTL2zXxROBRIxRpHc7mBX7w6HqO2s4enswtlMor0rrt9AvE3ru31Fjrln
	 QoOQAIbvbM2DYzKfD38jxjDPFfodOD48uv0EhI2XfZRv4hGX9iRZF4ceO/5vglEhnx
	 eAT8BvzRV6/SpmiR+t5ykiupHPDBqSNe3zElDtVfoG+vksNr1OsYjdg7nlOKXmSk/n
	 9VHDuezqd7zXxrD4RaRdL0hbPoEseBGf3SV6cjkL6GrtUAyXJRRLFhNcWkRENm/ian
	 5Jr6EklFqtJcvd8BRfQAD6QL+OOxMv7SaMEMgcQSLsRyDYJoEOO8juGDkB1CXrZeYM
	 PH23bAcG3U7Nw==
Date: Wed, 1 May 2024 14:33:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/16] xfs: move the block format conversion out of line
 in xfs_dir2_sf_addname
Message-ID: <20240501213355.GC360919@frogsfrogsfrogs>
References: <20240430124926.1775355-1-hch@lst.de>
 <20240430124926.1775355-16-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430124926.1775355-16-hch@lst.de>

On Tue, Apr 30, 2024 at 02:49:25PM +0200, Christoph Hellwig wrote:
> Move the code to convert to the block format and add the entry to the end
> of xfs_dir2_sf_addname instead of the current very hard to read compound
> statement in the middle of the function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yeah, that was kind of a mess...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_dir2_sf.c | 37 +++++++++++++++++++------------------
>  1 file changed, 19 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 02aa176348a795..0598465357cc3a 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -426,26 +426,16 @@ xfs_dir2_sf_addname(
>  	}
>  
>  	new_isize = (int)dp->i_disk_size + incr_isize;
> +
>  	/*
> -	 * Won't fit as shortform any more (due to size),
> -	 * or the pick routine says it won't (due to offset values).
> +	 * Too large to fit into the inode fork or too large offset?
>  	 */
> -	if (new_isize > xfs_inode_data_fork_size(dp) ||
> -	    (pick =
> -	     xfs_dir2_sf_addname_pick(args, objchange, &sfep, &offset)) == 0) {
> -		/*
> -		 * Just checking or no space reservation, it doesn't fit.
> -		 */
> -		if ((args->op_flags & XFS_DA_OP_JUSTCHECK) || args->total == 0)
> -			return -ENOSPC;
> -		/*
> -		 * Convert to block form then add the name.
> -		 */
> -		error = xfs_dir2_sf_to_block(args);
> -		if (error)
> -			return error;
> -		return xfs_dir2_block_addname(args);
> -	}
> +	if (new_isize > xfs_inode_data_fork_size(dp))
> +		goto convert;
> +	pick = xfs_dir2_sf_addname_pick(args, objchange, &sfep, &offset);
> +	if (pick == 0)
> +		goto convert;
> +
>  	/*
>  	 * Just checking, it fits.
>  	 */
> @@ -479,6 +469,17 @@ xfs_dir2_sf_addname(
>  	xfs_dir2_sf_check(args);
>  	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA);
>  	return 0;
> +
> +convert:
> +	/*
> +	 * Just checking or no space reservation, it doesn't fit.
> +	 */
> +	if ((args->op_flags & XFS_DA_OP_JUSTCHECK) || args->total == 0)
> +		return -ENOSPC;
> +	error = xfs_dir2_sf_to_block(args);
> +	if (error)
> +		return error;
> +	return xfs_dir2_block_addname(args);
>  }
>  
>  /*
> -- 
> 2.39.2
> 
> 
