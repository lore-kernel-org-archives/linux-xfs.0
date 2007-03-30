Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 30 Mar 2007 01:39:29 -0700 (PDT)
Received: from mtagate7.de.ibm.com (mtagate7.de.ibm.com [195.212.29.156])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2U8dL6p002770
	for <xfs@oss.sgi.com>; Fri, 30 Mar 2007 01:39:22 -0700
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate7.de.ibm.com (8.13.8/8.13.8) with ESMTP id l2U8dJDo146422
	for <xfs@oss.sgi.com>; Fri, 30 Mar 2007 08:39:19 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2U8dJRu2220066
	for <xfs@oss.sgi.com>; Fri, 30 Mar 2007 10:39:19 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2U8dIpv001587
	for <xfs@oss.sgi.com>; Fri, 30 Mar 2007 10:39:19 +0200
Date: Fri, 30 Mar 2007 10:39:18 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: Interface for the new fallocate() system call
Message-ID: <20070330083918.GD8365@osiris.boeblingen.de.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com> <20070317111036.GC29931@parisc-linux.org> <20070321120425.GA27273@amitarora.in.ibm.com> <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070330071417.GI355@devserv.devel.redhat.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jakub Jelinek <jakub@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Fri, Mar 30, 2007 at 02:14:17AM -0500, Jakub Jelinek wrote:
> On Thu, Mar 29, 2007 at 10:10:10AM -0700, Andrew Morton wrote:
> > > Platform: s390
> > > --------------
> > > s390 prefers following layout:
> > > 
> > >    int fallocate(int fd, loff_t offset, loff_t len, int mode)
> > > 
> > > For details on why and how "int, int, loff_t, loff_t" is a problem on
> > > s390, please see Heiko's mail on 16th March. Here is the link:
> > > http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg133595.html
> > > 
> > > Platform: ppc, arm
> > > ------------------
> > > ppc (32 bit) has a problem with "int, loff_t, loff_t, int" layout,
> > > since this will result in a pad between fd and offset, making seven
> > > arguments total - which is not supported by ppc32. It supports only
> > > 6 arguments. Thus the desired layout by ppc32 is:
> > > 
> > >    int fallocate(int fd, int mode, loff_t offset, loff_t len)
> > > 
> > > Even ARM prefers above kind of layout. For details please see the
> > > definition of sys_arm_sync_file_range().
> > 
> > This is a clean-looking option.  Can s390 be changed to support seven-arg
> > syscalls?
> 
> Wouldn't
> int fallocate(loff_t offset, loff_t len, int fd, int mode)
> work on both s390 and ppc/arm?  glibc will certainly wrap it and
> reorder the arguments as needed, so there is no need to keep fd first.

That would be fine for s390.
