Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 03 Sep 2008 05:15:01 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m83CEuVb022835
	for <xfs@oss.sgi.com>; Wed, 3 Sep 2008 05:14:56 -0700
Date: Wed, 3 Sep 2008 08:16:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] Don't do I/O beyond eof when unreserving space
Message-ID: <20080903121622.GA5980@infradead.org>
References: <48BE14BF.2010906@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48BE14BF.2010906@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Sep 03, 2008 at 02:38:23PM +1000, Lachlan McIlroy wrote:
> When unreserving space with boundaries that are not block aligned we round
> up the start and round down the end boundaries and then use this function,
> xfs_zero_remaining_bytes(), to zero the parts of the blocks that got dropped
> during the rounding.  The problem is we don't consider if these blocks are
> beyond eof.  Worse still is if we encounter delayed allocations beyond eof
> we will try to use the magic delayed allocation block number as a real block
> number.  If the file size is ever extended to expose these blocks then we'll
> go through xfs_zero_eof() to zero them anyway.  Version 2 adds some comments.

Looks good.
