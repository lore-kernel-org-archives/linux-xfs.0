Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from buxtehude.debian.org ([209.87.16.39]:55918 "EHLO
        buxtehude.debian.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751096AbdCQUqd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2017 16:46:33 -0400
Subject: Bug#766811: spurious library links
Reply-To: Michael Biebl <biebl@debian.org>, 766811@bugs.debian.org
References: <20141026004825.GA27863@bongo.bofh.it>
 <20160124151308.GA7620@jwilk.net> <20160206005821.GA11551@bongo.bofh.it>
 <20160206132241.GA2869@jwilk.net> <20160210031703.GA28092@bongo.bofh.it>
 <822351939.19802495.1455074423707.JavaMail.zimbra@redhat.com>
 <785bca5c-7b92-1c20-7a68-7c8b79419fa4@debian.org>
 <CAFMei7NSLSmONCC6AT1hbyLi18e4MWkYwt9pjqBrWACBEa+AfA@mail.gmail.com>
 <9f4d18b6-66b9-5014-4c8b-40ad63ecbbe0@debian.org>
 <CAFMei7Obi6WV2+RW4kccQn7zyqMZZcm7WtSAKt6D2a-VKH0cDA@mail.gmail.com>
From: Michael Biebl <biebl@debian.org>
Message-ID: <29b6e6b8-46ff-ad69-9016-ab7bef89d809@debian.org>
Date: Fri, 17 Mar 2017 21:42:54 +0100
MIME-Version: 1.0
In-Reply-To: <CAFMei7Obi6WV2+RW4kccQn7zyqMZZcm7WtSAKt6D2a-VKH0cDA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FMln56jV5M1tAxDeReA4UX8ms79CGcjlx"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nathan Scott <nscott@redhat.com>
Cc: 766811 <766811@bugs.debian.org>, Nathan Scott <nathans@debian.org>, Marco d'Itri <md@linux.it>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FMln56jV5M1tAxDeReA4UX8ms79CGcjlx
Content-Type: multipart/mixed; boundary="9xMVNadrLMbSbOeeS2g1ehhA9VW2qgM0l";
 protected-headers="v1"
From: Michael Biebl <biebl@debian.org>
To: Nathan Scott <nscott@redhat.com>
Cc: 766811 <766811@bugs.debian.org>, Nathan Scott <nathans@debian.org>,
 Marco d'Itri <md@linux.it>
Message-ID: <29b6e6b8-46ff-ad69-9016-ab7bef89d809@debian.org>
Subject: Re: Bug#766811: spurious library links
References: <20141026004825.GA27863@bongo.bofh.it>
 <20160124151308.GA7620@jwilk.net> <20160206005821.GA11551@bongo.bofh.it>
 <20160206132241.GA2869@jwilk.net> <20160210031703.GA28092@bongo.bofh.it>
 <822351939.19802495.1455074423707.JavaMail.zimbra@redhat.com>
 <785bca5c-7b92-1c20-7a68-7c8b79419fa4@debian.org>
 <CAFMei7NSLSmONCC6AT1hbyLi18e4MWkYwt9pjqBrWACBEa+AfA@mail.gmail.com>
 <9f4d18b6-66b9-5014-4c8b-40ad63ecbbe0@debian.org>
 <CAFMei7Obi6WV2+RW4kccQn7zyqMZZcm7WtSAKt6D2a-VKH0cDA@mail.gmail.com>
In-Reply-To: <CAFMei7Obi6WV2+RW4kccQn7zyqMZZcm7WtSAKt6D2a-VKH0cDA@mail.gmail.com>

--9xMVNadrLMbSbOeeS2g1ehhA9VW2qgM0l
Content-Type: multipart/mixed;
 boundary="------------7042D7A2FD74CF2CA02AF554"

This is a multi-part message in MIME format.
--------------7042D7A2FD74CF2CA02AF554
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 17.03.2017 um 16:50 schrieb Nathan Scott:
> Hi Michael,
>=20
> Yes, please go right ahead with NMU -

Done. I've just uploaded xfsprogs_4.9.0+nmu1

 I will follow up with the XFS
> folks when I can.

debdiff is attached. It slightly differs from Marco's original patch.
Instead of disabling the code, I simply removed it. This should be more
suitable for upstreaming.

Regards,
Michael

--=20
Why is it that all of the instruments seeking intelligent life in the
universe are pointed away from Earth?

--------------7042D7A2FD74CF2CA02AF554
Content-Type: text/plain; charset=UTF-8;
 name="xfsprogs_4.9.0+nmu1.debdiff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="xfsprogs_4.9.0+nmu1.debdiff"

ZGlmZiAtTnJ1IHhmc3Byb2dzLTQuOS4wL2RlYmlhbi9jaGFuZ2Vsb2cgeGZzcHJvZ3MtNC45
LjArbm11MS9kZWJpYW4vY2hhbmdlbG9nCi0tLSB4ZnNwcm9ncy00LjkuMC9kZWJpYW4vY2hh
bmdlbG9nCTIwMTctMDEtMDUgMjM6MDU6NTUuMDAwMDAwMDAwICswMTAwCisrKyB4ZnNwcm9n
cy00LjkuMCtubXUxL2RlYmlhbi9jaGFuZ2Vsb2cJMjAxNy0wMy0xNyAxOToyNzo1OC4wMDAw
MDAwMDAgKzAxMDAKQEAgLTEsMyArMSwxMSBAQAoreGZzcHJvZ3MgKDQuOS4wK25tdTEpIHVu
c3RhYmxlOyB1cmdlbmN5PW1lZGl1bQorCisgICogTm9uLW1haW50YWluZXIgdXBsb2FkLgor
ICAqIFJlbW92ZSBjb2RlIGluIGluY2x1ZGUvYnVpbGRtYWNyb3Mgd2hpY2ggY3JlYXRlcyBi
b2d1cyBzeW1saW5rcyBmb3IKKyAgICBsaWJyYXJpZXMuIChDbG9zZXM6ICM3NjY4MTEpCisK
KyAtLSBNaWNoYWVsIEJpZWJsIDxiaWVibEBkZWJpYW4ub3JnPiAgRnJpLCAxNyBNYXIgMjAx
NyAxOToyNzo1OCArMDEwMAorCiB4ZnNwcm9ncyAoNC45LjApIHVuc3RhYmxlOyB1cmdlbmN5
PWxvdwogCiAgICogTmV3IHVwc3RyZWFtIHJlbGVhc2UKZGlmZiAtTnJ1IHhmc3Byb2dzLTQu
OS4wL2luY2x1ZGUvYnVpbGRtYWNyb3MgeGZzcHJvZ3MtNC45LjArbm11MS9pbmNsdWRlL2J1
aWxkbWFjcm9zCi0tLSB4ZnNwcm9ncy00LjkuMC9pbmNsdWRlL2J1aWxkbWFjcm9zCTIwMTct
MDEtMDUgMjM6MDU6NTUuMDAwMDAwMDAwICswMTAwCisrKyB4ZnNwcm9ncy00LjkuMCtubXUx
L2luY2x1ZGUvYnVpbGRtYWNyb3MJMjAxNy0wMy0xNyAxOToyNzo1OC4wMDAwMDAwMDAgKzAx
MDAKQEAgLTc1LDEzICs3NSw3IEBACiAJLi4vJChJTlNUQUxMKSAtbSA2NDQgLVQgb2xkX2xp
YiAkKExJQk5BTUUpLmxhaSAkKFBLR19MSUJfRElSKTsgXAogCS4uLyQoSU5TVEFMTCkgLW0g
NjQ0ICQoTElCTkFNRSkubGFpICQoUEtHX0xJQl9ESVIpLyQoTElCTkFNRSkubGEgOyBcCiAJ
Li4vJChJTlNUQUxMKSAtbSA3NTUgLWQgJChQS0dfUk9PVF9MSUJfRElSKTsgXAotCS4uLyQo
SU5TVEFMTCkgLVQgc29fYmFzZSAkKExJQk5BTUUpLmxhaSAkKFBLR19ST09UX0xJQl9ESVIp
OyBcCi0JaWYgWyAieCQoc2hlbGwgcmVhZGxpbmsgLWYgJChQS0dfTElCX0RJUikpIiAhPSBc
Ci0JICAgICAieCQoc2hlbGwgcmVhZGxpbmsgLWYgJChQS0dfUk9PVF9MSUJfRElSKSkiIF07
IHRoZW4gXAotCQkuLi8kKElOU1RBTEwpIC1TICQoUEtHX0xJQl9ESVIpLyQoTElCTkFNRSku
YSAkKFBLR19ST09UX0xJQl9ESVIpLyQoTElCTkFNRSkuYTsgXAotCQkuLi8kKElOU1RBTEwp
IC1TICQoUEtHX0xJQl9ESVIpLyQoTElCTkFNRSkubGEgJChQS0dfUk9PVF9MSUJfRElSKS8k
KExJQk5BTUUpLmxhOyBcCi0JCS4uLyQoSU5TVEFMTCkgLVMgJChQS0dfUk9PVF9MSUJfRElS
KS8kKExJQk5BTUUpLnNvICQoUEtHX0xJQl9ESVIpLyQoTElCTkFNRSkuc287IFwKLQlmaQor
CS4uLyQoSU5TVEFMTCkgLVQgc29fYmFzZSAkKExJQk5BTUUpLmxhaSAkKFBLR19ST09UX0xJ
Ql9ESVIpOwogZWxzZQogSU5TVEFMTF9MVExJQl9ERVYgPSAkKElOU1RBTExfTFRMSUJfU1RB
VElDKQogZW5kaWYK
--------------7042D7A2FD74CF2CA02AF554--

--9xMVNadrLMbSbOeeS2g1ehhA9VW2qgM0l--

--FMln56jV5M1tAxDeReA4UX8ms79CGcjlx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEECbOsLssWnJBDRcxUauHfDWCPItwFAljMSlEACgkQauHfDWCP
ItxRXhAAk6Ch+qKpH4xNlkslA9m1Uw/vxcJO2Z4ATpvd0zeoYR87z87HYS6JPdjI
mClTjTkAT0vIFizBrVO0ZU96LmC95J9F9Avmgm4oYO+OgbpXw7cBCsnB1+Urk3KV
zDkn9ORmZJTMSVokRTNhBbxozehz5OuvPq0Z8y7Uxlc9eR9U7t46gHge1Odro93A
qmCu5tH0aLWVmB8u4oKS13a7MFLkzc+FN+/DGdFQnUW18/GeRN8aekF9JZR3mEPs
O7oHJ65DwcSFndOptkxl1wUSu0o1ggh+uOTGPnNWfDDPtkjnY4ELhZ+VehJwGaWS
rTOaj3Rmu474iDOLONxlO5PxOUuNmL/uBS7gqcxDjTvK9y1b67B7qrALXY05jSGG
lhXXBZvb7pHU/bxF7WFeUblEvdjYSS4Lh6MpkKTy2MErQDIm9oihuAvQnHcReJuR
3pPxXC3kjNiTieHQZf7YQbcagj+8Wh2yMdduR+/AXBFPGUeTfJhJyPSCgdpoTPkV
cqMDlLlZ7mM60nkqpdWBawORR4sSvvjDJiy0YTJvNAP2SPBR2EVPwsVr6zEqoCLD
M5GhcWo10PUr8hfZi5+Kpd4b+2RSVq9JGK0bkG7WNNQFh+Q5WqNU65nKzSNjv0B6
t77L9cs/12Fs+QSp+avNpt9RDDqYlfjd/1F6pScH4z2jlyIqa4M=
=EJVK
-----END PGP SIGNATURE-----

--FMln56jV5M1tAxDeReA4UX8ms79CGcjlx--
