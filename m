Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3E13CA0EC3
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 07:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbjILH3D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 03:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjILH3C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 03:29:02 -0400
Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A49AA
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 00:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maiolino.me;
        s=protonmail3; t=1694503734; x=1694762934;
        bh=DiYat1SAqNqcP9ul6MVAgPj5giA0VwtYt2euu7ynCYY=;
        h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=c3iq8A7C9dA+I0hnRN0HTuUF5PMs91u8ttqV5ZxbxaB7s+ZOiuELcVM9+Kn2yynOI
         IXPy/WyKsSO7hnznwwSsjrn0kCY59PwXPYHy0gGBgIh1wHPmeqQSo9ToZwfAG1exxy
         CYR9a5TpNFiqZ3LdJophW6S79XDMpzlSVnaU9k7BOUe3ml7ohV05BTTicR8g2l2+2l
         gyMXGDTqaDQfZBkOilcVit7RryUAz0AcKdrbHc984vpyUGbQ8EBTRJ87wPu+ElXkij
         z4HyGui1vMcG79/ZdFy8NdOmMF61tMqmBs2RAb3puBOPXRvMIxy29ZGkxUMhjcT9P5
         thgsJOBRwdZ7A==
Date:   Tue, 12 Sep 2023 07:28:42 +0000
To:     linux-xfs@vger.kernel.org
From:   Carlos Maiolino <carlos@maiolino.me>
Subject: [ANNOUNCE] xfsprogs: for-next updated to e17ccef35
Message-ID: <20230912072839.xmoanxvkf2ityqi2@andromeda>
Feedback-ID: 28765827:user:proton
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha256; boundary="------47c290402b4aa1b06479fd83a07ea1949862b6a6f4f34265aa2a5038955b13a4"; charset=utf-8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------47c290402b4aa1b06479fd83a07ea1949862b6a6f4f34265aa2a5038955b13a4
Content-Type: text/plain; charset=UTF-8
Date: Tue, 12 Sep 2023 09:28:39 +0200
From: Carlos Maiolino <carlos@maiolino.me>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: for-next updated to e17ccef35
Message-ID: <20230912072839.xmoanxvkf2ityqi2@andromeda>
MIME-Version: 1.0
Content-Disposition: inline

Hello.

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next

Has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

e17ccef351b424b11ddccc9d228d02a025f9639a

This update consists mostly of a libxfs-sync to Linux 6.5.

15 new commits:

Colin Ian King (1):
      [d03a3c4b2] xfs: remove redundant initializations of pointers drop_leaf and save_leaf

Darrick J. Wong (6):
      [8105f53ed] xfsprogs: don't allow udisks to automount XFS filesystems with no prompt
      [05dcea079] xfs: fix xfs_btree_query_range callers to initialize btree rec fully
      [98572f41f] xfs: AGI length should be bounds checked
      [deccac70b] xfs: convert flex-array declarations in struct xfs_attrlist*
      [39e9f4c29] xfs: convert flex-array declarations in xfs attr leaf blocks
      [e17ccef35] xfs: convert flex-array declarations in xfs attr shortform objects

Dave Chinner (6):
      [ef16737e4] xfs: use deferred frees for btree block freeing
      [01f05365c] xfs: pass alloc flags through to xfs_extent_busy_flush()
      [4127f5dc0] xfs: don't block in busy flushing when freeing extents
      [5835a5620] xfs: journal geometry is not properly bounds checked
      [6ac452dcd] xfs: AGF length has never been bounds checked
      [d096b26c3] xfs: fix bounds check in xfs_defer_agfl_block()

Kees Cook (1):
      [0aac3b2b0] overflow: Add struct_size_t() helper

Long Li (1):
      [95957f34c] xfs: fix ag count overflow during growfs

Code Diffstat:

 configure.ac                |   1 +
 db/metadump.c               |   4 +-
 include/builddefs.in        |   2 +
 include/platform_defs.h.in  |  16 +++
 libxfs/libxfs_priv.h        |   2 +-
 libxfs/xfs_ag.c             |   2 +-
 libxfs/xfs_alloc.c          | 289 ++++++++++++++++++++++++++++----------------
 libxfs/xfs_alloc.h          |  24 ++--
 libxfs/xfs_attr_leaf.c      |   2 -
 libxfs/xfs_bmap.c           |   8 +-
 libxfs/xfs_bmap_btree.c     |   3 +-
 libxfs/xfs_btree.h          |   2 +-
 libxfs/xfs_da_format.h      |  75 ++++++++++--
 libxfs/xfs_fs.h             |   6 +-
 libxfs/xfs_ialloc.c         |  32 +++--
 libxfs/xfs_ialloc_btree.c   |   3 +-
 libxfs/xfs_refcount.c       |  22 ++--
 libxfs/xfs_refcount_btree.c |   8 +-
 libxfs/xfs_rmap.c           |  10 +-
 libxfs/xfs_sb.c             |  56 ++++++++-
 m4/package_services.m4      |  42 +++++++
 scrub/Makefile              |  11 ++
 scrub/xfs.rules             |  13 ++
 23 files changed, 456 insertions(+), 177 deletions(-)
 create mode 100644 scrub/xfs.rules

--------47c290402b4aa1b06479fd83a07ea1949862b6a6f4f34265aa2a5038955b13a4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: ProtonMail

wnUEARYIACcFAmUAEyoJkOk12U/828uvFiEEj32Dn/1+aNUZzl9s6TXZT/zb
y68AACC4AQDiPqNusHK1TReWXAIJDl7Mg8Sbkv9abCFb7hkmbqefFQEAni/3
Wh8lm167NkFYkWwloTHUgjUYwJMfrezLxDzKdg0=
=9f+e
-----END PGP SIGNATURE-----


--------47c290402b4aa1b06479fd83a07ea1949862b6a6f4f34265aa2a5038955b13a4--

