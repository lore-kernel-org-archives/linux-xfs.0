Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:58385 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753178AbdLEXc6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Dec 2017 18:32:58 -0500
Date: Tue, 5 Dec 2017 15:32:53 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: extfree log recovery and owner (rmapbt) updates
Message-ID: <20171205233253.GF19219@magnolia>
References: <20171205185524.GB42206@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171205185524.GB42206@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Dec 05, 2017 at 01:55:24PM -0500, Brian Foster wrote:
> Hi,
> 
> I've been playing around with deferring AGFL block frees and noticed
> something funky going on with xfs_bmap_add_free() and owner info. We
> pass the extent owner info to xfs_bmap_add_free() in various places to
> transfer this info to the deferred free processing context.
> Subsequently, xfs_trans_free_extent() -> ... -> xfs_free_ag_extent()
> uses the owner info to remove the rmapbt entry associated with the
> extent. The rmapbt update occurs at the time the extent is freed.
> 
> If the system crashes immediately after the initial transaction commits,
> however, EFI recovery calls xfs_trans_free_extent() with an "unknown"
> owner. I see a reference to using a "wildcard" in this context in some
> of the old rmapbt commits, but it looks like this codepath skips the
> rmapbt update altogether if oi_owner == XFS_RMAP_OWN_UNKNOWN. A quick
> test that shuts down the fs immediately after a transaction commits that
> logs an EFI for a freed inode chunk leaves the fs inconsistent after log
> recovery, with a bit of a cryptic message from repair:
> 
>   unknown block state, ag 0, block 24
> 
> It does look like the associated rmapbt entry still exists in the tree
> even though the extent has been freed (from xfs_db -c fsmap):
> 
> 5: 0/24 len 8 owner -7 offset 0 bmbt 0 attrfork 0 extflag 0
> 
> So what is supposed to be going on here? Should the rmapbt entry be
> removed unconditionally during recovery, or should a separate rmapbt
> update item be deferred (as in the bunmapi case, for example) rather
> than passing oinfo along with the TYPE_FREE deferred item? Or something
> else entirely..?

Ooops, this whole thing is kind of a mess... so right now we have two
mechanisms to modify an rmap -- xfs_rmap_{map,unmap,alloc,free}_extent,
which uses the deferred ops mechanism; or xfs_rmap_{alloc,free}, which
makes the change directly in the current transaction.  The first is
used in the bmapping code for file blocks, and the second are used
everywhere else, particularly if we aren't set up for a transaction
roll, like when we're doing non-bmapi allocations.

So the simple fix to this is that we fix xfs_free_extent and
xfs_rmap_unmap so that OWN_UNKNOWN truly is a wildcard "remove rmap,
don't care who owns it" operation.  So long as the wildcard operation
comes after any other attempt to remove the rmap, this will be fine.

Note that xfs_bmap_add_free passes owner info into the in-core EFI,
which means that freeing an extent can also remove the rmap.  For
operations where we explicitly free the rmap via deferred ops (bmapi and
cow) we don't want this, so we need to be able to pass a NULL owner info
to xfs_bmap_add_free.  The EFI can record this as an OWN_NULL owner and
skip freeing the rmap, though this is potentially fraught because log
recovery won't know this and will try the wildcard rmap deletion anyway,
exposing another bug.

When we're cleaning up CoW extents, we create a CUI to remove the CoW
extent from the refcountbt and then create an EFI to free the extent.
The CUI finish routine queues an RUI to delete the rmap, which is then
placed after the EFI.  CUI -> EFI -> RUI, which is the wrong order.
This causes a double-free of the rmap, first with the wildcard and again
with OWN_COW, and the OWN_COW blows asserts.  So, that piece has to be
rearranged to log CUI -> RUI -> EFI.

I'll send an RFC patch as a reply to this one...

---

The other solution, of course, is to separate rmap and allocation
completely -- every allocation requires a dfops structure, and the
deferred rmaps must be queued directly by whomever calls the allocator.
This has the disadvantage that now everything in the allocation path is
a deferred op, whereas right now we can pack some of those into a single
transaction.

--D

> Brian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
