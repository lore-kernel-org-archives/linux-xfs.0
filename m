Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793620362;
	b=3xv0FJtPwAgGuEz0pqbpLEthmgJNXvmSqdyoV70lIrrH0AtUu9YZRV07p0mxJkKEdiut
	 geWg+WgsZvSaagrIaosYD+8TB80NxiXmqsfWzL6J1o34JAf38ow0Jtr9qI/PypQGR2Ea+
	 iVGlcydRXKbNBAYq1ck0XT3sV212LWjowJ9wyvndlwljcMIN3S9bNcjcvM4IXqgpBaUbw
	 ckscH4Fw5pa9CDBrGczccoMM3KZn3FZtCaKynDIxafy8V/lnBVoedzAp4NKWArUb2LKa5
	 LmjMZow2mpek2p0V6v/2dJfPYzdNOe9Uw2IOjkxz6eKKwMQ6y84UauqNsFxbQl1fRDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793620362;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=RNrgB0X0sFHSJq6hlCGDS+dbe/z5kRcC+D/NzEx9/KI=;
	b=v0LxWicuIbGenkrD1Qrdjap1UOgf3b3E1rd1vAXZl9mWgdE0G6jjvk/WIlif6vQdRcYf
	 cFoWnRPRajG8IyVJQ0G4kvcro5keAhwiyGCM2HCNgAs2QdGlM8OIltMrDqvwTLMydlz7q
	 Jmfqz3F9NE1+9WMzzZlMiz1nPbxxn3vh+r41/RuQA2lIXq7+AndyYWvedn31t9xRUtvj/
	 6fEJlaisITLbgnhFYM5mn7KLhnBpU3n4nFr5XGqB+bbqJPNlkLvD2Dp7X6rnPT3FptkXa
	 zJIHUjZEyIBVillFv9ix8GjM9Ikft2QNehISLylSGN69h64dc9mipCCzPkl4AF/3UCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BbOPN9Op;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79038606A324
	for <linux-xfs@vger.kernel.org>; Mon,  2 Nov 2026 11:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BbOPN9Op
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461641F00A16;
	Mon,  2 Nov 2026 11:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793620362;
	bh=RNrgB0X0sFHSJq6hlCGDS+dbe/z5kRcC+D/NzEx9/KI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BbOPN9OpkOjyE2+Qb9qQRJGAIANF8sWbJygsds3/PrbowMbG46JP2r8T+i/qT+D77
	 /l+lb/Hzg+qXYAPOZJyJwgKX1RLe+6bd62GUG3YEocrisMRH28mWjo7IMzbaZg5nNW
	 UXjF3VWw2CeWsUtWM6Oid0eiXf2BEwu+1VgJzqLD9VkbT3G890ge+oeSMbZdrj6lL7
	 q5UMxTOHHLn2JokdUwm6E3Y5FJq61V8QQOV+5sv3KepuDPxjTfaCqaCjPPw4eWbxzX
	 dGQ9Vk+dlEMa3tXKVVz6L0RoXQd7P6Cn4+iNRYlfGX765sFvIRjkxkIVH4XFVKA/2m
	 RmB3vJiaTFHOg==
Date: Mon, 2 Nov 2026 12:52:38 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix recovery of partial attr removals
Message-ID: <auh1xhogpIaw2d5t@nidhogg.toxiclabs.cc>
References: <20261028081125.2209827-1-hch@lst.de>
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
In-Reply-To: <20261028081125.2209827-1-hch@lst.de>

On Wed, Oct 28, 2026 at 09:09:39AM +0100, Christoph Hellwig wrote:
> When running xfs/753 on parent pointer-enabled file systems with DEBUG
> enabled, log recovery will eventually crash after a few dozen iterations
> due to an ASSERT that XFS_ATTR_INCOMPLETE is not already set when
> xfs_attr3_leaf_setflag is called:
> 
> XFS: Assertion failed: (entry->flags & XFS_ATTR_INCOMPLETE) == 0, file: fs/xfs/libxfs/xfs_attr_leaf.c, line: 3045
> 
> This is because parent pointer use logged attributes, and the attribute
> intents do not track the work that has been done as the transaction
> rolls, and the recovery mechanism is to run the operation from scratch.
> Because of this various places check for XFS_DA_OP_RECOVERY skip work
> already done.  But while recovery tolerates an attribute already fully
> removed, it currently trips the above assert for an attribute that
> already has the INCOMPLETE bit set, but still exists.  Fix this by
> handling the case like all the others.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> 
> This really wants a Fixes tag and/or a cc stable, but I have a really
> hard time coming up with a good one.  The logged attrs are a messy
> history with tons of refactoring, but this actually code goes back way
> beyond that, but wasn't a problem before the attr item recovery.  Logged
> attrs themselves are still only a debug option and not used by default
> except for the parent pointer.  Any good suggestions?

Uff.. I think this goes waaaay back, even before CRC?!

Giving this wasn't a proble before LARP, I'd probably be inclined to set
a Fixes pointing towards 1d08e11d04d2.
Not because it imminently fixes that patch, but that the broken behavior
kind of started after that. Cc stable probably v5.19. I don't think
there is any point before that.

For the patch though:
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
>  fs/xfs/libxfs/xfs_attr_leaf.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 6068fad9dc9e..82932b5c02fd 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -3042,7 +3042,14 @@ xfs_attr3_leaf_setflag(
>  #endif
>  	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
>  
> -	ASSERT((entry->flags & XFS_ATTR_INCOMPLETE) == 0);
> +	if (entry->flags & XFS_ATTR_INCOMPLETE) {
> +		if (!(args->op_flags & XFS_DA_OP_RECOVERY)) {
> +			ASSERT(args->op_flags & XFS_DA_OP_RECOVERY);
> +			return -EFSCORRUPTED;
> +		}
> +		return 0;
> +	}
> +
>  	entry->flags |= XFS_ATTR_INCOMPLETE;
>  	xfs_trans_log_buf(args->trans, bp,
>  			XFS_DA_LOGRANGE(leaf, entry, sizeof(*entry)));
> -- 
> 2.53.0
> 
> 
