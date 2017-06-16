Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53168 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750792AbdFPSfM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Jun 2017 14:35:12 -0400
Date: Fri, 16 Jun 2017 20:35:10 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 2/2] xfs: Properly retry failed inode items in case of
 error during buffer writeback
Message-ID: <20170616183510.GC21846@wotan.suse.de>
References: <20170616105445.3314-1-cmaiolino@redhat.com>
 <20170616105445.3314-3-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170616105445.3314-3-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jun 16, 2017 at 12:54:45PM +0200, Carlos Maiolino wrote:
> When a buffer has been failed during writeback, the inode items into it
> are kept flush locked, and are never resubmitted due the flush lock, so,
> if any buffer fails to be written, the items in AIL are never written to
> disk and never unlocked.
> 
> This causes unmount operation to hang due these items flush locked in AIL,

What type of hang? If it has occurred in production is there a trace somewhere?
what does it look like?

You said you would work on an xfstest for this, how's that going? Otherewise
a commit log description of how to reproduce would be useful.

> but this also causes the items in AIL to never be written back, even when
> the IO device comes back to normal.
> 
> I've been testing this patch with a DM-thin device, creating a
> filesystem larger than the real device.
> 
> When writing enough data to fill the DM-thin device, XFS receives ENOSPC
> errors from the device, and keep spinning on xfsaild (when 'retry
> forever' configuration is set).
> 
> At this point, the filesystem can not be unmounted because of the flush locked
> items in AIL, but worse, the items in AIL are never retried at all
> (once xfs_inode_item_push() will skip the items that are flush locked),
> even if the underlying DM-thin device is expanded to the proper size.

Jeesh.

If the above issue is a real hang, shoudl we not consider a sensible stable fix
to start off with ?

  Luis
