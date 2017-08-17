Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40612 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751167AbdHQFsh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Aug 2017 01:48:37 -0400
Subject: Re: xfs_repair fails: mismatched UUID?
References: <1502946903.3034.25.camel@sub-pop.net>
 <d31ec46a-cc4c-5865-6ee4-fffdcb32c254@sandeen.net>
 <e285d801-755b-b84e-028a-b889f4ee336c@sandeen.net>
 <1502948579.29878.8.camel@sub-pop.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d83f6b0d-6881-edc1-4353-eb357ed55730@sandeen.net>
Date: Thu, 17 Aug 2017 00:48:30 -0500
MIME-Version: 1.0
In-Reply-To: <1502948579.29878.8.camel@sub-pop.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2OWAePDjQhGKKNQPArAGDrK5P7F8t7o1L"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Link Dupont <link@sub-pop.net>, linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2OWAePDjQhGKKNQPArAGDrK5P7F8t7o1L
Content-Type: multipart/mixed; boundary="oq51pfxtSO7NUSCwRDrUncxgjdes7OiLh";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: Link Dupont <link@sub-pop.net>, linux-xfs@vger.kernel.org
Message-ID: <d83f6b0d-6881-edc1-4353-eb357ed55730@sandeen.net>
Subject: Re: xfs_repair fails: mismatched UUID?
References: <1502946903.3034.25.camel@sub-pop.net>
 <d31ec46a-cc4c-5865-6ee4-fffdcb32c254@sandeen.net>
 <e285d801-755b-b84e-028a-b889f4ee336c@sandeen.net>
 <1502948579.29878.8.camel@sub-pop.net>
In-Reply-To: <1502948579.29878.8.camel@sub-pop.net>

--oq51pfxtSO7NUSCwRDrUncxgjdes7OiLh
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 8/17/17 12:42 AM, Link Dupont wrote:
> On Thu, 2017-08-17 at 00:26 -0500, Eric Sandeen wrote:
>> Oh right, you did say RAID enclosure.
>>
>> My money is on the enclosure no longer presenting you with sectors in
>> the original order, or in an otherwise severely damaged form, for
>> whatever reason.
>=20
> The problem *could* be from the enclosure itself; I don't have a second=
 one to
> test. I'm fairly sure the cause is a failing drive (I get a red LED fro=
m one of
> the two status LEDs on the front of the enclosure).
>=20
>> xfs_repair restores filesystem consistency but it is not a data recove=
ry or
>> storage repair tool.  ;)
>=20
> I get that. But since the files are there, it seemed like the file-syst=
em could
> be repaired. I'll dig up the output.

My worry is that the "log uuid" was neither zeros nor the proper UUID; it=
 was
something else.  So it wasn't bad, unreadable sectors which got filled in=
 with
zeros by ddrescue, it was apparently some random data coughed up by the
enclosure for some unknown reason.

If it did that to the log, it may well have done that to many other parts=

of the filesystem as well.

-Eric


--oq51pfxtSO7NUSCwRDrUncxgjdes7OiLh--

--2OWAePDjQhGKKNQPArAGDrK5P7F8t7o1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJZlS40AAoJECCuFpLhPd7gGQMP/jq9zldQN/NmJFFMss814HmS
6cNrTcNkjxkBwpguaastZ53TnCXjdU1NvBe8Qut7AeKaEcHxi19XPpUkY8s69jJz
YQn4x5HHxlhJ7seavrmhnb3+HhApi1roSXrI7kNj+/AwA0cPCrL6/lzHS3X9lRnT
zIA3G+mBdhQPnnGj9wkMw30t3fp6heHhtE3cbe2MPIae2sCfOEjPHiF/stfp8sWm
ZoiutjLeX+utR8sKZXjzMAtC9ePmLKh9nUvQC2d0Z8EVmzIGLHQI/RMVX8qhsV10
M9trotGFTZvQTvKhbGeNPX3Luc+f1EGPcbIc7q7l4yNblg436bmW9XNjjShTK0wi
f0M0C6pRNLo06zpR3Lpb9uN5Vf5TTMggbyTsIb4zwA4EOOrxbvdMdgfOuez/xSVL
bbbEXjrNcmFg1v2R6V9FjifAqKP/RTxjaQCssgqNHvmYOQ2xcFNBDmx7xs2O0jAn
qiNiQEiLwZgek7NPvWDvo+kebpv5SRZKujRmjKX9STsYoZQHA7pfXGK479mEPFe1
LZOnioy4zJboCBAwC9uxy0TGq/8M9CRD4Nu+MJp8nm0qC9ZDsrBRGO6QJ1aPcw3O
vknAzFDmV1vSo5NCE+tHxvo5M15zpFHdCLf0/1hHWzVzgUNMNqi+2sVuv+QyZUSA
zlHVlzq16UdRcF7bruMB
=Ul+F
-----END PGP SIGNATURE-----

--2OWAePDjQhGKKNQPArAGDrK5P7F8t7o1L--
