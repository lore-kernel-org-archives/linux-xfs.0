Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FA24C04FF3
	for <linux-xfs@archiver.kernel.org>; Fri, 21 May 2021 21:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48601613EC
	for <linux-xfs@archiver.kernel.org>; Fri, 21 May 2021 21:22:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhEUVXm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 May 2021 17:23:42 -0400
Received: from sandeen.net ([63.231.237.45]:54350 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhEUVXm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 May 2021 17:23:42 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 943485382DB
        for <linux-xfs@vger.kernel.org>; Fri, 21 May 2021 16:21:44 -0500 (CDT)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs 5.12.0-rc1 released
Message-ID: <3eacd030-f945-62bd-ec7f-cf6dc07d45cc@sandeen.net>
Date:   Fri, 21 May 2021 16:22:16 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="omQrMnU4XiIYajHysZT6A8tN80AZ5udIU"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--omQrMnU4XiIYajHysZT6A8tN80AZ5udIU
Content-Type: multipart/mixed; boundary="P2RU1xamLwlLIecpDHpUbDbdPMrb9oGYD";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <3eacd030-f945-62bd-ec7f-cf6dc07d45cc@sandeen.net>
Subject: [ANNOUNCE] xfsprogs 5.12.0-rc1 released

--P2RU1xamLwlLIecpDHpUbDbdPMrb9oGYD
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The master branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with 5.12.0. There are no changes from -=
rc1.

Tarballs are available at:

https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.12.0.ta=
r.gz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.12.0.ta=
r.xz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.12.0.ta=
r.sign

The new head of the master branch is commit:

3e384caa (HEAD -> for-next, tag: v5.12.0) xfsprogs: Release v5.12.0

The condensed changelog since 5.11.0 is:

xfsprogs-5.12.0-rc1 (07 May 2021)
        - mkfs: don't default to too-large physical sector size (Jeff Moy=
er)
        - repair: phase 6 speedups (Dave Chinner, Gao Xiang)
        - man: Add dax mount option to man xfs(5) (Carlos Maiolino)
        - xfs_admin: pick up log arguments correctly (Darrick Wong)
        - xfs_growfs: support shrinking unused space (Gao Xiang)
        - libfrog: report inobtcount in geometry (Darrick Wong)
        - xfs_logprint: Fix buffer overflow printing quotaoff (Carlos Mai=
olino)
        - xfsprogs: include <signal.h> for platform_crash (Leah Neukirche=
n)
        - xfsprogs: remove BMV_IF_NO_DMAPI_READ flag (Anthony Iliopoulos)=

        - workqueue: bound maximum queue depth (Dave Chinner)

xfsprogs-5.12.0-rc0 (12 Apr 2021)
        - libxfs changes merged from kernel 5.12

New Commits:

Eric Sandeen (1):
      [3e384caa] xfsprogs: Release v5.12.0


Code Diffstat:

 VERSION          | 2 +-
 configure.ac     | 2 +-
 debian/changelog | 6 ++++++
 doc/CHANGES      | 3 +++
 4 files changed, 11 insertions(+), 2 deletions(-)


--P2RU1xamLwlLIecpDHpUbDbdPMrb9oGYD--

--omQrMnU4XiIYajHysZT6A8tN80AZ5udIU
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmCoJIkFAwAAAAAACgkQIK4WkuE93uCI
9xAAq0YJUl9efoqxrFx1R6/XyBBJQHHhbOCHoV6sOGz0r24ENbJsHx9RdWs3T3hKihwPyx4nOrR9
s9/cRuEDZa/SOXHX1+iOp7ZaPc4+ZmcORvsQABx/gE97rscs8ELVTyR5Gr8wce6eaclTpLzbKpd2
ULGNvFtTNR0KJ46o9azBYJ/HoDCAG5iZyKxyrynYuKrkhYwvENihe2sq+NNonfuTlzE6XgebZjA6
IKscQRgFM/Po3XyT91e9+cKDguLJVBBA260MsewAwfBJnsC0GNGUZCROPB0KbUMX2hu+gPUr9NOQ
MyxunyaGtVcf9ViVQfFUlCHobrP7am7IRkc8hcPGRvOglXuMBDdqs10GYHUlHVTQJF0Rs7+Od0va
QMziuf/I2VsaZ+JzH9vVEwDg/BhCLd1csVZHkrHhuUcESctlKutF7qGDOzpDprv8Y0Xd+sryvuEk
Xc4iYroqvPJkN59ByE7BiqVVbZx2kJ8KXE3KZWqlXrsbPic2V2yiBkf9V7H5R0IbPb2ZnhHyPJxL
Be8/RQyYaRfIyUEaFK1uqdwc/ToVQCWszLgQ9UcGamj39qWf06z3JXb7mvdQENhDATr7BYbSqcWL
MUePrGQbzDr5qSC2EhNnX4l6faIKNU4TmqZh2x66lovOFXLr2DUdyR4WFr5pD2BB8U86cQzcit+3
FFE=
=2CAr
-----END PGP SIGNATURE-----

--omQrMnU4XiIYajHysZT6A8tN80AZ5udIU--
