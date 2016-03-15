Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A6BC47CDB
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 18:08:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0CD61AC001
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 16:08:22 -0700 (PDT)
Received: from mail-ig0-f176.google.com (mail-ig0-f176.google.com
	[209.85.213.176]) by cuda.sgi.com with ESMTP id
	HMgfQXUuh0D1ngod (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 15 Mar 2016 16:08:17 -0700 (PDT)
Received: by mail-ig0-f176.google.com with SMTP id av4so100182782igc.1
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 16:08:17 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 15 Mar 2016 17:08:16 -0600
Message-ID: <CAJCQCtR4tq8+BXRX+Y4rkqn6ZrFLw-9SX=gXKkF3QS1b2c8Ksg@mail.gmail.com>
Subject: new fs, xfs_admin new label, metadata corruption detected
From: Chris Murphy <lists@colorremedies.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Is this expected? File system continues to work OK, sha256sum on the
single file on this fs matches the source, but the metadata corruption
messages are a bit scary so figured I'd ask about it.

Filesystem created with
xfsprogs-4.3.0-1.fc23
kernel-4.4.4-300.fc23.x86_64

mkfs.xfs defaults used on an LVM thinly provisioned volume on a single
spinning disk.

# xfs_info /dev/mapper/VG-testxfs
meta-data=/dev/mapper/VG-testxfs isize=512    agcount=23, agsize=399984 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0
data     =                       bsize=4096   blocks=8960000, imaxpct=25
         =                       sunit=16     swidth=16 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=3124, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


Mounted the file system, copied one decently large ISO, deleted it,
unmounted the file system. Upgraded to kernel 4.5.0, and
xfsprogs-4.3.0-3.fc23, reboot, mounted the file system again, copied a
file, unmounted, and then tried to rename its label:

[root@f23s ~]# xfs_admin -L testxfs /dev/mapper/VG-testxfs
Metadata corruption detected at xfs_agf block 0x30d3808/0x1000
xfs_admin: cannot init perag data (-117). Continuing anyway.
writing all SBs
new label = "testxfs"

Kernel messages:
[snip]
[  226.804218] nf_conntrack: automatic helper assignment is deprecated
and it will be removed soon. Use the iptables CT target to attach
helpers instead.
[  370.527700] SGI XFS with ACLs, security attributes, no debug enabled
[  370.546159] XFS (dm-5): Mounting V5 Filesystem
[  370.621943] XFS (dm-5): Ending clean mount
[  438.064901] EXT4-fs (dm-7): mounted filesystem with ordered data
mode. Opts: (null)
[  837.965252] BTRFS: device label testbtr devid 1 transid 3
/dev/mapper/VG-testbtrfs
[  851.690987] BTRFS info (device dm-8): disk space caching is enabled
[  851.691064] BTRFS: has skinny extents
[  851.691100] BTRFS: flagging fs with big metadata feature
[  851.702530] BTRFS: creating UUID tree
[ 1057.799823] XFS (dm-5): Unmounting Filesystem

[root@f23s ~]# xfs_repair /dev/mapper/VG-testxfs
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
Metadata corruption detected at xfs_agf block 0x4322d08/0x1000
Metadata corruption detected at xfs_agf block 0x30d3808/0x1000
fllast 1014 in agf 22 too large (max = 1014)
Metadata corruption detected at xfs_agf block 0x4015988/0x1000
Metadata corruption detected at xfs_agf block 0x3d08608/0x1000
Metadata corruption detected at xfs_agf block 0x33e0b88/0x1000
fllast 1014 in agf 16 too large (max = 1014)
fllast 1014 in agf 21 too large (max = 1014)
fllast 1014 in agf 20 too large (max = 1014)
Metadata corruption detected at xfs_agf block 0x39fb288/0x1000
fllast 1014 in agf 17 too large (max = 1014)
fllast 1014 in agf 19 too large (max = 1014)
Metadata corruption detected at xfs_agf block 0x36edf08/0x1000
fllast 1014 in agf 18 too large (max = 1014)
        - 16:47:27: scanning filesystem freespace - 23 of 23
allocation groups done
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - 16:47:27: scanning agi unlinked lists - 23 of 23 allocation
groups done
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 15
        - agno = 16
        - agno = 1
        - agno = 2
        - agno = 17
        - agno = 3
        - agno = 18
        - agno = 4
        - agno = 19
        - agno = 5
        - agno = 20
        - agno = 6
        - agno = 7
        - agno = 21
        - agno = 8
        - agno = 22
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - 16:47:27: process known inodes and inode discovery - 64 of
64 inodes done
        - process newly discovered inodes...
        - 16:47:27: process newly discovered inodes - 23 of 23
allocation groups done
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - 16:47:27: setting up duplicate extent list - 23 of 23
allocation groups done
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - 16:47:27: check for inodes claiming duplicate blocks - 64 of
64 inodes done
Phase 5 - rebuild AG headers and trees...
        - 16:47:27: rebuild AG headers and trees - 23 of 23 allocation
groups done
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done

I haven't tried reproducing this.

-- 
Chris Murphy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
