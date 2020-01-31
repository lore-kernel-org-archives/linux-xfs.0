Return-Path: <SRS0=/Bg7=3U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7544CC33C9E
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jan 2020 01:27:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C0BD206F0
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jan 2020 01:27:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbgAaB1T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jan 2020 20:27:19 -0500
Received: from sandeen.net ([63.231.237.45]:50148 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727656AbgAaB1T (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Jan 2020 20:27:19 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 4224014A10
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jan 2020 19:27:18 -0600 (CST)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to ad943585
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <46d8101c-feac-89a2-c9fe-f093f575f7be@sandeen.net>
Date:   Thu, 30 Jan 2020 19:27:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="n8BLGypXmCVn3V5XXPfPDGLrw1ihVWnpG"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--n8BLGypXmCVn3V5XXPfPDGLrw1ihVWnpG
Content-Type: multipart/mixed; boundary="cp10V69oTN9UaysyTvquY5abS4h6gy1Oi"

--cp10V69oTN9UaysyTvquY5abS4h6gy1Oi
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

(Darrick, you don't need to resend yours) :)

The new head of the for-next branch is commit:

ad943585 libxfs: remove duplicate attr function declarations

New Commits:

Darrick J. Wong (10):
      [147bdab0] man: list xfs_io lsattr inode flag letters
      [48a70ce8] man: document the xfs_db btheight command
      [af0876e7] man: reformat xfs_quota commands in the manpage for test=
ing
      [94635201] man: document some missing xfs_db commands
      [09385584] xfs_db: dump per-AG reservations
      [2dd63108] xfs_io: fix copy_file_range length argument overflow
      [4eafc4d3] xfs_io: fix pwrite/pread length truncation on 32-bit sys=
tems
      [3f6bf952] xfs_repair: fix totally broken unit conversion in direct=
ory invalidation
      [abbb206c] xfs_io: fix integer over/underflow handling in timespec_=
from_string
      [ad943585] libxfs: remove duplicate attr function declarations

Eric Sandeen (4):
      [dda1a0a2] xfsprogs: alphabetize libxfs_api_defs.h
      [2cf10e4c] libxfs: move header includes closer to kernelspace
      [91c0b8d9] xfs_repair: don't search for libxfs.h in system headers
      [123b8513] xfsprogs: do not redeclare globals provided by libraries=



Code Diffstat:

 db/attrset.c                |   4 +-
 db/info.c                   | 104 ++++++++++++++++++
 db/init.c                   |   1 -
 io/copy_file_range.c        |  15 ++-
 io/pread.c                  |   4 +-
 io/pwrite.c                 |   6 +-
 libxcmd/input.c             |  23 ++--
 libxfs/libxfs_api_defs.h    | 250 +++++++++++++++++++++++---------------=
------
 libxfs/libxfs_priv.h        |   8 --
 libxfs/xfs_ag_resv.c        |   3 +
 libxfs/xfs_alloc.c          |   1 +
 libxfs/xfs_alloc_btree.c    |   2 +
 libxfs/xfs_attr_leaf.c      |   1 +
 libxfs/xfs_bmap.c           |   1 +
 libxfs/xfs_btree.c          |   2 +
 libxfs/xfs_defer.c          |   4 +
 libxfs/xfs_dir2.c           |   1 +
 libxfs/xfs_dquot_buf.c      |   3 +
 libxfs/xfs_ialloc.c         |   1 +
 libxfs/xfs_iext_tree.c      |   6 +-
 libxfs/xfs_inode_buf.c      |   1 +
 libxfs/xfs_inode_fork.c     |   2 +-
 libxfs/xfs_refcount.c       |   1 +
 libxfs/xfs_refcount_btree.c |   1 +
 libxfs/xfs_rmap.c           |   1 +
 libxfs/xfs_trans_resv.c     |   1 +
 logprint/logprint.c         |   4 +-
 man/man8/xfs_db.8           | 102 ++++++++++++++++++
 man/man8/xfs_io.8           |  89 ++++++++++++++--
 man/man8/xfs_quota.8        |  15 +--
 mdrestore/xfs_mdrestore.c   |   1 -
 repair/phase6.c             |  10 +-
 repair/rmap.c               |   2 +-
 repair/slab.c               |   2 +-
 34 files changed, 496 insertions(+), 176 deletions(-)


--cp10V69oTN9UaysyTvquY5abS4h6gy1Oi--

--n8BLGypXmCVn3V5XXPfPDGLrw1ihVWnpG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl4zgnUACgkQIK4WkuE9
3uDZAg//WRLg00b8T+ORlCNhgu3czwJy7/znyMmpUmXGFrg7FMSJw1kT8ZY94SAU
Y6EIbiyAWtxMTc8b/URg1bc4zEkuBrXOXvB4Ck6E7E8vVRl2EAtq/LIzFJZYSOqC
pWCt1OoNw3y8f2dfgSKdKXWQPDHI4zQdUEO0kt5HFXma/QBzuClg8ORKg2KzO8s8
4bytBMkq9RasK2ov9fpreCDqb86sQlQOlwfjhn68t10Sa0EhWZT1Bi+XLDEG3qVO
pmtmxThe3ovYl3PzygEE1W9w86dyUiXl9yXFLevoSL6pRMANd4+hpk5T5p6pdEPA
1uGv4TJy2mE5dgnTrxkAlkWPFw3lUrnqCRKnHHk2RhHwlNktJ5Ui4EEoZOeYsrg9
UsRh9M2Ba/KJPSJd7mWOVKeOB3LNPaeyvkmjlAuRbOMBk5B39svbNLJs0HSG8SqT
GHDblUBWMXtVFLNgbTGSC5KCW2rfk6T5vjlJHiCluU1W4a4/jqYXQa0LDFcC++w9
pPfc+3wpZmEDjt7M9fz/4ZmuwM9IZfk0YEuLzMB7svKL5Vcd3KNpD2RgU62faldP
YUKov5dZRYDBDPJcSk6QBsFETpq1gmAgq8kwm9YGU6hPuKSa6Q+SWKRuNBT21goC
trJSgH3b3Srb6fHOsy8dc7MytdIF0xeYo4WfGCrxayR9W0j/AJM=
=0228
-----END PGP SIGNATURE-----

--n8BLGypXmCVn3V5XXPfPDGLrw1ihVWnpG--
