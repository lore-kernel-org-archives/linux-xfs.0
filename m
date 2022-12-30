Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B4FAC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:57:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235723AbiLaA5l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:57:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiLaA5j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:57:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEDD1CFD2
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:57:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B69B61D66
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B94FC433EF;
        Sat, 31 Dec 2022 00:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448257;
        bh=A4qHz32Trq3EMKo0rXjfYy6wAcK2cY0080eUmUpfDzo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HoBwH7nPjXBdP0jQn0SBQu/Mx4R5P9D2Fvz+w49sPKZIy1cCNCrNPjD909NQsP+YW
         ToS8Gs59bdSTbry15ug4AqEJ4fqawAm2CunPKEutYzhrvDdQCvq/6CGqklTqyF8uLu
         7HInYQWvrZ+pVDLvPJ4qYdYihM8cmUon4VSk5BbMpyFf/KmZJEUGYYQFJ7+o1XzHvl
         VEWTyxm0Xn4PdSgJV3dQ0E38Fy5zUipXEDqlpM9K8um1FN/XKhIDry51IIcgROvzaP
         ii2gyvUIX74RSBS3QEH4MQtxY1Shznu4H7RL+Tz1RpDs4KGL6L/dGHEDgjZsgIL5Gc
         /vc46ipYSQg6w==
Subject: [PATCHSET v1.0 0/2] xfs: extent free log intent cleanups
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:05 -0800
Message-ID: <167243868517.714498.12799285534857942283.stgit@magnolia>
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

This series cleans up some warts in the extent freeing log intent code.
We start by acknowledging that this mechanism does not have anything to
do with the bmap code by moving it to xfs_alloc.c and giving the
function a more descriptive name.  Then we clean up the tracepoints and
the _finish_one call paths to pass the intent structure around.  This
reduces the overhead when the tracepoints are disabled and will make
things much cleaner when we start adding realtime support in the next
patch.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=extfree-intent-cleanups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=extfree-intent-cleanups
---
 fs/xfs/libxfs/xfs_ag.c         |    3 ++-
 fs/xfs/libxfs/xfs_alloc.c      |   14 +++++++-------
 fs/xfs/libxfs/xfs_alloc.h      |   20 +++++++-------------
 fs/xfs/libxfs/xfs_bmap.c       |   14 +++++++++-----
 fs/xfs/libxfs/xfs_bmap_btree.c |    2 +-
 fs/xfs/libxfs/xfs_ialloc.c     |    6 +++---
 fs/xfs/libxfs/xfs_refcount.c   |    7 ++++---
 fs/xfs/scrub/newbt.c           |    4 ++--
 fs/xfs/scrub/reap.c            |   11 +++++++----
 fs/xfs/xfs_extfree_item.c      |    6 ++----
 fs/xfs/xfs_reflink.c           |    2 +-
 fs/xfs/xfs_trace.h             |   33 +++++++++++++++------------------
 12 files changed, 60 insertions(+), 62 deletions(-)

