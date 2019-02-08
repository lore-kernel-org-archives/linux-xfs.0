Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.194]:55127 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726801AbfBHCZU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Feb 2019 21:25:20 -0500
Date: Thu, 7 Feb 2019 21:25:13 -0500
From: David T-G <davidtg@justpickone.org>
Subject: Re: is it safe to xfs_repair this volume? do i have a different
 first step?
Message-ID: <20190208022513.GB2185@justpickone.org>
References: <20190207132534.GA2185@justpickone.org>
 <20190207145247.GC2880@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190207145247.GC2880@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linux-XFS list <linux-xfs@vger.kernel.org>

Brian, et al --

...and then Brian Foster said...
% 
% On Thu, Feb 07, 2019 at 08:25:34AM -0500, David T-G wrote:
% > 
% > I have a four-disk RAID5 volume with an ~11T filesystem that suddenly
% > won't mount 
...
% > when poking, I at first thought that this was a RAID issue, but all of
% > the md reports look good and apparently the GPT table issue is common, so
% > I'll leave all of that out unless someone asks for it.
% 
% I'd be curious if the MD metadata format contends with GPT metadata. Is
% the above something you've ever tried before running into this problem
% and thus can confirm whether it preexisted the mount problem or not?

There's a lot I don't know, so it's quite possible that it doesn't line
up.  Here's what mdadm tells me:

  diskfarm:root:6:~> mdadm --detail /dev/md0
  /dev/md0:
          Version : 1.2
    Creation Time : Mon Feb  6 00:56:35 2017
       Raid Level : raid5
       Array Size : 11720265216 (11177.32 GiB 12001.55 GB)
    Used Dev Size : 3906755072 (3725.77 GiB 4000.52 GB)
     Raid Devices : 4
    Total Devices : 4
      Persistence : Superblock is persistent

      Update Time : Fri Jan 25 03:32:18 2019
            State : clean
   Active Devices : 4
  Working Devices : 4
   Failed Devices : 0
    Spare Devices : 0

           Layout : left-symmetric
       Chunk Size : 512K

             Name : diskfarm:0  (local to host diskfarm)
             UUID : ca7008ef:90693dae:6c231ad7:08b3f92d
           Events : 48211

      Number   Major   Minor   RaidDevice State
         0       8       17        0      active sync   /dev/sdb1
         1       8       65        1      active sync   /dev/sde1
         3       8       81        2      active sync   /dev/sdf1
         4       8        1        3      active sync   /dev/sda1
  diskfarm:root:6:~>
  diskfarm:root:6:~> for D in a1 b1 e1 f1 ; do mdadm --examine /dev/sd$D | egrep "$D|Role|State|Checksum|Events" ; done
  /dev/sda1:
            State : clean
      Device UUID : f05a143b:50c9b024:36714b9a:44b6a159
         Checksum : 4561f58b - correct
           Events : 48211
     Device Role : Active device 3
     Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
  /dev/sdb1:
            State : clean
         Checksum : 4654df78 - correct
           Events : 48211
     Device Role : Active device 0
     Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
  /dev/sde1:
            State : clean
         Checksum : c4ec7cb6 - correct
           Events : 48211
     Device Role : Active device 1
     Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
  /dev/sdf1:
            State : clean
         Checksum : 349cf800 - correct
           Events : 48211
     Device Role : Active device 2
     Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

Does that set off any alarms for you?


% 
% If not, I'd suggest some more investigation into this before you make
% any future partition or raid changes to this storage. I thought there
% were different MD formats to accommodate precisely this sort of
% incompatibility, but I don't know for sure. linux-raid is probably more
% of a help here.

Thanks :-)  I have no plans to partition, but I will eventually want to
grow it, so I'll definitely have to check on that.


% 
% > dmesg reports some XFS problems
% > 
% >   diskfarm:root:5:~> dmesg | egrep 'md[:/0]'
...
% >   [  202.230961] XFS (md0p1): Mounting V4 Filesystem
% >   [  203.182567] XFS (md0p1): Torn write (CRC failure) detected at log block 0x3397e8. Truncating head block from 0x3399e8.
% >   [  203.367581] XFS (md0p1): failed to locate log tail
% >   [  203.367587] XFS (md0p1): log mount/recovery failed: error -74
% >   [  203.367712] XFS (md0p1): log mount failed
...
% 
% Hmm. So part of the on-disk log is invalid. We attempt to deal with this
...
% I'd guess that the torn write is due to interleaving log writes across
% raid devices or something, but we can't really tell from just this.

The filesystem *shouldn't* see that there are distinct devices under
there, since that's handled by the md driver, but there's STILL a lot
that I don't know :-)


% 
% >   diskfarm:root:4:~> xfs_repair -n /dev/disk/by-label/4Traid5md 2>&1 | egrep -v 'agno = '
...
% >           - scan filesystem freespace and inode maps...
% >   sb_fdblocks 471930978, counted 471939170
% 
% The above said, the corruption here looks extremely minor. You basically
...
% scans and not much else going on.

That sounds hopeful! :-)


