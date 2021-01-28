Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E8BC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:04:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B84F064DE0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbhA1GER (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:04:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:38408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhA1GEJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 01:04:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2814364DD9;
        Thu, 28 Jan 2021 06:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611813809;
        bh=Mw/lhGem4OTcbs7PZIIAUnBSSgcZDc40YJ+NJGJP2h4=;
        h=Subject:From:To:Cc:Date:From;
        b=K6Tw2LnQfOjGIwAC3was6vBxcrU0p8bO+oCl3bJKXBbfETvnHeBE5mM4F9nq3GUMA
         LwPcDrcgGMcQ0E2LFk7vpd7wrTPlOx1BRE5k1ncjiqOkfPXnUNifGXM0riN24Qqh/O
         SzU02lt3AH6I+6sQqQmDCh/9h9CZvc4sRnlUfnrHXUasNGzwqoiuFZ7qI/Nr3rimi9
         XqDfU3clL2kIJQn+1r4FDaAB4b5kzAFTylQTJw+nN5oAmQdAtN2ZIJNc+22ffk2YyW
         XzDfW0pBf8gnVKgEl7G63xmL7v7Rov4tNCuheA016DzpsM96ridM1uNjJnQ8CPRwmH
         JNKWiCY2N0HZg==
Subject: [PATCHSET v3 0/2] xfs: speed up parallel workqueues
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com, bfoster@redhat.com
Date:   Wed, 27 Jan 2021 22:03:25 -0800
Message-ID: <161181380539.1525344.442839530784024643.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

After some discussion on IRC with Dave, we came to the conclusion that
our background workqueue behavior could use some tweaking.  Kernel
worker threads that scan the filesystem and/or run their own
transactions more closely fit the definition of an unbound workqueue --
the work items can take a long time, they don't have much in common with
the submitter thread, the submitter isn't waiting hotly for a response,
and we the process scheduler should deal with scheduling them.
Furthermore, we don't want to place artificial limits on workqueue
scaling because that can leave unused capacity while we're blocking
(pwork is currently used for mount time quotacheck).

Therefore, we switch pwork to use an unbound workqueue, and now we let
the workqueue code figure out the relevant concurrency.  We expose the
pwork workqueue via sysfs, and document the interesting knobs in the
administrator's guide.

v2: expose all the workqueues via sysfs
v3: only expose those workqueues that exist for kernel threads that
    create their own transactions, and update the admin guide.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=workqueue-speedups-5.12
---
 Documentation/admin-guide/xfs.rst |   38 +++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_iwalk.c                |    5 +----
 fs/xfs/xfs_log.c                  |    5 +++--
 fs/xfs/xfs_mru_cache.c            |    2 +-
 fs/xfs/xfs_pwork.c                |   25 +++++-------------------
 fs/xfs/xfs_pwork.h                |    4 +---
 fs/xfs/xfs_super.c                |   23 ++++++++++++++--------
 fs/xfs/xfs_super.h                |    6 ++++++
 8 files changed, 69 insertions(+), 39 deletions(-)

