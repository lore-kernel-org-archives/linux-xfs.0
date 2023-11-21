Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34206C61D92
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Nov 2023 13:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbjKUNN2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Nov 2023 08:13:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjKUNN2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Nov 2023 08:13:28 -0500
Received: from mail-4018.proton.ch (mail-4018.proton.ch [185.70.40.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F65D8
        for <linux-xfs@vger.kernel.org>; Tue, 21 Nov 2023 05:13:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maiolino.me;
        s=protonmail3; t=1700572400; x=1700831600;
        bh=Dv3kJnJ5IAkBih9wlgOt1KdFXhB0t75L+MGIgZCUNdY=;
        h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=UgcQZW0Ru1/p5y3BNXGhdn2K8I7X3qzVqstN5w+RNvmhPFoW26rwSwmMzhTVmE3Ak
         ydaaLOYTg+DqToGD+b32wya69EjQd8kYtnAYPmZwfGozrGt8LSs6PhMH2zAGVi0YZE
         9uYx2SRIPP53R2RQFrGZHPi/pj3CaTegUon28DmdBEdkPuPomd05itjqRg8tdq8vP+
         7TGKYjWsiLZkwydRzM72zGPjLzM2rvleT8z8bHYwIHsqQcMTseS8061Nov3TexiACR
         FczMyfdajUTvVsSlbKQC51Drf+73tTH3lKyESp9UJMdlwAimlUQ1RN3WrPs/VQBzyC
         KbtknZ5DGnx2Q==
Date:   Tue, 21 Nov 2023 13:12:25 +0000
To:     linux-xfs@vger.kernel.org
From:   Carlos Maiolino <carlos@maiolino.me>
Subject: [ANNOUNCE] xfsprogs: for-next updated to b1de31281
Message-ID: <rqo3gxbrqfg6z3uq6mpc2s3jsfrru3lndpfko7hhk5cjdpeq3j@fucr7okbtxrm>
Feedback-ID: 28765827:user:proton
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha256; boundary="------d02c8133b3fb38c88e7d17ffeb93955f4162c5b8e19ba85f4937baacfbc0cb14"; charset=utf-8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------d02c8133b3fb38c88e7d17ffeb93955f4162c5b8e19ba85f4937baacfbc0cb14
Content-Type: text/plain; charset=UTF-8
Date: Tue, 21 Nov 2023 14:12:22 +0100
From: Carlos Maiolino <carlos@maiolino.me>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: for-next updated to b1de31281
Message-ID: <rqo3gxbrqfg6z3uq6mpc2s3jsfrru3lndpfko7hhk5cjdpeq3j@fucr7okbtxrm>
MIME-Version: 1.0
Content-Disposition: inline

Hello.

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next

Has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

b1de312818e2fdcba5443d34fa7462b3df80babd

31 new commits:

Chandan Babu R (21):
      [3ea310101] metadump: Use boolean values true/false instead of 1/0
      [0d3650b23] mdrestore: Fix logic used to check if target device is large enough
      [c7196b8bb] metadump: Declare boolean variables with bool type
      [fb4697dd6] metadump: Define and use struct metadump
      [eba3f43eb] metadump: Add initialization and release functions
      [1e4702774] metadump: Postpone invocation of init_metadump()
      [be75f7d73] metadump: Introduce struct metadump_ops
      [1a5a88ec8] metadump: Introduce metadump v1 operations
      [46944d200] metadump: Rename XFS_MD_MAGIC to XFS_MD_MAGIC_V1
      [ead066280] metadump: Define metadump v2 ondisk format structures and macros
      [119265828] metadump: Define metadump ops for v2 format
      [0323bbf6b] xfs_db: Add support to read from external log device
      [50f2031ac] mdrestore: Declare boolean variables with bool type
      [1fb3dccce] mdrestore: Define and use struct mdrestore
      [214bf0a21] mdrestore: Detect metadump v1 magic before reading the header
      [80240ae3d] mdrestore: Add open_device(), read_header() and show_info() functions
      [bb78872ff] mdrestore: Replace metadump header pointer argument with a union pointer
      [0f47a5004] mdrestore: Introduce mdrestore v1 operations
      [019ddea09] mdrestore: Extract target device size verification into a function
      [fa9f484b7] mdrestore: Define mdrestore ops for v2 format
      [b1de31281] mdrestore: Add support for passing log device as an argument

Christian Brauner (1):
      [faea09b8b] Revert "xfs: switch to multigrain timestamps"

Christoph Hellwig (2):
      [2c7fe3b33] db: fix unsigned char related warnings
      [3bd45ce1c] repair: fix the call to search_rt_dup_extent in scan_bmapbt

Darrick J. Wong (3):
      [be49fa968] xfs: allow userspace to rebuild metadata structures
      [e01fe994e] xfs: fix log recovery when unknown rocompat bits are set
      [38d34b01d] xfs: adjust the incore perag block_count when shrinking

Jakub Bogusz (1):
      [c1b65c9cd] Polish translation update for xfsprogs 6.5.0.

Jeff Layton (2):
      [6cfd0b487] xfs: convert to ctime accessor functions
      [f99988c2f] xfs: switch to multigrain timestamps

Pavel Reichl (1):
      [9448c82ef] xfs_quota: fix missing mount point warning

Code Diffstat:

 db/hash.c                 |    45 +-
 db/io.c                   |    56 +-
 db/io.h                   |     2 +
 db/metadump.c             |   777 +-
 db/xfs_metadump.sh        |     3 +-
 include/xfs_inode.h       |    26 +-
 include/xfs_metadump.h    |    70 +-
 libfrog/paths.c           |    18 +-
 libxfs/xfs_ag.c           |     6 +
 libxfs/xfs_fs.h           |     6 +-
 libxfs/xfs_inode_buf.c    |     5 +-
 libxfs/xfs_sb.c           |     3 +-
 libxfs/xfs_trans_inode.c  |     2 +-
 man/man8/xfs_mdrestore.8  |     8 +
 man/man8/xfs_metadump.8   |    14 +
 mdrestore/xfs_mdrestore.c |   503 +-
 po/pl.po                  | 21543 ++++++++++++++++++++++----------------------
 repair/scan.c             |     6 +-
 18 files changed, 11969 insertions(+), 11124 deletions(-)

--------d02c8133b3fb38c88e7d17ffeb93955f4162c5b8e19ba85f4937baacfbc0cb14
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: ProtonMail

wnUEARYIACcFAmVcrLkJEOk12U/828uvFiEEj32Dn/1+aNUZzl9s6TXZT/zb
y68AABLSAQCVJQMgx9KRRaZ2FmvaBvypiYK8FKKVjSTZ8fhpLNtLkwEAnzUt
Dobm9gvuLE5OXEZR1QHGF1ENkA5hfjDikojxeQY=
=PM26
-----END PGP SIGNATURE-----


--------d02c8133b3fb38c88e7d17ffeb93955f4162c5b8e19ba85f4937baacfbc0cb14--

