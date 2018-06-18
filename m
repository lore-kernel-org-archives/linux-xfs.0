Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45948 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754227AbeFRUE1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jun 2018 16:04:27 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id A82652018F
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jun 2018 20:04:26 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200127] New: Kernel crashes in xfs_alloc_get_freelist() when
 writing to a corrupted xfs image
Date: Mon, 18 Jun 2018 20:04:24 +0000
Message-ID: <bug-200127-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=200127

            Bug ID: 200127
           Summary: Kernel crashes in xfs_alloc_get_freelist() when
                    writing to a corrupted xfs image
           Product: File System
           Version: 2.5
    Kernel Version: 4.17
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: wen.xu@gatech.edu
        Regression: No

Created attachment 276653
  --> https://bugzilla.kernel.org/attachment.cgi?id=276653&action=edit
The (compressed) crafted image which causes crash

- Reproduce
# mkdir mnt
# mount -t xfs final.img mnt
# gcc -o poc poc.c
# ./poc ./mnt

- POC (poc.c)
#define _GNU_SOURCE
#include <sys/types.h>
#include <sys/mount.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/xattr.h>

#include <dirent.h>
#include <errno.h>
#include <error.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <linux/falloc.h>
#include <linux/loop.h>

static void activity(char *mpoint) {

  char *foo_bar_baz;
  int err;

  static int buf[8192];
  memset(buf, 0, sizeof(buf));

  err = asprintf(&foo_bar_baz, "%s/foo/bar/baz", mpoint);

  int fd = open(foo_bar_baz, O_RDWR | O_TRUNC, 0777);
  if (fd >= 0) {
    write(fd, (char *)buf, 517);
    write(fd, (char *)buf, sizeof(buf));
    close(fd);
  }

}

int main(int argc, char *argv[]) {
  activity(argv[1]);
  return 0;
}

- Kernel message
[  928.647644] XFS (loop0): Mounting V5 Filesystem
[  928.695568] XFS (loop0): Ending clean mount
[  930.628501] XFS (loop0): Corruption warning: Metadata has LSN (32:0) ahead
of current LSN (1:237). Please unmount and run xfs_repair (>= v4.3) to resolve.
[  930.628552] XFS (loop0): Metadata corruption detected at
xfs_agfl_verify+0x1b3/0x1d0, xfs_agfl block 0x3
[  930.630745] XFS (loop0): Unmount and run xfs_repair
[  930.631766] XFS (loop0): First 128 bytes of corrupted metadata buffer:
[  930.633147] 0000000014fe3de9: 58 41 46 4c 00 00 00 00 f8 b6 90 f9 45 76 45
29  XAFL........EvE)
[  930.637675] 000000004dd0ed1c: b1 1a cc a5 61 96 39 9c 00 00 00 20 00 00 00
00  ....a.9.... ....
[  930.639479] 000000001dc25501: 58 e5 62 3f 00 00 0e b3 00 00 0e b4 00 00 0e
b5  X.b?............
[  930.641303] 00000000b877670b: 00 00 0e b6 00 00 0e b7 00 00 0e b8 ff ff ff
ff  ................
[  930.643108] 00000000152a84a5: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff  ................
[  930.644892] 00000000ff2008d7: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff  ................
[  930.646716] 00000000f060ca7a: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff  ................
[  930.648502] 000000006b464d8a: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff  ................
[  930.650359] XFS (loop0): metadata I/O error in "xfs_trans_read_buf_map" at
daddr 0x3 len 1 error 117
[  930.652270] XFS (loop0): page discard on page 0000000005fd24f3, inode
0x75e5, offset 0.
[  930.654025]
==================================================================
[  930.655513] BUG: KASAN: null-ptr-deref in xfs_alloc_get_freelist+0x115/0x350
[  930.656938] Read of size 8 at addr 0000000000000028 by task a.out/1406

