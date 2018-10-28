Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f181.google.com ([209.85.208.181]:44086 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbeJ2CgU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Oct 2018 22:36:20 -0400
MIME-Version: 1.0
From: Anatoly Trosinenko <anatoly.trosinenko@gmail.com>
Date: Sun, 28 Oct 2018 20:50:46 +0300
Message-ID: <CAE5jQCc3hrq6E-Ff1oiYUOSDA08PMrqnu80XQtaD5adcUQvV8w@mail.gmail.com>
Subject: XFS: Hang and dmesg flood on mounting invalid FS image
Content-Type: multipart/mixed; boundary="00000000000043aab105794d98d7"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

--00000000000043aab105794d98d7
Content-Type: text/plain; charset="UTF-8"

Hello,

When mounting a broken XFS image, the kernel hangs and floods dmesg
with stack traces.

How to reproduce with kvm-xfstests:
1) Checkout v4.19, copy x86_64-config-4.14 to .config, `make
olddefconfig` and compile
2) Unpack the attached image (128 Mb uncompressed) to /tmp/kvm-xfstests-$USER
3) Inside the `kvm-xfstests shell`:

root@kvm-xfstests:~# mount /vtmp
root@kvm-xfstests:~# mount /vtmp/xfs.img /mnt
[   39.280840] XFS (loop0): Mounting V5 Filesystem
[   39.303657] XFS (loop0): Internal error xlog_valid_rec_header(2) at
line 5283 of file fs/xfs/xfs_log_recover.c.  Caller
xlog_do_recovery_pass+0x2bd/0x5d0
[   39.304886] CPU: 0 PID: 373 Comm: mount Not tainted 4.19.0-xfstests #1
[   39.305491] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.11.1-1ubuntu1 04/01/2014
[   39.306247] Call Trace:
[   39.306464]  dump_stack+0x85/0xc0
[   39.306751]  xlog_valid_rec_header.isra.6+0xd5/0xe0
[   39.307250]  xlog_do_recovery_pass+0x2bd/0x5d0
[   39.307624]  ? xlog_bread_noalign+0x98/0x110
[   39.307983]  ? xlog_bread_noalign+0x98/0x110
[   39.308344]  xlog_verify_head+0xab/0x190
[   39.308675]  xlog_find_tail+0x208/0x350
[   39.308999]  xlog_recover+0x2b/0x160
[   39.309307]  xfs_log_mount+0x280/0x2a0
[   39.309625]  xfs_mountfs+0x42f/0x890
[   39.309928]  ? xfs_mru_cache_create+0x18b/0x1f0
[   39.310309]  xfs_fs_fill_super+0x4f8/0x6d0
[   39.310655]  ? xfs_test_remount_options+0x60/0x60
[   39.311050]  mount_bdev+0x17f/0x1b0
[   39.311347]  mount_fs+0x3b/0x170
[   39.311624]  ? __init_waitqueue_head+0x36/0x50
[   39.311999]  vfs_kern_mount.part.16+0x54/0x160
[   39.312374]  do_mount+0x20e/0xdf0
[   39.312657]  ? memdup_user+0x3e/0x70
[   39.312961]  __ia32_compat_sys_mount+0xa3/0x140
[   39.313346]  do_fast_syscall_32+0x9d/0x2f0
[   39.313694]  entry_SYSENTER_compat+0x84/0x96
[   39.314126] XFS (loop0): Torn write (CRC failure) detected at log
block 0xaaf. Truncating head block from 0xab7.
[   39.316912] XFS (loop0): Internal error xlog_valid_rec_header(2) at
line 5283 of file fs/xfs/xfs_log_recover.c.  Caller
xlog_do_recovery_pass+0x2bd/0x5d0
[   39.318057] CPU: 0 PID: 373 Comm: mount Not tainted 4.19.0-xfstests #1
[   39.318601] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.11.1-1ubuntu1 04/01/2014
[   39.319339] Call Trace:
[   39.319552]  dump_stack+0x85/0xc0
[   39.319834]  xlog_valid_rec_header.isra.6+0xd5/0xe0
[   39.320244]  xlog_do_recovery_pass+0x2bd/0x5d0
[   39.320618]  ? xlog_bread_noalign+0x98/0x110
[   39.320979]  ? xlog_bread_noalign+0x98/0x110
[   39.321344]  xlog_verify_tail+0x144/0x1e0
[   39.321686]  xlog_verify_head+0xd4/0x190
[   39.322021]  xlog_find_tail+0x208/0x350
[   39.322348]  xlog_recover+0x2b/0x160
[   39.322654]  xfs_log_mount+0x280/0x2a0
[   39.322974]  xfs_mountfs+0x42f/0x890
[   39.323280]  ? xfs_mru_cache_create+0x18b/0x1f0
[   39.323664]  xfs_fs_fill_super+0x4f8/0x6d0
[   39.324013]  ? xfs_test_remount_options+0x60/0x60
[   39.324411]  mount_bdev+0x17f/0x1b0
[   39.324710]  mount_fs+0x3b/0x170
[   39.324988]  ? __init_waitqueue_head+0x36/0x50
[   39.325369]  vfs_kern_mount.part.16+0x54/0x160
[   39.325747]  do_mount+0x20e/0xdf0
[   39.326063]  ? memdup_user+0x3e/0x70
[   39.326369]  __ia32_compat_sys_mount+0xa3/0x140
[   39.326753]  do_fast_syscall_32+0x9d/0x2f0
[   39.327101]  entry_SYSENTER_compat+0x84/0x96
[   39.328873] XFS (loop0): Internal error xlog_valid_rec_header(2) at
line 5283 of file fs/xfs/xfs_log_recover.c.  Caller
xlog_do_recovery_pass+0x2bd/0x5d0
[   39.330024] CPU: 0 PID: 373 Comm: mount Not tainted 4.19.0-xfstests #1
[   39.330574] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.11.1-1ubuntu1 04/01/2014
[   39.331349] Call Trace:
[   39.331565]  dump_stack+0x85/0xc0
[   39.331850]  xlog_valid_rec_header.isra.6+0xd5/0xe0
[   39.332264]  xlog_do_recovery_pass+0x2bd/0x5d0
[   39.332642]  ? xlog_bread_noalign+0x98/0x110
[   39.333005]  ? xlog_bread_noalign+0x98/0x110
[   39.333371]  xlog_verify_tail+0x144/0x1e0
[   39.333713]  xlog_verify_head+0xd4/0x190
[   39.334048]  xlog_find_tail+0x208/0x350
[   39.334376]  xlog_recover+0x2b/0x160
[   39.334682]  xfs_log_mount+0x280/0x2a0
[   39.335003]  xfs_mountfs+0x42f/0x890
[   39.335309]  ? xfs_mru_cache_create+0x18b/0x1f0
[   39.335693]  xfs_fs_fill_super+0x4f8/0x6d0
[   39.336041]  ? xfs_test_remount_options+0x60/0x60
[   39.336439]  mount_bdev+0x17f/0x1b0
[   39.336739]  mount_fs+0x3b/0x170
[   39.337016]  ? __init_waitqueue_head+0x36/0x50
[   39.337396]  vfs_kern_mount.part.16+0x54/0x160
[   39.337774]  do_mount+0x20e/0xdf0
[   39.338059]  ? memdup_user+0x3e/0x70
[   39.338365]  __ia32_compat_sys_mount+0xa3/0x140
[   39.338749]  do_fast_syscall_32+0x9d/0x2f0
[   39.339098]  entry_SYSENTER_compat+0x84/0x96
[   39.340891] XFS (loop0): Internal error xlog_valid_rec_header(2) at
line 5283 of file fs/xfs/xfs_log_recover.c.  Caller
xlog_do_recovery_pass+0x2bd/0x5d0
[   39.342084] CPU: 0 PID: 373 Comm: mount Not tainted 4.19.0-xfstests #1
[   39.342636] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.11.1-1ubuntu1 04/01/2014
[   39.343385] Call Trace:
[   39.343601]  dump_stack+0x85/0xc0
[   39.343890]  xlog_valid_rec_header.isra.6+0xd5/0xe0
[   39.344309]  xlog_do_recovery_pass+0x2bd/0x5d0
[   39.344692]  ? xlog_bread_noalign+0x98/0x110
[   39.345092]  ? xlog_bread_noalign+0x98/0x110
[   39.345709]  xlog_verify_tail+0x144/0x1e0
[   39.346059]  xlog_verify_head+0xd4/0x190
[   39.346392]  xlog_find_tail+0x208/0x350
[   39.346718]  xlog_recover+0x2b/0x160
[   39.347025]  xfs_log_mount+0x280/0x2a0
[   39.347345]  xfs_mountfs+0x42f/0x890
[   39.347650]  ? xfs_mru_cache_create+0x18b/0x1f0
[   39.348032]  xfs_fs_fill_super+0x4f8/0x6d0
[   39.348380]  ? xfs_test_remount_options+0x60/0x60
[   39.348778]  mount_bdev+0x17f/0x1b0
[   39.349077]  mount_fs+0x3b/0x170
[   39.349366]  ? __init_waitqueue_head+0x36/0x50
[   39.349753]  vfs_kern_mount.part.16+0x54/0x160
[   39.350138]  do_mount+0x20e/0xdf0
[   39.350425]  ? memdup_user+0x3e/0x70
[   39.350731]  __ia32_compat_sys_mount+0xa3/0x140
[   39.351115]  do_fast_syscall_32+0x9d/0x2f0
[   39.351464]  entry_SYSENTER_compat+0x84/0x96
[   39.353323] XFS (loop0): Internal error xlog_valid_rec_header(2) at
line 5283 of file fs/xfs/xfs_log_recover.c.  Caller
xlog_do_recovery_pass+0x2bd/0x5d0
// ... and so on ...

