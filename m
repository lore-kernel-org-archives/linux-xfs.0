Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:41598 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751156AbdDDNLu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Apr 2017 09:11:50 -0400
Received: from mail1.g1.pair.com (localhost [127.0.0.1])
        by mail1.g1.pair.com (Postfix) with ESMTP id C0208548259
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2017 09:02:00 -0400 (EDT)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail1.g1.pair.com (Postfix) with ESMTPSA id F1B3F60AEB5
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2017 09:01:59 -0400 (EDT)
Date: Tue, 4 Apr 2017 15:02:02 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: "interesting" crash : 3.18.44, huge xfs, nfs
Message-ID: <20170404150202.6c7d032c@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/MSrwHJn_z3j.G7rivzrpzV7"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

--Sig_/MSrwHJn_z3j.G7rivzrpzV7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,=20
here is an interesting crash dump. I've never seen this function
called before : "Fixing recursive fault but reboot is needed!"

The system is frozen and must be hard rebooted. The filesystem is
humongous: about 400 TB.

Running is plain vanilla 3.18.44 (should upgrade...). I wonder if the
bug is still present though?=20

Context: this is a file server. There was a power failure yesterday, so
there's probably some corruption hidden somewhere triggering the crash.

Cheers.

(xfs_repair is running).

avril 04 10:11:42 Colorstock-01 kernel: BUG: unable to handle kernel NULL p=
ointer dereference at 0000000000000240
avril 04 10:11:42 Colorstock-01 kernel: IP: [<ffffffff811614d5>] iput+0x5/0=
x190
avril 04 10:11:42 Colorstock-01 kernel: PGD 0=20
avril 04 10:11:42 Colorstock-01 kernel: Oops: 0000 [#1] SMP=20
avril 04 10:11:42 Colorstock-01 kernel: Modules linked in: nfsv3 arc4 ecb m=
d4 nfsv4 cifs fscache dm_mod cfg80211 rfkill nfsd auth_rpcgss oid_registry =
nfs_acl nfs lockd grace sunrpc af_packet bonding joydev evdev x86_pkg_temp_=
thermal coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32c_intel a=
esni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd microcode=
 pcspkr myri10ge ast ttm drm_kms_helper drm i2c_algo_bit ixgbe ptp pps_core=
 mdio dca ses enclosure i2c_i801 sg i2c_core lpc_ich mfd_core ipmi_si 8250_=
fintek ipmi_msghandler rtc_cmos wmi processor thermal_sys acpi_power_meter =
button md_mod usbhid xhci_pci xhci_hcd ohci_pci ehci_pci ohci_hcd uhci_hcd =
ehci_hcd uas usb_storage usbcore usb_common fuse ipv6 autofs4 ext4 ext3 xfs=
 reiserfs crc16 jbd2 jbd aacraid ahci libahci ata_generic libata
avril 04 10:11:42 Colorstock-01 kernel: CPU: 12 PID: 2375 Comm: kworker/u64=
:0 Not tainted 3.18.44-storiq64-i7 #1
avril 04 10:11:42 Colorstock-01 kernel: Hardware name: Supermicro Super Ser=
ver/X10DRD-iNT, BIOS 2.0 12/17/2015
avril 04 10:11:42 Colorstock-01 kernel: Workqueue: writeback bdi_writeback_=
workfn (flush-253:0)
avril 04 10:11:42 Colorstock-01 kernel: task: ffff88085685a820 ti: ffff8800=
747a0000 task.ti: ffff8800747a0000
avril 04 10:11:42 Colorstock-01 kernel: RIP: 0010:[<ffffffff811614d5>]  [<f=
fffffff811614d5>] iput+0x5/0x190
avril 04 10:11:42 Colorstock-01 kernel: RSP: 0018:ffff8800747a3590  EFLAGS:=
 00010202
avril 04 10:11:42 Colorstock-01 kernel: RAX: 0000000000000000 RBX: ffff8808=
545b7000 RCX: 000ffffffffe0000
avril 04 10:11:42 Colorstock-01 kernel: RDX: 0000000000000000 RSI: 00000000=
000003f0 RDI: 00000000000001a8
avril 04 10:11:42 Colorstock-01 kernel: RBP: 0000000000000000 R08: ffff8800=
747a3684 R09: ffff8800747a3750
avril 04 10:11:42 Colorstock-01 kernel: R10: 0000000000000001 R11: 00000000=
00000000 R12: ffff880792569000
avril 04 10:11:42 Colorstock-01 kernel: R13: 0000000000000000 R14: ffff8800=
747a3801 R15: ffff8808545b7000
avril 04 10:11:42 Colorstock-01 kernel: FS:  0000000000000000(0000) GS:ffff=
88087f380000(0000) knlGS:0000000000000000
avril 04 10:11:42 Colorstock-01 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00=
00000080050033
avril 04 10:11:42 Colorstock-01 kernel: CR2: 0000000000000240 CR3: 00000000=
015e9000 CR4: 00000000003407e0
avril 04 10:11:42 Colorstock-01 kernel: DR0: 0000000000000000 DR1: 00000000=
00000000 DR2: 0000000000000000
avril 04 10:11:42 Colorstock-01 kernel: DR3: 0000000000000000 DR6: 00000000=
fffe0ff0 DR7: 0000000000000400
avril 04 10:11:42 Colorstock-01 kernel: Stack:
avril 04 10:11:42 Colorstock-01 kernel:  ffffffffa2c357b6 ffffffff81654f40 =
ffffffff92569060 ffff880792569040
avril 04 10:11:42 Colorstock-01 kernel:  ffff8800747a3730 ffff8800747a3730 =
0000000000000010 0000000000000000
avril 04 10:11:42 Colorstock-01 kernel:  ffffffffa2c0438d 0000000000000001 =
ffff8800747a3770 ffff8800747a37b0
avril 04 10:11:42 Colorstock-01 kernel: Call Trace:
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2c357b6>] ? xfs_filestr=
eam_lookup_ag+0x76/0x1b0 [xfs]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2c0438d>] ? xfs_bmap_bt=
alloc+0x2dd/0x770 [xfs]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2bfc192>] ? xfs_bmap_se=
arch_multi_extents+0xa2/0x120 [xfs]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2c03a06>] ? xfs_bmap_la=
st_extent+0x56/0x80 [xfs]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2c03a56>] ? xfs_bmap_is=
aeof+0x26/0x90 [xfs]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2c05211>] ? xfs_bmapi_w=
rite+0x4b1/0xaa0 [xfs]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2c3ca61>] ? xfs_iomap_w=
rite_allocate+0x131/0x350 [xfs]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2c283d7>] ? xfs_map_blo=
cks+0x1b7/0x240 [xfs]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2c291f6>] ? xfs_vm_writ=
epage+0x186/0x5a0 [xfs]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81106ead>] ? __writepage=
+0xd/0x40
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff811077af>] ? write_cache=
_pages+0x1bf/0x430
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81106ea0>] ? global_dirt=
yable_memory+0x50/0x50
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2d299c2>] ? ext4_writep=
ages+0x3f2/0xd00 [ext4]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81107a58>] ? generic_wri=
tepages+0x38/0x50
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff8116db61>] ? __writeback=
_single_inode+0x41/0x2b0
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff811700b8>] ? writeback_s=
b_inodes+0x1b8/0x470
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff811703fe>] ? __writeback=
_inodes_wb+0x8e/0xc0
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81170683>] ? wb_writebac=
k+0x253/0x350
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81170b8a>] ? bdi_writeba=
ck_workfn+0x2ca/0x480
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81071b95>] ? process_one=
_work+0x155/0x440
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81072543>] ? worker_thre=
ad+0x63/0x490
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff810724e0>] ? rescuer_thr=
ead+0x290/0x290
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff810769ee>] ? kthread+0xc=
e/0xf0
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81450fd8>] ? ret_from_fo=
rk+0x58/0x90
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:11:42 Colorstock-01 kernel: Code: 08 48 8d b8 00 04 00 00 e8 e9=
 eb fb ff 84 c0 74 09 65 48 ff 04 25 18 f5 00 00 48 83 c4 08 c3 0f 1f 80 00=
 00 00 00 48 85 ff 74 3e <f6> 87 98 00 00 00 40 0f 85 fe 00 00 00 41 55 41 =
54 55 48 8d af=20
avril 04 10:11:42 Colorstock-01 kernel: RIP  [<ffffffff811614d5>] iput+0x5/=
0x190
avril 04 10:11:42 Colorstock-01 kernel:  RSP <ffff8800747a3590>
avril 04 10:11:42 Colorstock-01 kernel: CR2: 0000000000000240
avril 04 10:11:42 Colorstock-01 kernel: ---[ end trace 8ff2f50e12a8faab ]---
avril 04 10:11:42 Colorstock-01 kernel: ------------[ cut here ]------------
avril 04 10:11:42 Colorstock-01 kernel: WARNING: CPU: 12 PID: 2375 at kerne=
l/exit.c:675 do_exit+0x48/0xb50()
avril 04 10:11:42 Colorstock-01 kernel: Modules linked in: nfsv3 arc4 ecb m=
d4 nfsv4 cifs fscache dm_mod cfg80211 rfkill nfsd auth_rpcgss oid_registry =
nfs_acl nfs lockd grace sunrpc af_packet bonding joydev evdev x86_pkg_temp_=
thermal coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32c_intel a=
esni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd microcode=
 pcspkr myri10ge ast ttm drm_kms_helper drm i2c_algo_bit ixgbe ptp pps_core=
 mdio dca ses enclosure i2c_i801 sg i2c_core lpc_ich mfd_core ipmi_si 8250_=
