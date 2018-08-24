Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-co1nam03on0091.outbound.protection.outlook.com ([104.47.40.91]:32969
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726526AbeHXRTK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 Aug 2018 13:19:10 -0400
From: "Xu, Wen" <wen.xu@gatech.edu>
Subject: Out-of-bounds access in xfs_iext_last() found by fuzzing
Date: Fri, 24 Aug 2018 13:44:17 +0000
Message-ID: <9265CCFF-09F4-4271-B417-90581450FD58@gatech.edu>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9CD99B964E97584F8C9385B3D94F6DEE@namprd07.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>

Hi all,

I found a new bug through fuzzing. 

Check https://bugzilla.kernel.org/show_bug.cgi?id=200923 for details.

- Kernel message
[  452.231378] XFS (loop0): Unmounting Filesystem
[  509.564607] XFS (loop0): Mounting V4 Filesystem
[  509.564934] XFS (loop0): Log size 14877269 blocks too large, maximum size is 1048576 blocks
[  509.564938] XFS (loop0): Log size out of supported range.
[  509.566163] XFS (loop0): Continuing onwards, but if log hangs are experienced then please report this message in the bug report.
[  509.569856] XFS (loop0): totally zeroed log
[  509.570747] XFS (loop0): Ending clean mount
[  513.024230] XFS (loop0): Metadata corruption detected at xfs_allocbt_verify+0x16d/0x1d0, xfs_allocbt block 0x7f8
[  513.029651] XFS (loop0): Unmount and run xfs_repair
[  513.030663] XFS (loop0): First 128 bytes of corrupted metadata buffer:
[  513.032043] 0000000026b36fb2: fe ed ba be 00 00 00 00 00 00 00 02 00 00 00 00  ................
[  513.032818] XFS (loop0): Metadata corruption detected at xfs_dinode_verify+0x86c/0x900, inode 0x35da dinode
[  513.033819] 00000000a9ee8312: 00 00 00 00 00 00 07 d8 00 00 00 01 00 00 00 00  ................
[  513.035825] XFS (loop0): Unmount and run xfs_repair
[  513.037576] 00000000556b8e70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.038565] XFS (loop0): First 128 bytes of corrupted metadata buffer:
[  513.040343] 0000000054187ac6: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.041756] 00000000ed680b27: 49 4e a1 ff 02 01 00 00 00 00 00 00 00 00 00 00  IN..............
[  513.043532] 00000000f8507640: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.045370] 0000000049363c80: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 01  ................
[  513.047139] 00000000d383a558: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.048898] 00000000184fa3f0: 5b 43 7e d6 24 b1 7f 0d 5b 43 7e d6 24 b1 7f 0d  [C~.$...[C~.$...
[  513.050672] 0000000059de6927: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.052448] 00000000d1ed2cf4: 5b 43 7e d6 24 b1 7f 0d 00 00 00 00 12 00 00 0f  [C~.$...........
[  513.054220] 00000000857c056e: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.056006] 00000000c61f587d: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.059581] 000000004c39f790: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.061364] 0000000060816d19: ff ff ff ff 6d 6e 74 2f 66 6f 6f 2f 62 61 72 2f  ....mnt/foo/bar/
[  513.063161] 0000000049273748: 62 61 7a 00 00 00 00 00 00 00 00 00 00 00 00 00  baz.............
[  513.119875] XFS (loop0): Metadata corruption detected at xfs_dinode_verify+0x86c/0x900, inode 0x35da dinode
[  513.121909] XFS (loop0): Unmount and run xfs_repair
[  513.122919] XFS (loop0): First 128 bytes of corrupted metadata buffer:
[  513.124305] 00000000ed680b27: 49 4e a1 ff 02 01 00 00 00 00 00 00 00 00 00 00  IN..............
[  513.126082] 0000000049363c80: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 01  ................
[  513.127871] 00000000184fa3f0: 5b 43 7e d6 24 b1 7f 0d 5b 43 7e d6 24 b1 7f 0d  [C~.$...[C~.$...
[  513.129639] 00000000d1ed2cf4: 5b 43 7e d6 24 b1 7f 0d 00 00 00 00 12 00 00 0f  [C~.$...........
[  513.131439] 00000000c61f587d: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.133194] 000000004c39f790: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.134953] 0000000060816d19: ff ff ff ff 6d 6e 74 2f 66 6f 6f 2f 62 61 72 2f  ....mnt/foo/bar/
[  513.136733] 0000000049273748: 62 61 7a 00 00 00 00 00 00 00 00 00 00 00 00 00  baz.............
[  513.138526] XFS (loop0): Metadata corruption detected at xfs_allocbt_verify+0x16d/0x1d0, xfs_allocbt block 0x7f8
[  513.140649] XFS (loop0): Unmount and run xfs_repair
[  513.141685] XFS (loop0): First 128 bytes of corrupted metadata buffer:
[  513.143689] 0000000026b36fb2: fe ed ba be 00 00 00 00 00 00 00 02 00 00 00 00  ................
[  513.146023] 00000000a9ee8312: 00 00 00 00 00 00 07 d8 00 00 00 01 00 00 00 00  ................
[  513.148114] 00000000556b8e70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.149920] 0000000054187ac6: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.152545] 00000000f8507640: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.154417] 00000000d383a558: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.156206] 0000000059de6927: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.158071] 00000000857c056e: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.209697] XFS (loop0): Metadata corruption detected at xfs_allocbt_verify+0x16d/0x1d0, xfs_allocbt block 0x7f8
[  513.211833] XFS (loop0): Unmount and run xfs_repair
[  513.212831] XFS (loop0): First 128 bytes of corrupted metadata buffer:
[  513.214168] 0000000026b36fb2: fe ed ba be 00 00 00 00 00 00 00 02 00 00 00 00  ................
[  513.215968] 00000000a9ee8312: 00 00 00 00 00 00 07 d8 00 00 00 01 00 00 00 00  ................
[  513.217731] 00000000556b8e70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.219522] 0000000054187ac6: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.221280] 00000000f8507640: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.223064] 00000000d383a558: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.224799] 0000000059de6927: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.226571] 00000000857c056e: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.229089] XFS (loop0): Metadata corruption detected at xfs_dinode_verify+0x86c/0x900, inode 0x35da dinode
[  513.231088] XFS (loop0): Unmount and run xfs_repair
[  513.232075] XFS (loop0): First 128 bytes of corrupted metadata buffer:
[  513.233394] 00000000ed680b27: 49 4e a1 ff 02 01 00 00 00 00 00 00 00 00 00 00  IN..............
[  513.235156] 0000000049363c80: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 01  ................
[  513.236883] 00000000184fa3f0: 5b 43 7e d6 24 b1 7f 0d 5b 43 7e d6 24 b1 7f 0d  [C~.$...[C~.$...
[  513.238636] 00000000d1ed2cf4: 5b 43 7e d6 24 b1 7f 0d 00 00 00 00 12 00 00 0f  [C~.$...........
[  513.240404] 00000000c61f587d: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.242151] 000000004c39f790: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.243917] 0000000060816d19: ff ff ff ff 6d 6e 74 2f 66 6f 6f 2f 62 61 72 2f  ....mnt/foo/bar/
[  513.245663] 0000000049273748: 62 61 7a 00 00 00 00 00 00 00 00 00 00 00 00 00  baz.............
[  513.248219] XFS (loop0): Metadata corruption detected at xfs_allocbt_verify+0x16d/0x1d0, xfs_allocbt block 0x7f8
[  513.250291] XFS (loop0): Unmount and run xfs_repair
[  513.251332] XFS (loop0): First 128 bytes of corrupted metadata buffer:
[  513.252669] 0000000026b36fb2: fe ed ba be 00 00 00 00 00 00 00 02 00 00 00 00  ................
[  513.254447] 00000000a9ee8312: 00 00 00 00 00 00 07 d8 00 00 00 01 00 00 00 00  ................
[  513.256222] 00000000556b8e70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.257986] 0000000054187ac6: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.259778] 00000000f8507640: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.262236] 00000000d383a558: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.264028] 0000000059de6927: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.265793] 00000000857c056e: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.269180] XFS (loop0): Metadata corruption detected at xfs_allocbt_verify+0x16d/0x1d0, xfs_allocbt block 0x7f8
[  513.272134] XFS (loop0): Unmount and run xfs_repair
[  513.273331] XFS (loop0): First 128 bytes of corrupted metadata buffer:
[  513.274664] 0000000026b36fb2: fe ed ba be 00 00 00 00 00 00 00 02 00 00 00 00  ................
[  513.276466] 00000000a9ee8312: 00 00 00 00 00 00 07 d8 00 00 00 01 00 00 00 00  ................
[  513.278246] 00000000556b8e70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.280017] 0000000054187ac6: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.281790] 00000000f8507640: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.283572] 00000000d383a558: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.285328] 0000000059de6927: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.287107] 00000000857c056e: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.311462] XFS (loop0): page discard on page 0000000049f0b414, inode 0x35d5, offset 0.
[  513.313470] XFS (loop0): Metadata corruption detected at xfs_allocbt_verify+0x16d/0x1d0, xfs_allocbt block 0x7f8
[  513.315685] XFS (loop0): Unmount and run xfs_repair
[  513.316687] XFS (loop0): First 128 bytes of corrupted metadata buffer:
[  513.318274] 0000000026b36fb2: fe ed ba be 00 00 00 00 00 00 00 02 00 00 00 00  ................
[  513.320059] 00000000a9ee8312: 00 00 00 00 00 00 07 d8 00 00 00 01 00 00 00 00  ................
[  513.322111] 00000000556b8e70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.322672] ==================================================================
[  513.323897] 0000000054187ac6: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.325433] BUG: KASAN: slab-out-of-bounds in xfs_iext_last+0xeb/0x160
[  513.325438] Read of size 8 at addr ffff8801ef5eddf8 by task a.out/1501

