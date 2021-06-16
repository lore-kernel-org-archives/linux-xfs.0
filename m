Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEF8DC48BE5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 23:55:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94C516112D
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 23:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234722AbhFPX5p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 19:57:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhFPX5p (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 Jun 2021 19:57:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 656836112D;
        Wed, 16 Jun 2021 23:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623887738;
        bh=Bfy5jKBTELQA4nIaPSP5JzSbq371DjEgoXPzqBUHbxM=;
        h=Subject:From:To:Cc:Date:From;
        b=h5qh+yDIhYqAoQNCXO3TsnQ8fWnN8q+adywLTUf28fKOiFZoQAMQ5gI1w61Y6roDp
         CQkqoMdoDvwYg38VBcP908ZmpIEepk/3fYpqe574PkA3RvZwnEUrdvjNZFl+dTcLKv
         a8YdZmyQpveT++Ak0e4RBimrozs3SYSvzo+8zDg/DNYAKWUk/C/iBZlkVB/i4WmRO1
         mv45SA5ghJlswOchXLLQ+nT6Fxpa5H8H9pq23uRK3mJjepXR3Jmw6HNkZYcmmWoayF
         BWfiiUIbn+OgJ5yNMAymIi5czBMisJbW+9DR3YYubdLAuUZ6AlbI6EdDuGSF3plNgw
         L3M120TQKoHBw==
Subject: [PATCHSET 0/2] xfs: minor fixes to log recovery problems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 16 Jun 2021 16:55:38 -0700
Message-ID: <162388773802.3427167.4556309820960423454.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series fixes a couple of bugs that I found in log recovery.  The
first problem is that we don't reserve space for per-AG btree expansion
when we inactivate inodes during log recovery.  If a file with shared
blocks were to be unlinked, this can result in transaction failure
because inactivation assumes that it doesn't need to reserve blocks to
free files and cannot handle a refcount btree expansion.

The second problem addressed here is that if log recovery fails due to
something that doesn't directly impact the log (like ENOSPC during
transaction allocation, or ENOMEM allocating buffers) it will leave the
log running, which means that it writes an unmount record after recovery
fails.  The /next/ mount will see a clean log and start running, even
though the metadata isn't consistent.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=log-recovery-fixes-5.14
---
 fs/xfs/xfs_log.c         |    3 +++
 fs/xfs/xfs_log_recover.c |    5 ++++-
 fs/xfs/xfs_mount.c       |   10 +++++++++-
 3 files changed, 16 insertions(+), 2 deletions(-)

