Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 695F7C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  4 May 2022 19:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237727AbiEDTZh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 May 2022 15:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234639AbiEDTZg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 May 2022 15:25:36 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DE3BA4B40C
        for <linux-xfs@vger.kernel.org>; Wed,  4 May 2022 12:21:59 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id C9396490B;
        Wed,  4 May 2022 14:21:25 -0500 (CDT)
Message-ID: <a75d431e-882e-10e6-3f20-0378da8dc7a5@sandeen.net>
Date:   Wed, 4 May 2022 14:21:57 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Content-Language: en-US
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Cc:     Bastian Germann <bastiangermann@fishpost.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>
Subject: [ANNOUNCE] xfsprogs 5.16.0 released
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Cmvv0EeRQpjdbsYND0hq7Op7"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Cmvv0EeRQpjdbsYND0hq7Op7
Content-Type: multipart/mixed; boundary="------------KTzZa4YYaikFR2eIggL0jadf";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Cc: Bastian Germann <bastiangermann@fishpost.de>,
 "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <dchinner@redhat.com>
Message-ID: <a75d431e-882e-10e6-3f20-0378da8dc7a5@sandeen.net>
Subject: [ANNOUNCE] xfsprogs 5.16.0 released

--------------KTzZa4YYaikFR2eIggL0jadf
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged for a v5.16.0 release. The condensed cha=
ngelog
is below.

This release is almost 100% a libxfs sync. I'm trying to catch up, and th=
e=20
next release will be 5.18.0-rc0, with both 5.17 and 5.18 libxfs changes s=
ynced.
(there are very few).

At that point I'll finally start pulling in more functional changes.

Tarballs are available at:

https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.16.0.ta=
r.gz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.16.0.ta=
r.xz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.16.0.ta=
r.sign

The new head of the master branch is commit:

4cafd8fa (HEAD -> for-next, tag: v5.16.0, korg/master, korg/for-next, ref=
s/patches/for-next/v5.16.0) xfsprogs: Release v5.16.0

xfsprogs-5.16.0 (04 May 2022)
        - libxfs: remove kernel stubs from xfs_shared.h (Eric Sandeen)
        - debian: Generate .gitcensus instead of .census (Bastian Germann=
))

xfsprogs-5.16.0-rc0 (28 Apr 2022)
        - libxfs changes merged from kernel 5.16



--------------KTzZa4YYaikFR2eIggL0jadf--

--------------Cmvv0EeRQpjdbsYND0hq7Op7
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmJy0lUFAwAAAAAACgkQIK4WkuE93uCf
LA/6A1sJZy+RTZh71sYAZRfG3v6Y9BYhQCAmjS0wmU5ohxNE6xhpLsSq493mFJP0MD1j2ZeHuUXz
aIe7CyGO22Y+rBOujDi6233D8KZqW9tJZ+qzibzXQhRw1OTuRCVa96GTYhCFlcsBz/gy9ydddrWP
zDQe4nBcf8AJeB4L+RAZVkN1W7aczAoVH76TGw9YxgAQGntsX26oASI9uweCXI6lvAdx8pp7I29M
jdNPkykRZRU8+kxQHSZ7wLZSk04Ea27Hsrktr6BlxHqoY6Eo3tBRDOgy15KnhKUWTO9y2rewpzBO
w2+vFgYk3SRd/q7zxxyNlMdEiO2Azg43EbZzqRyF0v9JjwfXa1I2S9VIBTh4XuyiUYv9fHyQr6c3
muXXIIKAvoJ9J6BqLVdgAJkQul1erRhE0E10oejnkwEqaGRx3W26XdVwLpQ5nOdnKNEKUqX29LKZ
/nNLquZSkRKJyBrMoK6lKNTe5oGBB5mh+8zAYPmH3nJ8NxAddvFh+Ij5m6WAurdPc8yf65850ndY
hbiRitVYm6LqYTZyJiaZdlPM6/eicXauib+RB6f0VvDqEf36/A0oM0aaLLwdGhDWKxr6BeAAcxMK
+ZTu/KKDOln+fUjunnOzdrs2lrbcA6rFxHIG/AADztXpOUZj6k4IcjuR08o1g3m3ezO6sr24leEd
htE=
=w1yV
-----END PGP SIGNATURE-----

--------------Cmvv0EeRQpjdbsYND0hq7Op7--
