Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 29 Jun 2007 13:48:42 -0700 (PDT)
Received: from smtp2.linux-foundation.org (smtp2.linux-foundation.org [207.189.120.14])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5TKmXtL010777
	for <xfs@oss.sgi.com>; Fri, 29 Jun 2007 13:48:34 -0700
Date: Fri, 29 Jun 2007 13:47:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.22-rc6-mm1
Message-Id: <20070629134748.71adba1e.akpm@linux-foundation.org>
In-Reply-To: <200706291432.10128.m.kozlowski@tuxland.pl>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
	<200706291432.10128.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, Jason Wessel <jason.wessel@windriver.com>, Michal Marek <mmarek@suse.cz>
Cc: paulus@samba.org, xfs-masters@oss.sgi.com, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, xfs@oss.sgi.com

On Fri, 29 Jun 2007 14:32:09 +0200
Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Hello,
> 
> 	allmodconfig on powerpc (iMac g3) fails due to
> git-kgdb.patch. allmodconfig defaults should be changed?
> 
>   CC      arch/powerpc/kernel/kgdb.o
> arch/powerpc/kernel/kgdb.c:485:2: error: #error Both XMON and KGDB selected 
> in .config. Unselect one of them.
> make[1]: *** [arch/powerpc/kernel/kgdb.o] Blad 1
> make: *** [arch/powerpc/kernel] Blad 2

Jason cc'ed

> anyway after unselecting XMON we can see:
> 
>   CC [M]  fs/xfs/linux-2.6/xfs_ioctl32.o
> fs/xfs/linux-2.6/xfs_ioctl32.c: In function 'xfs_ioc_bulkstat_compat':
> fs/xfs/linux-2.6/xfs_ioctl32.c:334: error: 'xfs_inumbers_fmt_compat' 
> undeclared (first use in this function)
> fs/xfs/linux-2.6/xfs_ioctl32.c:334: error: (Each undeclared identifier is 
> reported only once
> fs/xfs/linux-2.6/xfs_ioctl32.c:334: error: for each function it appears in.)
> make[2]: *** [fs/xfs/linux-2.6/xfs_ioctl32.o] Blad 1
> make[1]: *** [fs/xfs] Blad 2
> 
> This is just allmodconfig - not a .config that's used daily by users but I'm 
> used to compiling the kernel using it anyway 8)
> 

Michal cc'ed.  I think this is the one which was already reported but
I haven't seen a fix yet?
