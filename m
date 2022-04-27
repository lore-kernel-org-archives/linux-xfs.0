Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08ECDC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 00:51:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245394AbiD0AzF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 20:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356519AbiD0AzE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 20:55:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD361AD96
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 17:51:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2689CB82450
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 00:51:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD33CC385A4;
        Wed, 27 Apr 2022 00:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651020712;
        bh=DodJED3KcVqJWoqf+yTZO6EZ96BumpEq8fqSkCFtPn4=;
        h=Subject:From:To:Cc:Date:From;
        b=F3S1QgRtMo8rrygSjdNryizxlWhGZ4ssejyUys2hf+24YzWfWWHel9lUGrLi9dLF2
         IjHFSHPqaOaak7Q5ndYJkHyIH4pLIXh/fFuZrQPASYQGnjk5AM3eqx1+dcvmWT7cFq
         jRTyf1Ct3P+AuXlgriksKfJJPkKQ2KwmBirBfGUy0Igu6Jtk0HZaxbcyqOE8EiNnsL
         kUi+qu8+VVASocmskRvPlxuV0UWqCZQu98E/80Cy1NgQdTSwpXVkZI6G5lYZdJc1Fp
         cXsf15d0DyLHo2PgV7dWMoLF9e7vW/6HikJ/2iDHrP3UmIviXgFVawGX6RFz7dfoNq
         QpqYI48Yg+4uQ==
Subject: [PATCHSET v2 0/9] xfs: fix reflink inefficiencies
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        linux-xfs@vger.kernel.org
Date:   Tue, 26 Apr 2022 17:51:52 -0700
Message-ID: <165102071223.3922658.5241787533081256670.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

As Dave Chinner has complained about on IRC, there are a couple of
things about reflink that are very inefficient.  First of all, we
limited the size of all bunmapi operations to avoid flooding the log
with defer ops in the worst case, but recent changes to the defer ops
code have solved that problem, so get rid of the bunmapi length clamp.

Second, the log reservations for reflink operations are far far larger
than they need to be.  Shrink them to exactly what we need to handle
each deferred RUI and CUI log item, and no more.  Also reduce logcount
because we don't need 8 rolls per operation.  Introduce a transaction
reservation compatibility layer to avoid changing the minimum log size
calculations.

v2: better document the use of EFIs to track when refcount updates
    should be continued in a new transaction, disentangle the alternate
    log space reservation code

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=reflink-speedups-5.19
---
 fs/xfs/libxfs/xfs_bmap.c       |   22 ----
 fs/xfs/libxfs/xfs_log_rlimit.c |   75 +++++++++++++-
 fs/xfs/libxfs/xfs_refcount.c   |   14 ++-
 fs/xfs/libxfs/xfs_refcount.h   |   13 +-
 fs/xfs/libxfs/xfs_trans_resv.c |  214 +++++++++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_trans_resv.h |   16 ++-
 fs/xfs/xfs_reflink.c           |   95 +++++++++++-------
 fs/xfs/xfs_trace.h             |   32 ++++++
 fs/xfs/xfs_trans.c             |    3 -
 9 files changed, 345 insertions(+), 139 deletions(-)

