Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B16C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Feb 2022 22:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239665AbiBGWDR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Feb 2022 17:03:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiBGWDR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Feb 2022 17:03:17 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A366C061355
        for <linux-xfs@vger.kernel.org>; Mon,  7 Feb 2022 14:03:15 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id j2so44489760ybu.0
        for <linux-xfs@vger.kernel.org>; Mon, 07 Feb 2022 14:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ibUbCfOq6EyjionBVazY+x72axotkytX35q7ezGc8TM=;
        b=pPho8pPLJmfIc/ttxV5IwMl/0OcVhu5wYiypGGkmlHyr6Y7fyF47lt3nxP9QO4KTby
         3/rhhoH7YPhl/w10Wd3Bm44zMuDzESizR1W/gZerXehMa+KEw2R4X1ynEEyYQdJ7x8LN
         VyIHE5SJ7zrXZGPxQxtqibvh2Zu6VlyNps4SX4T30QMtAucCVBqNrvG1Swl/euN/pVXg
         u/ODhU0cLA6/Xv4+CKkDrjxSl9yt75lSOMlWTKTjXCpxsKcKDf4vJS2FN66Qgoiugrh/
         Mvsloz8w4F5q/upyW6Z2+DMRiuLF8tltqQ8syI48bFgrngh8fF1lnQyazJbQd02vd3g2
         HR/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ibUbCfOq6EyjionBVazY+x72axotkytX35q7ezGc8TM=;
        b=uVfwREBVHD6/qp5w9WLXU5SSS8kpMt18dQ+L66uT/0Y7MgtR+S0FQy1237+0NS9J+B
         H9lQAEXwc+orFtbQIEWNorbX1kwMwAhDXpXAxYlYhqXZ3Yj3vD005e3ZdJ/Gn5Lwoths
         vun/61HA45SNk7gyyM4OuDOvJd0bFYFKoqFyTP+2LhpRPQ4+d0u2TAvwaMDEU7JonNhA
         L2qa+jQGkYG9vIcbACyLwfK/P8XbVUJT+sEXQU9FpY6sRf07gKCqCfTnWZzkg9+xXgSm
         pFmYXE5YV+bXM71ZgFXqTivVB0Q0kHo0JWeAEHra9VC67dV14bXRpOnm/UsiMHnisJMZ
         MLFw==
X-Gm-Message-State: AOAM531bLMds1sGTct+En/MjBcA/Hglx6PRjTCibAkj6q2mij7jk166T
        0Gp6xSEaKeHuPxzZa2Awf21/GbErRBCq17He/Zo4ZQ==
X-Google-Smtp-Source: ABdhPJzJpWGff4LbZUyshiceaC/2Gc49gNIgSPP3eU8Dk07O5wBnGKK0wJbioTncaWUstHpKl4+fCwV72dFo5GcWM+M=
X-Received: by 2002:a81:3795:: with SMTP id e143mr2074468ywa.514.1644271394450;
 Mon, 07 Feb 2022 14:03:14 -0800 (PST)
MIME-Version: 1.0
References: <CAA43vkVeMb0SrvLmc8MCU7K8yLUBqHOVk3=JGOi+KDh3zs9Wfw@mail.gmail.com>
 <20220201233312.GX59729@dread.disaster.area>
In-Reply-To: <20220201233312.GX59729@dread.disaster.area>
From:   Sean Caron <scaron@umich.edu>
Date:   Mon, 7 Feb 2022 17:03:03 -0500
Message-ID: <CAA43vkUQ2fb_BEO1oB=bcrsGdcFTxZxyAFUVmLwvkRiobF8EYA@mail.gmail.com>
Subject: Re: XFS disaster recovery
To:     Dave Chinner <david@fromorbit.com>, Sean Caron <scaron@umich.edu>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

OK! With your patch and help on that other thread pertaining to
xfs_metadump I was able to get a full metadata dump of this
filesystem.

I used xfs_mdrestore to set up a sparse image for this volume using my
dumped metadata:

xfs_mdrestore /exports/home/work/md4.metadump /exports/home/work/md4.img

Then set up a loopback device for it and tried to mount.

losetup --show --find /exports/home/work/md4.img
mount /dev/loop0 /mnt

When I do this, I get a "Structure needs cleaning" error and the
following in dmesg:

