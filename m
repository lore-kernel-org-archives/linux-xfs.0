Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 30 Mar 2007 03:32:50 -0700 (PDT)
Received: from ozlabs.org (ozlabs.org [203.10.76.45])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2UAWd6p000674
	for <xfs@oss.sgi.com>; Fri, 30 Mar 2007 03:32:41 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17932.54577.163137.202721@cargo.ozlabs.ibm.com>
Date: Fri, 30 Mar 2007 19:15:29 +1000
From: Paul Mackerras <paulus@samba.org>
Subject: Re: Interface for the new fallocate() system call
In-Reply-To: <20070330071417.GI355@devserv.devel.redhat.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
	<20070225022326.137b4875.akpm@linux-foundation.org>
	<20070301183445.GA7911@amitarora.in.ibm.com>
	<20070316143101.GA10152@amitarora.in.ibm.com>
	<20070316161704.GE8525@osiris.boeblingen.de.ibm.com>
	<20070317111036.GC29931@parisc-linux.org>
	<20070321120425.GA27273@amitarora.in.ibm.com>
	<20070329115126.GB7374@amitarora.in.ibm.com>
	<20070329101010.7a2b8783.akpm@linux-foundation.org>
	<20070330071417.GI355@devserv.devel.redhat.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jakub Jelinek <jakub@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

Jakub Jelinek writes:

> Wouldn't
> int fallocate(loff_t offset, loff_t len, int fd, int mode)
> work on both s390 and ppc/arm?  glibc will certainly wrap it and
> reorder the arguments as needed, so there is no need to keep fd first.

That looks fine to me.

Paul.
