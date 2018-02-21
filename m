Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:46060 "EHLO
        mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752185AbeBUK5D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Feb 2018 05:57:03 -0500
Received: by mail-vk0-f54.google.com with SMTP id k187so667064vke.12
        for <linux-xfs@vger.kernel.org>; Wed, 21 Feb 2018 02:57:03 -0800 (PST)
MIME-Version: 1.0
From: Andrea Mazzocchi <mazzocchiandrea24@gmail.com>
Date: Wed, 21 Feb 2018 11:57:01 +0100
Message-ID: <CAJbUkCSw-Cyi1-KkfAtaCWYODZ3jHAsE8coQpMo1qb+SXDsyEw@mail.gmail.com>
Subject: XFS corruption of in-memory data detected with KVM
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello everybody.

We are experiencing crashes on our SSD VPSes, all working on KVM;
other VPSes hosted on another VPS provider
using VMware never gave us troubles, the ones on KVM occasionally
crashes under unknown circumstances.
We use the same CentOS7 ISO on all our hosts (both KVM and VMware).
Only the hosts on KVM crash and we don't understand why.

Here's the dmesg of the crashed host in the emergency console.
Any suggestion is more than welcome!

Best regards

[    1.781684] systemd[1]: Found device /dev/mapper/centos-root.
[    1.781919] systemd[1]: Starting File System Check on
/dev/mapper/centos-root...
[    1.798487] systemd-fsck[3751]: /sbin/fsck.xfs: XFS file system.
[    1.799458] systemd[1]: Started File System Check on /dev/mapper/centos-root.
[    1.838485] systemd[1]: Started dracut initqueue hook.
[    1.838637] systemd[1]: Reached target Remote File Systems (Pre).
[    1.838764] systemd[1]: Starting Remote File Systems (Pre).
[    1.838886] systemd[1]: Reached target Remote File Systems.
[    1.839070] systemd[1]: Starting Remote File Systems.
[    1.839211] systemd[1]: Started dracut pre-mount hook.
[    1.839357] systemd[1]: Mounting /sysroot...
[    2.235562] kernel: SGI XFS with ACLs, security attributes, no debug enabled
[    2.237759] kernel: XFS (dm-0): Mounting U5 Filesystem
[    5.413560] kernel: XFS (dm-0): Starting recovery (logdev: internal)
[    5.436057] kernel: XFS (dm-0): Internal error
XFS_WANT_CORRUPTED_GOTO at line 3171 of file
fs/xfs/libxfs/xfs_btree.c. Caller xfs_free_ag_extent+8x402/0x780 [xfs]
[    5.437201] kernel: CPU: 1 PID: 398 Comm: mount Not tainted
3.18.0-693.11.1.e17.x86_64 #1
[    5.438265] kernel: Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS rel-1.11.0-0-g63451fca13-prebuilt.qemu-project.org
04/01/2014
[    5.448392] kernel: ffff8801361368d8 0000000073ff73da
ffff8801363bfa88 ffffffff816a3e61
[    5.441585] kernel: ffff8881363bfa28 ffffffffc822c46b
ffffffffc01e94d2 ffff8881363bfa98
[    5.442682] kernel: ffffffffc0206543 ffff8801363bfafc
0000000000000000 00000000ffffffff
[    5.443783] kernel: Call Trace:
[    5.444828] kernel: [<ffffffff816a3e61>] dump_stack+0x19/0x1b
[    5.445958] kernel: [<ffffffffc022c46b>] xfs_error_report+0x3b/0x40 [xfs]
[    5.447159] kernel: [<ffffffffc0le94d2>] ?
xfs_free_ag_extent+0x402/0x780 [xfs]
[    5.448357] kernel: [<ffffffffc0206543>] xfs_btree_insert+0x1a3/0x1b0 [xfs]
[    5.449683] kernel: [<ffffffffc0le94d2>] xfs_free_ag_extent+0x402/0x780 [xfs]
[    5.458844] kernel: [<ffffffffc0lebe6c>] xfs_free_extent+0xfc/0x130 [xfs]
[    5.452168] kernel: [<ffffffffc025a6b6>]
xfs_trans_free_extent+0x26/0x60 [xfs]
[    5.453378] kernel: [<ffffffffc0252a5e>]
xlog_recover_process_efi+0x17e/0x1c0 [xfs]
[    5.454788] kernel: [<ffffffffc0254db7>]
xlog_recover_process_efis.isra.30+0x77/0xe0 [xfs]
[    5.455927] kernel: [<ffffffffc02586e1>] xlog_recover_finish+0x21/0xb0 [xfs]
[    5.457896] kernel: [<ffffffffc024b814>] xfs_log_mount_finish+0x34/0x50 [xfs]
[    5.458273] kernel: [<ffffffffc0241eal>] xfs_mountfs+0x5d1/0x8b0 [xfs]
[    5.459589] kernel: [<ffffffffc02301a0>] ?
xfs_filestreamget_parent+Ox80/0x80 [xis]
[    5.468727] kernel: [<ffffffffc0244ceb>] xfs_fs_fill_super+0x3bb/0x4d0 [xfs]
[    5.461933] kernel: [<ffffffff81204b10>] mount_bdev+0x1b0/0x1f0
[    5.463161] kernel: [<ffffffffc0244930>] ?
xfs_test_remount_options.isra.11+0x70/0x70 [xfs]
[    5.464485] kernel: [<ffffffffc0243655>] xfs_fs_mount+0x15/0x20 [xfs]
[    5.465668] kernel: [<ffffffff81205389>] mount_fs+0x39/0x1b0
[    5.466951] kernel: [<ffffffff811a5f05>] ? __alloc_percpu+0x15/0x20
[    5.468185] kernel: [<ffffffff81221e57>] vfs_kern_mount+0x67/0x110
[    5.469497] kernel: [<ffffffff81224363>] do_mount+0x233/0xaf0
[    5.478715] kernel: [<ffffffff811a100b>] ? strndup_user+0x4b/0xa0
[    5.471909] kernel: [<ffffffff81224fa6>] SyS_mount+0x96/Oxf0
[    5.473063] kernel: [<ffffffff816b5089>] system_call_fastpath+0x16/0x1b
[    5.474233] kernel: XFS (dm-0): Internal error xfs_trans_cancel at
line 984 of file fs/xfs xfs_trans.c. Caller
xlog_recover_process_efi+Oxl8e/Oxlc0 (xis]
[    5.476668] kernel: CPU: 1 PID: 390 Comm: mount Not tainted
3.10.0-693.11.1.e17.x86_64 #1
[    5.477942] kernel: Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS rel-1.11.0-0-g63451fca13-prebuilt.qemu-project.org
04/01/2014
[    5.480466] kernel: ffff880136010000 0000000073ff73da
ffff8801363bfbd0 ffffffff816a3e61
[    5.481751] kernel: ffff8801363bfbe8 ffffffffc022c46b
ffffffffc0252a6e ffff8801363bfc10
[    5.483028] kernel: ffffffffc02488cd ffff8800369d6000
0000000000000000 ffff8800369d6198
[    5.484313] kernel: Call Trace:
[    5.485801] kernel: [<ffffffff816a3e61>] dump_stack+0x19/0x1b
[    5.487129] kernel: [<ffffffffc022c46b>] xfs_error_report+Ox3b/0x40 [xfs]
[    5.488464] kernel: [<ffffffffc0252a6e>] ?
xlog_recover_process_efi+Oxl8e/Oxlc0 [xfs]
[    5.489797] kernel: [<ffffffffc02488cd>] xfs_trans_cancel+Oxbd/Oxe0 [xfs]
[    5.491123] kernel: [<ffffffffc0252a6e>]
xlog_recover_process_efi+Oxl8e/Oxlc0 [xis]
[    5.492429] kernel: [<ffffffffc0254db7>]
xlog_recover_process_efis.isra.30+0x77/0xe0 [xfs]
[    5.493748] kernel: [<ffffffffc02586el>] xlog_recover_finish+Ox21/OxbO [xfs]
[    5.495001] kernel: [<ffffffffc024b814>] xfs_log_mount_finish+0x34/0x50 [xfs]
[    5.496286] kernel: [<ffffffffc0241eal>] xfs_mountfs+0x5d1/0x8b0 [xfs]
[    5.497508] kernel: [<ffffffffc02301a0>] ?
xfs_filestream_get_parent+0x80/0x80 [xfs]
[    5.498700] kernel: [<ffffffffc0244ceb>] xfs_fs_fi1l_super+Ox3bb/Ox4d0 [xfs]
[    5.499866] kernel: [<ffffffff81204b10>] mount_bdev+0x1b0/0x1f0
[    5.501050] kernel: [<ffffffffc0244930>] ?
xfs_test_remount_options.isra.11+0x70/0x70 [xfs]
[    5.502232] kernel: [<ffffffffc0243655>] xfs_fs_mount+Ox15/0x20 [xfs]
[    5.503406] kernel: [<ffffffff81205389>] mount_fs+0x39/0x1b0
[    5.504556] kernel: [<ffffffff811a5f05>] ? __alloc_percpu+Ox15/0x20
[    5.505713] kernel: [<ffffffff81221e57>] vfs_kern_mount+0x67/0x110
[    5.506893] kernel: [<ffffffff81224363>] do_mount+0x233/0xaf0
[    5.508048] kernel: [<ffffffff811a100b>] ? strndup_user+Ox4b/Oxa0
[    5.509222] kernel: [<ffffffff81224fa6>] SyS_mount+0x96/0xf0
[    5.510366] kernel: [<ffffffff816b5089>] system_call_fastpath+0x16/0x1b
[    5.511554] kernel: XFS (dm-0): xfs_do_force_shutdown(0x8) called
from line 985 of file fs/xfs/xfs_trans.c.     Return address =
Oxffffffffc02488e6
[    5.514064] kernel: XFS (dm-0): Corruption of in-memory data
detected. Shutting down file system
[    5.515795] kernel: XFS (dm-0): Please umount the filesystem and
rectify the problem(s)
[    5.517485] kernel: XFS (dm-0): Failed to recover EFIs
[    5.519112] kernel: XFS (dm-0): log mount finish failed
[    5.208098] mount[390]: mount: mount /dev/mapper/centos-root on
/sysroot failed: Structure needs cleaning
[    5.208670] systemd[1]: sysroot.mount mount process exited,
code-exited status=32
[    5.208864] systemd[1]: Failed to mount /sysroot.
[    5.209318] systemd[1]: Dependency failed for Initrd Root File System.
[    5.214710] systemd[1]: Dependency failed for Reload Configuration
from the Real Root.
[    5.214839] systemd[1]: Job initrd-parse-etc.service/start failed
with result 'dependency'
[    5.214948] systemd[1]: Triggering OnFailure= dependencies of
initrd-parse-etc.service.
[    5.215120] systemd[1]: Job initrd-root-fs.target/start failed with
result 'dependency'.
[    5.215248] systemd[1]: Triggering OnFailure= dependencies of
initrd-root-fs.target.
[    5.215350] systemd[1]: Unit sysroot.mount entered failed state.
[    5.215557] systemd[1]: Stopped dracut pre-pivot and cleanup hook.
[    5.215753] systemd[1]: Stopped target Initrd Default Target.
[    5.217627] systemd[1]: Reached target Initrd File Systems.
[    5.217760] systemd[1]: Starting Initrd File Systems.
[    5.218946] systemd[1]: Stopped dracut pre-udev hook.
[    5.219191] systemd[1]: Stopping dracut pre-udev hook...
[    5.221870] systemd[1]: Stopped dracut cmdline hook.
[    5.222055] systemd[1]: Stopping dracut cmdline hook...
[    5.227280] systemd[1]: Stopped dracut mount hook.
[    5.230291] systemd[1]: Stopped target Basic System.
[    5.230486] systemd[1]: Stopping Basic System.
[    5.232450] systemd[1]: Stopped dracut initqueue hook.
[    5.232621] systemd[1]: Stopping dracut initqueue hook...
[    5.235783] systemd[1]: Stopped target System Initialization.
[    5.235904] systemd[1]: Stopping System Initialization.
[    5.236560] systemd[1]: Started Emergency Shell.
[    5.236688] systemd[1]: Starting Emergency Shell...
[    5.236825] systemd[1]: Reached target Emergency Mode.
[    5.236947] systemd[1]: Startup finished in 806ms (kernel) + 0
(initrd) + 4.430s (userspace) = 5.236s.
[    5.237073] systemd[1]: Starting Emergency Mode.
[    5.256981] systemd[1]: Received SIGRTMIM+21 from PID 274 (plymouthd).
(END)
