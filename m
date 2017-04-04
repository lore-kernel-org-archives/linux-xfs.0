Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35440 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755092AbdDDRpJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Apr 2017 13:45:09 -0400
Subject: Re: "interesting" crash : 3.18.44, huge xfs, nfs
References: <20170404150202.6c7d032c@harpe.intellique.com>
 <20170404192411.650fb403@harpe.intellique.com>
 <95e14081-0f1c-7458-cca2-1f33d6662037@sandeen.net>
 <20170404194340.4733ccb7@harpe.intellique.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <889a3521-9f9d-59fd-8592-06ba40869e8f@sandeen.net>
Date: Tue, 4 Apr 2017 12:45:07 -0500
MIME-Version: 1.0
In-Reply-To: <20170404194340.4733ccb7@harpe.intellique.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0Or2crmH1tdBJMCFqmEJVh1C6E9HKstXi"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0Or2crmH1tdBJMCFqmEJVh1C6E9HKstXi
Content-Type: multipart/mixed; boundary="ExdwhrRXsfSk8XQND4jSUBrKofDq3g8t7";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-xfs@vger.kernel.org
Message-ID: <889a3521-9f9d-59fd-8592-06ba40869e8f@sandeen.net>
Subject: Re: "interesting" crash : 3.18.44, huge xfs, nfs
References: <20170404150202.6c7d032c@harpe.intellique.com>
 <20170404192411.650fb403@harpe.intellique.com>
 <95e14081-0f1c-7458-cca2-1f33d6662037@sandeen.net>
 <20170404194340.4733ccb7@harpe.intellique.com>
In-Reply-To: <20170404194340.4733ccb7@harpe.intellique.com>

--ExdwhrRXsfSk8XQND4jSUBrKofDq3g8t7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 4/4/17 12:43 PM, Emmanuel Florac wrote:
> Le Tue, 4 Apr 2017 12:36:57 -0500
> Eric Sandeen <sandeen@sandeen.net> =C3=A9crivait:
>=20
>>>> Context: this is a file server. There was a power failure
>>>> yesterday, so there's probably some corruption hidden somewhere
>>>> triggering the crash. =20
>>
>> and using filestreams, apparently?
>=20
> I don't see why or where we'd use filestreams there... What's the use
> case actually?

well, it's in your crash backtrace, so you tell me ;)

>>>
>>> The machine goes on crashing on disk access... xfs_repair 4.9 is
>>> running now, and after that we'll reboot with a current kernel
>>> (4.4.59). Any advice? =20
>>
>> Yep, go back in time & get an xfs_metadump before you repair it.  :(
>=20
> You know how it goes it crashes, users scream, administrator jumps on
> xfs_repair, and the rest is history.
> =20
>> Please do at least capture repair output.
>>
>=20
> Well the only thing I know is "there was nothing special in xfs_repair
> output"... I'll tell the admin to catch the output next time if
> necessary...

So it crashed on every access, and repair fixed it, but repair said
"nothing special" in the process?  :(

-Eric


--ExdwhrRXsfSk8XQND4jSUBrKofDq3g8t7--

--0Or2crmH1tdBJMCFqmEJVh1C6E9HKstXi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJY49ujAAoJECCuFpLhPd7gmhwP/1mjZWbT1LcS1UtzEIbUXJvB
OIjXPiRc4+klY7Bei6mGqRhgGFQnXS/W+B/XnyaXbAZtP0zOHydl5soNVTm8KYn3
FjM61Ivr6jr98ouKVpPsyxHhAmwMCd9lvkJu6zQc/QxbND8zNJZ9LUaGdpmGpHDg
HuCoLCs9x1YHBk+wTjup6sGNJQ/mquCNSeGu0sQzgyY24PXSsVT0kvx3bXJld/Dw
HpvZsy8FE8NGPuiWsv5ENVuogfKIzdv38no08MyIyrpt1UNI0eEN7TF8RIjMdNOL
ZKVZ0sS164Y9ZcpPoUNJeLH4exEHxFi6iaOfA73f2XzZpZ9sRU16OwtsYJ3LY6Nl
FmXbyKchhrSVznEOv1si/YF5QHPazxlxCYLx2uiJnVyXuNa/OrJWT8dskrYqUuAa
ZsobAEy5u4wohx4GaYWMW/xR8eDcmj97PM27dCWpAe601LIyZBx8NTxo6JE0VPyC
6Cxt+bAMqJBupwpnFkFWf4i+T1pCpTbCmLAA9kIt7lfd2kHMA8dk6dXUgMfgciVf
mamiBU0Jv3WH67wiQnqMrpwFcb9YQrlJomM9hK+Ht0U8GF7Zr9mDXk88SzFVdqlX
6IUM8ySWzt9L7Tz9kvy9TBdCBxMHeswx1ZjzM4gf6OG88QSlpO0JGE5mrjw+MwwW
B0+lhblTmD2qlGtBvjDC
=ab4g
-----END PGP SIGNATURE-----

--0Or2crmH1tdBJMCFqmEJVh1C6E9HKstXi--
