Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA51EC433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Feb 2022 01:20:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbiBBBU7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Feb 2022 20:20:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbiBBBU6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Feb 2022 20:20:58 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C05DC061714
        for <linux-xfs@vger.kernel.org>; Tue,  1 Feb 2022 17:20:58 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id k31so56402552ybj.4
        for <linux-xfs@vger.kernel.org>; Tue, 01 Feb 2022 17:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HIAuMwdWamheRYzDrbreyeK51p+bHxzFHK1YQ0isf84=;
        b=acG6s1sDf8AP7b61TUy3UVPWxNFmu4mZ6oW0ZYTiZRhd9s1dBjxWwkWcm1HI57CJve
         cCJjuoBtJ1QXf5E2va5ouGiPPnTm5IkjBR+48SfCER1SfrgWONIFCtszper9ndOHXmaI
         bolYN8BEUySVnJ+fufO+JnLjgLEBHSoSq4as77RRX4Eca2/kfKz5wcUH0ottWtSROxKn
         i+1kRRBVMHgmi7VLWFBDazxytnuGkp7iaBzxk4JHJhj1BnwbwnLXbM1x0Pp62WZGabKU
         du1akVPO0fmAbmoG9Rr353A9SphPIinfIQfAyMJxmXXqTYLiljreB08I59kcUiTM05H/
         sZiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HIAuMwdWamheRYzDrbreyeK51p+bHxzFHK1YQ0isf84=;
        b=MVwAnBnxspXQG2ajg/Sq0hoE3NTVndpWkyWck9F7WO0UgTpp2r6OH53xkgrbd4FWD8
         3NPhHgsI3k9/5roeHBXM1g0Wpny62u7XZHfm+YAH7DM6waIpnu96IUJOWt5pEOECNwZI
         U4wUy0hnGxLFdCy1VNn4PMOZcxHwlPIiIWHAArcGnE3ev7xqI7+xkpXDScx4eMogNDmt
         I0ZXozU2Bz69pJbyPOtoL78jXvvdPAhbuk5p0yFcPDT6Z49jiAPS/NMN9/DaP5oGi3Nd
         7pTwLdvu760tZE8uoQU5qEGJD+r1ymV0sDAXwzoVnz3qQ+Fd32bvI15A/tpy5pgtqqkk
         jkbQ==
X-Gm-Message-State: AOAM533hvAvvcqZep0s7RofE+hh8Rtm0M6MnET2anqEriFtu8sLU36ub
        B75QBgzSpQ57UbS52FLRn/0ofyWO8byaDM91Et6KSVvUm10=
X-Google-Smtp-Source: ABdhPJyI9anqulVJ+U23AJ+gaBtstbh8ZT3B76Eb49UcpiFOmwbW05D0eHuIBRr4atWN7uUOAgwwuEU0HzIah8KwKlI=
X-Received: by 2002:a05:6902:102f:: with SMTP id x15mr36810157ybt.413.1643764857164;
 Tue, 01 Feb 2022 17:20:57 -0800 (PST)
MIME-Version: 1.0
References: <CAA43vkVeMb0SrvLmc8MCU7K8yLUBqHOVk3=JGOi+KDh3zs9Wfw@mail.gmail.com>
 <20220201233312.GX59729@dread.disaster.area>
In-Reply-To: <20220201233312.GX59729@dread.disaster.area>
From:   Sean Caron <scaron@umich.edu>
Date:   Tue, 1 Feb 2022 20:20:45 -0500
Message-ID: <CAA43vkV_nDTJjXqtWw-jpc8KVWwa2jQ8-2bNbNJZBcsBSHV8dw@mail.gmail.com>
Subject: Re: XFS disaster recovery
To:     Dave Chinner <david@fromorbit.com>, Sean Caron <scaron@umich.edu>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Thank you for the detailed response, Dave! I downloaded and built the
latest xfsprogs (5.14.2) and tried to run a metadump with the
parameters:

xfs_metadump -g -o -w /dev/md4 /exports/home/work/md4.metadump

It says:

Metadata CRC error detected at 0x56384b41796e, xfs_agf block 0x4d7fffd948/0x1000
xfs_metadump: cannot init perag data (74). Continuing anyway.

It starts counting up inodes and gets to "Copied 418624 of 83032768
inodes (1 of 350 AGs)"

The it stops with an error:

xfs_metadump: inode 2216156864 has unexpected extents

I don't see any disk read errors or SAS errors logged in dmesg. MD
array is still online and running as far as I can tell.

Where should I go from here?

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
