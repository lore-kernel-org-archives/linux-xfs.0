Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56F5FC433ED
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Apr 2021 21:52:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20BBF61168
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Apr 2021 21:52:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbhDWVxd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Apr 2021 17:53:33 -0400
Received: from sandeen.net ([63.231.237.45]:50148 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231218AbhDWVxd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Apr 2021 17:53:33 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 2EF8D552447
        for <linux-xfs@vger.kernel.org>; Fri, 23 Apr 2021 16:51:38 -0500 (CDT)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to da7f6039
Message-ID: <c0e00ef4-f1ed-0222-55f2-7ba780159f3a@sandeen.net>
Date:   Fri, 23 Apr 2021 16:52:55 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4IZjWVBgm8ALNANmrGjj1XbeS2VRInTu6"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4IZjWVBgm8ALNANmrGjj1XbeS2VRInTu6
Content-Type: multipart/mixed; boundary="v2yQtulkRvoPZB3StLn6vCcCbmJnicpYt";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <c0e00ef4-f1ed-0222-55f2-7ba780159f3a@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to da7f6039

--v2yQtulkRvoPZB3StLn6vCcCbmJnicpYt
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

If I've missed your patch twice now, you should definitely ping me. :)

Happy Friday!

The new head of the for-next branch is commit:

da7f6039 (HEAD -> for-next, korg/for-next, refs/patches/for-next/repair__=
fix_an_uninitialized_variable_issue.patch) repair: fix an uninitialized v=
ariable issue

New Commits:

Anthony Iliopoulos (1):
      [4cfe2c37] xfsprogs: remove BMV_IF_NO_DMAPI_READ flag

Gao Xiang (2):
      [272480fa] xfs_growfs: support shrinking unused space
      [da7f6039] repair: fix an uninitialized variable issue


Code Diffstat:

 growfs/xfs_growfs.c   |  9 ++++-----
 io/bmap.c             | 28 +++++++---------------------
 man/man8/xfs_bmap.8   |  9 ---------
 man/man8/xfs_growfs.8 |  8 +++++---
 po/de.po              |  3 ---
 po/pl.po              |  3 ---
 repair/phase6.c       |  2 +-
 scrub/filemap.c       |  3 +--
 8 files changed, 18 insertions(+), 47 deletions(-)


--v2yQtulkRvoPZB3StLn6vCcCbmJnicpYt--

--4IZjWVBgm8ALNANmrGjj1XbeS2VRInTu6
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmCDQbcFAwAAAAAACgkQIK4WkuE93uBk
cBAAsEzJv+BZWO0c/+/rZBFIhuPY8jVRhQ3rHKaf9vEH3kOslKDaNl9jSiR3ZaGHBQjhRyuqIjLr
BSSpyH3x3hobduqUdLCDFKWm3I5F1Cm69Ycn7SVmQmmOv0dIA5YVg6+lk9NsZs+wEvHgJPOT4YHf
cdLjTnSXETXFSlbR0HReot7jfc7kSt3/3FCgLt1LFNgeDNo6QSn7tYnD7KfU3NPvXbC655+eAGJT
tSg+N0LwRQi+1p6xb1wlijTXESWvC31HB7hS01EV+Byh98ZVPe3hCgmGZx0qRNdxqbvCOmFOS8ju
NI5CKjapuSBRSEzFCHa/Uk3eo5cVnCUIi2b3FFfwmGUi3iehj43RBlfhFqQk0ccSVlK8pAXVeq4R
73zirI7ak9sAtZ7hDzQhoLjiFclBsT0NCiRHgN68NvlAGl10ub2Ynf5JUMmAP+OxxV/0SvyyG02l
m6T4I2fGvGdFCp57guNQvlmSN08Q0FZmi1y7fN5W4KD4gu8F2hnrDjfzbGXyKILTElrU+JnQx4WI
E57L/TiRslRhYYSLuWJKgsiMW5Lcp4ea3yHC3jzemmcj/rteGNcyel8brqWwX0Dn+a0cbdsA74Gw
5N794IeRDQTaM1LEcMyK3qrWIOtmz4X10HOTTMF3nd+CQlTV5Vl7UP/s7kTMW4jR8cF83bWepyGy
sGg=
=yGlr
-----END PGP SIGNATURE-----

--4IZjWVBgm8ALNANmrGjj1XbeS2VRInTu6--
