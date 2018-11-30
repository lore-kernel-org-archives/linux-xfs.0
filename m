Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38424 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbeK3XWP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Nov 2018 18:22:15 -0500
Date: Fri, 30 Nov 2018 20:15:06 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [4.20-rc4 regression] generic/095 Concurrent mixed I/O hang on
 xfs based overlayfs
Message-ID: <20181130121506.GI2299@dhcp-12-149.nay.redhat.com>
References: <20181130051253.GB7100@sh-el5.eng.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181130051253.GB7100@sh-el5.eng.rdu2.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Murphy Zhou <jencce.kernel@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org

On Fri, Nov 30, 2018 at 12:12:53AM -0500, Murphy Zhou wrote:
> Hi,
> 
> Hit a xfs regression issue by generic/095 on overlayfs.
> 
> It's easy to reproduce. Tests processes hang there and never return.
> There are some warning in the dmesg.
> 
> SIGINT (Ctrl+C) can't kill the tests, neither does SIGTERM (kill).
> However, SIGKILL (kill -9) can clean them up.
> 
> This happens when testing on v4 or v5 or reflink, with the same behaviour.
> -m crc=0
> -m crc=1,finobt=1,rmapbt=0,reflink=0 -i sparse=1
> -m crc=1,finobt=1,rmapbt=1,reflink=1 -i sparse=1
> 
> This does not happen if ext4 as base fs for overlayfs.
> 
> Bisecting points to this commit:
> 	4721a601 iomap: dio data corruption and spurious errors when pipes fill
> 
> Test pass soon after this commit reverted.
> 
> # ps axjf
>  1839  1862   S+    0:00  |  \_ /bin/bash ./bin/single -o -t generic/095
>  1862  2005   S+    0:00  |      \_ /bin/bash ./check -T -overlay generic/095
>  2005  2292   S+    0:00  |          \_ /bin/bash ./tests/generic/095
>  2292  2516   Sl+   0:01  |              \_ /usr/bin/fio /tmp/2292.fio
>  2516  2565   Rs    6:02  |                  \_ /usr/bin/fio /tmp/2292.fio
>  2516  2566   Rs    6:02  |                  \_ /usr/bin/fio /tmp/2292.fio
>  2516  2567   Rs    6:02  |                  \_ /usr/bin/fio /tmp/2292.fio
>  2516  2568   Rs    6:02  |                  \_ /usr/bin/fio /tmp/2292.fio
>  2516  2569   Rs    6:02  |                  \_ /usr/bin/fio /tmp/2292.fio

Nice catch! I didn't tried overlayfs on XFS regression test this time. I never hit
issue on XFS singly, even on glusterfs(XFS underlying).

I just gave it a try. This bug is reproducible on xfs-linux git tree
xfs-4.20-fixes-2 HEAD. And by strace all fio processes, they all
keep outputing [1]. More details as [2]. Only overlayfs on XFS can
reproduce this bug, overlayfs on Ext4 can't.

Thanks,
Zorro

[1]
# strace -p $running_fio_process
...
...
splice(3, NULL, 5, [147456], 8192, 0)   = 0
splice(3, NULL, 5, [147456], 8192, 0)   = 0
splice(3, NULL, 5, [147456], 8192, 0)   = 0
splice(3, NULL, 5, [147456], 8192, 0)   = 0
splice(3, NULL, 5, [147456], 8192, 0)   = 0
splice(3, NULL, 5, [147456], 8192, 0)   = 0
splice(3, NULL, 5, [147456], 8192, 0)   = 0
splice(3, NULL, 5, [147456], 8192, 0)   = 0
splice(3, NULL, 5, [147456], 8192, 0)   = 0
splice(3, NULL, 5, [147456], 8192, 0)   = 0
splice(3, NULL, 5, [147456], 8192, 0)   = 0
splice(3, NULL, 5, [147456], 8192, 0)   = 0
splice(3, NULL, 5, [147456], 8192, 0)   = 0
splice(3, NULL, 5, [147456], 8192, 0)   = 0
splice(3, NULL, 5, [147456], 8192, 0)   = 0
splice(3, NULL, 5, [147456], 8192, 0)   = 0
splice(3, NULL, 5, [147456], 8192, 0)   = 0
splice(3, NULL, 5, [147456], 8192, 0)   = 0
splice(3, NULL, 5, [147456], 8192, 0)   = 0
splice(3, NULL, 5, [147456], 8192, 0)   = 0
splice(3, NULL, 5, [147456], 8192, 0)   = 0
splice(3, NULL, 5, [147456], 8192, 0)   = 0
splice(3, NULL, 5, [147456], 8192, 0)   = 0
splice(3, NULL, 5, [147456], 8192, 0)   = 0
splice(3, NULL, 5, [147456], 8192, 0)   = 0
...
...

[2]
# mount -l
...
/dev/sda3 on /mnt/ovl/test type xfs (rw,relatime,seclabel,attr2,inode64,sunit=512,swidth=512,noquota)
/dev/sda5 on /mnt/ovl/scratch type xfs (rw,relatime,seclabel,attr2,inode64,sunit=512,swidth=512,noquota)
/mnt/ovl/test on /mnt/xfstests/mnt1 type overlay (rw,relatime,context=system_u:object_r:nfs_t:s0,lowerdir=/mnt/ovl/test/ovl-lower,upperdir=/mnt/ovl/test/ovl-upper,workdir=/mnt/ovl/test/ovl-work)
/mnt/ovl/scratch on /mnt/xfstests/mnt2 type overlay (rw,relatime,context=system_u:object_r:nfs_t:s0,lowerdir=/mnt/ovl/scratch/ovl-lower,upperdir=/mnt/ovl/scratch/ovl-upper,workdir=/mnt/ovl/scratch/ovl-work)

