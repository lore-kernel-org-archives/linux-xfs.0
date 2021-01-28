Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3901DC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:03:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECF4964DDA
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:03:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhA1GDG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:03:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:37980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhA1GDF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 01:03:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A14064DDF;
        Thu, 28 Jan 2021 06:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611813744;
        bh=iOZn9n6GEcNpICj4gcYHDKAILbz++qkDWXnHbN682hc=;
        h=Subject:From:To:Cc:Date:From;
        b=eXfJyD75xsjBvIqIXm9UcYVqkKwMBvoqAyDB8/VIWsCbSbqR7p3eVtAM9LY3eyStd
         RutIgimgN1571bY9OeWYIJBgbyY5SOlWXw9ZHYBrzBEj4W7A/YY46Q408uL6l7OEBb
         sOdsBQiVhA2ig/ilLzgfVCiOp3VdnDkBVIZPKqcqLHifJLVpvqBPULjwRW8UZR+elJ
         EQwk0kfKQVAMtjvnsfRPBkhN89nBTyGMCEs6M4pI1XUu7hfWTcrIQqvsrFq/aPuRW6
         rf4QHOXdUtR7cwRhG9KO9/Ync4hcH2j1Rctq8a2P36fsbVZKEKoliNcr1zSb58c6Di
         HpjvuvcFJIzXw==
Subject: [PATCHSET v5 00/11] xfs: try harder to reclaim space when we run out
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Wed, 27 Jan 2021 22:02:20 -0800
Message-ID: <161181374062.1525026.14717838769921652940.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Historically, when users ran out of space or quota when trying to write
to the filesystem, XFS didn't try very hard to reclaim space that it
might have speculatively allocated for the purpose of speeding up
front-end filesystem operations (appending writes, cow staging).  The
upcoming deferred inactivation series will greatly increase the amount
of allocated space that isn't actively being used to store user data.

Therefore, try to reduce the circumstances where we return EDQUOT or
ENOSPC to userspace by teaching the write paths to try to clear space
and retry the operation one time before giving up.

Previous iterations of this patchset made massive changes to the
codebase, but thanks to the transaction allocation helpers that Brian
pushed for (in the previous patchset) this is mostly no longer
necessary. :)

v2: clean up and rebase against 5.11.
v3: restructure the retry loops per dchinner suggestion
v4: simplify the calling convention of xfs_trans_reserve_quota_nblks
v5: constrain the open-coded 'goto retry' loops to the hlepers created
    in the previous patchset

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=reclaim-space-harder-5.12
---
 fs/xfs/xfs_file.c        |   24 +++---
 fs/xfs/xfs_icache.c      |  184 ++++++++++++++++++++++++++++++----------------
 fs/xfs/xfs_icache.h      |    7 +-
 fs/xfs/xfs_ioctl.c       |   11 +++
 fs/xfs/xfs_iops.c        |   10 ++-
 fs/xfs/xfs_quota.h       |   51 +++++++++++--
 fs/xfs/xfs_reflink.c     |    7 ++
 fs/xfs/xfs_trace.c       |    1 
 fs/xfs/xfs_trace.h       |   42 +++++++++++
 fs/xfs/xfs_trans.c       |   31 +++++++-
 fs/xfs/xfs_trans_dquot.c |  169 +++++++++++++++++++++++++++++++++++++++---
 11 files changed, 433 insertions(+), 104 deletions(-)

