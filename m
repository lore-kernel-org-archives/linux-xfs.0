Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA04C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Mar 2022 18:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345129AbiCKSh0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Mar 2022 13:37:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbiCKShZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Mar 2022 13:37:25 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 98F84D3AE7
        for <linux-xfs@vger.kernel.org>; Fri, 11 Mar 2022 10:36:18 -0800 (PST)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id C5BC1490B
        for <linux-xfs@vger.kernel.org>; Fri, 11 Mar 2022 12:35:02 -0600 (CST)
Message-ID: <f2ff49db-9a85-1303-c268-3d9f035c2418@sandeen.net>
Date:   Fri, 11 Mar 2022 12:36:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-Language: en-US
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs-5.15.0-rc1 released
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------9JZJfTYHJwoaz9TXf050vTD7"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------9JZJfTYHJwoaz9TXf050vTD7
Content-Type: multipart/mixed; boundary="------------5uG9Wem0eqV10TpEHEbMJgh5";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <f2ff49db-9a85-1303-c268-3d9f035c2418@sandeen.net>
Subject: [ANNOUNCE] xfsprogs-5.15.0-rc1 released

--------------5uG9Wem0eqV10TpEHEbMJgh5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v5.15.0-rc1

This is close to (finally!) v5.15.0 final, though I hope to get
Darrick's log size change in before it's done, as switching feature
defaults at the same time as the log size change feels ... tidy.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

6b4ec98f (HEAD -> for-next, tag: v5.15.0-rc1, korg/master, korg/for-next,=
 refs/patches/for-next/5.15.rc0.1) xfsprogs: Release v5.15.0-rc1

New Commits:

Darrick J. Wong (3):
      [1e7212c8] xfs_scrub: report optional features in version string
      [d6febe33] xfs_scrub: fix reporting if we can't open raw block devi=
ces
      [a3e22408] mkfs: add a config file for x86_64 pmem filesystems

Eric Sandeen (6):
      [3cd200ff] xfs_quota: document unit multipliers used in limit comma=
nd
      [d8913327] mkfs.xfs(8): remove incorrect default inode allocator de=
scription
      [c10023e4] xfs_quota: don't exit on fs_table_insert_project_path fa=
ilure
      [12518245] xfs_repair: don't guess about failure reason in phase6
      [069610ec] xfs_quota: fix up dump and report documentation
      [6b4ec98f] xfsprogs: Release v5.15.0-rc1


Code Diffstat:

 VERSION                |  2 +-
 configure.ac           |  2 +-
 doc/CHANGES            | 18 ++++++++++++++++++
 libfrog/paths.c        |  8 ++------
 libfrog/paths.h        |  2 +-
 man/man8/mkfs.xfs.8.in | 19 ++++++-------------
 man/man8/xfs_quota.8   | 18 ++++++++++++++++--
 mkfs/Makefile          |  1 +
 mkfs/dax_x86_64.conf   | 19 +++++++++++++++++++
 quota/project.c        | 10 ++++++++--
 quota/report.c         | 10 ++++------
 repair/phase6.c        | 30 +++++++++---------------------
 scrub/phase1.c         | 20 +++++++++++---------
 scrub/xfs_scrub.c      | 26 ++++++++++++++++++++++----
 14 files changed, 119 insertions(+), 66 deletions(-)
 create mode 100644 mkfs/dax_x86_64.conf

--------------5uG9Wem0eqV10TpEHEbMJgh5--

--------------9JZJfTYHJwoaz9TXf050vTD7
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmIrlqAFAwAAAAAACgkQIK4WkuE93uCm
kBAAsB76mL73PbfIM8plruqNW0h+/4EBzW0pdtAHL7Iqtgc1LSyEk3x3lY0bKdCcW6qK3O3OGoDu
EMN+aFct8hzSmA0V/PmHunI64xKYyybD9Af56cGLaMZEQ0L9nK1vXrecrTw151AojciK4bt3SrPu
ihjE8jpi+PEZGIsGaB6WqNazUimhHWl9wtEWvznl85kcoxe2UZQP5v28fTmLUYFD6ddUliP1JJg+
qqXGy4CqCe/3D/Cx8anlNjK4odPu72pjRq43UsNFJNHDpjVMnAh/+C4ESvqD8mdLGU56eDigiscP
ydEN3yd22LOVuZZKgxcdHBep9bAIPPkGDkJsr0McMoTasi1EX2QmnxqNVVbq3aNjvUaLGZzhc+m0
pipgKQN8lPOwPOxQPPhqyvTdD9Gwk8xq0IsF33Po3y2EvXT9ZX8jMmaB41kkpwddJADpqmtTgjaK
luY04jJKmBCL+1O5JDSh8DWXhxpQQV3Yzb4o575xjjkQY3KLj11IYGwMWLPz9oMT0urew7MYLDgs
H/wpgAm8z/OdY4llAAQv3WvXR3D4zTNmDyBAiYt4vQOdlEGQRqyTevjyCq0VomuL+1TXzIhwKoFE
hPDw2XbeAJps8yimAulGhZWEGm9nDdMhwj+552+pKkgnsVej2IH3Y4yJLk6FhGIFuYvrD0+gDaSK
j2Y=
=QCZX
-----END PGP SIGNATURE-----

--------------9JZJfTYHJwoaz9TXf050vTD7--
