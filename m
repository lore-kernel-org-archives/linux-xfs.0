Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F7E310651;
	Mon, 10 Aug 2026 18:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786385225; cv=none; b=Fv9ik3dghRqCNsA9SmctbhBFKIxTf6UhAxPGxGQMoiWO629Kd8ZX3Qkt2qjX29+Ih7zdtYXOjmRX4cXsg/rk6eCZNZALg6XkkXLGd94DjuI9irJHZv4kUsr0RB4vQh8iNGt30WB3IY0xaq3FYB+tsFA/z5LueCLP/wuWA1rI7uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786385225; c=relaxed/simple;
	bh=FVwKRILliHWr65Nl+epuisl3vE7X/hpu8TMWfZ74cIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rG/WRvN8vdyQy0zP9xLy9yCApa31hDhDycECz8KF9wWMzaWTXFbhobjV0UWyGMPrfzMeyXyBzesxh67w8GboYrqH826owws0rOuQdhpY0QLpDLP54MMfP/lJbz14vEzgML344Arb/AaSDGmsKgWvjYqrnBrXsKHWy8uKqySyWVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S3ueKuiS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S3ueKuiS"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4EDA71F000E9;
	Mon, 10 Aug 2026 18:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786385224;
	bh=4/Dsmeg0WYX5R6eqsqvBBzxR4fvbeeBUr/QABQg2hLE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S3ueKuiS05CEhvIWT1Urj08/MNKnoHHiEg8yjq4jmjhqndz6QyR8wXpF5qH3ACqGW
	 rK7+eIZ39esqdKFbxeS7tGgfxA6/LrlH6keA4pLlJ/o7xZk/kLLai+KxgHtQpO9YtD
	 byKBFxZ1aypC7X5M3FwGECApkOETdpZNQoCMQmW9BylM2IUwRJFFWz3QCKyv9QSNhC
	 98lv2y/vlh3oXnqxGrZBZJ0wJ+77ZA+U0w5sYA+7sf+m4Y9CBPBD8R8Aj26XROM2ys
	 VRDhkgtdJl/4xASuWZrdjNW8zod8u2+at19G0Ysqf0dHZ4ynSCzowXZ6iJRxnDuQha
	 lFfxtRkaljZdw==
Date: Mon, 10 Aug 2026 11:07:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Javier Tia <javier@peridio.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/6] xfs: assert the reservation covers each da fork
 growth
Message-ID: <20260810180703.GR3556460@frogsfrogsfrogs>
References: <20260808234016.246054-7-floss@jetm.me>
 <20260810164312.960721-8-floss@jetm.me>
 <20260810164312.960721-14-floss@jetm.me>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810164312.960721-14-floss@jetm.me>

On Mon, Aug 10, 2026 at 10:43:19AM -0600, Javier Tia wrote:
> xfs_da_grow_inode_int() subtracts the blocks it just allocated from
> args->total, the caller's remaining block reservation.  The subtraction
> is unsigned, so a caller that reaches it with too small a total wraps
> the field instead of failing, and every allocation afterwards runs with
> a bogus reservation.  Assert the remaining reservation still covers the
> step, so an under-reserved or uninitialised total trips in debug builds
> instead of silently wrapping.
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Javier Tia <floss@jetm.me>

Looks good,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_da_btree.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index ad801b7bd2dd..9be407affc6e 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2385,6 +2385,7 @@ xfs_da_grow_inode_int(
>  	}
>  
>  	/* account for newly allocated blocks in reserved blocks total */
> +	ASSERT(args->total >= dp->i_nblocks - nblks);
>  	args->total -= dp->i_nblocks - nblks;
>  
>  out_free_map:
> -- 
> Javier Tia
> 
> 