fintek ipmi_msghandler rtc_cmos wmi processor thermal_sys acpi_power_meter =
button md_mod usbhid xhci_pci xhci_hcd ohci_pci ehci_pci ohci_hcd uhci_hcd =
ehci_hcd uas usb_storage usbcore usb_common fuse ipv6 autofs4 ext4 ext3 xfs=
 reiserfs crc16 jbd2 jbd aacraid ahci libahci ata_generic libata
avril 04 10:11:42 Colorstock-01 kernel: CPU: 12 PID: 2375 Comm: kworker/u64=
:0 Tainted: G      D        3.18.44-storiq64-i7 #1
avril 04 10:11:42 Colorstock-01 kernel: Hardware name: Supermicro Super Ser=
ver/X10DRD-iNT, BIOS 2.0 12/17/2015
avril 04 10:11:42 Colorstock-01 kernel: Workqueue: writeback bdi_writeback_=
workfn (flush-253:0)
avril 04 10:11:42 Colorstock-01 kernel:  0000000000000086 0000000000000000 =
ffffffff8144a289 0000000000000007
avril 04 10:11:42 Colorstock-01 kernel:  0000000000000000 0000000000000009 =
ffffffff8105b952 0000000000000009
avril 04 10:11:42 Colorstock-01 kernel:  0000000000000096 ffff8800747a34e8 =
0000000000000240 0000000000000096
avril 04 10:11:42 Colorstock-01 kernel: Call Trace:
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff8144a289>] ? dump_stack+=
0x5e/0x7a
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff8105b952>] ? warn_slowpa=
th_common+0x72/0x90
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff8105cc88>] ? do_exit+0x4=
8/0xb50
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff8144953c>] ? printk+0x4f=
/0x54
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81017282>] ? oops_end+0x=
92/0xd0
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff8104fee6>] ? no_context+=
0x106/0x360
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff810505de>] ? __do_page_f=
ault+0x9e/0x4b0
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2c0cb9d>] ? xfs_btree_u=
pdate+0xbd/0xd0 [xfs]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81452f38>] ? page_fault+=
0x28/0x30
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff811614d5>] ? iput+0x5/0x=
190
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2c357b6>] ? xfs_filestr=
eam_lookup_ag+0x76/0x1b0 [xfs]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2c0438d>] ? xfs_bmap_bt=
alloc+0x2dd/0x770 [xfs]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2bfc192>] ? xfs_bmap_se=
arch_multi_extents+0xa2/0x120 [xfs]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2c03a06>] ? xfs_bmap_la=
st_extent+0x56/0x80 [xfs]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2c03a56>] ? xfs_bmap_is=
aeof+0x26/0x90 [xfs]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2c05211>] ? xfs_bmapi_w=
rite+0x4b1/0xaa0 [xfs]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2c3ca61>] ? xfs_iomap_w=
rite_allocate+0x131/0x350 [xfs]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2c283d7>] ? xfs_map_blo=
cks+0x1b7/0x240 [xfs]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2c291f6>] ? xfs_vm_writ=
epage+0x186/0x5a0 [xfs]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81106ead>] ? __writepage=
+0xd/0x40
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff811077af>] ? write_cache=
_pages+0x1bf/0x430
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81106ea0>] ? global_dirt=
yable_memory+0x50/0x50
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2d299c2>] ? ext4_writep=
ages+0x3f2/0xd00 [ext4]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81107a58>] ? generic_wri=
tepages+0x38/0x50
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff8116db61>] ? __writeback=
_single_inode+0x41/0x2b0
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff811700b8>] ? writeback_s=
b_inodes+0x1b8/0x470
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff811703fe>] ? __writeback=
_inodes_wb+0x8e/0xc0
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81170683>] ? wb_writebac=
k+0x253/0x350
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81170b8a>] ? bdi_writeba=
ck_workfn+0x2ca/0x480
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81071b95>] ? process_one=
_work+0x155/0x440
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81072543>] ? worker_thre=
ad+0x63/0x490
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff810724e0>] ? rescuer_thr=
ead+0x290/0x290
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff810769ee>] ? kthread+0xc=
e/0xf0
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81450fd8>] ? ret_from_fo=
rk+0x58/0x90
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:11:42 Colorstock-01 kernel: ---[ end trace 8ff2f50e12a8faac ]---
avril 04 10:11:42 Colorstock-01 kernel: BUG: unable to handle kernel paging=
 request at ffffffffffffffd8
avril 04 10:11:42 Colorstock-01 kernel: IP: [<ffffffff81076ff7>] kthread_da=
ta+0x7/0x10
avril 04 10:11:42 Colorstock-01 kernel: PGD 15ec067 PUD 15ee067 PMD 0=20
avril 04 10:11:42 Colorstock-01 kernel: Oops: 0000 [#2] SMP=20
avril 04 10:11:42 Colorstock-01 kernel: Modules linked in: nfsv3 arc4 ecb m=
d4 nfsv4 cifs fscache dm_mod cfg80211 rfkill nfsd auth_rpcgss oid_registry =
nfs_acl nfs lockd grace sunrpc af_packet bonding joydev evdev x86_pkg_temp_=
thermal coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32c_intel a=
esni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd microcode=
 pcspkr myri10ge ast ttm drm_kms_helper drm i2c_algo_bit ixgbe ptp pps_core=
 mdio dca ses enclosure i2c_i801 sg i2c_core lpc_ich mfd_core ipmi_si 8250_=
fintek ipmi_msghandler rtc_cmos wmi processor thermal_sys acpi_power_meter =
button md_mod usbhid xhci_pci xhci_hcd ohci_pci ehci_pci ohci_hcd uhci_hcd =
ehci_hcd uas usb_storage usbcore usb_common fuse ipv6 autofs4 ext4 ext3 xfs=
 reiserfs crc16 jbd2 jbd aacraid ahci libahci ata_generic libata
avril 04 10:11:42 Colorstock-01 kernel: CPU: 12 PID: 2375 Comm: kworker/u64=
:0 Tainted: G      D W      3.18.44-storiq64-i7 #1
avril 04 10:11:42 Colorstock-01 kernel: Hardware name: Supermicro Super Ser=
ver/X10DRD-iNT, BIOS 2.0 12/17/2015
avril 04 10:11:42 Colorstock-01 kernel: task: ffff88085685a820 ti: ffff8800=
747a0000 task.ti: ffff8800747a0000
avril 04 10:11:42 Colorstock-01 kernel: RIP: 0010:[<ffffffff81076ff7>]  [<f=
fffffff81076ff7>] kthread_data+0x7/0x10
avril 04 10:11:42 Colorstock-01 kernel: RSP: 0018:ffff8800747a3250  EFLAGS:=
 00010002
avril 04 10:11:42 Colorstock-01 kernel: RAX: 0000000000000000 RBX: 00000000=
0000000c RCX: 0000000000000000
avril 04 10:11:42 Colorstock-01 kernel: RDX: 000000000000000f RSI: 00000000=
0000000c RDI: ffff88085685a820
avril 04 10:11:42 Colorstock-01 kernel: RBP: ffff88085685a820 R08: 00000000=
00000000 R09: ffff8808569686c8
avril 04 10:11:42 Colorstock-01 kernel: R10: ffffffff817c38ec R11: 00000000=
0000001a R12: ffff88087f392c40
avril 04 10:11:42 Colorstock-01 kernel: R13: ffff88085685ac68 R14: 00000000=
0000000c R15: ffff88085685a820
avril 04 10:11:42 Colorstock-01 kernel: FS:  0000000000000000(0000) GS:ffff=
88087f380000(0000) knlGS:0000000000000000
avril 04 10:11:42 Colorstock-01 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00=
00000080050033
avril 04 10:11:42 Colorstock-01 kernel: CR2: 0000000000000028 CR3: 00000000=
015e9000 CR4: 00000000003407e0
avril 04 10:11:42 Colorstock-01 kernel: DR0: 0000000000000000 DR1: 00000000=
00000000 DR2: 0000000000000000
avril 04 10:11:42 Colorstock-01 kernel: DR3: 0000000000000000 DR6: 00000000=
fffe0ff0 DR7: 0000000000000400
avril 04 10:11:42 Colorstock-01 kernel: Stack:
avril 04 10:11:42 Colorstock-01 kernel:  ffffffff810729e8 0000000000000000 =
ffffffff8144becb ffff8800747a3268
avril 04 10:11:42 Colorstock-01 kernel:  ffff8800747a3268 0000000000012c40 =
ffff8800747a3fd8 0000000000012c40
avril 04 10:11:42 Colorstock-01 kernel:  ffff88085685a820 ffff88085685a810 =
ffff8800747a2fb8 ffff88085685a810
avril 04 10:11:42 Colorstock-01 kernel: Call Trace:
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff810729e8>] ? wq_worker_s=
leeping+0x8/0x90
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff8144becb>] ? __schedule+=
0x73b/0x8a0
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff8105d4a7>] ? do_exit+0x8=
67/0xb50
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81017282>] ? oops_end+0x=
92/0xd0
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff8104fee6>] ? no_context+=
0x106/0x360
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff810505de>] ? __do_page_f=
ault+0x9e/0x4b0
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2c0cb9d>] ? xfs_btree_u=
pdate+0xbd/0xd0 [xfs]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81452f38>] ? page_fault+=
0x28/0x30
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff811614d5>] ? iput+0x5/0x=
190
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2c357b6>] ? xfs_filestr=
eam_lookup_ag+0x76/0x1b0 [xfs]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2c0438d>] ? xfs_bmap_bt=
alloc+0x2dd/0x770 [xfs]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2bfc192>] ? xfs_bmap_se=
arch_multi_extents+0xa2/0x120 [xfs]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2c03a06>] ? xfs_bmap_la=
st_extent+0x56/0x80 [xfs]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2c03a56>] ? xfs_bmap_is=
aeof+0x26/0x90 [xfs]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2c05211>] ? xfs_bmapi_w=
rite+0x4b1/0xaa0 [xfs]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2c3ca61>] ? xfs_iomap_w=
rite_allocate+0x131/0x350 [xfs]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2c283d7>] ? xfs_map_blo=
cks+0x1b7/0x240 [xfs]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2c291f6>] ? xfs_vm_writ=
epage+0x186/0x5a0 [xfs]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81106ead>] ? __writepage=
+0xd/0x40
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff811077af>] ? write_cache=
_pages+0x1bf/0x430
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81106ea0>] ? global_dirt=
yable_memory+0x50/0x50
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffffa2d299c2>] ? ext4_writep=
ages+0x3f2/0xd00 [ext4]
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81107a58>] ? generic_wri=
tepages+0x38/0x50
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff8116db61>] ? __writeback=
_single_inode+0x41/0x2b0
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff811700b8>] ? writeback_s=
b_inodes+0x1b8/0x470
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff811703fe>] ? __writeback=
_inodes_wb+0x8e/0xc0
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81170683>] ? wb_writebac=
k+0x253/0x350
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81170b8a>] ? bdi_writeba=
ck_workfn+0x2ca/0x480
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81071b95>] ? process_one=
_work+0x155/0x440
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81072543>] ? worker_thre=
ad+0x63/0x490
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff810724e0>] ? rescuer_thr=
ead+0x290/0x290
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff810769ee>] ? kthread+0xc=
e/0xf0
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81450fd8>] ? ret_from_fo=
rk+0x58/0x90
avril 04 10:11:42 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:11:42 Colorstock-01 kernel: Code: eb ae 66 90 65 48 8b 04 25 00=
 b9 00 00 48 8b 80 f0 03 00 00 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 0f 1f 40=
 00 48 8b 87 f0 03 00 00 <48> 8b 40 d8 c3 0f 1f 40 00 48 83 ec 18 48 8b b7 =
