Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 17 Mar 2007 08:27:46 -0700 (PDT)
Received: from caramon.arm.linux.org.uk (caramon.arm.linux.org.uk [217.147.92.249])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2HFRb6p010125
	for <xfs@oss.sgi.com>; Sat, 17 Mar 2007 08:27:39 -0700
Date: Sat, 17 Mar 2007 14:53:48 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [RFC][PATCH] sys_fallocate() system call
Message-ID: <20070317145348.GA32278@flint.arm.linux.org.uk>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070316143101.GA10152@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com, cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com

On Fri, Mar 16, 2007 at 08:01:01PM +0530, Amit K. Arora wrote:
> Attached below is the patch which implements this system call. It has
> been currently implemented and tested on i386, ppc64 and x86_64
> architectures. I am facing some problems while trying to implement this
> on s390, and thus the delay. While I try to get it right on s390(x), we
> thought of posting this patch, so that we can save some time. Parallely
> we will work on getting the patch work on s390, and probably it will
> come as a separate patch.

I suggest reading the very end of arch/arm/kernel/sys_arm.c; I'd rather
avoid adding more and more hacks like that to the kernel if at all
possible.

One solution (already mentioned elsewhere) is that we start avoiding
passing 64-bit arguments and instead pass two 32-bit instead.  This
nicely avoids the alignment restrictions for 64-bit args in ABIs.

(The issue for ARM is that with anything other than the "fd, mode,
offset, len" layout we will have to deal with different ABI argument
layouts, or implement our own wrapper function as done for
sys_arm_sync_file_range.)

I think the problem comes down to "what is the argument layout which
causes the least amount of problems for the complete set of architectures."
For ARM, that's the "fd, mode, offset, len" layout.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
