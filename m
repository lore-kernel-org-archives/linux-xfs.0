Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C550BC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbiLaA50 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:57:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiLaA50 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:57:26 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB2DF03A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:57:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BC995CE19E1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04AE2C433EF;
        Sat, 31 Dec 2022 00:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448242;
        bh=ifweVBEfk9yk3aIv42afQ6/ysKTo5WA5JQFGcCA1iYA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=U0VhI7+kvb/tyWJ/TFMbBOPnfAnwnT5Wy613+gNKfjxsa1yZCm9cG5p9Q3skTXAI4
         HJx1Q1l3B3azms7VfQZgKblcgA/DMVbiUIJ9ypDnsJkAQ7k+EkESpeGE61KCKfBcbc
         sZG08wF6BGsQODjso/uMl2l2yjN+nRUCw5iQk+xSaPHQbKLh0BiIbTS+GQb88QR1W3
         0YFLY4LG8kxIQS8VAa9iXMqWs7bDJH9OT/dTQ3PI12JsV8+NKNP9EzJxmj98vVNRnp
         IRQEykDoIVlnXR2JVpfa0DRpU+yDiej0QNvokAESBVzMNcxuYlecZL96JN0762/c39
         5Bf9HkEZQzR9w==
Subject: [PATCHSET v1.0 0/2] xfs: enable in-core block reservation for rt
 metadata
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:02 -0800
Message-ID: <167243868195.714306.16190516279141417082.stgit@magnolia>
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

In preparation for adding reverse mapping and refcounting to the
realtime device, enhance the metadir code to reserve free space for
btree shape changes as delayed allocation blocks.

This effectively allows us to pre-allocate space for the rmap and
refcount btrees in the same manner as we do for the data device
counterparts, which is how we avoid ENOSPC failures when space is low
but we've already committed to a COW operation.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=reserve-rt-metadata-space

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=reserve-rt-metadata-space
---
 fs/xfs/libxfs/xfs_ag.c       |    4 -
 fs/xfs/libxfs/xfs_ag_resv.c  |   25 ++----
 fs/xfs/libxfs/xfs_ag_resv.h  |    2 
 fs/xfs/libxfs/xfs_errortag.h |    4 +
 fs/xfs/libxfs/xfs_imeta.c    |  187 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_imeta.h    |   11 ++
 fs/xfs/libxfs/xfs_types.h    |    7 ++
 fs/xfs/scrub/newbt.c         |    3 -
 fs/xfs/scrub/repair.c        |    5 -
 fs/xfs/xfs_error.c           |    3 +
 fs/xfs/xfs_fsops.c           |   39 +++++----
 fs/xfs/xfs_fsops.h           |    2 
 fs/xfs/xfs_inode.h           |    3 +
 fs/xfs/xfs_mount.c           |   10 ++
 fs/xfs/xfs_mount.h           |    1 
 fs/xfs/xfs_rtalloc.c         |   23 +++++
 fs/xfs/xfs_rtalloc.h         |    5 +
 fs/xfs/xfs_super.c           |    6 -
 fs/xfs/xfs_trace.h           |   46 ++++++++++
 19 files changed, 335 insertions(+), 51 deletions(-)

