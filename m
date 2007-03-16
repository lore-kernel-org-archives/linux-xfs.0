Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 Mar 2007 09:18:50 -0700 (PDT)
Received: from mtagate1.de.ibm.com (mtagate1.de.ibm.com [195.212.29.150])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2GGIg6p017366
	for <xfs@oss.sgi.com>; Fri, 16 Mar 2007 09:18:44 -0700
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.13.8/8.13.8) with ESMTP id l2GGIfIw056630
	for <xfs@oss.sgi.com>; Fri, 16 Mar 2007 16:18:41 GMT
Received: from d12av01.megacenter.de.ibm.com (d12av01.megacenter.de.ibm.com [9.149.165.212])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2GGIe5e2080954
	for <xfs@oss.sgi.com>; Fri, 16 Mar 2007 17:18:41 +0100
Received: from d12av01.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av01.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2GGIex3006302
	for <xfs@oss.sgi.com>; Fri, 16 Mar 2007 17:18:40 +0100
Date: Fri, 16 Mar 2007 17:17:04 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [RFC][PATCH] sys_fallocate() system call
Message-ID: <20070316161704.GE8525@osiris.boeblingen.de.ibm.com>
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

> on s390, and thus the delay. While I try to get it right on s390(x), we
> thought of posting this patch, so that we can save some time. Parallely
> we will work on getting the patch work on s390, and probably it will
> come as a separate patch.
> 
> +asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len)
> +{

There is something here that will not work on s390 (31bit): the arguments
would end up in:
fd -> r2
mode -> r3
offset -> r4 + r5
len -> r6 + second halve on stack

But the s390 ABI says that a long long will be put into two consecutive
registers if the first register is smaller than 6, or it will be put
completely on the stack. So both 32 bit parts of len will end up on the
stack. That would make it a syscall with seven arguments which we currently
don't support on s390. There is no way to access the second half of len
from kernel space and that is why it is not working for you.
So you either rearrange the parameters or convert the loff_t's to pointers.

e.g.

asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len, int mode)

would work even on s390 ;)
