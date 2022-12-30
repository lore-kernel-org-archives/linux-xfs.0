Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD16C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:58:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235655AbiLaA6M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:58:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiLaA6L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:58:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA99F03A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:58:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDD3DB81E06
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:58:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A379FC433D2;
        Sat, 31 Dec 2022 00:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448288;
        bh=IFDSATLJy3ksjSwyzOYTrtEO9zJbFLDxCvIS4Tu4OtA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iMW9pM07GAaYpZZEZitkqdYEEEhXnuU+SykwWlkWsr3jbMP6OgqSrK4a+Iwz2fKyf
         bb9s2VPqpRAwGtueEEWvakcUouTpY0isY2B0UzHg9psFmpfnI1IuVoj/tRknne1CG8
         +L73OCeJbA2c/FA7uYwpN1WTP4pLpMcoJBVwLbmYFFA/ckujfUowYs/PUd1uptbpLA
         PG7s0P8Ozz+USxTXSe1tR+x6J6dllP+UTLyT/AYv8HqthR3xSlxJVrBwMSZap7+Xj1
         TNy2Tx2qMNLfrd4VlWg3JoO/AYrzasG024bw6U9YMkXM/3j80Of3rvg13exCIFymph
         kFyLtKJwNa0tQ==
Subject: [PATCHSET v1.0 0/5] xfs: rmap log intent cleanups
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:11 -0800
Message-ID: <167243869156.714954.12346064053546135919.stgit@magnolia>
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

This series cleans up the rmap intent code before we start adding
support for realtime devices.  Similar to previous intent cleanup
patchsets, we start transforming the tracepoints so that the data
extraction are done inside the tracepoint code, and then we start
passing the intent itself to the _finish_one function.  This reduces the
boxing and unboxing of parameters.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=rmap-intent-cleanups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=rmap-intent-cleanups
---
 fs/xfs/libxfs/xfs_btree.c |    4 +
 fs/xfs/libxfs/xfs_btree.h |    2 
 fs/xfs/libxfs/xfs_rmap.c  |  233 +++++++++++++++++----------------------------
 fs/xfs/libxfs/xfs_rmap.h  |   10 ++
 fs/xfs/xfs_rmap_item.c    |   79 +++++++--------
 fs/xfs/xfs_trace.c        |    1 
 fs/xfs/xfs_trace.h        |  187 +++++++++++++++++++++++++-----------
 7 files changed, 265 insertions(+), 251 deletions(-)

