Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Apr 2007 10:27:29 -0700 (PDT)
Received: from rgminet02.oracle.com (rgminet02.oracle.com [148.87.113.119])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l35HRKfB000743
	for <xfs@oss.sgi.com>; Thu, 5 Apr 2007 10:27:22 -0700
Received: from rgminet01.oracle.com (rgminet01.oracle.com [148.87.113.118])
	by rgminet02.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id l35FoFgj014786
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 5 Apr 2007 09:50:16 -0600
Date: Thu, 5 Apr 2007 08:50:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: Interface for the new fallocate() system call
Message-Id: <20070405085016.a513526b.randy.dunlap@oracle.com>
In-Reply-To: <20070405112619.GA19982@amitarora.in.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
	<20070225022326.137b4875.akpm@linux-foundation.org>
	<20070301183445.GA7911@amitarora.in.ibm.com>
	<20070316143101.GA10152@amitarora.in.ibm.com>
	<20070316161704.GE8525@osiris.boeblingen.de.ibm.com>
	<20070317111036.GC29931@parisc-linux.org>
	<20070321120425.GA27273@amitarora.in.ibm.com>
	<20070329115126.GB7374@amitarora.in.ibm.com>
	<20070329101010.7a2b8783.akpm@linux-foundation.org>
	<20070330071417.GI355@devserv.devel.redhat.com>
	<20070405112619.GA19982@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: Jakub Jelinek <jakub@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Thu, 5 Apr 2007 16:56:19 +0530 Amit K. Arora wrote:

> On Fri, Mar 30, 2007 at 02:14:17AM -0500, Jakub Jelinek wrote:
> > Wouldn't
> > int fallocate(loff_t offset, loff_t len, int fd, int mode)
> > work on both s390 and ppc/arm?  glibc will certainly wrap it and
> > reorder the arguments as needed, so there is no need to keep fd first.
>  
> This should work on all the platforms. The only concern I can think of
> here is the convention being followed till now, where all the entities on
> which the action has to be performed by the kernel (say fd, file/device
> name, pid etc.) is the first argument of the system call. If we can live
> with the small exception here, fine.
> 
> Or else, we may have to implement the 
> 
>   int fd, int mode, loff_t offset, loff_t len
> 
> as the layout of arguments here. I think only s390 will have a problem
> with this, and we can think of a workaround for it (may be similar to
> what ARM did to implement sync_file_range() system call)   :
> 
> asmlinkage long sys_s390_fallocate(int fd, loff_t offset, loff_t len, int mode)
> {
>         return sys_fallocate(fd, offset, len, mode);
> }
> 
> 
> To me both the approaches look slightly unconventional. But, we need to
> compromise somewhere to make things work on all the platforms.
> 
> Any thoughts on which one of the above should we finalize on ?
> 
> Thanks!

If s390 can work around the calling order that easily, I certainly
prefer the more conventional ordering of:

>   int fd, int mode, loff_t offset, loff_t len

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
