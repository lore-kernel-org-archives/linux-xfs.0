Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:10574 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751924AbdHCWfl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2017 18:35:41 -0400
Date: Fri, 4 Aug 2017 08:35:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Stop searching for free slots in an inode chunk when
 there are none
Message-ID: <20170803223538.GB21024@dastard>
References: <20170803151915.7861-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170803151915.7861-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Aug 03, 2017 at 05:19:15PM +0200, Carlos Maiolino wrote:
> In a filesystem without finobt, the Space manager selects an AG to alloc a new
> inode, where xfs_dialloc_ag_inobt() will search the AG for the free slot chunk.
> 
> When the new inode is in the samge AG as its parent, the btree will be
> searched starting on the parent's record, and then retried from the top
> if no slot is available beyond the parent's record.
> 
> To exit this loop though, xfs_dialloc_ag_inobt(), relies on the fact that the
> btree must have a free slot available, once its callers relied on the
> agi->freecount when deciding how/where to allocate this new inode.
> 
> In the case when the agi->freecount is corrupted, showing available
> inodes in an AG, when in fact there is none, this becomes an infinite
> loop.
> 
> Add a way to stop the loop when a free slot is not found in the btree,
> making the function to fall into the whole AG scan which will then, be
> able to detect the corruption and shut the filesystem down.

That doesn't sound quite right. The initial scan and the restart
loop are both limited to scanning search_distance records - we never
search the entire tree except when it's really small (i..e less than
10-20 records (640-1280 inodes) depending on balance). If the
pagino record to end of btree distance in both directions is shorter
than the search distance for a given loop (i.e. less than 10 records
from pagino to end-of-btree) then that is the only time a corrupted
agi->freecount can cause this problem.

IOWs, on production systems where there's more than a few hundred
inodes (i.e. the vast majority of installations) a corrupted
agi->freecount won't lead to a endless loop because search_distance
will terminate the retry loop and we'll allocate a new inode.

To tell the truth, I'd much rather we just use the search distance
to prevent endless looping than add a second method of limiting
the search loop. i.e. don't reset search_distance when we restart
the search loop at pagino.  That means even for small trees (<
search_distance * 2 records) we'll retry when we get to the end of
tree, but we'll still break out of the loop and allocate new inodes
as soon as we hit the search distance limit.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
