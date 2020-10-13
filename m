Return-Path: <SRS0=8N9+=DU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A869C433E7
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 16:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00013252AB
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 16:35:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbgJMQfV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Oct 2020 12:35:21 -0400
Received: from sandeen.net ([63.231.237.45]:40508 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727415AbgJMQfU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Oct 2020 12:35:20 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 200AD11662
        for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2020 11:34:10 -0500 (CDT)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 4aaeedc4 / v5.9.0-rc1
Message-ID: <e4d9a624-7199-7d27-9c8d-7f66f27fbd2d@sandeen.net>
Date:   Tue, 13 Oct 2020 11:35:19 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="U5KZRNRH3vdGUK3zjHAucS5da4zGRE8ca"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--U5KZRNRH3vdGUK3zjHAucS5da4zGRE8ca
Content-Type: multipart/mixed; boundary="MsE7KBB7cE95adnL295oaeLP88tAChL5X";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <e4d9a624-7199-7d27-9c8d-7f66f27fbd2d@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 4aaeedc4 / v5.9.0-rc1

--MsE7KBB7cE95adnL295oaeLP88tAChL5X
Content-Type: multipart/mixed;
 boundary="------------84EDE1D8045E0154C283DC48"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------84EDE1D8045E0154C283DC48
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v5.9.0-rc1.

Barring important missed patches or regressions, this will be the content=

for v5.9.0 GA.

The new head of the for-next branch is commit:

b2fa3ec1 (HEAD -> for-next, korg/for-next, refs/patches/for-next/5.9.0-rc=
1.patch) xfsprogs: Release v5.9.0-rc1

New Commits:

Darrick J. Wong (4):
      [0779e54d] libfrog: fix a potential null pointer dereference
      [f4d02645] libhandle: fix potential unterminated string problem
      [2b9857cd] xfs_scrub: don't use statvfs to collect filesystem summa=
ry counts
      [86b8934d] xfs_repair: coordinate parallel updates to the rt bitmap=


Eric Sandeen (2):
      [b285432b] xfsprogs: fix ioctl_xfs_geometry manpage naming
      [b2fa3ec1] xfsprogs: Release v5.9.0-rc1

Gao Xiang (1):
      [8faa41b4] xfsprogs: allow i18n to xfs printk

Ian Kent (1):
      [5ca4d781] xfsprogs: ignore autofs mount table entries


Code Diffstat:

 VERSION                                            |  2 +-
 configure.ac                                       |  2 +-
 debian/changelog                                   |  6 +++++
 doc/CHANGES                                        | 11 +++++++++
 libfrog/bulkstat.c                                 |  2 +-
 libfrog/linux.c                                    |  2 ++
 libfrog/paths.c                                    |  2 ++
 libhandle/handle.c                                 |  3 ++-
 libxfs/libxfs_priv.h                               |  8 +++----
 ..._xfs_fsop_geometry.2 =3D> ioctl_xfs_fsgeometry.2} | 10 ++++----
 man/man3/xfsctl.3                                  |  4 ++--
 repair/dinode.c                                    | 16 ++++++-------
 repair/globals.c                                   |  1 +
 repair/globals.h                                   |  1 +
 repair/incore.c                                    |  1 +
 scrub/fscounters.c                                 | 27 ++++------------=
------
 16 files changed, 52 insertions(+), 46 deletions(-)
 rename man/man2/{ioctl_xfs_fsop_geometry.2 =3D> ioctl_xfs_fsgeometry.2} =
(95%)

--------------84EDE1D8045E0154C283DC48
Content-Type: application/pgp-keys;
 name="OpenPGP_0x20AE1692E13DDEE0.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="OpenPGP_0x20AE1692E13DDEE0.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsFNBE6x99QBEADMR+yNFBc1Y5avoUhzI/sdR9ANwznsNpiCtZlaO4pIWvqQJCjBzp96cpCsn=
