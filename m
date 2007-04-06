Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 06 Apr 2007 03:20:00 -0700 (PDT)
Received: from mail.clusterfs.com (mail.clusterfs.com [206.168.112.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l36AJsfB023236
	for <xfs@oss.sgi.com>; Fri, 6 Apr 2007 03:19:55 -0700
Date: Fri, 6 Apr 2007 03:58:20 -0600
From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Interface for the new fallocate() system call
Message-ID: <20070406095820.GF5967@schatzie.adilger.int>
References: <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com> <20070317111036.GC29931@parisc-linux.org> <20070321120425.GA27273@amitarora.in.ibm.com> <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070405112619.GA19982@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070405112619.GA19982@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: Jakub Jelinek <jakub@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Apr 05, 2007  16:56 +0530, Amit K. Arora wrote:
> This should work on all the platforms. The only concern I can think of
> here is the convention being followed till now, where all the entities on
> which the action has to be performed by the kernel (say fd, file/device
> name, pid etc.) is the first argument of the system call. If we can live
> with the small exception here, fine.

Yes, it is much cleaner to have fd first, like every other such syscall.

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

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
