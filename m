Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086F147F786;
	Wed,  2 Sep 2026 16:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788366955; cv=none; b=hZFloCcg25Q+zuL3eM9YombtDHG9fJjmfV6EhTkWON2BQBaNPmrvKBr9fAvz7wHfi12STFr4TsXlsug+xz3kvEvMZ0qiLlA5Rr+PfO6hUYGMe620cEsI6uHIoO7eMu8PDohcpVF5dZ9KwAh8FbDUylozO52k7GdBRjos940gVxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788366955; c=relaxed/simple;
	bh=sqNtSfdNCaTQb/2mf73osRumdi1Z06osl4U/LVAk7AU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nPNuX8KDK84j0nXja06PXtPaVcFYaMlOnypygLB/igp7ivqT945A1LD90EXVYTFFkGP4WgsmnwoIs+yPpT4Cq77OEPLPeegFMOnSYsFB4t4GVkt3naMBp/j/LaQ/lExm00yD7PMZHOOy8+zWqaGoNYwg5MqvzaaAh2tRo7+ONZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RUx12r4I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RUx12r4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8512B1F000E9;
	Wed,  2 Sep 2026 16:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788366953;
	bh=ac8jsX+DMtEi6vVSz6czKKoo3d1DKY5/tg/cm1MFQFw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RUx12r4IWkNLDsowdrG0tIOgZVYvTtRlYFpwS7Ps2MMhUDo8igPTsx5tqCIx+dq7Z
	 P45rLsyOHNZ648U94ptQfeZK2A6TIPNQ1jReHuNNaBFn1FpxVy8yWXLcWIeku6ogf3
	 phduk3qLzEe+N5cPT55mwg37gegxI/Km0KI7fLBcmLItsmKIyiPbKfe055cCnOgsmT
	 Hj6e5Xzpy/SOMfU4n1Jfo/4KJG55kbI+nqf+WVv1ur153KlNEiDkd3z+uNSX3O5xxx
	 wK869ki2JRA8vPt7m9JGtU8shMYnwNuJVRQ2YKntYe6yvK8KFGuG1wfJG6pEikmfAv
	 4BdET61TLKMcQ==
