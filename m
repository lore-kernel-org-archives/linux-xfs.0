Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C93AC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbjEZAdI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjEZAdI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:33:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51156EE
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:33:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB770608CC
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44DC5C433EF;
        Fri, 26 May 2023 00:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061186;
        bh=TrGS9awgyGvAPKlRYRARn6yOX3Zs4Lk8CWZZKrvGjls=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=uO4fYf8reEL+qEv+40HJIAWDA9zntmEHwZmCbUF5dSrNF3DvOylADaKBXY7uf+Jcy
         uV0ygrTuYui+i269BoWVsv1eKxqEhkNCPaW/jWu02HaVcUkKLaVbE3kk2RiP6r9Tpg
         SBP5CXd8a8S7vZdU4dqOaBJac0Fo6047XXXpfWLK8h11OUtlsxkgQg1a44OrtsKe3v
         zpz8KeOZYAJWTmLcNoKECSzeGU0j2e11XhDF0SrPDFhUZBklv703gB5YdWLOgzizsP
         e0OllSCxkQzz6auMIZxkkoTwvBDSJ/JI75Pqmh8oWdA2dT0WaPPhOkrC+zEEVqPKKk
         fb9eFzcp+COzg==
Date:   Thu, 25 May 2023 17:33:05 -0700
Subject: [PATCHSET v25.0 0/9] xfs: move btree geometry to ops struct
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506062668.3733506.5702088548886151666.stgit@frogsfrogsfrogs>
In-Reply-To: <20230526000020.GJ11620@frogsfrogsfrogs>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset prepares the generic btree code to allow for the creation
of new btree types outside of libxfs.  The end goal here is for online
fsck to be able to create its own in-memory btrees that will be used to
improve the performance (and reduce the memory requirements of) the
refcount btree.

To enable this, I decided that the btree ops structure is the ideal
place to encode all of the geometry information about a btree. The btree
ops struture already contains the buffer ops (and hence the btree block
magic numbers) as well as the key and record sizes, so it doesn't seem
all that farfetched to encode the XFS_BTREE_ flags that determine the
geometry (ROOT_IN_INODE, LONG_PTRS, etc).

The rest of the patchset cleans up the btree functions that initialize
btree blocks and btree buffers.  The bulk of this work is to replace
btree geometry related function call arguments with a single pointer to
the ops structure, and then clean up everything else around that.  As a
side effect, we rename the functions.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=btree-geometry-in-ops

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=btree-geometry-in-ops
---
 fs/xfs/libxfs/xfs_ag.c             |   33 +++++++----------
 fs/xfs/libxfs/xfs_ag.h             |    2 +
 fs/xfs/libxfs/xfs_alloc_btree.c    |   21 ++++-------
 fs/xfs/libxfs/xfs_bmap.c           |    9 +----
 fs/xfs/libxfs/xfs_bmap_btree.c     |   14 ++-----
 fs/xfs/libxfs/xfs_btree.c          |   70 +++++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_btree.h          |   36 ++++++++-----------
 fs/xfs/libxfs/xfs_btree_mem.h      |    9 -----
 fs/xfs/libxfs/xfs_btree_staging.c  |    6 +--
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   17 ++++-----
 fs/xfs/libxfs/xfs_refcount_btree.c |    8 ++--
 fs/xfs/libxfs/xfs_rmap_btree.c     |   16 ++++----
 fs/xfs/libxfs/xfs_shared.h         |    9 +++++
 fs/xfs/scrub/trace.h               |   10 ++---
 fs/xfs/scrub/xfbtree.c             |   16 +++-----
 15 files changed, 118 insertions(+), 158 deletions(-)

