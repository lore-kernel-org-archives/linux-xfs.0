Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Jun 2007 08:35:10 -0700 (PDT)
Received: from mtagate5.uk.ibm.com (mtagate5.uk.ibm.com [195.212.29.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5QFZ2tL019957
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 08:35:04 -0700
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate5.uk.ibm.com (8.13.8/8.13.8) with ESMTP id l5QFF6HO082038
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 15:15:06 GMT
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5QFF6Kj2953434
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 16:15:06 +0100
Received: from d06av02.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5QFF5hp026055
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 16:15:06 +0100
Date: Tue, 26 Jun 2007 17:15:05 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 2/7][TAKE5] fallocate() on s390(x)
Message-ID: <20070626151505.GA15160@osiris.boeblingen.de.ibm.com>
References: <20070510223950.GD86004887@sgi.com> <20070511110301.GB28425@in.ibm.com> <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134255.GC1951@amitarora.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625134255.GC1951@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

> Index: linux-2.6.22-rc4/arch/s390/kernel/syscalls.S
> ===================================================================
> --- linux-2.6.22-rc4.orig/arch/s390/kernel/syscalls.S	2007-06-11 16:16:01.000000000 -0700
> +++ linux-2.6.22-rc4/arch/s390/kernel/syscalls.S	2007-06-11 16:27:29.000000000 -0700
> @@ -322,6 +322,7 @@
>  SYSCALL(sys_getcpu,sys_getcpu,sys_getcpu_wrapper)
>  SYSCALL(sys_epoll_pwait,sys_epoll_pwait,compat_sys_epoll_pwait_wrapper)
>  SYSCALL(sys_utimes,sys_utimes,compat_sys_utimes_wrapper)
> +SYSCALL(s390_fallocate,sys_fallocate,sys_fallocate_wrapper)
>  NI_SYSCALL							/* 314 sys_fallocate */

You need to remove the NI_SYSCALL line. Otherwise all following entries
will be wrong.

>  SYSCALL(sys_utimensat,sys_utimensat,compat_sys_utimensat_wrapper)	/* 315 */
>  SYSCALL(sys_signalfd,sys_signalfd,compat_sys_signalfd_wrapper)
> Index: linux-2.6.22-rc4/include/asm-s390/unistd.h
> ===================================================================
> --- linux-2.6.22-rc4.orig/include/asm-s390/unistd.h	2007-06-11 16:16:01.000000000 -0700
> +++ linux-2.6.22-rc4/include/asm-s390/unistd.h	2007-06-11 16:27:29.000000000 -0700
> @@ -256,7 +256,8 @@
>  #define __NR_signalfd		316
>  #define __NR_timerfd		317
>  #define __NR_eventfd		318
> -#define NR_syscalls 319
> +#define __NR_fallocate		319
> +#define NR_syscalls 320

Erm... no. You use slot 314 in the syscall table but assign number 319.
That won't work. Please use 314 for both.
I assume this got broken when updating to newer kernel versions.
