Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2D01C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 22 May 2022 15:28:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347796AbiEVP2T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 May 2022 11:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241366AbiEVP2S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 May 2022 11:28:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82D738BF6
        for <linux-xfs@vger.kernel.org>; Sun, 22 May 2022 08:28:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9134DB80CA2
        for <linux-xfs@vger.kernel.org>; Sun, 22 May 2022 15:28:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BADC385AA;
        Sun, 22 May 2022 15:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653233294;
        bh=NuKFQK/uztjzW9S1b8mg/lhX9AkHyoU2ba9KVMR1NnQ=;
        h=Subject:From:To:Cc:Date:From;
        b=AoeHfZrdQDDTQlJ66DHU/hcxPsQHGqLK1UbsbSq7VOabKVzJ7O0jSBbJ30XiofkM4
         uW/SKO2z97gY14rBFAPZLUmuDJBDbsD/oi3H7gu6lerRzcUaAVS7B+5em/jiI/S87W
         LGi6jgYnMR9zhX1ffuZe3k7YnSgppXWHE+SZof9CmV/uUMEzHn0o2zQSyT5wCQOH1B
         LLX0I8nIvRdkfyd8mgnvaD2AVfGlTG9JrUa+xbgTcBJ8HyiJxXedEMunwX5LiWeAIQ
         AMOQBRetX8ggQj366hecUC9cm9WBfv70N+r84hVXhYIv59XU0NSwxqP/9rULoAu7ai
         aYOWBLmRmrEdQ==
Subject: [PATCHSET 0/5] xfs: last pile of LARP cleanups for 5.19
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Sun, 22 May 2022 08:28:13 -0700
Message-ID: <165323329374.78886.11371349029777433302.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This final series contains a two key cleanups for the new LARP code.
Most of it is refactoring and tweaking the code that creates kernel log
messages about enabling and disabling features -- we should be warning
about LARP being turned on once per day, instead of once per insmod
cycle; we shouldn't be spamming the logs so aggressively about turning
*off* log incompat features.

The second part of the series refactors the LARP code responsible for
getting (and releasing) permission to use xattr log items.  The
implementation code doesn't belong in xfs_log.c, and calls to logging
functions don't belong in libxfs -- they really should be done by the
VFS implementation functions before they start calling into libraries.
As a side effect, we now amortize the cost of gaining xattr log item
permission across entire attrmulti calls.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=larp-cleanups-5.19
---
 fs/xfs/libxfs/xfs_attr.c |   12 +-------
 fs/xfs/scrub/scrub.c     |   17 +-----------
 fs/xfs/xfs_acl.c         |   10 +++++++
 fs/xfs/xfs_fsops.c       |    7 +----
 fs/xfs/xfs_ioctl.c       |   22 +++++++++++++---
 fs/xfs/xfs_ioctl.h       |    2 +
 fs/xfs/xfs_ioctl32.c     |    4 ++-
 fs/xfs/xfs_iops.c        |   25 ++++++++++++++----
 fs/xfs/xfs_log.c         |   41 -----------------------------
 fs/xfs/xfs_log.h         |    1 -
 fs/xfs/xfs_message.h     |   12 ++++++++
 fs/xfs/xfs_mount.c       |    1 -
 fs/xfs/xfs_super.h       |    2 +
 fs/xfs/xfs_xattr.c       |   65 ++++++++++++++++++++++++++++++++++++++++++++++
 14 files changed, 135 insertions(+), 86 deletions(-)

