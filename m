Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792529763;
	b=PgUMYCe5YhBlesbznF2jRLNKZXnHPuB6ltMIPGUK0qnRAxDbqFVGqqSnqOxdhpr2MaP4
	 EJ6YFWZ2U314qmaFzaAfKZatuNKpzUa6+9DQMaYD6MEY+Y+Jjnko2JSbSdytPDs5JSf1V
	 dRnf/RYhEmutco/gxNtqU1Vdi1U0qV+QH1rEFB5gaIguhGeFvf/pOLb1TqC15qeF9Bpnr
	 oSmHmqV+d0ynwkPImg0V3iA+ZrtgTzz0zr2rVZVX6S8ATlhm0ACgKNi3tEwZPl602aDqC
	 Tx6NfrEcdEJTFgKE0Utie9mkhtR/ixmdMVhOobaNCVpsRoF//bB5ee4LTk2tvN4ID4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792529763;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=mJMPTkaYc6nK1lEpKCFWWYIliu60SBSzOa09WLYSW7w=;
	b=TCKNqAEUaB+kVkthp/K4ifEpohLQacUQoXUeWGboM8XXqedryDHFFuYwRfzk/UAfuCAa
	 ufNyEmc+nLwfSWCgYcAYAOToa0m1lz/3qFdTcW30GnurdZ8Do5lwzXf6+oKfpyXb1ppH4
	 awYlesPw4Dr4P+gZhEpAAfc7fsLrjqbGQXGFzF4sr16t2JPTpigdWVNXsliz8LbCPrUJA
	 xJvvB7csr90S7XR7rs6tmgyXWj1itbILRBYZYBsWHoFOsH+STvgTCn0Mo3FNvvQm2PIyG
	 F9wGUr5PL4chPUoqJ9qu2eAW2XnM8hMklr35hL5vAUkjL0sw9AzYG6RLcWkuZuGDMEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hBSF4cEY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93229606A31C;
	Tue, 20 Oct 2026 20:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hBSF4cEY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEED91F000C9;
	Tue, 20 Oct 2026 20:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792529763;
	bh=mJMPTkaYc6nK1lEpKCFWWYIliu60SBSzOa09WLYSW7w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hBSF4cEY1dEQNYzjJm1D7vt0IucDuWWIi1u0r0ZtnUrym+PJ3jRLThR3EFTwn3VU3
	 5H+hgJceX5YHQq8RcM5XQ35TmVN8PJ9AthdBhUXvFumj+1iSbK/QbHz7JKWM7B/hs/
	 Gp6EXCqXOEHcrsavy2PwTRLSRvgdfS2B4HOee1zGwBBOgf2DRqHgBlTDyNfEuPe3lY
	 AJ6lyWhvMHYcAA79Z5vngU9gwbww2WGq/YXYHLs/sD557LT0nO6Wrf8T5/QuTA6+7N
	 XaoD/TMCnHGMhNliUULSCC3CBBMW6u+v+X8c1D65pG0FkV+XE+c2Zu+Csj7oxWO9YV
	 Y71wY4E8hd/fA==
Date: Wed, 21 Oct 2026 07:55:54 +1100
From: Dave Chinner <dgc@kernel.org>
To: Eduard Zateev <hackerowskiy@gmail.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot+9d8e687768d0f38c1f09@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: preserve buffer item with outstanding references
Message-ID: <atfVWiDCE2LSOBMU@dread>
References: <20261020200433.3298861-1-hackerowskiy@gmail.com>
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
In-Reply-To: <20261020200433.3298861-1-hackerowskiy@gmail.com>

On Tue, Oct 20, 2026 at 10:04:31PM +0200, Eduard Zateev wrote:
> The buffer log item can still be referenced by the CIL after the buffer's
> synchronous write completes.  In this case xfs_buf_item_relse() is called
> from xfs_buf_ioend() with bli_refcount non-zero.  Freeing the item leaves
> a stale pointer in the CIL, which xlog_cil_committed() later dereferences.
> 
> Restore the reference-count check removed by commit d2fe5c4c8d25
> ("xfs: rearrange code in xfs_buf_item.c").  If references remain, keep
> the log item attached to the buffer so that its final reference release
> can perform cleanup.
> 
> Build-tested: fs/xfs/xfs_buf_item.o (ARCH=arm64, W=1).
> The syzbot report does not include a reproducer, so runtime testing was
> not possible.
> 
> Fixes: d2fe5c4c8d25 ("xfs: rearrange code in xfs_buf_item.c")
> Reported-by: syzbot+9d8e687768d0f38c1f09@syzkaller.appspotmail.com
> Closes: https://syzbot.org/bug?extid=9d8e687768d0f38c1f09
> Assisted-by: LLM OpenAI Codex
> 
> ---
>  fs/xfs/xfs_buf_item.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 1a4ef34af8d..80f0cf12825 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -80,7 +80,8 @@ xfs_buf_item_relse(
>  	trace_xfs_buf_item_relse(bp, _RET_IP_);
>  
>  	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
> -	ASSERT(atomic_read(&bip->bli_refcount) == 0);
> +	if (atomic_read(&bip->bli_refcount))
> +		return;
>  
>  	bp->b_log_item = NULL;
>  	xfs_buf_rele(bp);
> 
> Signed-off-by: Eduard Zateev <hackerowskiy@gmail.com>

You didn't bother to check the mailing list or syzbot for
duplicates or prior discussion, did you?

What I said about this less than two days ago:

https://lore.kernel.org/linux-xfs/atUsQVuCKnAIZc3X@dread/

-Dave.
-- 
Dave Chinner
dgc@kernel.org