Message-ID: <86fc18f6-8c21-4738-9a10-64a2fa48cc1f@kernel.org>
Date: Wed, 2 Sep 2026 18:35:48 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm: replace PF_KSWAPD flag with kthread_func() check
To: Kefeng Wang <wangkefeng.wang@huawei.com>, brauner@kernel.org,
 djwong@kernel.org, cem@kernel.org, akpm@linux-foundation.org,
 surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev,
 hannes@cmpxchg.org, ziy@nvidia.com, david@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, ljs@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
 <20260902131653.1338227-4-wangkefeng.wang@huawei.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSNWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBrZXJuZWwub3JnPsLBsAQTAQoAWhYhBKlA1DSZLC6OmRA9UCJPp+fM
 gqZkBQJqFFy6GxSAAAAAAAQADm1hbnUyLDIuNSsxLjEyLDIsMgIbAwUJGtCBUAULCQgHAwUV
 CgkICwUWAgMBAAIeBQIXgAAKCRAiT6fnzIKmZJIUEADFx/tREzUImHrEwVHeSvDFmA7tJysI
 UVrlvrM09E7GIuzphzv7jYmo8n3ANpCczLEVr4G0syYQdTigaZgv3+FQDIIzhKih1IHhu1Ei
 XHlywNWKnQxxQEUNi5Mwx43wQz5XVw9F1A7gtKBKNtfogO511hAbrzagrYajyQacEJ/+sfhZ
 9Da8ltHIXD8pcYaHUfQgEusCgmEd9+KrUwrTbckFKmYq5chuE6yJ4J0EmWknL096jIE6CnzF
 FRslQ3B1UKDjxVsm1ZHfir5NeWszLkTvGFsddFaWTgh8UycESG6VQzKXjjewXu2pG7YQYRpj
 QKm1W5X2TkwWkXRBZTmfmbhxIUMh3+zf5wQ463rSmDN/8v81tdqBtAW6rH/kzg1GvkaTHXn0
 507yEHFzBksk2viAuIxxr7km8+/KARYLIdGtx30EG8cKzAUZOK6WqxtNCsXUJNrVE8CWrCaD
 icoNu7Fs1c5hmPHdSTnU48ce67449DdnO4neLSNhRiGlMHJgfJUmgrxu/hcYeOZ3haWmEQ2w
 uW1Mh01OHi8QZHCEyAbABrPs9GUgccc/4eYXX9hIgxfSkYzn8f+8NuIFPWl/0uTvjgqU29FQ
 SbzOLxHq9439Ox40G5mS5eZXRGxITYR+6TXvRGI6P/264jvflnr/pDGUttaikU+0W+1uxgKH
 cmYbEc7ATQRbGTU1AQgAn0H6UrFiWcovkh6EXVcl+SeqyO6JHOPm+e9Wu0Vw+VIUvXZVUVVQ
 La1PQDUi6j00ChlcR66g9/V0sPIcSutacPKfdKYOBvzd4rlhL8rfrdEsQw5ApZxrA8kYZVMh
 FmBRKAa6wos25moTlMKpCWzTH84+WO5+ziCTsTUZASAToz3RdunTD+vQcHj0GqNTPAHK63sf
 bAB2I0BslZkXkY1RLb/YhuA6E7JyEd2pilZOrIuBGl/5q2qSakgnAVFWFBR/DO27JuAksYnq
 +aH8vI0xGvwn75KqSk4UzAkDzWSmO4ZHuahKtQgZNsMYV+PGayRBX9b9zbldzopoLBdqHc4n
 jQARAQABwsF8BBgBCgAmAhsMFiEEqUDUNJksLo6ZED1QIk+n58yCpmQFAmfIHFQFCRYU6J8A
 CgkQIk+n58yCpmS2PA//bqN1LfcotmArgElsa+0EGZSQlYgK48pm8WAeTXTngudP9IJ4SuKY
 HR5RNjHcBeqN+Me0zxRqYzRb8nGanHEkDyf4Im8DQM8d6vbyU+FcPmG4skud4kgS1zMHnlVd
 SXfSIwKC/hKgdHG8aBV7545Lz9X6Iohea+94wneD0aw/hqF+QWewGZhWJriWAZtvEkzNjQOi
 4U9F/trLten/x7bpphDSnDMKJtITbtzATT1Dq7o7VpIUK1nCTQALMuMjKCdi8OdU/+V+R3O4
 0PXWvX8qrvqYapVbZ+9KqT74FsuB0Ya9uXwgBF2Q6cRuETZk5vqaqKxzqoQZCO8AOz/58j6O
 2RHNy/mZEN+7tJ5Tsq42zVJ4jxsT8b9YplavCMsnBgDeRWhcbYhCyttoL7nYISyWg4kQYZ/P
 wIV3OuNv2f8iKYsxNsRuClOAF82+gvqOy1/1pprFjy8uo2pkoOrb63aOP3vO5VHnRKgra6dq
 NcaZ+c6J4H+nEJGi2SkHAUJz5oBzuThvPudLvPA/SK8sKoM01IRxSihev/S/5WLazXB1PGem
 OCbvzC1IjWJJraxiDJ5IygokapUa2RP7+WBR22skQ3SSl6G107QgWKSyTOGWEaRmV53vxQLV
 jXuCmzSSasTL60zq5yGrT4/DYQVSNEUiUbG4pYekxJujNeEDkUlky0Y=
