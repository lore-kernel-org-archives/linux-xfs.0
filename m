Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76B3FC4167B
	for <linux-xfs@archiver.kernel.org>; Sun, 29 Oct 2023 04:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjJ2Eec (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 29 Oct 2023 00:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjJ2Eeb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 29 Oct 2023 00:34:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192B6CC
        for <linux-xfs@vger.kernel.org>; Sat, 28 Oct 2023 21:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698554021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=q8CT93+rru+20f6T5oB+ApoGuNtHvCDC6nTLTCfDNa4=;
        b=QD/ICWmCVEWY85Kr650ZSRRdsLgvYm//E2xD/ALKNIvcFoFdPzYA2LBHFlmZ1K76UXwJrp
        RPpaKv9q1QHLqIIgISObN1shfKH0kNmqS0aiFW8ym54PPdXAQOHPJo9z1hotmnV/35vXRM
        J0glIZCvI6CvKg2dXaHCsZlGG3eKytY=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-359-0Y8JrHPEOR-KQTKFXb0F9A-1; Sun, 29 Oct 2023 00:33:39 -0400
X-MC-Unique: 0Y8JrHPEOR-KQTKFXb0F9A-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-27756e0e4d8so3361892a91.3
        for <linux-xfs@vger.kernel.org>; Sat, 28 Oct 2023 21:33:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698554018; x=1699158818;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q8CT93+rru+20f6T5oB+ApoGuNtHvCDC6nTLTCfDNa4=;
        b=L/wCT+0obqHNENvDhQWbEojloO50AZtZUPXB3gHISMzzGO4qh/FHJIXIH4YpKugRef
         s1Oqba32EZyfe1dlAJ4Da45VkWCxlt+kZVu1StpjGRQ5VwQnYPU978xNszGTPm+O/7Bz
         XYpvKg3uSE4CZ4byTbOeZi3dKeGzlEWs6d3HDGeLe4/7iVdECfYatHNhAbl8ZFSimVhO
         2o/PMaKDwhJd4POhXoRGMSfDDlnMgM0RCdnFmMeauDQ19+L6ATcC5T1+etfPblq+Uyri
         hhepdZp6VW1V1pmnn/uT7Rd+msQIi0UOz/ibxCwBzYe3zX6BaEQMIB5Ddh76P8LFBTY8
         /BvQ==
X-Gm-Message-State: AOJu0YylqD7f56N3pxm+K8BRzu8zT7rx2sYkvThJPoylOMIvazoSRM5S
        Zp5nwj732qVneBwk/AVfEBfl7tPfmGXDkuCVAn/00YXA40hLyd9h2KRcxGecgvkphBGBjWoxRiV
        1ClDnjHvPbUBB/CGjqt8Uq9kN+yrFX/ES1XraT9jwnDmNnO09ez9RelTgXfefJTtoU55heyW2PB
        eohEfnBA==
X-Received: by 2002:a17:90a:88a:b0:27e:22b:dce5 with SMTP id v10-20020a17090a088a00b0027e022bdce5mr5311106pjc.27.1698554017969;
        Sat, 28 Oct 2023 21:33:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE6pVp5LZuo6jC83UrHiRYEEDyOAluQov5owhMqYr5IkYiX8ebfTB/+FjBJYw7SdfTsFVP2vQ==
X-Received: by 2002:a17:90a:88a:b0:27e:22b:dce5 with SMTP id v10-20020a17090a088a00b0027e022bdce5mr5311096pjc.27.1698554017401;
        Sat, 28 Oct 2023 21:33:37 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id gg18-20020a17090b0a1200b002800ea6caacsm3232373pjb.1.2023.10.28.21.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Oct 2023 21:33:37 -0700 (PDT)
Date:   Sun, 29 Oct 2023 12:33:33 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, fstests@vger.kernel.org
Subject: [Bug report] More xfs courruption issue found on s390x
Message-ID: <20231029043333.v6wkqsorxdk2dbch@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi xfs folks,

Besides https://lore.kernel.org/linux-xfs/20231029041122.bx2k7wwm7otebjd5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com/T/#u ,

I always hit another failure on s390x too, by running generic/039 or generic/065 [1]:

  XFS: Assertion failed: ip->i_nblocks == 0, file: fs/xfs/xfs_inode.c, line: 2359

More details as dmesg output [2] and .full output [3].

And ... more other kind of failure likes [3]:
  XFS: Assertion failed: error != -ENOENT, file: fs/xfs/xfs_trans.c, line: 1310

All these falures are on s390x only... and more xfs corruption failure by running
fstests on s390x. I don't know if it's a s390x issue or a xfs issue on big endian
machine (s390x), so cc s390x list.

I tested on mainline linux 6.6.0-rc7+, the HEAD commit is:

commit 750b95887e567848ac2c851dae47922cac6db946
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Oct 26 20:42:02 2023 -1000

    Merge tag 'drm-fixes-2023-10-27' of git://anongit.freedesktop.org/drm/drm


Thanks,
Zorro

[1]
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/s390x s390x-kvm-091 6.6.0-rc7+ #1 SMP Fri Oct 27 08:58:03 EDT 2023
MKFS_OPTIONS  -- -f -m crc=1,finobt=1,rmapbt=0,reflink=1,bigtime=1,inobtcount=1 /dev/loop1
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/loop1 /mnt/fstests/SCRATCH_DIR

generic/065       _check_xfs_filesystem: filesystem on /dev/loop1 is inconsistent (r)
(see /var/lib/xfstests/results//generic/065.full for details)
_check_dmesg: something found in dmesg (see /var/lib/xfstests/results//generic/065.dmesg)
- output mismatch (see /var/lib/xfstests/results//generic/065.out.bad)
    --- tests/generic/065.out	2023-10-27 09:04:38.185351816 -0400
    +++ /var/lib/xfstests/results//generic/065.out.bad	2023-10-27 09:09:12.145421405 -0400
    @@ -4,11 +4,11 @@
     wrote 65536/65536 bytes at offset 0
     XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
     File 'foo' content after log replay:
    -0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
    +0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
     *
     0020000
    ...
    (Run 'diff -u /var/lib/xfstests/tests/generic/065.out /var/lib/xfstests/results//generic/065.out.bad'  to see the entire diff)
Ran: generic/065
Failures: generic/065
Failed 1 of 1 tests

[2]
[  440.713107] run fstests generic/065 at 2023-10-27 09:09:11
[  440.971883] XFS (dm-3): Mounting V5 Filesystem 6d36b06f-6fbd-4a9f-925c-c49582f14078
[  440.972968] XFS (dm-3): Ending clean mount
[  441.037265] XFS (dm-3): Unmounting Filesystem 6d36b06f-6fbd-4a9f-925c-c49582f14078
[  441.045980] XFS (dm-3): Mounting V5 Filesystem 6d36b06f-6fbd-4a9f-925c-c49582f14078
[  441.046947] XFS (dm-3): Starting recovery (logdev: internal)
[  441.047283] XFS (dm-3): Ending recovery (logdev: internal)
[  441.055894] XFS: Assertion failed: ip->i_nblocks == 0, file: fs/xfs/xfs_inode.c, line: 2359
[  441.055920] ------------[ cut here ]------------
[  441.055921] WARNING: CPU: 3 PID: 212189 at fs/xfs/xfs_message.c:104 assfail+0x4e/0x68 [xfs]
[  441.056180] Modules linked in: dm_flakey tls loop lcs ctcm fsm qeth ccwgroup zfcp qdio scsi_transport_fc dasd_fba_mod dasd_eckd_mod dasd_mod rfkill sunrpc vfio_ccw mdev zcrypt_cex4 vfio_iommu_type1 vfio drm fuse i2c_core drm_panel_orientation_quirks xfs libcrc32c ghash_s390 prng aes_s390 virtio_net des_s390 sha3_512_s390 net_failover failover sha3_256_s390 virtio_blk dm_mirror dm_region_hash dm_log dm_mod pkey zcrypt
[  441.056210] CPU: 3 PID: 212189 Comm: kworker/3:5 Kdump: loaded Tainted: G        W          6.6.0-rc7+ #1
[  441.056213] Hardware name: IBM 3931 LA1 400 (KVM/Linux)
[  441.056215] Workqueue: xfs-inodegc/dm-3 xfs_inodegc_worker [xfs]
[  441.056312] Krnl PSW : 0704c00180000000 000003ff7ffb36d2 (assfail+0x52/0x68 [xfs])
[  441.056410]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
[  441.056413] Krnl GPRS: c000000100000021 000003ff8001d9a0 ffffffffffffffea 000000000000000a
[  441.056415]            00000380048aba90 0000000000000000 000003ff801272ba 0000000088f81488
[  441.056417]            00000000d6301708 000000008cb5d000 00000001c459c800 00000001c459c800
[  441.056419]            0000000081de3600 0000000000000000 000003ff7ffb36c0 00000380048abb38
[  441.056426] Krnl Code: 000003ff7ffb36c6: 95001010		cli	16(%r1),0
                          000003ff7ffb36ca: a774000a		brc	7,000003ff7ffb36de
                         #000003ff7ffb36ce: af000000		mc	0,0
                         >000003ff7ffb36d2: eb6ff0a80004	lmg	%r6,%r15,168(%r15)
                          000003ff7ffb36d8: 07fe		bcr	15,%r14
                          000003ff7ffb36da: 47000700		bc	0,1792
                          000003ff7ffb36de: af000000		mc	0,0
                          000003ff7ffb36e2: 0707		bcr	0,%r7
[  441.056439] Call Trace:
[  441.056440]  [<000003ff7ffb36d2>] assfail+0x52/0x68 [xfs] 
[  441.056537] ([<000003ff7ffb36c0>] assfail+0x40/0x68 [xfs])
[  441.056635]  [<000003ff7ffaf3ca>] xfs_ifree+0x42a/0x478 [xfs] 
[  441.056737]  [<000003ff7ffaf4c8>] xfs_inactive_ifree+0xb0/0x210 [xfs] 
[  441.056815]  [<000003ff7ffaf7aa>] xfs_inactive+0x182/0x2e0 [xfs] 
[  441.056899]  [<000003ff7ffa1f0c>] xfs_inodegc_worker+0xf4/0x1c8 [xfs] 
[  441.056983]  [<000000003242f8f0>] process_one_work+0x1b8/0x408 
[  441.056989]  [<000000003242fe40>] worker_thread+0x300/0x460 
[  441.056992]  [<000000003243a758>] kthread+0x120/0x128 
[  441.056995]  [<00000000323b6fcc>] __ret_from_fork+0x3c/0x58 
[  441.056997]  [<0000000032da7072>] ret_from_fork+0xa/0x30 
[  441.057003] Last Breaking-Event-Address:
[  441.057004]  [<000003ff7ffb351c>] xfs_printk_level+0xac/0xd8 [xfs]
[  441.057095] ---[ end trace 0000000000000000 ]---
[  441.060319] XFS (dm-3): Unmounting Filesystem 6d36b06f-6fbd-4a9f-925c-c49582f14078
[  441.109229] XFS (loop0): Unmounting Filesystem 1eef4fa0-3548-491e-a877-16ca42a411b6

[3]
meta-data=/dev/loop1             isize=512    agcount=4, agsize=655360 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
data     =                       bsize=4096   blocks=2621440, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
Discarding blocks...Done.
_check_xfs_filesystem: filesystem on /dev/loop1 is inconsistent (r)
*** xfs_repair -n output ***
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
bad nblocks 16 for inode 133, would reset to 0
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 2
        - agno = 1
bad nblocks 16 for inode 133, would reset to 0
        - agno = 3
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.
*** end xfs_repair output
*** mount output ***
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime,seclabel)
devtmpfs on /dev type devtmpfs (rw,nosuid,seclabel,size=4096k,nr_inodes=986186,mode=755,inode64)
securityfs on /sys/kernel/security type securityfs (rw,nosuid,nodev,noexec,relatime)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev,seclabel,inode64)
devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,seclabel,gid=5,mode=620,ptmxmode=000)
tmpfs on /run type tmpfs (rw,nosuid,nodev,seclabel,size=1592372k,nr_inodes=819200,mode=755,inode64)
cgroup2 on /sys/fs/cgroup type cgroup2 (rw,nosuid,nodev,noexec,relatime,seclabel,nsdelegate,memory_recursiveprot)
pstore on /sys/fs/pstore type pstore (rw,nosuid,nodev,noexec,relatime,seclabel)
bpf on /sys/fs/bpf type bpf (rw,nosuid,nodev,noexec,relatime,mode=700)
/dev/mapper/rhel_s390x--kvm--091-root on / type xfs (rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,noquota)
selinuxfs on /sys/fs/selinux type selinuxfs (rw,nosuid,noexec,relatime)
systemd-1 on /proc/sys/fs/binfmt_misc type autofs (rw,relatime,fd=29,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=3937)
mqueue on /dev/mqueue type mqueue (rw,nosuid,nodev,noexec,relatime,seclabel)
debugfs on /sys/kernel/debug type debugfs (rw,nosuid,nodev,noexec,relatime,seclabel)
tracefs on /sys/kernel/tracing type tracefs (rw,nosuid,nodev,noexec,relatime,seclabel)
hugetlbfs on /dev/hugepages type hugetlbfs (rw,relatime,seclabel,pagesize=1M)
configfs on /sys/kernel/config type configfs (rw,nosuid,nodev,noexec,relatime)
fusectl on /sys/fs/fuse/connections type fusectl (rw,nosuid,nodev,noexec,relatime)
ramfs on /run/credentials/systemd-sysctl.service type ramfs (ro,nosuid,nodev,noexec,relatime,seclabel,mode=700)
ramfs on /run/credentials/systemd-tmpfiles-setup-dev.service type ramfs (ro,nosuid,nodev,noexec,relatime,seclabel,mode=700)
/dev/vda1 on /boot type xfs (rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,noquota)
/dev/mapper/rhel_s390x--kvm--091-home on /home type xfs (rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,noquota)
ramfs on /run/credentials/systemd-tmpfiles-setup.service type ramfs (ro,nosuid,nodev,noexec,relatime,seclabel,mode=700)
sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw,relatime)
tmpfs on /run/user/0 type tmpfs (rw,nosuid,nodev,relatime,seclabel,size=796184k,nr_inodes=199046,mode=700,inode64)
*** end mount output

