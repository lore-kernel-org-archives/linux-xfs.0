Return-Path: <SRS0=Yx8G=BD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 736CCC433E3
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 19:05:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 585EF2070E
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 19:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgGXTFf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 15:05:35 -0400
Received: from sandeen.net ([63.231.237.45]:55418 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726416AbgGXTFf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 Jul 2020 15:05:35 -0400
Received: from Liberator.local (c-71-237-195-212.hsd1.or.comcast.net [71.237.195.212])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 3F7234D1BA2
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 14:04:51 -0500 (CDT)
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
To:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfsprogs v5.7.0 released
Message-ID: <6c56d6aa-d3b9-92af-4137-b812172505bd@sandeen.net>
Date:   Fri, 24 Jul 2020 12:05:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="o0EiM4XYYc2gerHlXOkSUiDQfIMpdt7lF"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--o0EiM4XYYc2gerHlXOkSUiDQfIMpdt7lF
Content-Type: multipart/mixed; boundary="HuzjHMgHyuZLuFys9rDiDw9Xph1cGPlRV"

--HuzjHMgHyuZLuFys9rDiDw9Xph1cGPlRV
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

xfsprogs v5.7.0 has been released, and the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Tarballs are available at:

https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.7.0.tar=
=2Egz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.7.0.tar=
=2Exz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.7.0.tar=
=2Esign

The new head of the master branch is commit:

97194e73 (HEAD -> guilt/for-next, tag: v5.7.0, refs/patches/for-next/5.7.=
0) xfsprogs: Release v5.7.0

Abbreviated changelog:

xxfsprogs-5.7.0 (24 Jul 2020)
        - xfs_io: Document '-q' option for sendfile command (Xiao Yang)

xfsprogs-5.7.0-rc1 (15 Jul 2020)
        - remove libreadline support (Christoph Hellwig)
        - xfs_quota: allow individual timer extension (Eric Sandeen)
        - xfs_quota: fix unsigned int id comparisons (Darrick Wong)
        - xfs_repair: fix progress reporting (Eric Sandeen)
        - xfs_repair: fix minrecs error during phase5 btree rebuild (Gao =
Xiang)
        - xfs_repair: add missing validations to match xfs_check (Darrick=
 Wong)
        - xfs_repair: use btree bulk loading (Darrick Wong)
        - xfs_io: fix copy_range argument parsing (Eric Sandeen)
        - xfs_io: document -q option for pread/pwrite command (Xiao Yang)=

        - xfs_metadump: man page fixes (Kaixu Xia)
        - xfs_db: fix crc invalidation segfault (Anthony Iliopoulos)

xfsprogs-5.7.0-rc0 (07 May 2020)
        - libxfs changes merged from kernel 5.7

Thanks,
-Eric



--HuzjHMgHyuZLuFys9rDiDw9Xph1cGPlRV--

--o0EiM4XYYc2gerHlXOkSUiDQfIMpdt7lF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl8bMPsACgkQIK4WkuE9
3uArMRAAyHYHro674gM3cTqI9b4bHHIzppqI193+DVG361RZ7xKTXNjOk9rLbE8o
WJvq5Qfadb3xISz9zanPaw6f6i2//n4wX4teHelBTFw4YmUGKA/VAot3tXRNvkcj
0NfWNDSWHkYCCLoVxe9YdZVsOlH5HVsqbJkp7wGcTR3cYksqTtFxJp9CvOSgYvcy
UBvbybr9p/DUnI3TUp5VmhyG048DCEgY4DAD86bg37jlRYNPWx1bYSFtUeYIugzU
rSNpc/Z8f5vQo1FpPDjuOxVTQoAv/YQSn7PXY9VksAObDuIm11xwuvDBr/PUds7l
6Z0XKfCbgSh26F78g/4JDM6jpM1O2jD0MGRlL82Vl1rtBK8fdscdCsZDzA8vO2pF
lkkskw53Z596IC/J0+6upoyfHPl+n8lbMoJOJVp5o83lLVbrxxcQX44dyHnuAc7U
RfO1oyUaLfHHtLI8A/GoGZ3MZAjhcr9S+X29oeC8l6bJv2RrkbFtAOgZ6yZ6whIb
onXxhWPWynzIVnHmb49F2JWpWr6hwUgavy2JHxeA5SY7Mnpz9gnLFaEC6RZckpNy
WUwhzkR2259vaFQugHWYIsMzgUfcCkhoZznI71iEM4kFntYW1GgMY0RCzJOJ5OdH
hbSGtKsY+fbXZAIWKvAh3koxRr7kSmuTEta8z9GS0c5YG+j0S6M=
=HA+p
-----END PGP SIGNATURE-----

--o0EiM4XYYc2gerHlXOkSUiDQfIMpdt7lF--
