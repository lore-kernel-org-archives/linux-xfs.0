Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:50166 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750857AbdGYJvw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jul 2017 05:51:52 -0400
Subject: Re: xfsprogs commit 4944defad4ae2cbcf056207490d7c597bb92cd7c
References: <c16e39da-27dd-d35c-e9e1-463d36472a8b@gentoo.org>
 <8A0CFE17-BAB8-4CC9-8A01-BFD99F6C83FE@jabberwocky.com>
 <20170725055659.GC4369@magnolia>
From: "Jory A. Pratt" <anarchy@gentoo.org>
Message-ID: <a65b4362-8355-d50d-745a-1ad4d027121e@gentoo.org>
Date: Tue, 25 Jul 2017 04:51:40 -0500
MIME-Version: 1.0
In-Reply-To: <20170725055659.GC4369@magnolia>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="jkerQ9kFbmsaINjIpCRtg5cs5bc35jw9Q"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, David Shaw <dshaw@jabberwocky.com>
Cc: cmaiolino@redhat.com, xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jkerQ9kFbmsaINjIpCRtg5cs5bc35jw9Q
Content-Type: multipart/mixed; boundary="JcikB9bj9VuSDGw4UtN0e7gcrMUAtUiG7";
 protected-headers="v1"
From: "Jory A. Pratt" <anarchy@gentoo.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
 David Shaw <dshaw@jabberwocky.com>
Cc: cmaiolino@redhat.com, xfs <linux-xfs@vger.kernel.org>
Message-ID: <a65b4362-8355-d50d-745a-1ad4d027121e@gentoo.org>
Subject: Re: xfsprogs commit 4944defad4ae2cbcf056207490d7c597bb92cd7c
References: <c16e39da-27dd-d35c-e9e1-463d36472a8b@gentoo.org>
 <8A0CFE17-BAB8-4CC9-8A01-BFD99F6C83FE@jabberwocky.com>
 <20170725055659.GC4369@magnolia>
In-Reply-To: <20170725055659.GC4369@magnolia>

--JcikB9bj9VuSDGw4UtN0e7gcrMUAtUiG7
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

On 07/25/17 00:56, Darrick J. Wong wrote:
> [cc xfs list]
>=20
> On Sun, Jul 23, 2017 at 10:21:56AM -0400, David Shaw wrote:
>> On Jul 22, 2017, at 10:13 PM, Jory A. Pratt <anarchy@gentoo.org> wrote=
:
>>>
>>> Is there any specific reason you all have drop'd away from the posix
>>> standard? This change introduces build failure as it no longer follow=
s
>>> the posix standard for stdout.
>>>
>>> metadump.c:2875:10: error: assignment of read-only variable 'stdout'
>>>   stdout =3D stderr;
>>>          ^
>>> metadump.c:2911:10: error: assignment of read-only variable 'stdout'
>>>   stdout =3D outf;
>=20
> Huh?  What system configuration (libc, etc.) is this?
>=20
> The Open Group Base Specifications Issue 7
> http://pubs.opengroup.org/onlinepubs/9699919799/functions/stdin.html
> only mentions this:
>=20
>     extern FILE *stderr, *stdin, *stdout;
>=20
> and says that it defers to the ISO C standard.
>=20
> The ISO C11 standard (draft 1570, anyway)
> https://port70.net/~nsz/c/c11/n1570.txt
> has this to say:
>=20
>             stderr
>             stdin
>             stdout
>     which are expressions of type ''pointer to FILE'' that point to the=

>     FILE objects associated, respectively, with the standard error,
>     input, and output streams.
>=20
> I don't see anything in there about stdout being read only, though I
> suppose there's nothing in that explicitly requiring they be assignable=
=2E
>=20
> <grumble> musl, isn't it...?

Yes that is correct musl.
>=20
> --D
>=20
>>
>> Hi,
>>
>> I think you may have meant this to go to Darrick Wong
>> (darrick.wong@oracle.com), cc'd.  I reported the bug (well,
>> indirectly), but Darrick was the person who fixed it.
>>
>> David
>>
>=20


--=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Jory A. Pratt
Gentoo Linux Developer [Mozilla Lead]
E-Mail    : anarchy@gentoo.org
GnuPG FP  : D4AC 8D63 0B16 F7C9 08E9  B909 A0CC C3BA B4D0 88B4
GnuPG ID  : B4D088B4
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D


--JcikB9bj9VuSDGw4UtN0e7gcrMUAtUiG7--

--jkerQ9kFbmsaINjIpCRtg5cs5bc35jw9Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEE1KyNYwsW98kI6bkJoMzDurTQiLQFAll3FLMACgkQoMzDurTQ
iLTZWQf5AauDOfJTvu2Grx05zx5PSci9Za/PMfLo7FxHF7BQGkj0VSTGH0bn3QYU
gxF6DvPVbZLzDVU/4rptRk0AlZDIlBz+RFCWmbWJdvglhfwaNjQB6246agC5fzne
3Zw4wc0c7Cf6i1/reeRKu97szwSTFhMW5bK7hKtl05wLZk3Bqbp3xD0KtfJuaScI
nlV1i4Oh87Z7O5P6uLso8Dy+zNDUTL8Gv6RIBPHPUpo+zU+vfR7No+QeK8deQ1q1
CPTS2sgmLDXdwMGphwEbq24bAZxPNUVX0mJp6mto5xzvTGq+e3hXTAC4PPYoIH+d
7pb5WTHThPp6Dp1SKmxrlEwfVpguiA==
=MN6I
-----END PGP SIGNATURE-----

--jkerQ9kFbmsaINjIpCRtg5cs5bc35jw9Q--
