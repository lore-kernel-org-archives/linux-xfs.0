Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 May 2007 08:33:32 -0700 (PDT)
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4EFXSfB023882
	for <xfs@oss.sgi.com>; Mon, 14 May 2007 08:33:29 -0700
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l4EFXSGR025359
	for <xfs@oss.sgi.com>; Mon, 14 May 2007 11:33:28 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4EFXR0K219552
	for <xfs@oss.sgi.com>; Mon, 14 May 2007 09:33:27 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4EFXQqb012695
	for <xfs@oss.sgi.com>; Mon, 14 May 2007 09:33:27 -0600
Date: Mon, 14 May 2007 21:03:30 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/5][TAKE2] fallocate() on s390 - glibc wrapper
Message-ID: <20070514153330.GA25249@amitarora.in.ibm.com>
References: <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070514132926.GA30768@amitarora.in.ibm.com> <20070514142820.GA31468@amitarora.in.ibm.com> <20070514144833.GB31748@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514144833.GB31748@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Mon, May 14, 2007 at 08:18:34PM +0530, Amit K. Arora wrote:
> This is the patch suggested by Martin Schwidefsky. Here are the comments
> and patch from him.

Martin also suggested a wrapper in glibc to handle this system call on
s390. Posting it here so that we get feedback for this too.
Here it is:

.globl __fallocate
ENTRY(__fallocate)
	stm	%r6,%r7,28(%r15)	/* save %r6/%r7 on stack */
	cfi_offset (%r7, -68)
	cfi_offset (%r6, -72)
	lm	%r6,%r7,96(%r15)	/* load loff_t len from stack */
	svc	SYS_ify(fallocate)
	lm	%r6,%r7,28(%r15)	/* restore %r6/%r7 from stack */
	br	%r14
PSEUDO_END(__fallocate)

--
Regards,
Amit Arora
 
> -------------
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> This patch implements support of fallocate system call on s390(x)
> platform. A wrapper is added to address the issue which s390 ABI has
> with the arguments of this system call.
> 
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
> 
>  arch/s390/kernel/compat_wrapper.S |   10 ++++++++++
>  arch/s390/kernel/sys_s390.c       |   29 +++++++++++++++++++++++++++++
>  arch/s390/kernel/syscalls.S       |    1 +
>  include/asm-s390/unistd.h         |    3 ++-
>  4 files changed, 42 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.21/arch/s390/kernel/compat_wrapper.S
> ===================================================================
> --- linux-2.6.21.orig/arch/s390/kernel/compat_wrapper.S
> +++ linux-2.6.21/arch/s390/kernel/compat_wrapper.S
> @@ -1682,3 +1682,13 @@ compat_sys_utimes_wrapper:
>  	llgtr	%r2,%r2			# char *
>  	llgtr	%r3,%r3			# struct compat_timeval *
>  	jg	compat_sys_utimes
> +
> +	.globl  sys_fallocate_wrapper
> +sys_fallocate_wrapper:
> +	lgfr	%r2,%r2			# int
> +	lgfr	%r3,%r3			# int
> +	sllg    %r4,%r4,32		# get high word of 64bit loff_t
> +	lr      %r4,%r5			# get low word of 64bit loff_t
> +	sllg    %r5,%r6,32		# get high word of 64bit loff_t
> +	l	%r5,164(%r15)		# get low word of 64bit loff_t
> +	jg	sys_fallocate
> Index: linux-2.6.21/arch/s390/kernel/syscalls.S
> ===================================================================
> --- linux-2.6.21.orig/arch/s390/kernel/syscalls.S
> +++ linux-2.6.21/arch/s390/kernel/syscalls.S
> @@ -322,3 +322,4 @@ NI_SYSCALL							/* 310 sys_move_pages *
>  SYSCALL(sys_getcpu,sys_getcpu,sys_getcpu_wrapper)
>  SYSCALL(sys_epoll_pwait,sys_epoll_pwait,compat_sys_epoll_pwait_wrapper)
>  SYSCALL(sys_utimes,sys_utimes,compat_sys_utimes_wrapper)
> +SYSCALL(s390_fallocate,sys_fallocate,sys_fallocate_wrapper)
> Index: linux-2.6.21/arch/s390/kernel/sys_s390.c
> ===================================================================
> --- linux-2.6.21.orig/arch/s390/kernel/sys_s390.c
> +++ linux-2.6.21/arch/s390/kernel/sys_s390.c
> @@ -286,3 +286,32 @@ int kernel_execve(const char *filename, 
>  		  "d" (__arg3) : "memory");
>  	return __svcres;
>  }
> +
> +#ifndef CONFIG_64BIT
> +/*
> + * This is a wrapper to call sys_fallocate(). For 31 bit s390 the last
> + * 64 bit argument "len" is split into the upper and lower 32 bits. The
> + * system call wrapper in the user space loads the value to %r6/%r7.
> + * The code in entry.S keeps the values in %r2 - %r6 where they are and
> + * stores %r7 to 96(%r15). But the standard C linkage requires that
> + * the whole 64 bit value for len is stored on the stack and doesn't
> + * use %r6 at all. So s390_fallocate has to convert the arguments from
> + *   %r2: fd, %r3: mode, %r4/%r5: offset, %r6/96(%r15)-99(%r15): len
> + * to
> + *   %r2: fd, %r3: mode, %r4/%r5: offset, 96(%r15)-103(%r15): len
> + */
> +asmlinkage long s390_fallocate(int fd, int mode, loff_t offset,
> +			       u32 len_high, u32 len_low)
> +{
> +	union {
> +		u64 len;
> +		struct {
> +			u32 high;
> +			u32 low;
> +		};
> +	} cv;
> +	cv.high = len_high;
> +	cv.low = len_low;
> +	return sys_fallocate(fd, mode, offset, cv.len);
> +}
> +#endif
> Index: linux-2.6.21/include/asm-s390/unistd.h
> ===================================================================
> --- linux-2.6.21.orig/include/asm-s390/unistd.h
> +++ linux-2.6.21/include/asm-s390/unistd.h
> @@ -251,8 +251,9 @@
>  #define __NR_getcpu		311
>  #define __NR_epoll_pwait	312
>  #define __NR_utimes		313
> +#define __NR_fallocate		314
> 
> -#define NR_syscalls 314
> +#define NR_syscalls 315
> 
>  /* 
>   * There are some system calls that are not present on 64 bit, some
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
