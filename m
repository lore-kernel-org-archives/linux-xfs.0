Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C17AC4332F
	for <linux-xfs@archiver.kernel.org>; Sun, 29 Oct 2023 04:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjJ2EM0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 29 Oct 2023 00:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjJ2EMY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 29 Oct 2023 00:12:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74949CA
        for <linux-xfs@vger.kernel.org>; Sat, 28 Oct 2023 21:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698552692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=fsQ76kSpxpgkXQwD2Of978hkohjeDbuaKTUVPxc3kFk=;
        b=SVkbTP9MM8ariXzBKmVVHwCImm8CZ9jcNzqCYzXc6x3OwaMiY48v6zXIDLJUh4qwFbjyAG
        FbJ/sc17tdTDc/RtiadLqADwJ85Qx2ji/2bpk7kv6tPlT3izLRIZBVpRRjBUBtZc6m1URp
        dhxG8mX27VF15qlWIHDB3BVfpB2ALn4=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-692-wI_U02i_OoGIcJsYsbLxjg-1; Sun, 29 Oct 2023 00:11:30 -0400
X-MC-Unique: wI_U02i_OoGIcJsYsbLxjg-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-6b2018a11e2so3409097b3a.2
        for <linux-xfs@vger.kernel.org>; Sat, 28 Oct 2023 21:11:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698552689; x=1699157489;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fsQ76kSpxpgkXQwD2Of978hkohjeDbuaKTUVPxc3kFk=;
        b=JmAd61/egJW0LSXVIxmTRUbTDBWybRXGgD4bace9uTFz49ZDd0eCsCpReQnkd0foPD
         rEYIausMsAtKnqKNMdmd1hVqISlDPIM/otP6m8HAq0BAsSy4oYcnR/pbJASl2fDtwpkG
         lwLLU8a4qlYhb3RqUeAXKMI7DyJXQ7hskeTxGf5seY3kOpB3zlDlj/mBBCHJPGop0CeW
         zGloMOuHsK2nY/2kDjuGBXy+qwQiYJsGcN+WfNHOVtENsTs5o7YCSO2MhmuaSlXzLztK
         q298dlerHoC44EE/ljO3xmK969sr1S1MNGtdMgXaxURHNxNPckPiG3opRWS0DB4ZAxbl
         mHGQ==
X-Gm-Message-State: AOJu0YwHLpU2CntoBdXoJiOESQaaj44AJKCBUJQBA0NP8ilF4+QiFxXD
        ScKnZfKTroDd0taC5r4QgrN3eE0cYcAMwQoLuvQ985f6rh7yM1RGq7wwnO3E7EhG1ITJc/Ts3KH
        fS9s1tbOb0TIjjz/HgnI04a2PN9NUNFILhzj0jRJIwMhG9WCO/MP+QReSFriW5//2iyz0UXvegx
        6Mg0sY8w==
X-Received: by 2002:a05:6a20:cea4:b0:17d:d70f:a2c3 with SMTP id if36-20020a056a20cea400b0017dd70fa2c3mr7701846pzb.20.1698552688683;
        Sat, 28 Oct 2023 21:11:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEbl+6pHo9yMUOhoSA4wABmsyCeh/JcrHEFaT/o+/7/TnBbEo8tz1RdKTODIEhUq2LbdyuJzQ==
X-Received: by 2002:a05:6a20:cea4:b0:17d:d70f:a2c3 with SMTP id if36-20020a056a20cea400b0017dd70fa2c3mr7701824pzb.20.1698552688015;
        Sat, 28 Oct 2023 21:11:28 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id a3-20020a17090a740300b00263cca08d95sm1665340pjg.55.2023.10.28.21.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Oct 2023 21:11:27 -0700 (PDT)
Date:   Sun, 29 Oct 2023 12:11:22 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     fstests@vger.kernel.org
Subject: [Bug report][fstests generic/047] Internal error !(flags &
 XFS_DABUF_MAP_HOLE_OK) at line 2572 of file fs/xfs/libxfs/xfs_da_btree.c.
  Caller xfs_dabuf_map.constprop.0+0x26c/0x368 [xfs]
Message-ID: <20231029041122.bx2k7wwm7otebjd5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi xfs list,

