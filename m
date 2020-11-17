Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C791C2D0E4
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 20:44:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F123206A5
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 20:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbgKQUoX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Nov 2020 15:44:23 -0500
Received: from sandeen.net ([63.231.237.45]:39454 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728955AbgKQUoW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Nov 2020 15:44:22 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 25C642420
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 14:43:56 -0600 (CST)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to effdc364
Message-ID: <a46dcad0-5c50-2d09-1bfc-a32cf59d9991@sandeen.net>
Date:   Tue, 17 Nov 2020 14:44:20 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="99EdLq1LzTPALRh6AzihOAGt3pGUQFl2F"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--99EdLq1LzTPALRh6AzihOAGt3pGUQFl2F
Content-Type: multipart/mixed; boundary="pEeo1O9fF5pOpzXTnpTs9jH002zVd5ciP";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <a46dcad0-5c50-2d09-1bfc-a32cf59d9991@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to effdc364

--pEeo1O9fF5pOpzXTnpTs9jH002zVd5ciP
Content-Type: multipart/mixed;
 boundary="------------A79FDAF7216D44D1D7164B01"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------A79FDAF7216D44D1D7164B01
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This is just the libxfs-5.10 sync part, plus a couple prep patches
from Darrick (thanks!).  This /omits/ the new features enablement in the
disk format, because userspace bits aren't pushed yet.

You may not want to rebase on this just yet, I have a whole stack of
work (mostly from Darrick, thanks!) to make xfsprogs handle the new
features, and I will get that pushed out shortly (1-2 days?).  After
the next push may be the right time to remind me of anything that's
missing.

The new head of the master for-next is commit:

effdc364 (HEAD -> for-next, tag: v5.10.0-rc0, origin/libxfs-5.10-sync, ko=
rg/libxfs-5.10-sync, korg/for-next) xfsprogs: Release v5.10.0-rc0

New Commits:

Carlos Maiolino (5):
      [8a21dbae] xfs: remove kmem_realloc()
      [cc3650f7] xfs: remove typedef xfs_attr_sf_entry_t
      [2fd09353] xfs: Remove typedef xfs_attr_shortform_t
      [7ed1fb76] xfs: Use variable-size array for nameval in xfs_attr_sf_=
entry
      [24b24fad] xfs: Convert xfs_attr_sf macros to inline functions

Christoph Hellwig (3):
      [29dcd957] xfs: move the buffer retry logic to xfs_buf.c
      [bcd3d2e3] xfs: remove xlog_recover_iodone
      [37e6f885] xfs: simplify xfs_trans_getsb

Darrick J. Wong (29):
      [ec24f6fa] libxfs: create a real struct timespec64
      [c0e58015] libxfs: refactor NSEC_PER_SEC
      [177c81e2] xfs: store inode btree block counts in AGI header
      [eb2c6897] xfs: use the finobt block counts to speed up mount times=

      [729f5739] xfs: support inode btree blockcounts in online repair
      [18e3b8c2] xfs: explicitly define inode timestamp range
      [94c5482a] xfs: refactor quota expiration timer modification
      [abc0f205] xfs: refactor default quota grace period setting code
      [68879320] xfs: refactor quota timestamp coding
      [acaa8149] xfs: move xfs_log_dinode_to_disk to the log recovery cod=
e
      [a252aadf] xfs: redefine xfs_timestamp_t
      [fc3e21db] xfs: redefine xfs_ictimestamp_t
      [e7e3beb9] xfs: widen ondisk inode timestamps to deal with y2038+
      [06963ef0] xfs: widen ondisk quota expiration timestamps to handle =
y2038+
      [d5fe08a6] xfs: don't free rt blocks when we're doing a REMAP bunma=
pi call
      [953cc24b] xfs: log new intent items created as part of finishing r=
ecovered intent items
      [171bead5] xfs: avoid shared rmap operations for attr fork extents
      [84347143] xfs: remove xfs_defer_reset
      [b1d41c43] xfs: proper replay of deferred ops queued during log rec=
overy
      [75d8bf7e] xfs: xfs_defer_capture should absorb remaining block res=
ervations
      [bb6667dc] xfs: xfs_defer_capture should absorb remaining transacti=
on reservation
      [50edfee5] xfs: fix an incore inode UAF in xfs_bui_recover
      [8c7a833f] xfs: change the order in which child and parent defer op=
s are finished
      [1826a6b0] xfs: periodically relog deferred intent items
      [e49ec9ed] xfs: only relog deferred intent items if free space in t=
he log gets low
      [3dc1d41a] xfs: fix high key handling in the rt allocator's query_r=
ange function
      [fc46ff14] xfs: set xefi_discard when creating a deferred agfl free=
 log intent item
      [4d1b7499] xfs: fix flags argument to rmap lookup when converting s=
hared file rmaps
      [a700c789] xfs: fix rmap key and record comparison functions

Eric Sandeen (1):
      [effdc364] xfsprogs: Release v5.10.0-rc0

Kaixu Xia (4):
      [8282a81f] xfs: use the existing type definition for di_projid
      [2f4c11d4] xfs: fix some comments
      [02408cf0] xfs: remove the redundant crc feature check in xfs_attr3=
_rmt_verify
      [1c2b7ed1] xfs: code cleanup in xfs_attr_leaf_entsize_{remote,local=
}


Code Diffstat:

 VERSION                    |   4 +-
 configure.ac               |   2 +-
 db/attrshort.c             |  88 ++++++++---------
 db/check.c                 |  22 ++---
 db/field.c                 |   2 +-
 db/inode.c                 |  14 +--
 db/metadump.c              |  18 ++--
 debian/changelog           |   6 ++
 doc/CHANGES                |   3 +
 include/kmem.h             |   2 +-
 include/libxfs.h           |   1 -
 include/platform_defs.h.in |  32 +++++++
 include/xfs_fs_compat.h    |  12 +++
 include/xfs_inode.h        |  33 ++++---
 include/xfs_mount.h        |   4 +
 include/xfs_trace.h        |   2 +
 include/xfs_trans.h        |  33 ++++++-
 libxfs/kmem.c              |   2 +-
 libxfs/libxfs_api_defs.h   |   1 +
 libxfs/libxfs_priv.h       |   2 -
 libxfs/rdwr.c              |  11 ++-
 libxfs/trans.c             |   6 +-
 libxfs/util.c              |   7 +-
 libxfs/xfs_ag.c            |   5 +
 libxfs/xfs_alloc.c         |   1 +
 libxfs/xfs_attr.c          |  14 ++-
 libxfs/xfs_attr_leaf.c     |  43 +++++----
 libxfs/xfs_attr_remote.c   |   2 -
 libxfs/xfs_attr_sf.h       |  29 ++++--
 libxfs/xfs_bmap.c          |  19 ++--
 libxfs/xfs_bmap.h          |   2 +-
 libxfs/xfs_da_format.h     |  24 ++---
 libxfs/xfs_defer.c         | 230 +++++++++++++++++++++++++++++++++++++++=
+-----
 libxfs/xfs_defer.h         |  37 ++++++++
 libxfs/xfs_dquot_buf.c     |  35 +++++++
 libxfs/xfs_format.h        | 205 +++++++++++++++++++++++++++++++++++++++=
-
 libxfs/xfs_fs.h            |   1 +
 libxfs/xfs_ialloc.c        |   5 +
 libxfs/xfs_ialloc_btree.c  |  65 ++++++++++++-
 libxfs/xfs_iext_tree.c     |   2 +-
 libxfs/xfs_inode_buf.c     | 130 ++++++++++++-------------
 libxfs/xfs_inode_buf.h     |  17 +++-
 libxfs/xfs_inode_fork.c    |   8 +-
 libxfs/xfs_log_format.h    |   7 +-
 libxfs/xfs_quota_defs.h    |   8 +-
 libxfs/xfs_rmap.c          |  29 ++++--
 libxfs/xfs_rmap_btree.c    |  16 ++--
 libxfs/xfs_rtbitmap.c      |  11 +--
 libxfs/xfs_sb.c            |   6 +-
 libxfs/xfs_shared.h        |   3 +
 libxfs/xfs_trans_inode.c   |  17 +++-
 libxlog/xfs_log_recover.c  |   2 +-
 logprint/log_misc.c        |  16 +++-
 logprint/log_print_all.c   |   6 +-
 logprint/logprint.h        |   1 +
 repair/attr_repair.c       |  36 +++----
 repair/dinode.c            |  25 ++---
 scrub/common.c             |   2 -
 scrub/progress.c           |   1 -
 59 files changed, 1031 insertions(+), 336 deletions(-)

--------------A79FDAF7216D44D1D7164B01
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

--------------A79FDAF7216D44D1D7164B01--

--pEeo1O9fF5pOpzXTnpTs9jH002zVd5ciP--

--99EdLq1LzTPALRh6AzihOAGt3pGUQFl2F
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl+0NiQFAwAAAAAACgkQIK4WkuE93uDg
DQ/8Dku43DsZtj2vtfXA/tDh6S8V/57/0inD1Tj6kGN1TOOJHx8mPxfHhVtgQahHEUzNheP2P5vo
YzNmkpxu9Y37gcU2baEt2E3vxSkjVTiXMTDFjFhpzUmoCgC6Lht7gaKQXbMFBf0H1mlhb4fSKXkI
Hio9mGplsGQ1iI0CaPsphs0Jha67V1yrHKrglf8I7wW6Ask/nEKa/k6FIGQv41kr3mwpI2mD8j9n
cFYmLDq2m6PWHa1gg0Ajip1KQmCVs1SFugnePh+eDbT1Z0toDFqxowGcK2u20NdvOpgtnVLvByuH
iaQZv840qfRFGcEZAGt7P6gTwO0qh36BHzCtsh/KP5EE2pIGBiE6sen8wE26B5yZxJCVMib7GxYM
12fZb1zoImURWhznn+ap9xwZ0UEA/lsscQ8//i1+x61b6qE6Jdg9oOpyrzsjicHWE+pwIlqLHlBm
D3pK39iZlrachMwk94FiuDkTnS86p/kh/M+W39SskUcV4lIagwZe4XdxuHklUw3iiL1iYGf0k6X4
D6pDbXfSMmP2/jIsjFz0ebUOQwWpd713MKp8ez838PbY0qcTIA+NaY9BDUdL5a+TjZDWRgmk9guq
/KOwwPgDmq3m2B2/C7xAogNAQN912odZAdZvzGrL9X8d36MGZSNnwlScSutaEsj2xz/s8eiPopnS
ouA=
=8fU/
-----END PGP SIGNATURE-----

--99EdLq1LzTPALRh6AzihOAGt3pGUQFl2F--
