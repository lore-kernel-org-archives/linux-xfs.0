Return-Path: <SRS0=YlU2=7J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E5AEC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 May 2020 15:07:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70D802084C
	for <linux-xfs@archiver.kernel.org>; Wed, 27 May 2020 15:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389567AbgE0PHm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 May 2020 11:07:42 -0400
Received: from sandeen.net ([63.231.237.45]:42258 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388922AbgE0PHm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 27 May 2020 11:07:42 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 08EDB48C729
        for <linux-xfs@vger.kernel.org>; Wed, 27 May 2020 10:07:02 -0500 (CDT)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 957fd6cf
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <2e3073d9-7c2b-28a4-ace4-3fbc78b2adf3@sandeen.net>
Date:   Wed, 27 May 2020 10:07:38 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="s8Ka6Scon3nsmDf3nGDX97OPnbuMdD5YH"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--s8Ka6Scon3nsmDf3nGDX97OPnbuMdD5YH
Content-Type: multipart/mixed; boundary="u7536VrlfAL1u15EnRXatdb3yXikpWuJ0"

--u7536VrlfAL1u15EnRXatdb3yXikpWuJ0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

957fd6cf (HEAD -> for-next, korg/for-next) metadump: remove redundant bra=
cket and show right SYNOPSIS

New Commits:

Anthony Iliopoulos (1):
      [a19679ec] xfs_db: fix crc invalidation segfault

Christoph Hellwig (1):
      [273165cc] scrub: remove xfs_ prefixes from various function

Darrick J. Wong (3):
      [cafb847b] xfs_db: don't crash if el_gets returns null
      [bb9bedb6] xfs_db: fix rdbmap_boundscheck
      [981e63e0] debian: replace libreadline with libedit

Eric Sandeen (3):
      [a4d94d6c] xfs_repair: fix progress reporting
      [67a73d61] xfs_quota: refactor code to generate id from name
      [36dc471c] xfs_quota: allow individual timer extension

Kaixu Xia (2):
      [9f9ee751] mkfs: simplify the configured sector sizes setting in va=
lidate_sectorsize
      [957fd6cf] metadump: remove redundant bracket and show right SYNOPS=
IS


Code Diffstat:

 db/check.c              |   2 +-
 db/crc.c                |   2 +-
 db/input.c              |  23 ++--
 debian/control          |   2 +-
 debian/rules            |   2 +-
 man/man8/xfs_metadump.8 |   1 -
 man/man8/xfs_quota.8    |  36 ++++++-
 mkfs/xfs_mkfs.c         |  17 +--
 quota/edit.c            | 277 +++++++++++++++++++++---------------------=
------
 repair/phase2.c         |   6 ++
 repair/progress.c       |  35 +++---
 repair/progress.h       |  31 +++---
 scrub/common.c          |   2 +-
 scrub/common.h          |   2 +-
 scrub/filemap.c         |   2 +-
 scrub/inodes.c          |   2 +-
 scrub/phase1.c          |   8 +-
 scrub/phase2.c          |   8 +-
 scrub/phase3.c          |  18 ++--
 scrub/phase4.c          |   2 +-
 scrub/phase5.c          |   2 +-
 scrub/phase7.c          |   2 +-
 scrub/repair.c          |   2 +-
 scrub/scrub.c           | 106 +++++++++---------
 scrub/scrub.h           |  42 ++++----
 scrub/spacemap.c        |   2 +-
 scrub/vfs.c             |   2 +-
 scrub/xfs_scrub.c       |   4 +-
 28 files changed, 321 insertions(+), 319 deletions(-)


--u7536VrlfAL1u15EnRXatdb3yXikpWuJ0--

--s8Ka6Scon3nsmDf3nGDX97OPnbuMdD5YH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl7OgjwACgkQIK4WkuE9
3uAvrhAAgU+Yq9kt6u99/HUxFZxbFD7DX1gxx+hGDewr3RPAsphNkvuCrwwFaL32
VnTADgFTeEXWx6gZHDPT4TFGvtfvr/TZ2CXLyHTGuOrtr1iOMH5ikB0NFkN91dM4
iS/9TFQ3/ZFZSw/Fxu0xzdKCK2cn9Wl8/VhJ8wouIyFcvH6AxG4YrtaVoZqYiIhk
XUjEcfFJhIYXuuRUDEoh33xzKoc7owkkDgbfi8Gwoa3V/BQ5VqUxYB63etAltr2l
IsoLXOypeEV+5xdIlBbAinz3WlbUZQIKz69kxOhsSH8yS6kU1NlNut0Blb/0bDC1
slnAuRNXCIOxbTbMg7eG8ZqGT3oD0mc8+vqqYJrXWmXIuCRfk02Xkp/i176V5dS8
HrXcwYp777b8kYhe1tm08d7JrSiYYdBflcjd6yZyM3FLFw5E20dhM+HHjjbfAo71
YbyAWSZsGAIYAg1DY1LlXzV42UrO1dA/QqyI2iHv8XXTO5ivzreoDTyqEupVYPP1
T6kP/LWg4Qm13wqWM7vbWPtak93iTRqMaZw8NlA0Io3nH8LDgo8+fPeH2alCx0MD
e5wcE8iOtEKatsxidy0FtUs91SHcp2zajxVec5LNrsFRuk+gF/5Xu6Ycpk15j/i1
FgCTe6ChMnf/b0Thhno+WoOc7vrv73uUr3ww4SvZokawKptvakQ=
=atkB
-----END PGP SIGNATURE-----

--s8Ka6Scon3nsmDf3nGDX97OPnbuMdD5YH--
