Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:23698 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752772AbdLEXtS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Dec 2017 18:49:18 -0500
Date: Wed, 6 Dec 2017 10:49:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: extfree log recovery and owner (rmapbt) updates
Message-ID: <20171205234915.GY4094@dastard>
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
> of the old rmapbt commits,

Yup, that was my original intent - to deal with log recovery not
knowing who the owner of the extent being freed is as it's not
recorded in the EFI.

IOWs, XFS_RMAP_OWN_UNKNOWN was supposed to match any owner in
the rmapbt record and allow it to be removed instead of throwing a
corruption error because a the owner field didn't match the rmap
extent record we found on lookup.

It seems that this morphed during the refcount updates to the rmapbt
record structure and I didn't catch that during review. i.e. once
cow and unsharing are added into the picture, the rmapbt updates are
no longer a 1:1 mapping with extent freeing....

> but it looks like this codepath skips the
> rmapbt update altogether if oi_owner == XFS_RMAP_OWN_UNKNOWN.

Yup, that looks like a bug at first glance, but I think what we
really need to determine here is whether there is a deferred rmap
update for that extent being freed or not. That will determine what
needs to happen when processing the EFI - if there's a deferred
rmap update, then we don't want to free the rmap record here, but
if there isn't an rmap update, then we need to free it from EFI
context...

> A quick
> test that shuts down the fs immediately after a transaction commits that
> logs an EFI for a freed inode chunk leaves the fs inconsistent after log
> recovery, with a bit of a cryptic message from repair:
> 
>   unknown block state, ag 0, block 24

That would explain the failures I occasionally see from an
fstest whose number I can't recall right now.

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

I'm thinking it depends on whether we've got a deferred RUI for the
extent being freed pending in the recovery list or not...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
