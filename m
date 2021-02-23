Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67CA4C43381
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:01:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 129FE64E6B
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:01:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhBWDBA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 22:01:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:47364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230053AbhBWDA7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Feb 2021 22:00:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C507664E41;
        Tue, 23 Feb 2021 03:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614049218;
        bh=Ai6Yh4Vo1St0M/Pcg2+FbjHcMBbacCIdajiFd6Cpb5Y=;
        h=Subject:From:To:Cc:Date:From;
        b=UqBJKwzNLxL1RiYZo3sN5KuPIJaM2VCr8Vjwn1rhuRnxz6pWs2QOeoD0sUT8fGOet
         6JFalrLYxiiZioTd4SRP0cJVXYgmVkaPlXOU+w08VM7utcVYLe4O7ob/oXwGmyaZts
         GNxrYTMegVzYIMqCim3OouW9YZ1mISNMmC5P/ygunHWzUlpYx5Zo8r5fex2ZXHYIUi
         Qs/uBQ9sW2RuyMEsWWqQBJ0KrroLFY4Znls0rHoGE43p4erBuyUV1DGW4p2jtx+skL
         g6fB/KBsR1brx7SDnSo6lxkv7KPaVJX73FClCszcvobhy71OTt3wpNtU4gFz9dXi5v
         RecONRyWs4s4Q==
Subject: [PATCHSET v6 0/7] xfsprogs: add the ability to flag a fs for repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Mon, 22 Feb 2021 19:00:18 -0800
Message-ID: <161404921827.425352.18151735716678009691.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series adds userspace support for a new incompat feature flag so
that we can force a sysadmin to run xfs_repair on a filesystem before
mounting.  This will be used in conjunction with v5 feature upgrades.
All of these patches are reviewed and (hopefully) already in Eric's
upstream tree.

v2: tweak the "can't upgrade" behavior and repair messages
v3: improve documentation, define error codes for the upgrade process, and
    only force repair if NEEDSREPAIR is set
v4: move all the upgrader code to xfs_repair per Eric suggestion
v5: various fixes suggested by reviewers, and document deprecated V4 options
v6: break this series into smaller pieces since this is all the reviewed stuff;
    and fix some comments

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
 db/check.c           |    5 ++++
 db/sb.c              |   13 ++++++++++++
 db/xfs_admin.sh      |   13 ++++++------
 include/xfs_mount.h  |    1 +
 libxfs/init.c        |   20 ++++++++++++------
 man/man8/xfs_admin.8 |    8 +++++++
 repair/agheader.c    |   21 +++++++++++++++++++
 repair/xfs_repair.c  |   56 ++++++++++++++++++++++++++++++++++++++++++--------
 8 files changed, 115 insertions(+), 22 deletions(-)

