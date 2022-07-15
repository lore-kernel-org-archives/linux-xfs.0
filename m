Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F6E7C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Jul 2022 16:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiGOQVD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Jul 2022 12:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiGOQVC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Jul 2022 12:21:02 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C1B9866ADF
        for <linux-xfs@vger.kernel.org>; Fri, 15 Jul 2022 09:21:01 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 262B622DB
        for <linux-xfs@vger.kernel.org>; Fri, 15 Jul 2022 11:20:36 -0500 (CDT)
Message-ID: <4a80233f-765d-836f-7c1a-0e0839aab4d2@sandeen.net>
Date:   Fri, 15 Jul 2022 11:20:59 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Content-Language: en-US
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 50dba818
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------kGweamnMYi3ARjSQL6yiDf5Y"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------kGweamnMYi3ARjSQL6yiDf5Y
Content-Type: multipart/mixed; boundary="------------MCd04X0blmdDRMWNrcrepk0j";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <4a80233f-765d-836f-7c1a-0e0839aab4d2@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 50dba818

--------------MCd04X0blmdDRMWNrcrepk0j
Content-Type: text/plain; charset=UTF-8
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

50dba818 mkfs: terminate getsubopt arrays properly

New Commits:

Chandan Babu R (1):
      [91c1d083] xfs_repair: Search for conflicts in inode_tree_ptrs[] wh=
en processing uncertain inodes

Darrick J. Wong (5):
      [f2e38861] xfs_repair: check free rt extent count
      [9d454cca] xfs_repair: check the rt bitmap against observations
      [daebb4ce] xfs_repair: check the rt summary against observations
      [f50d3462] xfs_repair: ignore empty xattr leaf blocks
      [50dba818] mkfs: terminate getsubopt arrays properly

hexiaole (1):
      [03bc6539] xfs: correct nlink printf specifier from hd to PRIu32


Code Diffstat:

 logprint/log_misc.c  |   2 +-
 mkfs/xfs_mkfs.c      |  16 +++-
 repair/attr_repair.c |  20 +++++
 repair/dino_chunks.c |   3 +-
 repair/phase5.c      |  13 +++-
 repair/protos.h      |   1 +
 repair/rt.c          | 212 ++++++++++++++++++---------------------------=
-----
 repair/rt.h          |  18 ++---
 repair/xfs_repair.c  |   7 +-
 9 files changed, 132 insertions(+), 160 deletions(-)

--------------MCd04X0blmdDRMWNrcrepk0j--

--------------kGweamnMYi3ARjSQL6yiDf5Y
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmLRk+sFAwAAAAAACgkQIK4WkuE93uBA
qxAAjsAZwnGwlc9chCFctQo+56KuL134Ee6geEzItDOhx20caxIQVRT3ZF80PPg9wYojM0+seG+r
RpzViGd5xNjnf4nFNpVPaGr1inYaYfKBL9CEijNF1h1IQGtnPLz9V2mZSt8SgZGAYpac20859x5C
ExKlMQH6TRnG5NwdsGTheVmzksQEEk9EH8+coOAY/k6keJYCOPw4KLC4sgqjw9FKgXvmbc7xscYJ
xGR6q78uPciZhXUePoDL61VMNg1m6Ch7WT/ZTGtx0oeCEoJtKNQQqsFxryEi6rz3mRaFNn9HsCfW
mecGBOqeVXQ5JuDNPf5vjzMXny4IJ4agVe/00j4V1jvivheqF1cFZFIDgnItq87dQ4UmsDE63Nio
eubqRLUNf2v4MWRuaZLKsUvwmWWeqL+rbVJGVEA0GHH+2jfLZbvVp/BqDobXLhSPAwj5xKhFuncb
wD0SO95oesXR5XOkQ/uQ/dRwzlC58fxbI0HnVrXOj4Gaws33XOuE77iFUBPDRTeXIClLt5oTndFG
l/1H6yGldtbWuEviQ61AtwyUGLj+osOquxSXXZkncR/a9vDBShGArDHo+ce9olz79CBFFNxv4vxc
kVKrco9fa8+FcLN1uxOe0H1QleriCAfDEJoXfjOstAXuhGTcTASYhSl99bLPOs/XBSgqs3bo3+4s
e+I=
=aZGZ
-----END PGP SIGNATURE-----

--------------kGweamnMYi3ARjSQL6yiDf5Y--
