Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.gocept.net ([195.62.125.19]:33857 "EHLO mail.gocept.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752503AbdIAVjE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Sep 2017 17:39:04 -0400
From: Christian Theune <ct@flyingcircus.io>
Message-Id: <3398A79C-23F0-404E-B73F-BF19D7CA3788@flyingcircus.io>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_5FE2E860-17A5-489C-A734-3609E7AADC90";
 protocol="application/pgp-signature"; micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: null pointer reference after crash
Date: Fri, 1 Sep 2017 23:38:59 +0200
In-Reply-To: <01963DED-9DF3-4CFE-ACF1-0F8E72D9E948@flyingcircus.io>
References: <ED0CA266-63AF-4A99-A8B9-DC4C452EC217@flyingcircus.io>
 <20170828174238.GE4757@magnolia>
 <BE1D250C-EDA0-4E9B-A085-1DD62497BEA8@flyingcircus.io>
 <289A60E8-9FE0-43B0-8882-F7C96D03DDCF@flyingcircus.io>
 <20170830155800.GJ4757@magnolia>
 <F0B84B50-6DB4-4285-A2DE-DBECFE03C065@flyingcircus.io>
 <83C585A4-6612-4515-942F-B79078C0D085@flyingcircus.io>
 <01963DED-9DF3-4CFE-ACF1-0F8E72D9E948@flyingcircus.io>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org


--Apple-Mail=_5FE2E860-17A5-489C-A734-3609E7AADC90
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi,

(sorry for the staggered posting, sitting in an off-hours maintenance =
cycle and got time to think and things are trickling in).

The hopefully last piece that I can add for today is that I=E2=80=99ve =
ever only seen this happen is within maybe 10 minutes or less, after a =
reboot and (clean or unclean doesn=E2=80=99t matter) mount and then =
getting an immediate spike of traffic with Ceph recoverying things. =
Also, we started adding a =E2=80=98find=E2=80=99 and =E2=80=98vmtouch=E2=80=
=99 prewarm script before starting Ceph. So the boot order is

- mount
- vmtouch selected files
- cache inodes by running =E2=80=98find=E2=80=99 on the disk
- start Ceph osd

Once it survived for a while I haven=E2=80=99t seen it crash at all, =
only directly after boots. (So far)

Christian

> On Sep 1, 2017, at 11:03 PM, Christian Theune <ct@flyingcircus.io> =
wrote:
>=20
> Hi,
>=20
> something that might be of value: I haven=E2=80=99t seen those on =
4.9.25 (where we started to see very regular host crashes/reboots due to =
iommu issues) at all - they only started to creep up on the 4.9.43 that =
we=E2=80=99ve been running for about 2 weeks now.
>=20
> Christian
>=20
>> On Sep 1, 2017, at 10:53 PM, Christian Theune <ct@flyingcircus.io> =
wrote:
>>=20
>> Hi,
>>=20
>> got it again today: this time with a filesystem that just seconds =
before saw a (clean) xfs_repair. Also, another Ceph user stumbled over =
this today:
>> https://www.spinics.net/lists/ceph-users/msg36628.html
>>=20
>> Here=E2=80=99s my dump of today - it=E2=80=99s identical to the last =
one, so maybe this will be the last one I=E2=80=99m posting here until =
you ask me for more information. :)
>>=20
>> [ 2052.528430] BUG: unable to handle kernel NULL pointer dereference =
at 00000000000000a0
>> [ 2052.544143] IP: [<ffffffff81312320>] xfs_da3_node_read+0x30/0xb0
>> [ 2052.556170] PGD 0 [ 2052.559844]
>> [ 2052.562825] Oops: 0000 [#1] SMP
>> [ 2052.569099] Modules linked in: nf_log_ipv4 nf_conntrack_ipv4 =
nf_defrag_ipv4 nf_log_ipv6 nf_log_common xt_LOG xt_limit =
nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack sch_fq =
x86_pkg_temp_thermal kvm_intel kvm irqbypass ixgbe nvme crc32c_intel =
nvme_core mdio acpi_cpufreq nbd nf_conntrack_ftp nf_conntrack dm_zero =
dm_thin_pool dm_persistent_data dm_bio_prison dm_round_robin =
dm_multipath xts aesni_intel glue_helper lrw ablk_helper cryptd =
aes_x86_64 fuse dm_snapshot dm_bufio dm_crypt dm_mirror dm_region_hash =
dm_log
>> [ 2052.660301] CPU: 20 PID: 12288 Comm: ceph-osd Not tainted 4.9.43 =
#1
>> [ 2052.672811] Hardware name: Thomas-Krenn.AG X9DR3-F/X9DR3-F, BIOS =
3.0a 07/31/2013
>> [ 2052.687579] task: ffff880f0d85b900 task.stack: ffffc90009708000
>> [ 2052.699397] RIP: 0010:[<ffffffff81312320>]  [<ffffffff81312320>] =
xfs_da3_node_read+0x30/0xb0
>> [ 2052.716280] RSP: 0018:ffffc9000970bd28  EFLAGS: 00010286
>> [ 2052.726886] RAX: 0000000000000000 RBX: ffff8810504e7878 RCX: =
0000000000000001
>> [ 2052.741135] RDX: 0000000000000000 RSI: 0000000000000000 RDI: =
ffffc9000970bce0
>> [ 2052.755379] RBP: ffffc9000970bd48 R08: 00000000b6c20f50 R09: =
ffffc9000970bbc0
>> [ 2052.769627] R10: fffffffffffffffe R11: 0000000000000001 R12: =
ffffc9000970bd78
>> [ 2052.783875] R13: ffff880f8e65cec0 R14: 0000000000000003 R15: =
00000000b6c20f50
>> [ 2052.798120] FS:  00007fdd627fa700(0000) GS:ffff88107fc00000(0000) =
knlGS:0000000000000000
>> [ 2052.814276] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [ 2052.825745] CR2: 00000000000000a0 CR3: 0000000fcf9e8000 CR4: =
00000000001406e0
>> [ 2052.839992] Stack:
>> [ 2052.844015]  ffffffff81a44fe0 ffffc9000970bd48 ffffc9000970bdd0 =
0000000000000003
>> [ 2052.858918]  ffffc9000970bdb8 ffffffff81337404 0000000200000008 =
ffff880892da4040
>> [ 2052.873824]  000000005e94d370 ffff88105a603000 0000000000000000 =
0000000000000000
>> [ 2052.888730] Call Trace:
>> [ 2052.893630]  [<ffffffff81337404>] =
xfs_attr3_node_inactive+0x174/0x210
>> [ 2052.906496]  [<ffffffff813376da>] xfs_attr_inactive+0x23a/0x250
>> [ 2052.918317]  [<ffffffff81350a4b>] xfs_inactive+0x7b/0x110
>> [ 2052.929096]  [<ffffffff81359344>] xfs_fs_destroy_inode+0xa4/0x210
>> [ 2052.941267]  [<ffffffff811c46cb>] destroy_inode+0x3b/0x60
>> [ 2052.952041]  [<ffffffff811c4819>] evict+0x129/0x190
>> [ 2052.961783]  [<ffffffff811c4c4a>] iput+0x19a/0x200
>> [ 2052.971349]  [<ffffffff811b9129>] do_unlinkat+0x129/0x2d0
>> [ 2052.982134]  [<ffffffff811b9d26>] SyS_unlink+0x16/0x20
>> [ 2052.992394]  [<ffffffff81885260>] =
entry_SYSCALL_64_fastpath+0x13/0x94
>> [ 2053.005252] Code: 55 48 89 e5 41 54 53 4d 89 c4 48 89 fb 48 83 ec =
10 48 c7 04 24 e0 4f a4 81 e8 fd fe ff ff 85 c0 75 46 48 85 db 74 41 49 =
8b 34 24 <48> 8b 96 a0 00 00 00 0f b7 52 08 66 c1 c2 08 66 81 fa be 3e =
74
>> [ 2053.045148] RIP  [<ffffffff81312320>] xfs_da3_node_read+0x30/0xb0
>> [ 2053.057348]  RSP <ffffc9000970bd28>
>> [ 2053.064318] CR2: 00000000000000a0
>> [ 2053.071494] ---[ end trace 9360ec3fb784a9ab ]---
>>=20
>> Cheers,
>> Christian
>>=20
>> --
>> Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
>> Flying Circus Internet Operations GmbH =C2=B7 http://flyingcircus.io
>> Forsterstra=C3=9Fe 29 =C2=B7 06112 Halle (Saale) =C2=B7 Deutschland
>> HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian =
Theune, Christian Zagrodnick
>>=20
>=20
> Liebe Gr=C3=BC=C3=9Fe,
> Christian Theune
>=20
> --
> Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
> Flying Circus Internet Operations GmbH =C2=B7 http://flyingcircus.io
> Forsterstra=C3=9Fe 29 =C2=B7 06112 Halle (Saale) =C2=B7 Deutschland
> HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian =
Theune, Christian Zagrodnick
>=20

Liebe Gr=C3=BC=C3=9Fe,
Christian Theune

--
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 http://flyingcircus.io
Forsterstra=C3=9Fe 29 =C2=B7 06112 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick


--Apple-Mail=_5FE2E860-17A5-489C-A734-3609E7AADC90
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQEcBAEBCgAGBQJZqdN0AAoJEKuh8lKpfGLOMKsH/ikArMxLmyDXC/866U0ZrBSd
I8M7WV4CCfLt21/LVJfFQRuOBBjUofGUMWvwHz55agYt/ipQFHpElNZMN/tXM+Ll
Z/bjmCwc/UC7c1bk5K8D6HwMQalovHlBxf9JbV0F3u5BV/j471EljMxIP+SYag2m
10Ikp0NjIqcyMc4NCmK8XfQjU7R/iLTbRIlkQ6NmFJsWQruZta3nTNuxXeIoqV1T
/GbxGk56WWlQ5Sl4r2WbrETNegUS9U8/JBEKvNkXqlHLYFVZTxMir4PE2lT8wGh1
PryKeYpnl0eHlXZ1YN2fa+7bd7hxyAWy5Us9kEfPpBPlvnXC/gxNKbqqJZjV1PU=
=PYrc
-----END PGP SIGNATURE-----

--Apple-Mail=_5FE2E860-17A5-489C-A734-3609E7AADC90--
