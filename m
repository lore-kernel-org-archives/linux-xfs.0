Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 Mar 2007 02:49:58 -0700 (PDT)
Received: from over.ny.us.ibm.com (over.ny.us.ibm.com [32.97.182.150])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2J9nm6p023850
	for <xfs@oss.sgi.com>; Mon, 19 Mar 2007 02:49:51 -0700
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
	by pokfb.esmtp.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l2J9OIHG013790
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 19 Mar 2007 05:24:18 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2J9OEIR011701
	for <xfs@oss.sgi.com>; Mon, 19 Mar 2007 05:24:14 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2J9OEbW057976
	for <xfs@oss.sgi.com>; Mon, 19 Mar 2007 03:24:14 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2J9ODFD002219
	for <xfs@oss.sgi.com>; Mon, 19 Mar 2007 03:24:13 -0600
Date: Mon, 19 Mar 2007 14:54:04 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] sys_fallocate() system call
Message-ID: <20070319092404.GA12092@amitarora.in.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070316152103.GD8525@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070316152103.GD8525@osiris.boeblingen.de.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com, cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com

On Fri, Mar 16, 2007 at 04:21:03PM +0100, Heiko Carstens wrote:
> On Fri, Mar 16, 2007 at 08:01:01PM +0530, Amit K. Arora wrote:
> > First of all, thanks for the overwhelming response!
> > 
> > Based on the suggestions received, I have added a new parameter to the
> > sys_fallocate() system call - an interger called "mode", just after the
> > "fd". Now the system call looks like this:
> > 
> >  asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len)
> > 
> > Currently we have two modes FA_ALLOCATE and FA_DEALLOCATE, for
> > preallocation and deallocation of preallocated blocks respectively. More
> > modes can be added, when required. And these modes can be renamed, since
> > I am sure these are no way the best ones ! :)
> > 
> > Attached below is the patch which implements this system call. It has
> > been currently implemented and tested on i386, ppc64 and x86_64
> > architectures. I am facing some problems while trying to implement this
> > on s390, and thus the delay. While I try to get it right on s390(x), we
> > thought of posting this patch, so that we can save some time. Parallely
> > we will work on getting the patch work on s390, and probably it will
> > come as a separate patch.
> 
> What's the problem you face on s390? If it's just the compat wrapper, you
> may look at sys_sync_file_range_wrapper. Or I will send a patch if needed.

Hi Heiko,

Yes, the problem was adding compat wrapper for this. I will appreciate
your help in writing it. Only thing is that we might have to wait till
the order of the arguments is decided upon. Thanks!

--
Regards,
Amit Arora
