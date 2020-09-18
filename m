Return-Path: <SRS0=2mLC=C3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D7A7C43464
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 18:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5292022208
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 18:40:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgIRSkS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Sep 2020 14:40:18 -0400
Received: from sandeen.net ([63.231.237.45]:50008 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbgIRSkR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 Sep 2020 14:40:17 -0400
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2020 14:40:17 EDT
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id A9A93EF1
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2020 13:29:35 -0500 (CDT)
From:   Eric Sandeen <sandeen@sandeen.net>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfsprogs for-next updated to 06267c3e
Message-ID: <30d7436e-b114-c123-fc6f-1cafee88c240@sandeen.net>
Date:   Fri, 18 Sep 2020 13:30:22 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="22cFRBgjJdQzHAUQwq1X8JiaHVfFFN3OG"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--22cFRBgjJdQzHAUQwq1X8JiaHVfFFN3OG
Content-Type: multipart/mixed; boundary="QrY53LrCoMAPeanJFgAawcCiPTz9xGNxs";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <30d7436e-b114-c123-fc6f-1cafee88c240@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 06267c3e

--QrY53LrCoMAPeanJFgAawcCiPTz9xGNxs
Content-Type: multipart/mixed;
 boundary="------------E1075CC6DBE0B7DF7456EECB"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------E1075CC6DBE0B7DF7456EECB
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

It's Friday, so of course the for-next branch of the xfsprogs repository =
at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v5.9.0-rc0

This is just the libxfs/ sync bits.  Now onto the real content.

The new head of the for-next branch is commit:

06267c3e (HEAD -> guilt/libxfs-5.9-sync, tag: v5.9.0-rc0, korg/libxfs-5.9=
-sync, korg/for-next, refs/patches/libxfs-5.9-sync/5.9.0-rc0) xfsprogs: R=
elease v5.9.0-rc0

New Commits:

Allison Collins (22):
      [11b4b23d] xfs: Add xfs_has_attr and subroutines
      [36b8f99d] xfs: Check for -ENOATTR or -EEXIST
      [91986fc1] xfs: Factor out new helper functions xfs_attr_rmtval_set=

      [7efadb7a] xfs: Pull up trans handling in xfs_attr3_leaf_flipflags
      [e37811b3] xfs: Split apart xfs_attr_leaf_addname
      [32221b28] xfs: Refactor xfs_attr_try_sf_addname
      [4345a0a1] xfs: Pull up trans roll from xfs_attr3_leaf_setflag
      [5a2edbba] xfs: Factor out xfs_attr_rmtval_invalidate
      [e936ed7a] xfs: Pull up trans roll in xfs_attr3_leaf_clearflag
      [978b6ada] xfs: Refactor xfs_attr_rmtval_remove
      [0a98254e] xfs: Pull up xfs_attr_rmtval_invalidate
      [e6133b6f] xfs: Add helper function xfs_attr_node_shrink
      [ebdc3357] xfs: Remove unneeded xfs_trans_roll_inode calls
      [9086487f] xfs: Remove xfs_trans_roll in xfs_attr_node_removename
      [fb68bf93] xfs: Add helpers xfs_attr_is_shortform and xfs_attr_set_=
shortform
      [1a27e045] xfs: Add helper function xfs_attr_leaf_mark_incomplete
      [0a194afd] xfs: Add remote block helper functions
      [05c54abe] xfs: Add helper function xfs_attr_node_removename_setup
      [acefd66b] xfs: Add helper function xfs_attr_node_removename_rmt
      [aff8f72d] xfs: Simplify xfs_attr_leaf_addname
      [1df775fa] xfs: Simplify xfs_attr_node_addname
      [484c2bf6] xfs: Lift -ENOSPC handler from xfs_attr_leaf_addname

Brian Foster (3):
      [8f67a46c] xfs: preserve rmapbt swapext block reservation from free=
d blocks
      [625c12fb] xfs: fix inode allocation block res calculation preceden=
ce
      [d6e8deb1] xfs: fix off-by-one in inode alloc block reservation cal=
culation

Carlos Maiolino (3):
      [d7faa18a] xfs: Remove kmem_zone_alloc() usage
      [17e074de] xfs: Remove kmem_zone_zalloc() usage
      [2db3075b] xfs: Refactor xfs_da_state_alloc() helper

Darrick J. Wong (13):
      [f8b581d6] libxfs: actually make buffers track the per-ag structure=
s
      [23571db9] xfs: rename xfs_bmap_is_real_extent to is_written_extent=

      [9ff3a1a7] xfs: redesign the reflink remap loop to fix blkres deple=
tion crash
      [a579493d] xfs: rename dquot incore state flags
      [8330c89c] xfs: make XFS_DQUOT_CLUSTER_SIZE_FSB part of the ondisk =
format
      [12907581] xfs: remove qcore from incore dquots
      [bce109af] xfs: drop the type parameter from xfs_dquot_verify
      [8e4128a7] xfs: rename XFS_DQ_{USER,GROUP,PROJ} to XFS_DQTYPE_*
      [4a4b0690] xfs: create xfs_dqtype_t to represent quota types
      [28518f77] xfs: improve ondisk dquot flags checking
      [cde0e6a6] xfs: rename the ondisk dquot d_flags to d_type
      [b28d8768] xfs: initialize the shortform attr header padding entry
      [d1f29689] xfs: fix xfs_bmap_validate_extent_raw when checking attr=
 fork of rt files

Dave Chinner (5):
      [d5c6e6a1] xfs: Don't allow logging of XFS_ISTALE inodes
      [847ab4e0] xfs: add an inode item lock
      [2b8ea826] xfs: pin inode backing buffer to the inode log item
      [2efa10f3] xfs: attach inodes to the cluster buffer when dirtied
      [1da5326f] xfs: remove xfs_inobp_check()

Eric Sandeen (2):
      [be2f3d39] xfs: fix boundary test in xfs_attr_shortform_verify
      [06267c3e] xfsprogs: Release v5.9.0-rc0

Gao Xiang (1):
      [10c0a390] xfs: get rid of unnecessary xfs_perag_{get,put} pairs

Jan Kara (1):
      [cdef05dd] writeback: Drop I_DIRTY_TIME_EXPIRE

Keyur Patel (1):
      [c2f0ae02] xfs: Couple of typo fixes in comments

Randy Dunlap (2):
      [98c76f9e] xfs: xfs_btree_staging.h: delete duplicated words
      [809c2c46] xfs: delete duplicated words + other fixes


Code Diffstat:

 VERSION                     |   4 +-
 configure.ac                |   2 +-
 db/check.c                  |  21 +-
 db/dquot.c                  |   2 +-
 debian/changelog            |   6 +
 doc/CHANGES                 |   4 +
 include/kmem.h              |  12 +-
 include/xfs_trans.h         |   2 +
 libxfs/kmem.c               |   8 +-
 libxfs/libxfs_io.h          |   9 +-
 libxfs/libxfs_priv.h        |   5 +
 libxfs/logitem.c            |   4 +-
 libxfs/rdwr.c               |  20 +-
 libxfs/trans.c              |  34 +-
 libxfs/util.c               |   1 +
 libxfs/xfs_ag.c             |   4 +-
 libxfs/xfs_ag_resv.h        |  12 -
 libxfs/xfs_alloc.c          |  25 +-
 libxfs/xfs_alloc_btree.c    |  10 +-
 libxfs/xfs_attr.c           | 865 +++++++++++++++++++++++++++-----------=
------
 libxfs/xfs_attr.h           |   1 +
 libxfs/xfs_attr_leaf.c      | 125 ++++---
 libxfs/xfs_attr_leaf.h      |   3 +
 libxfs/xfs_attr_remote.c    | 216 +++++++----
 libxfs/xfs_attr_remote.h    |   3 +-
 libxfs/xfs_bmap.c           |  10 +-
 libxfs/xfs_bmap.h           |  15 +-
 libxfs/xfs_bmap_btree.c     |   2 +-
 libxfs/xfs_btree_staging.h  |   6 +-
 libxfs/xfs_da_btree.c       |  12 +-
 libxfs/xfs_da_btree.h       |   2 +-
 libxfs/xfs_dir2_node.c      |  17 +-
 libxfs/xfs_dquot_buf.c      |  25 +-
 libxfs/xfs_format.h         |  36 +-
 libxfs/xfs_ialloc.c         |  32 +-
 libxfs/xfs_ialloc_btree.c   |   2 +-
 libxfs/xfs_inode_buf.c      |  33 +-
 libxfs/xfs_inode_buf.h      |   6 -
 libxfs/xfs_inode_fork.c     |   6 +-
 libxfs/xfs_quota_defs.h     |  31 +-
 libxfs/xfs_refcount_btree.c |   6 +-
 libxfs/xfs_rmap_btree.c     |  11 +-
 libxfs/xfs_rtbitmap.c       |   2 +-
 libxfs/xfs_sb.c             |   2 +-
 libxfs/xfs_shared.h         |   1 +
 libxfs/xfs_trans_inode.c    | 114 ++++--
 libxfs/xfs_trans_space.h    |   4 +-
 logprint/log_misc.c         |   4 +-
 repair/dinode.c             |  12 +-
 repair/phase7.c             |   6 +-
 repair/quotacheck.c         |  42 +--
 repair/quotacheck.h         |   2 +-
 52 files changed, 1099 insertions(+), 740 deletions(-)

--------------E1075CC6DBE0B7DF7456EECB
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

--------------E1075CC6DBE0B7DF7456EECB--

--QrY53LrCoMAPeanJFgAawcCiPTz9xGNxs--

--22cFRBgjJdQzHAUQwq1X8JiaHVfFFN3OG
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl9k/L8FAwAAAAAACgkQIK4WkuE93uBn
NA/+MDjL5rJPNGgUVT+L/zcEZcZv0HJcNBW3QwGq6gNK0EqFeJrqkT84VP3p2+vrn8C2dyCgOVzL
J1xY9YlbEcHmGNjG4SCME0cRooMo+6dwGGlVM6INGVuf81csocPPhpiT+WnGLtV2MUwU8aKm5lpO
1LqWYkx8VAh8lu1cj2p3va9UaQb6lm3AWINrwC1BuBN4ska4JXSh3mFRd7daqtZdUNmDr9TApKLa
UFH/drESa/2ExR7pVRraJz5EeIgR6ZBrHNOKf10knYyvwoihT0qCoWCqzTr7XrAdUEccFkL6XOHB
HOIFa7rv3ph84DyDuujeQ2+1c9NDqyRJD+SQrKyqZKxMz0eOHSCdc9M+u7USGGzP98VQcBtHmLHa
/BR47E8/pX9CS1tYEUXmq2quE3E+MWIyMghuaakAwjMcM+zS6gQ2QuRO1nQpteTTcxHWOm4PCcWW
mNMAZ/+hRBRI0X/1wxsZvYWz3LlDAr1YQobq9bx1wr1MGxzSXM1TqTI7UGXORSDh8mXemEtrA5VU
xo1nwwzQNlVCgQSaRvjtBpNTNgUC5n2xZF9dlPX4rPTyUjHW2quk1vLYGLxVrp0QlrbhGhObSTCa
ORCqFg7VkSRnjducSZgrdsmX6mmlt3ORc0+CfYIlYKXePnd8hDCvG5nV6T7Mx/qPXB2ttSMIR9Ai
bWs=
=pWcf
-----END PGP SIGNATURE-----

--22cFRBgjJdQzHAUQwq1X8JiaHVfFFN3OG--
