Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28E59C433DB
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 19:43:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D542D64F84
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 19:43:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhBCTn5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 14:43:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:44664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230365AbhBCTnx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Feb 2021 14:43:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CF4164F84;
        Wed,  3 Feb 2021 19:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612381392;
        bh=CcJjkbBw8mulRucj21olFo7nUzPD6IL8FZ5vRJzUSts=;
        h=Subject:From:To:Cc:Date:From;
        b=B1Ud2YZDDgRn4kqlCYmI+75ygpOHjlZdAEn2YhKi8Sst7HzaqGzc1P5BvGOU7KkKj
         ZaJQd/6kEo2/woCuAHkoHzWlt0XXyMGlKONpXy/0FJrQrlMj3Zqt8/Xh4WJwDr4No+
         2JpOBuXkYVU2f+VGP7il0Qqa4bypGD97v+Q8fSb/vbE4GpLpzlrr2wrbxLgNb761aI
         LdMa6J8eZ2O1oIdvfh/UQK+1sUH7L8ypPSb1Hwd+8Lsaul4ZyLLBBKYxiEY2K5sFk0
         vDsVijZPgCy3Rx+e7BWvDevOnd0jLtPDWqYFYBZqb+7eZllMserpSAEeGh77I1wrAQ
         wK7QcGgMbCbaQ==
Subject: [PATCHSET v3 0/5] xfs: add the ability to flag a fs for repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Date:   Wed, 03 Feb 2021 11:43:11 -0800
Message-ID: <161238139177.1278306.5915396345874239435.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series adds a new incompat feature flag so that we can force a
sysadmin to run xfs_repair on a filesystem before mounting.  This will
be used in conjunction with v5 feature upgrades.

v2: tweak the "can't upgrade" behavior and repair messages
v3: improve documentation, define error codes for the upgrade process, and
    only force repair if NEEDSREPAIR is set

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=needsrepair

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=needsrepair

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=needsrepair
---
 db/check.c           |    5 ++
 db/sb.c              |  160 ++++++++++++++++++++++++++++++++++++++++++++++++--
 db/xfs_admin.sh      |   32 +++++++++-
 include/xfs_mount.h  |    1 
 libxfs/init.c        |   12 +++-
 man/man8/xfs_admin.8 |   30 +++++++++
 man/man8/xfs_db.8    |   16 +++++
 repair/agheader.c    |   21 +++++++
 repair/xfs_repair.c  |   51 ++++++++++++++++
 9 files changed, 311 insertions(+), 17 deletions(-)

