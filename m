Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 963EEC63777
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 17:33:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 433DC206F7
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 17:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390713AbgKXRdl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Nov 2020 12:33:41 -0500
Received: from sandeen.net ([63.231.237.45]:41356 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728749AbgKXRdl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Nov 2020 12:33:41 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 33D7514948B
        for <linux-xfs@vger.kernel.org>; Tue, 24 Nov 2020 11:33:36 -0600 (CST)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to c0594dd6
Message-ID: <09780327-9bae-a74c-75b3-525d698c0744@sandeen.net>
Date:   Tue, 24 Nov 2020 11:33:40 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6ZdTFA4n3VAbq18bK0lJi8OYO8k2nET72"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6ZdTFA4n3VAbq18bK0lJi8OYO8k2nET72
Content-Type: multipart/mixed; boundary="EP4k5DoE23ZPEAIwe1h37w4jv4e122vpS";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <09780327-9bae-a74c-75b3-525d698c0744@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to c0594dd6

--EP4k5DoE23ZPEAIwe1h37w4jv4e122vpS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This is one more libxfs sync, and picking up a couple of older patches
I'd missed.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

c0594dd6 (HEAD -> for-next, origin/for-next, korg/for-next) libxfs: get r=
id of b_bcount from xfs_buf

New Commits:

Christoph Hellwig (1):
      [f3a6a9f8] repair: simplify bmap_next_offset

Dave Chinner (1):
      [c0594dd6] libxfs: get rid of b_bcount from xfs_buf

Gao Xiang (1):
      [7ec35999] xfs: fix forkoff miscalculation related to XFS_LITINO(mp=
)


Code Diffstat:

 db/metadump.c             |  2 +-
 libxfs/libxfs_io.h        |  4 +---
 libxfs/logitem.c          |  4 ++--
 libxfs/rdwr.c             | 20 +++++++++---------
 libxfs/trans.c            |  2 +-
 libxfs/xfs_attr_leaf.c    |  8 ++++++-
 libxlog/xfs_log_recover.c |  6 +++---
 mkfs/proto.c              |  9 +++++---
 repair/attr_repair.c      |  4 ++--
 repair/dino_chunks.c      |  2 +-
 repair/phase6.c           | 54 ++++++++++++++++++++++-------------------=
------
 repair/prefetch.c         | 14 ++++++------
 12 files changed, 67 insertions(+), 62 deletions(-)


--EP4k5DoE23ZPEAIwe1h37w4jv4e122vpS--

--6ZdTFA4n3VAbq18bK0lJi8OYO8k2nET72
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl+9Q/QFAwAAAAAACgkQIK4WkuE93uAj
5RAAnwVtW9RU2RdTaYQ6dTSfEi8zOFkux+4SIj07Z2cE73c8VBs0wNvuGiXIj5ZSihF0sP8KLObR
p3U4N21wJBgtSQ8D+59ICvucqOCq86+jkyndYt/9nN6Dosonut2RYojU7MQFdg9lSfqwtOIb3I7/
HjZyAsD0M/quAr5BEdvIeUgx6lUvKurOl07pCiK/3J201TVWGmKMgHGuQ5PANaid7bJu1SIa8rZv
/WJBDFv+Llleq2+YcmoN1ZEKLmkzKeLkMuU535APQfnwqfkf3dw5wdm/XRd0mG6W6lkzu59caCzd
TX85qKvjgMdSKs9F/lFuvtow5D60x4iiU+cM/rUKU6yWOeSGGGPdpEOEcARqCpc+BiNEwKiuuO5U
rUL+bafqCakQkueJWgjAhGGby62dn66W22Hqw2hJ5PINQYGB1vIx7YwHYSYEG3uyBoly2GG6GxAI
fgT5yzjTrmVxPw/Q3tIZ7wmpzWFDMxiPzPM73bgrzH6iPyEOyKpiK1y/TBlISrAHZ+uYCg01mZac
YQnXWRifEx+gXAuz0B90xfFJCrwdAHnhByZLV1vfzPCIKhDadGtGcgc6Q6kk2r4KcUWW1H6h63LA
LOqby/isova60V0Sm7Gd8Vzh0/VJ0zduK6fFS1ehu364ikLXUsvmKPVDtFMwL9Os5mbk5q6y2EDt
maQ=
=VuTn
-----END PGP SIGNATURE-----

--6ZdTFA4n3VAbq18bK0lJi8OYO8k2nET72--
