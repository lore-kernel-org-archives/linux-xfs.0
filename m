Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3718CC00140
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Aug 2022 18:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238393AbiHLSvd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Aug 2022 14:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238367AbiHLSvb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Aug 2022 14:51:31 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8686ADEA7
        for <linux-xfs@vger.kernel.org>; Fri, 12 Aug 2022 11:51:30 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 0AB6B79E0
        for <linux-xfs@vger.kernel.org>; Fri, 12 Aug 2022 13:50:16 -0500 (CDT)
Message-ID: <1a4a75bc-22a6-9f87-121b-b97de15d35f3@sandeen.net>
Date:   Fri, 12 Aug 2022 13:51:28 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Content-Language: en-US
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs-5.19.0 released
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------P6dxwvVbFHI3JyXrsy3vOL10"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------P6dxwvVbFHI3JyXrsy3vOL10
Content-Type: multipart/mixed; boundary="------------9uNCFJub5UAJIibYF0B1SphQ";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <1a4a75bc-22a6-9f87-121b-b97de15d35f3@sandeen.net>
Subject: [ANNOUNCE] xfsprogs-5.19.0 released

--------------9uNCFJub5UAJIibYF0B1SphQ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged for a v5.19.0 release. The condensed cha=
ngelog
since v5.18.0 is below.

Tarballs are available at:

https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.19.0.ta=
r.gz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.19.0.ta=
r.xz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.19.0.ta=
r.sign

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

5652dc4f xfsprogs: Release v5.19.0

xfsprogs-5.19.0 (12 Aug 2022)
        - xfs_repair: fix printf format specifiers on 32-bit (Darrick J. =
Wong)

xfsprogs-5.19.0-rc1 (05 Aug 2022)
        - libxfs: last bit of kernel sync
        - libxfs: Fix MAP_SYNC build failure on MIPS/musl (Darrick J. Won=
g)
        - mkfs: stop allowing tiny filesystems (Darrick J. Wong)
        - mkfs: complain about impossible log size constraints (Darrick J=
=2E Wong)
        - mkfs: ignore stripe geometry for small filesystems (Darrick J. =
Wong)
        - mkfs: update manpage of bigtime and inobtcount (Zhang Boyang)
        - mkfs: document large extent count in --help screen (Darrick J. =
Wong)
        - mkfs: fix segfault with incorrect options (Darrick J. Wong)
        - xfs_repair: Support upgrade to large extent counters (Chandan B=
abu R)
        - xfs_repair: check geometry before upgrades (Darrick J. Wong)
        - xfs_repair: ignore empty xattr leaf blocks (Darrick J. Wong)
        - xfs_repair: check rt summary/bitmap vs observations (Darrick J.=
 Wong)
        - xfs_repair: check free rt extent count (Darrick J. Wong)
        - xfs_repair: detect/fix changed fields w/ nrext64 (Darrick J. Wo=
ng)
        - xfs_repair: clear DIFLAG2_NREXT64 w/o fs support (Darrick J. Wo=
ng)
        - xfs_repair: ignore log_incompat inconsistencies (Darrick J. Won=
g)s
        - xfs_repair: rewrite secondary supers w/ needsrepair (Darrick J.=
 Wong)
        - xfs_db: id the minlogsize transaction reservation (Darrick J. W=
ong)

xfsprogs-5.19.0-rc0 (22 Jun 2022)
        - libxfs changes merged from kernels 5.18 and 5.19-rc
        - mkfs: option to create with large extent counters (Chandan Babu=
 R)
        - xfs_info: Report NREXT64 feature status (Chandan Babu R)
        - xfs_logprint: Log item printing for ATTRI & ATTRD (Allison Hend=
erson)


--------------9uNCFJub5UAJIibYF0B1SphQ--

--------------P6dxwvVbFHI3JyXrsy3vOL10
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmL2oTAFAwAAAAAACgkQIK4WkuE93uB3
Ag/5AZQQ1BBtfL9q//JUU70xRkxeUSwLySqEcEFBMkoHd/bZGPwsZ4LqiWucam8HEeObKt2XebwN
jxFazlKixqYvgZOO9XYim24ruY/0SG3kdiUswvKFTCVNOcF2GOyNp5uLn3N3IvCB0/bhWSwPsRjp
dg2nyada2Fb1xZLoaLBJuruhGicbuBponQFc+W3WKD3gO+pqzvsbDQHBwB3jG2AWF6ci1ePQn5tT
AH4YOmFvzdFiA925p1I4y2KUunpamkXmCTJF1NUfxVbnpRVsoTK5qC6Rh8IlYNtUzZfL2Iuv9jns
vTa6ijrOiXZ1xznrEt6PGByYMv0PvOgyoiaHH6DNwNtgL+kiXOQTq1vusw4/PTbLjgCKaUwoHJd2
P4anyKs/oImjHFq7A+H5m3j2J7FEmzdugTuVyyHG4xufccss3JWGF5QGiiDj1t52gOX30YAncVHC
mrSlfK39IkCuyKhDBDRNPidEjwv/8Eyd+H1FJRyCF9cZHjxl0Cm1fNKGJaodKPtWvukq2Z35Hq21
wUxeK9hAmidJpfNeC4WVFfMlK4Cv9B4L+n2mkLT/nVNLCJBJeIM605CSYZyTACVY35WI+FML71uu
9x8xVk1oiqmJ3artvdO+fMCjedBDaGX0CvjTmiJvgO/1tNTBDyFBzPdaO3I6risv2MbM9UHkAkuD
Ok4=
=NpDS
-----END PGP SIGNATURE-----

--------------P6dxwvVbFHI3JyXrsy3vOL10--
