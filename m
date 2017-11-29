Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:43552 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751368AbdK2Dda (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Nov 2017 22:33:30 -0500
MIME-Version: 1.0
In-Reply-To: <20171128223308.GC21412@magnolia>
References: <1504638680-25682-1-git-send-email-amir73il@gmail.com>
 <1504638680-25682-11-git-send-email-amir73il@gmail.com> <CAOQ4uxi_SjKCJ97Knvh4S6UiD3jskHEqDja7wwc+-mXp4CNbEw@mail.gmail.com>
 <20171127150439.i4tpt4yhooxnoaiz@destiny> <CAOQ4uxiGryFy7GLZUa0EWcbT+50cMfBb8a2dYa1mZ7tEf+UURg@mail.gmail.com>
 <20171128172152.ktvpnwv233govfwl@destiny> <CAOQ4uxgeKdZnxXcvt10MG2kT4PTZ4eZH+-v2R0zPJXTcRvONeQ@mail.gmail.com>
 <20171128200035.26kqhetxtemnm7z4@destiny> <CAOQ4uxh2OX9Lbnauv-ip5GC_8oCJ38hYsjjvp0+JFGYLqRk7nw@mail.gmail.com>
 <CAOQ4uxhQu-1AK71zg4Ce0cJd+xRt3Gf9zMMVb=Rs00zFuWA3hQ@mail.gmail.com> <20171128223308.GC21412@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 29 Nov 2017 05:33:28 +0200
Message-ID: <CAOQ4uxhj0-SBO_6cORsdJURmyrwvv_nxBRhKjMAb-PvxyeU6ew@mail.gmail.com>
Subject: Re: [PATCH v3 10/13] fstests: crash consistency fsx test using dm-log-writes
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Josef Bacik <jbacik@fb.com>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Josef Bacik <josef@toxicpanda.com>

On Wed, Nov 29, 2017 at 12:33 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Tue, Nov 28, 2017 at 11:17:01PM +0200, Amir Goldstein wrote:
[...]
>> Well, what do you know.
>> xfs crashed and burned after 18 rounds of 455 on test partition.
>> Same check fs error I blamed dm-log-writes for.
>>
>> Darrick,
>>
>> Attached the modified 455 test which runs fsx on test partition
>> and full log (+ dmesg with nothing of interest AFAICT).
>> xfs code is 4.14.0-rc8 + your patch
>> "xfs: log recovery should replay deferred ops in order"
>>
>> The test was run on a 100G partition on a spinning disk.
>>
>> Let me know what you think.
>
> I didn't even get /that/ far; with 4.15-rc1 and a vanilla g/455 I see
> immediately:

You mean vanilla g/457?

>
> [18395.236285] run fstests generic/457 at 2017-11-28 14:15:49
> [18395.561112] XFS (sdf): Unmounting Filesystem
> [18395.752713] XFS (sdf): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
> [18395.753469] XFS (sdf): EXPERIMENTAL reflink feature enabled. Use at your own risk!
> [18395.754259] XFS (sdf): Mounting V5 Filesystem
> [18395.757525] XFS (sdf): Ending clean mount
> [18395.796992] XFS (sdf): Unmounting Filesystem
> [18395.949561] XFS (dm-0): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
> [18395.950316] XFS (dm-0): EXPERIMENTAL reflink feature enabled. Use at your own risk!
> [18395.951103] XFS (dm-0): Mounting V5 Filesystem
> [18395.954946] XFS (dm-0): Ending clean mount
> [18396.132701] XFS (dm-0): Unmounting Filesystem
> [18396.309939] XFS (sdf): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
> [18396.310913] XFS (sdf): EXPERIMENTAL reflink feature enabled. Use at your own risk!
> [18396.311798] XFS (sdf): Mounting V5 Filesystem
> [18396.330304] XFS (sdf): Starting recovery (logdev: internal)
> [18396.334996] XFS (sdf): Metadata corruption detected at xfs_inode_buf_verify+0xc4/0x330 [xfs], xfs_inode block 0x80
> [18396.336389] XFS (sdf): Unmount and run xfs_repair
> [18396.336945] XFS (sdf): First 64 bytes of corrupted metadata buffer:
> [18396.337679] ffffc90004080000: 00 4e 41 ed 03 01 00 00 00 00 00 00 00 00 00 00  .NA.............
> [18396.338647] ffffc90004080010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [18396.339576] ffffc90004080020: 00 00 00 00 00 00 00 00 5a 1d e0 16 0b 69 8a 10  ........Z....i..
> [18396.340341] ffffc90004080030: 5a 1d e0 16 0b 69 8a 10 00 00 00 00 00 00 00 06  Z....i..........
> [18396.341091] XFS (sdf): bad inode magic/vsn daddr 128 #0 (magic=4e)
> [18396.341754] XFS (sdf): metadata I/O error: block 0x80 ("xlog_recover_do..(read#2)") error 117 numblks 32
> [18396.343131] XFS (sdf): log mount/recovery failed: error -117
> [18396.343852] XFS (sdf): log mount failed
>
> Off by one in the inode verifier... am I supposed to have Josef's patch?
>

I donno. Josef's patch makes sense, but it only matters for cleaning
logdev page cache
from stale data in between 2 different runs

> Also, fwiw I don't see any test failures (or interesting output) with
> your modified 455:
>
> [19344.527290] run fstests generic/455 at 2017-11-28 14:31:38
> [19344.948061] XFS (pmem4): Unmounting Filesystem
> [19345.098299] XFS (dm-0): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
> [19345.099328] XFS (dm-0): EXPERIMENTAL reflink feature enabled. Use at your own risk!
> [19345.100427] XFS (dm-0): Mounting V5 Filesystem
> [19345.105724] XFS (dm-0): Ending clean mount
> [19345.476248] XFS (dm-0): Unmounting Filesystem
> [19346.055840] XFS (pmem4): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
> [19346.057092] XFS (pmem4): EXPERIMENTAL reflink feature enabled. Use at your own risk!
> [19346.057883] XFS (pmem4): Mounting V5 Filesystem
> [19346.059640] XFS (pmem4): Ending clean mount
> [19346.084019] XFS (pmem4): Unmounting Filesystem
> [19346.492297] XFS (pmem4): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
> [19346.492950] XFS (pmem4): EXPERIMENTAL reflink feature enabled. Use at your own risk!
> [19346.493865] XFS (pmem4): Mounting V5 Filesystem
> [19346.495732] XFS (pmem4): Ending clean mount
> [19346.556181] XFS (pmem4): Unmounting Filesystem
> [19346.780951] XFS (pmem3): Unmounting Filesystem
> [19346.857051] XFS (pmem3): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
> [19346.858352] XFS (pmem3): EXPERIMENTAL reflink feature enabled. Use at your own risk!
> [19346.859053] XFS (pmem3): Mounting V5 Filesystem
> [19346.861319] XFS (pmem3): Ending clean mount
> [19346.940162] XFS (pmem3): Unmounting Filesystem
> [19346.980932] XFS (pmem3): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
> [19346.981640] XFS (pmem3): EXPERIMENTAL reflink feature enabled. Use at your own risk!
> [19346.982359] XFS (pmem3): Mounting V5 Filesystem
> [19346.984765] XFS (pmem3): Ending clean mount
> [19347.204449] XFS (pmem3): Unmounting Filesystem
>
> I think it's supposed to cycle more than that, right?
>

Usually yes. This time around I got it after 18 rounds, but sometimes
it takes more than 100 rounds.
Modified 455 is much faster because it skips all the replays, so I can
expedite the testing.
Also, since most of the failures I have seen were on the slow spinning
disk, not sure you would get
them on pmem device.

I'll continue to bisect.

Amir.