[  930.658621] CPU: 0 PID: 1406 Comm: a.out Not tainted 4.17.0-rc4-kasan #2
[  930.658624] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
Ubuntu-1.8.2-1ubuntu1 04/01/2014
[  930.658632] Call Trace:
[  930.658644]  dump_stack+0x7b/0xb5
[  930.658653]  kasan_report+0x10c/0x390
[  930.658658]  ? xfs_alloc_get_freelist+0x115/0x350
[  930.658663]  __asan_load8+0x54/0x90
[  930.658668]  xfs_alloc_get_freelist+0x115/0x350
[  930.658674]  ? xfs_free_agfl_block+0x90/0x90
[  930.658679]  ? xfs_alloc_space_available+0x128/0x170
[  930.658689]  xfs_alloc_fix_freelist+0x35b/0x830
[  930.658698]  ? __fput+0x17a/0x380
[  930.658703]  ? xfs_alloc_read_agf+0x340/0x340
[  930.658707]  ? kasan_check_write+0x14/0x20
[  930.658711]  ? new_slab+0x450/0x660
[  930.658716]  ? ___slab_alloc+0x26e/0x4b0
[  930.658723]  ? kasan_check_write+0x14/0x20
[  930.658730]  ? xfs_perag_get+0x4c/0xf0
[  930.658735]  ? xfs_alloc_vextent+0x1fa/0x990
[  930.658740]  xfs_alloc_vextent+0x215/0x990
[  930.658746]  xfs_bmap_extents_to_btree+0x30d/0x940
[  930.658752]  ? xfs_bmse_can_merge+0xb0/0xb0
[  930.658758]  ? percpu_counter_add_batch+0x22/0xa0
[  930.658766]  ? xfs_mod_fdblocks+0x77/0x220
[  930.658775]  __xfs_bunmapi+0x11d5/0x1430
[  930.658782]  ? xfs_bmapi_remap+0x750/0x750
[  930.658789]  ? io_serial_out+0x37/0x50
[  930.658796]  ? serial8250_console_write+0x215/0x480
[  930.658801]  ? serial8250_start_tx+0x370/0x370
[  930.658805]  ? __asan_loadN+0xf/0x20
[  930.658809]  ? xfs_bmapi_update_map+0x76/0x1c0
[  930.658814]  ? xfs_bmapi_read+0x4e8/0x620
[  930.658822]  ? _kstrtoull+0x7e/0x110
[  930.658825]  ? _parse_integer+0xb0/0xb0
[  930.658832]  ? vprintk_emit+0x373/0x450
[  930.658837]  xfs_bunmapi+0x2c/0x60
[  930.658844]  xfs_bmap_punch_delalloc_range+0x170/0x240
[  930.658848]  ? xfs_getbmap+0xe80/0xe80
[  930.658852]  ? kstrtoint+0x6c/0xd0
[  930.658855]  ? _kstrtol+0xc0/0xc0
[  930.658861]  ? xfs_emerg+0x170/0x170
[  930.658871]  ? down_write+0x41/0x50
[  930.658876]  xfs_aops_discard_page+0x178/0x1d0
[  930.658881]  xfs_do_writepage+0x90c/0x9d0
[  930.658886]  ? xfs_add_to_ioend+0x600/0x600
[  930.658894]  ? invalid_page_referenced_vma+0x130/0x130
[  930.658899]  ? pmdp_huge_clear_flush+0x10/0x10
[  930.658903]  ? percpu_counter_add_batch+0x22/0xa0
[  930.658911]  ? clear_page_dirty_for_io+0x334/0x450
[  930.658916]  write_cache_pages+0x3cd/0x770
[  930.658922]  ? iomap_dirty_actor+0x310/0x310
[  930.658926]  ? xfs_add_to_ioend+0x600/0x600
[  930.658931]  ? clear_page_dirty_for_io+0x450/0x450
[  930.658935]  ? up_write+0x16/0x40
[  930.658939]  ? xfs_iunlock+0x11a/0x150
[  930.658946]  ? xfs_file_fsync+0x460/0x460
[  930.658951]  xfs_vm_writepages+0xd3/0x130
[  930.658954]  ? xfs_vm_readpage+0xc0/0xc0
[  930.658960]  ? xfs_file_write_iter+0x16a/0x1a0
[  930.658964]  do_writepages+0x37/0xb0
[  930.658970]  __filemap_fdatawrite_range+0x19a/0x1f0
[  930.658975]  ? delete_from_page_cache_batch+0x4e0/0x4e0
[  930.658981]  ? may_open_dev+0x50/0x50
[  930.658986]  ? locks_remove_file+0x9f/0x2a0
[  930.658991]  filemap_flush+0x1c/0x20
[  930.658995]  xfs_release+0x1b7/0x1f0
[  930.659000]  xfs_file_release+0x15/0x20
[  930.659003]  __fput+0x17a/0x380
[  930.659008]  ____fput+0xe/0x10
[  930.659015]  task_work_run+0xc8/0xf0
[  930.659023]  exit_to_usermode_loop+0xf2/0x100
[  930.659027]  do_syscall_64+0x138/0x170
[  930.659033]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  930.659050] RIP: 0033:0x7fb3beeb28f0
[  930.659054] RSP: 002b:00007ffd93f35298 EFLAGS: 00000246 ORIG_RAX:
0000000000000003
[  930.659063] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
00007fb3beeb28f0
[  930.659065] RDX: 0000000000008000 RSI: 0000000000601080 RDI:
0000000000000003
[  930.659068] RBP: 00007ffd93f352d0 R08: 000000000102d010 R09:
0000000000000000
[  930.659070] R10: 0000000000000690 R11: 0000000000000246 R12:
00000000004005c0
[  930.659073] R13: 00007ffd93f353d0 R14: 0000000000000000 R15:
0000000000000000
[  930.659077]
==================================================================
[  930.660551] Disabling lock debugging due to kernel taint
[  930.660672] BUG: unable to handle kernel NULL pointer dereference at
0000000000000028
[  930.662391] PGD 80000001e5d10067 P4D 80000001e5d10067 PUD 1e5d11067 PMD 0
[  930.663791] Oops: 0000 [#1] SMP KASAN PTI
[  930.664637] Modules linked in: snd_hda_codec_generic snd_hda_intel
snd_hda_codec snd_hwdep snd_hda_core snd_pcm snd_timer snd soundcore i2c_piix4
mac_hid ib_iser rdma_cm iw_cm ib_cm ib_core iscsi_tcp libiscsi_tcp libiscsi
scsi_transport_iscsi autofs4 raid10 raid456 async_raid6_recov async_memcpy
async_pq async_xor async_tx raid1 raid0 multipath linear 8139too qxl
drm_kms_helper crct10dif_pclmul syscopyarea crc32_pclmul sysfillrect sysimgblt
fb_sys_fops ttm aesni_intel drm aes_x86_64 crypto_simd cryptd glue_helper
floppy 8139cp pata_acpi mii
[  930.674527] CPU: 0 PID: 1406 Comm: a.out Tainted: G    B            
4.17.0-rc4-kasan #2
[  930.676159] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
Ubuntu-1.8.2-1ubuntu1 04/01/2014
[  930.678079] RIP: 0010:xfs_alloc_get_freelist+0x119/0x350
[  930.679157] RSP: 0018:ffff8801f3e66d08 EFLAGS: 00010282
[  930.680222] RAX: ffff8801f1e02008 RBX: ffff8801f1e02000 RCX:
0000000000000000
[  930.681668] RDX: 0000000000000000 RSI: 0000000000000297 RDI:
0000000000000297
[  930.683109] RBP: ffff8801f3e66dd0 R08: ffffed003ee03ebb R09:
ffffed003ee03ebb
[  930.684546] R10: 0000000000000001 R11: ffffed003ee03eba R12:
ffff8801f1741880
[  930.685989] R13: ffff8801f3e66e58 R14: 0000000000000000 R15:
0000000000000000
[  930.687431] FS:  00007fb3bf3a0700(0000) GS:ffff8801f7000000(0000)
knlGS:0000000000000000
[  930.689054] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  930.690226] CR2: 0000000000000028 CR3: 00000001e59ac000 CR4:
00000000000006f0
[  930.691674] Call Trace:
[  930.692200]  ? xfs_free_agfl_block+0x90/0x90
[  930.693076]  ? xfs_alloc_space_available+0x128/0x170
[  930.694106]  xfs_alloc_fix_freelist+0x35b/0x830
[  930.695040]  ? __fput+0x17a/0x380
[  930.695732]  ? xfs_alloc_read_agf+0x340/0x340
[  930.696630]  ? kasan_check_write+0x14/0x20
[  930.697477]  ? new_slab+0x450/0x660
[  930.698216]  ? ___slab_alloc+0x26e/0x4b0
[  930.699030]  ? kasan_check_write+0x14/0x20
[  930.699878]  ? xfs_perag_get+0x4c/0xf0
[  930.700655]  ? xfs_alloc_vextent+0x1fa/0x990
[  930.701537]  xfs_alloc_vextent+0x215/0x990
[  930.702396]  xfs_bmap_extents_to_btree+0x30d/0x940
[  930.703378]  ? xfs_bmse_can_merge+0xb0/0xb0
[  930.704242]  ? percpu_counter_add_batch+0x22/0xa0
[  930.705212]  ? xfs_mod_fdblocks+0x77/0x220
[  930.706070]  __xfs_bunmapi+0x11d5/0x1430
[  930.707302]  ? xfs_bmapi_remap+0x750/0x750
[  930.708158]  ? io_serial_out+0x37/0x50
[  930.708942]  ? serial8250_console_write+0x215/0x480
[  930.709970]  ? serial8250_start_tx+0x370/0x370
[  930.710891]  ? __asan_loadN+0xf/0x20
[  930.711637]  ? xfs_bmapi_update_map+0x76/0x1c0
[  930.712557]  ? xfs_bmapi_read+0x4e8/0x620
[  930.713394]  ? _kstrtoull+0x7e/0x110
[  930.714162]  ? _parse_integer+0xb0/0xb0
[  930.714965]  ? vprintk_emit+0x373/0x450
[  930.715768]  xfs_bunmapi+0x2c/0x60
[  930.716486]  xfs_bmap_punch_delalloc_range+0x170/0x240
[  930.717544]  ? xfs_getbmap+0xe80/0xe80
[  930.718338]  ? kstrtoint+0x6c/0xd0
[  930.719049]  ? _kstrtol+0xc0/0xc0
[  930.719746]  ? xfs_emerg+0x170/0x170
[  930.720496]  ? down_write+0x41/0x50
[  930.721230]  xfs_aops_discard_page+0x178/0x1d0
[  930.722164]  xfs_do_writepage+0x90c/0x9d0
[  930.723000]  ? xfs_add_to_ioend+0x600/0x600
[  930.723871]  ? invalid_page_referenced_vma+0x130/0x130
[  930.724931]  ? pmdp_huge_clear_flush+0x10/0x10
[  930.725868]  ? percpu_counter_add_batch+0x22/0xa0
[  930.726842]  ? clear_page_dirty_for_io+0x334/0x450
[  930.727832]  write_cache_pages+0x3cd/0x770
[  930.728686]  ? iomap_dirty_actor+0x310/0x310
[  930.729569]  ? xfs_add_to_ioend+0x600/0x600
[  930.730454]  ? clear_page_dirty_for_io+0x450/0x450
[  930.731447]  ? up_write+0x16/0x40
[  930.732143]  ? xfs_iunlock+0x11a/0x150
[  930.732927]  ? xfs_file_fsync+0x460/0x460
[  930.733774]  xfs_vm_writepages+0xd3/0x130
[  930.734611]  ? xfs_vm_readpage+0xc0/0xc0
[  930.735434]  ? xfs_file_write_iter+0x16a/0x1a0
[  930.736356]  do_writepages+0x37/0xb0
[  930.737107]  __filemap_fdatawrite_range+0x19a/0x1f0
[  930.738126]  ? delete_from_page_cache_batch+0x4e0/0x4e0
[  930.739208]  ? may_open_dev+0x50/0x50
[  930.739976]  ? locks_remove_file+0x9f/0x2a0
[  930.740843]  filemap_flush+0x1c/0x20
[  930.741608]  xfs_release+0x1b7/0x1f0
[  930.757355]  xfs_file_release+0x15/0x20
[  930.758172]  __fput+0x17a/0x380
[  930.758835]  ____fput+0xe/0x10
[  930.759480]  task_work_run+0xc8/0xf0
[  930.760231]  exit_to_usermode_loop+0xf2/0x100
[  930.761137]  do_syscall_64+0x138/0x170
[  930.761933]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  930.762975] RIP: 0033:0x7fb3beeb28f0
[  930.763719] RSP: 002b:00007ffd93f35298 EFLAGS: 00000246 ORIG_RAX:
0000000000000003
[  930.765265] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
00007fb3beeb28f0
[  930.766727] RDX: 0000000000008000 RSI: 0000000000601080 RDI:
0000000000000003
[  930.768177] RBP: 00007ffd93f352d0 R08: 000000000102d010 R09:
0000000000000000
[  930.769623] R10: 0000000000000690 R11: 0000000000000246 R12:
00000000004005c0
[  930.771085] R13: 00007ffd93f353d0 R14: 0000000000000000 R15:
0000000000000000
[  930.772540] Code: 1c 25 28 00 00 00 0f 85 4f 02 00 00 48 81 c4 a0 00 00 00
5b 41 5c 41 5d 41 5e 41 5f 5d c3 49 8d 7f 28 e8 ab a2 da ff 48 8d 43 08 <4d> 8b
77 28 48 89 c7 48 89 85 50 ff ff ff e8 94 a1 da ff 8b 53
[  930.776398] RIP: xfs_alloc_get_freelist+0x119/0x350 RSP: ffff8801f3e66d08
[  930.777790] CR2: 0000000000000028
[  930.778588] ---[ end trace b21925e6ee7e4fcf ]---

Reported by Wen Xu from SSLab at Gatech.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.