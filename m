Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06EC5C433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B523D64E8D
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhBMFr0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 13 Feb 2021 00:47:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:57400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229648AbhBMFrZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 13 Feb 2021 00:47:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FE5564D9D;
        Sat, 13 Feb 2021 05:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613195205;
        bh=oRA5hhxmsAJfVkNdEdUqMigMm6K8GYwiYDx/pv7MEwQ=;
        h=Subject:From:To:Cc:Date:From;
        b=boEuj4KqPgSQBuAB0/1SYwHf634yGDxbONOe0n7wxAoHfKNo1Q6/VBWPrifPAuwjF
         CbD8/Odg4PvjsXmyvoLngnVrRhfSkFy4Z7jBL1jJfLrkmHx3IVlBUkWHn/T69K3NyO
         hdHphZ/b6g4JD3ATu2NtsNHXEXIGDK9e4m8f4L97cf9ZfEj3RAJQEB1yHT74CCS9da
         vg0VRMbPxXR9zMqVYjxJu0i6JTYE72dW4fK3XSamx5leXKS7BGYGCc++7TYlE9l6pn
         6ZxBURpZ85fR5J8QwirfMbQWRYJQEOzdq+uymNP68dZHyJx5Nry6NNPACnjs0AL0/J
         ZrEEPOz4VadLw==
Subject: [PATCHSET 0/3] xfs_repair: set needsrepair when dirtying filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Fri, 12 Feb 2021 21:46:44 -0800
Message-ID: <161319520460.422860.10568013013578673175.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In the base needsrepair patchset, we set up the basics of handling the
new NEEDSREPAIR flag in xfsprogs.  This second series enables repair to
protect users against the system going down after repair begins to dirty
the filesystem but before it completes.  We start by adding a write hook
to the xfs_mount so that repair can intercept the first write to set
NEEDSREPAIR on the filesystem and the ondisk super, and finish off by
inserting error injection points into libxfs and xfs_repair so that
fstests can verify that this actually works.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-set-needsrepair
---
 include/xfs_mount.h |    4 ++
 libxfs/init.c       |   68 +++++++++++++++++++++++++++++++++--
 libxfs/libxfs_io.h  |   19 ++++++++++
 libxfs/rdwr.c       |   10 +++++
 repair/globals.c    |    3 ++
 repair/globals.h    |    3 ++
 repair/progress.c   |    3 ++
 repair/xfs_repair.c |   99 +++++++++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 204 insertions(+), 5 deletions(-)

