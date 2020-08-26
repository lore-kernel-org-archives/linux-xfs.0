Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 471B1C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 19:17:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CF54207F7
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 19:17:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgHZTRO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 15:17:14 -0400
Received: from sandeen.net ([63.231.237.45]:56954 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbgHZTRO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Aug 2020 15:17:14 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id BF928323BE3
        for <linux-xfs@vger.kernel.org>; Wed, 26 Aug 2020 14:17:00 -0500 (CDT)
To:     linux-xfs@vger.kernel.org
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 84f1e8a0
Message-ID: <e3772721-8f4c-de6a-7197-29f435706ec3@sandeen.net>
Date:   Wed, 26 Aug 2020 14:17:11 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5RmyubORPHo3rXJCIIq4bNMx8WjWq0sx8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5RmyubORPHo3rXJCIIq4bNMx8WjWq0sx8
Content-Type: multipart/mixed; boundary="v3au1UlYZi7YPV7ecq9XBCzPH8IhJy2vg";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs@vger.kernel.org
Message-ID: <e3772721-8f4c-de6a-7197-29f435706ec3@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 84f1e8a0

--v3au1UlYZi7YPV7ecq9XBCzPH8IhJy2vg
Content-Type: multipart/mixed;
 boundary="------------42E218E66C14A6F8E4B4DA94"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------42E218E66C14A6F8E4B4DA94
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with 5.8.0-rc1

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

84f1e8a0 (HEAD -> for-next, tag: v5.8.0-rc1, korg/for-next, refs/patches/=
for-next/v5.8.1-rc1) xfsprogs: Release v5.8.0-rc1

New Commits:

Bill O'Donnell (2):
      [ca42fa70] xfs_quota: command error message improvement
      [d8a94546] xfs_quota: state command should report ugp grace times

Darrick J. Wong (5):
      [4751e054] xfs_db: fix nlink usage in check
      [23d22c98] xfs_db: report the inode dax flag
      [095c2097] man: update mkfs.xfs inode flag option documentation
      [64989ff3] mkfs: allow setting dax flag on root directory
      [387a96e1] xfs_quota: display warning limits when printing quota ty=
pe information

Eric Sandeen (4):
      [7b4a7b3f] xfs_db: short circuit type_f if type is unchanged
      [cdabe556] xfs_db: consolidate set_iocur_type behavior
      [918664ad] xfsprogs: move custom interface definitions out of xfs_f=
s.h
      [84f1e8a0] xfsprogs: Release v5.8.0-rc1

Zorro Lang (1):
      [b1a48c4f] xfs_db: use correct inode to set inode type


Code Diffstat:

 VERSION                 |   2 +-
 configure.ac            |   2 +-
 db/check.c              |   4 +-
 db/inode.c              |   3 ++
 db/io.c                 |  45 +++++-----------
 db/type.c               |   2 +
 debian/changelog        |   6 +++
 doc/CHANGES             |   9 ++++
 include/Makefile        |   1 +
 include/xfs.h           |   2 +
 include/xfs_fs_compat.h |  88 +++++++++++++++++++++++++++++++
 libxfs/xfs_fs.h         |  62 ----------------------
 man/man8/mkfs.xfs.8     |  22 ++++++--
 mkfs/xfs_mkfs.c         |  14 +++++
 quota/state.c           | 134 +++++++++++++++++++++++++++++++++++++-----=
------
 15 files changed, 264 insertions(+), 132 deletions(-)
 create mode 100644 include/xfs_fs_compat.h

--------------42E218E66C14A6F8E4B4DA94
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

--------------42E218E66C14A6F8E4B4DA94--

--v3au1UlYZi7YPV7ecq9XBCzPH8IhJy2vg--

--5RmyubORPHo3rXJCIIq4bNMx8WjWq0sx8
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl9GtTcFAwAAAAAACgkQIK4WkuE93uBq
2xAAt01TaL6Sofzz9YehQsA3vxXXDWl7DRVF4qAK5cbyHGNDKSmGAcpCBZCnIXTot0W43bkr+OsL
WOGEt0hY8Qj2P1elDMwa1EPltcZCjI0/SRIinrOTZYy9QiEz+1UFWXWVaGtSvK+s1ukFBSY8lg9h
qamavNvkMP1Q8SvHgAmTGfsY2uSP5x3Ncf9E+fkgpTt0hS5X1McY1uXP+IlgZ9DXSz54FZCKZ7ow
xQm+vPdt20XdHrRmiQeb/AKl0COnr+D2czSTKbx+1PM4Vf8SkEJl2wC7P0MeWGzuA7dtdeClVi1D
P/iBrS7so4oK4gd9RYsXVd/1tvGUFOwIV1za/3fhguTFikc0JyCSirlNVaWzxZjrOMTePEnN6Ts8
/lSTO87/L9fzxrmMhRaWuSr2Q6qPXow8lENqnz7H2Q/W7LURbt+bRKu9D53yiDih1Tvqvx17qm8U
5ySr9tUwnd/9yqyoqkZkYOQySRLrSvT78xR77P5iUdhLgOZaevYhQ/mlXt6bge0T6q2/EcWohn44
XuGEFoLILkyZy35fhhF4pwAYkoGY/Ni1hI3MYstVLwANhSIsKp99z13tP7J3Welqkish/cshP0O3
XrlqAtz9f/jAvBUOZCc03m//kO6dCkq9SBIfBE5hCVwAkTR+c4JLi+9qXP1NVStpaGvmrI3B5tZk
e+s=
=CoZj
-----END PGP SIGNATURE-----

--5RmyubORPHo3rXJCIIq4bNMx8WjWq0sx8--
