Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 Mar 2007 02:31:39 -0700 (PDT)
Received: from e2.ny.us.ibm.com (e2.ny.us.ibm.com [32.97.182.142])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2J9VR6p020551
	for <xfs@oss.sgi.com>; Mon, 19 Mar 2007 02:31:28 -0700
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2J9VOvt026036
	for <xfs@oss.sgi.com>; Mon, 19 Mar 2007 05:31:24 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2J9U83A183388
	for <xfs@oss.sgi.com>; Mon, 19 Mar 2007 05:30:08 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2J9U7Zk011279
	for <xfs@oss.sgi.com>; Mon, 19 Mar 2007 05:30:08 -0400
Date: Mon, 19 Mar 2007 15:00:06 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] sys_fallocate() system call
Message-ID: <20070319093006.GB12092@amitarora.in.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070317163350.6b676c26.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070317163350.6b676c26.sfr@canb.auug.org.au>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com, cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com

On Sat, Mar 17, 2007 at 04:33:50PM +1100, Stephen Rothwell wrote:
> On Fri, 16 Mar 2007 20:01:01 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
> >
> 
> > +asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
> >
> > --- linux-2.6.20.1.orig/include/asm-powerpc/systbl.h
> > +++ linux-2.6.20.1/include/asm-powerpc/systbl.h
> > @@ -305,3 +305,4 @@ SYSCALL_SPU(faccessat)
> >  COMPAT_SYS_SPU(get_robust_list)
> >  COMPAT_SYS_SPU(set_robust_list)
> >  COMPAT_SYS(move_pages)
> > +SYSCALL(fallocate)
> 
> It is going to need to be a COMPAT_SYS call in powerpc because 32 bit
> powerpc will pass the two loff_t's in pairs of registers while
> 64bit passes them in one register each.

Ok. Will make that change, unless it is decided to pass each loff_t
argument as two "u32"s. Thanks!

--
Regards,
Amit Arora
