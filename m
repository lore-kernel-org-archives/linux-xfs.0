Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B349C43381
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:05:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1AD764DDF
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:05:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhA1GEi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:04:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:38476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231205AbhA1GEX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 01:04:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8F4764DDF;
        Thu, 28 Jan 2021 06:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611813823;
        bh=4wRvPzWq0hCf8jTvMIIDbIWnL26uWd4TPOFU5+vR8gs=;
        h=Subject:From:To:Cc:Date:From;
        b=vNAI8aMSnZCQPFMSUPRL+RLnqz5o1+jzPoGQ3KILt071UWOnfeWZw6YR1lTvUcA33
         RlI2NOCBwZCVAyK3q3QzMj8qkcTduSdlDB301i9jybGV+q6WdPnNBqzSoxBQjNF8cn
         lQca5EUv0/ffc2VPkcb/Clh6tu3+XlmbyRWio4hGEWqzJFxoLnxRdklu2Cauka8ILN
         fYKoOp2RP93+bHXgikEF7kSeWCnlTp4KgWpn9yx5g0w2PKkRhP3/GjlbrThyfIzdKZ
         LAX2eEGMVRCJk+DXToHqpX4KOYLMX7VK0ZX3RidMxLvzefbSVZucG/lo+80uD1+25Z
         N8EnZABPs8xxA==
Subject: [PATCHSET v5 00/11] xfs: consolidate posteof and cowblocks cleanup
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com, bfoster@redhat.com
Date:   Wed, 27 Jan 2021 22:03:39 -0800
Message-ID: <161181381898.1525433.10723801103841220046.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Currently, we treat the garbage collection of post-EOF preallocations
and copy-on-write preallocations as totally separate tasks -- different
incore inode tags, different workqueues, etc.  This is wasteful of radix
tree tags and workqueue resources since we effectively have parallel
code paths to do the same thing.

Therefore, consolidate both functions under one radix tree bit and one
workqueue function that scans an inode for both things at the same time.
At the end of the series we make the scanning per-AG instead of per-fs
so that the scanning can run in parallel.  This reduces locking
contention from background threads and will free up a radix tree bit for
the deferred inode inactivation series.

More recent iterations of this patchset also rework the code to avoid
static predeclarations and take advantage of the evolutions of the
three previous patchsets.

v2: clean up and rebase against 5.11.
v3: various streamlining as part of restructuring the space reclaim series
v4: move the workqueue parallelism bits to their own series
v5: expose blockgc wq via sysfs and reduce iolock cycling.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=eofblocks-consolidation-5.12
---
 Documentation/admin-guide/xfs.rst |    3 
 fs/xfs/scrub/common.c             |    4 -
 fs/xfs/xfs_globals.c              |    7 -
 fs/xfs/xfs_icache.c               |  295 ++++++++++++++++---------------------
 fs/xfs/xfs_icache.h               |   16 +-
 fs/xfs/xfs_ioctl.c                |    2 
 fs/xfs/xfs_linux.h                |    3 
 fs/xfs/xfs_mount.c                |    5 +
 fs/xfs/xfs_mount.h                |    9 +
 fs/xfs/xfs_super.c                |   23 +--
 fs/xfs/xfs_sysctl.c               |   15 --
 fs/xfs/xfs_sysctl.h               |    3 
 fs/xfs/xfs_trace.h                |    6 -
 13 files changed, 170 insertions(+), 221 deletions(-)

