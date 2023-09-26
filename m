Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35CE0E7F148
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 00:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbjI0AN5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 20:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjI0ALz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 20:11:55 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1D83AAC
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 16:29:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716A9C433C8;
        Tue, 26 Sep 2023 23:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695770989;
        bh=qc7WV+RKPlrkm+Z0d7peZxSd9LZNpp138OAavxxTeWU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=cAHldwxX0Z50dcP42yAvds1zyoRxG08KcvsOz+ymnpH3Nxw1/BzKArpoUHQTtscRu
         VBDBCqi6jUa4jMHy3aA5fNc6lLmmPp8nVKsAcF3+Hnka6FGQcDvHBpzFUND/euT7YW
         3THZSI4vZNyLG4zi7sO8rzsnopYTxfYL1lW8Xj8C8d+MkLMmNQ/31HWb5t+HfbfPpm
         3tdKwVS3SXEHEI7hgNFPdS79wlsY9GL2qhTZWhm3BY5fldWm4OOLBr0SH3K9pMauhR
         CGYPP5UMW5+ri74s+IZExGqedBy9TnphLThgU+9Sk9Vv2Me4PmcCEIsoFHuEn/rYYb
         n9gUvGqMH0Lag==
Date:   Tue, 26 Sep 2023 16:29:48 -0700
Subject: [PATCHSET v27.0 0/4] xfs: online repair of AG btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <169577059962.3313285.5801727504839472715.stgit@frogsfrogsfrogs>
In-Reply-To: <20230926231410.GF11439@frogsfrogsfrogs>
References: <20230926231410.GF11439@frogsfrogsfrogs>
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

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
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
 fs/xfs/scrub/agheader_repair.c     |    9 
 fs/xfs/scrub/alloc.c               |   16 +
 fs/xfs/scrub/alloc_repair.c        |  914 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.c              |    1 
 fs/xfs/scrub/common.h              |   19 +
 fs/xfs/scrub/ialloc_repair.c       |  874 ++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/newbt.c               |   48 ++
 fs/xfs/scrub/newbt.h               |    6 
 fs/xfs/scrub/refcount_repair.c     |  793 +++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.c              |  128 +++++
 fs/xfs/scrub/repair.h              |   43 ++
 fs/xfs/scrub/scrub.c               |   22 +
 fs/xfs/scrub/scrub.h               |    9 
 fs/xfs/scrub/trace.h               |  112 +++-
 fs/xfs/scrub/xfarray.h             |   22 +
 fs/xfs/xfs_extent_busy.c           |   13 +
 fs/xfs/xfs_extent_busy.h           |    2 
 31 files changed, 3103 insertions(+), 88 deletions(-)
 create mode 100644 fs/xfs/scrub/alloc_repair.c
 create mode 100644 fs/xfs/scrub/ialloc_repair.c
 create mode 100644 fs/xfs/scrub/refcount_repair.c

