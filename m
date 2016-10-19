Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:52464 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755932AbcJSBPP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Oct 2016 21:15:15 -0400
Date: Wed, 19 Oct 2016 12:15:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: use rhashtable to track buffer cache
Message-ID: <20161019011512.GH23194@dastard>
References: <1476821653-2595-1-git-send-email-dev@lynxeye.de>
 <1476821653-2595-2-git-send-email-dev@lynxeye.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476821653-2595-2-git-send-email-dev@lynxeye.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Lucas Stach <dev@lynxeye.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 18, 2016 at 10:14:12PM +0200, Lucas Stach wrote:
> On filesystems with a lot of metadata and in metadata intensive workloads
> xfs_buf_find() is showing up at the top of the CPU cycles trace. Most of
> the CPU time is spent on CPU cache misses while traversing the rbtree.
> 
> As the buffer cache does not need any kind of ordering, but fast lookups
> a hashtable is the natural data structure to use. The rhashtable
> infrastructure provides a self-scaling hashtable implementation and
> allows lookups to proceed while the table is going through a resize
> operation.
> 
> This reduces the CPU-time spent for the lookups to 1/3 even for small
> filesystems with a relatively small number of cached buffers, with
> possibly much larger gains on higher loaded filesystems.
> 
> The minimum size of 4096 buckets was chosen as it was the size of the
> xfs buffer cache hash before it was converted to an rbtree.
> 
> Signed-off-by: Lucas Stach <dev@lynxeye.de>

This fails to compile on CONFIG_XFS_DEBUG=y kernels due to various
ASSERT statements not being updated appropriately. When making XFS
changes to core infrastructure like this, it is highly recommended
that you use CONFIG_XFS_DEBUG=y so that it catches mistakes and
assumptions that your changes violate at runtime....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
