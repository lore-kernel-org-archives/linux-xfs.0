Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 02 Oct 2007 16:23:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l92NNH9d031791
	for <xfs@oss.sgi.com>; Tue, 2 Oct 2007 16:23:19 -0700
Date: Wed, 3 Oct 2007 09:23:05 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: sync_blockdev in xfs_flush_device_work
Message-ID: <20071002232304.GG23367404@sgi.com>
References: <20070929110921.GA2466@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070929110921.GA2466@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sat, Sep 29, 2007 at 01:09:21PM +0200, Christoph Hellwig wrote:
> How is the sync_blockdev in the ENOSP path going to help it?  It only
> syncs the block device mapping which XFS doesn't use it at all.

Not really sure - it's probably a left over from when XFs was
using it, but still that makes no difference to ENOSPC flushing..

I think we can kill it...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
