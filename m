Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2C59C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235547AbiL3XBe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:01:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiL3XBd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:01:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BFA15FC1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:01:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DB1BB81D68
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC50C433F0;
        Fri, 30 Dec 2022 23:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441289;
        bh=ZuA3hDlYNhJfi8xnIEiX3YLuAqdVz/xU+7x2iRQrpPc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gomN/D8/RpoWMdTAh+kygmWV9vFtVD9WHkKHi9pzRbkPI9GyAWUxa9sP8mqIWEDCF
         s6MojL5y8Pjgdj5lk7oUYDdoeAWdYEnpjlfzVFO2I0YvYnO9sP9htFcflxWqmI/bs2
         90PIVCjhZakaJcIq8rcyPw4GQPMyr09v4SbwfLxC/BwbpogTGE0Mqe09s33kiPKUZo
         6xifHPtVp3JWf9thSoeBjT8g9l+4WnOkLsY1gDO6HxNZmoak8Njffc7X65V1Jr6dsm
         EZ+i4jq+mZ9Qc3BzxUStgtoLuJmDNDWHxtOERLz9xJmuiqBMW4MYsZKr+ZVzMYh6oH
         lDC/XgU5IF/0A==
Subject: [PATCHSET v24.0 0/5] xfs: online repair of AG btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:48 -0800
Message-ID: <167243836860.693494.7976721071711129282.stgit@magnolia>
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

Now that we've spent a lot of time reworking common code in online fsck,
we're ready to start rebuilding the AG space btrees.  This series
implements repair functions for the free space, inode, and refcount
btrees.  Rebuilding the reverse mapping btree is much more intense and
is left for a subsequent patchset.  The fstests counterpart of this
patchset implements stress testing of repair.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-ag-btrees

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-ag-btrees

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-ag-btrees
---
 fs/xfs/Makefile                    |    3 
 fs/xfs/libxfs/xfs_ag.h             |   10 
 fs/xfs/libxfs/xfs_ag_resv.c        |    2 
 fs/xfs/libxfs/xfs_alloc.c          |   18 -
 fs/xfs/libxfs/xfs_alloc.h          |    2 
 fs/xfs/libxfs/xfs_alloc_btree.c    |   13 -
 fs/xfs/libxfs/xfs_btree.c          |   26 +
 fs/xfs/libxfs/xfs_btree.h          |    2 
 fs/xfs/libxfs/xfs_ialloc.c         |   41 +-
 fs/xfs/libxfs/xfs_ialloc.h         |    3 
 fs/xfs/libxfs/xfs_refcount.c       |   18 -
 fs/xfs/libxfs/xfs_refcount.h       |    2 
 fs/xfs/libxfs/xfs_refcount_btree.c |   13 -
 fs/xfs/libxfs/xfs_types.h          |    7 
 fs/xfs/scrub/agheader_repair.c     |    4 
 fs/xfs/scrub/alloc.c               |   14 -
 fs/xfs/scrub/alloc_repair.c        |  912 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.c              |    1 
 fs/xfs/scrub/common.h              |   13 +
 fs/xfs/scrub/ialloc_repair.c       |  873 ++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/newbt.c               |   13 +
 fs/xfs/scrub/newbt.h               |    4 
 fs/xfs/scrub/reap.c                |   17 +
 fs/xfs/scrub/refcount_repair.c     |  791 +++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.c              |  128 +++++
 fs/xfs/scrub/repair.h              |   43 ++
 fs/xfs/scrub/scrub.c               |   22 +
 fs/xfs/scrub/scrub.h               |    9 
 fs/xfs/scrub/trace.h               |  112 +++-
 fs/xfs/scrub/xfarray.h             |   22 +
 fs/xfs/xfs_extent_busy.c           |   13 +
 fs/xfs/xfs_extent_busy.h           |    2 
 fs/xfs/xfs_icache.c                |  122 ++++-
 fs/xfs/xfs_trace.h                 |   22 +
 34 files changed, 3193 insertions(+), 104 deletions(-)
 create mode 100644 fs/xfs/scrub/alloc_repair.c
 create mode 100644 fs/xfs/scrub/ialloc_repair.c
 create mode 100644 fs/xfs/scrub/refcount_repair.c

