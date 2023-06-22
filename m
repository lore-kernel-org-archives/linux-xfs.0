Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECC9BEB64D8
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jun 2023 12:12:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjFVMMm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jun 2023 08:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjFVMMl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jun 2023 08:12:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF4B199D
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jun 2023 05:12:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C14760A07
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jun 2023 12:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A509C433C8
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jun 2023 12:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687435959;
        bh=8CjtaMyA3aqUfAbjeeCQx9bNzWPjKO4ZfQ9A/SL9Gy4=;
        h=Date:From:To:Subject:From;
        b=iOvbewOVbXltZkCgaWP+zsP2QzhZQWQPY6Mz1j9O0wC2g4QJFanE2+iV+nNEP3YYK
         /ztde1sxQ0AYsmjZYiMugv63QsKzJQC/W7LY62uOOX5i5IXKlgO4Tpab5ejZ+m+Ph4
         5Z0Y2PglpC0TBN3/b6PZ5jiB1LrHd8lM+GYLUslNJIEbjAxguPFbpfZo+2iWDaY/0v
         CkCN1QlKh3IiQ7A4YoLIPj0YHrdswj+/azBEEM8Fi2SP88U+AlB8D9SRXtbcHjwag7
         TovqJn/2keepTPVZHBMQYUl0LnoN+cQXo/4f/aKZvxq8Nd1kidfC66ZDEbAdJun3kk
         wucMRZjM4hk0Q==
Date:   Thu, 22 Jun 2023 14:12:36 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: for-next updated to cd3e5d3cf
Message-ID: <20230622121236.kga7aya2uuh6qonh@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello.

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next

Has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

cd3e5d3cf6cf33cbddbac364183c1aebb1352378

16 new commits:

Darrick J. Wong (11):
      [03f97ae49] libxfs: test the ascii case-insensitive hash
      [cb8c70b01] xfs_db: move obfuscate_name assertion to callers
      [10a01bcdd] xfs_db: fix metadump name obfuscation for ascii-ci filesystems
      [5309ddc05] mkfs.xfs.8: warn about the version=ci feature
      [6a5285ec1] mkfs: deprecate the ascii-ci feature
      [2b686ab31] xfs_db: hoist name obfuscation code out of metadump.c
      [c51c8c857] xfs_db: create dirents and xattrs with colliding names
      [47560612f] xfs_db: make the hash command print the dirent hash
      [4d3226b6e] libxfs: deferred items should call xfs_perag_intent_{get,put}
      [c6b593ee4] libxfs: port list_cmp_func_t to userspace
      [05a3a3895] libxfs: port transaction precommit hooks to userspace

Dave Chinner (5):
      [8b2a40fff] xfs: restore allocation trylock iteration
      [a565e3456] xfs: fix AGF vs inode cluster buffer deadlock
      [daa2d8205] xfs: fix agf/agfl verification on v4 filesystems
      [629d6b3df] xfs: validity check agbnos on the AGFL
      [cd3e5d3cf] xfs: validate block number being freed before adding to xefi

Code Diffstat:

 db/Makefile              |   2 +-
 db/hash.c                | 418 ++++++++++++++++++++++++++++++++++++++++++++++-
 db/metadump.c            | 372 +++--------------------------------------
 db/obfuscate.c           | 393 ++++++++++++++++++++++++++++++++++++++++++++
 db/obfuscate.h           |  17 ++
 include/list.h           |   7 +-
 include/xfs_inode.h      |   3 +-
 include/xfs_trans.h      |   7 +
 libfrog/dahashselftest.h | 208 +++++++++++------------
 libfrog/list_sort.c      |  10 +-
 libxfs/defer_item.c      |  74 +++++----
 libxfs/libxfs_api_defs.h |   2 +
 libxfs/libxfs_priv.h     |   4 +-
 libxfs/logitem.c         | 165 ++++++++++++++++++-
 libxfs/trans.c           |  96 +++++++++++
 libxfs/util.c            |   4 +-
 libxfs/xfs_ag.c          |   5 +-
 libxfs/xfs_alloc.c       |  91 ++++++++---
 libxfs/xfs_alloc.h       |   6 +-
 libxfs/xfs_bmap.c        |  10 +-
 libxfs/xfs_bmap_btree.c  |   7 +-
 libxfs/xfs_ialloc.c      |  24 ++-
 libxfs/xfs_log_format.h  |   9 +-
 libxfs/xfs_refcount.c    |  13 +-
 libxfs/xfs_trans_inode.c | 113 +------------
 man/man8/mkfs.xfs.8.in   |  23 ++-
 man/man8/xfs_db.8        |  39 ++++-
 mkfs/xfs_mkfs.c          |  11 ++
 scrub/repair.c           |  12 +-
 29 files changed, 1484 insertions(+), 661 deletions(-)
 create mode 100644 db/obfuscate.c
 create mode 100644 db/obfuscate.h

-- 
Carlos
