Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DFF2C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235807AbiLaBAc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235750AbiLaBAc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:00:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2617C1C921
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:00:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAD23B81DEF
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE77C433EF;
        Sat, 31 Dec 2022 01:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448428;
        bh=Ukg1CXMzx3mra0tCrbEL50tuHnOd06rDZPJDSbLtgPM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fvZuqYME+wZaT+jlK4kOcgOWNTBPdgKVDJawK3eXJ6idsFir3oETX2QOlltId9nYn
         4IXp3zV82z7to8PUY2RATdTpM7OVWN7Yj994BhSUfeP/7abGZs8WAXC5K0x0UU3Pm9
         AWb9PcZaImnSHCckKFVJkSE5dRI/Wjh2WQ/V3HQhMPVSVc1xDmqiAcW+7pDjxW9qTj
         UPXvd1hBmyPhQsdbvo4/Mvwo38aCO0vXLXV5Oi7jlCD3oFt6156H3vqzi3ke9o/o7d
         WLTUYGYLxhBtUGX6VnylaWu7VOCA4Oz9fXjpEgSodUXSaWl24pDvkyhke41hHtz1zB
         EqSpYr1zHgb/A==
Subject: [PATCHSET v1.0 00/10] libxfs: refactor rt extent unit conversions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:28 -0800
Message-ID: <167243876812.727509.17144221830951566022.stgit@magnolia>
In-Reply-To: <Y69UsO7tDT3HcFri@magnolia>
References: <Y69UsO7tDT3HcFri@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series replaces all the open-coded integer division and
multiplication conversions between rt blocks and rt extents with calls
to static inline helpers.  Having cleaned all that up, the helpers are
augmented to skip the expensive operations in favor of bit shifts and
masking if the rt extent size is a power of two.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=refactor-rt-unit-conversions

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=refactor-rt-unit-conversions
---
 include/libxfs.h         |    1 
 include/xfs_mount.h      |    2 +
 libfrog/Makefile         |    1 
 libfrog/div64.h          |   83 +++++++++++++++++++++++++++++++++++++++++
 libxfs/libxfs_priv.h     |   93 ++++++++++++----------------------------------
 libxfs/xfs_bmap.c        |   19 +++------
 libxfs/xfs_rtbitmap.c    |    4 +-
 libxfs/xfs_rtbitmap.h    |   88 ++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_sb.c          |    2 +
 libxfs/xfs_swapext.c     |    7 ++-
 libxfs/xfs_trans_inode.c |    3 +
 libxfs/xfs_trans_resv.c  |    3 +
 mkfs/proto.c             |   13 +++---
 repair/agheader.h        |    2 -
 repair/dinode.c          |   21 ++++++----
 repair/incore.c          |   16 ++++----
 repair/incore.h          |    4 +-
 repair/phase4.c          |   16 ++++----
 repair/rt.c              |    4 +-
 19 files changed, 259 insertions(+), 123 deletions(-)
 create mode 100644 libfrog/div64.h

