Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 14 Oct 2006 22:52:37 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9F5qLaG018889
	for <xfs@oss.sgi.com>; Sat, 14 Oct 2006 22:52:25 -0700
Message-ID: <4531CC5D.5010705@melbourne.sgi.com>
Date: Sun, 15 Oct 2006 15:51:25 +1000
From: David Chatterton <chatz@melbourne.sgi.com>
Reply-To: chatz@melbourne.sgi.com
MIME-Version: 1.0
Subject: Re: corrupted log causes infinite loop at mount
References: <452FECFE.5050902@sandeen.net>
In-Reply-To: <452FECFE.5050902@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Eric,

Eric Sandeen wrote:
> While playing with some filesystem corruption testers, I ran into this.
> 
> http://sandeen.net/xfs.31.img.bz2
> 
> If you try to mount, it gets into xfs_buf_get_noaddr via log replay with
> a len of 0, and I think this causes an infinite loop in the goto:
> 
>  try_again:
>         data = kmem_alloc(malloc_len, KM_SLEEP | KM_MAYFAIL);
>         if (unlikely(data == NULL))
>                 goto fail_free_buf;
> 
>         /* check whether alignment matches.. */
>         if ((__psunsigned_t)data !=
>             ((__psunsigned_t)data & ~target->bt_smask)) {
>                 /* .. else double the size and try again */
>                 kmem_free(data, malloc_len);
>                 malloc_len <<= 1;
>                 goto try_again;
>         }
> 
> Up the callchain a bit there is an ASSERT that the size is > 0, but of
> course that doesn't help on a non-debug kernel...
> 
> haven't had time to investigate beyond that.
> 
> -Eric
> 

I assume the loop is further up the chain since kmem_alloc should return NULL
when asked to alloc 0. So then the problem also lies further up the chain in
checking for a 0 length before calling down, and/or not assuming we are out of
memory when xfs_buf_get_noaddr fails.

David

-- 
David Chatterton
XFS Engineering Manager
SGI Australia