f0 03 00 00 ba=20
avril 04 10:11:42 Colorstock-01 kernel: RIP  [<ffffffff81076ff7>] kthread_d=
ata+0x7/0x10
avril 04 10:11:42 Colorstock-01 kernel:  RSP <ffff8800747a3250>
avril 04 10:11:42 Colorstock-01 kernel: CR2: ffffffffffffffd8
avril 04 10:11:42 Colorstock-01 kernel: ---[ end trace 8ff2f50e12a8faad ]---
avril 04 10:11:42 Colorstock-01 kernel: Fixing recursive fault but reboot i=
s needed!
avril 04 10:12:03 Colorstock-01 kernel: INFO: rcu_sched detected stalls on =
CPUs/tasks: { 12} (detected by 3, t=3D21002 jiffies, g=3D5299726, c=3D52997=
25, q=3D34120)
avril 04 10:12:03 Colorstock-01 kernel: Task dump for CPU 12:
avril 04 10:12:03 Colorstock-01 kernel: kworker/u64:0   D ffff880078271370 =
    0  2375      2 0x00000008
avril 04 10:12:03 Colorstock-01 kernel:  ffff88083c143f40 ffff88087be9ac00 =
0000000000000000 ffff88087be9bb00
avril 04 10:12:03 Colorstock-01 kernel:  0000000000000800 ffffffff81071b95 =
0000000000012c40 000000005685a820
avril 04 10:12:03 Colorstock-01 kernel:  ffff88087be9ac00 ffff88083c143f40 =
ffff88083c143f70 ffff88087be9ac00
avril 04 10:12:03 Colorstock-01 kernel: Call Trace:
avril 04 10:12:03 Colorstock-01 kernel:  [<ffffffff81071b95>] ? process_one=
_work+0x155/0x440
avril 04 10:12:03 Colorstock-01 kernel:  [<ffffffff81072543>] ? worker_thre=
ad+0x63/0x490
avril 04 10:12:03 Colorstock-01 kernel:  [<ffffffff810724e0>] ? rescuer_thr=
ead+0x290/0x290
avril 04 10:12:03 Colorstock-01 kernel:  [<ffffffff810769ee>] ? kthread+0xc=
e/0xf0
avril 04 10:12:03 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:12:03 Colorstock-01 kernel:  [<ffffffff81450fd8>] ? ret_from_fo=
rk+0x58/0x90
avril 04 10:12:03 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:13:06 Colorstock-01 kernel: INFO: rcu_sched detected stalls on =
CPUs/tasks: { 12} (detected by 1, t=3D84007 jiffies, g=3D5299726, c=3D52997=
25, q=3D197079)
avril 04 10:13:06 Colorstock-01 kernel: Task dump for CPU 12:
avril 04 10:13:06 Colorstock-01 kernel: kworker/u64:0   D ffff880078271370 =
    0  2375      2 0x00000008
