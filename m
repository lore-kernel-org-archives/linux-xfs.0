Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7E54C433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7840661152
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:29:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbhIRBad (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Sep 2021 21:30:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:36792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230044AbhIRBad (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Sep 2021 21:30:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33C8360FBF;
        Sat, 18 Sep 2021 01:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631928550;
        bh=osGnM/f/M18M1V5XLAdGKV+5n3mJvbTKKVU/ih7dSZM=;
        h=Subject:From:To:Cc:Date:From;
        b=cSqcilp9gDTGBobJ374zjid/tyw9mNvM40lA5GojEvuIQ+ALE2VO/6A3/dkcTrCEY
         JhaxIaFKBK99fYLGWJpUM3mVO1QpXvJR/6s6cMRw570bEh0hOFK3NzbaV8841uNIW7
         LkKmx/3ZCCsOE3fNbEOrN0I5ykJkkbDRPP9E3LwEyNgjD2YPrWXo6FEuPx+9oEGc0t
         3d3cbVrCvSc+TdjKloyUGJmgIMmmNaskEK6/aQFYEjW4kuILeProN2R88Mw5Pjt7zm
         p4CX+ZgrPhgnSu5PetGzYN6Nhe34sjzT42mI8kwqTB3atc1kv/xqVCTOWzTAeFt2sy
         0SPcWTQLIkd8w==
Subject: [PATCHSET RFC chandan 00/14] xfs: support dynamic btree cursor height
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@oracle.com, chandanrlinux@gmail.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 17 Sep 2021 18:29:09 -0700
Message-ID: <163192854958.416199.3396890438240296942.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Chandan Babu pointed out that his large extent counters series depends
on the ability to have btree cursors of arbitrary heights, so I've
ported this to 5.15-rc1 so his patchsets won't have to depend on
djwong-dev for submission.

In this series, we rearrange the incore btree cursor so that we can
support btrees of any height.  This will become necessary for realtime
rmap and reflink since we'd like to handle tall trees without bloating
the AG btree cursors.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=btree-dynamic-depth-5.16
---
 fs/xfs/libxfs/xfs_ag_resv.c        |    4 -
 fs/xfs/libxfs/xfs_alloc.c          |   18 +-
 fs/xfs/libxfs/xfs_alloc_btree.c    |    7 -
 fs/xfs/libxfs/xfs_bmap.c           |   24 ++-
 fs/xfs/libxfs/xfs_bmap_btree.c     |    7 -
 fs/xfs/libxfs/xfs_btree.c          |  266 ++++++++++++++++++++++++------------
 fs/xfs/libxfs/xfs_btree.h          |   52 +++++--
 fs/xfs/libxfs/xfs_btree_staging.c  |    8 +
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    7 -
 fs/xfs/libxfs/xfs_refcount_btree.c |    6 -
 fs/xfs/libxfs/xfs_rmap_btree.c     |   46 +++---
 fs/xfs/libxfs/xfs_rmap_btree.h     |    2 
 fs/xfs/libxfs/xfs_trans_resv.c     |   12 ++
 fs/xfs/libxfs/xfs_trans_space.h    |    7 +
 fs/xfs/scrub/agheader.c            |   13 +-
 fs/xfs/scrub/agheader_repair.c     |    8 +
 fs/xfs/scrub/bitmap.c              |   16 +-
 fs/xfs/scrub/bmap.c                |    2 
 fs/xfs/scrub/btree.c               |  118 ++++++++--------
 fs/xfs/scrub/btree.h               |   17 ++
 fs/xfs/scrub/dabtree.c             |   62 ++++----
 fs/xfs/scrub/repair.h              |    3 
 fs/xfs/scrub/scrub.c               |   60 ++++----
 fs/xfs/scrub/trace.c               |    7 +
 fs/xfs/scrub/trace.h               |   10 +
 fs/xfs/xfs_mount.c                 |    2 
 fs/xfs/xfs_super.c                 |   11 -
 fs/xfs/xfs_trace.h                 |    2 
 28 files changed, 466 insertions(+), 331 deletions(-)

