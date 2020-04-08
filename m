Return-Path: <SRS0=ttQi=5Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFEECC2D0EA
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 14:01:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3FE52072A
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 14:01:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbgDHOB1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 10:01:27 -0400
Received: from sandeen.net ([63.231.237.45]:41436 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726663AbgDHOB1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Apr 2020 10:01:27 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 85571544
        for <linux-xfs@vger.kernel.org>; Wed,  8 Apr 2020 09:01:17 -0500 (CDT)
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs-5.6.0-rc1 released
To:     linux-xfs <linux-xfs@vger.kernel.org>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <dfe829d1-bb0d-3842-7919-ae63e7f0d60f@sandeen.net>
Date:   Wed, 8 Apr 2020 09:01:24 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="EzAOM4nATDcv5eQbyqow8DAMzR6l4hjLP"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--EzAOM4nATDcv5eQbyqow8DAMzR6l4hjLP
Content-Type: multipart/mixed; boundary="vJG7dYgWTKSXxzJWhSupZS0MsShwZslh6"

--vJG7dYgWTKSXxzJWhSupZS0MsShwZslh6
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with xfsprogs-5.6.0-rc1.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

52e6dd80 (HEAD -> guilt/for-next, tag: v5.6.0-rc1, refs/patches/for-next/=
5.6.0-rc0.2) xfsprogs: Release v5.6.0-rc1

New Commits:

Christoph Hellwig (3):
      [d11bffea] libxfs: turn the xfs_buf_incore stub into an inline func=
tion
      [cf8f9004] xfs: remove XFS_BUF_SET_BDSTRAT_FUNC
      [69806fff] libxfs: remove libxfs_iomove

Darrick J. Wong (5):
      [0a82d75e] libxfs: don't barf in libxfs_bwrite on a null buffer ops=
 name
      [023ba280] libxfs: check return value of device flush when closing =
device
      [f4afdcb0] xfs_db: clean up the salvage read callsites in set_cur()=

      [db8e6401] xfs_repair: fix dir_read_buf use of libxfs_da_read_buf
      [be6687e4] xfs_scrub: fix type error in render_ino_from_handle

Dave Chinner (5):
      [105041e6] mkfs: use cvtnum from libfrog
      [825b7432] xfsprogs: Fix --disable-static option build
      [2582ae0d] xfsprogs: LDFLAGS comes from configure, not environment
      [78aeaffd] xfsprogs: fix silently broken option parsing
      [9e1595e6] xfs_io: set exitcode on failure appropriately

Eric Sandeen (1):
      [52e6dd80] xfsprogs: Release v5.6.0-rc1


Code Diffstat:

 VERSION                 |  2 +-
 configure.ac            |  2 +-
 copy/xfs_copy.c         |  2 +-
 db/freesp.c             |  2 +-
 db/init.c               |  7 ++--
 db/io.c                 | 16 +++++----
 debian/changelog        |  6 ++++
 doc/CHANGES             |  7 ++++
 growfs/xfs_growfs.c     |  1 -
 include/builddefs.in    |  4 +++
 include/xfs_multidisk.h |  3 --
 io/attr.c               | 24 ++++++++++---
 io/copy_file_range.c    | 18 ++++++++--
 io/cowextsize.c         |  5 +++
 io/encrypt.c            | 29 +++++++++++++---
 io/fadvise.c            |  9 ++++-
 io/fiemap.c             |  3 ++
 io/file.c               |  1 +
 io/fsmap.c              |  9 +++--
 io/fsync.c              |  2 ++
 io/getrusage.c          |  1 +
 io/imap.c               |  1 +
 io/inject.c             |  1 +
 io/link.c               |  1 +
 io/log_writes.c         | 28 ++++++++-------
 io/madvise.c            | 10 +++++-
 io/mincore.c            | 10 +++++-
 io/mmap.c               | 62 +++++++++++++++++++++++++++------
 io/open.c               | 91 ++++++++++++++++++++++++++++++++++++-------=
------
 io/parent.c             |  1 +
 io/pread.c              | 19 +++++++++--
 io/prealloc.c           | 55 ++++++++++++++++++++++++------
 io/pwrite.c             | 31 ++++++++++++++---
 io/readdir.c            | 10 ++++--
 io/reflink.c            | 30 +++++++++++++---
 io/resblks.c            |  3 ++
 io/seek.c               | 12 +++++--
 io/sendfile.c           | 18 ++++++++--
 io/shutdown.c           |  2 ++
 io/stat.c               | 13 ++++++-
 io/sync_file_range.c    |  8 ++++-
 io/truncate.c           |  2 ++
 io/utimes.c             |  3 ++
 libfrog/Makefile        |  2 ++
 libfrog/convert.c       | 14 +++++---
 libfrog/convert.h       |  2 +-
 libxcmd/Makefile        |  2 ++
 libxfs/Makefile         |  2 ++
 libxfs/init.c           | 11 ++++--
 libxfs/libxfs_io.h      |  6 ----
 libxfs/libxfs_priv.h    | 14 ++++----
 libxfs/logitem.c        |  1 -
 libxfs/rdwr.c           | 26 +-------------
 libxlog/Makefile        |  2 ++
 logprint/logprint.c     |  2 +-
 mkfs/proto.c            |  2 +-
 mkfs/xfs_mkfs.c         | 74 +++++-----------------------------------
 repair/phase6.c         | 21 +++++-------
 repair/xfs_repair.c     |  2 +-
 scrub/phase5.c          |  2 +-
 scrub/xfs_scrub.c       |  2 --
 spaceman/freesp.c       |  1 -
 spaceman/prealloc.c     |  1 -
 63 files changed, 501 insertions(+), 252 deletions(-)




--vJG7dYgWTKSXxzJWhSupZS0MsShwZslh6--

--EzAOM4nATDcv5eQbyqow8DAMzR6l4hjLP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl6N2TUACgkQIK4WkuE9
3uBDchAAilyyc4BWhe65GZ9EWJRSZ8+S/sMaPYIOK8+riHQTKIcxgAA10d56KOv3
TbflmwNVhjCuBw35qI5qeckItiSEFMHMXWNEhkbCfhJGv5Q+dzHHdWIK3VZLolmw
8OrJCEK5PUZMOubsYhMdcuZkH6L/G0Ya9vjiB2pWWa/93n89OlBXHg2g8VxBW1PJ
Crqe+jscrbWWo0qB8eLAWGe0pC47mOWGBg5MSIloOARrj0TjXjhZNzms7Srw9PBF
0Sx1LKjDvEwM2H4ohPHYPPIXzaYa8F+CafyOwPgccgFNXwrBk617E89amDTqUsoB
Pl5ju+8sY+gNl1E/EvjrQIJKpfbaA+zqp3LxkqXjY8VEr1+fcdHrkjFSSUsI+knm
Ow9o24c9aZjydb+cP4yktQ3rfmdSho9+TejhnHlJZ+LjOhaZb6jVBMe58bqks5Ef
HkXHXX/0b3awWy98DoFt3FHwL2ZjkxGGxGUS3KWKxJO2XbKxg3FtASCVwXiLk1ou
F0jonop7u3tArmgHZ02w7mNe43bw8NkrN4jmyWkOuGJkE05LVX/P4UJFATVggGOO
WERdpsJs/OHhex6ijpXvTU36a+xDz2iEcDRxUzPJYrkjTBgOADBf8KgdcNgzAEwt
2rK+QSKQA3CJQ7drGw+RScIs4AZPk0H4oWBNSjRKGi4iMHprBso=
=n4XZ
-----END PGP SIGNATURE-----

--EzAOM4nATDcv5eQbyqow8DAMzR6l4hjLP--
