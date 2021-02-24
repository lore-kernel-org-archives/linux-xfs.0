Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A2E1C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 22:44:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48A8C64EDD
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 22:44:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235261AbhBXWof (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 17:44:35 -0500
Received: from sandeen.net ([63.231.237.45]:43804 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235246AbhBXWoc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Feb 2021 17:44:32 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 791EC22C5
        for <linux-xfs@vger.kernel.org>; Wed, 24 Feb 2021 16:43:31 -0600 (CST)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next branch updated to 533034dc / v5.11.0-rc1
Message-ID: <121af99c-7a5e-f5c8-9f32-0a59b9a973cb@sandeen.net>
Date:   Wed, 24 Feb 2021 16:43:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="T2wzuB5JsgGgfJM5AzRh7mKAGDfsWVZOa"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--T2wzuB5JsgGgfJM5AzRh7mKAGDfsWVZOa
Content-Type: multipart/mixed; boundary="tbykZUr856ZrfSvl7yQTG4nxIbp4v9WVd";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <121af99c-7a5e-f5c8-9f32-0a59b9a973cb@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next branch updated to 533034dc / v5.11.0-rc1

--tbykZUr856ZrfSvl7yQTG4nxIbp4v9WVd
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v5.11.0-rc1.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

HOWEVER, this is very close to the final release, so unless it's
urgent your patch will hit 5.12.

The new head of the for-next branch is commit:

533034dc (HEAD -> for-next, tag: v5.11.0-rc1, korg/for-next, refs/patches=
/for-next/5.11-rc1) xfsprogs: Release v5.11.0-rc1

New Commits:

Darrick J. Wong (17):
      [b71bedbf] xfs_admin: clean up string quoting
      [9e5ce7a2] xfs_admin: support filesystems with realtime devices
      [67b8ca98] xfs_db: report the needsrepair flag in check and version=
 commands
      [b95b770f] xfs_db: don't allow label/uuid setting if the needsrepai=
r flag is set
      [1acabf90] xfs_repair: fix unmount error message to have a newline
      [bbe6680f] xfs_repair: clear quota CHKD flags on the incore superbl=
ock too
      [a7348c58] xfs_repair: clear the needsrepair flag
      [3b7667cb] xfs_repair: set NEEDSREPAIR the first time we write to a=
 filesystem
      [704e4cef] libxfs: simulate system failure after a certain number o=
f writes
      [8e9f22d6] xfs_repair: factor phase transitions into a helper
      [7007b99f] xfs_repair: add post-phase error injection points
      [8780b4bd] man: mark all deprecated V4 format options
      [6b1a9a24] xfs_repair: allow upgrades on v5 filesystems
      [ab9d8d69] xfs_admin: support adding features to V5 filesystems
      [49c226a5] xfs_repair: enable inobtcount upgrade via repair
      [63bbaacf] xfs_repair: enable bigtime upgrade via repair
      [5f58bffa] man: document XFS_XFLAG_APPEND behavior for directories

Eric Sandeen (1):
      [533034dc] xfsprogs: Release v5.11.0-rc1

Gao Xiang (1):
      [060ea87a] mkfs: make use of xfs_validate_stripe_geometry()


Code Diffstat:

 VERSION                         |   2 +-
 configure.ac                    |   2 +-
 db/check.c                      |   5 +
 db/sb.c                         |  13 +++
 db/xfs_admin.sh                 |  15 +--
 doc/CHANGES                     |  21 ++++
 include/linux.h                 |  13 +++
 include/xfs_mount.h             |   5 +
 libxfs/init.c                   |  88 ++++++++++++++---
 libxfs/libxfs_api_defs.h        |   1 +
 libxfs/libxfs_io.h              |  19 ++++
 libxfs/rdwr.c                   |  10 +-
 man/man2/ioctl_xfs_fsgetxattr.2 |   1 +
 man/man8/mkfs.xfs.8             |  19 ++++
 man/man8/xfs_admin.8            |  53 ++++++++++
 mkfs/xfs_mkfs.c                 |  35 +++----
 repair/agheader.c               |  21 ++++
 repair/globals.c                |   5 +
 repair/globals.h                |   5 +
 repair/phase2.c                 |  93 ++++++++++++++++++
 repair/xfs_repair.c             | 210 ++++++++++++++++++++++++++++++++++=
++----
 21 files changed, 579 insertions(+), 57 deletions(-)


--tbykZUr856ZrfSvl7yQTG4nxIbp4v9WVd--

--T2wzuB5JsgGgfJM5AzRh7mKAGDfsWVZOa
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmA21qAFAwAAAAAACgkQIK4WkuE93uCv
4Q//YO3rvOv7K5UrbIdInJaI/ofPqtyIgGEe8u0V5VE9nXk6bBV2B5y4go5qTT9OCoKfpd16DQM7
zrQ6W8Tw7HGyrF8nti1cBZ/iN9EIpE4B06RN4C0JmfHHI3ofennzm5rNIYn85e8lv6MIgJYaESj7
bqH+UyFCXqPoh1/twlYhstNuVxKtF8/P0aPWHl5iOPQRJXnXK7S9iytYSpwUFFBL1hUEsIi/t1DD
6e/xjG3EShjp41QLIvzNdgD6H0AX6ff4iqRG50F+hybBBCRQFlMMhT2IJRzNnMxnTnrpqLYG3lhu
+NFRzQ14Yocg1rQWIxaUwtZtoo+pONTKoTA+pjQ6jao5nL2MJL4urY7+8ZexrEgBT7waFCQc8ltg
cKbvJkRCwCpsAz/+YdmXVX5ck5TuAHe1hfsqiY9XVoX0ffVtOW683S98MjP2ZNPxhRlBToO5typj
zqQdXmbaGayTj2oIH4ojtnFOLsBXnJYUPC728A1VJ4DPTMwgLmZk9LzX6MGjZLOibW1DWhAmt8Rr
WfI0//+NRRQQfgSV+sTrea27YhIBfYY/upkDl4zvRtiaccOp0GQG21dBBnrT9sQUR4gJaXl4rM1j
HGKWME6CWK+taIQAu4lKPPpS1Phe23PaG5f/g9zGcasPDJ+t09XiAdy4UOFmQRq93Klq0qF9R/NH
f+8=
=uPWu
-----END PGP SIGNATURE-----

--T2wzuB5JsgGgfJM5AzRh7mKAGDfsWVZOa--
