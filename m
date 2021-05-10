Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C002C43603
	for <linux-xfs@archiver.kernel.org>; Mon, 10 May 2021 15:05:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE5C761482
	for <linux-xfs@archiver.kernel.org>; Mon, 10 May 2021 15:05:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241685AbhEJPGu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 May 2021 11:06:50 -0400
Received: from sandeen.net ([63.231.237.45]:34770 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233789AbhEJPEM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 May 2021 11:04:12 -0400
Received: from liberator.local (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 6DB17615D6D
        for <linux-xfs@vger.kernel.org>; Mon, 10 May 2021 10:02:41 -0500 (CDT)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs 5.12.0-rc1 released
Message-ID: <c9946e72-8766-8774-7d75-f56f365599d4@sandeen.net>
Date:   Mon, 10 May 2021 10:02:56 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="oUbHEH1CCpo7VsWy9W0PLZw8BBbwsX7OC"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oUbHEH1CCpo7VsWy9W0PLZw8BBbwsX7OC
Content-Type: multipart/mixed; boundary="E8S00hOVLG3rYYBQ7E8DFLuIKRSSTTJ5c";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <c9946e72-8766-8774-7d75-f56f365599d4@sandeen.net>
Subject: [ANNOUNCE] xfsprogs 5.12.0-rc1 released

--E8S00hOVLG3rYYBQ7E8DFLuIKRSSTTJ5c
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The master branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with 5.12.0-rc1.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

8d943b34 (HEAD -> for-next, tag: v5.12.0-rc1) xfsprogs: Release v5.12.0-r=
c1

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

New Commits since the last update announcement:

Darrick J. Wong (2):
      [28927ccb] mkfs: reject cowextsize after making final decision abou=
t reflink support
      [d625f741] libxfs: copy crtime correctly now that it's timespec64

Eric Sandeen (1):
      [8d943b34] xfsprogs: Release v5.12.0-rc1

Code Diffstat:

 VERSION         |  2 +-
 configure.ac    |  2 +-
 doc/CHANGES     | 12 ++++++++++++
 libxfs/util.c   |  3 +--
 mkfs/xfs_mkfs.c | 14 +++++++-------
 5 files changed, 22 insertions(+), 11 deletions(-)






--E8S00hOVLG3rYYBQ7E8DFLuIKRSSTTJ5c--

--oUbHEH1CCpo7VsWy9W0PLZw8BBbwsX7OC
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmCZSyAFAwAAAAAACgkQIK4WkuE93uBd
/A//SpDl6V2x/gTzBmWni75pOXNdtWGYvhpF6iUnOVWlq6lbTkG+sQveH/S6xVa43XAhZVdv2z86
2mTRDdd7n2//Ss/epGRgPre1lXtwUwks7UTvWTZRBXo/t7QUPdSCLnT5Ysukrg6OoxTKf0hQp/FU
lz6X1kaNtP6I5e2Qoq7T5/ExEpy2mCU+Mgo1gmwTsqB61u0qAqzbVOHQhdp6UOTCw8k9hLf+6sbV
JKVvUr2G8rHkiV3Zkc9ZsF+P2B/vLGF1Ug9p7m5j2g0WCAFA+uiLTJ166dB9ciHjn0ZGZThffSRh
Ddzn5Bmmsq9OUWPGHhkHVQNbBR4DJMpn9Oj01Or+JATChMXpb76qIMxyyXvX39fSpWqavihxtgoX
UaEoc0Rba0StsE6dWmWj2tn71BqGoVIkrE0eJIx+KFWNVYEKq+8Kjap9wr1qMlWNBptDV99VDKW7
xVXO2L7QR6/arT6makQQy6I9bfD5BtrCDC5cImSf2ZhNxXTs4UGi25I9bjc0Rfq4mPP+tMIxouGj
yAVnTPc26lmyJz4yOhQZ7rTh/pbUIAEDC8r9GF7McRXLI41bn0uoB077ZI6zuplmVylOxd/8aMso
NKF2LhPQNeoK2xTxBDMoSA1/aXKeAPSZysavP1p8UGXLcwhzoung/cuwzol5XmoUv9t69VjW2LFB
9k4=
=YV6E
-----END PGP SIGNATURE-----

--oUbHEH1CCpo7VsWy9W0PLZw8BBbwsX7OC--
