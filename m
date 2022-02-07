Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B67BAC433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Feb 2022 22:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236354AbiBGWd5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Feb 2022 17:33:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234065AbiBGWd5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Feb 2022 17:33:57 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 094ACC061355
        for <linux-xfs@vger.kernel.org>; Mon,  7 Feb 2022 14:33:55 -0800 (PST)
Received: from dread.disaster.area (pa49-180-69-7.pa.nsw.optusnet.com.au [49.180.69.7])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id CDF5210C7938;
        Tue,  8 Feb 2022 09:33:54 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nHCa1-009KUK-0P; Tue, 08 Feb 2022 09:33:53 +1100
Date:   Tue, 8 Feb 2022 09:33:52 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Sean Caron <scaron@umich.edu>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS disaster recovery
Message-ID: <20220207223352.GG59729@dread.disaster.area>
References: <CAA43vkVeMb0SrvLmc8MCU7K8yLUBqHOVk3=JGOi+KDh3zs9Wfw@mail.gmail.com>
 <20220201233312.GX59729@dread.disaster.area>
 <CAA43vkUQ2fb_BEO1oB=bcrsGdcFTxZxyAFUVmLwvkRiobF8EYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA43vkUQ2fb_BEO1oB=bcrsGdcFTxZxyAFUVmLwvkRiobF8EYA@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62019e53
        a=NB+Ng1P8A7U24Uo7qoRq4Q==:117 a=NB+Ng1P8A7U24Uo7qoRq4Q==:17
        a=kj9zAlcOel0A:10 a=oGFeUVbbRNcA:10 a=7-415B0cAAAA:8
        a=jpeW6z9rN1Rjkf2ewFgA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 07, 2022 at 05:03:03PM -0500, Sean Caron wrote:
> Hi Dave,
> 
> OK! With your patch and help on that other thread pertaining to
> xfs_metadump I was able to get a full metadata dump of this
> filesystem.
> 
> I used xfs_mdrestore to set up a sparse image for this volume using my
> dumped metadata:
> 
> xfs_mdrestore /exports/home/work/md4.metadump /exports/home/work/md4.img
> 
> Then set up a loopback device for it and tried to mount.
> 
> losetup --show --find /exports/home/work/md4.img
> mount /dev/loop0 /mnt
> 
> When I do this, I get a "Structure needs cleaning" error and the
> following in dmesg:
> 
> [523615.874581] XFS (loop0): Corruption warning: Metadata has LSN
> (7095:2330880) ahead of current LSN (7095:2328512). Please unmount and
> run xfs_repair (>= v4.3) to resolve.
> [523615.874637] XFS (loop0): Metadata corruption detected at
> xfs_agi_verify+0xef/0x180 [xfs], xfs_agi block 0x10
> [523615.874666] XFS (loop0): Unmount and run xfs_repair
> [523615.874679] XFS (loop0): First 128 bytes of corrupted metadata buffer:
> [523615.874695] 00000000: 58 41 47 49 00 00 00 01 00 00 00 00 0f ff ff
> f8  XAGI............
> [523615.874713] 00000010: 00 03 ba 40 00 04 ef 7e 00 00 00 02 00 00 00
> 34  ...@...~.......4
> [523615.874732] 00000020: 00 30 09 40 ff ff ff ff ff ff ff ff ff ff ff
> ff  .0.@............
> [523615.874750] 00000030: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff  ................
> [523615.874768] 00000040: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff  ................
> [523615.874787] 00000050: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff  ................
> [523615.874806] 00000060: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff  ................
> [523615.874824] 00000070: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff  ................
> [523615.874914] XFS (loop0): metadata I/O error in
> "xfs_trans_read_buf_map" at daddr 0x10 len 8 error 117
> [523615.874998] XFS (loop0): xfs_imap_lookup: xfs_ialloc_read_agi()
> returned error -117, agno 0
> [523615.876866] XFS (loop0): Failed to read root inode 0x80, error 117

Hmmm - I think this is after log recovery. The nature of the error
(metadata LSN a few blocks larger than the current recovered LSN)
implies that part of the log was lost during device failure/recovery
and hence not recovered when mounting the filesystem.

> Seems like the next step is to just run xfs_repair (with or without
> log zeroing?) on this image and see what shakes out?

Yup.

You may be able to run it on the image file without log zeroing
after the failed mount if there were no pending intents that needed
replay.  But it doesn't matter if you do zero the log at this point,
as it's already replayed everything it can replay back into the
filesystem and it will be as consistent as it's going to get.

Regardless, you are still likely to get a bunch of "unlinked but not
freed" inode warnings and inconsistent free space because the mount
failed between the initial recovery phase and the final recovery
phase that runs intent replay and processes unlinked inodes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
