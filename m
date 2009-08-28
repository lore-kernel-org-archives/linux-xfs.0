Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7SHFe62166748 for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 12:15:50 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 78C731B80FD5
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 10:16:29 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 7FIygBXoRP5Hb4ZD for
	<xfs@oss.sgi.com>; Fri, 28 Aug 2009 10:16:29 -0700 (PDT)
Message-ID: <4A9810C7.8010806@sandeen.net>
Date: Fri, 28 Aug 2009 10:15:51 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: fix unaligned access in libxfs
References: <20090828153718.GA26409@infradead.org>
In-Reply-To: <20090828153718.GA26409@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Gabriel Vlasiu <gabrielvlasiu@gmail.com>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> The get/put unaligned handlers we use to access the extent descriptor
> are not good enough for architectures like Sparc that do not tolerate
> dereferencing unaligned pointers.  Replace the implementation with the
> one the kernel uses on these architectures.  It might be a tad
> slower on architectures like x86, but I don't want to have multiple
> implementations around to not let the testing matrix explode.
> Also remove the unaligned.h header which includes another implementation
> for unaligned access we don't actually use anymore.
> 
> Note that the little change to xfs_inode.c needs to go into the kernel
> aswell, I will send a patch for that shortly.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Gabriel Vlasiu <gabrielvlasiu@gmail.com>
> Tested-by: Gabriel Vlasiu <gabrielvlasiu@gmail.com>

