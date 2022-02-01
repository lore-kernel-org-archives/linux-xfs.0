Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CDFBC433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Feb 2022 23:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242908AbiBAXdR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Feb 2022 18:33:17 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:51180 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242901AbiBAXdP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Feb 2022 18:33:15 -0500
Received: from dread.disaster.area (pa49-180-69-7.pa.nsw.optusnet.com.au [49.180.69.7])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8C67162C1D5;
        Wed,  2 Feb 2022 10:33:14 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nF2e8-006yvG-RF; Wed, 02 Feb 2022 10:33:12 +1100
Date:   Wed, 2 Feb 2022 10:33:12 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Sean Caron <scaron@umich.edu>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS disaster recovery
Message-ID: <20220201233312.GX59729@dread.disaster.area>
References: <CAA43vkVeMb0SrvLmc8MCU7K8yLUBqHOVk3=JGOi+KDh3zs9Wfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA43vkVeMb0SrvLmc8MCU7K8yLUBqHOVk3=JGOi+KDh3zs9Wfw@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61f9c33a
        a=NB+Ng1P8A7U24Uo7qoRq4Q==:117 a=NB+Ng1P8A7U24Uo7qoRq4Q==:17
        a=kj9zAlcOel0A:10 a=oGFeUVbbRNcA:10 a=7-415B0cAAAA:8
        a=czFGi23Ckiix3EVKEEsA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 01, 2022 at 06:07:18PM -0500, Sean Caron wrote:
> Hi all,
> 
> Me again with another not-backed-up XFS filesystem that's in a little
> trouble. Last time I stopped by to discuss my woes, I was told that I
> could check in here and get some help reading the tea leaves before I
> do anything drastic so I'm doing that :)
> 
> Brief backstory: This is a RAID 60 composed of three 18-drive RAID 6
> strings of 8 TB disk drives, around 460 TB total capacity. Last week
> we had a disk fail out of the array. We replaced the disk and the
> recovery hung at around 70%.
> 
> We power cycled the machine and enclosure and got the recovery to run
> to completion. Just as it finished up, the same string dropped another
> drive.
> 
> We replaced that drive and started recovery again. It got a fair bit
> into the recovery, then hung just as did the first drive recovery, at
> around +/- 70%. We power cycled everything again, then started the
> recovery. As the recovery was running again, a third disk started to
> throw read errors.
> 
> At this point, I decided to just stop trying to recover this array so
> it's up with two disks down but otherwise assembled. I figured I would
> just try to mount ro,norecovery and try to salvage as much as possible
> at this point before going any further.
> 
> Trying to mount ro,norecovery, I am getting an error:

Seeing as you've only lost redundancy at this point in time, this
will simply result in trying to mount the filesystem in an
inconsistent state and so you'll see metadata corruptions because
the log has no be replayed.

> metadata I/O error in "xfs_trans_read_buf_map at daddr ... len 8 error 74
> Metadata CRC error detected at xfs_agf_read_verify+0xd0/0xf0 [xfs],
> xfs_agf block ...
> 
> I ran an xfs_repair -L -n just to see what it would spit out. It
> completes within 15-20 minutes (which I feel might be a good sign,
> from my experience, outcomes are inversely proportional to run time),
> but the output is implying that it would unlink over 100,000 files
> (I'm not sure how many total files are on the filesystem, in terms of
> what proportion of loss this would equate to) and it also says:
> 
> "Inode allocation btrees are too corrupted, skipping phases 6 and 7"

This is expected because 'xfs_repair -n' does not recover the log.
Hence you're running checks on an inconsistent fs and repair is
detecting that the inobts are inconsistent so it can't check the
directory structure connectivity and link counts sanely.

What you want to do here is take a metadump of the filesystem (it's
an offline operation) and restore it to a an image file on a
different system (creates a sparse file so just needs to run on a fs
that supports file sizes > 16TB). You can then mount the image file
via "mount -o loop <fs.img> <mntpt>", and it run log recovery on the
image. Then you can unmount it again and see if the resultant
filesystem image contains any corruption via 'xfs_repair -n'.

If there's no problems found, then the original filesysetm is all
good an all you need to do is mount it and everythign should be
there ready for the migration process to non-failing storage.

If there are warnings/repairs needed then you're probably best to
post the output of 'xfs_reapir -n' so we can review it and determine
the best course of action from there.

IOWs, do all the diagnosis/triage of the filesytem state on the
restored metadump images so that we don't risk further damaging the
real storage. If we screw up a restored filesystem image, no big
deal, we can just return it to the original state by restoring it
from the metadump again to try something different.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