[523615.874581] XFS (loop0): Corruption warning: Metadata has LSN
(7095:2330880) ahead of current LSN (7095:2328512). Please unmount and
run xfs_repair (>= v4.3) to resolve.
[523615.874637] XFS (loop0): Metadata corruption detected at
xfs_agi_verify+0xef/0x180 [xfs], xfs_agi block 0x10
[523615.874666] XFS (loop0): Unmount and run xfs_repair
[523615.874679] XFS (loop0): First 128 bytes of corrupted metadata buffer:
[523615.874695] 00000000: 58 41 47 49 00 00 00 01 00 00 00 00 0f ff ff
f8  XAGI............
[523615.874713] 00000010: 00 03 ba 40 00 04 ef 7e 00 00 00 02 00 00 00
34  ...@...~.......4
[523615.874732] 00000020: 00 30 09 40 ff ff ff ff ff ff ff ff ff ff ff
ff  .0.@............
[523615.874750] 00000030: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff  ................
[523615.874768] 00000040: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff  ................
[523615.874787] 00000050: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff  ................
[523615.874806] 00000060: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff  ................
[523615.874824] 00000070: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff  ................
[523615.874914] XFS (loop0): metadata I/O error in
"xfs_trans_read_buf_map" at daddr 0x10 len 8 error 117
[523615.874998] XFS (loop0): xfs_imap_lookup: xfs_ialloc_read_agi()
returned error -117, agno 0
[523615.876866] XFS (loop0): Failed to read root inode 0x80, error 117

Seems like the next step is to just run xfs_repair (with or without
log zeroing?) on this image and see what shakes out?

Thanks,

Sean

On Tue, Feb 1, 2022 at 6:33 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Tue, Feb 01, 2022 at 06:07:18PM -0500, Sean Caron wrote:
> > Hi all,
> >
> > Me again with another not-backed-up XFS filesystem that's in a little
> > trouble. Last time I stopped by to discuss my woes, I was told that I
> > could check in here and get some help reading the tea leaves before I
> > do anything drastic so I'm doing that :)
> >
> > Brief backstory: This is a RAID 60 composed of three 18-drive RAID 6
> > strings of 8 TB disk drives, around 460 TB total capacity. Last week
> > we had a disk fail out of the array. We replaced the disk and the
> > recovery hung at around 70%.
> >
> > We power cycled the machine and enclosure and got the recovery to run
> > to completion. Just as it finished up, the same string dropped another
> > drive.
> >
> > We replaced that drive and started recovery again. It got a fair bit
> > into the recovery, then hung just as did the first drive recovery, at
> > around +/- 70%. We power cycled everything again, then started the
> > recovery. As the recovery was running again, a third disk started to
> > throw read errors.
> >
> > At this point, I decided to just stop trying to recover this array so
> > it's up with two disks down but otherwise assembled. I figured I would
> > just try to mount ro,norecovery and try to salvage as much as possible
> > at this point before going any further.
> >
> > Trying to mount ro,norecovery, I am getting an error:
>
> Seeing as you've only lost redundancy at this point in time, this
> will simply result in trying to mount the filesystem in an
> inconsistent state and so you'll see metadata corruptions because
> the log has no be replayed.
>
> > metadata I/O error in "xfs_trans_read_buf_map at daddr ... len 8 error 74
> > Metadata CRC error detected at xfs_agf_read_verify+0xd0/0xf0 [xfs],
> > xfs_agf block ...
> >
> > I ran an xfs_repair -L -n just to see what it would spit out. It
> > completes within 15-20 minutes (which I feel might be a good sign,
> > from my experience, outcomes are inversely proportional to run time),
> > but the output is implying that it would unlink over 100,000 files
> > (I'm not sure how many total files are on the filesystem, in terms of
> > what proportion of loss this would equate to) and it also says:
> >
> > "Inode allocation btrees are too corrupted, skipping phases 6 and 7"
>
> This is expected because 'xfs_repair -n' does not recover the log.
> Hence you're running checks on an inconsistent fs and repair is
> detecting that the inobts are inconsistent so it can't check the
> directory structure connectivity and link counts sanely.
>
> What you want to do here is take a metadump of the filesystem (it's
> an offline operation) and restore it to a an image file on a
> different system (creates a sparse file so just needs to run on a fs
> that supports file sizes > 16TB). You can then mount the image file
> via "mount -o loop <fs.img> <mntpt>", and it run log recovery on the
> image. Then you can unmount it again and see if the resultant
> filesystem image contains any corruption via 'xfs_repair -n'.
>
> If there's no problems found, then the original filesysetm is all
> good an all you need to do is mount it and everythign should be
> there ready for the migration process to non-failing storage.
>
> If there are warnings/repairs needed then you're probably best to
> post the output of 'xfs_reapir -n' so we can review it and determine
> the best course of action from there.
>
> IOWs, do all the diagnosis/triage of the filesytem state on the
> restored metadump images so that we don't risk further damaging the
> real storage. If we screw up a restored filesystem image, no big
> deal, we can just return it to the original state by restoring it
> from the metadump again to try something different.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
