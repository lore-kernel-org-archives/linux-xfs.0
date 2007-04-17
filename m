Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Apr 2007 05:55:50 -0700 (PDT)
Received: from e5.ny.us.ibm.com (e5.ny.us.ibm.com [32.97.182.145])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3HCthfB002992
	for <xfs@oss.sgi.com>; Tue, 17 Apr 2007 05:55:45 -0700
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l3HCtgDX010326
	for <xfs@oss.sgi.com>; Tue, 17 Apr 2007 08:55:42 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l3HCtg8k444038
	for <xfs@oss.sgi.com>; Tue, 17 Apr 2007 08:55:42 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l3HCtPR3011241
	for <xfs@oss.sgi.com>; Tue, 17 Apr 2007 08:55:26 -0400
Date: Tue, 17 Apr 2007 18:25:14 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: Interface for the new fallocate() system call
Message-ID: <20070417125514.GA7574@amitarora.in.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com> <20070317111036.GC29931@parisc-linux.org> <20070321120425.GA27273@amitarora.in.ibm.com> <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070330071417.GI355@devserv.devel.redhat.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, Jakub Jelinek <jakub@redhat.com>, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com, suparna@in.ibm.com

On Fri, Mar 30, 2007 at 02:14:17AM -0500, Jakub Jelinek wrote:
> Wouldn't
> int fallocate(loff_t offset, loff_t len, int fd, int mode)
> work on both s390 and ppc/arm?  glibc will certainly wrap it and
> reorder the arguments as needed, so there is no need to keep fd first.
>

I think more people are comfirtable with this approach. Since glibc
will wrap the system call and export the "conventional" interface
(with fd first) to applications, we may not worry about keeping fd first
in kernel code. I am personally fine with this approach.

Still, if people have major concerns, we can think of getting rid of the
"mode" argument itself. Anyhow we may, in future, need to have a policy
based system call (say, for providing the goal block by applications for
performance reasons). "mode" can then be made part of it.

Comments ?
--
Regards,
Amit Arora
