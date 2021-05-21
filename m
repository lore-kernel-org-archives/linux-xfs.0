Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 170C6C04FF3
	for <linux-xfs@archiver.kernel.org>; Fri, 21 May 2021 21:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1F50613EC
	for <linux-xfs@archiver.kernel.org>; Fri, 21 May 2021 21:26:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhEUV1X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 May 2021 17:27:23 -0400
Received: from sandeen.net ([63.231.237.45]:54498 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhEUV1X (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 May 2021 17:27:23 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 42C225382DB
        for <linux-xfs@vger.kernel.org>; Fri, 21 May 2021 16:25:25 -0500 (CDT)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs 5.12.0 released
Message-ID: <6a17d605-5cd0-d900-4e5b-f6f17e73cade@sandeen.net>
Date:   Fri, 21 May 2021 16:25:58 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Sd3azt9AfNBG0MZhLQ4wiVftHi6sHhKUb"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Sd3azt9AfNBG0MZhLQ4wiVftHi6sHhKUb
Content-Type: multipart/mixed; boundary="kq8h1wLlaOBiHfCV812dHMlSPEYFreIV8";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <6a17d605-5cd0-d900-4e5b-f6f17e73cade@sandeen.net>
Subject: [ANNOUNCE] xfsprogs 5.12.0 released

--kq8h1wLlaOBiHfCV812dHMlSPEYFreIV8
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

(You already knew 5.12.0-rc1 was released, and it's still true! but let's=

try that again with the correct subject...)

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



--kq8h1wLlaOBiHfCV812dHMlSPEYFreIV8--

--Sd3azt9AfNBG0MZhLQ4wiVftHi6sHhKUb
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmCoJWYFAwAAAAAACgkQIK4WkuE93uCC
Og//b3ixbh9t3CNDSpYARkdCDZO7pUUIuzFf/Q45coLUQZIIdDaTzJuucw8ZA7kUQvH2NT5HXcHC
Fo0cA7A8oPP9hPa5vBc1jxtWTdC99EzyQmr1ZHgxivi/DeiNdTOk1UDcyvfpLn2EjtkSzmEnTcJg
+Jo871LlEMXl9lrpq3Y9GK7RQXHqOp1mdvjzi0ipSxiZuo/aArUJr0uhE+AIVBOromef6FGymC1n
OmkhV5jfdNg4GZXelkQg5MQATioAenwlGbUWMGmTuU20Wh35L8scoFnSOWO39G9Y13d0y+wegAFe
Ap7JFz+9K+1lOpq85pV6thjKBcNy4bzj7OjXuJTXAmTL3VqPTGPhw3+0unIVrNBuFd2quW4UIYD/
vP6YajnVtFJ81QqnvqqTo9tXmXM7bUZKfpHCVK3dRjEE50RPW5fD9filB1Qm7q8Lt4IVmElSfASp
FJQxn8ADjicb6Ztr12EMHYgtwAWHPyG2IMaCh8OYzoMMtLk0IK19ZwgWFBIzo0Q/C29qgl5NxUri
sUqVkp9LFPjBPMNMaTD8lUWNSYrT2KEEtVnYt4eY7AibtzJRdR+jD7BoGMR86bKNjSGPpztf4WnT
rFceCHF2ksc02+SvRI5w2ARhs4Lh6oldD8L0/G/VxzyaDrIP+Ag0YZNAVM3FR+cz7WC9OitAo/Ju
DpM=
=tx6I
-----END PGP SIGNATURE-----

--Sd3azt9AfNBG0MZhLQ4wiVftHi6sHhKUb--