[3]
[ 3078.795314] run fstests generic/506 at 2023-10-27 09:53:09
[ 3079.005423] XFS (loop1): Mounting V5 Filesystem c94f4c60-e4fd-4fec-b130-e245b3880061
[ 3079.006596] XFS (loop1): Ending clean mount
[ 3079.007556] XFS (loop1): User initiated shutdown received.
[ 3079.007565] XFS (loop1): Metadata I/O Error (0x4) detected at xfs_fs_goingdown+0x5a/0xf8 [xfs] (fs/xfs/xfs_fsops.c:492).  Shutting down filesystem.
[ 3079.007769] XFS (loop1): Please unmount the filesystem and rectify the problem(s)
[ 3079.008944] XFS (loop1): Unmounting Filesystem c94f4c60-e4fd-4fec-b130-e245b3880061
[ 3079.031168] XFS (loop1): Mounting V5 Filesystem ba7c075d-3018-49c9-a17d-0689c02892e2
[ 3079.032478] XFS (loop1): Ending clean mount
[ 3079.032515] XFS (loop1): Quotacheck needed: Please wait.
[ 3079.036144] XFS (loop1): Quotacheck: Done.
[ 3079.040399] XFS (loop1): Unmounting Filesystem ba7c075d-3018-49c9-a17d-0689c02892e2
[ 3079.044961] XFS (loop1): Mounting V5 Filesystem ba7c075d-3018-49c9-a17d-0689c02892e2
[ 3079.045808] XFS (loop1): Ending clean mount
[ 3079.055991] XFS (loop1): User initiated shutdown received.
[ 3079.055994] XFS (loop1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xb4/0xf8 [xfs] (fs/xfs/xfs_fsops.c:495).  Shutting down filesystem.
[ 3079.056076] XFS (loop1): Please unmount the filesystem and rectify the problem(s)
[ 3079.099382] XFS (loop1): Unmounting Filesystem ba7c075d-3018-49c9-a17d-0689c02892e2
[ 3079.102254] XFS (loop1): Mounting V5 Filesystem ba7c075d-3018-49c9-a17d-0689c02892e2
[ 3079.103055] XFS (loop1): Starting recovery (logdev: internal)
[ 3079.103217] XFS (loop1): Ending recovery (logdev: internal)
[ 3079.106775] XFS (loop1): Unmounting Filesystem ba7c075d-3018-49c9-a17d-0689c02892e2
[ 3079.113727] XFS (loop1): Mounting V5 Filesystem ba7c075d-3018-49c9-a17d-0689c02892e2
[ 3079.114471] XFS (loop1): Ending clean mount
[ 3079.115334] XFS: Assertion failed: error != -ENOENT, file: fs/xfs/xfs_trans.c, line: 1310
[ 3079.115372] ------------[ cut here ]------------
[ 3079.115374] WARNING: CPU: 1 PID: 2035839 at fs/xfs/xfs_message.c:104 assfail+0x4e/0x68 [xfs]
[ 3079.115495] Modules linked in: dm_log_writes dm_thin_pool dm_persistent_data dm_bio_prison sd_mod t10_pi sg dm_snapshot dm_bufio ext4 mbcache jbd2 dm_flakey tls loop lcs ctcm fsm qeth ccwgroup zfcp qdio scsi_transport_fc dasd_fba_mod dasd_eckd_mod dasd_mod rfkill sunrpc vfio_ccw mdev zcrypt_cex4 vfio_iommu_type1 vfio drm fuse i2c_core drm_panel_orientation_quirks xfs libcrc32c ghash_s390 prng aes_s390 virtio_net des_s390 sha3_512_s390 net_failover failover sha3_256_s390 virtio_blk dm_mirror dm_region_hash dm_log dm_mod pkey zcrypt [last unloaded: scsi_debug]
[ 3079.115532] CPU: 1 PID: 2035839 Comm: touch Kdump: loaded Tainted: G        W          6.6.0-rc7+ #1
[ 3079.115534] Hardware name: IBM 3931 LA1 400 (KVM/Linux)
[ 3079.115536] Krnl PSW : 0704c00180000000 000003ff7ffb36d2 (assfail+0x52/0x68 [xfs])
[ 3079.115625]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
[ 3079.115627] Krnl GPRS: c000000100000021 000003ff8001d9a0 ffffffffffffffea 000000000000000a
[ 3079.115629]            0000038006d0f928 0000000000000000 000003ff80129d40 000000008f254398
[ 3079.115630]            0000038006d0fb20 000000008f254000 00000380fffffffe 00000000a12a8400
[ 3079.115632]            000003ff8762ef68 0000000000000000 000003ff7ffb36c0 0000038006d0f9d0
[ 3079.115638] Krnl Code: 000003ff7ffb36c6: 95001010		cli	16(%r1),0
                          000003ff7ffb36ca: a774000a		brc	7,000003ff7ffb36de
                         #000003ff7ffb36ce: af000000		mc	0,0
                         >000003ff7ffb36d2: eb6ff0a80004	lmg	%r6,%r15,168(%r15)
                          000003ff7ffb36d8: 07fe		bcr	15,%r14
                          000003ff7ffb36da: 47000700		bc	0,1792
                          000003ff7ffb36de: af000000		mc	0,0
                          000003ff7ffb36e2: 0707		bcr	0,%r7
[ 3079.115648] Call Trace:
[ 3079.115649]  [<000003ff7ffb36d2>] assfail+0x52/0x68 [xfs] 
[ 3079.115727] ([<000003ff7ffb36c0>] assfail+0x40/0x68 [xfs])
[ 3079.115803]  [<000003ff7ffc0c34>] xfs_trans_alloc_ichange+0x274/0x318 [xfs] 
[ 3079.115880]  [<000003ff7ffa9058>] xfs_setattr_nonsize+0xa0/0x478 [xfs] 
[ 3079.115966]  [<00000000327530ce>] notify_change+0x38e/0x530 
[ 3079.115972]  [<0000000032776fee>] vfs_utimes+0x12e/0x268 
[ 3079.115976]  [<000000003277740e>] do_utimes+0x6e/0xb0 
[ 3079.115980]  [<00000000327779de>] __s390x_sys_utimensat+0x86/0xc0 
[ 3079.115983]  [<0000000032d97060>] __do_syscall+0x1d0/0x1f8 
[ 3079.115988]  [<0000000032da7040>] system_call+0x70/0x98 
[ 3079.115992] Last Breaking-Event-Address:
[ 3079.115993]  [<000003ff7ffb351c>] xfs_printk_level+0xac/0xd8 [xfs]
[ 3079.116070] ---[ end trace 0000000000000000 ]---
[ 3079.127976] XFS (loop1): User initiated shutdown received.
[ 3079.127983] XFS (loop1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xb4/0xf8 [xfs] (fs/xfs/xfs_fsops.c:495).  Shutting down filesystem.
[ 3079.128127] XFS (loop1): Please unmount the filesystem and rectify the problem(s)
[ 3079.179362] XFS (loop1): Unmounting Filesystem ba7c075d-3018-49c9-a17d-0689c02892e2
[ 3079.182441] XFS (loop1): Mounting V5 Filesystem ba7c075d-3018-49c9-a17d-0689c02892e2
[ 3079.183327] XFS (loop1): Starting recovery (logdev: internal)
[ 3079.183464] XFS (loop1): Ending recovery (logdev: internal)
[ 3079.186928] XFS (loop1): Unmounting Filesystem ba7c075d-3018-49c9-a17d-0689c02892e2
[ 3079.198937] XFS (loop0): Unmounting Filesystem 1eef4fa0-3548-491e-a877-16ca42a411b6