[  513.325448] CPU: 1 PID: 1501 Comm: a.out Not tainted 4.18.0+ #9
[  513.327219] 00000000f8507640: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.328504] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[  513.329844] 00000000d383a558: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.330163] Call Trace:
[  513.331928] 0000000059de6927: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.333738]  dump_stack+0x7b/0xb5
[  513.335482]  print_address_description+0x70/0x290
[  513.335488]  kasan_report+0x291/0x390
[  513.335493]  ? xfs_iext_last+0xeb/0x160
[  513.335498] 00000000857c056e: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.337253]  __asan_load8+0x54/0x90
[  513.337259]  xfs_iext_last+0xeb/0x160
[  513.337268]  xfs_bmap_last_extent+0xd8/0x170
[  513.337275]  ? xfs_bmap_last_before+0x200/0x200
[  513.337285]  ? xfs_log_reserve+0x32e/0x3c0
[  513.337292]  xfs_bmap_last_offset+0xe8/0x1c0
[  513.337298]  ? xfs_bmap_last_extent+0x170/0x170
[  513.337305]  ? xfs_trans_reserve+0x13c/0x370
[  513.337311]  ? xfs_trans_add_item+0x5e/0xf0
[  513.337320]  xfs_iomap_write_allocate+0x2e6/0x6d0
[  513.337328]  ? xfs_file_iomap_begin+0xee0/0xee0
[  513.337336]  ? add_to_page_cache_lru+0xf4/0x190
[  513.337342]  ? add_to_page_cache_locked+0x20/0x20
[  513.337347]  ? __page_cache_alloc+0xcb/0xe0
[  513.337354]  ? xfs_find_daxdev_for_inode+0x5d/0x80
[  513.337360]  ? xfs_iext_lookup_extent+0x298/0x3d0
[  513.337367]  xfs_map_blocks+0x51a/0x770
[  513.337374]  ? xfs_vm_readpages+0xd0/0xd0
[  513.337379]  ? kasan_check_read+0x11/0x20
[  513.337388]  ? page_mkclean+0xe9/0x160
[  513.337394]  ? page_referenced+0x2a0/0x2a0
[  513.337400]  xfs_do_writepage+0x28f/0x640
[  513.337407]  ? xfs_add_to_ioend+0x610/0x610
[  513.337414]  ? clear_page_dirty_for_io+0x332/0x450
[  513.337419]  write_cache_pages+0x3cd/0x770
[  513.337426]  ? xfs_add_to_ioend+0x610/0x610
[  513.337432]  ? clear_page_dirty_for_io+0x450/0x450
[  513.337441]  ? up_write+0x16/0x40
[  513.337448]  ? xfs_iunlock+0x11a/0x150
[  513.337454]  xfs_vm_writepages+0xd3/0x130
[  513.337460]  ? xfs_vm_releasepage+0xc0/0xc0
[  513.337467]  ? aa_path_link+0x200/0x200
[  513.337473]  ? xfs_iunlock+0x12b/0x150
[  513.337479]  do_writepages+0x37/0xb0
[  513.337485]  __filemap_fdatawrite_range+0x19a/0x1f0
[  513.337491]  ? delete_from_page_cache_batch+0x4e0/0x4e0
[  513.337499]  ? kernel_read+0xa0/0xa0
[  513.337506]  ? common_file_perm+0x11b/0x2e0
[  513.337513]  file_write_and_wait_range+0x66/0xb0
[  513.337518]  xfs_file_fsync+0xf0/0x460
[  513.337524]  ? xfs_filemap_huge_fault+0x80/0x80
[  513.337530]  ? xfs_filemap_huge_fault+0x80/0x80
[  513.337540]  vfs_fsync_range+0x68/0x100
[  513.337546]  do_fsync+0x3d/0x70
[  513.337552]  __x64_sys_fsync+0x21/0x30
[  513.337560]  do_syscall_64+0x78/0x170
[  513.337567]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  513.337572] RIP: 0033:0x7ff96c5d44d9
[  513.337579] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 8f 29 2c 00 f7 d8 64 89 01 48
[  513.337582] RSP: 002b:00007ffe4847c438 EFLAGS: 00000286 ORIG_RAX: 000000000000004a
[  513.337589] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff96c5d44d9
[  513.337592] RDX: ffffffffffffff98 RSI: 00000000754d6461 RDI: 0000000000000005
[  513.337596] RBP: 00007ffe484806f0 R08: 00007ffe484807d8 R09: 00007ffe484807d8
[  513.337599] R10: 00007ffe484807d8 R11: 0000000000000286 R12: 0000000000400530
[  513.337602] R13: 00007ffe484807d0 R14: 0000000000000000 R15: 0000000000000000