avril 04 10:13:06 Colorstock-01 kernel:  ffff88083c143f40 ffff88087be9ac00 =
0000000000000000 ffff88087be9bb00
avril 04 10:13:06 Colorstock-01 kernel:  0000000000000800 ffffffff81071b95 =
0000000000012c40 000000005685a820
avril 04 10:13:06 Colorstock-01 kernel:  ffff88087be9ac00 ffff88083c143f40 =
ffff88083c143f70 ffff88087be9ac00
avril 04 10:13:06 Colorstock-01 kernel: Call Trace:
avril 04 10:13:06 Colorstock-01 kernel:  [<ffffffff81071b95>] ? process_one=
_work+0x155/0x440
avril 04 10:13:06 Colorstock-01 kernel:  [<ffffffff81072543>] ? worker_thre=
ad+0x63/0x490
avril 04 10:13:06 Colorstock-01 kernel:  [<ffffffff810724e0>] ? rescuer_thr=
ead+0x290/0x290
avril 04 10:13:06 Colorstock-01 kernel:  [<ffffffff810769ee>] ? kthread+0xc=
e/0xf0
avril 04 10:13:06 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:13:06 Colorstock-01 kernel:  [<ffffffff81450fd8>] ? ret_from_fo=
rk+0x58/0x90
avril 04 10:13:06 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:13:37 Colorstock-01 kernel: BUG: unable to handle kernel NULL p=
ointer dereference at 0000000000000240
avril 04 10:13:37 Colorstock-01 kernel: IP: [<ffffffff811614d5>] iput+0x5/0=
x190
avril 04 10:13:37 Colorstock-01 kernel: PGD 0=20
avril 04 10:13:37 Colorstock-01 kernel: Oops: 0000 [#3] SMP=20
avril 04 10:13:37 Colorstock-01 kernel: Modules linked in: nfsv3 arc4 ecb m=
d4 nfsv4 cifs fscache dm_mod cfg80211 rfkill nfsd auth_rpcgss oid_registry =
nfs_acl nfs lockd grace sunrpc af_packet bonding joydev evdev x86_pkg_temp_=
thermal coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32c_intel a=
esni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd microcode=
 pcspkr myri10ge ast ttm drm_kms_helper drm i2c_algo_bit ixgbe ptp pps_core=
 mdio dca ses enclosure i2c_i801 sg i2c_core lpc_ich mfd_core ipmi_si 8250_=
fintek ipmi_msghandler rtc_cmos wmi processor thermal_sys acpi_power_meter =
button md_mod usbhid xhci_pci xhci_hcd ohci_pci ehci_pci ohci_hcd uhci_hcd =
ehci_hcd uas usb_storage usbcore usb_common fuse ipv6 autofs4 ext4 ext3 xfs=
 reiserfs crc16 jbd2 jbd aacraid ahci libahci ata_generic libata
avril 04 10:13:37 Colorstock-01 kernel: CPU: 6 PID: 147 Comm: kswapd0 Taint=
ed: G      D W      3.18.44-storiq64-i7 #1
avril 04 10:13:37 Colorstock-01 kernel: Hardware name: Supermicro Super Ser=
ver/X10DRD-iNT, BIOS 2.0 12/17/2015
avril 04 10:13:37 Colorstock-01 kernel: task: ffff88085e23cf60 ti: ffff8808=
5db94000 task.ti: ffff88085db94000
avril 04 10:13:37 Colorstock-01 kernel: RIP: 0010:[<ffffffff811614d5>]  [<f=
fffffff811614d5>] iput+0x5/0x190
avril 04 10:13:37 Colorstock-01 kernel: RSP: 0018:ffff88085db975b0  EFLAGS:=
 00010202
avril 04 10:13:37 Colorstock-01 kernel: RAX: 0000000000000000 RBX: ffff8808=
545b7000 RCX: 000ffffffffe0000
avril 04 10:13:37 Colorstock-01 kernel: RDX: 0000000000000000 RSI: 00000000=
000003f0 RDI: 00000000000001a8
avril 04 10:13:37 Colorstock-01 kernel: RBP: 0000000000000000 R08: ffff8808=
5db976a4 R09: ffff88085db97770
avril 04 10:13:37 Colorstock-01 kernel: R10: 0000000000000001 R11: 00000000=
00000000 R12: ffff8801ef597800
avril 04 10:13:37 Colorstock-01 kernel: R13: 0000000000000000 R14: ffff8808=
5db97801 R15: ffff8808545b7000
avril 04 10:13:37 Colorstock-01 kernel: FS:  0000000000000000(0000) GS:ffff=
88087f2c0000(0000) knlGS:0000000000000000
avril 04 10:13:37 Colorstock-01 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00=
00000080050033
avril 04 10:13:37 Colorstock-01 kernel: CR2: 0000000000000240 CR3: 00000000=
015e9000 CR4: 00000000003407e0
avril 04 10:13:37 Colorstock-01 kernel: DR0: 0000000000000000 DR1: 00000000=
00000000 DR2: 0000000000000000
avril 04 10:13:37 Colorstock-01 kernel: DR3: 0000000000000000 DR6: 00000000=
fffe0ff0 DR7: 0000000000000400
avril 04 10:13:37 Colorstock-01 kernel: Stack:
avril 04 10:13:37 Colorstock-01 kernel:  ffffffffa2c357b6 0000000000000000 =
ffffffffef597860 ffff8801ef597840
avril 04 10:13:37 Colorstock-01 kernel:  ffff88085db97750 ffff88085db97750 =
0000000000000010 0000000000000000
avril 04 10:13:37 Colorstock-01 kernel:  ffffffffa2c0438d 0000000000000004 =
ffff88085db97790 ffff88085db977d0
avril 04 10:13:37 Colorstock-01 kernel: Call Trace:
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffffa2c357b6>] ? xfs_filestr=
eam_lookup_ag+0x76/0x1b0 [xfs]
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffffa2c0438d>] ? xfs_bmap_bt=
alloc+0x2dd/0x770 [xfs]
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffffa2bfc192>] ? xfs_bmap_se=
arch_multi_extents+0xa2/0x120 [xfs]
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffffa2c03a06>] ? xfs_bmap_la=
st_extent+0x56/0x80 [xfs]
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffffa2c03a56>] ? xfs_bmap_is=
aeof+0x26/0x90 [xfs]
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffffa2c05211>] ? xfs_bmapi_w=
rite+0x4b1/0xaa0 [xfs]
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffffa2c3ca61>] ? xfs_iomap_w=
rite_allocate+0x131/0x350 [xfs]
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffffa2c283d7>] ? xfs_map_blo=
cks+0x1b7/0x240 [xfs]
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffffa2c291f6>] ? xfs_vm_writ=
epage+0x186/0x5a0 [xfs]
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff8110f1e5>] ? shrink_page=
_list+0x515/0xa20
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff8110fcf2>] ? shrink_inac=
tive_list+0x262/0x4f0
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff811107d1>] ? shrink_lruv=
ec+0x521/0x650
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff81120153>] ? list_lru_co=
unt_node+0x13/0x50
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff81110941>] ? shrink_zone=
+0x41/0x120
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff81111317>] ? balance_pgd=
at+0x3a7/0x5e0
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff811116bc>] ? kswapd+0x16=
c/0x490
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff810906e0>] ? wait_woken+=
0x60/0x60
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff81111550>] ? balance_pgd=
at+0x5e0/0x5e0
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff810769ee>] ? kthread+0xc=
e/0xf0
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff81450fd8>] ? ret_from_fo=
rk+0x58/0x90
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:13:37 Colorstock-01 kernel: Code: 08 48 8d b8 00 04 00 00 e8 e9=
 eb fb ff 84 c0 74 09 65 48 ff 04 25 18 f5 00 00 48 83 c4 08 c3 0f 1f 80 00=
 00 00 00 48 85 ff 74 3e <f6> 87 98 00 00 00 40 0f 85 fe 00 00 00 41 55 41 =
54 55 48 8d af=20
avril 04 10:13:37 Colorstock-01 kernel: RIP  [<ffffffff811614d5>] iput+0x5/=
0x190
avril 04 10:13:37 Colorstock-01 kernel:  RSP <ffff88085db975b0>
avril 04 10:13:37 Colorstock-01 kernel: CR2: 0000000000000240
avril 04 10:13:37 Colorstock-01 kernel: ---[ end trace 8ff2f50e12a8faae ]---
avril 04 10:13:37 Colorstock-01 kernel: ------------[ cut here ]------------
avril 04 10:13:37 Colorstock-01 kernel: WARNING: CPU: 6 PID: 147 at kernel/=
exit.c:675 do_exit+0x48/0xb50()
avril 04 10:13:37 Colorstock-01 kernel: Modules linked in: nfsv3 arc4 ecb m=
d4 nfsv4 cifs fscache dm_mod cfg80211 rfkill nfsd auth_rpcgss oid_registry =
nfs_acl nfs lockd grace sunrpc af_packet bonding joydev evdev x86_pkg_temp_=
thermal coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32c_intel a=
esni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd microcode=
 pcspkr myri10ge ast ttm drm_kms_helper drm i2c_algo_bit ixgbe ptp pps_core=
 mdio dca ses enclosure i2c_i801 sg i2c_core lpc_ich mfd_core ipmi_si 8250_=
fintek ipmi_msghandler rtc_cmos wmi processor thermal_sys acpi_power_meter =
button md_mod usbhid xhci_pci xhci_hcd ohci_pci ehci_pci ohci_hcd uhci_hcd =
ehci_hcd uas usb_storage usbcore usb_common fuse ipv6 autofs4 ext4 ext3 xfs=
 reiserfs crc16 jbd2 jbd aacraid ahci libahci ata_generic libata
