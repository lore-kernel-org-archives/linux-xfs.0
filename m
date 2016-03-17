Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C6F727CA0
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 02:32:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4C573AC003
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 00:32:38 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id n5NLC5sDzlV5HS0J (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 17 Mar 2016 00:32:33 -0700 (PDT)
Date: Thu, 17 Mar 2016 15:32:30 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: new fs, xfs_admin new label, metadata corruption detected
Message-ID: <20160317073230.GA2708@dhcp12-237.nay.redhat.com>
References: <CAJCQCtR4tq8+BXRX+Y4rkqn6ZrFLw-9SX=gXKkF3QS1b2c8Ksg@mail.gmail.com>
	<56E8AA22.7080301@sandeen.net>
	<CAJCQCtQYMitUvPN1ORyEHvDhddJ09Hp_xK_CBc0e1Cu972S3_w@mail.gmail.com>
	<CAJCQCtQJ_1ARXYuN3j2VyVN8FBtG0myqmPnOgco1v-tQxqmyBg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJCQCtQJ_1ARXYuN3j2VyVN8FBtG0myqmPnOgco1v-tQxqmyBg@mail.gmail.com>
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
To: Chris Murphy <lists@colorremedies.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Mar 16, 2016 at 08:39:21PM -0600, Chris Murphy wrote:
> OK I can consistently reproduce this on the CLI. I end up with totally different
> 
> # lvcreate -L 40g VG -n testxfs
>   Logical volume "testxfs" created.
> # lvs
>   LV         VG   Attr       LSize  Pool       Origin Data%  Meta%
> Move Log Cpy%Sync Convert
>   testbtrfs  VG   Vwi-a-tz-- 39.06g thintastic        0.01
>   testext4   VG   Vwi-a-tz-- 39.06g thintastic        3.96
>   testxfs    VG   -wi-a----- 40.00g
>   thintastic VG   twi-aotz-- 39.06g                   3.97   4.86
> # mkfs.xfs /dev/VG/testxfs
> meta-data=/dev/VG/testxfs        isize=512    agcount=4, agsize=2621440 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=0
> data     =                       bsize=4096   blocks=10485760, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> log      =internal log           bsize=4096   blocks=5120, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> # mount /dev/VG/testxfs /mnt/0
> # cp file.iso /mnt/0
> # lvresize -L 80g VG/testxfs
>   Size of logical volume VG/testxfs changed from 40.00 GiB (10240
> extents) to 80.00 GiB (20480 extents).
>   Logical volume testxfs successfully resized.
> # xfs_growfs -d /mnt/0
> meta-data=/dev/mapper/VG-testxfs isize=512    agcount=4, agsize=2621440 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1 spinodes=0
> data     =                       bsize=4096   blocks=10485760, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> log      =internal               bsize=4096   blocks=5120, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> data blocks changed from 10485760 to 20971520
> # df -h
> Filesystem              Size  Used Avail Use% Mounted on
> devtmpfs                1.9G     0  1.9G   0% /dev
> tmpfs                   1.9G     0  1.9G   0% /dev/shm
> tmpfs                   1.9G  904K  1.9G   1% /run
> tmpfs                   1.9G     0  1.9G   0% /sys/fs/cgroup
> /dev/sda1               180G   15G  165G   9% /
> tmpfs                   1.9G  4.0K  1.9G   1% /tmp
> /dev/sda1               180G   15G  165G   9% /boot
> /dev/sda6               525M  8.4M  517M   2% /boot/efi
> /dev/mapper/brick1      562G  355G  205G  64% /brick1
> tmpfs                   388M     0  388M   0% /run/user/1000
> /dev/mapper/VG-testxfs   80G  857M   80G   2% /mnt/0
> [root@f23s ~]# lvs
>   LV         VG   Attr       LSize  Pool       Origin Data%  Meta%
> Move Log Cpy%Sync Convert
>   testbtrfs  VG   Vwi-a-tz-- 39.06g thintastic        0.01
>   testext4   VG   Vwi-a-tz-- 39.06g thintastic        3.96
>   testxfs    VG   -wi-ao---- 80.00g
>   thintastic VG   twi-aotz-- 39.06g                   3.97   4.86
> # xfs_info /dev/VG/testxfs
> meta-data=/dev/mapper/VG-testxfs isize=512    agcount=8, agsize=2621440 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1 spinodes=0
> data     =                       bsize=4096   blocks=20971520, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> log      =internal               bsize=4096   blocks=5120, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> # xfs_repair -n /dev/VG/testxfs
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
> Metadata corruption detected at xfs_agf block 0x8c00008/0x1000
> fllast 1014 in agf 7 too large (max = 1014)
> Metadata corruption detected at xfs_agf block 0x6400008/0x1000
> fllast 1014 in agf 5 too large (max = 1014)
> Metadata corruption detected at xfs_agf block 0x5000008/0x1000
> fllast 1014 in agf 4 too large (max = 1014)
> Metadata corruption detected at xfs_agf block 0x7800008/0x1000
> fllast 1014 in agf 6 too large (max = 1014)

Hi,

I can't reproduce this bug by run the same steps with you said on:
linux 4.5.0-rc2
xfsprogs v4.5.0-rc1

Could you reproduce you problem on the newest linux/xfsprogs?

As above results, agf 4, 5, 6 and 7 are the *new* AGs which created by
growfs. So the corruption only on the *new* AGs. Generally the
agf_fllast should < XFS_AGFL_SIZE(mp), but your fllast is equal to
XFS_AGFL_SIZE(mp).

BTW, if you can reproduce this bug on the newest linux/xfsprogs, could
you check when "crc=0, finobt=0" or "crc=1, finobt=0", it still can be
reproduced? If you can't reproduce on the newest, it maybe a bug of fedora.

Thanks,
Zorro

>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan (but don't clear) agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - agno = 4
>         - agno = 5
>         - agno = 6
>         - agno = 7
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 1
>         - agno = 4
>         - agno = 2
>         - agno = 7
>         - agno = 5
>         - agno = 6
>         - agno = 3
> No modify flag set, skipping phase 5
> Phase 6 - check inode connectivity...
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify link counts...
> No modify flag set, skipping filesystem flush and exiting.
> # mount /dev/VG/testxfs /mnt/0
> 
> No mount errors.
> [14189.495433] XFS (dm-5): Mounting V5 Filesystem
> [14189.710141] XFS (dm-5): Ending clean mount
> [14326.856144] XFS (dm-5): Unmounting Filesystem
> [14413.691734] XFS (dm-5): Mounting V5 Filesystem
> [14413.833598] XFS (dm-5): Ending clean mount
> 
> 
> 
> Chris Murphy
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
