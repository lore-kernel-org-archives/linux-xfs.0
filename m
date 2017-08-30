Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.gocept.net ([195.62.125.19]:59369 "EHLO mail.gocept.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751686AbdH3N4K (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Aug 2017 09:56:10 -0400
From: Christian Theune <ct@flyingcircus.io>
Message-Id: <289A60E8-9FE0-43B0-8882-F7C96D03DDCF@flyingcircus.io>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_A6E5C88F-D9C5-4C4B-8D51-67908EC339A2";
 protocol="application/pgp-signature"; micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: null pointer reference after crash
Date: Wed, 30 Aug 2017 15:56:05 +0200
In-Reply-To: <BE1D250C-EDA0-4E9B-A085-1DD62497BEA8@flyingcircus.io>
References: <ED0CA266-63AF-4A99-A8B9-DC4C452EC217@flyingcircus.io>
 <20170828174238.GE4757@magnolia>
 <BE1D250C-EDA0-4E9B-A085-1DD62497BEA8@flyingcircus.io>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org


--Apple-Mail=_A6E5C88F-D9C5-4C4B-8D51-67908EC339A2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi,

just got it again on a different call path, maybe that helps:

[ 1070.136303] Oops: 0000 [#1] SMP
[ 1070.142577] Modules linked in: nf_log_ipv4 nf_conntrack_ipv4 =
nf_defrag_ipv4 nf_log_ipv6 nf_log_common xt_LOG xt_limit =
nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack sch_fq =
x86_pkg_temp_thermal kvm_intel kvm irqbypass nvme crc32c_intel ixgbe =
nvme_core mdio acpi_cpufreq nbd nf_conntrack_ftp nf_conntrack dm_zero =
dm_thin_pool dm_persistent_data dm_bio_prison dm_round_robin =
dm_multipath xts aesni_intel glue_helper lrw ablk_helper cryptd =
aes_x86_64 fuse dm_snapshot dm_bufio dm_crypt dm_mirror dm_region_hash =
dm_log
[ 1070.233784] CPU: 19 PID: 7460 Comm: ceph-osd Not tainted 4.9.43 #1
[ 1070.246124] Hardware name: Thomas-Krenn.AG X9DR3-F/X9DR3-F, BIOS 3.0a =
07/31/2013
[ 1070.260895] task: ffff8810517d0000 task.stack: ffffc9002abec000
[ 1070.272710] RIP: 0010:[<ffffffff81312320>]  [<ffffffff81312320>] =
xfs_da3_node_read+0x30/0xb0
[ 1070.289592] RSP: 0018:ffffc9002abefd28  EFLAGS: 00010286
[ 1070.300199] RAX: 0000000000000000 RBX: ffff88104d859a48 RCX: =
0000000000000001
[ 1070.314447] RDX: 0000000000000000 RSI: 0000000000000000 RDI: =
ffffc9002abefce0
[ 1070.328694] RBP: ffffc9002abefd48 R08: 0000000066656566 R09: =
ffffc9002abefbc0
[ 1070.342942] R10: fffffffffffffffe R11: 0000000000000001 R12: =
ffffc9002abefd78
[ 1070.357191] R13: ffff88066b430780 R14: 0000000000000005 R15: =
0000000066656566
[ 1070.371436] FS:  00007fe511bfc700(0000) GS:ffff88107fbc0000(0000) =
knlGS:0000000000000000
[ 1070.387590] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1070.399066] CR2: 00000000000000a0 CR3: 0000000f14d50000 CR4: =
00000000001406e0
[ 1070.413311] Stack:
[ 1070.417332]  ffffffff81a44fe0 ffffc9002abefd48 ffffc9002abefdd0 =
0000000000000005
[ 1070.432239]  ffffc9002abefdb8 ffffffff81337404 0000000200000008 =
ffff8809b5cab040
[ 1070.447144]  000000005e94ce38 ffff880c25e1c600 0000000000000000 =
0000000000000000
[ 1070.462051] Call Trace:
[ 1070.466949]  [<ffffffff81337404>] xfs_attr3_node_inactive+0x174/0x210
[ 1070.479802]  [<ffffffff813376da>] xfs_attr_inactive+0x23a/0x250
[ 1070.491625]  [<ffffffff81350a4b>] xfs_inactive+0x7b/0x110
[ 1070.502403]  [<ffffffff81359344>] xfs_fs_destroy_inode+0xa4/0x210
[ 1070.514573]  [<ffffffff811c46cb>] destroy_inode+0x3b/0x60
[ 1070.525352]  [<ffffffff811c4819>] evict+0x129/0x190
[ 1070.535093]  [<ffffffff811c4c4a>] iput+0x19a/0x200
[ 1070.544660]  [<ffffffff811b9129>] do_unlinkat+0x129/0x2d0
[ 1070.555445]  [<ffffffff811b9d26>] SyS_unlink+0x16/0x20
[ 1070.565706]  [<ffffffff81885260>] entry_SYSCALL_64_fastpath+0x13/0x94
[ 1070.578562] Code: 55 48 89 e5 41 54 53 4d 89 c4 48 89 fb 48 83 ec 10 =
48 c7 04 24 e0 4f a4 81 e8 fd fe ff ff 85 c0 75 46 48 85 db 74 41 49 8b =
34 24 <48> 8b 96 a0 00 00 00 0f b7 52 08 66 c1 c2 08 66 81 fa be 3e 74
[ 1070.618459] RIP  [<ffffffff81312320>] xfs_da3_node_read+0x30/0xb0
[ 1070.630663]  RSP <ffffc9002abefd28>
[ 1070.637630] CR2: 00000000000000a0
[ 1070.644858] ---[ end trace bc2d3667eef00f69 ]=E2=80=94

As of now the system doesn=E2=80=99t have the same following issues and =
the other FS=E2=80=99s are still functioning. I=E2=80=99ll run =
xfs_repair later today on all filesystems for good measure.

Christian

> On Aug 28, 2017, at 9:00 PM, Christian Theune <ct@flyingcircus.io> =
wrote:
>=20
> Hi,
>=20
>> On Aug 28, 2017, at 7:42 PM, Darrick J. Wong =
<darrick.wong@oracle.com> wrote:
>>=20
>> On Mon, Aug 28, 2017 at 07:23:19PM +0200, Christian Theune wrote:
>>> Hi,
>>>=20
>>> we stumbled over this today as a host rebooted with an unrelated =
(iommu)
>>> kernel crash and got completely stuck after this:
>>>=20
>>> I=E2=80=99m currently running xfs_repair on all disks and will then =
see whether this
>>> will resolve, still I guess you want to know about it. Kernel is =
4.9.43
>>> vanilla. Let me know if you need more data.
>>=20
>> Does commit cd87d8679201 ("xfs: don't crash on unexpected holes in =
dir/attr
>> btrees") fix this problem?  It'll be in 4.13, maybe someone can =
backport it
>> to 4.9?
>=20
> Thanks for the suggestion. I=E2=80=99ll keep that in mind in case I =
see this again.
>=20
>> (Assuming you can get it to reproduce reliably?)
>=20
> I have only seen it once today and hopefully won=E2=80=99t see it =
again. We have had some storage servers that run multiple SSD and HDD =
disks (for Ceph) crash multiple times a week lastly due to the IOMMU =
issues that resulted in hardware watchdog reboots, so I guess those xfs' =
did have quite some noise in it.
>=20
> Not sure I can do anything to reproduce it at all. *fingers crossed*
>=20
> Christian
>=20
> --
> Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
> Flying Circus Internet Operations GmbH =C2=B7 http://flyingcircus.io
> Forsterstra=C3=9Fe 29 =C2=B7 06112 Halle (Saale) =C2=B7 Deutschland
> HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian =
Theune, Christian Zagrodnick

Liebe Gr=C3=BC=C3=9Fe,
Christian Theune

--
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 http://flyingcircus.io
Forsterstra=C3=9Fe 29 =C2=B7 06112 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick


--Apple-Mail=_A6E5C88F-D9C5-4C4B-8D51-67908EC339A2
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQEcBAEBCgAGBQJZpsP1AAoJEKuh8lKpfGLOrvAH/2+h7NX5xwEYjBV7SPlR7htC
jMx/LF7ApEqixUvLlH5MXEb3EwULzhn7n4KulxVSbqJypzAtDvWDL/Y5nOlz3EWW
0DgBvDbghKX8HhIOR7asOOU537uoO9PZypFK5Mj+A3kE4QuR05HTiV9VyLFg4H4F
JcyaXKZHDGpGbtphAYn1yVWjNqa8bosPj6ArbAeC5kgu36vO3QstTq8gsyoomrey
DWGT+8H15Wl5hvo/W7X9uH6Gfwubq89aYypDa5bHRupaof5IAPtnJ+a9q2T6WgP3
/RbtZuqPUlK7HcsDXaVv6zqQORcN3wtGt2ymIP6o73AgsBPrDeintyz7xlL2hy4=
=q8Vg
-----END PGP SIGNATURE-----

--Apple-Mail=_A6E5C88F-D9C5-4C4B-8D51-67908EC339A2--
