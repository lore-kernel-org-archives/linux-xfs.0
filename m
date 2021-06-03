Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 916C7C47092
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 03:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7952161263
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 03:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhFCDOi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 23:14:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229747AbhFCDOi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 23:14:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2FE061263;
        Thu,  3 Jun 2021 03:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622689974;
        bh=68+iUOMiutL411xT4b+KT2O6oG/3/zAYIPZJB6+/tas=;
        h=Subject:From:To:Cc:Date:From;
        b=o4WA4UrjAMalR84eQBazaaPBJ54sizvIB2G7+osA7CGiTdEZ7EeHoKXryh6TZEwZs
         mOMEvNOxu37T8I/kEwpXkPjQTp91jtJ4QLu/l3wxzUpw7qQ2L/FxfJ591t04AnPDGc
         lgcRWOFftyhCHSs5r/QwOKC5lNUd7dMDYauVvJBkyeEHecrneyXyi1oS7/BIvGzHOo
         qxps1God9vg8aUBaeYRT42AFmb7OVV9A9zBuDYB5rJlNvL/mIQcS1ANdDw0+mUIf3+
         Yxeh6JhtFvvFrdhD6BH1SOtSK4Ei65t1Te6rTCx0Del524LUZkUbbeuQV37YHDzA3W
         4LDt/JEdjp8SA==
Subject: [PATCHSET 0/2] xfs: rename struct xfs_eofblocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 02 Jun 2021 20:12:54 -0700
Message-ID: <162268997425.2724263.18220495607834735216.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In the old days, struct xfs_eofblocks was an optional parameter to the
speculative post-EOF allocation garbage collector to narrow the scope of
a scan to files fitting specific criteria.  Nowadays it is used for all
other kinds of inode cache walks (reclaim, quotaoff, inactivation), so
the name is no longer fitting.  Change the flag namespace and rename the
structure to something more appropriate for what it does.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=rename-eofblocks-5.14
---
 fs/xfs/xfs_file.c   |    8 +-
 fs/xfs/xfs_icache.c |  164 ++++++++++++++++++++++++++-------------------------
 fs/xfs/xfs_icache.h |   33 +++++++---
 fs/xfs/xfs_ioctl.c  |   30 +++++----
 fs/xfs/xfs_trace.h  |   36 ++++++-----
 5 files changed, 143 insertions(+), 128 deletions(-)

