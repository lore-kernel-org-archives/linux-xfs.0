Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53592 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751079AbdFTHBI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Jun 2017 03:01:08 -0400
Date: Tue, 20 Jun 2017 09:01:03 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/2] xfs: Properly retry failed inode items in case of
 error during buffer writeback
Message-ID: <20170620070103.amrnv3nalfzohku2@eorzea.usersys.redhat.com>
References: <20170616105445.3314-1-cmaiolino@redhat.com>
 <20170616105445.3314-3-cmaiolino@redhat.com>
 <20170616183510.GC21846@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170616183510.GC21846@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org

Hello Luis.

On Fri, Jun 16, 2017 at 08:35:10PM +0200, Luis R. Rodriguez wrote:
> On Fri, Jun 16, 2017 at 12:54:45PM +0200, Carlos Maiolino wrote:
> > When a buffer has been failed during writeback, the inode items into it
> > are kept flush locked, and are never resubmitted due the flush lock, so,
> > if any buffer fails to be written, the items in AIL are never written to
> > disk and never unlocked.
> > 
> > This causes unmount operation to hang due these items flush locked in AIL,
> 
> What type of hang? If it has occurred in production is there a trace somewhere?
> what does it look like?
> 

No, there isn't any specific trace, the hang can be seen in several different
places, when unmounting the filesystem, it will hang in xfs_ail_push_all_sync(),
but this will be hit even if no unmount is attempted, with items stuck forever
in ail.

I think the easier way to track this is to look at the device stats in sysfs,
and you will see a forever increase in push_ail statistics even with no work
going on in the filesystem.

> You said you would work on an xfstest for this, how's that going? Otherewise
> a commit log description of how to reproduce would be useful.
>

The xfstests is not done yet, and I'm actually not focusing on it right now, I
already have a reproducer, pointed on the beginning of the discussion from this
problem and having this fixed by now is my priority, once the patches are in
shape and accepted, I'll work on the xfstests.

Not to mention that this problem is still possible to occur not only with
inode items, but also with dquot items, which will also be fixed as soon as we
reach a consensus of how to best fix this problem by now. Once the dquot items
fix will use the same infra-structure as the inode items use in this patchset,
and quite the same code, one of the reasons I segmented the buffer resubmission
into a different function that can be used for both item types.


 
> > but this also causes the items in AIL to never be written back, even when
> > the IO device comes back to normal.
> > 
> > I've been testing this patch with a DM-thin device, creating a
> > filesystem larger than the real device.
> > 
> > When writing enough data to fill the DM-thin device, XFS receives ENOSPC
> > errors from the device, and keep spinning on xfsaild (when 'retry
> > forever' configuration is set).
> > 
> > At this point, the filesystem can not be unmounted because of the flush locked
> > items in AIL, but worse, the items in AIL are never retried at all
> > (once xfs_inode_item_push() will skip the items that are flush locked),
> > even if the underlying DM-thin device is expanded to the proper size.
> 
> Jeesh.
> 
> If the above issue is a real hang, shoudl we not consider a sensible stable fix
> to start off with ?
> 

Please take a look at the whole history of this issue, this patchset is supposed
to be the stable fix, that's why one of the reqs was to use xa_lock here, to
change the log_item flags, instead of using atomic ops, making it easier to
backport it to stable kernels, without messing around with atomic ops and field
type changes and yes, this is a real hang problem, which we already received
several reports on this along the time I'm working on it.

Cheers

>   Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
