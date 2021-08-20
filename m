Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D213C4338F
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Aug 2021 20:17:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD77660F5E
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Aug 2021 20:17:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhHTURp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Aug 2021 16:17:45 -0400
Received: from sandeen.net ([63.231.237.45]:41958 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230266AbhHTURn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Aug 2021 16:17:43 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id C4C2322E2
        for <linux-xfs@vger.kernel.org>; Fri, 20 Aug 2021 15:16:53 -0500 (CDT)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs 5.13.0 released
Message-ID: <b5607a29-b9af-0022-562b-909f4a101ca9@sandeen.net>
Date:   Fri, 20 Aug 2021 15:17:04 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Zw5zI22sDfqx8D63aLGP3uDDrL0cd1ZAY"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Zw5zI22sDfqx8D63aLGP3uDDrL0cd1ZAY
Content-Type: multipart/mixed; boundary="8gIr2ViR3B79Ulhm2wWzJmQHZqPQhwzH0";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <b5607a29-b9af-0022-562b-909f4a101ca9@sandeen.net>
Subject: [ANNOUNCE] xfsprogs 5.13.0 released

--8gIr2ViR3B79Ulhm2wWzJmQHZqPQhwzH0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The master branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with 5.13.0. There are no changes from -=
rc1.

Tarballs are available at:

https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.13.0.ta=
r.gz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.13.0.ta=
r.xz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.13.0.ta=
r.sign

The new head of the master branch is commit:

b4203330 (HEAD -> for-next, tag: v5.13.0) xfsprogs: Release v5.13.0

The condensed changelog since 5.12.0 is:

xfsprogs-5.13.0 (20 Aug 2021)
         - No further changes

xfsprogs-5.13.0-rc1 (02 Aug 2021)
         - mkfs: validate rtextsz hint when rtinherit is set (Darrick J. =
Wong)
         - xfs_repair: invalidate dirhash when junking dirent (Darrick J.=
 Wong)
         - xfs_repair: validate inherited rtextsz hint alignmt (Darrick J=
=2E Wong)
         - xfs_quota: allow truncate of grp & prj quota files (Darrick J.=
 Wong)
         - xfs_io: allow callers to dump fs stats individually (Darrick J=
=2E Wong)
         - xfs_io: don't count fsmaps before querying fsmaps (Darrick J. =
Wong)
         - xfs_io: print header once when dumping fsmap in csv (Darrick J=
=2E Wong)
         - xfs_io: clean up the funshare command a bit (Darrick J. Wong)
         - xfs_io: fix broken funshare_cmd usage (Darrick J. Wong)

xfsprogs-5.13.0-rc0 (01 Jul 2021)
         - libxfs changes merged from kernel 5.13






--8gIr2ViR3B79Ulhm2wWzJmQHZqPQhwzH0--

--Zw5zI22sDfqx8D63aLGP3uDDrL0cd1ZAY
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmEgDcAFAwAAAAAACgkQIK4WkuE93uC9
YRAAqQwKplWU9nVs2Iu+aM2TYuo/e7n9nJTkRf6nFmKdeH8UCJsBsevhrfbO7hXKlbdTFZnXFHHc
0uz+vweUWYLrXiSWnGM4cxed9P1rRe1Tr4OBRoOsiMlXFpiIFlUAYNlQQCjelxnq+n5g7kZpGYt7
zDoocYHYZ715lBA2onhSECPILQWB4fmR+4+Wey052oEIhukojD5Tx2/V6VMqpUo2ClkgOE+OLcOn
QwfvqQdA6c/Mri9I4m+AHPKMcrW8rOXSJoMwubhxCyAWL5nPKuUJg328KlXJVWfxRebfiHSdyYgS
lnC1JxAVK2Mkwwt5KfA9npo0muCaImx9HLPHOdm6FB5lqwNOV8w0LnKgMeW0Qu5aFNTjvkE7lRkl
8onNmck3WzZFjZnsU86bcjKC/CGvgWcGDYbzMMyWtdTsZnGhLbOfYjTVZcxSb/O/Ege+Dv3dq/wc
40W2/x6xGjt0IcRA/PB/4dP+WvabtvpVHmIgufGcfCDZ5T2nt64YZ7LA4oUVSsIqtlcOlmls83MX
vB6p8bAQZlhNVQ4RaeCr0MfjPtU1b+ZsOdwch3VAxy+BCU/oHWbY7vjSlNBgRJZO0smhJittkjkS
qVGP13Nm8Nu7iStrYvoS56H9AujdRvv1R1saI9xHFepdJ1cIQQEAcrGBe6r/wnXHcrWWCRCmFCr3
ujc=
=jR23
-----END PGP SIGNATURE-----

--Zw5zI22sDfqx8D63aLGP3uDDrL0cd1ZAY--
