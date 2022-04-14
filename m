Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56F26C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 22:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245194AbiDNW4a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 18:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244039AbiDNW43 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 18:56:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA5C644CA
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 15:54:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B934B82BDC
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 22:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9ACC385A9;
        Thu, 14 Apr 2022 22:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649976839;
        bh=vTh/1UL7ZAiCCGv+csLbS2XeDdHiJ+goN8RNax56IRc=;
        h=Subject:From:To:Cc:Date:From;
        b=WUOLcN/heQ//VduYzyrATzJkADjWIJashCxDPjg5gkPYiXjAnUqwivh+xBvpOk4nc
         T10jXFfQ8CK71rCf9Q9WBDO4Ulb7hqWzLRJbFmNfRd+9KKQ/vVqsCRE9OpdC29pRXj
         ovYkUiJxfZpTY6/9CXrRxn3vYssu53Fyt4fy+y92Gfe9Uq+hcT4RZXIdbvxROnvIHu
         qIjVDUf6vPLBCLsw796YOaxw0O96aj7aDxD4TY7M3J39+tMc7I0xNLViSprLQAkIQE
         6B1SQSmMeE5cKFMkUdVqp6O6l37vDg/MIydX9FMvDWJd65DIuflgEt6PYyjABN27aU
         RhgON0P0EIWZA==
Subject: [PATCHSET 0/4] xfs: fix rmap inefficiencies
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 14 Apr 2022 15:53:59 -0700
Message-ID: <164997683918.383709.10179435130868945685.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Reduce the performance impact of the reverse mapping btree when reflink
is enabled by using the much faster non-overlapped btree lookup
functions when we're searching the rmap index with a fully specified
key.  If we find the exact record we're looking for, great!  We don't
have to perform the full overlapped scan.  For filesystems with high
sharing factors this reduces the xfs_scrub runtime by a good 15%.

This has been shown to reduce the fstests runtime for realtime rmap
configurations by 30%, since the lack of AGs severely limits
scalability.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=rmap-speedups-5.19
---
 fs/xfs/libxfs/xfs_rmap.c |  132 +++++++++++++++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_rmap.h |    7 +-
 fs/xfs/scrub/bmap.c      |   24 +-------
 fs/xfs/xfs_trace.h       |    5 +-
 4 files changed, 94 insertions(+), 74 deletions(-)