QZV
32nqJBYnDpBDITBqTa/EF+IrHx8gKq8TaSBLHUq2ju2gJJLfBoL7V3807PQcI18YzkF+WL05O=
DFQ
2cemDhx5uLghHEeOxuGj+1AI+kh/FCzMedHc6k87Yu2ZuaWF+Gh1W2ix6hikRJmQvj5BEeAx7=
xKk
yBhzdbNIbbjV/iGi9b26B/dNcyd5w2My2gxMtxaiP7q5b6GM2rsQklHP8FtWZiYO7jsg/qIpp=
R1C
6Zr5jK1GQlMUIclYFeBbKggJ9mSwXJH7MIftilGQ8KDvNuV5AbkronGCsEEHj2khs7GfVv4pm=
UUH
f1MRIvV0x3WJkpmhuZaYg8AdJlyGKgp+TQ7B+wCjNTdVqMI1vDk2BS6Rg851ay7AypbCPx2w4=
d8j
IkQEgNjACHVDU89PNKAjScK1aTnW+HNUqg9BliCvuX5g4z2jgJBs57loTWAGe2Ve3cMy3VoQ4=
0Wt
3yKK0Eno8jfgzgb48wyycINZgnseMRhxc2c8hd51tftKLKhPj4c7uqjnBjrgOVaVBupGUmvLi=
ePl
nW56zJZ51BR5igWnILeOJ1ZIcf7KsaHyE6B1mG+XdmYtjDhjf3NAcoBWJuj8euxMB6TcQN2Mr=
SXy
5wSKaw40evooGwARAQABzSVFcmljIFIuIFNhbmRlZW4gPHNhbmRlZW5Ac2FuZGVlbi5uZXQ+w=
sF4
BBMBAgAiBQJOsffUAhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRAgrhaS4T3e4K8WD=
/9R
xynMYm+vXF1lc1ldA4miH1Mcw2y+3RSU4QZA5SrRBz4NX1atqz3OEUpu7qAAZUW9vp3MWEXeK=
rVR
/yg0NZTOPe+2a7ZN0J+s7AF6xVjdEsjW4bOo5cmGMcpciyfr9WwZbOOUEWWZ08UkEFa6B+p4E=
KJ9
eCOFeHITCkR3AA8uxtGBBAbFzm6wMmDegsvld9bXv5RdfUptyElzqlIukPJRz3/p3bUSCT6mk=
W7r
rvBUMwvGnaI2YVabJSLpd2xiVs7+gnslOk35TAMLrJ0uo3Nt2bx3sFlDIr9E2RgKYpbNE39O3=
5l8
t+A3asqD8DlqDg+VgTuOKBny/bVeKFuKAJ0Bvy2EU+/GPj/rnNgWh0gCPiaKqRRkPriGwdAXQ=
2zk
2oQUq0cfpOQm6oIKKgXEt+W/r0cxuWLAdxMsLYdzrARstfiMYLMnw6z6mGpptgTSSnemw1tOD=
qe9
+++Z6yM8JA1RIyCVRlGx4dBh+vtQsFzCJfgIZxmF0rWKgW2aAOHbzNHG+UUODLK0IpOhUYTcg=
yjl
vFM3tFwVjy0z/wF8ebmHkzeTMKJ64nPClwwfRfHz6KlgGlzEefNtZoHN7iR7uh282CpQ24NUC=
hS2
ORSd85Jt5TwxOfgSrEO9cC7rOeh18fNShCRrTG6WBdxXmxBn/e49nI2KHhMSVxut37YoWtqIu=
80k
RXJpYyBSLiBTYW5kZWVuIDxzYW5kZWVuQHJlZGhhdC5jb20+wsF4BBMBAgAiBQJOsq5eAhsDB=
gsJ
CAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRAgrhaS4T3e4IdpD/wOgkZiBdjErbXm8gZPuj6ce=
O3L
finJqWKJMHyPYmoUj4kPi5pgWRPjzGHrBPvPpbEogL88+mBF7H1jJRsx4qohO+ndsUjmFTztq=
1+8
ZeE9iffMmZWK4zA5kOoKRXtGQaVZeOQhVGJAWnrpRDLKc2mCx+sxrD44H1ScmJ1veGVy1nK0k=
4sQ
TyXA7ZOI+o622NyvHlRYpivkUqugqmYFGfrmgwP8CeJB62LrzN0D27B0K/22EjZFQBcYJRumu=
Aki
eMO9P3U/RRW+48499J5mgZgxXLgvsc3nKXH5Wi77hWsrgSbJTKeHm2i/H4Jb57VrEGTPN+tQp=
I7f
NrqaNiUWIk65RPV4khBrMVtxKXRU971JiJYGNP16OTxr98ksHBbnEVJNUPY/mV+IAml+bB6UD=
NN1
E2g8eIxXRqji5009YX6zEGdxIs1W50FvRzdLJ5vZQ+T+jtXccim2aXr31gX8HUN+UVwWyCg5p=
mZ8
CRiYGJeQc4eQ5U9Ce6DFTs3RFWIqVsfNsAah1VuCNbT7p8oK2DvozZ/gS8EQjmESZuQQDcGMd=
DL1
pZtzLdzpJFtqW1/gtz+aAHMa35WsNx3hAYvymJMoMaL1pfdyC07FtN0dGjXCOm0nWEf+vKS+B=
C3c
exv0i22h39vBc81BY0bzeeZwaDHjzhaNTuirZF10OBm11Xm3b87BTQROsffUARAA0DrUifTrX=
Qzq
xO8aiQOC5p9Tz25Np/Tfpv1rofOwL8VPBMvJX4P5l1V2yd70MZRUVgjmCydEyxLJ6G2YyHO2I=
ZTE
ajUY0Up+b3ErOpLpZwhvgWatjifpj6bBSKuDXeThqFdkphF5kAmgfVAIkan5SxWK3+S0V2F/o=
xst
IViBhMhDwI6XsRlnVBoLLYcEilxA2FlRUS7MOZGmRJkRtdGD5koVZSM6xVZQSmfEBaYQ/WJBG=
JQd
Py94nnlAVn3lH3+N7pXvNUuCGV+t4YUt3tLcRuIpYBCOWlc7bpgeCps5Xa0dIZgJ8Louu6OBJ=
5vV
XjPxTlkFdT0S0/uerCG51u8p6sGRLnUeAUGkQfIUqGUjW2rHaXgWNvzOV6i3tf9YaiXKl3avF=
aNW
1kKBs0T5M1cnlWZUUtl6k04lz5OjoNY9J/bGyV3DSlkblXRMK87iLYQSrcV6cFz9PRl4vW1LG=
ff3
xRQHngeN5fPxze8X5NE3hb+SSwyMSEqJxhVTXJVfQWWW0dQxP7HNwqmOWYF/6m+1gK/Y2gY3j=
AQn
sWTru4RVTZGnKwEPmOCpSUvsTRXsVHgsWJ70qd0yOSjWuiv4b8vmD3+QFgyvCBxPMdP3xsxN5=
eth
eLMOgRwWpLn6yNFq/xtgs+ECgG+gR78yXQyA7iCs5tFs2OrMqV5juSMGmn0kxJUAEQEAAcLBX=
wQY
AQIACQUCTrH31AIbDAAKCRAgrhaS4T3e4BKwD/0ZOOmUNOZCSOLAMjZx3mtYtjYgfUNKi0kiY=
Pve
GoRWTqbis8UitPtNrG4XxgzLOijSdOEzQwkdOIp/QnZhGNssMejCnsluK0GQd+RkFVWNmcQT7=
8hB
eGcnEMAXZKq7bkIKzvc06GFmkMbX/gAl6DiNGv0UNAX+5FYh+ucCJZSyAp3sA+9/LKjxnTedX=
0ay
gXA6rkpX0Y0FvN/9dfm47+LGq7WAqBOyYTU3E6/+Z72bZoG/cG7ANLxcPoolLOrU43oqFnD8Q=
wcN
56y4VfFj3/jDF2MX3xu4v2OjglVjMEYHTCxP3mpxesGHuqOit/FR+mF0MP9JGfj6x+bj/9JMB=
tCW
1bY/aPeMdPGTJvXjGtOVYblGZrSjXRn5++Uuy36CvkcrjuziSDG+JEexGxczWwN4mrOQWhMT5=
Jyb
+18CO+CWxJfHaYXiLEW7dI1AynL4jjn4W0MSiXpWDUw+fsBOPk6ah10C4+R1Jc7dyUsKksMfv=
vhR
X1hTIXhth85H16706bneTayZBhlZ/hK18uqTX+s0onG/m1F3vYvdlE4p2ts1mmixMF7KajN9/=
E5R
QtiSArvKTbfsB6Two4MthIuLuf+M0mI4gPl9SPlffWCYVPhaU9o83y1KFbD/+lh1pjP7bEu/Y=
udB
vz7F2Myjh4/9GUAijrCTNeDTDAgvIJDjXuLXpA=3D=3D
=3DpESb
-----END PGP PUBLIC KEY BLOCK-----

