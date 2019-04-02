Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37954 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728479AbfDBSzA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Apr 2019 14:55:00 -0400
Received: by mail-lf1-f68.google.com with SMTP id a6so9826826lfl.5
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2019 11:54:59 -0700 (PDT)
MIME-Version: 1.0
References: <20181211183203.7fdbca0f@lud1.home> <20190331224918.GO23020@dastard>
 <20190401181311.334e96e8@lud1.home> <20190401213226.GR26298@dastard> <20190402132357.0f72e3a9@lud1.home>
In-Reply-To: <20190402132357.0f72e3a9@lud1.home>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 2 Apr 2019 12:54:47 -0600
Message-ID: <CAJCQCtT3Sy5zoWDZg+kh_KyLs3hzejhskN+k9ofjfw00yeyShw@mail.gmail.com>
Subject: Re: File system corruption in two hard disks
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Luciano ES <lucmove@gmail.com>
Cc: XFS mailing list <linux-xfs@vger.kernel.org>

On Tue, Apr 2, 2019 at 10:24 AM Luciano ES <lucmove@gmail.com> wrote:

> [    3.790321] sd 1:0:0:0: [sdb] tag#12 CDB: Read(10) 28 00 00 00 0a 00 00 01 00 00
> [    3.790323] blk_update_request: I/O error, dev sdb, sector 2640

Common bad sector error, includes the LBA for the sector.

There's a scant chance it's recoverable if the drive supports
configurable SCT ERC, and just happens to have a low timeout value
(common on NAS and enterprise drives). You can check it with:

# smartctl -l scterc /dev/sdb
# cat /sys/block/sdb/device/timeout

These are two different things. The first is internal to the drive
(firmware). The second is the kernel's command queue timer for that
block device. If the SCT ERC value is something short like 70
deciseconds, you can try disabling it.

# smartctl -l scterc,0,0 /dev/sdb

And then increase the kernel command timer to something ridiculous
like 180 seconds.

# echo 180 > /sys/block/sdb/device/timeout

Try your repair again. xfs_repair might appear to hang. My guess is it
fails again right away. But there's some chance giving the drive more
time to recover that sector, and it might just do it. Thing is, if
there's no problem with the contents on that bad sector, it won't
likely be overwritten, and it only gets "repaired" by an overwrite.
Once the xfs_repair completes and if successful, you'll want to mount
the file system rw, make some trivial change like touching a file,
then unmount.

A reboot will reset all of these values, and you'll quickly learn if
this is fixed. If not...well cross that bridge later depending on what
results you get.


> [    8.298754] sd 1:0:0:0: [sdb] tag#14 Add. Sense: Unrecovered read error - auto reallocate failed
> [    8.298757] sd 1:0:0:0: [sdb] tag#14 CDB: Read(10) 28 00 00 00 0a 56 00 00 02 00
> [    8.298758] blk_update_request: I/O error, dev sdb, sector 2646

2640 and 2646 are likely the same 4096 physical sector; they get
different values because of 512 byte sector emulation. What do you get
for

# blockdev --getss --getpbsz


> I didn't have time to investigate more so I didn't even try smartctl on it.
> But looks like that disk is dead, doesn't it?
> :-(

Uncertain. Some number of bad sectors are considered acceptable by the
manufacturer if they remap. Well, yours went bad before the remap so
I'd complain if the drive is under warranty. But that's separate from
recovery...

# smartctl -x /dev/sdb



-- 
Chris Murphy
