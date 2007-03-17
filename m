Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 17 Mar 2007 03:33:37 -0700 (PDT)
Received: from ozlabs.org (ozlabs.org [203.10.76.45])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2HAXP6p011024
	for <xfs@oss.sgi.com>; Sat, 17 Mar 2007 03:33:27 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17915.48105.70494.958220@cargo.ozlabs.ibm.com>
Date: Sat, 17 Mar 2007 20:59:05 +1100
From: Paul Mackerras <paulus@samba.org>
Subject: Re: [RFC][PATCH] sys_fallocate() system call
In-Reply-To: <20070316161704.GE8525@osiris.boeblingen.de.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
	<20070225022326.137b4875.akpm@linux-foundation.org>
	<20070301183445.GA7911@amitarora.in.ibm.com>
	<20070316143101.GA10152@amitarora.in.ibm.com>
	<20070316161704.GE8525@osiris.boeblingen.de.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com, cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com

Heiko Carstens writes:

> So you either rearrange the parameters or convert the loff_t's to pointers.
> 
> e.g.
> 
> asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len, int mode)
> 
> would work even on s390 ;)

... but wouldn't work on 32-bit powerpc. :(  We would end up with a
pad argument between fd and offset, giving 7 arguments in all
(counting the loff_t's as 2), but we only support 6.

Paul.
