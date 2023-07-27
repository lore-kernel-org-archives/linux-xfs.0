Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9129EB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:20:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbjG0WUk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjG0WUj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:20:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15AC1187
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:20:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F47B61F50
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE08C433C7;
        Thu, 27 Jul 2023 22:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690496438;
        bh=CPGVNDFm25YNepW6S6Fwzhs9nhz9KGPMnDqOdK/NXHM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ImO+ZSLJ1/d3tF23JWUEyZwTe6pkyull2YJkpKxVT/0yS3xY0ySHmaN3EaQQbIr8Z
         NJWpseKYIGYC5eq91IOqCeXLw4L28vmv2ZylvtyJGRq1xQMsq45//IL1SRukCLRwGv
         0DXCoJ2OBIODgmECF84dFdKYiN7mXsqBGJlwrXzM/Ze+2W73VKJDsqaDdxrHAGsCJN
         pcXJCf8urY1kR/taCUg02gQlNpRi86JE1kfnSk3d0JwFAjYH606ThXNvKXulAYi288
         qCx0KJavIlEzvSIPaAja6tfD2sbvPKIHRfm87d7zv4grantPtfp4EGcxxHf36sbjuK
         lDUgf++d118JQ==
Date:   Thu, 27 Jul 2023 15:20:37 -0700
Subject: [PATCHSET v26.0 0/5] xfs: online repair of AG btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <169049625702.922264.5146998399930069330.stgit@frogsfrogsfrogs>
In-Reply-To: <20230727221158.GE11352@frogsfrogsfrogs>
References: <20230727221158.GE11352@frogsfrogsfrogs>
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
 fs/xfs/scrub/alloc.c               |   14 -
 fs/xfs/scrub/alloc_repair.c        |  912 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.c              |  153 ++++++
 fs/xfs/scrub/common.h              |   22 +
 fs/xfs/scrub/ialloc.c              |    3 
 fs/xfs/scrub/ialloc_repair.c       |  882 +++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/newbt.c               |   45 ++
 fs/xfs/scrub/newbt.h               |    6 
 fs/xfs/scrub/refcount_repair.c     |  796 +++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.c              |  128 +++++
 fs/xfs/scrub/repair.h              |   43 ++
 fs/xfs/scrub/scrub.c               |   22 +
 fs/xfs/scrub/scrub.h               |    9 
 fs/xfs/scrub/trace.h               |  134 ++++-
 fs/xfs/scrub/xfarray.h             |   22 +
 fs/xfs/xfs_extent_busy.c           |   13 +
 fs/xfs/xfs_extent_busy.h           |    2 
 fs/xfs/xfs_icache.c                |   38 --
 fs/xfs/xfs_icache.h                |    4 
 33 files changed, 3277 insertions(+), 131 deletions(-)
 create mode 100644 fs/xfs/scrub/alloc_repair.c
 create mode 100644 fs/xfs/scrub/ialloc_repair.c
 create mode 100644 fs/xfs/scrub/refcount_repair.c