Recently I always hit xfs corruption by running fstests generic/047 [1], and
it show more failures in dmesg[2], e.g:

  XFS (loop1): Internal error !(flags & XFS_DABUF_MAP_HOLE_OK) at line 2572 of file fs/xfs/libxfs/xfs_da_btree.c.  Caller xfs_dabuf_map.constprop.0+0x26c/0x368 [xfs]

The .full output lots of curruption messages [3].

Currently I only hit this issue on s390x, haven't hit it on x86_64 or ppc64le
or aarch64. The mkfs option isn't related, even on overlayfs (base on xfs)
still hit this issue.

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

generic/047       _check_xfs_filesystem: filesystem on /dev/loop1 failed scrub
(see /var/lib/xfstests/results//generic/047.full for details)
_check_xfs_filesystem: filesystem on /dev/loop1 is inconsistent (r)
(see /var/lib/xfstests/results//generic/047.full for details)
_check_dmesg: something found in dmesg (see /var/lib/xfstests/results//generic/047.dmesg)
- output mismatch (see /var/lib/xfstests/results//generic/047.out.bad)
    --- tests/generic/047.out	2023-10-27 09:04:38.145351816 -0400
    +++ /var/lib/xfstests/results//generic/047.out.bad	2023-10-27 09:08:12.475381462 -0400
    @@ -1 +1,1000 @@
     QA output created by 047
    +file /mnt/fstests/SCRATCH_DIR/1 missing - fsync failed
    +file /mnt/fstests/SCRATCH_DIR/2 missing - fsync failed
    +file /mnt/fstests/SCRATCH_DIR/3 missing - fsync failed
    +file /mnt/fstests/SCRATCH_DIR/4 missing - fsync failed
    +file /mnt/fstests/SCRATCH_DIR/5 missing - fsync failed
    +file /mnt/fstests/SCRATCH_DIR/6 missing - fsync failed
    ...
    (Run 'diff -u /var/lib/xfstests/tests/generic/047.out /var/lib/xfstests/results//generic/047.out.bad'  to see the entire diff)
Ran: generic/047
Failures: generic/047
Failed 1 of 1 tests



[2]
[  376.468885] run fstests generic/047 at 2023-10-27 09:08:07
 [  376.675751] XFS (loop1): Mounting V5 Filesystem 716c9687-ee74-4c12-b6ad-a0b513194f2b
 [  376.677088] XFS (loop1): Ending clean mount
 [  376.678189] XFS (loop1): User initiated shutdown received.
 [  376.678194] XFS (loop1): Metadata I/O Error (0x4) detected at xfs_fs_goingdown+0x5a/0xf8 [xfs] (fs/xfs/xfs_fsops.c:492).  Shutting down filesystem.
 [  376.678409] XFS (loop1): Please unmount the filesystem and rectify the problem(s)
 [  376.679423] XFS (loop1): Unmounting Filesystem 716c9687-ee74-4c12-b6ad-a0b513194f2b
 [  376.714910] XFS (loop1): Mounting V5 Filesystem 40196bb2-39f4-4c32-83ef-567f42216699
 [  376.716353] XFS (loop1): Ending clean mount
 [  380.375878] XFS (loop1): User initiated shutdown received.
 [  380.375888] XFS (loop1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xb4/0xf8 [xfs] (fs/xfs/xfs_fsops.c:495).  Shutting down filesystem.
 [  380.376101] XFS (loop1): Please unmount the filesystem and rectify the problem(s)
 [  380.380373] XFS (loop1): Unmounting Filesystem 40196bb2-39f4-4c32-83ef-567f42216699
 [  380.383835] XFS (loop1): Mounting V5 Filesystem 40196bb2-39f4-4c32-83ef-567f42216699
 [  380.397086] XFS (loop1): Starting recovery (logdev: internal)
 [  380.465934] XFS (loop1): Ending recovery (logdev: internal)
 [  380.467409] XFS (loop1): Unmounting Filesystem 40196bb2-39f4-4c32-83ef-567f42216699
 [  380.475431] XFS (loop1): Mounting V5 Filesystem 40196bb2-39f4-4c32-83ef-567f42216699
 [  380.477235] XFS (loop1): Ending clean mount
 [  380.477500] XFS (loop1): Internal error !(flags & XFS_DABUF_MAP_HOLE_OK) at line 2572 of file fs/xfs/libxfs/xfs_da_btree.c.  Caller xfs_dabuf_map.constprop.0+0x26c/0x368 [xfs]
 [  380.477636] CPU: 0 PID: 337362 Comm: 047 Kdump: loaded Tainted: G        W          6.6.0-rc7+ #1
 [  380.477639] Hardware name: IBM 3931 LA1 400 (KVM/Linux)
 [  380.477641] Call Trace:
 [  380.477642]  [<0000000032d71372>] dump_stack_lvl+0x62/0x80 
 [  380.477648]  [<000003ff7ff96c00>] xfs_corruption_error+0x70/0xa0 [xfs] 
 [  380.477762]  [<000003ff7ff551ce>] xfs_dabuf_map.constprop.0+0x2a6/0x368 [xfs] 
 [  380.477871]  [<000003ff7ff5773e>] xfs_da_read_buf+0x6e/0x128 [xfs] 
 [  380.477977]  [<000003ff7ff57838>] xfs_da3_node_read+0x40/0x78 [xfs] 
 [  380.478085]  [<000003ff7ff58c7a>] xfs_da3_node_lookup_int+0x82/0x558 [xfs] 
 [  380.478193]  [<000003ff7ff68d6e>] xfs_dir2_node_lookup+0x3e/0x140 [xfs] 
 [  380.478302]  [<000003ff7ff5cfd2>] xfs_dir_lookup+0x1ea/0x218 [xfs] 
 [  380.478410]  [<000003ff7fface40>] xfs_lookup+0x60/0x108 [xfs] 
 [  380.478525]  [<000003ff7ffa9d42>] xfs_vn_lookup+0x62/0x98 [xfs] 
 [  380.478641]  [<0000000032738cfa>] __lookup_slow+0x9a/0x148 
 [  380.478647]  [<000000003273dc86>] walk_component+0x126/0x1b8 
 [  380.478650]  [<000000003273e948>] path_lookupat+0x88/0x1e8 
 [  380.478653]  [<000000003273f66a>] filename_lookup+0xaa/0x198 
 [  380.478656]  [<00000000327306d0>] vfs_statx+0x90/0x160 
 [  380.478659]  [<0000000032730a1e>] vfs_fstatat+0x86/0xe8 
 [  380.478661]  [<0000000032730c98>] __do_sys_newfstatat+0x28/0x48 
 [  380.478663]  [<0000000032d97060>] __do_syscall+0x1d0/0x1f8 
 [  380.478668]  [<0000000032da7040>] system_call+0x70/0x98 
 [  380.478672] XFS (loop1): Corruption detected. Unmount and run xfs_repair
 [  380.478674] XFS (loop1): xfs_dabuf_map: bno 8388608 inode 128
 [  380.478676] XFS (loop1): [00] br_startoff 8388608 br_startblock -2 br_blockcount 1 br_state 0
 [  380.478711] XFS (loop1): Internal error !(flags & XFS_DABUF_MAP_HOLE_OK) at line 2572 of file fs/xfs/libxfs/xfs_da_btree.c.  Caller xfs_dabuf_map.constprop.0+0x26c/0x368 [xfs]
 [  380.478818] CPU: 0 PID: 337362 Comm: 047 Kdump: loaded Tainted: G        W          6.6.0-rc7+ #1
 [  380.478820] Hardware name: IBM 3931 LA1 400 (KVM/Linux)
 [  380.478821] Call Trace:
 [  380.478822]  [<0000000032d71372>] dump_stack_lvl+0x62/0x80 
 [  380.478825]  [<000003ff7ff96c00>] xfs_corruption_error+0x70/0xa0 [xfs] 
 [  380.478939]  [<000003ff7ff551ce>] xfs_dabuf_map.constprop.0+0x2a6/0x368 [xfs] 
 [  380.479047]  [<000003ff7ff5773e>] xfs_da_read_buf+0x6e/0x128 [xfs] 
 [  380.479155]  [<000003ff7ff57838>] xfs_da3_node_read+0x40/0x78 [xfs] 
 [  380.479263]  [<000003ff7ff58c7a>] xfs_da3_node_lookup_int+0x82/0x558 [xfs] 
 [  380.479370]  [<000003ff7ff68d6e>] xfs_dir2_node_lookup+0x3e/0x140 [xfs] 
 [  380.479480]  [<000003ff7ff5cfd2>] xfs_dir_lookup+0x1ea/0x218 [xfs] 
 [  380.479594]  [<000003ff7fface40>] xfs_lookup+0x60/0x108 [xfs] 
 [  380.479710]  [<000003ff7ffa9d42>] xfs_vn_lookup+0x62/0x98 [xfs] 
 [  380.479826]  [<0000000032738cfa>] __lookup_slow+0x9a/0x148 
 [  380.479829]  [<000000003273dc86>] walk_component+0x126/0x1b8 
 [  380.479832]  [<000000003273e948>] path_lookupat+0x88/0x1e8 
 [  380.479835]  [<000000003273f66a>] filename_lookup+0xaa/0x198 
 [  380.479837]  [<00000000327306d0>] vfs_statx+0x90/0x160 
 [  380.479840]  [<0000000032730a1e>] vfs_fstatat+0x86/0xe8 
 [  380.479842]  [<0000000032730c98>] __do_sys_newfstatat+0x28/0x48 
 [  380.479844]  [<0000000032d97060>] __do_syscall+0x1d0/0x1f8 
 [  380.479847]  [<0000000032da7040>] system_call+0x70/0x98 
 [  380.479850] XFS (loop1): Corruption detected. Unmount and run xfs_repair
 [  380.479852] XFS (loop1): xfs_dabuf_map: bno 8388608 inode 128
 [  380.479887] XFS (loop1): [00] br_startoff 8388608 br_startblock -2 br_blockcount 1 br_state 0
 [  380.479912] XFS (loop1): Internal error !(flags & XFS_DABUF_MAP_HOLE_OK) at line 2572 of file fs/xfs/libxfs/xfs_da_btree.c.  Caller xfs_dabuf_map.constprop.0+0x26c/0x368 [xfs]
 [  380.480022] CPU: 0 PID: 337362 Comm: 047 Kdump: loaded Tainted: G        W          6.6.0-rc7+ #1
 [  380.480024] Hardware name: IBM 3931 LA1 400 (KVM/Linux)
 [  380.480026] Call Trace:
 [  380.480026]  [<0000000032d71372>] dump_stack_lvl+0x62/0x80 
 [  380.480029]  [<000003ff7ff96c00>] xfs_corruption_error+0x70/0xa0 [xfs] 
 [  380.480143]  [<000003ff7ff551ce>] xfs_dabuf_map.constprop.0+0x2a6/0x368 [xfs] 
 [  380.480253]  [<000003ff7ff5773e>] xfs_da_read_buf+0x6e/0x128 [xfs] 
 [  380.480360]  [<000003ff7ff57838>] xfs_da3_node_read+0x40/0x78 [xfs] 
 [  380.480467]  [<000003ff7ff58c7a>] xfs_da3_node_lookup_int+0x82/0x558 [xfs] 
 [  380.480576]  [<000003ff7ff68d6e>] xfs_dir2_node_lookup+0x3e/0x140 [xfs] 
 [  380.480683]  [<000003ff7ff5cfd2>] xfs_dir_lookup+0x1ea/0x218 [xfs] 
 [  380.480791]  [<000003ff7fface40>] xfs_lookup+0x60/0x108 [xfs] 
 [  380.480907]  [<000003ff7ffa9d42>] xfs_vn_lookup+0x62/0x98 [xfs] 
 [  380.481021]  [<0000000032738cfa>] __lookup_slow+0x9a/0x148 
 [  380.481024]  [<000000003273dc86>] walk_component+0x126/0x1b8 
 [  380.481027]  [<000000003273e948>] path_lookupat+0x88/0x1e8 
 [  380.481030]  [<000000003273f66a>] filename_lookup+0xaa/0x198 
 [  380.481033]  [<00000000327306d0>] vfs_statx+0x90/0x160 
 [  380.481036]  [<0000000032730a1e>] vfs_fstatat+0x86/0xe8 
 [  380.481038]  [<0000000032730c98>] __do_sys_newfstatat+0x28/0x48 
 [  380.481040]  [<0000000032d97060>] __do_syscall+0x1d0/0x1f8 
 [  380.481043]  [<0000000032da7040>] system_call+0x70/0x98 
 [  380.481051] XFS (loop1): Corruption detected. Unmount and run xfs_repair
 [  380.481053] XFS (loop1): xfs_dabuf_map: bno 8388608 inode 128
 [  380.481054] XFS (loop1): [00] br_startoff 8388608 br_startblock -2 br_blockcount 1 br_state 0
 [  380.481080] XFS (loop1): Internal error !(flags & XFS_DABUF_MAP_HOLE_OK) at line 2572 of file fs/xfs/libxfs/xfs_da_btree.c.  Caller xfs_dabuf_map.constprop.0+0x26c/0x368 [xfs]
 [  380.481189] CPU: 0 PID: 337362 Comm: 047 Kdump: loaded Tainted: G        W          6.6.0-rc7+ #1
 [  380.481191] Hardware name: IBM 3931 LA1 400 (KVM/Linux)
 [  380.481192] Call Trace:
 [  380.481193]  [<0000000032d71372>] dump_stack_lvl+0x62/0x80 
 [  380.481195]  [<000003ff7ff96c00>] xfs_corruption_error+0x70/0xa0 [xfs] 
 [  380.481310]  [<000003ff7ff551ce>] xfs_dabuf_map.constprop.0+0x2a6/0x368 [xfs] 
 [  380.481418]  [<000003ff7ff5773e>] xfs_da_read_buf+0x6e/0x128 [xfs] 
 [  380.481526]  [<000003ff7ff57838>] xfs_da3_node_read+0x40/0x78 [xfs] 
 [  380.481635]  [<000003ff7ff58c7a>] xfs_da3_node_lookup_int+0x82/0x558 [xfs] 
 [  380.481743]  [<000003ff7ff68d6e>] xfs_dir2_node_lookup+0x3e/0x140 [xfs] 
 [  380.481854]  [<000003ff7ff5cfd2>] xfs_dir_lookup+0x1ea/0x218 [xfs] 
 [  380.481961]  [<000003ff7fface40>] xfs_lookup+0x60/0x108 [xfs] 
 [  380.482076]  [<000003ff7ffa9d42>] xfs_vn_lookup+0x62/0x98 [xfs] 
 [  380.482191]  [<0000000032738cfa>] __lookup_slow+0x9a/0x148 
 [  380.482194]  [<000000003273dc86>] walk_component+0x126/0x1b8 
 [  380.482197]  [<000000003273e948>] path_lookupat+0x88/0x1e8 
 [  380.482200]  [<000000003273f66a>] filename_lookup+0xaa/0x198 
 [  380.482203]  [<00000000327306d0>] vfs_statx+0x90/0x160 
 [  380.482205]  [<0000000032730a1e>] vfs_fstatat+0x86/0xe8 
 [  380.482207]  [<0000000032730c98>] __do_sys_newfstatat+0x28/0x48 
 [  380.482209]  [<0000000032d97060>] __do_syscall+0x1d0/0x1f8 
 [  380.482212]  [<0000000032da7040>] system_call+0x70/0x98 
 [  380.482215] XFS (loop1): Corruption detected. Unmount and run xfs_repair
 [  380.482216] XFS (loop1): xfs_dabuf_map: bno 8388608 inode 128
 [  380.482218] XFS (loop1): [00] br_startoff 8388608 br_startblock -2 br_blockcount 1 br_state 0
 [  380.482242] XFS (loop1): Internal error !(flags & XFS_DABUF_MAP_HOLE_OK) at line 2572 of file fs/xfs/libxfs/xfs_da_btree.c.  Caller xfs_dabuf_map.constprop.0+0x26c/0x368 [xfs]
 [  380.482362] CPU: 0 PID: 337362 Comm: 047 Kdump: loaded Tainted: G        W          6.6.0-rc7+ #1
 [  380.482364] Hardware name: IBM 3931 LA1 400 (KVM/Linux)
 [  380.482365] Call Trace:
 [  380.482366]  [<0000000032d71372>] dump_stack_lvl+0x62/0x80 
 [  380.482368]  [<000003ff7ff96c00>] xfs_corruption_error+0x70/0xa0 [xfs] 
 [  380.482483]  [<000003ff7ff551ce>] xfs_dabuf_map.constprop.0+0x2a6/0x368 [xfs] 
 [  380.482591]  [<000003ff7ff5773e>] xfs_da_read_buf+0x6e/0x128 [xfs] 
 [  380.482696]  [<000003ff7ff57838>] xfs_da3_node_read+0x40/0x78 [xfs] 
 [  380.482804]  [<000003ff7ff58c7a>] xfs_da3_node_lookup_int+0x82/0x558 [xfs] 
 [  380.482910]  [<000003ff7ff68d6e>] xfs_dir2_node_lookup+0x3e/0x140 [xfs] 
 [  380.483020]  [<000003ff7ff5cfd2>] xfs_dir_lookup+0x1ea/0x218 [xfs] 
 [  380.483128]  [<000003ff7fface40>] xfs_lookup+0x60/0x108 [xfs] 
 [  380.483241]  [<000003ff7ffa9d42>] xfs_vn_lookup+0x62/0x98 [xfs] 
 [  380.483356]  [<0000000032738cfa>] __lookup_slow+0x9a/0x148 
 [  380.483359]  [<000000003273dc86>] walk_component+0x126/0x1b8 
 [  380.483362]  [<000000003273e948>] path_lookupat+0x88/0x1e8 
 [  380.483365]  [<000000003273f66a>] filename_lookup+0xaa/0x198 
 [  380.483368]  [<00000000327306d0>] vfs_statx+0x90/0x160 
 [  380.483370]  [<0000000032730a1e>] vfs_fstatat+0x86/0xe8 
 [  380.483372]  [<0000000032730c98>] __do_sys_newfstatat+0x28/0x48 
 [  380.483374]  [<0000000032d97060>] __do_syscall+0x1d0/0x1f8 
 [  380.483377]  [<0000000032da7040>] system_call+0x70/0x98 
 [  380.483380] XFS (loop1): Corruption detected. Unmount and run xfs_repair
 [  380.483382] XFS (loop1): xfs_dabuf_map: bno 8388608 inode 128
 [  380.483383] XFS (loop1): [00] br_startoff 8388608 br_startblock -2 br_blockcount 1 br_state 0
 ...
 ...
 [  381.349174] XFS (loop1): Corruption detected. Unmount and run xfs_repair
[  381.349175] XFS (loop1): xfs_dabuf_map: bno 8388608 inode 128
[  381.349177] XFS (loop1): [00] br_startoff 8388608 br_startblock -2 br_blockcount 1 br_state 0
[  381.350972] XFS (loop1): Internal error !(flags & XFS_DABUF_MAP_HOLE_OK) at line 2572 of file fs/xfs/libxfs/xfs_da_btree.c.  Caller xfs_dabuf_map.constprop.0+0x26c/0x368 [xfs]
[  381.351085] CPU: 1 PID: 339644 Comm: xfs_scrub Kdump: loaded Tainted: G        W          6.6.0-rc7+ #1
[  381.351088] Hardware name: IBM 3931 LA1 400 (KVM/Linux)
[  381.351090] Call Trace:
[  381.351091]  [<0000000032d71372>] dump_stack_lvl+0x62/0x80 
[  381.351093]  [<000003ff7ff96c00>] xfs_corruption_error+0x70/0xa0 [xfs] 
[  381.351191]  [<000003ff7ff551ce>] xfs_dabuf_map.constprop.0+0x2a6/0x368 [xfs] 
[  381.351283]  [<000003ff7ff5773e>] xfs_da_read_buf+0x6e/0x128 [xfs] 
[  381.351375]  [<000003ff7ff57838>] xfs_da3_node_read+0x40/0x78 [xfs] 
[  381.351467]  [<000003ff7ff58c7a>] xfs_da3_node_lookup_int+0x82/0x558 [xfs] 
[  381.351558]  [<000003ff7ff68d6e>] xfs_dir2_node_lookup+0x3e/0x140 [xfs] 
[  381.351651]  [<000003ff80008436>] xchk_dir_lookup+0x13e/0x1e0 [xfs] 
[  381.351745]  [<000003ff800078c2>] xchk_parent+0x82/0x168 [xfs] 
[  381.351840]  [<000003ff8000aa1a>] xfs_scrub_metadata+0x1c2/0x420 [xfs] 
[  381.351938]  [<000003ff7ffa3876>] xfs_ioc_scrub_metadata+0x5e/0xb0 [xfs] 
[  381.352035]  [<000003ff7ffa5d92>] xfs_file_ioctl+0x672/0x9f8 [xfs] 
[  381.352133]  [<0000000032744c9e>] __s390x_sys_ioctl+0xbe/0x100 
[  381.352135]  [<0000000032d97060>] __do_syscall+0x1d0/0x1f8 
[  381.352138]  [<0000000032da7040>] system_call+0x70/0x98 
[  381.352141] XFS (loop1): Corruption detected. Unmount and run xfs_repair
[  381.352143] XFS (loop1): xfs_dabuf_map: bno 8388608 inode 128
[  381.352174] XFS (loop1): [00] br_startoff 8388608 br_startblock -2 br_blockcount 1 br_state 0
[  381.418153] XFS (loop1): Unmounting Filesystem 40196bb2-39f4-4c32-83ef-567f42216699

[3]
_check_xfs_filesystem: filesystem on /dev/loop1 failed scrub
*** xfs_scrub -v -d -n output ***
EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
Phase 1: Find filesystem geometry.
/mnt/fstests/SCRATCH_DIR: using 2 threads to scrub.
Phase 2: Check internal metadata.
Info: AG 1 superblock: Optimization is possible. (scrub.c line 212)
Info: AG 2 superblock: Optimization is possible. (scrub.c line 212)
Info: AG 3 superblock: Optimization is possible. (scrub.c line 212)
Phase 3: Scan all inodes.
Corruption: inode 128 (0/128) inode record: Repairs are required. (scrub.c line 196)
Corruption: inode 128 (0/128) parent pointer: Repairs are required. (scrub.c line 196)
Corruption: inode 131 (0/131) inode record: Repairs are required. (scrub.c line 196)
...
Corruption: inode 58300 (0/58300) inode record: Repairs are required. (scrub.c line 196)
Corruption: inode 58301 (0/58301) inode record: Repairs are required. (scrub.c line 196)
Corruption: inode 58302 (0/58302) inode record: Repairs are required. (scrub.c line 196)
Corruption: inode 58303 (0/58303) inode record: Repairs are required. (scrub.c line 196)
Phase 5: Check directory tree.
Info: /mnt/fstests/SCRATCH_DIR: Filesystem has errors, skipping connectivity checks. (phase5.c line 393)
Phase 7: Check summary counters.
198.9MiB data used;  1.0K inodes used.
95.9MiB data found; 1.0K inodes found.
1.0K inodes counted; 1.0K inodes checked.
/mnt/fstests/SCRATCH_DIR: corruptions found: 1001
/mnt/fstests/SCRATCH_DIR: Re-run xfs_scrub without -n.
*** end xfs_scrub output
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
bad nblocks 9 for inode 128, would reset to 0
no . entry for directory 128
no .. entry for root directory 128
problem with directory contents in inode 128
would clear root inode 128
bad nblocks 8 for inode 131, would reset to 0
bad nblocks 8 for inode 132, would reset to 0
bad nblocks 8 for inode 133, would reset to 0
...
bad nblocks 8 for inode 62438, would reset to 0
bad nblocks 8 for inode 62439, would reset to 0
bad nblocks 8 for inode 62440, would reset to 0
bad nblocks 8 for inode 62441, would reset to 0
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
root inode would be lost
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
bad nblocks 9 for inode 128, would reset to 0
        - agno = 2
        - agno = 3
no . entry for directory 128
no .. entry for root directory 128
problem with directory contents in inode 128
would clear root inode 128
bad nblocks 8 for inode 131, would reset to 0
bad nblocks 8 for inode 132, would reset to 0
bad nblocks 8 for inode 133, would reset to 0
...
bad nblocks 8 for inode 62439, would reset to 0
bad nblocks 8 for inode 62440, would reset to 0
bad nblocks 8 for inode 62441, would reset to 0
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
would reinitialize root directory
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
disconnected inode 131, would move to lost+found
disconnected inode 132, would move to lost+found
disconnected inode 133, would move to lost+found
...
disconnected inode 62439, would move to lost+found
disconnected inode 62440, would move to lost+found
disconnected inode 62441, would move to lost+found
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

