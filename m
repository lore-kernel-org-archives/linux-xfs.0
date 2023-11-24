Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF39C143
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 09:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="amm5BZge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CF5C433C9;
	Fri, 24 Nov 2023 09:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700817337;
	bh=5br3060aMQ365mQh/pFjUVxa6CrYZ1Ex+PtwgHCuHq0=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=amm5BZgeiQCpSdHso66LLdbhkoXXk4BQGi2C8VHv7lLwHSLn3DvxLMUxPg0vMTrgA
	 KVU/tC7pg6Bj8eivkBOVGcsHUTyZmlsWHAZpYBF5SPCS4csTp1JJyjwsH9ixQ4Ls4j
	 ae3HWuBT256dYLWflTpcCJuW7e0Wea4grCgIDInGbBzvaj2mfUyeruxG/xpOieEJc3
	 nLs14Ww5zgItChWQTO4QAyUv6qtBxAVneT5IRl/O+AWaJ0CucU3KI8bbsfyoLPHaEE
	 PV5x6yccfraCFZVnfFC4hCJ+sOWvSyLeMfQubomhS9xfx3V3GioPiynDnpa5EIVD5b
	 /ep5MgAfa0dUg==
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
 <170069441404.1865809.15599372422489523965.stgit@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From: Chandan Babu R <chandanbabu@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] libfrog: move 64-bit division wrappers to libfrog
Date: Fri, 24 Nov 2023 14:39:33 +0530
In-reply-to: <170069441404.1865809.15599372422489523965.stgit@frogsfrogsfrogs>
Message-ID: <87ttpbwlzd.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Nov 22, 2023 at 03:06:54 PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> We want to keep the rtgroup unit conversion functions as static inlines,
> so share the div64 functions via libfrog instead of libxfs_priv.h.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanbabu@kernel.org>

