Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47967 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750792AbdFPTYw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Jun 2017 15:24:52 -0400
Date: Fri, 16 Jun 2017 12:24:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfs: Properly retry failed inode items in case of
 error during buffer writeback
Message-ID: <20170616192445.GG5421@birch.djwong.org>
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
Cc: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org

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
> You said you would work on an xfstest for this, how's that going? Otherewise
> a commit log description of how to reproduce would be useful.

I'm curious for an xfstest too, but I think Carlos /did/ tell us how to
reproduce -- create a thinp device, format XFS, fill it up, and try to
unmount.  I don't think there /is/ much of a trace, just xfsaild doing
nothing and a bunch of ail items that are flush locked and stuck that way.

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

Huh?  I thought this series is supposed to be the fix.

--D

> 
>   Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