# xfs_info /mnt/ovl/test
meta-data=/dev/sda3              isize=512    agcount=16, agsize=245760 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=3932160, imaxpct=25
         =                       sunit=64     swidth=64 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
# xfs_info /mnt/ovl/scratch
meta-data=/dev/sda5              isize=512    agcount=16, agsize=245760 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=3932160, imaxpct=25
         =                       sunit=64     swidth=64 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


> 
> # dmesg
> [   50.285345] run fstests generic/095 at 2018-11-29 23:25:24
> [   50.441180] XFS (loop1): Unmounting Filesystem
> [   51.126243] XFS (loop1): Mounting V5 Filesystem
> [   51.133348] XFS (loop1): Ending clean mount
> [   51.646769] Page cache invalidation failure on direct I/O.  Possible data corruption due to collision with buffered I/O!
> [   51.646878] Page cache invalidation failure on direct I/O.  Possible data corruption due to collision with buffered I/O!
> [   51.647776] Page cache invalidation failure on direct I/O.  Possible data corruption due to collision with buffered I/O!
> [   51.647779] File: /loopsch/ovl-mnt/file1 PID: 2568 Comm: fio
> [   51.648148] Page cache invalidation failure on direct I/O.  Possible data corruption due to collision with buffered I/O!
> [   51.648151] File: /loopsch/ovl-mnt/file1 PID: 2568 Comm: fio
> [   51.657721] File: /loopsch/ovl-mnt/file1 PID: 2551 Comm: fio
> [   51.707667] File: /loopsch/ovl-mnt/file2 PID: 2599 Comm: fio
> 
> # local.config
> TEST_DEV=/dev/loop0
> TEST_DIR=/loopmnt
> SCRATCH_DEV=/dev/loop1
> SCRATCH_MNT=/loopsch
> FSTYP=xfs
> MOUNT_OPTIONS=""
> TEST_FS_MOUNT_OPTS=""
> MKFS_OPTIONS=""
> 
> # cmd
> ./check -T -overlay generic/095
> 
> # xfstests version: git log --oneline -1
> 15b13f7f (HEAD -> master, origin/master, origin/imaster, origin/HEAD) ext4/021: Work with 64k block size
> 
> # xfsprogs version: git log --oneline -1
> caa91046 (HEAD -> for-next, tag: v4.19.0, origin/master, origin/for-next, origin/HEAD) xfsprogs: Release v4.19.0
> 
> # xfs_io -V
> xfs_io version 4.19.0
> 
> # xfs on loop device as base fs for overlayfs
> /dev/loop1 on /loopsch type xfs (rw,relatime,seclabel,attr2,inode64,noquota)
> meta-data=/dev/loop1             isize=512    agcount=4, agsize=983040 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=0
> data     =                       bsize=4096   blocks=3932160, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=2560, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> # overlayfs mount info:
> /dev/loop0 on /loopmnt type xfs (rw,relatime,seclabel,attr2,inode64,noquota)
> /loopmnt on /loopmnt/ovl-mnt type overlay (rw,relatime,context=system_u:object_r:root_t:s0,lowerdir=/loopmnt/ovl-lower,upperdir=/loopmnt/ovl-upper,workdir=/loopmnt/ovl-work)
> 
> # cat bs-log
> git bisect start
> # good: [edeca3a769ad28a9477798c3b1d8e0701db728e4] Merge tag 'sound-4.20-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
> git bisect good edeca3a769ad28a9477798c3b1d8e0701db728e4
> # bad: [d6d460b89378b1bc6715574cdafd748ba59d5a27] Merge tag 'dma-mapping-4.20-3' of git://git.infradead.org/users/hch/dma-mapping
> git bisect bad d6d460b89378b1bc6715574cdafd748ba59d5a27
> # good: [07093b76476903f820d83d56c3040e656fb4d9e3] net: gemini: Fix copy/paste error
> git bisect good 07093b76476903f820d83d56c3040e656fb4d9e3
> # good: [7c98a42618271210c60b79128b220107d35938d9] Merge tag 'ceph-for-4.20-rc4' of https://github.com/ceph/ceph-client
> git bisect good 7c98a42618271210c60b79128b220107d35938d9
> # bad: [e195ca6cb6f21633e56322d5aa11ed59cdb22fb2] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/hid/hid
> git bisect bad e195ca6cb6f21633e56322d5aa11ed59cdb22fb2
> # bad: [d146194f31c96f9b260c5a1cf1592d2e7f82a2e2] Merge tag 'arm64-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux
> git bisect bad d146194f31c96f9b260c5a1cf1592d2e7f82a2e2
> # good: [0929d8580071c6a1cec1a7916a8f674c243ceee1] iomap: FUA is wrong for DIO O_DSYNC writes into unwritten extents
> git bisect good 0929d8580071c6a1cec1a7916a8f674c243ceee1
> # bad: [8c110d43c6bca4b24dd13272a9d4e0ba6f2ec957] iomap: readpages doesn't zero page tail beyond EOF
> git bisect bad 8c110d43c6bca4b24dd13272a9d4e0ba6f2ec957
> # bad: [4721a6010990971440b4ffefbdf014976b8eda2f] iomap: dio data corruption and spurious errors when pipes fill
> git bisect bad 4721a6010990971440b4ffefbdf014976b8eda2f
> # good: [b450672fb66b4a991a5b55ee24209ac7ae7690ce] iomap: sub-block dio needs to zeroout beyond EOF
> git bisect good b450672fb66b4a991a5b55ee24209ac7ae7690ce
> # first bad commit: [4721a6010990971440b4ffefbdf014976b8eda2f] iomap: dio data corruption and spurious errors when pipes fill