> ---
>  include/libxfs.h     |    1 +
>  libfrog/Makefile     |    1 +
>  libfrog/div64.h      |   96 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  libxfs/libxfs_priv.h |   77 +---------------------------------------
>  4 files changed, 99 insertions(+), 76 deletions(-)
>  create mode 100644 libfrog/div64.h
>
>
> diff --git a/include/libxfs.h b/include/libxfs.h
> index b28781d19d3..a6a5f66f28d 100644
> --- a/include/libxfs.h
> +++ b/include/libxfs.h
> @@ -18,6 +18,7 @@
>  #include "kmem.h"
>  #include "libfrog/radix-tree.h"
>  #include "libfrog/bitmask.h"
> +#include "libfrog/div64.h"
>  #include "atomic.h"
>  #include "spinlock.h"
>  
> diff --git a/libfrog/Makefile b/libfrog/Makefile
> index 8cde97d418f..dcfd1fb8a93 100644
> --- a/libfrog/Makefile
> +++ b/libfrog/Makefile
> @@ -41,6 +41,7 @@ crc32cselftest.h \
>  crc32defs.h \
>  crc32table.h \
>  dahashselftest.h \
> +div64.h \
>  fsgeom.h \
>  logging.h \
>  paths.h \
> diff --git a/libfrog/div64.h b/libfrog/div64.h
> new file mode 100644
> index 00000000000..673b01cbab3
> --- /dev/null
> +++ b/libfrog/div64.h
> @@ -0,0 +1,96 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2000-2005 Silicon Graphics, Inc.
> + * All Rights Reserved.
> + */
> +#ifndef LIBFROG_DIV64_H_
> +#define LIBFROG_DIV64_H_
> +
> +static inline int __do_div(unsigned long long *n, unsigned base)
> +{
> +	int __res;
> +	__res = (int)(((unsigned long) *n) % (unsigned) base);
> +	*n = ((unsigned long) *n) / (unsigned) base;
> +	return __res;
> +}
> +
> +#define do_div(n,base)	(__do_div((unsigned long long *)&(n), (base)))
> +#define do_mod(a, b)		((a) % (b))
> +#define rol32(x,y)		(((x) << (y)) | ((x) >> (32 - (y))))
> +
> +/**
> + * div_u64_rem - unsigned 64bit divide with 32bit divisor with remainder
> + * @dividend: unsigned 64bit dividend
> + * @divisor: unsigned 32bit divisor
> + * @remainder: pointer to unsigned 32bit remainder
> + *
> + * Return: sets ``*remainder``, then returns dividend / divisor
> + *
> + * This is commonly provided by 32bit archs to provide an optimized 64bit
> + * divide.
> + */
> +static inline uint64_t
> +div_u64_rem(uint64_t dividend, uint32_t divisor, uint32_t *remainder)
> +{
> +	*remainder = dividend % divisor;
> +	return dividend / divisor;
> +}
> +
> +/**
> + * div_u64 - unsigned 64bit divide with 32bit divisor
> + * @dividend: unsigned 64bit dividend
> + * @divisor: unsigned 32bit divisor
> + *
> + * This is the most common 64bit divide and should be used if possible,
> + * as many 32bit archs can optimize this variant better than a full 64bit
> + * divide.
> + */
> +static inline uint64_t div_u64(uint64_t dividend, uint32_t divisor)
> +{
> +	uint32_t remainder;
> +	return div_u64_rem(dividend, divisor, &remainder);
> +}
> +
> +/**
> + * div64_u64_rem - unsigned 64bit divide with 64bit divisor and remainder
> + * @dividend: unsigned 64bit dividend
> + * @divisor: unsigned 64bit divisor
> + * @remainder: pointer to unsigned 64bit remainder
> + *
> + * Return: sets ``*remainder``, then returns dividend / divisor
> + */
> +static inline uint64_t
> +div64_u64_rem(uint64_t dividend, uint64_t divisor, uint64_t *remainder)
> +{
> +	*remainder = dividend % divisor;
> +	return dividend / divisor;
> +}
> +
> +static inline uint64_t rounddown_64(uint64_t x, uint32_t y)
> +{
> +	do_div(x, y);
> +	return x * y;
> +}
> +
> +static inline bool isaligned_64(uint64_t x, uint32_t y)
> +{
> +	return do_div(x, y) == 0;
> +}
> +
> +static inline uint64_t
> +roundup_64(uint64_t x, uint32_t y)
> +{
> +	x += y - 1;
> +	do_div(x, y);
> +	return x * y;
> +}
> +
> +static inline uint64_t
> +howmany_64(uint64_t x, uint32_t y)
> +{
> +	x += y - 1;
> +	do_div(x, y);
> +	return x;
> +}
> +
> +#endif /* LIBFROG_DIV64_H_ */
> diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> index 2729241bdaa..5a7decf970e 100644
> --- a/libxfs/libxfs_priv.h
> +++ b/libxfs/libxfs_priv.h
> @@ -48,6 +48,7 @@
>  #include "kmem.h"
>  #include "libfrog/radix-tree.h"
>  #include "libfrog/bitmask.h"
> +#include "libfrog/div64.h"
>  #include "atomic.h"
>  #include "spinlock.h"
>  #include "linux-err.h"
> @@ -215,66 +216,6 @@ static inline bool WARN_ON(bool expr) {
>  	(inode)->i_version = (version);	\
>  } while (0)
>  
> -static inline int __do_div(unsigned long long *n, unsigned base)
> -{
> -	int __res;
> -	__res = (int)(((unsigned long) *n) % (unsigned) base);
> -	*n = ((unsigned long) *n) / (unsigned) base;
> -	return __res;
> -}
> -
> -#define do_div(n,base)	(__do_div((unsigned long long *)&(n), (base)))
> -#define do_mod(a, b)		((a) % (b))
> -#define rol32(x,y)		(((x) << (y)) | ((x) >> (32 - (y))))
> -
> -/**
> - * div_u64_rem - unsigned 64bit divide with 32bit divisor with remainder
> - * @dividend: unsigned 64bit dividend
> - * @divisor: unsigned 32bit divisor
> - * @remainder: pointer to unsigned 32bit remainder
> - *
> - * Return: sets ``*remainder``, then returns dividend / divisor
> - *
> - * This is commonly provided by 32bit archs to provide an optimized 64bit
> - * divide.
> - */
> -static inline uint64_t
> -div_u64_rem(uint64_t dividend, uint32_t divisor, uint32_t *remainder)
> -{
> -	*remainder = dividend % divisor;
> -	return dividend / divisor;
> -}
> -
> -/**
> - * div_u64 - unsigned 64bit divide with 32bit divisor
> - * @dividend: unsigned 64bit dividend
> - * @divisor: unsigned 32bit divisor
> - *
> - * This is the most common 64bit divide and should be used if possible,
> - * as many 32bit archs can optimize this variant better than a full 64bit
> - * divide.
> - */
> -static inline uint64_t div_u64(uint64_t dividend, uint32_t divisor)
> -{
> -	uint32_t remainder;
> -	return div_u64_rem(dividend, divisor, &remainder);
> -}
> -
> -/**
> - * div64_u64_rem - unsigned 64bit divide with 64bit divisor and remainder
> - * @dividend: unsigned 64bit dividend
> - * @divisor: unsigned 64bit divisor
> - * @remainder: pointer to unsigned 64bit remainder
> - *
> - * Return: sets ``*remainder``, then returns dividend / divisor
> - */
> -static inline uint64_t
> -div64_u64_rem(uint64_t dividend, uint64_t divisor, uint64_t *remainder)
> -{
> -	*remainder = dividend % divisor;
> -	return dividend / divisor;
> -}
> -
>  #define min_t(type,x,y) \
>  	({ type __x = (x); type __y = (y); __x < __y ? __x: __y; })
>  #define max_t(type,x,y) \
> @@ -380,22 +321,6 @@ roundup_pow_of_two(uint v)
>  	return 0;
>  }
>  
> -static inline uint64_t
> -roundup_64(uint64_t x, uint32_t y)
> -{
> -	x += y - 1;
> -	do_div(x, y);
> -	return x * y;
> -}
> -
> -static inline uint64_t
> -howmany_64(uint64_t x, uint32_t y)
> -{
> -	x += y - 1;
> -	do_div(x, y);
> -	return x;
> -}
> -
>  /* buffer management */
>  #define XBF_TRYLOCK			0
>  #define XBF_UNMAPPED			0


-- 
Chandan