% 
% >           - 09:18:47: scanning filesystem freespace - 48 of 48 allocation groups done
...
% >   Phase 7 - verify link counts...
% >           - 09:34:02: verify and correct link counts - 48 of 48 allocation groups done
% >   No modify flag set, skipping filesystem flush and exiting.
% > 
% > is the trimmed output that can fit on one screen.  Since I don't have a
...
% 
% What do you mean by trimmed output? Was there more output from
% xfs_repair that is not shown here?

Yes.  Note the

  | egrep -v 'agno = '

on the command line above.  The full output

  diskfarm:root:4:~> xfs_repair -n /dev/disk/by-label/4Traid5md >/tmp/xfs_repair.out 2>&1
  diskfarm:root:4:~> wc -l /tmp/xfs_repair.out
  124 /tmp/xfs_repair.out

was quite long.  Shall I attach that file or post a link?


% 
% In general, if you're concerned about what xfs_repair might do to a
% particular filesystem you can always do a normal xfs_repair run against
% a metadump of the filesystem before the original copy. Collect a
% metadump of the fs:
% 
% xfs_metadump -go <dev> <outputmdimg>

Hey, cool!  I like that :-)  It generated a sizeable output file

  diskfarm:root:8:~> xfs_metadump /dev/disk/by-label/4Traid5md /mnt/750Graid5md/tmp/4Traid5md.xfs_d.out >/mnt/750Graid5md/tmp/4Traid5md.xfs_d.out.stdout-stderr 2>&1
  diskfarm:root:8:~> ls -goh /mnt/750Graid5md/tmp/4Traid5md.xfs_d.out
  -rw-r--r-- 1 3.5G Feb  7 17:57 /mnt/750Graid5md/tmp/4Traid5md.xfs_d.out
  diskfarm:root:8:~> wc -l /mnt/750Graid5md/tmp/4Traid5md.xfs_d.out.stdout-stderr
  239 /mnt/750Graid5md/tmp/4Traid5md.xfs_d.out.stdout-stderr

as well as quite a few errors.  Here

  diskfarm:root:8:~> head /mnt/750Graid5md/tmp/4Traid5md.xfs_d.out.stdout-stderr
  xfs_metadump: error - read only 0 of 4096 bytes
  xfs_metadump: error - read only 0 of 4096 bytes
  xfs_metadump: cannot init perag data (5). Continuing anyway.
  xfs_metadump: error - read only 0 of 4096 bytes
  xfs_metadump: cannot read dir2 block 39/132863 (2617378559)
  xfs_metadump: error - read only 0 of 4096 bytes
  xfs_metadump: cannot read dir2 block 41/11461784 (2762925208)
  xfs_metadump: error - read only 0 of 4096 bytes
  xfs_metadump: cannot read dir2 block 41/4237562 (2755700986)
  xfs_metadump: error - read only 0 of 4096 bytes

  diskfarm:root:8:~> tail /mnt/750Graid5md/tmp/4Traid5md.xfs_d.out.stdout-stderr
  xfs_metadump: error - read only 0 of 4096 bytes
  xfs_metadump: cannot read superblock for ag 47
  xfs_metadump: error - read only 0 of 4096 bytes
  xfs_metadump: cannot read agf block for ag 47
  xfs_metadump: error - read only 0 of 4096 bytes
  xfs_metadump: cannot read agi block for ag 47
  xfs_metadump: error - read only 0 of 4096 bytes
  xfs_metadump: cannot read agfl block for ag 47
  xfs_metadump: Filesystem log is dirty; image will contain unobfuscated metadata in log.
  cache_purge: shake on cache 0x4ee1c0 left 117 nodes!?

is a glance at the contents.  Should I post/paste the full copy?


% 
% Note that the metadump collects everything except file data so it will
% require a decent amount of space depending on how much metadata
% populates your fs vs. data.
% 
% Then restore the metadump to a sparse file (on some other
% filesystem/storage):
% 
% xfs_mdrestore -g <mdfile> <sparsefiletarget>

I tried this 

  diskfarm:root:11:~> dd if=/dev/zero bs=1 count=0 seek=4G of=/mnt/750Graid5md/tmp/4Traid5md.xfs_d.iso
  0+0 records in
  0+0 records out
  0 bytes copied, 6.7252e-05 s, 0.0 kB/s
  diskfarm:root:11:~> ls -goh /mnt/750Graid5md/tmp/4Traid5md.xfs_d.iso
  -rw-r--r-- 1 4.0G Feb  7 21:15 /mnt/750Graid5md/tmp/4Traid5md.xfs_d.iso
  diskfarm:root:11:~> xfs_mdrestore /mnt/750Graid5md/tmp/4Traid5md.xfs_d.out /mnt/750Graid5md/tmp/4Traid5md.xfs_d.iso
  xfs_mdrestore: cannot set filesystem image size: File too large

and got an error :-(  Should a 4G file be large enough for a 3.5G
metadata dump?


% 
% Then you can mount/xfs_repair the restored sparse image, see what
% xfs_repair does, mount the before/after img, etc. Note again that file
% data is absent from the restored metadata image so don't expect to be
% able to look at file content in the metadump image.

Right.  That sounds like a great middle step, though.  Thanks!


% 
% Brian


HAND

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt
