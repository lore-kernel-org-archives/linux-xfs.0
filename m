Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4FB8C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:15:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BD8D64E4F
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:15:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhBIEOt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Feb 2021 23:14:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:47952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229891AbhBIEKm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Feb 2021 23:10:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D705964EA4;
        Tue,  9 Feb 2021 04:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612843791;
        bh=M4IyBRF44ERg674GGecpkJpkr5AQWSTrEuO5KYbTYus=;
        h=Subject:From:To:Cc:Date:From;
        b=MwG6pp8UJqI/KtqUssyKgNVS/WjajLOnleuFb3oXUggoVcsmitLibEbJ2RBgyafdQ
         BZa7TDXWu9f6b7HIbXTkANe0z3MbHItIAmi3TH7N6mp1513S7dO72e9VHfXoHtnb1i
         9u2o+XWgIcE4Exr3rlpcNRQwb8AW4RxVGt5zUqtRRAiS0y15OQJNHjLUqkT/rWJtKf
         o0F8xIRkax81Lkpk1Rlq+q1Icrx5S75yQdRsPd4gua1l0d0GiDnrXsBE+RfYMgA9s/
         N0m1vh3dwkxr89Qx8+Cw5SKpQsprXT3lqV6cTOBgBmwsyJk3+iKVZSQeSbOsyzaGG9
         7U5EF5xrQmb6Q==
Subject: [PATCHSET v5 0/2] xfs_db: add minimal directory navigation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, chandanrlinux@gmail.com
Date:   Mon, 08 Feb 2021 20:09:50 -0800
Message-ID: <161284379028.3056690.9453785606632527710.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset improves the usability of xfs_db by enabling users to
navigate to inodes by path and to list the contents of directories.

v2: Various cleanups and reorganizing suggested by dchinner
v3: Rebase to 5.10-rc0
v4: fix memory leak
v5: pick up a review from Chandan; no other changes

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
 db/Makefile              |    3 
 db/command.c             |    1 
 db/command.h             |    1 
 db/namei.c               |  609 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/libxfs_api_defs.h |    1 
 man/man8/xfs_db.8        |   20 ++
 6 files changed, 634 insertions(+), 1 deletion(-)
 create mode 100644 db/namei.c