Best regards
Anatoly

--00000000000043aab105794d98d7
Content-Type: application/octet-stream; name="xfs_128mb.img.bz2"
Content-Disposition: attachment; filename="xfs_128mb.img.bz2"
Content-Transfer-Encoding: base64
Content-ID: <f_jnt61atq0>
X-Attachment-Id: f_jnt61atq0

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
PXr3/n2vXr8iIiowBDR0hCP/MkpSWmJoBOT1BRUlNU84FVVldYWVr0ekEC9Xr9i2uLq8DAg19gBs
LExsjKzM7Q0hGprbG1ub3BxcvaE9zm6Ors7vAV5egoVwe3x9fn+AgYKDhIWGh4iJivfFxkaGjo+Q
DSMlJ/CP+MpKy0v8pGYDhxEyImpucnZ4TPiaChoqOkFUtNT1Aqpqqusra6vsLGys7S1tre4ubq7v
L2+v8DBwsPEFi8XGx8jJyssZmZozO+efoDdEbpfTT1NXW1vb9z2fd973/g+H4vj+T5fm+f6Pp+r6
/s+37fu+/8Px/L8/y/T9f2/efx/P8/1QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAtttttttttttttttttttttttttttttttttttttttttttttttttttttt
tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttoAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk
kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk
kkjVZgaRgu57d0H14bgsDCsIweDxHA9HCMFgYXgYD874bkTJcEgAAbrIQAklzCSSIwAAAOCVh6pE
Zq/7dJAAAPwoAAQhIBybJr0eQNJlC+IEgABzO93u9y+28XdJIAAGgYG2Mkkkkk/wzwm9N3Psjmku
T9ZwEuyIZUkgBCAQL2QLhAhAABYRSSSSSRYRYEgABlYEkkCBAOae6s4HytxJJJJJdL9F2rdv4Lc3
Nzc3K7m5wlYGxYvMk3m0XAh9tIFyEJokJJJJOjGS7IEJcwEUSQEZJAYssEkkkkz445MdjRjjjjTH
HHGp6Vk5rkiwbUyjCSIiigLJIsAUWCyARSErktbJbNa1rWta1r6BqQkkkkiKKBpGSQuYoE2hhcqq
LEWEiPxUIBchJN0Lj/OGTZtfltbTsW2barWtbDULJJFkEEhCrAgFw77DDDDDPhhhhhhhhhpqyEDB
gSbSQkmDhhlwwzYYYYYYYYYX4akAAFAABQAAUAAFAABQAAUAAFAABQAAUAAFAABQAAUAAFAABQAA
VhCjISEaUpTNopSlKUpS+mqLFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVEZSlKUz6KUpSlKUv0hKCQkDeAQAAELhJCFa1rX
NfWta1rWt+mXjE7RvJmYmZADe0bgcZArciIiIiPcqrthVaUpfpqIsJJJv1a1rXPfWta1rWt+mBpG
SEk2gDe4wAAVvo3YiZiLjeRExMwvCrvcKqrW5EREREABvdgAArciIiIiGVV2wqqte43bmJmZmZmb
u7varu7u7ugANgAArgXmZmZeZmZmZYFAF7Oq5mZmXmZmZmWBQBYFAF8JJJJpJJJJchhVcKqrT4n9
2c5znO5nOc5znNZVVwqqtKquFVVpiFVcKqrQAGwAAUABsAAFMwqrhVVa8PCquJJJJLySSTSSSSSw
KALAoAsCgC+58FJJOM6SSSSWBQAArvKquFVVr5SquFVVoADYAWBQBYFAFgUAAoADYAAK6JERMRER
EQqrhVVb/bwMzMzLzMzMzLAoAsCgCuYQqrhVVaYVVwqqtAAbAAFgUAWBQBYFAFAAbAABXOoiJiIi
IiFVcKqrQAGwAAVwImZmZmZlVXCqq0xEa3kF3u5mXmZmZmWBQBYFAF5rk4RXCqq1w0foiImIiIiI
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
--00000000000043aab105794d98d7--