avril 04 10:13:37 Colorstock-01 kernel: CPU: 6 PID: 147 Comm: kswapd0 Taint=
ed: G      D W      3.18.44-storiq64-i7 #1
avril 04 10:13:37 Colorstock-01 kernel: Hardware name: Supermicro Super Ser=
ver/X10DRD-iNT, BIOS 2.0 12/17/2015
avril 04 10:13:37 Colorstock-01 kernel:  0000000000000086 0000000000000000 =
ffffffff8144a289 0000000000000007
avril 04 10:13:37 Colorstock-01 kernel:  0000000000000000 0000000000000009 =
ffffffff8105b952 0000000000000009
avril 04 10:13:37 Colorstock-01 kernel:  0000000000000092 ffff88085db97508 =
0000000000000240 0000000000000092
avril 04 10:13:37 Colorstock-01 kernel: Call Trace:
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff8144a289>] ? dump_stack+=
0x5e/0x7a
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff8105b952>] ? warn_slowpa=
th_common+0x72/0x90
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff8105cc88>] ? do_exit+0x4=
8/0xb50
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff8144953c>] ? printk+0x4f=
/0x54
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff81017282>] ? oops_end+0x=
92/0xd0
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff8104fee6>] ? no_context+=
0x106/0x360
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff810505de>] ? __do_page_f=
ault+0x9e/0x4b0
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff81385e52>] ? __domain_ma=
pping+0x1e2/0x3c0
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff8138825a>] ? intel_map_s=
g+0x16a/0x240
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff81201fa3>] ? __blk_bios_=
map_sg+0x1b3/0x3c0
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff81452f38>] ? page_fault+=
0x28/0x30
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff811614d5>] ? iput+0x5/0x=
190
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffffa2c357b6>] ? xfs_filestr=
eam_lookup_ag+0x76/0x1b0 [xfs]
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffffa2c0438d>] ? xfs_bmap_bt=
alloc+0x2dd/0x770 [xfs]
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffffa2bfc192>] ? xfs_bmap_se=
arch_multi_extents+0xa2/0x120 [xfs]
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffffa2c03a06>] ? xfs_bmap_la=
st_extent+0x56/0x80 [xfs]
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffffa2c03a56>] ? xfs_bmap_is=
aeof+0x26/0x90 [xfs]
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffffa2c05211>] ? xfs_bmapi_w=
rite+0x4b1/0xaa0 [xfs]
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffffa2c3ca61>] ? xfs_iomap_w=
rite_allocate+0x131/0x350 [xfs]
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffffa2c283d7>] ? xfs_map_blo=
cks+0x1b7/0x240 [xfs]
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffffa2c291f6>] ? xfs_vm_writ=
epage+0x186/0x5a0 [xfs]
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff8110f1e5>] ? shrink_page=
_list+0x515/0xa20
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff8110fcf2>] ? shrink_inac=
tive_list+0x262/0x4f0
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff811107d1>] ? shrink_lruv=
ec+0x521/0x650
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff81120153>] ? list_lru_co=
unt_node+0x13/0x50
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff81110941>] ? shrink_zone=
+0x41/0x120
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff81111317>] ? balance_pgd=
at+0x3a7/0x5e0
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff811116bc>] ? kswapd+0x16=
c/0x490
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff810906e0>] ? wait_woken+=
0x60/0x60
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff81111550>] ? balance_pgd=
at+0x5e0/0x5e0
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff810769ee>] ? kthread+0xc=
e/0xf0
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff81450fd8>] ? ret_from_fo=
rk+0x58/0x90
avril 04 10:13:37 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:13:37 Colorstock-01 kernel: ---[ end trace 8ff2f50e12a8faaf ]---
avril 04 10:14:01 Colorstock-01 CRON[14140]: pam_unix(cron:session): sessio=
n opened for user munin by (uid=3D0)
avril 04 10:14:01 Colorstock-01 CRON[14147]: (munin) CMD (if [ -x /usr/shar=
e/munin/munin-limits ]; then /usr/share/munin/munin-limits --force --contac=
t nagios --contact old-nagios; fi)
avril 04 10:14:01 Colorstock-01 CRON[14140]: pam_unix(cron:session): sessio=
n closed for user munin
avril 04 10:14:01 Colorstock-01 systemd-journal[1218]: Forwarding to syslog=
 missed 3 messages.
avril 04 10:14:09 Colorstock-01 kernel: INFO: rcu_sched detected stalls on =
CPUs/tasks: { 12} (detected by 18, t=3D147012 jiffies, g=3D5299726, c=3D529=
9725, q=3D404660)
avril 04 10:14:09 Colorstock-01 kernel: Task dump for CPU 12:
avril 04 10:14:09 Colorstock-01 kernel: kworker/u64:0   D ffff880078271370 =
    0  2375      2 0x00000008
avril 04 10:14:09 Colorstock-01 kernel:  ffff88083c143f40 ffff88087be9ac00 =
0000000000000000 ffff88087be9bb00
avril 04 10:14:09 Colorstock-01 kernel:  0000000000000800 ffffffff81071b95 =
0000000000012c40 000000005685a820
avril 04 10:14:09 Colorstock-01 kernel:  ffff88087be9ac00 ffff88083c143f40 =
ffff88083c143f70 ffff88087be9ac00
avril 04 10:14:09 Colorstock-01 kernel: Call Trace:
avril 04 10:14:09 Colorstock-01 kernel:  [<ffffffff81071b95>] ? process_one=
_work+0x155/0x440
avril 04 10:14:09 Colorstock-01 kernel:  [<ffffffff81072543>] ? worker_thre=
ad+0x63/0x490
avril 04 10:14:09 Colorstock-01 kernel:  [<ffffffff810724e0>] ? rescuer_thr=
ead+0x290/0x290
avril 04 10:14:09 Colorstock-01 kernel:  [<ffffffff810769ee>] ? kthread+0xc=
e/0xf0
avril 04 10:14:09 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:14:09 Colorstock-01 kernel:  [<ffffffff81450fd8>] ? ret_from_fo=
rk+0x58/0x90
avril 04 10:14:09 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:14:53 Colorstock-01 rpc.mountd[2170]: authenticated mount reque=
st from 10.20.45.32:976 for /nas/Colorstock-01/_OUTPUT (/nas/Colorstock-01/=
_OUTPUT)
avril 04 10:14:53 Colorstock-01 systemd-journal[1218]: Forwarding to syslog=
 missed 1 messages.
avril 04 10:14:53 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.32 for /nas/Colorstock-01 (/): not exported
avril 04 10:14:53 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.32 for /nas/Colorstock-01 (/): not exported
avril 04 10:14:53 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.32 for /nas/Colorstock-01 (/): not exported
avril 04 10:14:53 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.32 for /nas/Colorstock-01 (/): not exported
avril 04 10:14:53 Colorstock-01 rpc.mountd[2170]: authenticated mount reque=
st from 10.20.45.32:973 for /nas/Colorstock-01/_INPUT (/nas/Colorstock-01/_=
INPUT)
avril 04 10:14:53 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.32 for /nas/Colorstock-01 (/): not exported
avril 04 10:14:53 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.32 for /nas/Colorstock-01 (/): not exported
avril 04 10:15:01 Colorstock-01 CRON[14156]: pam_unix(cron:session): sessio=
n opened for user root by (uid=3D0)
avril 04 10:15:01 Colorstock-01 CRON[14172]: (root) CMD (if [ -x /etc/munin=
/plugins/apt_all ]; then /etc/munin/plugins/apt_all update 7200 12 >/dev/nu=
ll; elif [ -x /etc/munin/plugins/apt ]; then /etc/munin/plugins/apt update =
7200 12 >/dev/null; fi)
avril 04 10:15:01 Colorstock-01 CRON[14156]: pam_unix(cron:session): sessio=
n closed for user root
avril 04 10:15:03 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.32 for /nas/Colorstock-01 (/): not exported
avril 04 10:15:03 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.32 for /nas/Colorstock-01 (/): not exported
avril 04 10:15:12 Colorstock-01 kernel: INFO: rcu_sched detected stalls on =
CPUs/tasks: { 12} (detected by 28, t=3D210017 jiffies, g=3D5299726, c=3D529=
9725, q=3D596353)
avril 04 10:15:12 Colorstock-01 kernel: Task dump for CPU 12:
avril 04 10:15:12 Colorstock-01 kernel: kworker/u64:0   D ffff880078271370 =
    0  2375      2 0x00000008
avril 04 10:15:12 Colorstock-01 kernel:  ffff88083c143f40 ffff88087be9ac00 =
0000000000000000 ffff88087be9bb00
avril 04 10:15:12 Colorstock-01 kernel:  0000000000000800 ffffffff81071b95 =
0000000000012c40 000000005685a820
avril 04 10:15:12 Colorstock-01 kernel:  ffff88087be9ac00 ffff88083c143f40 =
ffff88083c143f70 ffff88087be9ac00
avril 04 10:15:12 Colorstock-01 kernel: Call Trace:
avril 04 10:15:12 Colorstock-01 kernel:  [<ffffffff81071b95>] ? process_one=
_work+0x155/0x440
avril 04 10:15:12 Colorstock-01 kernel:  [<ffffffff81072543>] ? worker_thre=
ad+0x63/0x490
avril 04 10:15:12 Colorstock-01 kernel:  [<ffffffff810724e0>] ? rescuer_thr=
ead+0x290/0x290
avril 04 10:15:12 Colorstock-01 kernel:  [<ffffffff810769ee>] ? kthread+0xc=
e/0xf0
avril 04 10:15:12 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:15:12 Colorstock-01 kernel:  [<ffffffff81450fd8>] ? ret_from_fo=
rk+0x58/0x90
avril 04 10:15:12 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:15:40 Colorstock-01 systemd-journal[1218]: Forwarding to syslog=
 missed 12 messages.
avril 04 10:15:47 Colorstock-01 rpc.mountd[2170]: authenticated mount reque=
st from 10.20.45.101:1023 for /nas/Colorstock-01/_OUTPUT (/nas/Colorstock-0=
1/_OUTPUT)
avril 04 10:15:47 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:15:47 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:15:47 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:15:47 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:15:47 Colorstock-01 rpc.mountd[2170]: authenticated mount reque=
st from 10.20.45.101:1020 for /nas/Colorstock-01/_INPUT (/nas/Colorstock-01=
/_INPUT)
avril 04 10:15:47 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:15:47 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:15:47 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:15:47 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:15:47 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:15:47 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:15:47 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:15:47 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:15:47 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:15:47 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:15:47 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:15:47 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:15:47 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:15:47 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:15:47 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:15:47 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:15:47 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:15:47 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:15:59 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:15:59 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:15:59 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:15:59 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:16:15 Colorstock-01 kernel: INFO: rcu_sched detected stalls on =
CPUs/tasks: { 12} (detected by 0, t=3D273022 jiffies, g=3D5299726, c=3D5299=
725, q=3D788855)
avril 04 10:16:15 Colorstock-01 systemd-journal[1218]: Forwarding to syslog=
 missed 28 messages.
