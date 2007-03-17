Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 17 Mar 2007 04:43:01 -0700 (PDT)
Received: from mail.parisc-linux.org ([192.25.206.14])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2HBgq6p028048
	for <xfs@oss.sgi.com>; Sat, 17 Mar 2007 04:42:53 -0700
Date: Sat, 17 Mar 2007 05:10:37 -0600
From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC][PATCH] sys_fallocate() system call
Message-ID: <20070317111036.GC29931@parisc-linux.org>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070316161704.GE8525@osiris.boeblingen.de.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com, cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com

On Fri, Mar 16, 2007 at 05:17:04PM +0100, Heiko Carstens wrote:
> > +asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len)
> 
> e.g.
> 
> asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len, int mode)
> 
> would work even on s390 ;)

How about:

asmlinkage long sys_fallocate(int fd, int mode, u32 off_low, u32 off_high,
				u32 len_low, u32 len_high);

That way we all suffer equally ...
