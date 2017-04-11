Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40336 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751449AbdDKRhB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 13:37:01 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 98F998F86B
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2017 17:37:00 +0000 (UTC)
Date: Tue, 11 Apr 2017 13:36:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: remove custom do_div implementations
Message-ID: <20170411173656.GB12238@bfoster.bfoster>
References: <0c0a6e24-f5c9-7610-fa38-b61be6d7439a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c0a6e24-f5c9-7610-fa38-b61be6d7439a@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Apr 07, 2017 at 04:42:18PM -0500, Eric Sandeen wrote:
> Long ago, all this gunk was added with a lament about problems
> with gcc's do_div, and a fun recommendation in the changelog:
> 
>  egcs-2.91.66 is the recommended compiler version for building XFS.
> 
> All this special stuff was needed to work around an old gcc bug,
> apparently, and it's been there ever since.
> 
> There should be no need for this anymore, so remove it.
> 
> Remove the special 32-bit xfs_do_mod as well; just let the
> kernel's do_div() handle all this.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Looks Ok to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> I'm currently running through xfstests on a 32-bit box with
> no issues, so going ahead & sending it out.
> 
> Darrick, please queue this for -rc7.  (I KID!)  ;)
> 
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index 592fdf7..044fb0e 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -212,88 +212,6 @@ static inline kgid_t xfs_gid_to_kgid(__uint32_t gid)
>  #define xfs_sort(a,n,s,fn)	sort(a,n,s,fn,NULL)
>  #define xfs_stack_trace()	dump_stack()
>  
> -
> -/* Move the kernel do_div definition off to one side */
> -
> -#if defined __i386__
> -/* For ia32 we need to pull some tricks to get past various versions
> - * of the compiler which do not like us using do_div in the middle
> - * of large functions.
> - */
> -static inline __u32 xfs_do_div(void *a, __u32 b, int n)
> -{
> -	__u32	mod;
> -
> -	switch (n) {
> -		case 4:
> -			mod = *(__u32 *)a % b;
> -			*(__u32 *)a = *(__u32 *)a / b;
> -			return mod;
> -		case 8:
> -			{
> -			unsigned long __upper, __low, __high, __mod;
> -			__u64	c = *(__u64 *)a;
> -			__upper = __high = c >> 32;
> -			__low = c;
> -			if (__high) {
> -				__upper = __high % (b);
> -				__high = __high / (b);
> -			}
> -			asm("divl %2":"=a" (__low), "=d" (__mod):"rm" (b), "0" (__low), "1" (__upper));
> -			asm("":"=A" (c):"a" (__low),"d" (__high));
> -			*(__u64 *)a = c;
> -			return __mod;
> -			}
> -	}
> -
> -	/* NOTREACHED */
> -	return 0;
> -}
> -
> -/* Side effect free 64 bit mod operation */
> -static inline __u32 xfs_do_mod(void *a, __u32 b, int n)
> -{
> -	switch (n) {
> -		case 4:
> -			return *(__u32 *)a % b;
> -		case 8:
> -			{
> -			unsigned long __upper, __low, __high, __mod;
> -			__u64	c = *(__u64 *)a;
> -			__upper = __high = c >> 32;
> -			__low = c;
> -			if (__high) {
> -				__upper = __high % (b);
> -				__high = __high / (b);
> -			}
> -			asm("divl %2":"=a" (__low), "=d" (__mod):"rm" (b), "0" (__low), "1" (__upper));
> -			asm("":"=A" (c):"a" (__low),"d" (__high));
> -			return __mod;
> -			}
> -	}
> -
> -	/* NOTREACHED */
> -	return 0;
> -}
> -#else
> -static inline __u32 xfs_do_div(void *a, __u32 b, int n)
> -{
> -	__u32	mod;
> -
> -	switch (n) {
> -		case 4:
> -			mod = *(__u32 *)a % b;
> -			*(__u32 *)a = *(__u32 *)a / b;
> -			return mod;
> -		case 8:
> -			mod = do_div(*(__u64 *)a, b);
> -			return mod;
> -	}
> -
> -	/* NOTREACHED */
> -	return 0;
> -}
> -
>  /* Side effect free 64 bit mod operation */
>  static inline __u32 xfs_do_mod(void *a, __u32 b, int n)
>  {
> @@ -310,10 +228,7 @@ static inline __u32 xfs_do_mod(void *a, __u32 b, int n)
>  	/* NOTREACHED */
>  	return 0;
>  }
> -#endif
>  
> -#undef do_div
> -#define do_div(a, b)	xfs_do_div(&(a), (b), sizeof(a))
>  #define do_mod(a, b)	xfs_do_mod(&(a), (b), sizeof(a))
>  
>  static inline __uint64_t roundup_64(__uint64_t x, __uint32_t y)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
