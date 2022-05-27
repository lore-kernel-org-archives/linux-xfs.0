Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5033C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 27 May 2022 20:52:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347857AbiE0UwC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 May 2022 16:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237744AbiE0UwC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 May 2022 16:52:02 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3BBC43C4BA
        for <linux-xfs@vger.kernel.org>; Fri, 27 May 2022 13:51:58 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id A2B6948FB;
        Fri, 27 May 2022 15:51:50 -0500 (CDT)
Message-ID: <f182471d-f4e1-744f-a487-a01063f67201@sandeen.net>
Date:   Fri, 27 May 2022 15:51:55 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Content-Language: en-US
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Cc:     Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Andrey Albershteyn <aalbersh@redhat.com>,
        Pavel Reichl <preichl@redhat.com>
Subject: [ANNOUNCE] xfsprogs-5.18.0-rc1 released
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------cKsJJK7upM0oUzvNiyu2zzf0"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------cKsJJK7upM0oUzvNiyu2zzf0
Content-Type: multipart/mixed; boundary="------------T0LUjXHIdnWLuXWtY7EQpAPA";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>, "Darrick J. Wong"
 <djwong@kernel.org>, Andrey Albershteyn <aalbersh@redhat.com>,
 Pavel Reichl <preichl@redhat.com>
Message-ID: <f182471d-f4e1-744f-a487-a01063f67201@sandeen.net>
Subject: [ANNOUNCE] xfsprogs-5.18.0-rc1 released

--------------T0LUjXHIdnWLuXWtY7EQpAPA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with xfsprogs-5.18.0-rc1

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please let me know, either by resubmitting them to
linux-xfs@vger.kernel.org or via other methods, so they can be
picked up in the next update.

The new head of the master branch is commit:

f6b82f45 xfsprogs: Release v5.18.0-rc1

New Commits:

Andrey Albershteyn (1):
      [0d376f6c] xfs_db: take BB cluster offset into account when using '=
type' cmd

Dave Chinner (4):
      [a196ca65] metadump: handle corruption errors without aborting
      [38feb6e5] metadump: be careful zeroing corrupt inode forks
      [7f6791f7] xfs_io: add a quiet option to bulkstat
      [69d66277] xfsprogs: autoconf modernisation

Eric Sandeen (1):
      [f6b82f45] xfsprogs: Release v5.18.0-rc1

Pavel Reichl (1):
      [8b4002e0] mkfs: Fix memory leak


Code Diffstat:

 VERSION               |   2 +-
 configure.ac          |   8 +--
 db/io.c               |  13 ++++-
 db/metadump.c         | 143 +++++++++++++++++++++++++++-----------------=
-
 doc/CHANGES           |  23 ++++++++
 io/bulkstat.c         |   9 ++-
 m4/package_attr.m4    |   8 ++-
 m4/package_libcdev.m4 | 158 +++++++++++++++++++++++++++++++-------------=
------
 m4/package_types.m4   |   8 ++-
 m4/package_urcu.m4    |  18 +++---
 man/man8/xfs_io.8     |   6 +-
 mkfs/xfs_mkfs.c       |   1 +
 12 files changed, 257 insertions(+), 140 deletions(-)

--------------T0LUjXHIdnWLuXWtY7EQpAPA--

--------------cKsJJK7upM0oUzvNiyu2zzf0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmKROesFAwAAAAAACgkQIK4WkuE93uAT
rxAAheNlipKoJ6do8rsTRCylH5cEccgHfwNY0z64flj1nLJeooScm9mC1gX5r3grDk1YG01wITCa
1GYBwqr+RnL7IiBSEvY4DznPjDBr0qGAij4cPUiHSagPdme2OHg+4eHQDze9oPxIYiv5wmZ3vA2r
93MF+pl+Yk5met0xkh9nkjFAZACg0qS4tWIqrFdYVqrM+keAAx/5jp81qhJSVee6FhQg5pWn5HyK
CzLYphyMF45vXTG+sVOMtgag/KR2o1wmHntTvVwcLuicwSYDICBJkZMVLRlSi+G1IQv16JAN2wA3
QABGZCS0zgbuQ4mY7Va7iR3z3oYm546F10csJfN0BnX/yrCnGaZZaiJ0SP9qVppRgMptB8Ra799y
q2otQQIC0aDSh1n1kcOzP3vsLfb1Hww8rsdc8hOBgVPBRQL30YVK215MkmztPhgnbkkharvit6zZ
VZQZ5FAFM/flMP13w1HSqOxgR6/b/2VRjAdePeIXJkkK10Jhz5nKhgtllIfpN54bFxmI6a/736eJ
CsBOR6Kr7ipb+vTtt/ldGd/s/gOdryXJuMWJ6k8US64ikLW55aLbVWOH9po1mKmstyPlsBh/9Y0d
3zweASDBNe4zdPZwD7mKQA4Li5f9UKQU8kk2bdLw8R3GkPeDi7xoYlTaCJetnn7zBY2++dJh019k
FLk=
=Y3vj
-----END PGP SIGNATURE-----

--------------cKsJJK7upM0oUzvNiyu2zzf0--
