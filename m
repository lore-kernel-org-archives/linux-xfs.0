Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from welcomes-you.com ([144.76.218.113]:41456 "EHLO
        smtp.welcomes-you.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751407AbdJYH1A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2017 03:27:00 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by smtp.welcomes-you.com (Postfix) with ESMTP id DE2B531A3743
        for <linux-xfs@vger.kernel.org>; Wed, 25 Oct 2017 09:20:05 +0200 (CEST)
From: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
Subject: Possible to mount this XFS at least temporarily to retrieve files?
Message-ID: <dd004707-cd48-adb8-1429-37867360594e@aei.mpg.de>
Date: Wed, 25 Oct 2017 09:20:03 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi

after some hiatus, back on this list with an incident which happened
yesterday:

On a Debian Jessie machine installed back in October 2016 there a re a
bunch of 3TB disks behind an Adaptec ASR-6405[1] in RAID6 configuration.
Yesterday, one of the disks failed and was subsequently replace. About
an hour into the rebuild the 28TB xfs on this block device gave up:

Oct 24 12:39:15 atlas8 kernel: [526440.956408] XFS (sdc1):
xfs_imap_to_bp: xfs_trans_read_buf() returned error 117.
Oct 24 12:39:15 atlas8 kernel: [526440.956452] XFS (sdc1):
xfs_do_force_shutdown(0x8) called from line 3242 of file
/build/linux-byISom/linux-3.16.43/fs/xfs/xfs_inode.c.  Return address =
0xffffffffa02c0b76
Oct 24 12:39:45 atlas8 kernel: [526471.029957] XFS (sdc1):
xfs_log_force: error 5 returned.
Oct 24 12:40:15 atlas8 kernel: [526501.154991] XFS (sdc1):
xfs_log_force: error 5 returned.

(mount options were probably (99% confidence)
rw,relatime,attr2,inode64,noquota
)

As we had several bind mounts as well as NFS clients on this one, I was
not able to clear all pending mounts - xfs_check/xfs_repair constantly
complaint about the file system still being mounted even though
/proc/self/mounts as well as fuser/lsof disagreed.

Anyway, we rebooted the system, tried to manually mount the file system
to replay any pending log but no luck as the primary superblock was not
found.

Running xfs_repair (from xfsprogs 3.2.1) on this first started looking
for a secondary superblock which apparently it found after about two
hours as it never again search for it afterwards.

However, after this running xfs_repait with and without the -L switch
stopped dead in phase 6 with the error that lost+found ran out of disk
space.

We then upgraded xfsprogs to 4.9.0+nmu1 and tried again and it failed
with the same error.

Another shot in the dark was rebooting the system with a more recent
kernel, this time 4.9.30-2+deb9u5~bpo8+1 instead of 3.16.43-2+deb8u5
which indeed changed the behaviour of xfs_repair:

# xfs_repair /dev/sdc1
Phase 1 - find and verify superblock...
sb root inode value 18446744073709551615 (NULLFSINO) inconsistent with
calculated value 128
resetting superblock root inode pointer to 128
sb realtime bitmap inode 18446744073709551615 (NULLFSINO) inconsistent
with calculated value 129
resetting superblock realtime bitmap ino pointer to 129
sb realtime summary inode 18446744073709551615 (NULLFSINO) inconsistent
with calculated value 130
resetting superblock realtime summary ino pointer to 130
Phase 2 - using internal log
        - zero log...
Log inconsistent (didn't find previous header)
failed to find log head
zero_log: cannot find log head/tail (xlog_find_tail=5)
ERROR: The log head and/or tail cannot be discovered. Attempt to mount the
filesystem to replay the log or use the -L option to destroy the log and
attempt a repair.

xfs_repair -L /dev/sdc1
Phase 1 - find and verify superblock...
sb root inode value 18446744073709551615 (NULLFSINO) inconsistent with
calculated value 128
resetting superblock root inode pointer to 128
sb realtime bitmap inode 18446744073709551615 (NULLFSINO) inconsistent
with calculated value 129
resetting superblock realtime bitmap ino pointer to 129
sb realtime summary inode 18446744073709551615 (NULLFSINO) inconsistent
with calculated value 130
resetting superblock realtime summary ino pointer to 130
Phase 2 - using internal log
        - zero log...
Log inconsistent (didn't find previous header)
failed to find log head
zero_log: cannot find log head/tail (xlog_find_tail=5)

an occasional trial mount fails with

# mount -vvv /dev/sdc1 /mnt
mount: /dev/sdc1: can't read superblock

and dmesg:
[46098.224814] XFS (sdc1): Mounting V4 Filesystem
[46098.340251] XFS (sdc1): Log inconsistent (didn't find previous header)
[46098.340290] XFS (sdc1): failed to find log head
[46098.340311] XFS (sdc1): log mount/recovery failed: error -5
[46098.340365] XFS (sdc1): log mount failed

I've run xfs_metadump just in case someone would be interested in this,
however this stops with

[...]
xfs_metadump: invalid magic in dir inode 95523308418 block 2669
xfs_metadump: invalid magic in dir inode 95523308418 block 2682
Copied 28488832 of 0 inodes (23 of 28 AGs)
xfs_metadump: suspicious count 2032 in bmap extent 84 in dir2 ino
98836491893
Copied 30292672 of 0 inodes (24 of 28 AGs)
xfs_metadump: suspicious count 1341 in bmap extent 249 in dir2 ino
103419978691
Copying log                                                Log
inconsistent (didn't find previous header)
failed to find log head
xlog_is_dirty: cannot find log head/tail (xlog_find_tail=5)

(but return value of 0)

So, I don't know if this is helpful at all or not - and it's quite large
1.7GB gzipped, about 12GB uncompressed.

Some more "random" output:

# xfs_db -r -c "sb 0" -c "p" -c "freesp" /dev/sdc1

magicnum = 0x58465342
blocksize = 4096
dblocks = 7313814267
rblocks = 0
rextents = 0
uuid = 9be23871-60a4-4deb-83bf-65e6e1efaf98
logstart = 3758096388
rootino = null
rbmino = null
rsumino = null
rextsize = 1
agblocks = 268435455
agcount = 28
rbmblocks = 0
logblocks = 521728
versionnum = 0xb4a4
sectsize = 512
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 28
rextslog = 0
inprogress = 0
imax_pct = 5
icount = 0
ifree = 0
fdblocks = 7313292427
frextents = 0
uquotino = null
gquotino = 0
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 0
width = 0
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 1
features2 = 0x8a
bad_features2 = 0x8a
features_compat = 0
features_ro_compat = 0
features_incompat = 0
features_log_incompat = 0
crc = 0 (unchecked)
spino_align = 0
pquotino = 0
lsn = 0
meta_uuid = 00000000-0000-0000-0000-000000000000
   from      to extents  blocks    pct
      1       1    7326    7326   0.00
      2       3   10132   21624   0.00
      4       7   61789  251318   0.01
      8      15   54927  494942   0.01
     16      31   20357  399672   0.01
     32      63    6928  290701   0.01
     64     127    2956  254315   0.01
    128     255    1027  186825   0.00
    256     511    1054  402182   0.01
    512    1023    3980 3235959   0.07
   1024    2047     634  942129   0.02
   2048    4095     451 1340993   0.03
   4096    8191     267 1559353   0.04
   8192   16383     190 2332137   0.05
  16384   32767     114 2810123   0.07
  32768   65535      89 4339005   0.10
  65536  131071      46 4382290   0.10
 131072  262143      14 2596831   0.06
 262144  524287      12 4632120   0.11
 524288 1048575       8 6391289   0.15
1048576 2097151       9 14059493   0.33
2097152 4194303       8 20104228   0.47
4194304 8388607      16 103605889   2.40
8388608 16777215       1 10074277   0.23
16777216 33554431       1 20576975   0.48
33554432 67108863       2 109236674   2.53
67108864 134217727       2 212839297   4.92
134217728 268435455      21 3794702496  87.80

Now my "final" question: Is there a chance to get some/most files from
this hosed file system or am I just wasting my time[2]?

Any information I can share to help the issue?

Cheers

Carsten

[1] https://storage.microsemi.com/de-de/support/raid/sas_raid/sas-6405/
[2] The file system officially is used as "scratch" space, i.e. not
backed up. But eventually vital user data may end up there, thus the
quest of trying to restore whatever is possible.

-- 
Dr. Carsten Aulbert, Max Planck Institute for Gravitational Physics,
Callinstraße 38, 30167 Hannover, Germany
Phone: +49 511 762 17185
