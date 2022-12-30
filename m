Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EFFFC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:20:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236362AbiLaDU0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236216AbiLaDUZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:20:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11382733
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:20:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52090B81E65
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0062BC433D2;
        Sat, 31 Dec 2022 03:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456822;
        bh=jpK/RwsswreX8Sg5CZUJOpYsVLsGt7QWlv52yNoZFTA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Se9IupJ9m3+4dekzB1SyhuKub2PxgGnPWVAiG4E1KmXEYOoxY3xztq7HE1PEX68MN
         CeILA3/ZaLTuvmrYRrl/FgLiayAlVfgQ7rrnFrC8xnkP3CQK2yBbcjGoWvtWhkr9bk
         ZVt67VzO4Hp8zWBQQyo+BgXUtgqHdgHsmezgywya6YmouOvkS/UBdJCDCe7dZEvR1+
         Vp0wX+rEfACMkeZqXF5L8tzGFcKHXcJoGqlL1Yc0Guxf7RPvE4j4RLfsF6f0wxYCgt
         mBWMGF29exGsN/0Tq9LZgQ9HZQx2Kcp6WOqU0AGkL6nl2gsWRrhh2USE225RWWa5Xp
         rUBrQBOqiH8oQ==
Subject: [PATCHSET 0/3] xfs: vectorize scrub kernel calls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:23 -0800
Message-ID: <167243876361.726950.2109456102182372814.stgit@magnolia>
In-Reply-To: <Y69Uw6W5aclS115x@magnolia>
References: <Y69Uw6W5aclS115x@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Create a vectorized version of the metadata scrub and repair ioctl, and
adapt xfs_scrub to use that.  This is an experiment to measure overhead
and to try refactoring xfs_scrub.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=vectorized-scrub

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=vectorized-scrub

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=vectorized-scrub
---
 fs/xfs/libxfs/xfs_defer.c |   14 +++
 fs/xfs/libxfs/xfs_fs.h    |   37 +++++++++
 fs/xfs/scrub/btree.c      |   88 +++++++++++++++++++++
 fs/xfs/scrub/common.c     |  104 +++++++++++++++++++++++++
 fs/xfs/scrub/common.h     |    1 
 fs/xfs/scrub/dabtree.c    |   24 ++++++
 fs/xfs/scrub/inode.c      |    4 +
 fs/xfs/scrub/scrub.c      |  185 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.c      |   22 +++++
 fs/xfs/scrub/trace.h      |   80 +++++++++++++++++++
 fs/xfs/scrub/xfs_scrub.h  |    2 
 fs/xfs/xfs_ioctl.c        |   47 +++++++++++
 fs/xfs/xfs_trace.h        |   19 +++++
 fs/xfs/xfs_trans.c        |    3 +
 fs/xfs/xfs_trans.h        |    7 ++
 15 files changed, 636 insertions(+), 1 deletion(-)

