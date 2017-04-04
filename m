Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:26802 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753080AbdDDRYH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Apr 2017 13:24:07 -0400
Received: from mail1.g1.pair.com (localhost [127.0.0.1])
        by mail1.g1.pair.com (Postfix) with ESMTP id 6CA025479F3
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2017 13:24:06 -0400 (EDT)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail1.g1.pair.com (Postfix) with ESMTPSA id 0839060B209
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2017 13:24:05 -0400 (EDT)
Date: Tue, 4 Apr 2017 19:24:11 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: "interesting" crash : 3.18.44, huge xfs, nfs
Message-ID: <20170404192411.650fb403@harpe.intellique.com>
In-Reply-To: <20170404150202.6c7d032c@harpe.intellique.com>
References: <20170404150202.6c7d032c@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/aTC0=UDuFf4Icb.zx=9xC4z"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

--Sig_/aTC0=UDuFf4Icb.zx=9xC4z
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Tue, 4 Apr 2017 15:02:02 +0200
Emmanuel Florac <eflorac@intellique.com> =C3=A9crivait:

> Hi,=20
> here is an interesting crash dump. I've never seen this function
> called before : "Fixing recursive fault but reboot is needed!"
>=20
> The system is frozen and must be hard rebooted. The filesystem is
> humongous: about 400 TB.
>=20
> Running is plain vanilla 3.18.44 (should upgrade...). I wonder if the
> bug is still present though?=20
>=20
> Context: this is a file server. There was a power failure yesterday,
> so there's probably some corruption hidden somewhere triggering the
> crash.
>=20

The machine goes on crashing on disk access... xfs_repair 4.9 is
running now, and after that we'll reboot with a current kernel
(4.4.59). Any advice?

The latest crash trace was still xfs related apparently:


