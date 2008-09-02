Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 02 Sep 2008 14:50:33 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m82LoVEK028434
	for <xfs@oss.sgi.com>; Tue, 2 Sep 2008 14:50:32 -0700
Date: Tue, 2 Sep 2008 17:51:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Don't do I/O beyond eof when unreserving space
Message-ID: <20080902215157.GC9204@infradead.org>
References: <48BCCE29.3070707@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48BCCE29.3070707@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Sep 02, 2008 at 03:24:57PM +1000, Lachlan McIlroy wrote:
> When unreserving space with boundaries that are not block aligned we round
> up the start and round down the end boundaries and then use this function,
> xfs_zero_remaining_bytes(), to zero the parts of the blocks that got dropped
> during the rounding.  The problem is we don't consider if these blocks are
> beyond eof.  Worse still is if we encounter delayed allocations beyond eof
> we will try to use the magic delayed allocation block number as a real block
> number.  If the file size is ever extended to expose these blocks then we'll
> go through xfs_zero_eof() to zero them anyway.

Makes sense.  Would be nice to have a comment above the check explaining
why these first strange checks are there.  Something like the first
setence of the patch description here.
