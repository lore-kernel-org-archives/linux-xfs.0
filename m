Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8668C43334
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jun 2022 19:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344372AbiFCTbm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Jun 2022 15:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344125AbiFCTbm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Jun 2022 15:31:42 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 625635A2F7
        for <linux-xfs@vger.kernel.org>; Fri,  3 Jun 2022 12:31:40 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 3029E50922E
        for <linux-xfs@vger.kernel.org>; Fri,  3 Jun 2022 14:31:21 -0500 (CDT)
Message-ID: <04b1285b-621e-75c4-fc30-7bbefef927be@sandeen.net>
Date:   Fri, 3 Jun 2022 14:31:38 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Content-Language: en-US
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs-5.18.0 released
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------e2GDnreU49gOiEC7LSfman0K"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------e2GDnreU49gOiEC7LSfman0K
Content-Type: multipart/mixed; boundary="------------Jeceo7m0hxCUShfpEdXpYIDU";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <04b1285b-621e-75c4-fc30-7bbefef927be@sandeen.net>
Subject: [ANNOUNCE] xfsprogs-5.18.0 released

--------------Jeceo7m0hxCUShfpEdXpYIDU
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged for a v5.18.0 release. The condensed cha=
ngelog
is below.

Tarballs are available at:

https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.18.0.ta=
r.gz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.18.0.ta=
r.xz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.18.0.ta=
r.sign

The new head of the master branch is commit:

8c642e6f (HEAD -> for-next, tag: v5.18.0, korg/master, korg/for-next) xfs=
progs: Release v5.18.0

xfsprogs-5.18.0 (03 Jun 2022)
        - xfsprogs: more autoconf modernisation (Darrick J. Wong)

xfsprogs-5.18.0-rc1 (27 May 2022)
        - mkfs: Fix memory leak (Pavel Reichl)
        - mkfs: don't trample the gid set in the protofile (Darrick J. Wo=
ng)
        - mkfs: various post-log-size-increase fixes (Darrick J. Wong)
        - xfs_scrub: various enhancements and fixes (Darrick J. Wong)
        - xfs_scrub: move to mallinfo2 when available (Darrick J. Wong)
        - metadump: be careful zeroing corrupt inode forks (Dave Chinner)=

        - metadump: handle corruption errors without aborting (Dave Chinn=
er)
        - metadump: warn about suspicious finobt trees (Darrick J. Wong)
        - xfs_repair: check ftype of . and . directory entries (Darrick J=
=2E Wong)
        - xfs_repair: detect v5 feature mismatch in backup sb ((Darrick J=
=2E Wong)
        - xfs_repair: fix sizing of the incore rt space usage map calcula=
tion
        - xfs_repair: warn about bad btree levels in AG hdrs (Darrick J. =
Wong)
        - xfs_io: add a quiet option to bulkstat (Dave Chinner)
        - xfs_db: report maxlevels for each btree type (Darrick J. Wong)
        - xfs_db: support computing btheight for all cursors (Darrick J. =
Wong)
        - xfs_db: don't move cursor when switching types (Andrey Albersht=
eyn)
        - docs: note the removal of XFS_IOC_FSSETDM (Darrick J. Wong)
        - xfsprogs: autoconf modernisation (Dave Chinner)
        - debian: support multiarch for libhandle (Darrick J. Wong)
        - debian: bump compat level to 11 (Darrick J. Wong)
        - debian: refactor common options (Darrick J. Wong)

xfsprogs-5.18.0-rc0 (06 May 2022)
        - libxfs changes merged from kernels 5.17 and 5.18

--------------Jeceo7m0hxCUShfpEdXpYIDU--

--------------e2GDnreU49gOiEC7LSfman0K
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmKaYZoFAwAAAAAACgkQIK4WkuE93uAC
VA/8COThhl/QQMTRtLFuzMR6Zcg3hAwpohC54qgHkRTUxKBnB3QIuLhbQD5gCZHekRZFTF8Rxemp
5ubvd1WTYx9Jd5B6Tme6ZfeNmsCpKpYakRWBb0fOrLgmoy1SVaGm3tKlkHHtLRsQQ4Kzh943z/kD
oX46ggGhpT3C4T0tpumMxz0YId6+hb8eebb192dUgWBij19oRNXQNVjBq+plFqOFVIeseqfA7MHj
psVC3UfWBfI1YWQTeEAK6cepbqMjoGJA++nu0cFTQPXtaRDlwc2csZm4i4YXfV2UDUmJjYllnH6/
X+mGzsVBMUa41gdncf7qEnXjoYkkum8Ru0nm0LVhC6gaBjXWGaNCyl/qEcUpkmDijTk30Pe22gn2
/mchdl0VQjSG3kXBisrwlFXipLZPsAWl1k+oncC6inHzG6qTMNcv6KqpWd3gzp+pBVVklqNnBpl0
HUhkLaUW+5pv8tZ9wKY7LB7E2tCbItVg1JV/wKlY1tK+bNWBTrDyCgN0xYyfZV4sFeQJGp1t0azd
yVw+Oat6BcfsgwrW/lEjcfD/jfVZPCWtRAqGr+FjjmI4EQZSm4abaRpeopwM+rcPW3nvCT3GInYL
tuxvoktniocGzlrBZVq+rucDR32njCjE7K+2ya6WVpyKryA5XYnN2LfvepZfri+g0euh/rrgWcCe
6Zw=
=ZiM6
-----END PGP SIGNATURE-----

--------------e2GDnreU49gOiEC7LSfman0K--
