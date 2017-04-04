Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38882 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752935AbdDDSRA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Apr 2017 14:17:00 -0400
Subject: Re: "interesting" crash : 3.18.44, huge xfs, nfs
References: <20170404150202.6c7d032c@harpe.intellique.com>
 <20170404192411.650fb403@harpe.intellique.com>
 <95e14081-0f1c-7458-cca2-1f33d6662037@sandeen.net>
 <20170404194340.4733ccb7@harpe.intellique.com>
 <889a3521-9f9d-59fd-8592-06ba40869e8f@sandeen.net>
 <20170404200711.088a3c58@harpe.intellique.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5ae8a2ae-c62a-d8fd-268c-4e5d90e331d6@sandeen.net>
Date: Tue, 4 Apr 2017 13:16:48 -0500
MIME-Version: 1.0
In-Reply-To: <20170404200711.088a3c58@harpe.intellique.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4qGdELmDGRJJrbLmJ7t1SBc5JnwP1CJSm"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4qGdELmDGRJJrbLmJ7t1SBc5JnwP1CJSm
Content-Type: multipart/mixed; boundary="kECBCg50B1nM9Lqe4PW99PCC6rk7U8TUr";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-xfs@vger.kernel.org
Message-ID: <5ae8a2ae-c62a-d8fd-268c-4e5d90e331d6@sandeen.net>
Subject: Re: "interesting" crash : 3.18.44, huge xfs, nfs
References: <20170404150202.6c7d032c@harpe.intellique.com>
 <20170404192411.650fb403@harpe.intellique.com>
 <95e14081-0f1c-7458-cca2-1f33d6662037@sandeen.net>
 <20170404194340.4733ccb7@harpe.intellique.com>
 <889a3521-9f9d-59fd-8592-06ba40869e8f@sandeen.net>
 <20170404200711.088a3c58@harpe.intellique.com>
In-Reply-To: <20170404200711.088a3c58@harpe.intellique.com>

--kECBCg50B1nM9Lqe4PW99PCC6rk7U8TUr
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 4/4/17 1:07 PM, Emmanuel Florac wrote:
> Le Tue, 4 Apr 2017 12:45:07 -0500
> Eric Sandeen <sandeen@sandeen.net> =C3=A9crivait:
>=20
>>>
>>> I don't see why or where we'd use filestreams there... What's the
>>> use case actually? =20
>>
>> well, it's in your crash backtrace, so you tell me ;)
>>
>=20
> I remember now... There writing files in long sequences, so that's what=

> the filestream option is for. It worked fine for a few months though...=


I'm not saying it's the root cause, or wrong, but it is an interesting
datapoint for the server config.  It's not a heavily used option.

-Eric


--kECBCg50B1nM9Lqe4PW99PCC6rk7U8TUr--

--4qGdELmDGRJJrbLmJ7t1SBc5JnwP1CJSm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJY4+MbAAoJECCuFpLhPd7gR6YP/RQxeThtx742SNcaiXGVIRqX
SLXDd8vYhnWIGCVPJMqlOdpFX48C4xMMJjtvOs333eXzHbIs67xpzOmuHYrbQd2V
CofCgO9UgVcUiGjCrO2p9nPJxhQhFrDMtO13DaGcSHba0IjNiXXU/+/A2fTOkA+i
eMGdOTnM8SQVv18CiDCMPDIKXUhhvdSx4Di0Y5QVbtBlJJWjSH52Dn8xfh1iETZp
oMLMF1tlCYtVVRvpu5lCWjYpZK/Ei+xahq0CCyHNID73cNUHzfck1WuaiNMzhP6O
S4LmcCncibmUr/R+Iwa3BvQk4CcYFNIMPb8jdS0Y8sqnCH+lgl60pi5GdRK1VYGK
cxeo24WkEKH7RQw/zTiR8jHGLd793Hy/00esLAz1oLdclfL3XgZt46Yb98zTHpvI
bXLCPefmqjxpVVTAYQqiq9tkGDKyDUPEppYzjrqSsW+1DRyoPXiX4ALpareT0Gv0
mvsdI/EA3Hc9fKNYco3W5bdsVKtRTPRKSA66/kpFWhM5FzCSLNoGyZtOFkpEx39J
rYY31pajSj5bgZwXA/r04kNnOwFlxYGqYhfVbEkRRrSp//YY4JpLPCLoI/+9XyN/
s2uIw4eP1Dsoytv4AF+/qNVxtqlD4W0+CialtsDwljbFAoW/nmAXOi1XutFJUtCE
NyuYnbAep/OR/hNuOyo6
=+iHf
-----END PGP SIGNATURE-----

--4qGdELmDGRJJrbLmJ7t1SBc5JnwP1CJSm--