avril 04 10:16:15 Colorstock-01 kernel: Task dump for CPU 12:
avril 04 10:16:15 Colorstock-01 kernel: kworker/u64:0   D ffff880078271370 =
    0  2375      2 0x00000008
avril 04 10:16:15 Colorstock-01 kernel:  ffff88083c143f40 ffff88087be9ac00 =
0000000000000000 ffff88087be9bb00
avril 04 10:16:15 Colorstock-01 kernel:  0000000000000800 ffffffff81071b95 =
0000000000012c40 000000005685a820
avril 04 10:16:15 Colorstock-01 kernel:  ffff88087be9ac00 ffff88083c143f40 =
ffff88083c143f70 ffff88087be9ac00
avril 04 10:16:15 Colorstock-01 kernel: Call Trace:
avril 04 10:16:15 Colorstock-01 kernel:  [<ffffffff81071b95>] ? process_one=
_work+0x155/0x440
avril 04 10:16:15 Colorstock-01 kernel:  [<ffffffff81072543>] ? worker_thre=
ad+0x63/0x490
avril 04 10:16:15 Colorstock-01 kernel:  [<ffffffff810724e0>] ? rescuer_thr=
ead+0x290/0x290
avril 04 10:16:15 Colorstock-01 kernel:  [<ffffffff810769ee>] ? kthread+0xc=
e/0xf0
avril 04 10:16:15 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:16:15 Colorstock-01 kernel:  [<ffffffff81450fd8>] ? ret_from_fo=
rk+0x58/0x90
avril 04 10:16:15 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:16:48 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:16:48 Colorstock-01 systemd-journal[1218]: Forwarding to syslog=
 missed 1 messages.
avril 04 10:16:48 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:16:48 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:16:48 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:17:01 Colorstock-01 CRON[14180]: pam_unix(cron:session): sessio=
n opened for user root by (uid=3D0)
avril 04 10:17:18 Colorstock-01 kernel: INFO: rcu_sched detected stalls on =
CPUs/tasks: { 12} (detected by 17, t=3D336027 jiffies, g=3D5299726, c=3D529=
9725, q=3D1028813)
avril 04 10:17:18 Colorstock-01 systemd-journal[1218]: Forwarding to syslog=
 missed 4 messages.
avril 04 10:17:18 Colorstock-01 kernel: Task dump for CPU 12:
avril 04 10:17:18 Colorstock-01 kernel: kworker/u64:0   D ffff880078271370 =
    0  2375      2 0x00000008
avril 04 10:17:18 Colorstock-01 kernel:  ffff88083c143f40 ffff88087be9ac00 =
0000000000000000 ffff88087be9bb00
avril 04 10:17:18 Colorstock-01 kernel:  0000000000000800 ffffffff81071b95 =
0000000000012c40 000000005685a820
avril 04 10:17:18 Colorstock-01 kernel:  ffff88087be9ac00 ffff88083c143f40 =
ffff88083c143f70 ffff88087be9ac00
avril 04 10:17:18 Colorstock-01 kernel: Call Trace:
avril 04 10:17:18 Colorstock-01 kernel:  [<ffffffff81071b95>] ? process_one=
_work+0x155/0x440
avril 04 10:17:18 Colorstock-01 kernel:  [<ffffffff81072543>] ? worker_thre=
ad+0x63/0x490
avril 04 10:17:18 Colorstock-01 kernel:  [<ffffffff810724e0>] ? rescuer_thr=
ead+0x290/0x290
avril 04 10:17:18 Colorstock-01 kernel:  [<ffffffff810769ee>] ? kthread+0xc=
e/0xf0
avril 04 10:17:18 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:17:18 Colorstock-01 kernel:  [<ffffffff81450fd8>] ? ret_from_fo=
rk+0x58/0x90
avril 04 10:17:18 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:18:21 Colorstock-01 kernel: INFO: rcu_sched detected stalls on =
CPUs/tasks: { 12} (detected by 23, t=3D399032 jiffies, g=3D5299726, c=3D529=
9725, q=3D1093083)
avril 04 10:18:21 Colorstock-01 kernel: Task dump for CPU 12:
avril 04 10:18:21 Colorstock-01 kernel: kworker/u64:0   D ffff880078271370 =
    0  2375      2 0x00000008
avril 04 10:18:21 Colorstock-01 kernel:  ffff88083c143f40 ffff88087be9ac00 =
0000000000000000 ffff88087be9bb00
avril 04 10:18:21 Colorstock-01 kernel:  0000000000000800 ffffffff81071b95 =
0000000000012c40 000000005685a820
avril 04 10:18:21 Colorstock-01 kernel:  ffff88087be9ac00 ffff88083c143f40 =
ffff88083c143f70 ffff88087be9ac00
avril 04 10:18:21 Colorstock-01 kernel: Call Trace:
avril 04 10:18:21 Colorstock-01 kernel:  [<ffffffff81071b95>] ? process_one=
_work+0x155/0x440
avril 04 10:18:21 Colorstock-01 kernel:  [<ffffffff81072543>] ? worker_thre=
ad+0x63/0x490
avril 04 10:18:21 Colorstock-01 kernel:  [<ffffffff810724e0>] ? rescuer_thr=
ead+0x290/0x290
avril 04 10:18:21 Colorstock-01 kernel:  [<ffffffff810769ee>] ? kthread+0xc=
e/0xf0
avril 04 10:18:21 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:18:21 Colorstock-01 kernel:  [<ffffffff81450fd8>] ? ret_from_fo=
rk+0x58/0x90
avril 04 10:18:21 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:18:54 Colorstock-01 rpc.mountd[2170]: authenticated mount reque=
st from 10.20.92.10:960 for /nas/Colorstock-01/_INPUT (/nas/Colorstock-01/_=
INPUT)
avril 04 10:18:54 Colorstock-01 rpc.mountd[2170]: authenticated mount reque=
st from 10.20.92.10:679 for /nas/Colorstock-01/_OUTPUT (/nas/Colorstock-01/=
_OUTPUT)
avril 04 10:18:54 Colorstock-01 systemd-journal[1218]: Forwarding to syslog=
 missed 2 messages.
avril 04 10:19:01 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:19:01 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:19:01 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:19:01 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:19:19 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.96.11 for /nas/Colorstock-01 (/): not exported
avril 04 10:19:19 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.96.11 for /nas/Colorstock-01 (/): not exported
avril 04 10:19:19 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.96.11 for /nas/Colorstock-01 (/): not exported
avril 04 10:19:19 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.96.11 for /nas/Colorstock-01 (/): not exported
avril 04 10:19:24 Colorstock-01 kernel: INFO: rcu_sched detected stalls on =
CPUs/tasks: { 12} (detected by 17, t=3D462037 jiffies, g=3D5299726, c=3D529=
9725, q=3D1155263)
avril 04 10:19:24 Colorstock-01 systemd-journal[1218]: Forwarding to syslog=
 missed 8 messages.
avril 04 10:19:24 Colorstock-01 kernel: Task dump for CPU 12:
avril 04 10:19:24 Colorstock-01 kernel: kworker/u64:0   D ffff880078271370 =
    0  2375      2 0x00000008
avril 04 10:19:24 Colorstock-01 kernel:  ffff88083c143f40 ffff88087be9ac00 =
0000000000000000 ffff88087be9bb00
avril 04 10:19:24 Colorstock-01 kernel:  0000000000000800 ffffffff81071b95 =
0000000000012c40 000000005685a820
avril 04 10:19:24 Colorstock-01 kernel:  ffff88087be9ac00 ffff88083c143f40 =
ffff88083c143f70 ffff88087be9ac00
avril 04 10:19:24 Colorstock-01 kernel: Call Trace:
avril 04 10:19:24 Colorstock-01 kernel:  [<ffffffff81071b95>] ? process_one=
_work+0x155/0x440
avril 04 10:19:24 Colorstock-01 kernel:  [<ffffffff81072543>] ? worker_thre=
ad+0x63/0x490
avril 04 10:19:24 Colorstock-01 kernel:  [<ffffffff810724e0>] ? rescuer_thr=
ead+0x290/0x290
avril 04 10:19:24 Colorstock-01 kernel:  [<ffffffff810769ee>] ? kthread+0xc=
e/0xf0
avril 04 10:19:24 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:19:24 Colorstock-01 kernel:  [<ffffffff81450fd8>] ? ret_from_fo=
rk+0x58/0x90
avril 04 10:19:24 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:19:27 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:19:27 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:19:27 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:19:27 Colorstock-01 rpc.mountd[2170]: refused mount request fro=
m 10.20.45.101 for /nas/Colorstock-01 (/): not exported
avril 04 10:20:00 Colorstock-01 systemd-journal[1218]: Forwarding to syslog=
 missed 4 messages.
