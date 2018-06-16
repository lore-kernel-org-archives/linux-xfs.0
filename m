Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:22540 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753724AbeFPAN1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Jun 2018 20:13:27 -0400
Date: Sat, 16 Jun 2018 10:13:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] libxfs: detect zoned disks and prevent their raw use
Message-ID: <20180616001314.GS10363@dastard>
References: <20180615205011.7728-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180615205011.7728-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org, snitzer@redhat.com, hare@suse.de, axboe@kernel.dk, mwilck@suse.com, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

On Fri, Jun 15, 2018 at 01:50:11PM -0700, Luis R. Rodriguez wrote:
> Using raw zoned disks by filesystems requires special handling, only
> f2fs currently supports this. All other filesystems do not support
> dealing with zoned disks directly.
> 
> As such using raw zoned disks is not supported by XFS, to use them you
> need to use dm-zoned-tools, format them with dzadm, set the scheduler to
> deadline, and then setup a dmsetup with zoned type, and somehow set
> this up on every boot to live a semi-happy life for now.
> 
> Even if you use dmsetup on every boot, the zoned disk is still exposed,
> and a user may still think they have to run mkfs.xfs on it instead
> of the /dev/mapper/ disk, and then mount it by mistake.
> 
> In either case you may seem to believe your disk works and only eventually
> end up with alignmet issues and perhaps lose you data. For instance:
> 
> [10869.959501] device-mapper: zoned reclaim: (sda): Align zone 865 wp 28349 to 30842 (wp+2493) blocks failed -5
> [10870.014488] sd 0:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [10870.016137] sd 0:0:0:0: [sda] tag#0 Sense Key : Illegal Request [current]
> [10870.017696] sd 0:0:0:0: [sda] tag#0 Add. Sense: Unaligned write command
> 
> We have to prevent these mistakes by avoiding mkfs.xfs use on zoned disks.
> 
> Note that this not enough yet, if users are on old AHCI controllers,
> the disks may not be detected as zoned. More work through udev may be
> required to detect this situation old old parent PCI IDs for zoned
> disks, and then prevent their use somehow.
> 
> If you are stuck on using XFS there a udev rule out there [0], this is
> far from perfect, and not fully what we want done upstream on Linux
> distributions long term but it should at least help developers for now
> enjoy their shiny big fat zoned disks with XFS.
> 
> This check should help avoid having folks shoot themselves in the foot
> for now with zoned disks. If you make the mistake to use mkfs.xfs
> on a zoned disk, you will now get:
> 
>  # mkfs.xfs /dev/sda
> /dev/sda: zoned disk detected, refer to dm-zoned-tools for how to use with XFS

Shouldn't this code be put in libblkid() so it's available to all
filesystem tools, not just XFS?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
