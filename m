Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:7933 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728440AbeIRCwd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Sep 2018 22:52:33 -0400
Date: Tue, 18 Sep 2018 07:23:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: delalloc and reflink fixes & tweaks
Message-ID: <20180917212323.GF16550@dastard>
References: <20180917205354.15401-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180917205354.15401-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Sep 17, 2018 at 10:53:44PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series starts with a for-4.19 fix originally from Dave, and then
> has various tweaks, including a fix for a potential uninitialized data
> exposure that are 4.20 material.

Nice! I'll get the fix ready for 4.19-rc5 and look at the rest for
the 4.20 tree.

Do you have any numbers that demonstrate the performance impact of
the preallocation change? We've always intended to fix this exposure
issue as you've done, I'm just interested in the sort of impact it
has (if any). Allowing extent size hints to use delalloc should
substantially improve performance for workloads that use extent size
hints, so I don't expect the news to be all bad. :)

Also, with this change to use unwritten extents for all delalloc
extents, we can start doing speculative preallocation for writes
into holes inside EOF without leaving uninitialised/unzeroed blocks
laying around. Using spec.  prealloc for "extend-via-truncate,
sequential write to fill hole" workloads would greatly benefit from
that. Did you have any plans to look at that code?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
