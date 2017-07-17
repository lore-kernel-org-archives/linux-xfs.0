Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38110 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751314AbdGQRsx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Jul 2017 13:48:53 -0400
Date: Mon, 17 Jul 2017 13:48:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Metadata corruption detected at xfs_inode_buf_verify
Message-ID: <20170717174851.GB57771@bfoster.bfoster>
References: <alpine.DEB.2.21.1.1707161018130.22141@trent.utfs.org>
 <alpine.DEB.2.21.1.1707170035440.22141@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1.1707170035440.22141@trent.utfs.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christian Kujau <christian@nerdbynature.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 17, 2017 at 12:47:16AM -0700, Christian Kujau wrote:
> On Sun, 16 Jul 2017, Christian Kujau wrote:
> > so, the disk enclosure attached to my RaspberryPi[0] had "some" kind of 
> > failure last night: one of the disks appears to have some kind of hardware 
> > problem, the other is fine, but the XFS file system cannot be mounted. 
> > Instead of using the RPI to try the repair, I attached the enclosure to an 
> > Intel i7 machine (16 GB RAM) and attempted to mount:
> 
> After a late night chat on #xfs, it seems that the corruption may have 
> happened due to a problem with the storage driver on this RPI and Dave
> commented:
> 
>  | and I'm pretty sure that the USB mass storage interface/driver does not 
>  | pass through cache flushes or support FUA operations.
>  | which would explain why it appears that the inode cluster 
>  | initialisation IO isn't on disk, and it wasn't replayed by log recovery
>  | before inode updates were recovered....
> 
> (Put here so that it can be found in the archives, in case this happens to 
> someone else)
> 
> So, that being said, the now corrupted XFS still cannot be repaired by 
> xfs_repair (compiled from a git checkout two days ago). The full 
> xfs_repair run can be found the in screenlog:
> 
>  http://nerdbynature.de/bits/4.12.0-rc7/screenlog_1.txt
>  The xfs_logprint and xfs_metadump outputs can be provided at request.
> 
> 
> Is this something xfs_repair should be able to fix or is the filesystem
> just too mangled in this case?
> 

Hard to say for sure. I do wonder whether this is related to any of the
issues that Emmanuel ran into in his recent post[1]. Care to post the
metadump somewhere where it can be downloaded? Note that it usually can
be compressed to save upload/download time.

Brian

[1] http://www.spinics.net/lists/linux-xfs/msg08176.html

> Thanks,
> Christian.
> -- 
> BOFH excuse #431:
> 
> Borg implants are failing
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
