Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 12:08:09 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6OJ83sA021230
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 12:08:04 -0700
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F052919230C4
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 12:09:14 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org [140.211.169.13]) by cuda.sgi.com with ESMTP id B4Qs9GSJHzk8mncH for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 12:09:14 -0700 (PDT)
Date: Thu, 24 Jul 2008 12:08:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: partially uptodate page reads
Message-Id: <20080724120841.81c72be9.akpm@linux-foundation.org>
In-Reply-To: <20080724175913.GA32117@infradead.org>
References: <200807250117.11331.nickpiggin@yahoo.com.au>
	<20080724175913.GA32117@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, hifumi.hisashi@oss.ntt.co.jp, jack@ucw.cz, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Thu, 24 Jul 2008 13:59:13 -0400 Christoph Hellwig <hch@infradead.org> wrote:

> On Fri, Jul 25, 2008 at 01:17:11AM +1000, Nick Piggin wrote:
> > Hi, I have some questions about your patch in -mm
> > 
> > vfs-pagecache-usage-optimization-onpagesize=blocksize-environment.patch
> > 
> > I have no particular problem with something like this, but leaving the
> > implementation details aside for the moment, can we discuss the
> > justification for this?
> > 
> > Are there significant numbers of people using block size < page size in
> > situations where performance is important and significantly improved by
> > this patch? Can you give any performance numbers to illustrate perhaps?
> 
> With XFS lots of people use 4k blocksize filesystems on ia64 systems
> with 16k pages, so an optimization like this would be useful.

As Nick says, we really should have some measurement results which
confirm this theory.  Maybe we did do some but they didn't find theor
way into the changelog.

I've put the patch on hold until this confirmation data is available.

> But as mentioned in one of your previous comments I'd rather prefer
> a readpage interface chaneg to deal with this.