In-Reply-To: <20260902131653.1338227-4-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/2/26 15:16, Kefeng Wang wrote:
> The preceding commits removed the last consumer that propagated
> PF_KSWAPD beyond kswapd itself (XFS btree split worker inheritance).
> The only remaining setter of PF_KSWAPD is kswapd(), and every
> current_is_kswapd() caller only needs to check whether the current
> task *is* the kswapd thread, not whether it inherited the flag.
> 
> Replace the flag-based test with kthread_func(current) == kswapd,
> freeing the 0x00020000 PF flag bit.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  include/linux/sched.h                    |  2 +-
>  include/linux/swap.h                     |  7 +------
>  mm/vmscan.c                              | 10 ++++++++--
>  tools/sched_ext/include/scx/common.bpf.h |  1 -
>  4 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 8b3d47a325cc..86394121b6c0 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1809,7 +1809,7 @@ extern struct pid *cad_pid;
>  #define PF_USER_WORKER		0x00004000	/* Kernel thread cloned from userspace thread */
>  #define PF_NOFREEZE		0x00008000	/* This thread should not be frozen */
>  #define PF_KCOMPACTD		0x00010000	/* I am kcompactd */
> -#define PF_KSWAPD		0x00020000	/* I am kswapd */
> +#define PF__HOLE__00020000	0x00020000
>  #define PF_MEMALLOC_NOFS	0x00040000	/* All allocations inherit GFP_NOFS. See memalloc_nfs_save() */
>  #define PF_MEMALLOC_NOIO	0x00080000	/* All allocations inherit GFP_NOIO. See memalloc_noio_save() */
>  #define PF_LOCAL_THROTTLE	0x00100000	/* Throttle writes only against the bdi I write to,
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index a72ecf12c00d..fc290e29e4a9 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -25,12 +25,6 @@
>  #define SWAP_FLAGS_VALID	(SWAP_FLAG_PRIO_MASK | SWAP_FLAG_PREFER | \
>  				 SWAP_FLAG_DISCARD | SWAP_FLAG_DISCARD_ONCE | \
>  				 SWAP_FLAG_DISCARD_PAGES)
> -
> -static inline int current_is_kswapd(void)
> -{
> -	return current->flags & PF_KSWAPD;
> -}
> -
>  /*
>   * MAX_SWAPFILES defines the maximum number of swaptypes: things which can
>   * be swapped to.  The swap type and the offset into that swap type are
> @@ -339,6 +333,7 @@ void check_move_unevictable_folios(struct folio_batch *fbatch);
>  
>  extern void __meminit kswapd_run(int nid);
>  extern void __meminit kswapd_stop(int nid);
> +bool current_is_kswapd(void);
>  
>  #ifdef CONFIG_SWAP
>  int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 07ba86634b84..775d3f71a9de 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -7468,7 +7468,7 @@ static int kswapd(void *p)
>  	 * us from recursively trying to free more memory as we're
>  	 * trying to free the first piece of memory in the first place).
>  	 */
> -	tsk->flags |= PF_MEMALLOC | PF_KSWAPD;
> +	tsk->flags |= PF_MEMALLOC;
>  	set_freezable();
>  
>  	WRITE_ONCE(pgdat->kswapd_order, 0);
> @@ -7518,11 +7518,17 @@ static int kswapd(void *p)
>  			goto kswapd_try_sleep;
>  	}
>  
> -	tsk->flags &= ~(PF_MEMALLOC | PF_KSWAPD);
> +	tsk->flags &= ~PF_MEMALLOC;
>  
>  	return 0;
>  }
>  
> +bool current_is_kswapd(void)
> +{
> +	return kthread_func(current) == kswapd;
> +}
> +EXPORT_SYMBOL_GPL(current_is_kswapd);
> +
>  /*
>   * A zone is low on free memory or too fragmented for high-order memory.  If
>   * kswapd should reclaim (direct reclaim is deferred), wake it up for the zone's
> diff --git a/tools/sched_ext/include/scx/common.bpf.h b/tools/sched_ext/include/scx/common.bpf.h
> index 76f5e025e107..3e095343ae84 100644
> --- a/tools/sched_ext/include/scx/common.bpf.h
> +++ b/tools/sched_ext/include/scx/common.bpf.h
> @@ -32,7 +32,6 @@
>  #define PF_IO_WORKER			0x00000010	/* Task is an IO worker */
>  #define PF_WQ_WORKER			0x00000020	/* I'm a workqueue worker */
>  #define PF_KCOMPACTD			0x00010000      /* I am kcompactd */
> -#define PF_KSWAPD			0x00020000      /* I am kswapd */
>  #define PF_KTHREAD			0x00200000	/* I am a kernel thread */
>  #define PF_EXITING			0x00000004
>  #define CLOCK_MONOTONIC			1

