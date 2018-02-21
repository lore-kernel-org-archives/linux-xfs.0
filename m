Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:14753 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751576AbeBUVFz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Feb 2018 16:05:55 -0500
Date: Thu, 22 Feb 2018 08:04:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2 2/2] xfs: Fix "use after free" of intent items
Message-ID: <20180221210404.GF7000@dastard>
References: <20180221022826.7020-1-chandan@linux.vnet.ibm.com>
 <20180221022826.7020-2-chandan@linux.vnet.ibm.com>
 <20180221040109.GE7000@dastard>
 <18759094.m032Vjinrq@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18759094.m032Vjinrq@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-xfs@vger.kernel.org, hch@infradead.org, darrick.wong@oracle.com, bfoster@redhat.com

On Wed, Feb 21, 2018 at 11:15:22AM +0530, Chandan Rajendra wrote:
> On Wednesday, February 21, 2018 9:31:09 AM IST Dave Chinner wrote:
> > On Wed, Feb 21, 2018 at 07:58:26AM +0530, Chandan Rajendra wrote:
> > > generic/388 can cause the following "use after free" error to occur,
> > > 
> > >  =============================================================================
> > >  BUG xfs_efi_item (Not tainted): Poison overwritten
> > >  -----------------------------------------------------------------------------
> > > 
> > >  Disabling lock debugging due to kernel taint
> > >  INFO: 0x00000000292c4bd4-0x00000000292c4bd4. First byte 0x6a instead of 0x6b
> > >  INFO: Allocated in .kmem_zone_alloc+0xcc/0x190 age=79 cpu=0 pid=12436
> > >         .__slab_alloc+0x54/0x80
> > >         .kmem_cache_alloc+0x124/0x350
> > >         .kmem_zone_alloc+0xcc/0x190
> > >         .xfs_efi_init+0x48/0xf0
> > >         .xfs_extent_free_create_intent+0x40/0x130
> > >         .xfs_defer_intake_work+0x74/0x1e0
> > >         .xfs_defer_finish+0xac/0x5c0
> > >         .xfs_itruncate_extents+0x170/0x590
> > >         .xfs_inactive_truncate+0xcc/0x170
> > >         .xfs_inactive+0x1d8/0x2f0
> > >         .xfs_fs_destroy_inode+0xe4/0x3d0
> > >         .destroy_inode+0x68/0xb0
> > >         .do_unlinkat+0x1e8/0x390
> > >         system_call+0x58/0x6c
> > >  INFO: Freed in .xfs_efi_item_free+0x44/0x80 age=79 cpu=0 pid=12436
> > >         .kmem_cache_free+0x120/0x2b0
> > >         .xfs_efi_item_free+0x44/0x80
> > >         .xfs_trans_free_items+0xd4/0x130
> > >         .__xfs_trans_commit+0xd0/0x350
> > >         .xfs_trans_roll+0x4c/0x90
> > >         .xfs_defer_trans_roll+0xa4/0x2b0
> > >         .xfs_defer_finish+0xb8/0x5c0
> > >         .xfs_itruncate_extents+0x170/0x590
> > >         .xfs_inactive_truncate+0xcc/0x170
> > >         .xfs_inactive+0x1d8/0x2f0
> > >         .xfs_fs_destroy_inode+0xe4/0x3d0
> > >         .destroy_inode+0x68/0xb0
> > >         .do_unlinkat+0x1e8/0x390
> > >         system_call+0x58/0x6c
> > > 
> > > This happens due to the following interaction,
> > > 1. xfs_defer_finish() creates "extent free" intent item and adds it to the
> > >    per-transction list of log items.
> > > 2. xfs_defer_trans_roll() invokes __xfs_trans_commit(). Here, if the
> > >    XFS_MOUNT_FS_SHUTDOWN flag is set, we invoke io_unlock() operation
> > >    for each of the log items in the per-transction list. For "extent
> > >    free" log items xfs_efi_item_unlock() gets invoked which then frees
> > >    the xfs_efi_log_item.
> > 
> > Isn't this the problem? i.e. it's freeing the EFI item because the
> > abort flag is set, but there are still other references to it? Isn't
> > this wrong now that we have a cleanup function that will free the
> > EFI is the commit fails? i.e: this ....
> > 
> > > 3. xfs_defer_trans_roll() then invokes xfs_defer_trans_abort(). Since the
> > >    xfs_defer_pending->dfp_intent is still set to the "extent free" intent
> > >    item, we invoke xfs_extent_free_abort_intent(). This accesses the
> > >    previously freed xfs_efi_log_item to decrement the ref count.
> > 
> > ... will free the EFI correctly on transaction commit failure and so
> > we should be able to remove the "free immediately" hack from the
> > iop_unlock() code that we used to need because there was no external
> > reference that could free the EFI on commit failure....
> 
> The EFI log item would have its ref count initialized to 2 (One for the
> CIL/AIL and one for EFD).

And that's part of what has always been wrong with this code - it
takes references for things that don't really have references yet,
instead of taking them when the EFI is actually referenced. Hence we
have to hack around that with things like ignoring the reference
count when we get an abort signal, because we haven't reference
counted the object properly.

> In the "use after free" case the EFI was not
> committed to the CIL. At this point, we don't have any entity owning a
> reference to the log item since the EFI was not committed to the CIL nor was
> the EFD created. Hence IMHO, freeing the log item is the right approach.

No, we clearly have a reference - the deferops structure has a
reference to it. If it didn't have a reference, then we wouldn't
have a use after free situation....

> Also, the cleanup function (i.e. xfs_extent_free_abort_intent()) would
> decrement the ref count by 1 i.e. Its refcount would go from the initial value
> of 2 to 1. Hence the cleanup function won't free the EFI log item causing a
> memory leak.

No, then the xfs_extent_free_abort_intent() call releases it,
dropping the remaining reference that was intended for the EFD
which, because we aborted, will never take over control of that
reference.

i.e. the two references that are created at initialisation are for
the EFI itself as it passes through the CIL and journal commit, and
the second reference is used by the defer_ops it is attached to and
then handed to the EFD for it's pass through the CIL and journal
commit.

If we never commit the EFI, then we need to release that reference
(on abort), and then we need to clean up the extra reference that is
destined for the EFD which is held by the deferops. That's done by
xfs_extent_free_abort_intent().

And I'm guessing that we need to make sure the same fix goes through
all the other items that are used as deferops intents that were
modeled on the EFI/EFD infrastructure, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
