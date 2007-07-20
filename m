Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 20 Jul 2007 00:58:53 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6K7wnbm029842
	for <xfs@oss.sgi.com>; Fri, 20 Jul 2007 00:58:50 -0700
Date: Fri, 20 Jul 2007 08:29:23 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/7] - choose single default logbuf count & size
Message-ID: <20070720072923.GB29295@infradead.org>
References: <46A03617.3060009@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A03617.3060009@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Jul 19, 2007 at 11:12:07PM -0500, Eric Sandeen wrote:
> Remove sizing of logbuf size & count based on physical memory;
> this was never a very good gauge as it's looking at global
> memory, but deciding on sizing per-filesystem; no account
> is made of the total number of filesystems, for example.
> 
> For now just take the largest "default" case, as was set
> for machines with >400MB - 8 x 32k buffers.  This can
> always be tuned higher or lower with mount options
> if necessary.  Removes one more user of xfs_physmem.

Looks good.
