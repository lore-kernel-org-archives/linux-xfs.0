Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.gocept.net ([195.62.125.19]:46701 "EHLO mail.gocept.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751203AbdH1TBC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Aug 2017 15:01:02 -0400
From: Christian Theune <ct@flyingcircus.io>
Message-Id: <BE1D250C-EDA0-4E9B-A085-1DD62497BEA8@flyingcircus.io>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_FFF083B7-A30C-405A-BBFB-E8A00E66514A";
 protocol="application/pgp-signature"; micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: null pointer reference after crash
Date: Mon, 28 Aug 2017 21:00:59 +0200
In-Reply-To: <20170828174238.GE4757@magnolia>
References: <ED0CA266-63AF-4A99-A8B9-DC4C452EC217@flyingcircus.io>
 <20170828174238.GE4757@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org


--Apple-Mail=_FFF083B7-A30C-405A-BBFB-E8A00E66514A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi,

> On Aug 28, 2017, at 7:42 PM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>=20
> On Mon, Aug 28, 2017 at 07:23:19PM +0200, Christian Theune wrote:
>> Hi,
>>=20
>> we stumbled over this today as a host rebooted with an unrelated =
(iommu)
>> kernel crash and got completely stuck after this:
>>=20
>> I=E2=80=99m currently running xfs_repair on all disks and will then =
see whether this
>> will resolve, still I guess you want to know about it. Kernel is =
4.9.43
>> vanilla. Let me know if you need more data.
>=20
> Does commit cd87d8679201 ("xfs: don't crash on unexpected holes in =
dir/attr
> btrees") fix this problem?  It'll be in 4.13, maybe someone can =
backport it
> to 4.9?

Thanks for the suggestion. I=E2=80=99ll keep that in mind in case I see =
this again.

> (Assuming you can get it to reproduce reliably?)

I have only seen it once today and hopefully won=E2=80=99t see it again. =
We have had some storage servers that run multiple SSD and HDD disks =
(for Ceph) crash multiple times a week lastly due to the IOMMU issues =
that resulted in hardware watchdog reboots, so I guess those xfs' did =
have quite some noise in it.

Not sure I can do anything to reproduce it at all. *fingers crossed*

Christian

--
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 http://flyingcircus.io
Forsterstra=C3=9Fe 29 =C2=B7 06112 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick


--Apple-Mail=_FFF083B7-A30C-405A-BBFB-E8A00E66514A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQEcBAEBCgAGBQJZpGhrAAoJEKuh8lKpfGLOKRgIANSmHelT7WjAQ1N90+l1lJFp
MLCW7MSyGX9VbySC45hyom8Uze8JHwgGZYT+yyNt+0pgXmZFxTvmtmgSaafe2v9A
a8TdDywD7uRhvnssWXKIbXO22C6cgqKXHrgGahmSjaWyXsHPb4tnXKpdHQzwTaB4
HdSo8rFdKUx6r+JdGgQj1y3dQE7ncsNF+uMgIusmiB9eN83yCsHz8rILKBZADjwv
2WUgHmwcmXlfs39+EmRyUmvlAxd7FsG9qamXiB1/0w4hAHz3pKV2VjsnWiRURRqu
kC/4nFFtgEd0vWnyiSePP878WK0vfUW3qotEUJ0YXxWpocThKDisWRetdsHCK2w=
=wlxB
-----END PGP SIGNATURE-----

--Apple-Mail=_FFF083B7-A30C-405A-BBFB-E8A00E66514A--