avril 04 16:22:01 Colorstock-01 kernel: BUG: unable to handle kernel NULL p=
ointer dereference at 0000000000000240
avril 04 16:22:01 Colorstock-01 kernel: IP: [<ffffffff811614d5>] iput+0x5/0=
x190
avril 04 16:22:01 Colorstock-01 kernel: PGD 0
avril 04 16:22:01 Colorstock-01 kernel: Oops: 0000 [#1] SMP
avril 04 16:22:01 Colorstock-01 kernel: Modules linked in: nfsv3 arc4 ecb m=
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
avril 04 16:22:01 Colorstock-01 kernel: CPU: 19 PID: 822 Comm: kworker/u64:=
11 Not tainted 3.18.44-storiq64-i7 #1
avril 04 16:22:01 Colorstock-01 kernel: Hardware name: Supermicro Super Ser=
ver/X10DRD-iNT, BIOS 2.0 12/17/2015
avril 04 16:22:01 Colorstock-01 kernel: Workqueue: writeback bdi_writeback_=
workfn (flush-253:0)
avril 04 16:22:01 Colorstock-01 kernel: task: ffff88085c19a050 ti: ffff8808=
5c1ac000 task.ti: ffff88085c1ac000
avril 04 16:22:01 Colorstock-01 kernel: RIP: 0010:[<ffffffff811614d5>]  [<f=
fffffff811614d5>] iput+0x5/0x190
avril 04 16:22:01 Colorstock-01 kernel: RSP: 0018:ffff88085c1af590  EFLAGS:=
 00010202
avril 04 16:22:01 Colorstock-01 kernel: RAX: 0000000000000000 RBX: ffff8807=
55ea4000 RCX: 000ffffffffe0000
avril 04 16:22:01 Colorstock-01 kernel: RDX: 0000000000000000 RSI: 00000000=
00000060 RDI: 00000000000001a8
avril 04 16:22:01 Colorstock-01 kernel: RBP: 0000000000000000 R08: ffff8808=
5c1af684 R09: ffff88085c1af750
avril 04 16:22:01 Colorstock-01 kernel: R10: 0000000000000001 R11: 00000000=
00000000 R12: ffff880652e45c00
avril 04 16:22:01 Colorstock-01 kernel: R13: 0000000000000000 R14: ffff8808=
5c1af801 R15: ffff880755ea4000
avril 04 16:22:01 Colorstock-01 kernel: FS:  0000000000000000(0000) GS:ffff=
88087f460000(0000) knlGS:0000000000000000
avril 04 16:22:01 Colorstock-01 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00=
00000080050033
avril 04 16:22:01 Colorstock-01 kernel: CR2: 0000000000000240 CR3: 00000000=
015e9000 CR4: 00000000003407e0
avril 04 16:22:01 Colorstock-01 kernel: DR0: 0000000000000000 DR1: 00000000=
00000000 DR2: 0000000000000000
avril 04 16:22:01 Colorstock-01 kernel: DR3: 0000000000000000 DR6: 00000000=
fffe0ff0 DR7: 0000000000000400
avril 04 16:22:01 Colorstock-01 kernel: Stack:
avril 04 16:22:01 Colorstock-01 kernel:  ffffffffa2c357b6 0000000000001000 =
ffffffff52e45c60 ffff880652e45c40
avril 04 16:22:01 Colorstock-01 kernel:  ffff88085c1af730 ffff88085c1af730 =
0000000000000010 0000000000000000
avril 04 16:22:01 Colorstock-01 kernel:  ffffffffa2c0438d ffff88085c8c6c48 =
ffff88085c1af770 ffff88085c1af7b0
avril 04 16:22:01 Colorstock-01 kernel: Call Trace:
avril 04 16:22:01 Colorstock-01 kernel:  [<ffffffffa2c357b6>] ? xfs_filestr=
eam_lookup_ag+0x76/0x1b0 [xfs]
avril 04 16:22:01 Colorstock-01 kernel:  [<ffffffffa2c0438d>] ? xfs_bmap_bt=
alloc+0x2dd/0x770 [xfs]
avril 04 16:22:01 Colorstock-01 kernel:  [<ffffffffa2bfc192>] ? xfs_bmap_se=
arch_multi_extents+0xa2/0x120 [xfs]
avril 04 16:22:01 Colorstock-01 kernel:  [<ffffffffa2c03a06>] ? xfs_bmap_la=
st_extent+0x56/0x80 [xfs]
avril 04 16:22:01 Colorstock-01 kernel:  [<ffffffffa2c03a56>] ? xfs_bmap_is=
aeof+0x26/0x90 [xfs]
avril 04 16:22:01 Colorstock-01 kernel:  [<ffffffffa2c05211>] ? xfs_bmapi_w=
rite+0x4b1/0xaa0 [xfs]
avril 04 16:22:01 Colorstock-01 kernel:  [<ffffffffa2c3ca61>] ? xfs_iomap_w=
rite_allocate+0x131/0x350 [xfs]
avril 04 16:22:01 Colorstock-01 kernel:  [<ffffffffa2c283d7>] ? xfs_map_blo=
cks+0x1b7/0x240 [xfs]
avril 04 16:22:01 Colorstock-01 kernel:  [<ffffffffa2c291f6>] ? xfs_vm_writ=
epage+0x186/0x5a0 [xfs]
avril 04 16:22:01 Colorstock-01 kernel:  [<ffffffff81106ead>] ? __writepage=
+0xd/0x40
avril 04 16:22:01 Colorstock-01 kernel:  [<ffffffff811077af>] ? write_cache=
_pages+0x1bf/0x430
avril 04 16:22:01 Colorstock-01 kernel:  [<ffffffff81106ea0>] ? global_dirt=
yable_memory+0x50/0x50
avril 04 16:22:01 Colorstock-01 kernel:  [<ffffffff81107a58>] ? generic_wri=
tepages+0x38/0x50
avril 04 16:22:01 Colorstock-01 kernel:  [<ffffffff8116db61>] ? __writeback=
_single_inode+0x41/0x2b0
avril 04 16:22:01 Colorstock-01 kernel:  [<ffffffff811700b8>] ? writeback_s=
b_inodes+0x1b8/0x470
avril 04 16:22:01 Colorstock-01 kernel:  [<ffffffff811703fe>] ? __writeback=
_inodes_wb+0x8e/0xc0
avril 04 16:22:01 Colorstock-01 kernel:  [<ffffffff81170683>] ? wb_writebac=
k+0x253/0x350
avril 04 16:22:01 Colorstock-01 kernel:  [<ffffffff81170b8a>] ? bdi_writeba=
ck_workfn+0x2ca/0x480
avril 04 16:22:01 Colorstock-01 kernel:  [<ffffffff81071b95>] ? process_one=
_work+0x155/0x440
avril 04 16:22:01 Colorstock-01 kernel:  [<ffffffff81072543>] ? worker_thre=
ad+0x63/0x490
avril 04 16:22:01 Colorstock-01 kernel:  [<ffffffff810724e0>] ? rescuer_thr=
ead+0x290/0x290
avril 04 16:22:01 Colorstock-01 kernel:  [<ffffffff810769ee>] ? kthread+0xc=
e/0xf0
avril 04 16:22:01 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 16:22:01 Colorstock-01 kernel:  [<ffffffff81450fd8>] ? ret_from_fo=
rk+0x58/0x90
avril 04 16:22:01 Colorstock-01 kernel:  [<ffffffff81076920>] ? kthread_cre=
ate_on_node+0x180/0x180
avril 04 16:22:01 Colorstock-01 kernel: Code: 08 48 8d b8 00 04 00 00 e8 e9=
 eb fb ff 84 c0 74 09 65 48 ff 04 25 18 f5 00 00 48 83 c4 08 c3 0f 1f 80 00=
 00 00 00 48 85 ff 74 3e <f6> 87 98 00 00 00 40 0f 85 fe 00 00 00 41 55 41 =
54 55 48 8d af
avril 04 16:22:01 Colorstock-01 kernel: RIP  [<ffffffff811614d5>] iput+0x5/=
0x190
avril 04 16:22:01 Colorstock-01 kernel:  RSP <ffff88085c1af590>
avril 04 16:22:01 Colorstock-01 kernel: CR2: 0000000000000240
avril 04 16:22:01 Colorstock-01 kernel: ---[ end trace a6342d7a0e4dea0f ]---
avril 04 16:22:01 Colorstock-01 kernel: ------------[ cut here ]------------


--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/aTC0=UDuFf4Icb.zx=9xC4z
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAljj1rsACgkQX3jQXNUicVaLFACgthT/VOaT7z5zQr5HYcQ1rLJ+
OqkAn2aVZH0R6Zuv9V0aTWHPz6qm6iY5
=+mDW
-----END PGP SIGNATURE-----

--Sig_/aTC0=UDuFf4Icb.zx=9xC4z--
