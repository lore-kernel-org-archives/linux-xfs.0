Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A22C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Feb 2021 01:19:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9519464DCF
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Feb 2021 01:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhBPBTj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Feb 2021 20:19:39 -0500
Received: from sandeen.net ([63.231.237.45]:43006 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229697AbhBPBTi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 Feb 2021 20:19:38 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 2E9BB48C68A
        for <linux-xfs@vger.kernel.org>; Mon, 15 Feb 2021 19:18:52 -0600 (CST)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to 317ea9c7
Message-ID: <f6426c2a-0b55-f7b3-c6c9-d5e95260dbeb@sandeen.net>
Date:   Mon, 15 Feb 2021 19:18:57 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tupEZunfKd11fuyNGQh44QO6Xb0CJWQ73"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tupEZunfKd11fuyNGQh44QO6Xb0CJWQ73
Content-Type: multipart/mixed; boundary="qdkLRlgdoRGwiijuE9j9bbUeweIR0tFtQ";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <f6426c2a-0b55-f7b3-c6c9-d5e95260dbeb@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to 317ea9c7

--qdkLRlgdoRGwiijuE9j9bbUeweIR0tFtQ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This has the bonus feature of an xfsprogs-5.11.0-rc0 tag, which I forgot =
to
add after the libxfs-sync; I tagged it after incorporaqting the recent
debian updates in the middle of this update.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

317ea9c7 (HEAD -> for-next, korg/for-next, refs/patches/for-next/xfs_scru=
b__fix_weirdness_in_directory_name_check_code.patch) xfs_scrub: fix weird=
ness in directory name check code

New Commits:

Bastian Germann (3):
      [bbadb45b] debian: Drop unused dh-python from Build-Depends
      [a35f8da4] debian: Only build for Linux
      [402279c4] debian: Prevent installing duplicate changelog

Chandan Babu R (3):
      [8e0c0761] xfsprogs: xfs_fsr: Interpret arguments of qsort's compar=
e function correctly
      [937e3dd1] xfsprogs: xfs_fsr: Limit the scope of cmp()
      [4d4ea220] xfsprogs: xfs_fsr: Verify bulkstat version information i=
n qsort's cmp()

Darrick J. Wong (8):
      [d29084ce] xfs_db: add a directory path lookup command
      [08f24589] xfs_db: add an ls command
      [bbfbf5dd] misc: fix valgrind complaints
      [4f546267] xfs_scrub: detect infinite loops when scanning inodes
      [ff8717e5] xfs_scrub: load and unload libicu properly
      [942d5946] xfs_scrub: handle concurrent directory updates during na=
me scan
      [604bd75c] xfs_repair: check dquot id and type
      [317ea9c7] xfs_scrub: fix weirdness in directory name check code

Eric Sandeen (2):
      [663c6117] xfsprogs: Release v5.11.0-rc0
      [559b58fa] xfs_quota: drop pointless qsort cmp casting

Zorro Lang (1):
      [2c40c5a7] mkfs: fix wrong inobtcount usage error output


Code Diffstat:

 VERSION                  |   4 +-
 configure.ac             |   2 +-
 db/Makefile              |   3 +-
 db/command.c             |   1 +
 db/command.h             |   1 +
 db/namei.c               | 609 +++++++++++++++++++++++++++++++++++++++++=
++++++
 debian/changelog         |   8 +
 debian/control           |   8 +-
 debian/rules             |   2 +-
 doc/CHANGES              |   4 +
 fsr/xfs_fsr.c            |  29 ++-
 libhandle/handle.c       |  10 +-
 libxfs/libxfs_api_defs.h |   1 +
 man/man8/xfs_db.8        |  20 ++
 mkfs/xfs_mkfs.c          |   2 +-
 quota/quot.c             |  18 +-
 repair/quotacheck.c      |  58 ++++-
 scrub/inodes.c           |  18 +-
 scrub/phase5.c           |  10 +-
 scrub/spacemap.c         |   3 +-
 scrub/unicrash.c         |  33 ++-
 scrub/unicrash.h         |   4 +
 scrub/xfs_scrub.c        |   7 +
 23 files changed, 810 insertions(+), 45 deletions(-)
 create mode 100644 db/namei.c


--qdkLRlgdoRGwiijuE9j9bbUeweIR0tFtQ--

--tupEZunfKd11fuyNGQh44QO6Xb0CJWQ73
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmArHYEFAwAAAAAACgkQIK4WkuE93uA5
IRAAo5WweXMSAByzh0TxwjUTVdwLkKsN6RgG2yCzgNZP3KABAXBqFfAY9eTMTBMihBc9uq0Q+SNY
AVJaW+jiJjCD8BDoEZtdAHg52Nq2SQ9uxdDqOMT3ET8YdC1lQImQ94toTcjZNLJPBx5NvnJNCMnd
fIauSUkCTSxwfNdVq9M/Z/TEXHeCmS4sAAZWvH1C6XzDwoJEuqL1NOfp0NWmurotFuBpBLhn06ev
vsv6AqsAJ8odEbHhG653dzRHCBYYi6YTaI4tZdEpagg9sdE/O3DAlt0uvVyR7tz0vTx7OIjOagS7
03tBSzinLxbDL2EFv9LwMMzuYwDiEnVB6YmJryFWMVcsiaDXcFiyGS6cvwjAM3jqGrUdN9/f+Pqx
gSI/c727Et0GYUtqWp/LW3yf7uWQ3KvA0qyFHVZDW2D52MYMGBLH+OfKsM+NQ5nsKRjsQGyzDHlk
EmKFrPia6yPlfHzgl4y+SAYlYqE6vZf2/aUHTz+KE80Ju/ktsGsKAk+NKkur9ajHIiuobzlv8IfS
8FFhHV0G0bd/bS6pslittOsrZJ/wWLHnDgTjtbVK2IeMm7b5a5I6iBMa1HxTPcrhXqJ17DrBaDfo
/vIyWrwShw5DQBRlA7EY4gGCx5kS4Neft96zZ8rOCfS4UEACf7NTYqXdKbfCxVqgyMrH3iecvnUU
cLA=
=URwx
-----END PGP SIGNATURE-----

--tupEZunfKd11fuyNGQh44QO6Xb0CJWQ73--
