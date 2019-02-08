Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f182.google.com ([209.85.208.182]:42462 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727180AbfBHTpR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Feb 2019 14:45:17 -0500
Received: by mail-lj1-f182.google.com with SMTP id l15-v6so3976647lja.9
        for <linux-xfs@vger.kernel.org>; Fri, 08 Feb 2019 11:45:16 -0800 (PST)
MIME-Version: 1.0
References: <20190207132534.GA2185@justpickone.org> <20190207145247.GC2880@bfoster>
 <20190208022513.GB2185@justpickone.org>
In-Reply-To: <20190208022513.GB2185@justpickone.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 8 Feb 2019 12:45:03 -0700
Message-ID: <CAJCQCtQJ77ifSZGi+ohjB0aLOAfznnoVJPouoHee3MjN=gkmmw@mail.gmail.com>
Subject: Re: is it safe to xfs_repair this volume? do i have a different first step?
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David T-G <davidtg@justpickone.org>
Cc: Linux-XFS list <linux-xfs@vger.kernel.org>

On Thu, Feb 7, 2019 at 7:25 PM David T-G <davidtg@justpickone.org> wrote:
>
>   diskfarm:root:6:~> mdadm --detail /dev/md0
>   /dev/md0:
>           Version : 1.2

Version 1.2 metadata is 4K offset from the start of the member device.
The member devices in your case:

>       Number   Major   Minor   RaidDevice State
>          0       8       17        0      active sync   /dev/sdb1
>          1       8       65        1      active sync   /dev/sde1
>          3       8       81        2      active sync   /dev/sdf1
>          4       8        1        3      active sync   /dev/sda1

That means those member devices are partitioned. The primary GPT will
be in the first 34 512 byte sectors, and backup GPT in the last 34 512
byte sectors, on each physical drive. The mdadm v1.2 superblock is
located at 4K from the start of the partition designated as a member
of the array. And mdadm will only consider the partition as the area
that can be written to which means each member device's backup GPT
should be immune from being written to by md and XFS.

Since there's a 512KiB chunk size, and the array is clearly also
partitioned, means the array primary GPT is on one member device soon
after the mdadm superblock; and the array backup GPT is on a different
member device immediately before its own backup GPT. I can't think of
a reason for a conflict off the top of my head. And yet there's a
conflict somewhere as you have independent corruptions: XFS and GPT.

Just - whatever you do, don't fix anything. Here's an idea for setting
up an overlay so you can test your repairs by writing changes
elsewhere, and not touch the original drives.
https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file

I suggest getting advice on the linux-raid list before proceeding,
find out why it appears XFS and the array backup GPT are being stepped
on. They'll want to see the partitioning for every device (both
primary and backup if they aren't identical, i.e. one is corrupt), the
full superblock for each device, and the GPT for the array. And what
version of mdadm was used to create the array. They'll also want
smartctl -x for each drive. And they'll want 'smartctl -l scterc' from
each drive. And they'll want to know what the kernel command timer is
set to for each drive:
# cat /sys/block/sdX/device/timeout

I imagine you're gonna get asked by someone why bother partitioning
each drive with one partition, and then partition the array too, also
with one partition. That's overly complicated and serves no purpose.
Next time, make each whole drive an mdadm member; and then format the
array.

People lose their data all the time due to user error, so I can't
recommend enough that you sanity check what you've done and what you
intend to do, on each applicable list, using linux-raid for the mdadm
stuff. And for godsake if you care at all about this data you need at
least one backup copy.

-- 
Chris Murphy
