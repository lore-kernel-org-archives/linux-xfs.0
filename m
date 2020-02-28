Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91A9AC3F2CF
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 04:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66A17246AA
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 04:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730793AbgB1EXi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 23:23:38 -0500
Received: from sandeen.net ([63.231.237.45]:33124 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730780AbgB1EXi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Feb 2020 23:23:38 -0500
Received: from Liberator.local (unknown [4.28.11.152])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id D08AD11664
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 22:23:09 -0600 (CST)
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
To:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfsprogs for-next updated to fbbb184b
Message-ID: <adc5d23f-92d2-2dcc-5957-adb69f87cf4b@sandeen.net>
Date:   Thu, 27 Feb 2020 20:23:35 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iR2XZ5YDP7BTLaA3KybtbIujxN86FYaaV"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iR2XZ5YDP7BTLaA3KybtbIujxN86FYaaV
Content-Type: multipart/mixed; boundary="iV5jfGeO7ACiPQ6BCJSRar6JQ48ooDt72"

--iV5jfGeO7ACiPQ6BCJSRar6JQ48ooDt72
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

fbbb184b (HEAD -> for-next) xfs_repair: join realtime inodes to transacti=
on only once

New Commits:

Darrick J. Wong (13):
      [8d6ce222] libxfs: re-sort libxfs_api_defs.h defines
      [33c692a2] libfrog: remove libxfs.h dependencies in fsgeom.c and li=
nux.c
      [97282ffb] xfs_repair: refactor attr root block pointer check
      [471f0ab6] xfs_repair: don't corrupt a attr fork da3 node when clea=
ring forw/back
      [017e979e] xfs_repair: replace verify_inum with libxfs inode valida=
tors
      [659a4358] mkfs: check root inode location
      [b1f7ac05] xfs_repair: enforce that inode btree chunks can't point =
to AG headers
      [a3e126aa] xfs_repair: refactor fixed inode location checks
      [90b2397e] xfs_repair: use libxfs function to calculate root inode =
location
      [ded6b558] xfs_repair: check plausibility of root dir pointer befor=
e trashing it
      [306b450b] xfs_repair: try to correct sb_unit value from secondarie=
s
      [a9468486] libxfs: clean up libxfs_destroy
      [38abdcbd] xfs_scrub: fix reporting of EINVAL for online repairs

Eric Sandeen (3):
      [6bd73d16] xfs_repair: fix bad next_unlinked field
      [9d6023a8] libxfs: use FALLOC_FL_ZERO_RANGE in libxfs_device_zero
      [fbbb184b] xfs_repair: join realtime inodes to transaction only onc=
e


Code Diffstat:

 copy/xfs_copy.c          |   2 +-
 db/init.c                |   8 +-
 include/builddefs.in     |   3 +
 include/libxfs.h         |   2 +-
 include/linux.h          |  22 ++++
 libfrog/fsgeom.c         |   4 +-
 libfrog/linux.c          |   4 +-
 libxfs/init.c            |  31 ++++--
 libxfs/libxfs_api_defs.h |  12 ++-
 libxfs/rdwr.c            |  15 ++-
 mkfs/xfs_mkfs.c          |  46 +++++---
 repair/attr_repair.c     | 193 +++++++++++++++++++++------------
 repair/dino_chunks.c     |   2 +-
 repair/dinode.c          |  47 ++++----
 repair/dinode.h          |   4 -
 repair/dir2.c            |   7 +-
 repair/globals.c         |   6 --
 repair/globals.h         |   6 --
 repair/phase4.c          |  12 +--
 repair/phase6.c          |  12 +--
 repair/scan.c            |  23 ----
 repair/xfs_repair.c      | 272 ++++++++++++++++++++++++++---------------=
------
 scrub/scrub.c            |   5 +-
 23 files changed, 416 insertions(+), 322 deletions(-)


--iV5jfGeO7ACiPQ6BCJSRar6JQ48ooDt72--

--iR2XZ5YDP7BTLaA3KybtbIujxN86FYaaV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl5YlcgACgkQIK4WkuE9
3uC5VA//ZesDP8WZAyMs/AfVJ+gpGjA+DkFJZDZ4VULBh5mFs2u6+S4DFHO65ep+
M/qlzaIJNGyyYns4yjVuncban6gjsgN0yQ3350yl/SWN4iJgFu5c+qnDQHcDvtQM
KmjtSPjjN1NIJWX8ye5kYGnIwru+7LuuMOgEeg0bIo4cKQm3htKFFoM0vttuzVMX
7kt1NzMOZ847FNqt9OxBoGjJQn4jVGI+k8IzUsWaJj3+P1Q1F8sD4Kv5CBHPMQr3
oHmwZjSCnCT973SrlMGPrhZsIQGzGEz7myZLAWa68rJPufwOXOYCeOcraWSSYTes
EhciMx6oZ7pXMKZ5PtyPRSCW89Nv+uj4/Vv1iIOPuLLzUZMag3I1E3t0qDJ4pV2G
+aWfTCJFGn8F5ZCTYksdgSM+xD5RxMWJ17F3mE1WN8Oo1llMZIj43N4ogEtzPZkK
oicEHWp/n5xh9/vC6+Uu4azAzKQC/hQabCT/kjXIb6uZY2qUuShwvAxLbVaDVfBy
EwtLzEKjxEnjqTXMASjTBHd0CzV/9vucPnY+ck9cUzr0qAWlfb8c/gNXiCxHRKUt
6/AJxOXjMc7prxkt2xUE/S69Q26G92KkuYHIPU9jYkDJsMoNZDwJDly5b+hQgtKD
G2thvojiOTfkdJXubhj4LKxYJvomTL4op3WMP6eNPXRpXWa58Ro=
=tT+6
-----END PGP SIGNATURE-----

--iR2XZ5YDP7BTLaA3KybtbIujxN86FYaaV--
