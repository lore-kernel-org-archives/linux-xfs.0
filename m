Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6370D52F
	for <linux-xfs@vger.kernel.org>; Wed,  1 May 2024 21:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714599137; cv=none; b=Qaf2sVVOP2zzCC1b3oZMHlJmJ3p9rQyOGJHPjyEffToIGxCFKmoX1ycNf+PFBiOuf1mBzkaCi1jJIw+T0ZfwhsArcLFNNIdU8Izlx4YQfqN+x3KgL1LTD5FcE1QJ2+SaTwLlkp6vbPo0TgP+u9bkGOn9n7nXFuE17z9PXyGl73I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714599137; c=relaxed/simple;
	bh=Oqerj2ZMlSDVNTXAT5czBsVX+KYlGiglS0e7ktmGDpo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=irhMEmDaYzIJYTR/Nt88kwMGd/h7K0xnzpzAxF25byTVeBJKfveTPerx0YLV1qQ3Tm97t8VV/OdNrWMO9Q5O5o/pzVUhB5p9nOw75ILtZLuYZtgjKGPbgcTRrVSOhjvL6zXPh7vQ860Ki/to1zqOIGKe1Wa9lDfHEMH7eXMWLZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MH9FOSNI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MH9FOSNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B3DC072AA;
	Wed,  1 May 2024 21:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714599137;
	bh=Oqerj2ZMlSDVNTXAT5czBsVX+KYlGiglS0e7ktmGDpo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MH9FOSNIyr0FJvL6F5tnMvb4bTfPptaEkzhJzz9gCTcK3N39QCTbB5T4WCq6FZI1K
	 14umXhpreGt7jqdjJuI/GE9wqAWf6N6r41xeOViPkg0PVS+VPGYVSyZOvcJPokHkGP
	 gp5JY2DRIEWI1QyB5In1/fuNhC9eIuaVp6wuU5O+BlHXZMGHoHaiB4nHgrghOmeKmA
	 dijCSs3Nx8qVA8Tudbcd5UbTV1/DwpCFYMdxt4isXIiDFuCrqI4oQD4BcsemTMQlHQ
	 v2L/xFxo4piGQVuQljKwtp2hrYKiGDoQ3VRe5iL9tYK6iwxR5Hd1dUCRZEz7w4Dx16
	 0SQcSHcKaluOg==
Date: Wed, 1 May 2024 14:32:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/16] xfs: move common code into xfs_dir2_sf_addname
Message-ID: <20240501213216.GB360919@frogsfrogsfrogs>
References: <20240430124926.1775355-1-hch@lst.de>
 <20240430124926.1775355-14-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430124926.1775355-14-hch@lst.de>

On Tue, Apr 30, 2024 at 02:49:23PM +0200, Christoph Hellwig wrote:
> Move updating the inode size and the call to xfs_dir2_sf_check from
> xfs_dir2_sf_addname_easy and xfs_dir2_sf_addname_hard into
> xfs_dir2_sf_addname.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This seems simple enough,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_dir2_sf.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 43e1090082b45d..a9d614dfb9e43b 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -465,6 +465,9 @@ xfs_dir2_sf_addname(
>  			xfs_dir2_sf_toino8(args);
>  		xfs_dir2_sf_addname_hard(args, objchange, new_isize);
>  	}
> +
> +	dp->i_disk_size = new_isize;
> +	xfs_dir2_sf_check(args);
>  	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA);
>  	return 0;
>  }
> @@ -498,8 +501,6 @@ xfs_dir2_sf_addname_easy(
>  	 */
>  	sfep = (xfs_dir2_sf_entry_t *)((char *)sfp + byteoff);
>  	xfs_dir2_sf_addname_common(args, sfep, offset, false);
> -	dp->i_disk_size = new_isize;
> -	xfs_dir2_sf_check(args);
>  }
>  
>  /*
> @@ -583,8 +584,6 @@ xfs_dir2_sf_addname_hard(
>  		memcpy(sfep, oldsfep, old_isize - nbytes);
>  	}
>  	kfree(buf);
> -	dp->i_disk_size = new_isize;
> -	xfs_dir2_sf_check(args);
>  }
>  
>  /*
> -- 
> 2.39.2
> 
> 
