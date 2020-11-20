Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5AF8C2D0E4
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Nov 2020 22:16:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 822122468D
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Nov 2020 22:16:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728634AbgKTWQQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Nov 2020 17:16:16 -0500
Received: from sandeen.net ([63.231.237.45]:54648 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728348AbgKTWQP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Nov 2020 17:16:15 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id A6631335044
        for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2020 16:15:44 -0600 (CST)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 49c49fa6
Message-ID: <dc64f31d-ce83-fa41-f96c-8bad9bfbd640@sandeen.net>
Date:   Fri, 20 Nov 2020 16:16:13 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FtlMrnVR6X4SlYGQRHTRAP9h9dC4T9nHR"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FtlMrnVR6X4SlYGQRHTRAP9h9dC4T9nHR
Content-Type: multipart/mixed; boundary="SBYjGPEJpKm7pMfmw04xA9loi3VAwQCKe";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <dc64f31d-ce83-fa41-f96c-8bad9bfbd640@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 49c49fa6

--SBYjGPEJpKm7pMfmw04xA9loi3VAwQCKe
Content-Type: multipart/mixed;
 boundary="------------9FB198F483EDB46EA26F7145"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------9FB198F483EDB46EA26F7145
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

** One important note: xfsprogs now /requires/ libinih to build; this
supports the new config file feature.  If this is really onerous we
could possibly make it configurable, but for now it is required. **

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

(Now really would be a fine time for you to remind me of anything
that may have been missed, though I will take another pass through
the outstanding patches on my own)

Thanks,
-Eric

The new head of the for-next branch is commit:

49c49fa6 (HEAD -> for-next, korg/for-next, refs/patches/for-next/xfsprogs=
__get_rid_of_ancient_btree_tracing_fragments.patch) xfsprogs: get rid of =
ancient btree tracing fragments

New Commits:

Darrick J. Wong (25):
      [d83f65de] xfs: revert "xfs: fix rmap key and record comparison fun=
ctions"
      [13b89172] xfs_db: support displaying inode btree block counts in A=
GI header
      [62c713cb] xfs_repair: check inode btree block counters in AGI
      [086250dc] xfs_repair: regenerate inode btree block counters in AGI=

      [46da7033] xfs: enable new inode btree counters feature
      [9eb0d6eb] mkfs: enable the inode btree counter feature
      [e749bfaf] libfrog: define LIBFROG_BULKSTAT_CHUNKSIZE to remove dep=
endence on XFS_INODES_PER_CHUNK
      [bf6d4cf9] libfrog: convert cvttime to return time64_t
      [219285ad] xfs_quota: convert time_to_string to use time64_t
      [30042222] xfs_db: refactor timestamp printing
      [a9a32fcb] xfs_db: refactor quota timer printing
      [0160c149] libfrog: list the bigtime feature when reporting geometr=
y
      [344f38a9] xfs_db: report bigtime format timestamps
      [48937185] xfs_db: support printing time limits
      [f3eb31d9] xfs_quota: support editing and reporting quotas with big=
time
      [37c7dda1] xfs_repair: support bigtime timestamp checking
      [cac80700] xfs: enable big timestamps
      [e9601810] mkfs: format bigtime filesystems
      [9c7e941b] mkfs: allow users to specify rtinherit=3D0
      [dc2cfca7] mkfs: don't pass on extent size inherit flags when exten=
t size is zero
      [0b78ac05] xfs: remove unnecessary parameter from scrub_scan_estima=
te_blocks
      [ce2c8e56] xfs_db: report ranges of invalid rt blocks
      [02acb602] xfs_repair: skip the rmap and refcount btree checks when=
 the levels are garbage
      [f0e7f9c2] xfs_repair: correctly detect partially written extents
      [c2c7b124] xfs_repair: directly compare refcount records

Dave Chinner (9):
      [50949a0f] build: add support for libinih for mkfs
      [33c62516] mkfs: add initial ini format config file parsing support=

      [9c2b30c8] mkfs: constify various strings
      [ab2eef12] mkfs: hook up suboption parsing to ini files
      [7704be26] mkfs: document config files in mkfs.xfs(8)
      [fc5b8ca3] xfsprogs: remove unused buffer tracing code
      [cacdf172] xfsprogs: remove unused IO_DEBUG functionality
      [ab434d12] libxfs: rename buftarg->dev to btdev
      [49c49fa6] xfsprogs: get rid of ancient btree tracing fragments

Eric Sandeen (2):
      [84b317d9] mkfs: clarify valid "inherit" option values
      [885e3b46] xfs_io: fix up typos in manpage

Jakub Bogusz (1):
      [d36db701] Polish translation update for xfsprogs 5.8.0.


Code Diffstat:

 configure.ac              |     3 +
 db/Makefile               |     2 +-
 db/agi.c                  |     2 +
 db/check.c                |    33 +-
 db/command.c              |     1 +
 db/command.h              |     1 +
 db/dquot.c                |     6 +-
 db/field.c                |    12 +-
 db/field.h                |     1 +
 db/fprint.c               |   140 +-
 db/fprint.h               |     4 +
 db/inode.c                |     9 +-
 db/sb.c                   |     4 +
 db/timelimit.c            |   160 +
 doc/INSTALL               |     5 +
 include/Makefile          |     1 -
 include/builddefs.in      |     1 +
 include/libxfs.h          |     1 -
 include/linux.h           |     2 +-
 include/xfs.h             |     2 +
 include/xfs_btree_trace.h |    87 -
 include/xqm.h             |    20 +-
 libfrog/bulkstat.h        |     4 +
 libfrog/convert.c         |     6 +-
 libfrog/convert.h         |     2 +-
 libfrog/fsgeom.c          |     6 +-
 libxfs/Makefile           |     1 -
 libxfs/init.c             |    14 +-
 libxfs/libxfs_api_defs.h  |     2 +
 libxfs/libxfs_io.h        |    52 +-
 libxfs/logitem.c          |     2 +-
 libxfs/rdwr.c             |   214 +-
 libxfs/xfs_format.h       |     6 +-
 libxfs/xfs_rmap_btree.c   |    16 +-
 m4/package_inih.m4        |    20 +
 man/man8/mkfs.xfs.8       |   161 +-
 man/man8/xfs_db.8         |    23 +
 man/man8/xfs_io.8         |     8 +-
 mkfs/Makefile             |     2 +-
 mkfs/xfs_mkfs.c           |   303 +-
 po/pl.po                  | 20423 ++++++++++++++++++++++++--------------=
------
 quota/edit.c              |    79 +-
 quota/quota.c             |    16 +-
 quota/quota.h             |     9 +-
 quota/report.c            |    16 +-
 quota/util.c              |     5 +-
 repair/dinode.c           |   199 +-
 repair/phase5.c           |     5 +
 repair/prefetch.c         |     2 +-
 repair/quotacheck.c       |    11 +-
 repair/rmap.c             |     4 +-
 repair/scan.c             |    65 +-
 scrub/fscounters.c        |     9 +-
 scrub/fscounters.h        |     2 +-
 scrub/inodes.c            |     5 +-
 scrub/phase6.c            |     7 +-
 scrub/phase7.c            |     5 +-
 57 files changed, 12208 insertions(+), 9993 deletions(-)
 create mode 100644 db/timelimit.c
 delete mode 100644 include/xfs_btree_trace.h
 create mode 100644 m4/package_inih.m4

--------------9FB198F483EDB46EA26F7145
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

--------------9FB198F483EDB46EA26F7145--

--SBYjGPEJpKm7pMfmw04xA9loi3VAwQCKe--

--FtlMrnVR6X4SlYGQRHTRAP9h9dC4T9nHR
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl+4QC0FAwAAAAAACgkQIK4WkuE93uCd
8w/8Cr3h0k7T8JoGz1TrnNFg4/mQtQ2JnQLczpbtJSAMwx8hXu7BScseOJ7BwLF9jJ0EM3R/6qms
7wb35ShY3e8x0Wvq8kd+5Zm/8MUvTacRCw/PIFvgYQcxYyu9Z2ijHJyLqflrutu0IoPzqQ4tEtea
KaZ4ZFfoKMxDVNS6eXanga2XOV2th9/TImE+yLEkNE5VS/WbSG0qbBrCItFTfhFUe6Q24QzB+XSY
5BFEEOOyNkB2Xx4H3IPnAIsIhV7Q4y3mLceLpNpxiCpnyiK6Riq7sCmvuX4xycD5rXE3SEx3BTeY
2Ok+ygXOl1oFywnx92FKCaF1nOa80c5PeLSAx502u/Plobe4AuqCreHuaWC8waj+UgJt2cA4vVzs
pOPh8dlek2avi07+/dWQC23hYuQYmtMyBohF57L2oAF2yZQOB8+uATSc7F/seQWKzG16N1jDQYCy
Nh2IGT0E5KE63hmAlh2QL4/q7KUcpXrwuHO2Rns0+2oU4TCiz3H9nGGSUADWSCwKYl/xediBpwDa
SszTg404yFfrIrlvCWNuoiModXZe2jpbAeWPuaamJTiqF3I4jC8SoUAm7oj6pYdYNPlFy7aA4FhO
qtt7mu6Za9Zbd/K3zN5c4YaW/FGO5H78S16XQMNqzfAm52xmuWUAQc4HY2r0Yzi6E8jKoOwb2EdO
jFU=
=+8mp
-----END PGP SIGNATURE-----

--FtlMrnVR6X4SlYGQRHTRAP9h9dC4T9nHR--
