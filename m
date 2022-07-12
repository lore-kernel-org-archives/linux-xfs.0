Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3337AC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jul 2022 18:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiGLSev (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jul 2022 14:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiGLSeu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jul 2022 14:34:50 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D2828BDBB4
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jul 2022 11:34:49 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 26EBC4435
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jul 2022 13:34:30 -0500 (CDT)
Message-ID: <3fb4449d-7e6e-fdb0-96b0-3e9c34f22398@sandeen.net>
Date:   Tue, 12 Jul 2022 13:34:47 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Content-Language: en-US
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to c1c71781
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------O3nkOiBtytOopkYtRNTu3xQ0"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------O3nkOiBtytOopkYtRNTu3xQ0
Content-Type: multipart/mixed; boundary="------------9C6hS2JOheQMrJ4oIR7RrRQl";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <3fb4449d-7e6e-fdb0-96b0-3e9c34f22398@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to c1c71781

--------------9C6hS2JOheQMrJ4oIR7RrRQl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

I jumped the gun on 5.19.0-rc0, and a couple more libxfs patches got
added to the kkernel, so I added a new "release" and tag of
5.19.0-rc.0.1 after the last libxfs patches were merged.

After that I picked up most of Darrick's patches that had been reviewed,
as well as Zhang Boyang's mkfs man page update.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

c1c71781 mkfs: update manpage of bigtime and inobtcount

New Commits:

Darrick J. Wong (16):
      [41cbb27c] xfs: fix TOCTOU race involving the new logged xattrs con=
trol knob
      [53cbe278] xfs: fix variable state usage
      [5e572d1a] xfs: empty xattr leaf header blocks are not corruption
      [c21a5691] xfs: don't hold xattr leaf buffers across transaction ro=
lls
      [95e3fc7f] misc: fix unsigned integer comparison complaints
      [053fcbc7] xfs_logprint: fix formatting specifiers
      [d6bfc06d] libxfs: remove xfs_globals.larp
      [fa0f9232] xfs_repair: always rewrite secondary supers when needsre=
pair is set
      [84c5f08f] xfs_repair: don't flag log_incompat inconsistencies as c=
orruptions
      [766bfbd7] xfs_db: identify the minlogsize transaction reservation
      [baf8a5df] xfs_copy: don't use cached buffer reads until after libx=
fs_mount
      [b83b2ec0] xfs_repair: clear DIFLAG2_NREXT64 when filesystem doesn'=
t support nrext64
      [0ec4cd64] xfs_repair: detect and fix padding fields that changed w=
ith nrext64
      [b6fd1034] mkfs: preserve DIFLAG2_NREXT64 when setting other inode =
attributes
      [42efbb99] mkfs: document the large extent count switch in the --he=
lp screen
      [ad8a3d7c] mkfs: always use new_diflags2 to initialize new inodes

Eric Sandeen (1):
      [e298041e] xfsprogs: Release v5.19.0-rc0.1

Zhang Boyang (1):
      [c1c71781] mkfs: update manpage of bigtime and inobtcount


Code Diffstat:

 copy/xfs_copy.c          |  2 +-
 db/check.c               | 10 +++++++---
 db/logformat.c           |  4 +++-
 db/metadump.c            | 11 +++++++----
 include/xfs_mount.h      |  7 -------
 libxfs/util.c            | 15 ++++++---------
 libxfs/xfs_attr.c        | 47 ++++++++++++++----------------------------=
-----
 libxfs/xfs_attr.h        | 17 +----------------
 libxfs/xfs_attr_leaf.c   | 37 ++++++++++++++++++++-----------------
 libxfs/xfs_attr_leaf.h   |  3 +--
 libxfs/xfs_da_btree.h    |  4 +++-
 logprint/log_print_all.c |  2 +-
 man/man8/mkfs.xfs.8.in   |  4 ++--
 mkfs/xfs_mkfs.c          |  2 +-
 repair/agheader.c        | 23 ++++++++++++++++++++---
 repair/dinode.c          | 47 ++++++++++++++++++++++++++++++++++++++++++=
+----
 16 files changed, 130 insertions(+), 105 deletions(-)

--------------9C6hS2JOheQMrJ4oIR7RrRQl--

--------------O3nkOiBtytOopkYtRNTu3xQ0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmLNvscFAwAAAAAACgkQIK4WkuE93uDf
qQ//TPWvzGS6IN49oJYaKniPShUROND0Fb1v4gZB86USsdyMTnERJ6PyCQ4RIlBR4ARl0/PZ/duM
5+bW6/cKflnVKUGtXOCqLnJlIFfya+IBtbN6meSUIHLkfo1hHUj4EGmLHnkxYusPNxbof9Qao1gt
8clnNYpoKWLmoCBjrIz/RTOhmS2DnhSJJtj6uLNCOYym6aIxULvY7R3joU4EcZENX/W2ni4OoK12
Zj4qTAF4Um1g8/0U6zjWdYQqtuBVusSWrb7Py66GB/QK8jtqEMPBuwZDFBjHI9yuiSTrJMXKVDAG
1Hwwado8ZbESSyV/aVM+osy0WcjtlWV4qnibKJy+gLGKFhT0474D3O0xpKCNvzw7+eM5A4O9arKg
U+rI7eWNQu1/6G+CgSVcap0+yP9l/iR6W4VoQTkcxL3QCCsHfauhtg79wVI5KDS2bs1s6OSTAzZC
+bJmYqhZ9U3EDb8vR5VgpGusC9n0nzbwTSiFf14UcsvBapA/upxL/EXN0J54JQ9gkh4U0PFoD30H
6M/jdh36f9GwK25jUqkTDZnDElgCmtWnpac0NMaQ9knX/2oAbvHjxU9tbzZIpedXppqgC4RCDTAR
po/Vuiklz4gcSfPJxXFDniDQADOvR7a8YzEWNYk0DfQuRB9WzE+W7YycQDWos9SRqwVt8dcg+vcX
1j8=
=DSEV
-----END PGP SIGNATURE-----

--------------O3nkOiBtytOopkYtRNTu3xQ0--
