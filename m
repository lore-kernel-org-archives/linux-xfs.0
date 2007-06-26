Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Jun 2007 12:39:17 -0700 (PDT)
Received: from mtagate7.de.ibm.com (mtagate7.de.ibm.com [195.212.29.156])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5QJd7tL015401
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 12:39:08 -0700
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate7.de.ibm.com (8.13.8/8.13.8) with ESMTP id l5QJd8t9091626
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 19:39:08 GMT
Received: from d12av04.megacenter.de.ibm.com (d12av04.megacenter.de.ibm.com [9.149.165.229])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5QJd79q1827034
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 21:39:07 +0200
Received: from d12av04.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av04.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5QJd7aJ022308
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 21:39:07 +0200
Date: Tue, 26 Jun 2007 21:38:55 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 1/7][TAKE5] fallocate() implementation on i386, x86_64 and powerpc
Message-ID: <20070626193855.GA13727@osiris.ibm.com>
References: <20070510223950.GD86004887@sgi.com> <20070511110301.GB28425@in.ibm.com> <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134012.GB1951@amitarora.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625134012.GB1951@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

> Index: linux-2.6.22-rc4/arch/powerpc/kernel/sys_ppc32.c
> ===================================================================
> --- linux-2.6.22-rc4.orig/arch/powerpc/kernel/sys_ppc32.c
> +++ linux-2.6.22-rc4/arch/powerpc/kernel/sys_ppc32.c
> @@ -773,6 +773,13 @@ asmlinkage int compat_sys_truncate64(con
>  	return sys_truncate(path, (high << 32) | low);
>  }
> 
> +asmlinkage long compat_sys_fallocate(int fd, int mode, u32 offhi, u32 offlo,
> +				     u32 lenhi, u32 lenlo)
> +{
> +	return sys_fallocate(fd, mode, ((loff_t)offhi << 32) | offlo,
> +			     ((loff_t)lenhi << 32) | lenlo);
> +}
> +
>  asmlinkage int compat_sys_ftruncate64(unsigned int fd, u32 reg4, unsigned long high,
>  				 unsigned long low)
>  {
> Index: linux-2.6.22-rc4/arch/x86_64/ia32/ia32entry.S
> ===================================================================
> --- linux-2.6.22-rc4.orig/arch/x86_64/ia32/ia32entry.S
> +++ linux-2.6.22-rc4/arch/x86_64/ia32/ia32entry.S
> @@ -719,4 +719,5 @@ ia32_sys_call_table:
>  	.quad compat_sys_signalfd
>  	.quad compat_sys_timerfd
>  	.quad sys_eventfd
> +	.quad sys_fallocate
>  ia32_syscall_end:

Btw. this is also (still?) broken. x86_64 needs a compat syscall here.
