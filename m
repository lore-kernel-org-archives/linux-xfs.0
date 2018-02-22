Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f175.google.com ([209.85.217.175]:44465 "EHLO
        mail-ua0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932624AbeBVPLq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 10:11:46 -0500
Received: by mail-ua0-f175.google.com with SMTP id x4so3489497uaj.11
        for <linux-xfs@vger.kernel.org>; Thu, 22 Feb 2018 07:11:45 -0800 (PST)
MIME-Version: 1.0
From: Alatun Rom <alatun.rom@gmail.com>
Date: Thu, 22 Feb 2018 16:11:44 +0100
Message-ID: <CACssdW1zgsQGi33-mbteJbzUG3Q0bUaTXAfsSSNGmD8U_V1=Qg@mail.gmail.com>
Subject: xfs_repair questions
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all!

Maybe someone with knowledge about xfs_repair, can tell me what could
be the reason why a repair of an XFS  partition is currently
impossible.

The backstory: one of our servers is running a VM with a proprietary
service. After updating some packages on the host, the VM had crashed
after running initially after the update. At next start the system in
the VM (a rather old linux based on 2.6 kernel) could no longer boot,
complaining about invalid XFS structures. The VM is using a VMDK HD
container. Using vmware-mount tools I detected that the VMDK container
itself was also damaged. Vmware-tools could repair the container and I
tried to mount the root partition, which failed. I was able to locate
the offset of the MBR inside the container and mounted a loop-back
with that offset and using testdisk I was able to extract the
partition with the root file system to a file. I also extracted two
other partitions with this approach: another XFS and one ext2. Both
could be tested and fixed, but unfortunately the root filesystem is
tricky. Maybe another information is important here: initially the
system inside the VM was running on a native machine (about 10 years
ago). The root fs was created as XFS on a software raid (/dev/md0).
When I migrated the native machine to a VM I cloned the disks and
later removed one of partitions of the disc array

Now I'm trying to fix the xfs in this partition dump. xfs_repair found
7 candidates of secondary superblocks, but is unable to verify them. I
was rather disappointed with the lack of information xfs_repair
reported.

So I made a git clone of xfstools and looked for the code doing the
repair and added some more output. The output of xfs_repair for my
broken partition now looks like this:
---
Phase 1 - find and verify superblock...
bad primary superblock - bad magic number !!!

attempting to find secondary superblock...
found candidate secondary superblock... off: 32204029952
checking sbs#: 4
check sbs@ 32212221952 - status: 1
check sbs@ 64424443904 - status: 1
check sbs@ 96636665856 - status: 1
unable to verify superblock, continuing... error code: 16
found candidate secondary superblock... off: 57813565440
checking sbs#: 4
check sbs@ 32212221952 - status: 1
check sbs@ 64424443904 - status: 1
check sbs@ 96636665856 - status: 1
unable to verify superblock, continuing... error code: 16
found candidate secondary superblock... off: 64185663488
checking sbs#: 4
check sbs@ 32212221952 - status: 1
check sbs@ 64424443904 - status: 1
check sbs@ 96636665856 - status: 1
unable to verify superblock, continuing... error code: 16
found candidate secondary superblock... off: 96412992512
checking sbs#: 4
check sbs@ 7232069632 - status: 1
check sbs@ 14464139264 - status: 1
check sbs@ 21696208896 - status: 1
unable to verify superblock, continuing... error code: 16
found candidate secondary superblock... off: 96413164544
checking sbs#: 4
check sbs@ 7232069632 - status: 1
check sbs@ 14464139264 - status: 1
check sbs@ 21696208896 - status: 1
unable to verify superblock, continuing... error code: 16
found candidate secondary superblock... off: 96413271040
checking sbs#: 4
check sbs@ 7232069632 - status: 1
check sbs@ 14464139264 - status: 1
check sbs@ 21696208896 - status: 1
unable to verify superblock, continuing... error code: 16
found candidate secondary superblock... off: 96419537920
checking sbs#: 4
check sbs@ 7232069632 - status: 1
check sbs@ 14464139264 - status: 1
check sbs@ 21696208896 - status: 1
unable to verify superblock, continuing... error code: 16
Sorry, could not find valid secondary superblock
Exiting now.
--
(error code: 16 not enough superblocks the validate/ status code: 1 -
invalid superblock signature)
I added information about the file offset of the candiadates and the
status, why it is considered unusable. I also extracted the blocks at
the given offsets, and examined them and the contents of the SSBs are
looking extremely good:
--
00000000  58 46 53 42 00 00 10 00  00 00 00 00 01 df ff e0  |XFSB............|
00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000020  b1 f2 a8 ad 7d 75 4d a0  9a be 3f e6 a4 e4 05 c3  |....}uM...?.....|
00000030  00 00 00 00 01 00 00 04  00 00 00 00 00 00 00 80  |................|
00000040  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
00000050  00 00 00 01 00 77 ff f8  00 00 00 04 00 00 00 00  |.....w..........|
00000060  00 00 3b ff b4 a4 02 00  01 00 00 10 68 79 00 00  |..;.........hy..|
00000070  00 00 00 00 00 00 00 00  0c 09 08 04 17 00 00 19  |................|
00000080  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000090  00 00 00 00 01 df c3 d1  00 00 00 00 00 00 00 00  |................|
000000a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
000000b0  00 00 00 00 00 00 00 02  00 00 00 00 00 00 00 00  |................|
000000c0  00 00 00 00 00 00 00 01  00 00 00 08 00 00 00 08  |................|
000000d0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000200
--
As far as I understood, xfs_repair considers the file system
unfixable, because the other superblocks are not found at the offsets,
where they should be. The blocks found look quite ok.
My guess: because the VMDK container got damaged, the information of
the internal partitions can be incorrect, so testdisk did extract a
file that is somehow broken. But my guess is: I'm pretty close to get
it working again, but I'm stuck somehow.

What is unclear for me: why are 7 SSB found? Is this a geometry issue?
The found superblocks tell, that a total of 4 superblocks should
exist. What happens if you grow an XFS file system? Do additional
stripes generate a layout like this? Is the distance between the
superblock copies ALWAYS a constant value? In my scenario the distance
of the first 3 superblocks is not a fixed value. But how can blocks
get lost? I don't think this is possible with VMDK to "mark blocks as
deleted" inside a partition.

Perhaps somebody with more knowledge can comment this and can give me
some pointers.


Thanks
