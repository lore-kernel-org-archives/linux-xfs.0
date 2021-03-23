Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC541C433E6
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 04:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8B9F619B9
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 04:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhCWEUa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 00:20:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhCWEUT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Mar 2021 00:20:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1485261990;
        Tue, 23 Mar 2021 04:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616473219;
        bh=O4d3r87BXzzgYGOCdFTu7NB3tjBg+JgH9Iz/4AFhSJo=;
        h=Subject:From:To:Cc:Date:From;
        b=FGB+TSIsyu/gLMIQ7bBmv8GUUO7MOMiKKXJRR9Ru3SyK2A3DHUd61aY8v6+aRxn62
         X3/RjxHfj5e/DQ2x9FdlfMbUQUgOiKNLIQ7P6Wqt8QKZNM0MSfhmo0gmrItFIrL1ZQ
         /bticDJraQBOLICBrJ4CcxHbEsyLr5v+CJWx5srW4H5dc/bT/uVZgdgReCX3MbK13N
         bswX6/NyHd9Hc/AtpxTmVAYb5whRegjGTx7nHb4cFW+ccu4t47Gfl8/7VTt4RpqOj/
         J6C9UdduHeFF8vZ6r74VpRAq0He9UwVBif+SUe3B7hNzpQuCXRxT0kgxjEDxZE6unc
         4V50vaSJjHcbA==
Subject: [PATCHSET 0/2] fstests: test xfs_db directory navigation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 22 Mar 2021 21:20:18 -0700
Message-ID: <161647321880.3430916.13415014495565709258.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here are functional tests for a couple of xfs_db tests to improve the
usability of xfs_db by enabling users to navigate to inodes by path and
to list the contents of directories.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfs_db-directory-navigation

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=xfs_db-directory-navigation
---
 tests/xfs/917     |   98 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/917.out |   19 +++++++++
 tests/xfs/918     |  109 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/918.out |   27 +++++++++++++
 tests/xfs/group   |    2 +
 5 files changed, 255 insertions(+)
 create mode 100755 tests/xfs/917
 create mode 100644 tests/xfs/917.out
 create mode 100755 tests/xfs/918
 create mode 100644 tests/xfs/918.out

