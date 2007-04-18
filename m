Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Apr 2007 06:06:12 -0700 (PDT)
Received: from mail.clusterfs.com (mail.clusterfs.com [206.168.112.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3ID63fB007264
	for <xfs@oss.sgi.com>; Wed, 18 Apr 2007 06:06:05 -0700
Date: Wed, 18 Apr 2007 07:06:00 -0600
From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Interface for the new fallocate() system call
Message-ID: <20070418130600.GW5967@schatzie.adilger.int>
References: <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com> <20070317111036.GC29931@parisc-linux.org> <20070321120425.GA27273@amitarora.in.ibm.com> <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417125514.GA7574@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jakub Jelinek <jakub@redhat.com>, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com, suparna@in.ibm.com

On Apr 17, 2007  18:25 +0530, Amit K. Arora wrote:
> On Fri, Mar 30, 2007 at 02:14:17AM -0500, Jakub Jelinek wrote:
> > Wouldn't
> > int fallocate(loff_t offset, loff_t len, int fd, int mode)
> > work on both s390 and ppc/arm?  glibc will certainly wrap it and
> > reorder the arguments as needed, so there is no need to keep fd first.
> 
> I think more people are comfirtable with this approach.

Really?  I thought from the last postings that "fd first, wrap on s390"
was better.

> Since glibc
> will wrap the system call and export the "conventional" interface
> (with fd first) to applications, we may not worry about keeping fd first
> in kernel code. I am personally fine with this approach.

It would seem to make more sense to wrap the syscall on those architectures
that can't handle the "conventional" interface (fd first).

> Still, if people have major concerns, we can think of getting rid of the
> "mode" argument itself. Anyhow we may, in future, need to have a policy
> based system call (say, for providing the goal block by applications for
> performance reasons). "mode" can then be made part of it.

We need at least mode="unallocate" or a separate funallocate() call to
allow allocated-but-unwritten blocks to be unallocated without actually
punching out written data.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
