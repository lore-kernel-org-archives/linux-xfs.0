Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7420Tum133970 for <xfs@oss.sgi.com>; Mon, 3 Aug 2009 21:00:30 -0500
Received: from mx.ugf.br (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F1B1714A30DC
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2009 19:10:33 -0700 (PDT)
Received: from mx.ugf.br (mx.ugf.br [200.222.48.3]) by cuda.sgi.com with ESMTP
	id W3OpWBCGUCFL2r0c for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2009 19:10:33 -0700 (PDT)
Subject: Re: [PATCH 1/1] XFS: __xfs_get_blocks check pointer to the target
	device
From: Ramon de Carvalho Valle <ramon@risesecurity.org>
In-Reply-To: <20090803214929.GB3167@infradead.org>
References: <1249329808.7686.26.camel@logos>
	<20090803214929.GB3167@infradead.org>
Date: Mon, 03 Aug 2009 23:00:41 -0300
Message-Id: <1249351241.7513.18.camel@logos>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7082455041429779098=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, hch@lst.de, linux-kernel@vger.kernel.org, mszeredi@novell.com


--===============7082455041429779098==
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-VkPxh+G4plrOwLjm2QnC"


--=-VkPxh+G4plrOwLjm2QnC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-08-03 at 17:49 -0400, Christoph Hellwig wrote:
> On Mon, Aug 03, 2009 at 05:03:28PM -0300, Ramon de Carvalho Valle wrote:
> > The __xfs_get_blocks function does not check if the pointer to the targ=
et
> > device is valid before dereferencing it.
>=20
> It should never be zero.  It's set by xfs_imap_to_bmap to either
> mp->m_ddev_targp which is always allocated, or to mp->m_rtdev_targp
> which is always allocated if we have a realtime device, and
> XFS_IS_REALTIME_INODE should only be true in that case.
>=20

While testing XFS code with a modified version of fsfuzzer on SLES 10
SP3 (Kernel 2.6.16.60-0.49.3.ramon-ppc64), I came across the following
Oops:

--
iomap.iomap_target =3D 0000000000000000
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=3D128 NUMA PSERIES LPAR=20
Modules linked in: xfs_quota xfs ipv6 nfs lockd nfs_acl sunrpc apparmor loo=
p dm_mod ehea ibmvscsic sg ipr libata firmware_class sd_mod scsi_mod
NIP: D000000000532270 LR: D000000000532268 CTR: 0000000000EEBBA0
REGS: c0000000ea2b7250 TRAP: 0300   Not tainted  (2.6.16.60-0.49.3.ramon-pp=
c64)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 22244882  XER: 00000007
DAR: 0000000000000008, DSISR: 0000000040000000
TASK =3D c00000000f2e4d90[4369] 'run_test' THREAD: c0000000ea2b4000 CPU: 1
GPR00: D000000000532268 C0000000EA2B74D0 D000000000593F20 0000000000000029=20
GPR04: 8000000000009032 0000000000000000 0000000000000000 00000000000D360A=20
GPR08: 80003FBFF900000C 0000000000000000 C0000000FEFEBBE8 C0000000004F6478=20
GPR12: 0000000000004000 C0000000004C3800 0000000000000005 D00000000057EC20=20
GPR16: C0000000F5122480 C0000000EA7F55B0 0000000000000400 C0000000EA7F55B0=20
GPR20: D00000000058A798 0000000000000000 C0000000EBF868C8 0000000000000000=20
GPR24: 0000000000000000 0000000000000001 0000000000000000 0000000000000000=20
GPR28: C0000000EA7F55B0 C0000000EA2B7548 D00000000058C578 C0000000EBF868C8=20
NIP [D000000000532270] .__xfs_get_blocks+0x170/0x2fc [xfs]
LR [D000000000532268] .__xfs_get_blocks+0x168/0x2fc [xfs]
Call Trace:
[C0000000EA2B74D0] [D000000000532268] .__xfs_get_blocks+0x168/0x2fc [xfs] (=
unreliable)
[C0000000EA2B75C0] [C0000000000D8EBC] .__block_prepare_write+0x198/0x520
[C0000000EA2B76C0] [C0000000000D9818] .block_prepare_write+0x34/0x64
[C0000000EA2B7740] [D000000000531798] .xfs_vm_prepare_write+0x2c/0x44 [xfs]
[C0000000EA2B77C0] [C0000000000A2804] .generic_file_buffered_write+0x300/0x=
7fc
[C0000000EA2B7960] [D00000000053CB6C] .xfs_write+0x67c/0xa64 [xfs]
[C0000000EA2B7AE0] [D0000000005379B0] .xfs_file_aio_write+0x8c/0xa0 [xfs]
[C0000000EA2B7B60] [C0000000000D4518] .do_sync_write+0xd0/0x12c
[C0000000EA2B7CE0] [C0000000000D53BC] .vfs_write+0x130/0x218
[C0000000EA2B7D80] [C0000000000D55B0] .SyS_write+0x58/0xa0
[C0000000EA2B7E30] [C00000000000871C] syscall_exit+0x0/0x40
Instruction dump:
40a2fff4 38000200 7d20f8a8 7d290378 7d20f9ad 40a2fff4 48000118 e87e8058=20
e8810080 4800e80d e8410028 e9210080 <e8090008> f81f0030 41920048 e81f0000=20
--

I added a printk() line just before the:

	bh_result->b_bdev =3D iomap.iomap_target->bt_bdev;

and as we can see iomap.iomap_target is NULL.

My guess is that the XFS_DIFLAG_REALTIME flag is being set incorrectly
on the xfs inode structure, setting iomapp->iomap_target to the wrong
device pointer (probably NULL).

I don't know if this is the best place to add a check, neither if
returning -XFS_ERROR(EIO) is correct at this point. Maybe doing:

	if (iomap.iomap_target && omap.iomap_flags & IOMAP_REALTIME)
		bh_result->b_bdev =3D iomap.iomap_target->bt_bdev;

would be a better solution.

-Ramon

--=-VkPxh+G4plrOwLjm2QnC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkp3lkYACgkQGIS0iEuhp4MDVACfecj8ASdbnE0C2RffChz2cVl+
6SIAoN3cxFsc9ml2SNFYxCoZ2lLJ5viU
=w21t
-----END PGP SIGNATURE-----

--=-VkPxh+G4plrOwLjm2QnC--


--===============7082455041429779098==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7082455041429779098==--
