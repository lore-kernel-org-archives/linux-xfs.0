Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50951 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752870AbdDLXGV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 19:06:21 -0400
Date: Wed, 12 Apr 2017 16:06:12 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: transaction reservations for deleting of shared extents
Message-ID: <20170412230612.GS8502@birch.djwong.org>
References: <20170220072945.GA17608@lst.de>
 <20170221014356.GA5844@birch.djwong.org>
 <20170412135231.GA3891@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170412135231.GA3891@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 12, 2017 at 03:52:31PM +0200, Christoph Hellwig wrote:
> I think the problem is that t_log_res just contains the log reservation
> when the transaction was created.  But each item processed by
> xfs_defer_finish uses up some of it, but in some cases these might
> be different operations and not just more refcount updates, e.g. for
> xfs_itruncate_extents which I see the issues with we mix EFI/EFD
> items with refcount updates.

Hmmm... I suppose you could end up with a heavy load of deferred updates
stemming from the removal of a single extent:

1) Start with one huge extent mapped into a file.
2) Reflink every other block into another file.
3) Delete the first file.  This results in:
   a) Unmap the huge extent.
   b) Schedule removal of the rmap, if applicable.
   c) Schedule a refcount decrease for the huge extent.
   d) Perform the deferred rmap removal.  If we push blocks off the
      AGFL as part of removing rmapbt blocks, queue an EFI.
   e) Perform the deferred refcount decrease:
      For each (singly-)shared block, set the refcount=1 by deleting the
      refcount record.  Every ~150 deletions we free a refcount block
      and queue an EFI.  (If rmap, queue a deferred rmap update too.)
   f) Perform the deferred rmap removals.  If we push blocks off the
      AGFL as part of removing rmapbt blocks, queue an EFI.
   g) Free each shared block by queueing an EFI.
   h) For each EFI, free the extent.

So I think the problem you're seeing here is that just prior to (3g) we
have the most deferred items (EFIs, specifically) attached to this
transaction at any point in the whole operation.  There can be so many
EFIs that we use up the log reservation and blow the ASSERT.

One way to fix this is to unmap a smaller range in (1) so that we don't
blow up at (3g).  Unfortunately, it is hard to guess at (1) just how
many EFIs we might end up queueing, but I think reducing the amount of
file mapping we free in a given step might be the only sane solution.
One could calculate the number of blocks we can free, given the
remaining transaction reservation and assuming the worst case number of
EFIs that could get filed to unmap those blocks, and only __bunmapi that
many blocks, thereby forcing the caller to come back with a fresh
defer_ops for another try.

> I still don't have a good idea how to fix this, though.  One idea
> would be to prevent mixing different items, but I think being able
> to mix them was one of your goals with the defer infrastructure rewrite.

Yes, we have to be able to perform several different types of updates
in one defer_ops so that we can execute CoW remappings atomically.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
