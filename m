Return-Path: <SRS0=Jrso=6Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74846C47255
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 21:41:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59AEF206E6
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 21:41:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725904AbgEKVlY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 May 2020 17:41:24 -0400
Received: from sandeen.net ([63.231.237.45]:47952 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbgEKVlY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 May 2020 17:41:24 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 150D3B77
        for <linux-xfs@vger.kernel.org>; Mon, 11 May 2020 16:41:09 -0500 (CDT)
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 5d0807ad
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
To:     linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <ec63ae12-41b0-26e7-0a60-72820f7385c6@sandeen.net>
Date:   Mon, 11 May 2020 16:41:20 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TWPU7mBj8kLXXmqftZHjl602PmjC8OiX1"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TWPU7mBj8kLXXmqftZHjl602PmjC8OiX1
Content-Type: multipart/mixed; boundary="o7TxYdrP0fTw2ElOUCnQzcMEO1Tqx5RsZ"

--o7TxYdrP0fTw2ElOUCnQzcMEO1Tqx5RsZ
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

5d0807ad libxfs-apply: use git am instead of patch

New Commits:

Christoph Hellwig (11):
      [bbe12eb9] xfsprogs: remove libreadline support
      [d5b6e335] xfsprogs: remove xfs_dir_ops
      [b98cd1f7] libxfs: use tabs instead of spaces in div_u64
      [30f8e916] db: fix a comment in scan_freelist
      [27cd356f] db: add a comment to agfl_crc_flds
      [8e9a788f] db: cleanup attr_set_f and attr_remove_f
      [38cff22d] db: validate name and namelen in attr_set_f and attr_rem=
ove_f
      [951e17bc] db: ensure that create and replace are exclusive in attr=
_set_f
      [0c02ef9b] repair: cleanup build_agf_agfl
      [f19a627b] metadump: small cleanup for process_inode
      [5d0807ad] libxfs-apply: use git am instead of patch

Darrick J. Wong (3):
      [b0c0cdb7] libxcmd: don't crash if el_gets returns null
      [8c4d190e] find_api_violations: fix sed expression
      [7161cd21] xfs_db: bounds-check access to the dbmap array

Eric Sandeen (1):
      [baed08dd] xfs_io: copy_range can take up to 8 arguments


Code Diffstat:

 configure.ac                 |  7 ----
 db/Makefile                  |  5 ---
 db/agfl.c                    |  1 +
 db/attrset.c                 | 87 ++++++++++++++++++++++++--------------=
------
 db/check.c                   | 45 ++++++++++++++++++++++-
 db/input.c                   | 26 +------------
 db/metadump.c                |  3 +-
 growfs/Makefile              |  3 --
 include/builddefs.in         |  2 -
 include/xfs_inode.h          |  2 -
 include/xfs_mount.h          |  3 --
 io/Makefile                  |  4 --
 io/copy_file_range.c         |  2 +-
 libxcmd/Makefile             |  5 ---
 libxcmd/input.c              | 38 ++++++++-----------
 libxfs/libxfs_priv.h         |  4 +-
 libxfs/rdwr.c                |  8 ----
 libxfs/util.c                |  8 ----
 quota/Makefile               |  5 ---
 repair/phase5.c              |  7 +---
 repair/phase6.c              |  1 -
 spaceman/Makefile            |  4 --
 tools/find-api-violations.sh | 10 ++++-
 tools/libxfs-apply           |  4 +-
 24 files changed, 126 insertions(+), 158 deletions(-)


--o7TxYdrP0fTw2ElOUCnQzcMEO1Tqx5RsZ--

--TWPU7mBj8kLXXmqftZHjl602PmjC8OiX1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl65xoEACgkQIK4WkuE9
3uCmEQ/9FQ06sOYuOzgiBwQ580o6NE8LK62h2HxPsMpYt4amuXNUw0H/8/O0JuVJ
sU7U2ZhuqaJOUyz16C04WEjCOp6zOtP2xGYddXtWPfUJc/gDV80nE6MGsVdOhtew
OwunFZN/QBE8pGF09nmmOuaAqwReRQYyGVHLwgVi7wwZ/auBoVpbP6hDR0pV6j2r
BuXZCcCbfbTCjVDdfG6ieuC7AZlPUzVFwmDT0pY9Ux6QlEs9rPJSUSX8OnZJVPiU
ELTMh4c9EFCYYehCUIEBd7xoO6Z79FUE03lmgRHHWgXAwpBcmimebIQ0G2NCMcjb
jeMB0E0XK10S1p5cl9aBB2Hmf5yLZssGsV4uvpN9RfwRvzNv0+2Tq9O0EjOCeyHA
dTjio2cU5aeEnn6ZEg8NsHOJe7lbX2N3/hyjlIMhm/C0U8lS2pqyUwLM2XcNw+oH
aBU4/0+XGo/KwRZBRUdMo1IVAsrZAGiusmZkTr+hK8gxp7CBFUranwZL9DHFFgxD
ysX6Prx2euqaBimKUCBGsEPMPO+6lLOBUbouDC0CjHppxzCi0M50YEczS7rw3U9J
RdfKVYGFjhGPPaFfyQSkChxvmuCcRoUOk5dkbYmEfBzVKZMskQaBadBQNrSShleW
cWaZ/hxIr9p4hoFMEnvhG1BHKN7jZQ13RbKvsaWWyMQ2sPnmU/c=
=NxM0
-----END PGP SIGNATURE-----

--TWPU7mBj8kLXXmqftZHjl602PmjC8OiX1--
