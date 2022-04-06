Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D88B2C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 21:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234895AbiDFVvX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 17:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235721AbiDFVvE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 17:51:04 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0FC667C7AF
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 14:40:11 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 9B2817BC4
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 16:38:16 -0500 (CDT)
Message-ID: <21a805e0-3613-9a6b-4c19-49d92908258c@sandeen.net>
Date:   Wed, 6 Apr 2022 16:40:09 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-Language: en-US
From:   Eric Sandeen <sandeen@sandeen.net>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfsprogs-5.15.0 released
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------gt0NeuSuxhMeJBMzF4B14jeL"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------gt0NeuSuxhMeJBMzF4B14jeL
Content-Type: multipart/mixed; boundary="------------ih8QlLKABuiFmPZrUYRc6lrj";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <21a805e0-3613-9a6b-4c19-49d92908258c@sandeen.net>
Subject: [ANNOUNCE] xfsprogs-5.15.0 released

--------------ih8QlLKABuiFmPZrUYRc6lrj
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged for a v5.15.0 release. The condensed cha=
ngelog
is below, with changes since -rc1 after that.

Notable behavioral changes include inobtcount and bigtime (Y2038 compatib=
ility)
by default, as well as larger log sizes for smallish filesystems.

Tarballs are available at:

https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.15.0.ta=
r.gz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.15.0.ta=
r.xz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.15.0.ta=
r.sign

The new head of the master branch is commit:

19ee1446 (HEAD -> for-next, tag: v5.15.0, korg/master, korg/for-next) xfs=
progs: Release v5.15.0

xfsprogs-5.15.0 (06 Apr  2022)
        - mkfs: increase the min log size to 64MB when possible (Eric San=
deen)
        - xfs_scrub: retry items that are ok except for XFAIL (Darrick J.=
 Wong)
        - xfs_scrub: fix xfrog_scrub_metadata error reporting (Darrick J.=
 Wong)

xfsprogs-5.15.0-rc1 (11 Mar 2022)
        - mkfs: enable inobtcount and bigtime by default (Darrick J. Wong=
)
        - mkfs: prevent corruption of suboption string values (Darrick J.=
 Wong)
        - mkfs: document sample configuration file location (Darrick J. W=
ong)
        - mkfs: add configuration files for a few LTS kernels (Darrick J.=
 Wong)
        - mkfs: add a config file for x86_64 pmem filesystems (Darrick J.=
 Wong)
        - xfs_quota: don't exit on "project" cmd failure (Eric Sandeen)
        - xfs_repair: don't guess about failure reason in phase6 (Eric Sa=
ndeen)
        - xfs_repair: update 2ndary superblocks after upgrades (Darrick J=
=2E Wong)
        - xfs_scrub: fix reporting if we can't open devices (Darrick J. W=
ong)
        - xfs_scrub: report optional features in version (Darrick J. Wong=
)
        - libxcmd: use emacs mode for command history editing (Darrick J.=
 Wong)
        - libfrog: always use the kernel GETFSMAP definitions (Darrick J.=
 Wong)
        - mkfs.xfs(8): fix default inode allocator description (Eric Sand=
een)
        - xfs_quota(8): fix up dump and report documentation (Eric Sandee=
n)
        - xfs_quota(8): document units in limit command (Eric Sandeen)
        - misc: add a crc32c self test to mkfs and repair (Darrick J. Won=
g)

xfsprogs-5.15.0-rc0 (03 Feb 2022)
        - libxfs changes merged from kernel 5.15

New Commits:

Darrick J. Wong (2):
      [d9869446] xfs_scrub: fix xfrog_scrub_metadata error reporting
      [882082d5] xfs_scrub: retry scrub (and repair) of items that are ok=
 except for XFAIL

Eric Sandeen (2):
      [cdfa467e] mkfs: increase the minimum log size to 64MB when possibl=
e
      [19ee1446] xfsprogs: Release v5.15.0


Code Diffstat:

 VERSION                 |  2 +-
 configure.ac            |  2 +-
 debian/changelog        |  6 ++++++
 doc/CHANGES             |  5 +++++
 include/xfs_multidisk.h |  2 --
 mkfs/xfs_mkfs.c         | 41 +++++++++++++++++++----------------------
 scrub/scrub.c           | 33 ++++++++++++++++++++++++++++++---
 7 files changed, 62 insertions(+), 29 deletions(-)

Thanks for your patience.
Sincerely, the well-that's-a-bit-late department.

--------------ih8QlLKABuiFmPZrUYRc6lrj--

--------------gt0NeuSuxhMeJBMzF4B14jeL
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmJOCLkFAwAAAAAACgkQIK4WkuE93uCM
3g//bEfLUm4kmc6ydGgtTMxC3McH2YQY1/b5J0QKyiqdCtmDEPw8w+j+TrxWWZ3xW6sjLVaLhjQ5
QTQlIOdCIfMzcpvYOv+rQ8/RQOk4ePuURH9cZcnPfGJTDtvjBaShs+aPgL8gLpCCXMcqtBfHsoTj
8JuRMC+J8cxbiQlvpgHY00kkcm/arMjNxxl9RKLG9DOw5uE28Q8N+BKuME+9r5oWQ8GBgPCVNJgP
xqgmZmUZkB/Bn397rT6c5l5emHgZVdDx+KNsUOkTeVrRRmvuZLxCjoDNCnERddkDS1pLNVEs/b/8
xJ17LR6fA0DmK/JfbOEvGpSt6M918RqQjDm0jpG0idKzK2PRti+TA709HBuvn5ppObQljDoqU0mi
EMv8CqLQBKgnr1KTnhNHVV2owvKrWxKn1uFKWnUg+By8XFLB4JYVyudNknfmMaSWXmWZkHVt2+Uw
jtT05R+9VR5tlJPW77Oulk+pLklOfRHjJNGDtyMHCUClhTlq+9/KT5c+hYpxbq7pYb1UA0s7xkk0
1y3Jiw0aUOrYDOgelG/BI22lBpnoltLHsdeAUS2YdYXy6OFCGn7FmFmm36ovDSjVCGgb3ez9ileD
nF5tLzN9cr98hxI26Q5/GjEB4O7P7QoogFEwxidzxJIGHSPDe0GT+Tw4cPavch4DdyRyZ5Uq7jeQ
CsY=
=UU+3
-----END PGP SIGNATURE-----

--------------gt0NeuSuxhMeJBMzF4B14jeL--