avril 04 10:20:01 Colorstock-01 CRON[14187]: pam_unix(cron:session): sessio=
n opened for user munin by (uid=3D0)
avril 04 10:20:01 Colorstock-01 CRON[14188]: pam_unix(cron:session): sessio=
n opened for user root by (uid=3D0)
avril 04 10:20:01 Colorstock-01 CRON[14201]: (munin) CMD (if [ -x /usr/bin/=
munin-cron ]; then /usr/bin/munin-cron; fi)
avril 04 10:20:27 Colorstock-01 kernel: INFO: rcu_sched detected stalls on =
CPUs/tasks: { 12} (detected by 22, t=3D525042 jiffies, g=3D5299726, c=3D529=
9725, q=3D1160381)
avril 04 10:20:27 Colorstock-01 kernel: Task dump for CPU 12:
avril 04 10:20:27 Colorstock-01 kernel: kworker/u64:0   D ffff880078271370 =
    0  2375      2 0x00000008
avril 04 10:20:27 Colorstock-01 kernel:  ffff88083c143f40 ffff88087be9ac00 =
0000000000000000 ffff88087be9bb00
avril 04 10:20:27 Colorstock-01 kernel:  0000000000000800 ffffffff81071b95 =
0000000000012c40 000000005685a820
avril 04 10:20:27 Colorstock-01 kernel:  ffff88087be9ac00 ffff88083c143f40 =
ffff88083c143f70 ffff88087be9ac00
avril 04 10:20:27 Colorstock-01 kernel: Call Trace:
avril 04 10:20:27 Colorstock-01 kernel:  [<ffffffff81071b95>] ? process_one=
_work+0x155/0x440
avril 04 10:20:27 Colorstock-01 kernel:  [<ffffffff81072543>] ? worker_thre=
ad+0x63/0x490
avril 04 10:20:27 Colorstock-01 kernel:  [<ffffffff810724e0>] ? rescuer_thr=
ead+0x290/0x290
avril 04 10:20:27 Colorstock-01 kernel:  [<ffffffff810769ee>] ? kthread+0xc=
e/0xf0
avril 04 10:20:27 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:20:27 Colorstock-01 kernel:  [<ffffffff81450fd8>] ? ret_from_fo=
rk+0x58/0x90
avril 04 10:20:27 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:21:00 Colorstock-01 systemd-journal[1218]: Forwarding to syslog=
 missed 3 messages.
avril 04 10:21:30 Colorstock-01 kernel: INFO: rcu_sched detected stalls on =
CPUs/tasks: { 12} (detected by 22, t=3D588047 jiffies, g=3D5299726, c=3D529=
9725, q=3D1163160)
avril 04 10:21:30 Colorstock-01 kernel: Task dump for CPU 12:
avril 04 10:21:30 Colorstock-01 kernel: kworker/u64:0   D ffff880078271370 =
    0  2375      2 0x00000008
avril 04 10:21:30 Colorstock-01 kernel:  ffff88083c143f40 ffff88087be9ac00 =
0000000000000000 ffff88087be9bb00
avril 04 10:21:30 Colorstock-01 kernel:  0000000000000800 ffffffff81071b95 =
0000000000012c40 000000005685a820
avril 04 10:21:30 Colorstock-01 kernel:  ffff88087be9ac00 ffff88083c143f40 =
ffff88083c143f70 ffff88087be9ac00
avril 04 10:21:30 Colorstock-01 kernel: Call Trace:
avril 04 10:21:30 Colorstock-01 kernel:  [<ffffffff81071b95>] ? process_one=
_work+0x155/0x440
avril 04 10:21:30 Colorstock-01 kernel:  [<ffffffff81072543>] ? worker_thre=
ad+0x63/0x490
avril 04 10:21:30 Colorstock-01 kernel:  [<ffffffff810724e0>] ? rescuer_thr=
ead+0x290/0x290
avril 04 10:21:30 Colorstock-01 kernel:  [<ffffffff810769ee>] ? kthread+0xc=
e/0xf0
avril 04 10:21:30 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:21:30 Colorstock-01 kernel:  [<ffffffff81450fd8>] ? ret_from_fo=
rk+0x58/0x90
avril 04 10:21:30 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:22:33 Colorstock-01 kernel: INFO: rcu_sched detected stalls on =
CPUs/tasks: { 12} (detected by 17, t=3D651052 jiffies, g=3D5299726, c=3D529=
9725, q=3D1199524)
avril 04 10:22:33 Colorstock-01 kernel: Task dump for CPU 12:
avril 04 10:22:33 Colorstock-01 kernel: kworker/u64:0   D ffff880078271370 =
    0  2375      2 0x00000008
avril 04 10:22:33 Colorstock-01 kernel:  ffff88083c143f40 ffff88087be9ac00 =
0000000000000000 ffff88087be9bb00
avril 04 10:22:33 Colorstock-01 kernel:  0000000000000800 ffffffff81071b95 =
0000000000012c40 000000005685a820
avril 04 10:22:33 Colorstock-01 kernel:  ffff88087be9ac00 ffff88083c143f40 =
ffff88083c143f70 ffff88087be9ac00
avril 04 10:22:33 Colorstock-01 kernel: Call Trace:
avril 04 10:22:33 Colorstock-01 kernel:  [<ffffffff81071b95>] ? process_one=
_work+0x155/0x440
avril 04 10:22:33 Colorstock-01 kernel:  [<ffffffff81072543>] ? worker_thre=
ad+0x63/0x490
avril 04 10:22:33 Colorstock-01 kernel:  [<ffffffff810724e0>] ? rescuer_thr=
ead+0x290/0x290
avril 04 10:22:33 Colorstock-01 kernel:  [<ffffffff810769ee>] ? kthread+0xc=
e/0xf0
avril 04 10:22:33 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:22:33 Colorstock-01 kernel:  [<ffffffff81450fd8>] ? ret_from_fo=
rk+0x58/0x90
avril 04 10:22:33 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:23:28 Colorstock-01 rpc.mountd[2170]: authenticated unmount req=
uest from 10.20.96.11:953 for /nas/Colorstock-01/_OUTPUT (/nas/Colorstock-0=
1/_OUTPUT)
avril 04 10:23:28 Colorstock-01 systemd-journal[1218]: Forwarding to syslog=
 missed 1 messages.
avril 04 10:23:28 Colorstock-01 rpc.mountd[2170]: authenticated unmount req=
uest from 10.20.96.11:952 for /nas/Colorstock-01/_INPUT (/nas/Colorstock-01=
/_INPUT)
avril 04 10:23:36 Colorstock-01 kernel: INFO: rcu_sched detected stalls on =
CPUs/tasks: { 12} (detected by 1, t=3D714057 jiffies, g=3D5299726, c=3D5299=
725, q=3D1204173)
avril 04 10:23:36 Colorstock-01 kernel: Task dump for CPU 12:
avril 04 10:23:36 Colorstock-01 kernel: kworker/u64:0   D ffff880078271370 =
    0  2375      2 0x00000008
avril 04 10:23:36 Colorstock-01 kernel:  ffff88083c143f40 ffff88087be9ac00 =
0000000000000000 ffff88087be9bb00
avril 04 10:23:36 Colorstock-01 kernel:  0000000000000800 ffffffff81071b95 =
0000000000012c40 000000005685a820
avril 04 10:23:36 Colorstock-01 kernel:  ffff88087be9ac00 ffff88083c143f40 =
ffff88083c143f70 ffff88087be9ac00
avril 04 10:23:36 Colorstock-01 kernel: Call Trace:
avril 04 10:23:36 Colorstock-01 kernel:  [<ffffffff81071b95>] ? process_one=
_work+0x155/0x440
avril 04 10:23:36 Colorstock-01 kernel:  [<ffffffff81072543>] ? worker_thre=
ad+0x63/0x490
avril 04 10:23:36 Colorstock-01 kernel:  [<ffffffff810724e0>] ? rescuer_thr=
ead+0x290/0x290
avril 04 10:23:36 Colorstock-01 kernel:  [<ffffffff810769ee>] ? kthread+0xc=
e/0xf0
avril 04 10:23:36 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:23:36 Colorstock-01 kernel:  [<ffffffff81450fd8>] ? ret_from_fo=
rk+0x58/0x90
avril 04 10:23:36 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:24:30 Colorstock-01 systemd-journal[1218]: Forwarding to syslog=
 missed 1 messages.
avril 04 10:24:39 Colorstock-01 kernel: INFO: rcu_sched detected stalls on =
CPUs/tasks: { 12} (detected by 1, t=3D777062 jiffies, g=3D5299726, c=3D5299=
725, q=3D1211887)
avril 04 10:24:39 Colorstock-01 kernel: Task dump for CPU 12:
avril 04 10:24:39 Colorstock-01 kernel: kworker/u64:0   D ffff880078271370 =
    0  2375      2 0x00000008
