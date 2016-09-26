Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29181 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933166AbcIZVw4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Sep 2016 17:52:56 -0400
Date: Mon, 26 Sep 2016 14:52:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 58/71] xfs: garbage collect old cowextsz reservations
Message-ID: <20160926215209.GE14092@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
 <147216829394.867.16281333542262043955.stgit@birch.djwong.org>
 <20160924194234.GA1878@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160924194234.GA1878@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Sat, Sep 24, 2016 at 12:42:34PM -0700, Christoph Hellwig wrote:
> On Thu, Aug 25, 2016 at 04:38:14PM -0700, Darrick J. Wong wrote:
> > Trim CoW reservations made on behalf of a cowextsz hint if they get too
> > old or we run low on quota, so long as we don't have dirty data awaiting
> > writeback or directio operations in progress.
> 
> FYI, at least in your latest tree we only ever seem to set
> xfs_inode_set_cowblocks_tag in xfs_swap_extents, so this effectively
> isn't used during normal fs usage.

The tag should be set at the end of __xfs_iomap_write_delay if we're
creating a DA reservation in the CoW fork. 

> Also any reason we can't use the same infrastructure as our normal
> speculative preallocation here?

The two functions /could/ be merged but I'm hesitant to combine them
because they run as different workqueue items.

Setting speculative_cow_prealloc_lifetime to a (much) higher value than
speculative_prealloc_lifetime has been useful for combatting CoW
fragmentation on VM hosts where the VMs experience bursty write
behaviors and we can keep the utilization ratios low enough that we
don't start to run out of space.  IOWs, it benefits us to keep the CoW
fork reservations around for as long as we can unless we run out of
blocks or hit inode reclaim.

Regular speculative preallocations, otoh, can be removed quicker since
file size changes don't happen much.

--D
