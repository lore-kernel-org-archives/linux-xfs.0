Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 10:58:39 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6OHwAJ2016825
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 10:58:12 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 14CE21922835
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 10:59:20 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id CReOKg7sbFLQ6BW3 for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 10:59:20 -0700 (PDT)
Date: Thu, 24 Jul 2008 13:59:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: partially uptodate page reads
Message-ID: <20080724175913.GA32117@infradead.org>
References: <200807250117.11331.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807250117.11331.nickpiggin@yahoo.com.au>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: hifumi.hisashi@oss.ntt.co.jp, jack@ucw.cz, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, xfs@oss.sgi.com

On Fri, Jul 25, 2008 at 01:17:11AM +1000, Nick Piggin wrote:
> Hi, I have some questions about your patch in -mm
> 
> vfs-pagecache-usage-optimization-onpagesize=blocksize-environment.patch
> 
> I have no particular problem with something like this, but leaving the
> implementation details aside for the moment, can we discuss the
> justification for this?
> 
> Are there significant numbers of people using block size < page size in
> situations where performance is important and significantly improved by
> this patch? Can you give any performance numbers to illustrate perhaps?

With XFS lots of people use 4k blocksize filesystems on ia64 systems
with 16k pages, so an optimization like this would be useful.

But as mentioned in one of your previous comments I'd rather prefer
a readpage interface chaneg to deal with this.
