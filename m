Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1016DC38A24
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 18:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6BF42145D
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 18:18:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgEGSSQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 14:18:16 -0400
Received: from sandeen.net ([63.231.237.45]:53442 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgEGSSQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 May 2020 14:18:16 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 5E18A1F1E
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 13:18:07 -0500 (CDT)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 08814ce4
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <722facf2-1404-f49a-9682-61cdccdb1d88@sandeen.net>
Date:   Thu, 7 May 2020 13:18:13 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XqXtx4u1GBqjpyhb22ewj4pnFfaXTDxPs"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XqXtx4u1GBqjpyhb22ewj4pnFfaXTDxPs
Content-Type: multipart/mixed; boundary="bKNMGhrH15wqDHbh798NvyeJ09hy4fVzm"

--bKNMGhrH15wqDHbh798NvyeJ09hy4fVzm
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v5.7.0-rc0.  This is just the
libxfs-5.7 sync for now.  I should name this release
"It takes a village" - thanks again to djwong and this time hch
as well for the effort.

I'll move on to non-libxfs patches now, if the /next/ update doesn't
have your pet patch, please ping me or resend.

The new head of the for-next branch is commit:

a3e93c7c (HEAD -> libxfs-5.7-sync, tag: v5.7.0-rc0, korg/libxfs-5.7-sync,=
 korg/for-next, refs/patches/libxfs-5.7-sync/5.7.0-rc0) xfsprogs: Release=
 v5.7.0-rc0
---

Code Diffstat:

 VERSION                     |   4 +-
 configure.ac                |   2 +-
 copy/xfs_copy.c             |   4 +-
 copy/xfs_copy.h             |   2 +-
 db/agfl.c                   |   6 +-
 db/attrset.c                |  65 ++--
 db/check.c                  |  13 +-
 db/info.c                   |   2 +-
 db/init.c                   |   2 +-
 db/metadump.c               |   7 +-
 debian/changelog            |   6 +
 doc/CHANGES                 |   3 +
 include/xfs.h               |   4 +
 include/xfs_inode.h         |  19 +
 include/xfs_trace.h         |   4 +
 libxfs/Makefile             |   2 +
 libxfs/libxfs_api_defs.h    |   7 +-
 libxfs/libxfs_io.h          |   4 +-
 libxfs/libxfs_priv.h        |  45 ++-
 libxfs/rdwr.c               |  42 +++
 libxfs/util.c               |  30 +-
 libxfs/xfs_ag.c             |  16 +-
 libxfs/xfs_alloc.c          |  99 ++---
 libxfs/xfs_alloc.h          |   9 +
 libxfs/xfs_alloc_btree.c    | 119 ++++--
 libxfs/xfs_alloc_btree.h    |   7 +
 libxfs/xfs_attr.c           | 352 ++++++------------
 libxfs/xfs_attr.h           | 114 ++----
 libxfs/xfs_attr_leaf.c      | 130 +++----
 libxfs/xfs_attr_leaf.h      |   1 -
 libxfs/xfs_attr_remote.c    |   2 +-
 libxfs/xfs_bmap.c           |  88 ++---
 libxfs/xfs_bmap.h           |   3 +-
 libxfs/xfs_bmap_btree.c     |  50 +--
 libxfs/xfs_btree.c          |  93 +++--
 libxfs/xfs_btree.h          |  82 +++--
 libxfs/xfs_btree_staging.c  | 879 ++++++++++++++++++++++++++++++++++++++=
++++++
 libxfs/xfs_btree_staging.h  | 123 +++++++
 libxfs/xfs_da_btree.c       |  17 +-
 libxfs/xfs_da_btree.h       |  11 +-
 libxfs/xfs_da_format.h      |  12 -
 libxfs/xfs_dir2_block.c     |  33 +-
 libxfs/xfs_dir2_data.c      |  32 +-
 libxfs/xfs_dir2_leaf.c      |   2 +-
 libxfs/xfs_dir2_node.c      |  11 +-
 libxfs/xfs_format.h         |  48 ++-
 libxfs/xfs_fs.h             |  32 +-
 libxfs/xfs_ialloc.c         |  35 +-
 libxfs/xfs_ialloc_btree.c   | 104 ++++--
 libxfs/xfs_ialloc_btree.h   |   6 +
 libxfs/xfs_inode_buf.c      |  43 +--
 libxfs/xfs_inode_buf.h      |   5 -
 libxfs/xfs_inode_fork.c     |   2 +-
 libxfs/xfs_inode_fork.h     |   9 +-
 libxfs/xfs_log_format.h     |  10 +-
 libxfs/xfs_refcount.c       | 110 +++---
 libxfs/xfs_refcount_btree.c | 104 ++++--
 libxfs/xfs_refcount_btree.h |   6 +
 libxfs/xfs_rmap.c           | 123 +++----
 libxfs/xfs_rmap_btree.c     |  99 +++--
 libxfs/xfs_rmap_btree.h     |   5 +
 libxfs/xfs_sb.c             |  49 ++-
 libxfs/xfs_trans_resv.c     |   2 +-
 logprint/log_misc.c         |   2 +-
 logprint/log_print_all.c    |   6 +-
 mkfs/xfs_mkfs.c             |  11 +-
 repair/agheader.c           |   2 +-
 repair/dinode.c             |  16 +-
 repair/phase3.c             |   2 +-
 repair/phase5.c             |  15 +-
 repair/phase6.c             |  15 +-
 repair/prefetch.c           |   4 +-
 repair/rmap.c               |   2 +-
 repair/scan.c               |   8 +-
 repair/xfs_repair.c         |   4 +-
 75 files changed, 2363 insertions(+), 1074 deletions(-)
 create mode 100644 libxfs/xfs_btree_staging.c
 create mode 100644 libxfs/xfs_btree_staging.h


--bKNMGhrH15wqDHbh798NvyeJ09hy4fVzm--

--XqXtx4u1GBqjpyhb22ewj4pnFfaXTDxPs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl60UOYACgkQIK4WkuE9
3uC2LhAAlQr/KS+t0aInQOjLAuJVvTzLlRrOt2xepw6XBFId3m+FuTQMqfwILZJ7
CwCIeeMQ1UZwzbZ2/4AHj5y67U1xNK+Rx2PiTx++VYaabum1DwXkuLDanQUPOdqe
vXGekyr62RmRGC8EIw0XHWW52ETpRgcDnA4pMS2zcs5ASZBYoI+YlfJRKCEqDbdm
mK6mF2lMfQUu1se+ARPEAxtUo398dMzltnQhcMlNohE/wVaYL7uHsgcoPaba9aHE
/AfbmpLnBQGMojo3vu9mmhh7kwy++o4oqtua8DwBVsKAmLIJ1wgD/ZgeBnNjq/EN
+C6dVJ+2otjqpR7Y+7pA4etrAkzjoNAdbkrPfuRoOHxLjZPswC9mK5NGiAyTyGSQ
FFI0xYCriMx/6PVHpV/LkdYx18bvT5pThtVIf5eo0DCyMRvKgLDzxHAkwu5FHBNm
dZcFwA09i9a6L62s67OHlsgXWxC6Nye0yg1TraX5cgnxUqaAyoYz8QKJY8XDwULF
WQCbgCGJDhh1uQiIYjvMBxMTZdp3NFu84Mnn98zhXUBzikb+JlkNRfDslliKSvYl
PSh0EEtf8aqNC4/yWOBv3dL6vQzZk/kv1vkefIzR51OftYFSc1WCPRK8Nc0FTecU
GKiUxAnX6puggtRa0XU3TCuU+Vo5sAT27JQUBIVoz/lM54Cd1Ns=
=Ekue
-----END PGP SIGNATURE-----

--XqXtx4u1GBqjpyhb22ewj4pnFfaXTDxPs--
