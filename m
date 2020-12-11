Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA1BC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 23:21:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A77782310E
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 23:21:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406883AbgLKW02 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Dec 2020 17:26:28 -0500
Received: from sandeen.net ([63.231.237.45]:55428 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406918AbgLKW0V (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Dec 2020 17:26:21 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B7CC411662
        for <linux-xfs@vger.kernel.org>; Fri, 11 Dec 2020 16:24:54 -0600 (CST)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v5.10.0 released, master branch updated to
 25d27711
Message-ID: <a4de41d3-6751-7227-0d20-e54aca182758@sandeen.net>
Date:   Fri, 11 Dec 2020 16:25:39 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JcXmxIVERjbnLIbwXj8IO5zlnQR1WHJl6"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JcXmxIVERjbnLIbwXj8IO5zlnQR1WHJl6
Content-Type: multipart/mixed; boundary="cfIncVSYdgIQZ6hzpRo3Mq8rnvllVDYD4";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <a4de41d3-6751-7227-0d20-e54aca182758@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v5.10.0 released, master branch updated to
 25d27711

--cfIncVSYdgIQZ6hzpRo3Mq8rnvllVDYD4
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The master branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and taggeged with v5.10.0

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

Condensed changelog follows:

xfsprogs-5.10.0 (11 Dec 2020)
        - xfs_repair: remove old code for mountpoint inodes (Anthony Ilio=
poulos)

xfsprogs-5.10.0-rc1 (04 Dec 2020)
        - xfsprogs: Add inode btree counter feature (Darrick Wong)
        - xfsprogs: Add bigtime feature for Y2038 (Darrick Wong)
        - xfsprogs: Polish translation update (Jakub Bogusz)
        - mkfs.xfs: Add config file feature (Dave Chinner)
        - mkfs.xfs: allow users to specify rtinherit=3D0 (Darrick Wong)
        - xfs_repair: simplify bmap_next_offset (Christoph Hellwig)
        - man: various manpage updates (Eric Sandeen)
        - libxfs: remove some old dead code (Dave Chinner)
        - libxfs: add realtime extent tracking (Darrick Wong)

xfsprogs-5.10.0-rc0 (17 Nov 2020)
        - libxfs changes merged from kernel 5.10

The new head of the master branch is commit:

25d27711 (HEAD -> for-next, tag: v5.10.0, korg/master, korg/for-next, ref=
s/patches/for-next/5.10.0-rinal) xfsprogs: Release v5.10.0

New Commits:

Anthony Iliopoulos (1):
      [92065bfd] xfs_repair: remove obsolete code for handling mountpoint=
 inodes

Eric Sandeen (1):
      [25d27711] xfsprogs: Release v5.10.0


Code Diffstat:

 VERSION          |  2 +-
 configure.ac     |  2 +-
 debian/changelog |  8 +++++++-
 doc/CHANGES      |  3 +++
 po/de.po         |  5 -----
 po/pl.po         |  5 -----
 repair/dinode.c  | 12 ------------
 repair/incore.h  |  1 -
 8 files changed, 12 insertions(+), 26 deletions(-)


--cfIncVSYdgIQZ6hzpRo3Mq8rnvllVDYD4--

--JcXmxIVERjbnLIbwXj8IO5zlnQR1WHJl6
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl/T8eMFAwAAAAAACgkQIK4WkuE93uCY
AQ/+MULOUCuxGT20JAeAPG+Xk3IBPvu8CcQcbT6Dt4Vmu/HXRY4SWbQ55yomWL/yWF6Zc07nGHnB
6lkNALT+rmFJ6Z7KaTS+SKfJJE5WvGs8exA+q5h38gXB7iFDfAUwfBPBDEqFpEVpg+KIHEocndG0
wMXf55WkWRPd5/swL8dEsrLJi7EqrZ1KCb4X2qZKV12thEASNxOX0+bgd3wAZk/4nzTRaZtNa0oU
dF6bcvr5JYEEgNExPmmHCemUYX+RAlAMIY6jyT+C1RIcdE2iaoksghd4trDyTNXKmEwJDKXpj2V3
GfLYSd+NxFyn5B7yCHsco+n5zBZNncp3K7nkOPKFpXls2LGcJ1ilJCR+jTG7PQs3nz810+/tVbx3
biDTHywG+gUgLmKO+nLc0DJdbSkaA2JYsWngUSN69lAcfMi7xXnZUVmg9K8cwCjNtirhDWIpG5Gn
F33SbS+naxV3uCPKhEOsCwKqSffbbPWf1xSu9OQCD39+CCg7iUs43vWU9bkMcX1yJcw1zNiY1ySP
BLrkr8rizHM9DO6bCN64jGZRNljf4wkpwEjhqTieH6fVV8lS5akMGAYVqZZQWSqpRldOc2j2Yxi2
o6mI2LhtFVzTWvAa/GJRIMcFVej/wYrVPpiTJSZfRrh6mtX5Fg+Oud38hr112MoxKD4RcfHWvXmH
/E0=
=1FcA
-----END PGP SIGNATURE-----

--JcXmxIVERjbnLIbwXj8IO5zlnQR1WHJl6--
