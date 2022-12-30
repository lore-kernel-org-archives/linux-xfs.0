Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E09FC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:04:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235488AbiL3XEp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbiL3XEk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:04:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A94C61D0E2
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:04:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F0DCB81D94
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E779EC433D2;
        Fri, 30 Dec 2022 23:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441477;
        bh=TrGS9awgyGvAPKlRYRARn6yOX3Zs4Lk8CWZZKrvGjls=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=T8KPjbKGUmSOK/OBpWsUf80tNYYRng6Gtuo1tWbZv0xGOHpGXwmRiNEXb6/ZDt0jB
         +BUqeftwUHZn6QBVzpfqb5pgQvSaQeYbiV+Kb8wdc9IsJJ8g/QTnM5pYH+DFrJ+wdV
         Nf/CUUDFYcy61ETc2A1O2noPjrIFT1neiCq9ezVcDYd6l82VoUGlretHqspO+HPIxA
         mqhTsZyXZfTfGu29U/RQdFhZsI+V1ls+ghimSXVuYGzpoWgrVIsEIJ6hPBjriCo/Cs
         HE+MzioKSFOU0HRzJdQd84PCyDJt0WZ/f7RFZOBu22lKvjHNNTkzGxSwQ9PEBs5Wj9
         gdNT3oGGtVKlA==
Subject: [PATCHSET v24.0 0/9] xfs: move btree geometry to ops struct
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:33 -0800
Message-ID: <167243841359.696890.6518296492918665756.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
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

