Return-Path: <SRS0=m/8K=CN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C1B4C433E2
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 20:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D29A820C09
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 20:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgIDUyt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Sep 2020 16:54:49 -0400
Received: from sandeen.net ([63.231.237.45]:54864 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727855AbgIDUys (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Sep 2020 16:54:48 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 9C8DD323C01
        for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2020 15:54:21 -0500 (CDT)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v5.8.0 released
Message-ID: <9e40920d-2976-cd96-f5d7-335455c2fff3@sandeen.net>
Date:   Fri, 4 Sep 2020 15:54:46 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ftvEvk3fBukfbtxUUseKxiwc7sgzT68sR"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ftvEvk3fBukfbtxUUseKxiwc7sgzT68sR
Content-Type: multipart/mixed; boundary="4Ex5qWoNk5EZO0URGsukYQ5L7vuiBH9hB";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <9e40920d-2976-cd96-f5d7-335455c2fff3@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v5.8.0 released

--4Ex5qWoNk5EZO0URGsukYQ5L7vuiBH9hB
Content-Type: multipart/mixed;
 boundary="------------D7269FA9AABE9E4875709FA3"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------D7269FA9AABE9E4875709FA3
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

xfsprogs v5.8.0 has been released, and the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Tarballs are available at:

https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.8.0.tar=
=2Egz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.8.0.tar=
=2Exz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.8.0.tar=
=2Esign

The new head of the master branch is commit:

7fa3a67f "xfsprogs: Release v5.8.0"

Abbreviated changelog:

xfsprogs-5.8.0 (04 Sep 2020)
        - xfs_db: set b_ops to NULL for types without verifiers (Eric San=
deen)

xfsprogs-5.8.0-rc1 (26 Aug 2020)
        - mkfs: allow setting dax flag on root directory (Darrick Wong)
        - xfs_quota: improve reporting and messages (Bill O'Donnell)
        - xfs_db: use correct inode to set inode type (Zorro Lang)
        - xfs_db: fix nlink usage in check (Darrick Wong)
        - xfs_db: report the inode dax flag (Darrick Wong)
        - man: update mkfs.xfs inode flag option documentation (Darrick W=
ong)
        - xfsprogs: move custom interface def'ns to new header (Eric Sand=
een)

xfsprogs-5.8.0-rc0 (10 Aug 2020)
        - xfs_repair: check quota counters (Darrick Wong)
        - xfs_io: fix -D vs -R handling (Xiao Yang)
        - libxfs changes merged from kernel 5.8


Thanks,
-Eric



--------------D7269FA9AABE9E4875709FA3
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

--------------D7269FA9AABE9E4875709FA3--

--4Ex5qWoNk5EZO0URGsukYQ5L7vuiBH9hB--

--ftvEvk3fBukfbtxUUseKxiwc7sgzT68sR
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl9SqZYFAwAAAAAACgkQIK4WkuE93uDz
Bw//ZDHz0KuJYW2jKCZTRvf1/lTMSJy9FStjRRA/xpX03WYBg/ztTvfRKYIWkza2nSLcrdgmePBD
fMlv5jeD6+kYzx6YHjboURuahkbR6jptZSsVYSRjz/xIIN6rG+ZgzdS+0VyCykg5n82jBcQHpQ9A
CTlx8cZPRwgjPrZ/PpPwoAAloLD6B+nI6iaLifvsF9P8J+3QlapKang6+MkCkbyBNQTRUk02TBGR
ZACxvlK5IyfTAw9hAGc4by9EEXSu+TwRFjZT84sioKXYpFTGaiaQKApgSd4EL0v+1GCEoWr7mkxv
QxftTHxemKtsiICpEUgGTV3C8kcL7DavKAPwXoRnysUn7brdJFW0KuPVK6vE3v1NWC5EjVVMTXwo
FWrhWd0qglkb0HYBsL5sBiwssFkIV5Qlbv3psZge8cBlKxLu1eJ0+rAk1M2u6149I1KaeCnxT8AV
efTHZODtWQcfohTu3Hd6dbGes8Hmp96lfdNshPdCcjq898E7AE2lBsjsqt5wPIwPODytZjY1ubq5
pnrxjpQJdn1LzivSzcT981An8QF1i+qb21UUDLlpzxyyHE5vPhFmnMq1cjngm1PlOlWaXfU1mdFE
uf3Ffb2S0R1yNKy7mR1n8L5Lvt6p+Q2CT/wMNaYlV7UQ5TSDKY2hjSIgTUJTTpJq4HLN+eNq4rbN
hJw=
=6LLI
-----END PGP SIGNATURE-----

--ftvEvk3fBukfbtxUUseKxiwc7sgzT68sR--