Looks good to me.

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> Index: xfsprogs-dev/libxfs/xfs.h
> ===================================================================
> --- xfsprogs-dev.orig/libxfs/xfs.h	2009-08-27 10:06:13.377855006 -0300
> +++ xfsprogs-dev/libxfs/xfs.h	2009-08-27 10:06:26.537884492 -0300
> @@ -127,19 +127,37 @@ static inline int __do_div(unsigned long
>  #define max_t(type,x,y) \
>  	({ type __x = (x); type __y = (y); __x > __y ? __x: __y; })
>  
> -/* only 64 bit accesses used in xfs kernel code */
> -static inline __u64 get_unaligned_be64(void *ptr)
> +
> +static inline __uint32_t __get_unaligned_be32(const __uint8_t *p)
> +{
> +        return p[0] << 24 | p[1] << 16 | p[2] << 8 | p[3];
> +}
> +
> +static inline __uint64_t get_unaligned_be64(void *p)
>  {
> -	__be64	__tmp;
> -	memmove(&__tmp, ptr, 8);
> -	return be64_to_cpu(__tmp);
> +	return (__uint64_t)__get_unaligned_be32(p) << 32 |
> +			   __get_unaligned_be32(p + 4);
>  }
>  
> -static inline void put_unaligned(__be64 val, void *ptr)
> +static inline void __put_unaligned_be16(__uint16_t val, __uint8_t *p)
>  {
> -	memmove(ptr, &val, 8);
> +	*p++ = val >> 8;
> +	*p++ = val;
>  }
>  
> +static inline void __put_unaligned_be32(__uint32_t val, __uint8_t *p)
> +{
> +	__put_unaligned_be16(val >> 16, p);
> +	__put_unaligned_be16(val, p + 2);
> +}
> +
> +static inline void put_unaligned_be64(__uint64_t val, void *p)
> +{
> +	__put_unaligned_be32(val >> 32, p);
> +	__put_unaligned_be32(val, p + 4);
> +}
> +
> +
>  static inline __attribute__((const))
>  int is_power_of_2(unsigned long n)
>  {
> Index: xfsprogs-dev/libxfs/xfs_inode.c
> ===================================================================
> --- xfsprogs-dev.orig/libxfs/xfs_inode.c	2009-08-27 10:06:13.385884867 -0300
> +++ xfsprogs-dev/libxfs/xfs_inode.c	2009-08-27 10:06:26.541855737 -0300
> @@ -1056,8 +1056,8 @@ xfs_iextents_copy(
>  		}
>  
>  		/* Translate to on disk format */
> -		put_unaligned(cpu_to_be64(ep->l0), &dp->l0);
> -		put_unaligned(cpu_to_be64(ep->l1), &dp->l1);
> +		put_unaligned_be64(ep->l0, &dp->l0);
> +		put_unaligned_be64(ep->l1, &dp->l1);
>  		dp++;
>  		copied++;
>  	}
> Index: xfsprogs-dev/include/Makefile
> ===================================================================
> --- xfsprogs-dev.orig/include/Makefile	2009-08-28 12:29:42.257922053 -0300
> +++ xfsprogs-dev/include/Makefile	2009-08-28 12:29:55.830456736 -0300
> @@ -37,7 +37,7 @@ PHFILES = darwin.h freebsd.h irix.h linu
>  DKHFILES = volume.h fstyp.h dvh.h
>  LSRCFILES = $(shell echo $(PHFILES) | sed -e "s/$(PKG_PLATFORM).h//g")
>  LSRCFILES += platform_defs.h.in builddefs.in buildmacros buildrules install-sh
> -LSRCFILES += $(DKHFILES) command.h input.h path.h project.h unaligned.h
> +LSRCFILES += $(DKHFILES) command.h input.h path.h project.h
>  LDIRT = xfs disk
>  
>  default install: xfs disk
> Index: xfsprogs-dev/include/unaligned.h
> ===================================================================
> --- xfsprogs-dev.orig/include/unaligned.h	2009-08-28 12:29:34.710448280 -0300
> +++ /dev/null	1970-01-01 00:00:00.000000000 +0000
> @@ -1,120 +0,0 @@
> -#ifndef _UNALIGNED_H_
> -#define _UNALIGNED_H_
> -
> -/*
> - * For the benefit of those who are trying to port Linux to another
> - * architecture, here are some C-language equivalents. 
> - *
> - * This is based almost entirely upon Richard Henderson's
> - * asm-alpha/unaligned.h implementation.  Some comments were
> - * taken from David Mosberger's asm-ia64/unaligned.h header.
> - */
> -
> -/* 
> - * The main single-value unaligned transfer routines.
> - */
> -#define get_unaligned(ptr) \
> -	__get_unaligned((ptr), sizeof(*(ptr)))
> -#define put_unaligned(x,ptr) \
> -	__put_unaligned((__u64)(x), (ptr), sizeof(*(ptr)))
> -
> -/*
> - * This function doesn't actually exist.  The idea is that when
> - * someone uses the macros below with an unsupported size (datatype),
> - * the linker will alert us to the problem via an unresolved reference
> - * error.
> - */
> -extern void bad_unaligned_access_length(void) __attribute__((noreturn));
> -
> -struct __una_u64 { __u64 x __attribute__((packed)); };
> -struct __una_u32 { __u32 x __attribute__((packed)); };
> -struct __una_u16 { __u16 x __attribute__((packed)); };
> -
> -/*
> - * Elemental unaligned loads 
> - */
> -
> -static inline __u64 __uldq(const __u64 *addr)
> -{
> -	const struct __una_u64 *ptr = (const struct __una_u64 *) addr;
> -	return ptr->x;
> -}
> -
> -static inline __u32 __uldl(const __u32 *addr)
> -{
> -	const struct __una_u32 *ptr = (const struct __una_u32 *) addr;
> -	return ptr->x;
> -}
> -
> -static inline __u16 __uldw(const __u16 *addr)
> -{
> -	const struct __una_u16 *ptr = (const struct __una_u16 *) addr;
> -	return ptr->x;
> -}
> -
> -/*
> - * Elemental unaligned stores 
> - */
> -
> -static inline void __ustq(__u64 val, __u64 *addr)
> -{
> -	struct __una_u64 *ptr = (struct __una_u64 *) addr;
> -	ptr->x = val;
> -}
> -
> -static inline void __ustl(__u32 val, __u32 *addr)
> -{
> -	struct __una_u32 *ptr = (struct __una_u32 *) addr;
> -	ptr->x = val;
> -}
> -
> -static inline void __ustw(__u16 val, __u16 *addr)
> -{
> -	struct __una_u16 *ptr = (struct __una_u16 *) addr;
> -	ptr->x = val;
> -}
> -
> -#define __get_unaligned(ptr, size) ({		\
> -	const void *__gu_p = ptr;		\
> -	__u64 val;				\
> -	switch (size) {				\
> -	case 1:					\
> -		val = *(const __u8 *)__gu_p;	\
> -		break;				\
> -	case 2:					\
> -		val = __uldw(__gu_p);		\
> -		break;				\
> -	case 4:					\
> -		val = __uldl(__gu_p);		\
> -		break;				\
> -	case 8:					\
> -		val = __uldq(__gu_p);		\
> -		break;				\
> -	default:				\
> -		bad_unaligned_access_length();	\
> -	};					\
> -	(__typeof__(*(ptr)))val;		\
> -})
> -
> -#define __put_unaligned(val, ptr, size)		\
> -do {						\
> -	void *__gu_p = ptr;			\
> -	switch (size) {				\
> -	case 1:					\
> -		*(__u8 *)__gu_p = val;		\
> -	        break;				\
> -	case 2:					\
> -		__ustw(val, __gu_p);		\
> -		break;				\
> -	case 4:					\
> -		__ustl(val, __gu_p);		\
> -		break;				\
> -	case 8:					\
> -		__ustq(val, __gu_p);		\
> -		break;				\
> -	default:				\
> -	    	bad_unaligned_access_length();	\
> -	};					\
> -} while(0)
> -
> -#endif /* _UNALIGNED_H */
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
