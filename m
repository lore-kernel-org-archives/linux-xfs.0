Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795714448;
	b=ka6fRSS4hIIIMO4E+ECFjW7IJNFzTfGejlxbR3Sb7HGcCFzL33JbQyIuhOJ2uV7YOSeq
	 xqPaYeiGnHPI6FjU8rr4OwlWScJyyD7gDCR0fxzfa/qmLQ7zy0PzjZekPdn4qiP0z/47/
	 l+eGtHoJJmvIZj/kVVy14YuBVezpD2v61HthI2URxLEAMNtn77XUMO+jFB6QIMqSwuQeo
	 UwPFsPZwyATsejN/v8H8VAmPgy2yKgO3GVI42gHWRW12WKOp97CuQNrLSdYzGvRZ7D56w
	 fsOMdB2uDrvIw0tw6e68PXBAWaUpFS75KefQcDNCnDR0VTvuSVqVmmf4gO/2UA9FLrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795714448;
	h=Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=BtUdNQm0YLbjJixJ6r5Eh004MjxMb0hqOiHcmH+ZsR8=;
	b=1NNZds+Vv6j2dtWZnGVbLAVf/sXAk4Sw0tTBNTCClPZjvDRR7/sCn4j7creLoT2fui3K
	 vp50TDzQsUd2utr8V29W+ugLlwJ3bxqoLIvoXG9x7ipvf7HHm2HpR5yirNb0Ecdx4FKMH
	 /o5rAK43UkxYCH/zQDl/Vf241MYJFQP24/uNcogW3+ZVVmQDqVp8ZaGQviSwAktBS3sv1
	 q2Rit6mDcpUUElzCQ5Z7/pvdWtdHRnqoQ7i0HUBkygiyNVbgiWZGABBSqBq0098/Sp1As
	 JecXpX2RqlHryX0+lenMcxtMuOvLCkWmj2Vd9CzaEUDwQDbuMIX72hiso9X96C1U+OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B50B606A31C
	for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 17:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746E91F000C6;
	Thu, 26 Nov 2026 17:34:05 +0000 (UTC)
Date: Thu, 26 Nov 2026 18:34:02 +0100
From: cem@cronus.toxiclabs.cc
To: Andrea Parri <parri.andrea@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dgc@kernel.org>,
	Jeffin Philip <jeffinphilip14@gmail.com>, linux-xfs@vger.kernel.org,
	syzbot+c32ff62cf4913d345d0c@syzkaller.appspotmail.com,
	syzbot+9d8e687768d0f38c1f09@syzkaller.appspotmail.com,
	syzbot+a4fde844548510369112@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: wait for buffer unpinning before shutdown completion
Message-ID: <awhtipqpIxxUgyjj@cronus.toxiclabs.cc>
References: <20261126164604.158012-1-parri.andrea@gmail.com>
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
In-Reply-To: <20261126164604.158012-1-parri.andrea@gmail.com>

On Thu, Nov 26, 2026 at 05:46:02PM +0100, Andrea Parri wrote:
> Changing an XFS filesystem label while forcing log shutdown can trigger a
> use-after-free in the CIL push worker, as reported by syzbot:

I *think* Dave is already working on a proper fix for this on his
series, so I'll wait for him to look into this as I didn't have time to
go through his series yet.

Besides that...

> OpenAI Codex analyzed the reports, implemented the suggested change,
> drafted this changelog, and ran the tests described above.  Claude Code
> reviewed the change and revised this changelog.

LLMs references should stay away from commit messages. Doesn't matter
what tool you used, the code is still your responsibility.

> 
> Fixes: d2fe5c4c8d25 ("xfs: rearrange code in xfs_buf_item.c")
> Cc: stable@vger.kernel.org
> Reported-by: syzbot+c32ff62cf4913d345d0c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=c32ff62cf4913d345d0c
> Reported-by: syzbot+9d8e687768d0f38c1f09@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=9d8e687768d0f38c1f09
> Reported-by: syzbot+a4fde844548510369112@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=a4fde844548510369112
> Suggested-by: Dave Chinner <dgc@kernel.org>
> Link: https://lore.kernel.org/aqI6v-_dc2DDSbgB@dread
> Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
> ---
> 
> Jeffin, Cc'ing you because this touches the BLI lifetime that your log
> item reference counting conversion reworks.  This is the short-term
> xfs_buf_submit() fix Dave described in the thread linked above.  It is
> meant to be small enough to backport and does not replace that work.
> 
> Processing of emailed #syz test commands is currently disabled (see
> https://github.com/google/syzkaller/issues/8122), so the functional test
> results come only from local runs of syzbot's C reproducer.  Three later
> 10-minute runs of the unpatched kernel did not reproduce the UAF, so the
> 191-second fixed-kernel run provides only weak evidence that the race is
> fixed.
> 
>  fs/xfs/xfs_buf.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 6c93b4f5629c1..4acd0c3451da9 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1382,6 +1382,9 @@ xfs_buf_submit(
>  
>  	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
>  
> +	if (bp->b_flags & XBF_WRITE)
> +		xfs_buf_wait_unpin(bp);
> +
>  	/*
>  	 * On log shutdown we stale and complete the buffer immediately. We can
>  	 * be called to read the superblock before the log has been set up, so
> @@ -1402,9 +1405,6 @@ xfs_buf_submit(
>  		goto ioerror;
>  	}
>  
> -	if (bp->b_flags & XBF_WRITE)
> -		xfs_buf_wait_unpin(bp);
> -
>  	/*
>  	 * Make sure we capture only current IO errors rather than stale errors
>  	 * left over from previous use of the buffer (e.g. failed readahead).
> -- 
> 2.53.0
> 
