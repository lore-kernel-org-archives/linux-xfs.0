Return-Path: <SRS0=tAZO=BL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D53BC433E0
	for <linux-xfs@archiver.kernel.org>; Sat,  1 Aug 2020 01:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E8F72072A
	for <linux-xfs@archiver.kernel.org>; Sat,  1 Aug 2020 01:42:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgHABmu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 31 Jul 2020 21:42:50 -0400
Received: from sandeen.net ([63.231.237.45]:50958 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726794AbgHABmu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 31 Jul 2020 21:42:50 -0400
Received: from Liberator.local (047-025-251-180.res.spectrum.com [47.25.251.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 1EB2748C7C3
        for <linux-xfs@vger.kernel.org>; Fri, 31 Jul 2020 20:41:52 -0500 (CDT)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to e055f37a
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <2dffda48-9d90-8a0f-9e84-5ea86b2220c9@sandeen.net>
Date:   Fri, 31 Jul 2020 18:42:44 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ojsvR6bjzhN3yau6IfEPbY3cBSRnAM2nU"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ojsvR6bjzhN3yau6IfEPbY3cBSRnAM2nU
Content-Type: multipart/mixed; boundary="PLej2yvH7d4h5zoSKFX6vERpvENrpVXcH"

--PLej2yvH7d4h5zoSKFX6vERpvENrpVXcH
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

e055f37a (HEAD -> for-next, origin/for-next, korg/for-next) xfs_io: Remov=
e redundant setting/check for lsattr/stat command

New Commits:

Darrick J. Wong (4):
      [4ff36b06] xfs_repair: alphabetize HFILES and CFILES
      [cfaac8d9] xfs_repair: fix clearing of quota CHKD flags
      [0a8d74d6] xfs_repair: check quota values if quota was loaded
      [91a52fbc] xfs_repair: skip mount time quotacheck if our quotacheck=
 was ok

Xiao Yang (2):
      [5fd7257c] xfs_io: Make -D and -R options incompatible explicitly
      [e055f37a] xfs_io: Remove redundant setting/check for lsattr/stat c=
ommand


Code Diffstat:

 io/attr.c             |  11 +-
 io/cowextsize.c       |   9 +-
 io/open.c             |  22 +-
 io/stat.c             |   5 -
 man/man8/xfs_repair.8 |   4 +
 repair/Makefile       |  71 ++++++-
 repair/phase7.c       |  21 +-
 repair/quotacheck.c   | 552 ++++++++++++++++++++++++++++++++++++++++++++=
++++++
 repair/quotacheck.h   |  16 ++
 repair/xfs_repair.c   |  13 +-
 10 files changed, 690 insertions(+), 34 deletions(-)
 create mode 100644 repair/quotacheck.c
 create mode 100644 repair/quotacheck.h


--PLej2yvH7d4h5zoSKFX6vERpvENrpVXcH--

--ojsvR6bjzhN3yau6IfEPbY3cBSRnAM2nU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl8kyJYACgkQIK4WkuE9
3uApRRAAxN9u8W0/SR/pnCZWR3JSuVLYGSN7Hqb3TTjRqt8ekW9/5XuYIYuFBb3G
Qp7qzto4UaiDorxHuv0xfdAIplwmAWa69wPqi7Zf91ivxZ2OIka68JVOCtkYG7mi
65sacxGvLJEZKFllh2qCM5XPkrMCswCpnDz3sJSoZMOzfmzFc816HFl5tnq7brz/
Owi2zhEbxSPtUVxdxEqtrTqD50ZFt9S5T7uLxF8ju69I54xKz17opNwK3VLxbh2U
Z6LybZxNcEA6WycZhejp0ez7wK4+W2McFlFE/5ND5wykYH1gp5XMZfaLTrPwzDgB
cK4HkxrqZTv8Jd6iH4iJRRsJ0+MhzxG1ZCVKvjmLJC13GKGr3KDGTly8PY7jeB4+
RTxu6DREMtkPRrvLebD4NRUttQKofskFOjy790maO8v74QrmEh6p5DnnDOyha059
2ZogDEB1psvZ98jktgfecLKnntjO6q8Z2n9Fa7HR4vxpE1QuzaakSdc+8ygBrfeJ
zUWWffTDv89dt+u/TedUEs9jmbfuGZKMF1ggeseHJMvmiyhZLTHzyy8CyVV3VEFl
cIHO/JR4uyd+SVrZdtyp+3ONEqouwE3G8z7Mj+Rl9KmFSXKCsxKXoZk1eqJJf6pJ
HD7OQFZGNM3oa2xYIUvjFlav98SPvLNeYeCslo4zg9w7bSTBqFk=
=+9M1
-----END PGP SIGNATURE-----

--ojsvR6bjzhN3yau6IfEPbY3cBSRnAM2nU--
