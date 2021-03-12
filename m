Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F290C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 21:40:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C89664F72
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 21:40:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235275AbhCLVkU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Mar 2021 16:40:20 -0500
Received: from sandeen.net ([63.231.237.45]:40534 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235326AbhCLVjs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Mar 2021 16:39:48 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 745D815D96
        for <linux-xfs@vger.kernel.org>; Fri, 12 Mar 2021 15:39:15 -0600 (CST)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v5.11.0 released, master branch updated to
 a97792a8
Message-ID: <a99340e8-deb7-bd58-f77d-5f4f761ceb22@sandeen.net>
Date:   Fri, 12 Mar 2021 15:39:46 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CfrB1SkF3F3cmFLKkO2bK8vEjdDDZcO6i"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CfrB1SkF3F3cmFLKkO2bK8vEjdDDZcO6i
Content-Type: multipart/mixed; boundary="uC6QlIYWnhK7uLxfwEu6elt04jUHCsakn";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <a99340e8-deb7-bd58-f77d-5f4f761ceb22@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v5.11.0 released, master branch updated to
 a97792a8

--uC6QlIYWnhK7uLxfwEu6elt04jUHCsakn
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v5.11.0.

Tarballs are available at:

https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.11.0.ta=
r.gz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.11.0.ta=
r.xz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.11.0.ta=
r.sign

The new head of the master branch is commit:

a97792a8 xfsprogs: Release v5.11.0

Of note, this release supports the new "bigtime" (y2038) and inobtcnt
filesystem features, as well as an upgrade path.

Condensed changelog for this release follows:

(Bastian, I also included your 2 debian fixes but neglected to put it in
the short changelog, sorry.)

xfsprogs-5.11.0 (12 Mar 2021)
        - xfs_admin: don't hide xfs_repair output when upgrading (Darrick=
 Wong)
        - man: document attr2, ikeep option deprecation in xfs.5 (Pavel R=
eichl)

xfsprogs-5.11.0-rc1 (23 Feb 2021)
        - mkfs: make use of xfs_validate_stripe_geometry() (Gao Xiang)
        - mkfs: fix wrong inobtcount usage error output (Zorro Lang)
        - xfs_repair: enable bigtime upgrade via repair (Darrick J. Wong)=

        - xfs_repair: enable inobtcount upgrade via repair (Darrick J. Wo=
ng)
        - xfs_repair: set NEEDSREPAIR on first write (Darrick J. Wong)
        - xfs_repair: clear the needsrepair flag when done (Darrick J. Wo=
ng)
        - xfs_repair: check dquot id and type (Darrick J. Wong)
        - xfs_fsr: Verify bulkstat version in qsort's cmp() (Chandan Babu=
 R)
        - xfs_fsr: Interpret args of qsort's cmp() correctly (Chandan Bab=
u R)
        - xfs_scrub: load and unload libicu properly (Darrick J. Wong)
        - xfs_scrub: various fixes (Darrick J. Wong)
        - xfs_admin: support adding features to V5 filesystems (Darrick J=
=2E Wong)
        - xfs_admin: support filesystems with realtime devices (Darrick J=
=2E Wong)
        - man: mark all deprecated V4 format options (Darrick J. Wong)
        - misc: fix valgrind complaints (Darrick J. Wong)
        - xfs_db: disallow label/uuid setting if NEEDSREPAIR (Darrick J. =
Wong)
        - xfs_db: show NEEDSREPAIR in check & version commands (Darrick J=
=2E Wong)
        - xfs_db: add an ls command (Darrick J. Wong)
        - xfs_db: add a directory path lookup command (Darrick J. Wong)

xfsprogs-5.11.0-rc0 (12 Feb 2021)
        - libxfs changes merged from kernel 5.10
        - Debian packaging fixes (Bastian Germann)



--uC6QlIYWnhK7uLxfwEu6elt04jUHCsakn--

--CfrB1SkF3F3cmFLKkO2bK8vEjdDDZcO6i
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmBL36IFAwAAAAAACgkQIK4WkuE93uBY
aw/9GJVn32IGf2KBNQyxBjmdj0h9OYq2qvtIZSgzWPSonIMQ3TSygtrws1bjjTZE5bqKmpuw9Dac
SQLI1kCzhkPybAEh2x4s9ZxjgZhqktpnebPkMZuGfAVbJ5vuF/G3RGYplGg8H/ShC+oWIVHinhUi
zqlrduHFFCisKEff7xU4D6fgcgYGRmSRZNF27qLLZMD1xqCk015Vo2apJa/0WuhPCu8Q3BYClCJU
wOJxtwFfG2uwEHtim/yItUNia73ehXd7ZP69KFksoNxnglxmmuy+ox4VEivlklVVf/wE3/R0UJ8H
HbTWInWN4PqUS0bN+cKhVDclRPl1ENqfqzHuScu1OFc1nD/ZmSXTvJGAFhGEyYU7xXfWk+TLd9PQ
rOfNT+iaPbhhG4VhMbSKAo8LQAgK6d7JVhXt1yf0ZrBgMJIsfpdL4/5+lcozVg3hhR+kq/JM0MYI
+JSqH2ZmDrL7+Hp6l20WxZlIk/vf2/WtdACkOMZkvYFsIePDbqYp6DgdSKDecGR/e5G2I2gqGu4k
34J3kMC+9GYmjDIEbKbEAXKVLFmv8uFwH/ZyAdNXJpbjeqdF0VM1REfXYfk5XygrUG2lskyJTI6V
QkYPWf8NHeLvLzSJ+WbzDOFV17ykvFX23JelgdwJdPVY9otRRHb0nPTsp0lvvANVaIb8zw7xmLdH
ZxI=
=DxlT
-----END PGP SIGNATURE-----

--CfrB1SkF3F3cmFLKkO2bK8vEjdDDZcO6i--
