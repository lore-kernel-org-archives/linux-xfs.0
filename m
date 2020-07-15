Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA266C433E5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 20:12:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A87142065D
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 20:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgGOUMn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 16:12:43 -0400
Received: from sandeen.net ([63.231.237.45]:49258 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726971AbgGOUMl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Jul 2020 16:12:41 -0400
Received: from Liberator.localdomain (unknown [50.34.173.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B72944EA2CE
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 15:12:09 -0500 (CDT)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v5.7.0-rc1 released
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <9f0d51d3-cb5f-3402-f48f-211aad2f95f0@sandeen.net>
Date:   Wed, 15 Jul 2020 13:12:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="29uUZzA1JEzapmJ0DvY8CSlTyG84Hr8Tl"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--29uUZzA1JEzapmJ0DvY8CSlTyG84Hr8Tl
Content-Type: multipart/mixed; boundary="FmblPpKdC3xqLoelCU3wSswWwEVLXgxVX"

--FmblPpKdC3xqLoelCU3wSswWwEVLXgxVX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with version v5.7.0-rc1

This will be v5.7.0 in a week or so unless I'm alerted to any flaws
or critical missed patches.

The brief changelog looks like this:

xfsprogs-5.7.0-rc1 (15 Jul 2020)
        - remove libreadline support (Christoph Hellwig)
        - xfs_quota: allow individual timer extension (Eric Sandeen)
        - xfs_quota: fix unsigned int id comparisons (Darrick Wong)
        - xfs_repair: fix progress reporting (Eric Sandeen)
        - xfs_repair: fix minrecs error during phase5 btree rebuild (Gao =
Xiang)
        - xfs_repair: add missing validations to match xfs_check (Darrick=
 Wong)
        - xfs_repair: use btree bulk loading (Darrick Wong)
        - xfs_io: fix copy_range argument parsing (Eric Sandeen)
        - xfs_io: document -q option for pread/pwrite command (Xiao Yang)=

        - xfs_metadump: man page fixes (Kaixu Xia)
        - xfs_db: fix crc invalidation segfault (Anthony Iliopoulos)

The new head of the master branch is commit:

8f015890 (HEAD -> guilt/for-next, tag: v5.7.0-rc1, korg/master, korg/for-=
next, refs/patches/for-next/5.7.0-rc1) xfsprogs: Release v5.7.0-rc1

New Commits:

Anthony Iliopoulos (1):
      [a19679ec] xfs_db: fix crc invalidation segfault

Christoph Hellwig (12):
      [bbe12eb9] xfsprogs: remove libreadline support
      [d5b6e335] xfsprogs: remove xfs_dir_ops
      [b98cd1f7] libxfs: use tabs instead of spaces in div_u64
      [30f8e916] db: fix a comment in scan_freelist
      [27cd356f] db: add a comment to agfl_crc_flds
      [8e9a788f] db: cleanup attr_set_f and attr_remove_f
      [38cff22d] db: validate name and namelen in attr_set_f and attr_rem=
ove_f
      [951e17bc] db: ensure that create and replace are exclusive in attr=
_set_f
      [0c02ef9b] repair: cleanup build_agf_agfl
      [f19a627b] metadump: small cleanup for process_inode
      [5d0807ad] libxfs-apply: use git am instead of patch
      [273165cc] scrub: remove xfs_ prefixes from various function

Darrick J. Wong (38):
      [b0c0cdb7] libxcmd: don't crash if el_gets returns null
      [8c4d190e] find_api_violations: fix sed expression
      [7161cd21] xfs_db: bounds-check access to the dbmap array
      [cafb847b] xfs_db: don't crash if el_gets returns null
      [bb9bedb6] xfs_db: fix rdbmap_boundscheck
      [981e63e0] debian: replace libreadline with libedit
      [eaa5b0b7] xfs_quota: fix unsigned int id comparisons
      [be752639] xfs_repair: fix missing dir buffer corruption checks
      [41f8fc57] xfs_repair: warn when we would have rebuilt a directory
      [cae4fd29] xfs_repair: check for AG btree records that would wrap a=
round
      [2212e773] xfs_repair: fix bnobt and refcountbt record order checks=

      [2a0f9efe] xfs_repair: check for out-of-order inobt records
      [db2a77d1] xfs_repair: fix rmapbt record order check
      [08280b4b] xfs_repair: tag inobt vs finobt errors properly
      [320cc3b2] xfs_repair: complain about bad interior btree pointers
      [dcd6c2e1] xfs_repair: convert to libxfs_verify_agbno
      [6271fa06] xfs_repair: refactor verify_dfsbno_range
      [a6bd55d3] xfs_repair: remove verify_dfsbno
      [04777511] xfs_repair: remove verify_aginum
      [15fd0ca2] xfs_repair: mark entire free space btree record as free1=

      [f4cea8e8] xfs_repair: complain about free space only seen by one b=
tree
      [32e11be9] xfs_repair: complain about extents in unknown state
      [0ce3577f] xfs_repair: complain about any nonzero inprogress value,=
 not just 1
      [98206665] xfs_repair: drop lostblocks from build_agf_agfl
      [3acf0068] xfs_repair: rename the agfl index loop variable in build=
_agf_agfl
      [49031e66] xfs_repair: make container for btree bulkload root and b=
lock reservation
      [cca4dbfe] xfs_repair: inject lost blocks back into the fs no matte=
r the owner
      [79f86c9d] xfs_repair: create a new class of btree rebuild cursors
      [7e5ec4e4] xfs_repair: rebuild free space btrees with bulk loader
      [7a21223c] xfs_repair: rebuild inode btrees with bulk loader
      [dc9f4f5e] xfs_repair: rebuild reverse mapping btrees with bulk loa=
der
      [3c1ce0fc] xfs_repair: rebuild refcount btrees with bulk loader
      [e75cef63] xfs_repair: remove old btree rebuild support code
      [c94d40ce] xfs_repair: use bitmap to track blocks lost during btree=
 construction
      [a891d871] xfs_repair: complain about ag header crc errors
      [6ffc9523] xfs_repair: simplify free space btree calculations in in=
it_freespace_cursors
      [41865980] xfs_repair: try to fill the AGFL before we fix the freel=
ist
      [4dcaa160] xfs_copy: flush target devices before exiting

Eric Sandeen (6):
      [baed08dd] xfs_io: copy_range can take up to 8 arguments
      [a4d94d6c] xfs_repair: fix progress reporting
      [67a73d61] xfs_quota: refactor code to generate id from name
      [36dc471c] xfs_quota: allow individual timer extension
      [e48f6fbc] xfs_repair: remove gratuitous code block in phase5
      [8f015890] xfsprogs: Release v5.7.0-rc1

Gao Xiang (1):
      [6df28d12] xfs_repair: fix rebuilding btree block less than minrecs=


Kaixu Xia (2):
      [9f9ee751] mkfs: simplify the configured sector sizes setting in va=
lidate_sectorsize
      [957fd6cf] metadump: remove redundant bracket and show right SYNOPS=
IS

Xiao Yang (1):
      [0388cfb1] xfs_io: Document '-q' option for pread/pwrite command


Code Diffstat:

 VERSION                      |    2 +-
 configure.ac                 |    9 +-
 copy/xfs_copy.c              |   24 +-
 db/Makefile                  |    5 -
 db/agfl.c                    |    1 +
 db/attrset.c                 |   87 +-
 db/check.c                   |   45 +-
 db/crc.c                     |    2 +-
 db/input.c                   |   49 +-
 db/metadump.c                |    3 +-
 debian/changelog             |    6 +
 debian/control               |    2 +-
 debian/rules                 |    2 +-
 doc/CHANGES                  |   13 +
 growfs/Makefile              |    3 -
 include/builddefs.in         |    2 -
 include/libxfs.h             |    1 +
 include/xfs_inode.h          |    2 -
 include/xfs_mount.h          |    3 -
 io/Makefile                  |    4 -
 io/copy_file_range.c         |    2 +-
 io/pread.c                   |    3 +-
 io/pwrite.c                  |    3 +-
 libxcmd/Makefile             |    5 -
 libxcmd/input.c              |   38 +-
 libxfs/libxfs_api_defs.h     |   12 +
 libxfs/libxfs_priv.h         |    4 +-
 libxfs/rdwr.c                |    8 -
 libxfs/util.c                |    8 -
 man/man8/xfs_io.8            |   10 +-
 man/man8/xfs_metadump.8      |    1 -
 man/man8/xfs_quota.8         |   36 +-
 mkfs/xfs_mkfs.c              |   17 +-
 quota/Makefile               |    5 -
 quota/edit.c                 |  277 ++---
 repair/Makefile              |    4 +-
 repair/agbtree.c             |  696 ++++++++++++
 repair/agbtree.h             |   62 +
 repair/attr_repair.c         |    2 +-
 repair/bulkload.c            |  140 +++
 repair/bulkload.h            |   62 +
 repair/da_util.c             |   25 +-
 repair/dino_chunks.c         |    6 +-
 repair/dinode.c              |  109 +-
 repair/dinode.h              |   14 -
 repair/dir2.c                |   21 +
 repair/phase2.c              |    6 +
 repair/phase4.c              |   11 +-
 repair/phase5.c              | 2580 +++++-------------------------------=
------
 repair/phase6.c              |    4 +-
 repair/prefetch.c            |    9 +-
 repair/progress.c            |   35 +-
 repair/progress.h            |   31 +-
 repair/sb.c                  |    3 +-
 repair/scan.c                |  166 ++-
 repair/xfs_repair.c          |   17 +
 scrub/common.c               |    2 +-
 scrub/common.h               |    2 +-
 scrub/filemap.c              |    2 +-
 scrub/inodes.c               |    2 +-
 scrub/phase1.c               |    8 +-
 scrub/phase2.c               |    8 +-
 scrub/phase3.c               |   18 +-
 scrub/phase4.c               |    2 +-
 scrub/phase5.c               |    2 +-
 scrub/phase7.c               |    2 +-
 scrub/repair.c               |    2 +-
 scrub/scrub.c                |  106 +-
 scrub/scrub.h                |   42 +-
 scrub/spacemap.c             |    2 +-
 scrub/vfs.c                  |    2 +-
 scrub/xfs_scrub.c            |    4 +-
 spaceman/Makefile            |    4 -
 tools/find-api-violations.sh |   10 +-
 tools/libxfs-apply           |    4 +-
 75 files changed, 1990 insertions(+), 2931 deletions(-)
 create mode 100644 repair/agbtree.c
 create mode 100644 repair/agbtree.h
 create mode 100644 repair/bulkload.c
 create mode 100644 repair/bulkload.h


--FmblPpKdC3xqLoelCU3wSswWwEVLXgxVX--

--29uUZzA1JEzapmJ0DvY8CSlTyG84Hr8Tl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl8PYzIACgkQIK4WkuE9
3uBzGA/8CX+B4+3ZABr3Mpoynqdj577jmHoZDYuhG7m/2Cam2V0Jna6z0lR4FiLB
cKY6Cg96Mvn+sBQ0UNYa4xbzn7qXLZm6gSdNyiO3DQujCNMYKb+hJLSnr9VbTbEO
y79dYLM//9u1VmkknKQFdrP7zSL/GRseqFMUatiW30kC/lpNQnOB+n8zbtQHrZXN
WVQtKNki0uF46PxXvuoXPQ2aSvqKOSCxcnwFbpKagSwR0tBhlMvSdHF/w0QQxEGd
l7S3GYWSwYuyBCJqFDpLdFZBpLWX54Ivq6CvAmZEcqWkOT4VKEbL7Lj7pa3x2yzb
ID48tWnu83yD2A0VdLtjYDy6+C7qUBqFxX3LNYK4fGBjcsyxJ8asTQwba7xX2s2o
jB4qyekTTFcUzeBtnKNhKXYLU4Rl/v0j5iAaadZUlnYPg9CNmufSlLNc37LD9Pzc
gD4PE0RKip5qk+knhj/C6o2lVAmEdWrZDM9npfPTNHAmxdPj3aKt/lwoqmTur+Yx
VoyW2RCylrc4EK0HdXOQjZJazL/vmaACXWgc3aD55mPmscon6NYTfsm3iZd0VAoQ
zRwSMmuQXzTrdaDOKCzEQc5uGze0WQsjJdFuDtfVVUybZNwUtdm9pxW6XAVNZgwE
WR66dugqQnBN4DMBHfCyfD+v47cW3mYCzvCcp7GxSuiifPH3mwg=
=/ZMp
-----END PGP SIGNATURE-----

--29uUZzA1JEzapmJ0DvY8CSlTyG84Hr8Tl--
