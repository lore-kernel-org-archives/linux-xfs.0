Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9CC5C3DA7C
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:16:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235470AbiL3XQL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:16:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235164AbiL3XQK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:16:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14335BE2D;
        Fri, 30 Dec 2022 15:16:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C902BB81DA2;
        Fri, 30 Dec 2022 23:16:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C48C433D2;
        Fri, 30 Dec 2022 23:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442167;
        bh=ovcKWM5Uho36USPv9J6yLJTaLefJBBEhmq1kOETlN1k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=W7En7Fz7jN0QQoD6PBUpHHTU7ET9u33VWQN9xQNWYSoEfRoUcbhztqgsvq+6K4VFl
         rXCo1fRJp8372yKMC08Xg1MlIgMJ76cD0swDgj2KgIHxCZdKBgDOQVXMn0hoZ+Wnp9
         x3xuKxPBdwux6P57+1QyuDeGGMZzT2ah9sF7kN4MWUCH0u6ppkgefPmB6QyyBR73CQ
         HkHRciTy+/7r0KGxyOUF9+CTAYeaY+xM+L6F0B/Kec6PKb56VPrjJkL1OkZCTclScO
         oA72eSYLvfiilX28f/SjZub7a8899UGG9GlHtHr73aTAZ9+n6k4ntYV5FxxijZ+wZd
         SITAljvasK3GA==
Subject: [PATCHSET v24.0 0/2] fstests: online repair of AG btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:12 -0800
Message-ID: <167243875241.723308.1395808663517469875.stgit@magnolia>
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
 README            |    3 ++
 common/fuzzy      |   39 +++++++++++++++++++--------
 common/rc         |    2 +
 common/xfs        |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/725     |   37 +++++++++++++++++++++++++
 tests/xfs/725.out |    2 +
 tests/xfs/726     |   37 +++++++++++++++++++++++++
 tests/xfs/726.out |    2 +
 tests/xfs/727     |   38 ++++++++++++++++++++++++++
 tests/xfs/727.out |    2 +
 tests/xfs/728     |   37 +++++++++++++++++++++++++
 tests/xfs/728.out |    2 +
 tests/xfs/729     |   37 +++++++++++++++++++++++++
 tests/xfs/729.out |    2 +
 tests/xfs/730     |   37 +++++++++++++++++++++++++
 tests/xfs/730.out |    2 +
 tests/xfs/731     |   37 +++++++++++++++++++++++++
 tests/xfs/731.out |    2 +
 18 files changed, 382 insertions(+), 13 deletions(-)
 create mode 100755 tests/xfs/725
 create mode 100644 tests/xfs/725.out
 create mode 100755 tests/xfs/726
 create mode 100644 tests/xfs/726.out
 create mode 100755 tests/xfs/727
 create mode 100644 tests/xfs/727.out
 create mode 100755 tests/xfs/728
 create mode 100644 tests/xfs/728.out
 create mode 100755 tests/xfs/729
 create mode 100644 tests/xfs/729.out
 create mode 100755 tests/xfs/730
 create mode 100644 tests/xfs/730.out
 create mode 100755 tests/xfs/731
 create mode 100644 tests/xfs/731.out

