Return-Path: <SRS0=LlZ6=BV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61186C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 00:36:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DD812075D
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 00:36:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgHKAg5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Aug 2020 20:36:57 -0400
Received: from sandeen.net ([63.231.237.45]:48302 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727014AbgHKAg4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Aug 2020 20:36:56 -0400
Received: from [10.0.0.11] (liberator [10.0.0.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 44D1315B01
        for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2020 19:36:31 -0500 (CDT)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 54b4eee7
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <3f9eaf33-0a12-7911-b402-f289d894df36@sandeen.net>
Date:   Mon, 10 Aug 2020 19:36:51 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3Mz9y7en3SZEKZdDb3gopXIVrC3eJSZWt"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3Mz9y7en3SZEKZdDb3gopXIVrC3eJSZWt
Content-Type: multipart/mixed; boundary="WSjPWvh5U0m5WwO7HQuA1bbCWezFEhzP0"

--WSjPWvh5U0m5WwO7HQuA1bbCWezFEhzP0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v5.8.0-rc0.

This is mostly the libxfs sync plus a couple others prior.

(Huge thanks to djwong & hch for their work on the libxfs sync which
makes this job so much easier.)

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

54b4eee7 (HEAD -> guilt/libxfs-5.8-sync, tag: v5.8.0-rc0, korg/libxfs-5.8=
-sync, korg/for-next, refs/patches/libxfs-5.8-sync/5.8-rc0) xfsprogs: Rel=
ease v5.8.0-rc0

New Commits:

Brian Foster (8):
      [ba7dd41b] repair: set the in-core inode parent in phase 3
      [1b0bfeb5] repair: don't double check dir2 sf parent in phase 4
      [993ca3ee] repair: use fs rootino for dummy parent value instead of=
 zero
      [2703aa2c] repair: remove custom dir2 sf fork verifier from phase6
      [820c6548] xfs: remove unnecessary shutdown check from xfs_iflush()=

      [3acdd264] xfs: random buffer write failure errortag
      [0cd4b54a] xfs: remove unused iget_flags param from xfs_imap_to_bp(=
)
      [5779d997] xfs: don't fail verifier on empty attr3 leaf block

Christoph Hellwig (25):
      [ed8d09e1] xfs: remove the xfs_inode_log_item_t typedef
      [fa8a37b6] xfs: factor out a xfs_defer_create_intent helper
      [8d81fcd0] xfs: merge the ->log_item defer op into ->create_intent
      [74a7f5fa] xfs: merge the ->diff_items defer op into ->create_inten=
t
      [18d0d657] xfs: turn dfp_intent into a xfs_log_item
      [ed0873e6] xfs: refactor xfs_defer_finish_noroll
      [95e01274] xfs: turn dfp_done into a xfs_log_item
      [4371b480] xfs: use a xfs_btree_cur for the ->finish_cleanup state
      [8d431a3b] xfs: spell out the parameter name for ->cancel_item
      [f5d22700] xfs: xfs_bmapi_read doesn't take a fork id as the last a=
rgument
      [3eb685ae] xfs: call xfs_iformat_fork from xfs_inode_from_disk
      [07973a77] xfs: split xfs_iformat_fork
      [f47e002f] xfs: handle unallocated inodes in xfs_inode_from_disk
      [d1eeae6b] xfs: call xfs_dinode_verify from xfs_inode_from_disk
      [f6e757aa] xfs: don't reset i_delayed_blks in xfs_iread
      [89522615] xfs: remove xfs_iread
      [1fecabf9] xfs: remove xfs_ifork_ops
      [318d12fd] xfs: refactor xfs_inode_verify_forks
      [0815f7ab] xfs: improve local fork verification
      [00773e64] xfs: remove the special COW fork handling in xfs_bmapi_r=
ead
      [212be827] xfs: remove the NULL fork handling in xfs_bmapi_read
      [8c6cccd7] xfs: remove the XFS_DFORK_Q macro
      [87c472b7] xfs: move the per-fork nextents fields into struct xfs_i=
fork
      [d967a68d] xfs: move the fork format fields into struct xfs_ifork
      [a87a40a2] xfs: cleanup xfs_idestroy_fork

Darrick J. Wong (11):
      [6526f30e] xfs_db: stop misusing an onstack inode
      [3d16b59a] xfs: convert xfs_log_recover_item_t to struct xfs_log_re=
cover_item
      [a172b39c] xfs: refactor log recovery item sorting into a generic d=
ispatch structure
      [76887ef8] xfs: refactor log recovery item dispatch for pass2 readh=
ead functions
      [bc9c7143] xfs: refactor log recovery item dispatch for pass1 commi=
t functions
      [ecb32931] xfs: refactor log recovery buffer item dispatch for pass=
2 commit functions
      [90301e35] xfs: refactor releasing finished intents during log reco=
very
      [6fe2ec55] xfs: move log recovery buffer cancellation code to xfs_b=
uf_item_recover.c
      [e30de1a1] xfs: use ordered buffers to initialize dquot buffers dur=
ing quotacheck
      [edc9bb69] xfs: force writes to delalloc regions to unwritten
      [db8c0218] xfs: more lockdep whackamole with kmem_alloc*

Eric Sandeen (2):
      [e90330f9] xfs: always return -ENOSPC on project quota reservation =
failure
      [54b4eee7] xfsprogs: Release v5.8.0-rc0

Gustavo A. R. Silva (1):
      [1f3fe204] xfs: Replace zero-length array with flexible-array

Kaixu Xia (1):
      [faa7f9b2] xfs: fix the warning message in xfs_validate_sb_common()=


Nishad Kamdar (1):
      [7acf15bf] xfs: Use the correct style for SPDX License Identifier


Code Diffstat:

 VERSION                     |   4 +-
 configure.ac                |   2 +-
 db/attrset.c                |   6 +-
 db/block.c                  |  21 +--
 db/bmroot.c                 |  10 +-
 db/check.c                  | 102 ++++++++-------
 db/frag.c                   |   2 +-
 db/inode.c                  |  10 +-
 debian/changelog            |   6 +
 doc/CHANGES                 |   5 +
 include/kmem.h              |   1 +
 include/libxlog.h           |   2 +-
 include/xfs_inode.h         |   5 +-
 include/xfs_log_recover.h   |   4 +-
 include/xfs_trans.h         |   5 +-
 io/inject.c                 |   1 +
 libxfs/defer_item.c         | 162 ++++++++---------------
 libxfs/libxfs_api_defs.h    |   1 -
 libxfs/logitem.c            |   6 +-
 libxfs/rdwr.c               |  82 +++++-------
 libxfs/trans.c              |  20 +--
 libxfs/util.c               |  49 +++----
 libxfs/xfs_ag_resv.h        |   2 +-
 libxfs/xfs_alloc.h          |   2 +-
 libxfs/xfs_alloc_btree.h    |   2 +-
 libxfs/xfs_attr.c           |  16 +--
 libxfs/xfs_attr.h           |   2 +-
 libxfs/xfs_attr_leaf.c      |  59 ++++-----
 libxfs/xfs_attr_leaf.h      |   2 +-
 libxfs/xfs_attr_remote.h    |   2 +-
 libxfs/xfs_attr_sf.h        |   2 +-
 libxfs/xfs_bit.h            |   2 +-
 libxfs/xfs_bmap.c           | 310 +++++++++++++++++++-------------------=
-----
 libxfs/xfs_bmap.h           |   2 +-
 libxfs/xfs_bmap_btree.c     |   5 +-
 libxfs/xfs_bmap_btree.h     |   2 +-
 libxfs/xfs_btree.h          |   2 +-
 libxfs/xfs_da_btree.h       |   2 +-
 libxfs/xfs_da_format.h      |   2 +-
 libxfs/xfs_defer.c          | 162 +++++++++++------------
 libxfs/xfs_defer.h          |  26 ++--
 libxfs/xfs_dir2.c           |   8 +-
 libxfs/xfs_dir2.h           |   2 +-
 libxfs/xfs_dir2_block.c     |   2 +-
 libxfs/xfs_dir2_priv.h      |   2 +-
 libxfs/xfs_dir2_sf.c        |  13 +-
 libxfs/xfs_errortag.h       |   6 +-
 libxfs/xfs_format.h         |   9 +-
 libxfs/xfs_fs.h             |   2 +-
 libxfs/xfs_health.h         |   2 +-
 libxfs/xfs_inode_buf.c      | 186 +++++++-------------------
 libxfs/xfs_inode_buf.h      |  10 +-
 libxfs/xfs_inode_fork.c     | 320 ++++++++++++++++++++++----------------=
-------
 libxfs/xfs_inode_fork.h     |  68 ++++------
 libxfs/xfs_quota_defs.h     |   1 -
 libxfs/xfs_rtbitmap.c       |   2 +-
 libxfs/xfs_sb.c             |   2 +-
 libxfs/xfs_symlink_remote.c |  16 +--
 libxfs/xfs_trans_inode.c    |   2 +-
 libxlog/xfs_log_recover.c   |  18 +--
 logprint/log_print_all.c    |  14 +-
 logprint/log_redo.c         |   4 +-
 logprint/logprint.h         |   4 +-
 mkfs/proto.c                |   2 +-
 repair/dino_chunks.c        |   9 +-
 repair/dinode.c             |   2 +-
 repair/dir2.c               |  14 +-
 repair/phase6.c             | 115 +++++-----------
 repair/phase7.c             |   2 +-
 repair/quotacheck.c         |   4 +-
 repair/xfs_repair.c         |   3 +-
 71 files changed, 842 insertions(+), 1112 deletions(-)


--WSjPWvh5U0m5WwO7HQuA1bbCWezFEhzP0--

--3Mz9y7en3SZEKZdDb3gopXIVrC3eJSZWt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl8x6CYACgkQIK4WkuE9
3uCdsA//UhMoamUlOKiC5TK0d0e+DfVmgttFMxk1n7lS88agABlOI2sFohIKXY4X
6XE3nvH/6Ag/UCQwgkZ/IrV6ENHs8uARUzT+cqF/5xNdhMr3mhLOAv89DrB7Civz
lQSgj6U5RNAnW6RFHRyj4R+T0gi5svhnaDS+UYoxiK+uu6l/yK1X3Kz2e0GZMy/h
niuUCer0dPKFm91tyFcJqCzeN46ou52O3I3YAZZAqVj/eYnvQkPXcYr5BMN7TCQr
BB7NC8JXp4vi9X64L7HMBS71X7Kch24yKcUVUDNEP1hrye5SskpTwjihxUtgj1A4
mS0VWErLBTZv5+dFHzwjAcyC46UemI29M6sDtuNVulCtfcNgu+fXVoU916cplWP7
6h4aHIt9opa/22W9mT5NA5k4x10jHIeAjskUn6f//A44BPpsBOD2HfBlI37nUw3p
JWnNYaeFKhIGIqhwhl1NzWDdYl0xpRLN+ISOKUPUoBTk9fbH1PKKrz62HOpJuUKz
/R6nJcJZcWYPqXe7iQKbblIHC6228riq7xt0KwNICAbfrkpa/Uh84+qiNFvEIQ+2
iL0VeXtdDMTDmivMgC+Nd2MrumHRCC43kLMh3XfYIwTLeDhkWaSUBWONS/ibxpJI
D2QM3BO23maEmTwb9R4qgrYHs/6aiWZSsMeH5In4ryGWC1dkpME=
=mpoX
-----END PGP SIGNATURE-----

--3Mz9y7en3SZEKZdDb3gopXIVrC3eJSZWt--