[  513.337934] Allocated by task 1501:
[  513.338657]  save_stack+0x46/0xd0
[  513.338662]  kasan_kmalloc+0xad/0xe0
[  513.338666]  __kmalloc+0x117/0x230
[  513.338671]  kmem_alloc+0x91/0x120
[  513.338676]  xfs_iext_insert+0x804/0xa80
[  513.338682]  xfs_bmap_add_extent_hole_delay+0x1d0/0x5e0
[  513.338688]  xfs_bmapi_reserve_delalloc+0x46b/0x500
[  513.338693]  xfs_file_iomap_begin+0xc67/0xee0
[  513.338699]  iomap_apply+0xd7/0x200
[  513.338703]  iomap_file_buffered_write+0xa8/0xd0
[  513.338708]  xfs_file_buffered_aio_write+0x1f2/0x5b0
[  513.338712]  xfs_file_write_iter+0x16a/0x1a0
[  513.338716]  __vfs_write+0x286/0x410
[  513.338720]  vfs_write+0xf9/0x260
[  513.338724]  ksys_write+0xb4/0x140
[  513.338728]  __x64_sys_write+0x43/0x50
[  513.338733]  do_syscall_64+0x78/0x170
[  513.338738]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

[  513.339065] Freed by task 1:
[  513.339668]  save_stack+0x46/0xd0
[  513.339673]  __kasan_slab_free+0x13c/0x1a0
[  513.339677]  kasan_slab_free+0xe/0x10
[  513.339685]  kfree+0x8c/0x1c0
[  513.339691]  kfree_const+0x22/0x30
[  513.339696]  kernfs_put+0xd3/0x2c0
[  513.339704]  kernfs_evict_inode+0x3e/0x50
[  513.339710]  evict+0x16f/0x290
[  513.339714]  iput+0x280/0x300
[  513.339719]  dentry_unlink_inode+0x13d/0x180
[  513.339723]  __dentry_kill+0x16a/0x260
[  513.339727]  shrink_dentry_list+0xfa/0x260
[  513.339731]  shrink_dcache_parent+0xc1/0x110
[  513.339738]  vfs_rmdir+0x113/0x1b0
[  513.339743]  do_rmdir+0x308/0x330
[  513.339748]  __x64_sys_rmdir+0x24/0x30
[  513.339753]  do_syscall_64+0x78/0x170
[  513.339757]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