--------------84EDE1D8045E0154C283DC48--

--MsE7KBB7cE95adnL295oaeLP88tAChL5X--

--U5KZRNRH3vdGUK3zjHAucS5da4zGRE8ca
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl+F10cFAwAAAAAACgkQIK4WkuE93uBF
sA/+JhWs1yOeNChjeGMwDnK7aw12zQR5qwqQ+xNFyZADdPCAvrLzrmIaDJtaN+RqLeFTTrO81U98
794A+hkl01DNkAoUoq2OSCakXpKBqu5mX54Uxwzj/aWLsuYbb1ykYL6GMA2L4J/TYvfw0zSo2sd7
v0Qs9AG63PeZUIowS5jLXei6ef36loQnfS+7//0KD0kEQ4PhJeElUSWGwDrgSJ8jLPcymhIx2Qxk
JIVY8on+H7wuPWToTwfVKNYIj+C4HqeI4+jfHym3o443K7yqryiDGlUbbJKJXmakPZxGCexLd2Jn
Uj2McL/T8fpOKsKHSyoRdCz3pGzSvMjWCD2dPFyEJwKUqBWXSRd8HnSytKIFPMfqUXCRe3s6NuDA
GD7SfDexG/+dch59ipRN+G11HuMwovewIquNp3bUTc1hlFxt0aS/WXEKug5A8Q2SlHYrvDdgClbN
1RPwq2m2pkF/m38QxB2Hjo/FlmBeEVVyOef9/nHlBhsZw2HHynCVxPkGjSqhoAoyRn1nQY4GuJTl
hN90OUDZTV1SBvro3VP1MPwU4jWepaAEhVxhX5Nu4MZUsj/4xbfvkhUZkScFvtzKRjZ/f1/sVWAN
PByWTQtLQPiYB3jzpnaOA+jP8lvKYh+bFOYCUNH4xJonMzbbOY4d2wQZtyet17PiNZx/UM2TItG+
xU4=
=x/FG
-----END PGP SIGNATURE-----

--U5KZRNRH3vdGUK3zjHAucS5da4zGRE8ca--