avril 04 10:24:39 Colorstock-01 kernel:  ffff88083c143f40 ffff88087be9ac00 =
0000000000000000 ffff88087be9bb00
avril 04 10:24:39 Colorstock-01 kernel:  0000000000000800 ffffffff81071b95 =
0000000000012c40 000000005685a820
avril 04 10:24:39 Colorstock-01 kernel:  ffff88087be9ac00 ffff88083c143f40 =
ffff88083c143f70 ffff88087be9ac00
avril 04 10:24:39 Colorstock-01 kernel: Call Trace:
avril 04 10:24:39 Colorstock-01 kernel:  [<ffffffff81071b95>] ? process_one=
_work+0x155/0x440
avril 04 10:24:39 Colorstock-01 kernel:  [<ffffffff81072543>] ? worker_thre=
ad+0x63/0x490
avril 04 10:24:39 Colorstock-01 kernel:  [<ffffffff810724e0>] ? rescuer_thr=
ead+0x290/0x290
avril 04 10:24:39 Colorstock-01 kernel:  [<ffffffff810769ee>] ? kthread+0xc=
e/0xf0
avril 04 10:24:39 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:24:39 Colorstock-01 kernel:  [<ffffffff81450fd8>] ? ret_from_fo=
rk+0x58/0x90
avril 04 10:24:39 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:25:42 Colorstock-01 kernel: INFO: rcu_sched detected stalls on =
CPUs/tasks: { 12} (detected by 17, t=3D840067 jiffies, g=3D5299726, c=3D529=
9725, q=3D1226873)
avril 04 10:25:42 Colorstock-01 kernel: Task dump for CPU 12:
avril 04 10:25:42 Colorstock-01 kernel: kworker/u64:0   D ffff880078271370 =
    0  2375      2 0x00000008
avril 04 10:25:42 Colorstock-01 kernel:  ffff88083c143f40 ffff88087be9ac00 =
0000000000000000 ffff88087be9bb00
avril 04 10:25:42 Colorstock-01 kernel:  0000000000000800 ffffffff81071b95 =
0000000000012c40 000000005685a820
avril 04 10:25:42 Colorstock-01 kernel:  ffff88087be9ac00 ffff88083c143f40 =
ffff88083c143f70 ffff88087be9ac00
avril 04 10:25:42 Colorstock-01 kernel: Call Trace:
avril 04 10:25:42 Colorstock-01 kernel:  [<ffffffff81071b95>] ? process_one=
_work+0x155/0x440
avril 04 10:25:42 Colorstock-01 kernel:  [<ffffffff81072543>] ? worker_thre=
ad+0x63/0x490
avril 04 10:25:42 Colorstock-01 kernel:  [<ffffffff810724e0>] ? rescuer_thr=
ead+0x290/0x290
avril 04 10:25:42 Colorstock-01 kernel:  [<ffffffff810769ee>] ? kthread+0xc=
e/0xf0
avril 04 10:25:42 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:25:42 Colorstock-01 kernel:  [<ffffffff81450fd8>] ? ret_from_fo=
rk+0x58/0x90
avril 04 10:25:42 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:26:01 Colorstock-01 systemd[1]: systemd-logind.service watchdog=
 timeout (limit 1min)!
avril 04 10:26:01 Colorstock-01 systemd-journal[1218]: Forwarding to syslog=
 missed 1 messages.
avril 04 10:26:45 Colorstock-01 kernel: INFO: rcu_sched detected stalls on =
CPUs/tasks: { 12} (detected by 1, t=3D903072 jiffies, g=3D5299726, c=3D5299=
725, q=3D1292066)
avril 04 10:26:45 Colorstock-01 kernel: Task dump for CPU 12:
avril 04 10:26:45 Colorstock-01 kernel: kworker/u64:0   D ffff880078271370 =
    0  2375      2 0x00000008
avril 04 10:26:45 Colorstock-01 kernel:  ffff88083c143f40 ffff88087be9ac00 =
0000000000000000 ffff88087be9bb00
avril 04 10:26:45 Colorstock-01 kernel:  0000000000000800 ffffffff81071b95 =
0000000000012c40 000000005685a820
avril 04 10:26:45 Colorstock-01 kernel:  ffff88087be9ac00 ffff88083c143f40 =
ffff88083c143f70 ffff88087be9ac00
avril 04 10:26:45 Colorstock-01 kernel: Call Trace:
avril 04 10:26:45 Colorstock-01 kernel:  [<ffffffff81071b95>] ? process_one=
_work+0x155/0x440
avril 04 10:26:45 Colorstock-01 kernel:  [<ffffffff81072543>] ? worker_thre=
ad+0x63/0x490
avril 04 10:26:45 Colorstock-01 kernel:  [<ffffffff810724e0>] ? rescuer_thr=
ead+0x290/0x290
avril 04 10:26:45 Colorstock-01 kernel:  [<ffffffff810769ee>] ? kthread+0xc=
e/0xf0
avril 04 10:26:45 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:26:45 Colorstock-01 kernel:  [<ffffffff81450fd8>] ? ret_from_fo=
rk+0x58/0x90
avril 04 10:26:45 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:27:31 Colorstock-01 systemd[1]: systemd-logind.service stop-sig=
term timed out. Killing.
avril 04 10:27:31 Colorstock-01 systemd-journal[1218]: Forwarding to syslog=
 missed 1 messages.
avril 04 10:27:48 Colorstock-01 kernel: INFO: rcu_sched detected stalls on =
CPUs/tasks: { 12} (detected by 17, t=3D966077 jiffies, g=3D5299726, c=3D529=
9725, q=3D1299968)
avril 04 10:27:48 Colorstock-01 kernel: Task dump for CPU 12:
avril 04 10:27:48 Colorstock-01 kernel: kworker/u64:0   D ffff880078271370 =
    0  2375      2 0x00000008
avril 04 10:27:48 Colorstock-01 kernel:  ffff88083c143f40 ffff88087be9ac00 =
0000000000000000 ffff88087be9bb00
avril 04 10:27:48 Colorstock-01 kernel:  0000000000000800 ffffffff81071b95 =
0000000000012c40 000000005685a820
avril 04 10:27:48 Colorstock-01 kernel:  ffff88087be9ac00 ffff88083c143f40 =
ffff88083c143f70 ffff88087be9ac00
avril 04 10:27:48 Colorstock-01 kernel: Call Trace:
avril 04 10:27:48 Colorstock-01 kernel:  [<ffffffff81071b95>] ? process_one=
_work+0x155/0x440
avril 04 10:27:48 Colorstock-01 kernel:  [<ffffffff81072543>] ? worker_thre=
ad+0x63/0x490
avril 04 10:27:48 Colorstock-01 kernel:  [<ffffffff810724e0>] ? rescuer_thr=
ead+0x290/0x290
avril 04 10:27:48 Colorstock-01 kernel:  [<ffffffff810769ee>] ? kthread+0xc=
e/0xf0
avril 04 10:27:48 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:27:48 Colorstock-01 kernel:  [<ffffffff81450fd8>] ? ret_from_fo=
rk+0x58/0x90
avril 04 10:27:48 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:28:51 Colorstock-01 kernel: INFO: rcu_sched detected stalls on =
CPUs/tasks: { 12} (detected by 7, t=3D1029082 jiffies, g=3D5299726, c=3D529=
9725, q=3D1353586)
avril 04 10:28:51 Colorstock-01 kernel: Task dump for CPU 12:
avril 04 10:28:51 Colorstock-01 kernel: kworker/u64:0   D ffff880078271370 =
    0  2375      2 0x00000008
avril 04 10:28:51 Colorstock-01 kernel:  ffff88083c143f40 ffff88087be9ac00 =
0000000000000000 ffff88087be9bb00
avril 04 10:28:51 Colorstock-01 kernel:  0000000000000800 ffffffff81071b95 =
0000000000012c40 000000005685a820
avril 04 10:28:51 Colorstock-01 kernel:  ffff88087be9ac00 ffff88083c143f40 =
ffff88083c143f70 ffff88087be9ac00
avril 04 10:28:51 Colorstock-01 kernel: Call Trace:
avril 04 10:28:51 Colorstock-01 kernel:  [<ffffffff81071b95>] ? process_one=
_work+0x155/0x440
avril 04 10:28:51 Colorstock-01 kernel:  [<ffffffff81072543>] ? worker_thre=
ad+0x63/0x490
avril 04 10:28:51 Colorstock-01 kernel:  [<ffffffff810724e0>] ? rescuer_thr=
ead+0x290/0x290
avril 04 10:28:51 Colorstock-01 kernel:  [<ffffffff810769ee>] ? kthread+0xc=
e/0xf0
avril 04 10:28:51 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:28:51 Colorstock-01 kernel:  [<ffffffff81450fd8>] ? ret_from_fo=
rk+0x58/0x90
avril 04 10:28:51 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 10:29:01 Colorstock-01 systemd[1]: systemd-logind.service still ar=
ound after SIGKILL. Ignoring.
avril 04 10:29:01 Colorstock-01 systemd-journal[1218]: Forwarding to syslog=
 missed 1 messages.
-- Reboot --



--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/MSrwHJn_z3j.G7rivzrpzV7
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAljjmUsACgkQX3jQXNUicVYwZACfeymP8Zd/MWRb8y/sj1DkAjkM
iMAAoJcvUF7w4TvSypfkyYfH8tf413RT
=cPQp
-----END PGP SIGNATURE-----

--Sig_/MSrwHJn_z3j.G7rivzrpzV7--
