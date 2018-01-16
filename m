Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58434 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750885AbeAPNxv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 08:53:51 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w0GDrdoB126336
        for <linux-xfs@vger.kernel.org>; Tue, 16 Jan 2018 08:53:50 -0500
Received: from e06smtp11.uk.ibm.com (e06smtp11.uk.ibm.com [195.75.94.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2fhguxwg50-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 16 Jan 2018 08:53:50 -0500
Received: from localhost
        by e06smtp11.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 16 Jan 2018 13:53:46 -0000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] xfs: Fix "use after free" of intent items
Date: Tue, 16 Jan 2018 19:25:02 +0530
In-Reply-To: <20180112150223.GB32050@bfoster.bfoster>
References: <20180111125223.10727-1-chandan@linux.vnet.ibm.com> <20180112150223.GB32050@bfoster.bfoster>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <10110382.0xkuEa3Mc5@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, hch@infradead.org, darrick.wong@oracle.com

On Friday, January 12, 2018 8:32:24 PM IST Brian Foster wrote:
> On Thu, Jan 11, 2018 at 06:22:23PM +0530, Chandan Rajendra wrote:
> > generic/388 can cause the following "use after free" error to occur,
> > 
> >  =============================================================================
> >  BUG xfs_efi_item (Not tainted): Poison overwritten
> >  -----------------------------------------------------------------------------
> > 
> >  Disabling lock debugging due to kernel taint
> >  INFO: 0x00000000292c4bd4-0x00000000292c4bd4. First byte 0x6a instead of 0x6b
> >  INFO: Allocated in .kmem_zone_alloc+0xcc/0x190 age=79 cpu=0 pid=12436
> >  	.__slab_alloc+0x54/0x80
> >  	.kmem_cache_alloc+0x124/0x350
> >  	.kmem_zone_alloc+0xcc/0x190
> >  	.xfs_efi_init+0x48/0xf0
> >  	.xfs_extent_free_create_intent+0x40/0x130
> >  	.xfs_defer_intake_work+0x74/0x1e0
> >  	.xfs_defer_finish+0xac/0x5c0
> >  	.xfs_itruncate_extents+0x170/0x590
> >  	.xfs_inactive_truncate+0xcc/0x170
> >  	.xfs_inactive+0x1d8/0x2f0
> >  	.xfs_fs_destroy_inode+0xe4/0x3d0
> >  	.destroy_inode+0x68/0xb0
> >  	.do_unlinkat+0x1e8/0x390
> >  	system_call+0x58/0x6c
> >  INFO: Freed in .xfs_efi_item_free+0x44/0x80 age=79 cpu=0 pid=12436
> >  	.kmem_cache_free+0x120/0x2b0
> >  	.xfs_efi_item_free+0x44/0x80
> >  	.xfs_trans_free_items+0xd4/0x130
> >  	.__xfs_trans_commit+0xd0/0x350
> >  	.xfs_trans_roll+0x4c/0x90
> >  	.xfs_defer_trans_roll+0xa4/0x2b0
> >  	.xfs_defer_finish+0xb8/0x5c0
> >  	.xfs_itruncate_extents+0x170/0x590
> >  	.xfs_inactive_truncate+0xcc/0x170
> >  	.xfs_inactive+0x1d8/0x2f0
> >  	.xfs_fs_destroy_inode+0xe4/0x3d0
> >  	.destroy_inode+0x68/0xb0
> >  	.do_unlinkat+0x1e8/0x390
> >  	system_call+0x58/0x6c
> > 
> > This happens due to the following interaction,
> > 1. xfs_defer_finish() creates "extent free" intent item and adds it to the
> >    list at xfs_trans->t_items.
> > 2. xfs_defer_trans_roll() invokes __xfs_trans_commit(). Here, if the
> >    XFS_MOUNT_FS_SHUTDOWN flag is set, we invoke io_unlock() operation of the
> >    corresponding log item. For "extent free" log items xfs_efi_item_unlock()
> >    gets invoked which frees the xfs_efi_log_item.
> > 3. xfs_defer_trans_roll() then invokes xfs_defer_trans_abort(). Since the
> >    xfs_defer_pending->dfp_intent is still set to the "extent free" intent
> >    item, we invoke xfs_extent_free_abort_intent(). This accesses the
> >    previously freed xfs_efi_log_item to decrement the ref count.
> > 
> > This commit fixes the bug by changing xfs_efi_item_unlock() to invoke
> > xfs_efi_release() instead of xfs_efi_item_free(). The xfs_efi_log_item gets
> > freed when xfs_extent_free_abort_intent() invokes xfs_efi_release() once again
> > i.e. its refcount becomes zero and hence xfs_efi_item_free() is invoked.
> > 
> 
> Interesting.. trying to refamiliarize myself with the expected reference
> counting rules here, I see that this goes back to the old
> xfs_bmap_finish() mechanism. That guy would grab an EFI, log it and then
> attempt to roll/commit the transaction. IIRC, the direct release covers
> the case where that tx commit fails. That is essentially equivalent to a
> tx cancel in this example, so the tx is freed and xfs_bmap_finish() is
> done (returns with an error). The ->iop_unlock() frees the EFI in this
> case explicitly because 1.) the refcount is initialized to 2, one for
> the log and one for the EFD and 2.) the EFD is never created in this
> situation.
> 
> Given that, I suspect this code was correct with the bmap_finish() code
> and became a problem sometime later. Have you done any investigation to
> confirm/deny whether this is a regression since v4.7 or so?

You are right. The code was working fine with v4.6.  IMHO, this was due the
"committed" argument that was passed to __xfs_trans_roll(). This 
argument tracked if the log items were committed to the CIL. 

If __xfs_trans_roll() did return an error and "committed" was set to  true,
we just release one of the refcounts of the efi, since the efd will never
be created. The final refcount will be released when the EFI is added
to the AIL.

If __xfs_trans_roll() did return an error and "committed" was set to false,
we end up freeing the efi via ->iop_unlock() function and no action
is taken in xfs_bmap_finish().  However, with the present code
xfs_defer_trans_roll() ends up unconditionally (well almost; It does
check for the presence of a non-NULL pointer at 
xfs_defer_pending->dfp_intent) invoking xfs_extent_free_abort_intent(),
which access the freed memory.

I am working on a new patch for fixing this. Thanks for guidance.

-- 
chandan

