Return-Path: <SRS0=RTOF=DJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C87BC4363C
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 17:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B64B520758
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 17:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgJBRO0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Oct 2020 13:14:26 -0400
Received: from sandeen.net ([63.231.237.45]:44316 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbgJBRO0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Oct 2020 13:14:26 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 5A6A74872C8
        for <linux-xfs@vger.kernel.org>; Fri,  2 Oct 2020 12:13:34 -0500 (CDT)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 4aaeedc4
Message-ID: <af4cbb91-d293-cbd7-4dce-6201e6f55010@sandeen.net>
Date:   Fri, 2 Oct 2020 12:14:23 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kw5T9y82BVqu0rVM1ogjAYttXH76FX1ye"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kw5T9y82BVqu0rVM1ogjAYttXH76FX1ye
Content-Type: multipart/mixed; boundary="5rtrgIeSPtbaJr5kk6ra2GyHKaQbxoXtV";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <af4cbb91-d293-cbd7-4dce-6201e6f55010@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 4aaeedc4

--5rtrgIeSPtbaJr5kk6ra2GyHKaQbxoXtV
Content-Type: multipart/mixed;
 boundary="------------3343BE0A2744FFFC1436CE9B"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------3343BE0A2744FFFC1436CE9B
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

This is getting near -rc1, if you have more to get in, make sure I know
about it.  :)

The new head of the for-next branch is commit:

4aaeedc4 (HEAD -> for-next, origin/for-next, korg/for-next) libxfs: disal=
low filesystems with reverse mapping and reflink and realtime

New Commits:

Anthony Iliopoulos (1):
      [a4170b73] mkfs: remove a couple of unused function parameters

Darrick J. Wong (16):
      [f4ff8086] xfs_repair: don't crash on partially sparse inode cluste=
rs
      [c29a562f] xfs_repair: fix error in process_sf_dir2_fixi8
      [78cc984d] xfs_repair: junk corrupt xattr root blocks
      [e487b557] xfs_repair: complain about unwritten extents when they'r=
e not appropriate
      [36669577] xfs_repair: fix handling of data blocks colliding with e=
xisting metadata
      [07e068f9] xfs_repair: throw away totally bad clusters
      [82491ad3] xfs_repair: use libxfs_verify_rtbno to verify rt extents=

      [c2f38a4b] man: install all manpages that redirect to another manpa=
ge
      [4f6eceed] mkfs.xfs: tweak wording of external log device size comp=
laint
      [4e568074] mkfs: fix reflink/rmap logic w.r.t. realtime devices and=
 crc=3D0 support
      [31409f48] mkfs: set required parts of the realtime geometry before=
 computing log geometry
      [7214a7d4] libxfs: refactor inode flags propagation code
      [6c03cb23] libxfs: don't propagate RTINHERIT -> REALTIME when there=
 is no rtdev
      [221ec450] mkfs: don't allow creation of realtime files from a prot=
o file
      [e8e72c93] xfs_repair: don't flag RTINHERIT files when no rt volume=

      [4aaeedc4] libxfs: disallow filesystems with reverse mapping and re=
flink and realtime

Eric Sandeen (1):
      [7afc993c] mkfs.xfs: remove comment about needed future work

Pavel Reichl (1):
      [97a40596] mkfs.xfs: fix ASSERT on too-small device with stripe geo=
metry


Code Diffstat:

 include/buildmacros     |  3 +-
 include/xfs_multidisk.h | 14 ++++----
 libxfs/init.c           | 15 +++++++++
 libxfs/util.c           | 55 +++++++++++++++++-------------
 mkfs/proto.c            |  6 ++++
 mkfs/xfs_mkfs.c         | 42 +++++++++++------------
 repair/attr_repair.c    |  9 +++++
 repair/dino_chunks.c    | 54 +++++++++++++++++++++++++++++-
 repair/dinode.c         | 89 +++++++++++++++++++++++++++----------------=
------
 repair/dir2.c           |  2 +-
 10 files changed, 193 insertions(+), 96 deletions(-)

--------------3343BE0A2744FFFC1436CE9B
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

--------------3343BE0A2744FFFC1436CE9B--

--5rtrgIeSPtbaJr5kk6ra2GyHKaQbxoXtV--

--kw5T9y82BVqu0rVM1ogjAYttXH76FX1ye
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl93X+8FAwAAAAAACgkQIK4WkuE93uCQ
0hAAq+M01iDk6ZORILeOnq2eR3NMnU9+O8apEVvjaXkdDidHHVhSXl9AsjBLg3vm+K+caLrkHWiW
by6BsldMfuW8oGN9NB5U45/DhPcKs/HzZJRDVBwMQrvoE2gFkANsFhhmoJJsyf8D+vWXzv/Vb38V
ZJCVhuUx5JnNPigfACY+5FNlLSDnnLqzv2A89NQb1LOStZqNjNZR9esgS9N+mCJ+197LZZhUJttY
uLnjAXNYH9iy97vpEMcYqP1nfoUPL+MrAeiA1iUd2WMiyjwVswZ1iPflmIiQm5Xb203eNBJYazBa
ZpTje3JgwGwFMCyvxty9m2619lXvJRa8MHsmpDP9PCFRHNPFFv0+T/bIf8cEVB7CsTyUPYAKdei/
rdxrxXe9Zx4Fqb6ZqvrTRTpP3bUUc1fwUFJ/fgK0hdxGf4PurQN0b/XlMRwD+h3+jBkA/irJqZQ8
u/ft90sbz2qrnauTZLUnCtX2etRAsNwpwK+U9Df3PeTq2vxsJ8O5oVkKU5wakz4EWbIiv4lioH6W
z0s/2c0JP7Aco3fTpZIYoUHn9WD2LmAi+e35a/i793+7MLiGbW2iDTxOz1LXEglG87qJXU0hEioi
Cp5TKbvAl2ygiVm4+XwlybjR4ev5DaAy6i3MzToehEId6tpCd0n73hU0bTOl+RZgaVP1ITMV8/py
GE8=
=m3DR
-----END PGP SIGNATURE-----

--kw5T9y82BVqu0rVM1ogjAYttXH76FX1ye--
