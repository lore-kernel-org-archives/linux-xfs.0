Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795719078;
	b=dlc23clUkqY4HVCnpZwIMNdv31cekDN8ayjcdOG/+rxrc5RzZLQcgOE+7VPMNAofSDQu
	 SRl0B5ZBdnSPjuJGYxyf2QNQVgxfc4F9Iy5yxu4kMc2uLMVLPdhZxlOAtjI7QO93o5BzM
	 Ytmvlf8Ekvv33o2szxklWfl0es5apCCrKL//JltoatKrJgCa6V2flwqGz3hdNXwG0fuxM
	 +PvE0qNYxgBOn3rVnQFsxsSM+cwejDgszMFDBw/fDhnxUvYRIJuNU+np5jjd+3aOsAbQ9
	 J5XwWuB25Y44/dzhflNedFLjVCkPACby+iePlyrNvDBO4nkO1A3RCgsONT1zDrAqWHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795719078;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=bCGjI5b2pe8qj7wzPqcxc9LV9xKS4KO0aNvbgsPBLwA=;
	b=mOq3RUqqfM3ccKl1VmHqnbJb9uDUxob3J45v9v/kWkoF7+110bf4jVT4qZNwWncn/STw
	 ZVlXMbjrgKJEhxL8PqgqjA5ZI3eOfWjMU23YxgpJkTmoqel8872xhSnGBZ5BDdj0rQurZ
	 etufuhW4pXvxo/cKnqypXYkg1vKAJqiaN4s5vxlmH+bObmBAnvUg6Qbd/VmYwVHWwGq+O
	 JmCo9Q4qaUvRzGrE/yLFzpNiZbI9PQyUJuhRG3hsssf7a7J7+R1vzxskslYvr/rY3XuaS
	 PhgGOBGR123IkZNCP/t+QZPhe7R8zJ7PLa1NKmDJwFCQQRze5PkK5JsTVL0P1dXHQXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Up2+Gv1F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D36606A333
	for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 18:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Up2+Gv1F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C940F1F000CF;
	Thu, 26 Nov 2026 18:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795719077;
	bh=bCGjI5b2pe8qj7wzPqcxc9LV9xKS4KO0aNvbgsPBLwA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Up2+Gv1FCKMqdMwPEDry1Rn9WcjNMYX+4VKk1rE4b4a/4Hw1vLoxa6gou1iuM/xy2
	 U8KQI22/mDg8wjimPU2C1lbOx11rWCvBWcOR7zVzEDEUNJvMaeuAtRPxubsPgUBdEQ
	 Mnb5Pb3lC6wah90zd2evq4kdzpLkrj3/r/Ib+S4U0GVazZ/hA2yMRuQ+oy3zp0FzqM
	 El2LzTGxMi1xdPKFegaZ8G45YRrOBu/fHGySxd1lz+46g0JiSyEyYwgJhAORcInsR2
	 FT9BYLSOniZPqzTvRopHi4o5HQh735SNIT91D8TYhK6lnYVaeJsKhSTCwSIB+FELPd
	 Pg0KmWyhUQOpQ==
Date: Thu, 26 Nov 2026 19:51:13 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/15] xfs: refactor the continuation loop in
 xlog_write_partial
Message-ID: <awh_oTBqbr1Wbtnd@cronus.toxiclabs.cc>
References: <20261125144430.728485-1-hch@lst.de>
 <20261125144430.728485-4-hch@lst.de>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125144430.728485-4-hch@lst.de>

On Wed, Nov 25, 2026 at 03:42:24PM +0100, Christoph Hellwig wrote:
> Looping on a flag that is the effect of the size calculations is a bit
> unintuitive.  Switch to a for loop that loops over the length of the
> region instead, which has the same result but clearly documents what
> we are looping for.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  fs/xfs/xfs_log.c | 27 ++++++++++++---------------
>  1 file changed, 12 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 7a067cfe59e6..e6dbd532bbdd 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2074,7 +2074,7 @@ xlog_write_partial(
>  	/* walk the logvec, copying until we run out of space in the iclog */
>  	for (index = 0; index < lv->lv_niovecs; index++) {
>  		struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
> -		uint32_t		reg_offset = 0;
> +		uint32_t		offset;
>  
>  		/*
>  		 * The first region of a continuation must have a non-zero
> @@ -2104,16 +2104,14 @@ xlog_write_partial(
>  
>  		xlog_write_iovec(data, reg->i_addr, rlen);
>  
> -		/* If we wrote the whole region, move to the next. */
> -		if (rlen == reg->i_len)
> -			continue;
> -
>  		/*
> +		 * Otherwise we now have a partially written iovec, but it can
> +		 * span multiple iclogs so we loop here. First we release the
> +		 * iclog we currently have, then we get a new iclog and add a
> +		 * new opheader. Then we continue copying from where we were
> +		 * until we either complete the iovec or fill the iclog. If we
>  		 * complete the iovec, then we increment the index and go right
>  		 * back to the top of the outer loop. if we fill the iclog, we
>  		 * run the inner loop again.
> @@ -2128,7 +2126,7 @@ xlog_write_partial(
>  		 * space left in the current iclog, and check for the end of the
>  		 * continuation after getting a new iclog.
>  		 */
> -		do {
> +		for (offset = rlen; offset < reg->i_len; offset += rlen) {
>  			/*
>  			 * Ensure we include the continuation opheader in the
>  			 * space we need in the new iclog by adding that size
> @@ -2156,8 +2154,7 @@ xlog_write_partial(
>  			 * If rlen fits in the iclog, then end the region
>  			 * continuation. Otherwise we're going around again.
>  			 */
> -			reg_offset += rlen;
> -			rlen = reg->i_len - reg_offset;
> +			rlen = reg->i_len - offset;
>  			if (rlen <= xlog_write_space_left(data))
>  				ophdr->oh_flags |= XLOG_END_TRANS;
>  			else
> @@ -2167,8 +2164,8 @@ xlog_write_partial(
>  					xlog_write_space_left(data));
>  			ophdr->oh_len = cpu_to_be32(rlen);
>  
> -			xlog_write_iovec(data, reg->i_addr + reg_offset, rlen);
> -		} while (ophdr->oh_flags & XLOG_CONTINUE_TRANS);
> +			xlog_write_iovec(data, reg->i_addr + offset, rlen);
> +		}
>  	}
>  
>  	return 0;
> -- 
> 2.53.0
> 
