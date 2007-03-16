Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 Mar 2007 08:42:26 -0700 (PDT)
Received: from mtagate3.uk.ibm.com (mtagate3.uk.ibm.com [195.212.29.136])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2GFgG6p008944
	for <xfs@oss.sgi.com>; Fri, 16 Mar 2007 08:42:18 -0700
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate3.uk.ibm.com (8.13.8/8.13.8) with ESMTP id l2GFMhJb073280
	for <xfs@oss.sgi.com>; Fri, 16 Mar 2007 15:22:43 GMT
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com [9.149.37.216])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2GFMhdx2105422
	for <xfs@oss.sgi.com>; Fri, 16 Mar 2007 15:22:43 GMT
Received: from d06av04.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av04.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2GFMgXn017555
	for <xfs@oss.sgi.com>; Fri, 16 Mar 2007 15:22:43 GMT
Date: Fri, 16 Mar 2007 16:21:03 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [RFC][PATCH] sys_fallocate() system call
Message-ID: <20070316152103.GD8525@osiris.boeblingen.de.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070316143101.GA10152@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com, cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com

On Fri, Mar 16, 2007 at 08:01:01PM +0530, Amit K. Arora wrote:
> First of all, thanks for the overwhelming response!
> 
> Based on the suggestions received, I have added a new parameter to the
> sys_fallocate() system call - an interger called "mode", just after the
> "fd". Now the system call looks like this:
> 
>  asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len)
> 
> Currently we have two modes FA_ALLOCATE and FA_DEALLOCATE, for
> preallocation and deallocation of preallocated blocks respectively. More
> modes can be added, when required. And these modes can be renamed, since
> I am sure these are no way the best ones ! :)
> 
> Attached below is the patch which implements this system call. It has
> been currently implemented and tested on i386, ppc64 and x86_64
> architectures. I am facing some problems while trying to implement this
> on s390, and thus the delay. While I try to get it right on s390(x), we
> thought of posting this patch, so that we can save some time. Parallely
> we will work on getting the patch work on s390, and probably it will
> come as a separate patch.

What's the problem you face on s390? If it's just the compat wrapper, you
may look at sys_sync_file_range_wrapper. Or I will send a patch if needed.
