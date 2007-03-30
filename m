Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 30 Mar 2007 00:49:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2U7n66p023571
	for <xfs@oss.sgi.com>; Fri, 30 Mar 2007 00:49:08 -0700
Date: Fri, 30 Mar 2007 02:14:17 -0500
From: Jakub Jelinek <jakub@redhat.com>
Subject: Re: Interface for the new fallocate() system call
Message-ID: <20070330071417.GI355@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com> <20070317111036.GC29931@parisc-linux.org> <20070321120425.GA27273@amitarora.in.ibm.com> <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070329101010.7a2b8783.akpm@linux-foundation.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Thu, Mar 29, 2007 at 10:10:10AM -0700, Andrew Morton wrote:
> > Platform: s390
> > --------------
> > s390 prefers following layout:
> > 
> >    int fallocate(int fd, loff_t offset, loff_t len, int mode)
> > 
> > For details on why and how "int, int, loff_t, loff_t" is a problem on
> > s390, please see Heiko's mail on 16th March. Here is the link:
> > http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg133595.html
> > 
> > Platform: ppc, arm
> > ------------------
> > ppc (32 bit) has a problem with "int, loff_t, loff_t, int" layout,
> > since this will result in a pad between fd and offset, making seven
> > arguments total - which is not supported by ppc32. It supports only
> > 6 arguments. Thus the desired layout by ppc32 is:
> > 
> >    int fallocate(int fd, int mode, loff_t offset, loff_t len)
> > 
> > Even ARM prefers above kind of layout. For details please see the
> > definition of sys_arm_sync_file_range().
> 
> This is a clean-looking option.  Can s390 be changed to support seven-arg
> syscalls?

Wouldn't
int fallocate(loff_t offset, loff_t len, int fd, int mode)
work on both s390 and ppc/arm?  glibc will certainly wrap it and
reorder the arguments as needed, so there is no need to keep fd first.

	Jakub
