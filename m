Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 Mar 2007 04:25:23 -0700 (PDT)
Received: from mtagate4.uk.ibm.com (mtagate4.uk.ibm.com [195.212.29.137])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2JBPB6p020176
	for <xfs@oss.sgi.com>; Mon, 19 Mar 2007 04:25:13 -0700
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate4.uk.ibm.com (8.13.8/8.13.8) with ESMTP id l2JBP8s6025314
	for <xfs@oss.sgi.com>; Mon, 19 Mar 2007 11:25:08 GMT
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2JBP8sj2039814
	for <xfs@oss.sgi.com>; Mon, 19 Mar 2007 11:25:08 GMT
Received: from d06av02.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2JBP7Pc017691
	for <xfs@oss.sgi.com>; Mon, 19 Mar 2007 11:25:08 GMT
Date: Mon, 19 Mar 2007 12:23:12 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [RFC][PATCH] sys_fallocate() system call
Message-ID: <20070319112312.GA8331@osiris.boeblingen.de.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070316152103.GD8525@osiris.boeblingen.de.ibm.com> <20070319092404.GA12092@amitarora.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070319092404.GA12092@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com, cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com, Matthew Wilcox <matthew@wil.cx>, Paul Mackerras <paulus@samba.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Russell King <rmk+lkml@arm.linux.org.uk>

On Mon, Mar 19, 2007 at 02:54:04PM +0530, Amit K. Arora wrote:
> On Fri, Mar 16, 2007 at 04:21:03PM +0100, Heiko Carstens wrote:
> > On Fri, Mar 16, 2007 at 08:01:01PM +0530, Amit K. Arora wrote:
> > >  asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len)
> > > 
> > > Currently we have two modes FA_ALLOCATE and FA_DEALLOCATE, for
> > > preallocation and deallocation of preallocated blocks respectively. More
> > > modes can be added, when required. And these modes can be renamed, since
> > > I am sure these are no way the best ones ! :)
> > > 
> Yes, the problem was adding compat wrapper for this. I will appreciate
> your help in writing it. Only thing is that we might have to wait till
> the order of the arguments is decided upon. Thanks!

There is probably not much choice. If you want to stay with the loff_t
arguments it won't work on 31-bit s390 or 32-bit powerpc dependent on the
order of the arguments.
So you should go for what Matthew Wilcox suggested:

asmlinkage long sys_fallocate(int fd, int mode, u32 off_low, u32 off_high,
			      u32 len_low, u32 len_high);

That way it will work an all architectures and in addition no architecture
has to do some magic to combine the splitted 64 bit arguments in compat
mode.