[  513.340084] The buggy address belongs to the object at ffff8801ef5edde0
                which belongs to the cache kmalloc-16 of size 16
[  513.342690] The buggy address is located 8 bytes to the right of
                16-byte region [ffff8801ef5edde0, ffff8801ef5eddf0)
[  513.345082] The buggy address belongs to the page:
[  513.346059] page:ffffea0007bd7b40 count:1 mapcount:0 mapping:ffff8801f6c03a40 index:0xffff8801ef5edbc0
[  513.347897] flags: 0x2ffff0000000100(slab)
[  513.348731] raw: 02ffff0000000100 ffffea00078b95c0 0000001200000012 ffff8801f6c03a40
[  513.350289] raw: ffff8801ef5edbc0 0000000080800066 00000001ffffffff 0000000000000000
[  513.351832] page dumped because: kasan: bad access detected

[  513.353292] Memory state around the buggy address:
[  513.354269]  ffff8801ef5edc80: fb fb fc fc fb fb fc fc fb fb fc fc fb fb fc fc
[  513.355707]  ffff8801ef5edd00: fb fb fc fc fb fb fc fc fb fb fc fc fb fb fc fc
[  513.357176] >ffff8801ef5edd80: fb fb fc fc fb fb fc fc fb fb fc fc 00 00 fc fc
[  513.358613]                                                                 ^
[  513.360055]  ffff8801ef5ede00: fb fb fc fc fb fb fc fc fb fb fc fc fb fb fc fc
[  513.361520]  ffff8801ef5ede80: fb fb fc fc fb fb fc fc 00 00 fc fc fb fb fc fc
[  513.362953] ==================================================================
[  513.364390] Disabling lock debugging due to kernel taint
[  513.370013] XFS (loop0): page discard on page 0000000049f0b414, inode 0x35d5, offset 0.
[  513.371729] XFS (loop0): Metadata corruption detected at xfs_allocbt_verify+0x16d/0x1d0, xfs_allocbt block 0x7f8
[  513.373814] XFS (loop0): Unmount and run xfs_repair
[  513.374813] XFS (loop0): First 128 bytes of corrupted metadata buffer:
[  513.376187] 0000000026b36fb2: fe ed ba be 00 00 00 00 00 00 00 02 00 00 00 00  ................
[  513.377962] 00000000a9ee8312: 00 00 00 00 00 00 07 d8 00 00 00 01 00 00 00 00  ................
[  513.379755] 00000000556b8e70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.381531] 0000000054187ac6: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.383315] 00000000f8507640: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.385080] 00000000d383a558: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.386841] 0000000059de6927: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.388621] 00000000857c056e: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  513.391327] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
[  513.392917] PGD 80000001e3919067 P4D 80000001e3919067 PUD 1efed6067 PMD 0
[  513.394302] Oops: 0000 [#1] SMP KASAN PTI
[  513.395121] CPU: 0 PID: 1501 Comm: a.out Tainted: G    B             4.18.0+ #9
[  513.396589] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[  513.398480] RIP: 0010:xfs_bmap_longest_free_extent+0x4f/0xf0
[  513.399617] Code: 4d c8 e8 04 5c d2 ff 4d 8b 6c 24 30 44 89 fe 4c 89 ef e8 84 32 06 00 48 89 c3 48 83 c0 10 48 89 c7 48 89 45 d0 e8 41 59 d2 ff <80> 7b 10 00 75 29 4c 89 e6 b9 01 00 00 00 44 89 fa 4c 89 ef e8 48
[  513.403312] RSP: 0018:ffff8801de7b7610 EFLAGS: 00010292
[  513.404366] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffffa568486f
[  513.405798] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000010
[  513.407216] RBP: ffff8801de7b7648 R08: ffffed003bcf6f0e R09: ffff8801de7b77d8
[  513.408627] R10: 0000000000000005 R11: ffffed003bcf6f0d R12: ffff8801e5f374a0
[  513.410045] R13: ffff8801ddad3300 R14: ffff8801de7b7798 R15: 0000000000010a00
[  513.411464] FS:  00007ff96cab8700(0000) GS:ffff8801f7000000(0000) knlGS:0000000000000000
[  513.413072] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  513.414209] CR2: 0000000000000010 CR3: 00000001f0912000 CR4: 00000000000006f0
[  513.415616] Call Trace:
[  513.416125]  xfs_bmap_btalloc_nullfb+0x14b/0x250
[  513.417065]  ? xfs_bmap_btalloc_filestreams+0x320/0x320
[  513.418120]  xfs_bmap_btalloc+0x984/0xdb0
[  513.418942]  ? xfs_bmap_adjacent+0x7c0/0x7c0
[  513.419813]  ? kmem_cache_alloc+0xc9/0x1e0
[  513.420647]  ? kmem_zone_alloc+0x91/0x120
[  513.421470]  ? xfs_iext_lookup_extent+0x298/0x3d0
[  513.422413]  xfs_bmap_alloc+0x78/0x90
[  513.423163]  xfs_bmapi_write+0x8b2/0x10a0
[  513.423985]  ? xfs_bmapi_read+0x620/0x620
[  513.424809]  ? xlog_space_left+0x7f/0x130
[  513.425638]  ? kasan_check_write+0x14/0x20
[  513.426472]  ? xlog_grant_add_space.isra.8+0x59/0xb0
[  513.427483]  ? xfs_trans_add_item+0x5e/0xf0
[  513.428336]  xfs_alloc_file_space+0x2f3/0x590
[  513.429234]  ? xfs_prepare_shift+0xd0/0xd0
[  513.430067]  ? xfs_break_layouts+0x117/0x1e0
[  513.430933]  ? aa_path_link+0x200/0x200
[  513.431709]  ? xfs_update_prealloc_flags+0x1b0/0x1b0
[  513.432720]  ? __filemap_fdatawrite_range+0x1a5/0x1f0
[  513.433748]  ? _cond_resched+0x1a/0x50
[  513.434507]  ? down_write+0x41/0x50
[  513.435222]  ? xfs_reflink_unshare+0x2b/0x249
[  513.436103]  xfs_file_fallocate+0x433/0x540
[  513.436956]  ? errseq_check_and_advance+0x54/0x80
[  513.437923]  ? xfs_break_layouts+0x1e0/0x1e0
[  513.438793]  ? common_file_perm+0x11b/0x2e0
[  513.439645]  ? apparmor_task_setrlimit+0x270/0x270
[  513.440609]  ? xfs_file_fsync+0xf0/0x460
[  513.441420]  ? apparmor_file_permission+0x1a/0x20
[  513.442368]  ? xfs_break_layouts+0x1e0/0x1e0
[  513.443235]  vfs_fallocate+0x1e1/0x390
[  513.444000]  ksys_fallocate+0x41/0x70
[  513.444749]  __x64_sys_fallocate+0x55/0x60
[  513.445600]  do_syscall_64+0x78/0x170
[  513.446356]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  513.447378] RIP: 0033:0x7ff96c5d44d9
[  513.448116] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 8f 29 2c 00 f7 d8 64 89 01 48
[  513.451841] RSP: 002b:00007ffe4847c438 EFLAGS: 00000286 ORIG_RAX: 000000000000011d
[  513.453365] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff96c5d44d9
[  513.454783] RDX: 00000000000005ba RSI: 0000000000000041 RDI: 0000000000000003
[  513.456197] RBP: 00007ffe484806f0 R08: 00007ffe484807d8 R09: 00007ffe484807d8
[  513.457625] R10: 0000000000000db7 R11: 0000000000000286 R12: 0000000000400530
[  513.459049] R13: 00007ffe484807d0 R14: 0000000000000000 R15: 0000000000000000
[  513.460466] Modules linked in: snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hwdep snd_hda_core snd_pcm snd_timer snd soundcore mac_hid i2c_piix4 ib_iser rdma_cm iw_cm ib_cm ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx raid1 raid0 multipath linear 8139too qxl drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crct10dif_pclmul crc32_pclmul aesni_intel drm aes_x86_64 crypto_simd cryptd glue_helper 8139cp mii pata_acpi floppy
[  513.469993] CR2: 0000000000000010
[  513.470741] ---[ end trace 754084f7e4b34756 ]---
[  513.471711] RIP: 0010:xfs_bmap_longest_free_extent+0x4f/0xf0

-Wen
