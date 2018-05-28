Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.gn.apc.org ([37.220.108.136]:56918 "EHLO mail.gn.apc.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932556AbeE1QAa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 May 2018 12:00:30 -0400
Subject: Re: Deleting a project from XFS quotas
References: <d30e573b-9c2a-cf97-7608-ad10a7b1b21c@gn.apc.org>
 <20180523002552.GY23861@dastard>
 <0862c878-38bb-8af3-be83-d5e6c7dac282@sandeen.net>
From: Ian Macdonald <imac@gn.apc.org>
Message-ID: <4803181f-95ca-bc04-1765-aa0d8150e9f2@gn.apc.org>
Date: Mon, 28 May 2018 18:00:13 +0200
MIME-Version: 1.0
In-Reply-To: <0862c878-38bb-8af3-be83-d5e6c7dac282@sandeen.net>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="KpkS5V05tyDy7eMqHRQ9XkTk1pJzK1KmS"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KpkS5V05tyDy7eMqHRQ9XkTk1pJzK1KmS
Content-Type: multipart/mixed; boundary="8oYUGTmVf43tFt7EKMUtyDDp7V7o65ILi";
 protected-headers="v1"
From: Ian Macdonald <imac@gn.apc.org>
To: Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Message-ID: <4803181f-95ca-bc04-1765-aa0d8150e9f2@gn.apc.org>
Subject: Re: Deleting a project from XFS quotas
References: <d30e573b-9c2a-cf97-7608-ad10a7b1b21c@gn.apc.org>
 <20180523002552.GY23861@dastard>
 <0862c878-38bb-8af3-be83-d5e6c7dac282@sandeen.net>
In-Reply-To: <0862c878-38bb-8af3-be83-d5e6c7dac282@sandeen.net>

--8oYUGTmVf43tFt7EKMUtyDDp7V7o65ILi
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi Dave, Eric,

On 23/05/18 04:19, Eric Sandeen wrote:
> On 5/22/18 7:25 PM, Dave Chinner wrote:
>> On Tue, May 22, 2018 at 10:46:28AM +0200, Ian Macdonald wrote:
>=20
> ...
>=20
> =C2=A0
>> I don't know if reporting these empty quota IDs is intentional or
>> what you need to do to avoid having them reported - someone involved
>> in changing the dquot iteration mechanism will have to chime in on
>> that....
>=20
> <someone chimes in>
>=20
> If a quota exists on disk with a limit, it should be shown
> even if it doesn't happen to be in the projects file; in fact the
> projects(5) man page says the file itself is optional.
>=20
> And Ian's quotas weren't exactly empty, they were actual quotas with
> limits set, even if there was no current usage under that ID.
> So I think it makes sense to show them=C2=A0 (we would have if they wer=
e
> in /etc/projects, right?)

OK, that makes sense. Those extra projects were not displayed in the
quota report under Debian jessie, which led to my confusion.

> Anyway, if you have a quota showing up for an ID that's not in
> the projects file:
>=20
> ...
>
> You can make it disappear by setting its limits to zero:
>=20
> # xfs_quota -x -c 'limit -p bhard=3D0 42' /mnt/test
> # xfs_quota -x -c report /mnt/test
> Project quota on /mnt/test (/dev/pmem0p1)

I see, that has worked.

Many thanks for the help.

Best,
-Ian

--=20
Ian Macdonald
GPG/PGP: 0778 889F EE5D DFB4 D195 97A7 779B D6BF A305 DEFC
XMPP/OTR: imac@gn.apc.org  Wire.com: @idmacdonald

GreenNet Ltd, 56-64 Leonard Street, London EC2A 4LT
UK Tel:      0330 355 4011
Intl:        +44 20 7065 0935
My desk:     +44 20 3559 4011
Twitter:     @GreenNetISP
Registered in England & Wales, Company No. 02070438


--8oYUGTmVf43tFt7EKMUtyDDp7V7o65ILi--

--KpkS5V05tyDy7eMqHRQ9XkTk1pJzK1KmS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJbDCeYAAoJEHeb1r+jBd786igP/3rHtyvY3xAEi1pg6rP3KE90
cwC9oBLH1QTERL5rE6q2M+Lt4MyvNc6aETDHmq61K1YOaJPUe4Izy112rbKlzTzJ
pw1Fne285on6deW2yNac+RMbtUZzcbWFHVKxJbmdx+8+YoNe0rNbx5E/5/CHTW+S
xM5ue6KYl/3FvGh7TpbPJYdJW+Y/kLiopUMHdp7FE4Z3MDqGj+lpDyTeYXu0KwlM
Yn6R6uCN09Yzz/2B70We5AC8KsNsQ6zFK7zfYFSjpdvUJjoHtM/ofbMUUyYI4fFX
esI5NE8DftsF2O8hPihttnnO1strUrqkqAUBTJraKoTK+i6XZ2gF0UwrOijxmj+t
yPrlVNr4VUggyJnzO8K6bWxJxQ8UMCtBq53TM6SXqIfH2lCvsa6COUFiwBmERv1N
CRyMnlrQlwj5FN0I01Ra37PtXt42AzJfU7wnq+WD0xJxf6OGql0BLQ8IqEnV0E2e
kD56wJNyv5FcoAaOziuaZabDVsRuQokpJeGsNCXxrt+LIFxpWxWVK6f/w94xhk74
d5TNSP00fDumM6aav6V91rjjj0MDDrmFAzOHuYxZ+rbf7AKRaBs/Jv49DI/gD7sH
RQEkljoTpkI8IO//fq3H9EZNLMBNh9kQ53WIZPh082vT3ruTTsupS2ro6hFtWYCh
7mV29WhJHtn2bUisZF+/
=2deL
-----END PGP SIGNATURE-----

--KpkS5V05tyDy7eMqHRQ9XkTk1pJzK1KmS--
