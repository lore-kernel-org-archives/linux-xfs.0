Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C80AC07E95
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 02:57:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E57A61429
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 02:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhGCDAS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jul 2021 23:00:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230215AbhGCDAS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Jul 2021 23:00:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BE1D613EB;
        Sat,  3 Jul 2021 02:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625281065;
        bh=Pun0rXRtphqHab5Qk4dipgXuVHmzLR/I06CmlTcu1Es=;
        h=Subject:From:To:Cc:Date:From;
        b=ohJ8OcsRcU4RTYerzlc1ffLNfQEmETAsctbVVZ7fVmdNV0kVW/a3qlLRw8ZkInKge
         DCSlvQq3sgfVuhYhS0CMa8+rp61PVDe+M3ILz6EWrVN4NwsVhoKtdAGVYkaDzM/Kdw
         0SroHCGeAOJCEJnT0TLoeB5O83PTABepXti9Nl2JbaiLPlHH1XWpqFjSoV5QZ25nrK
         uB9gvjtE/fuNpLXCHf2j1AILQwJQSm+tzD7c5e+eyN3L9A3oNiVybP6N8b91ix6vuh
         phIMsawJh952WmjDz0+5/W+q5Hu2aQxiv5qbQsYjvvfMBgjW2FDzE07QXH0eAKdl25
         FG6Qy5XRB4jbw==
Subject: [PATCHSET 0/2] xfsprogs: strengthen validation of extent size hints
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com, hch@infradead.org
Date:   Fri, 02 Jul 2021 19:57:44 -0700
Message-ID: <162528106460.36302.18265535074182102487.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

While playing around with realtime extent sizes and extent size hints, I
noticed that it was very possible for userspace to trip the inode
verifiers if they tried to set an extent size hint that wasn't aligned
to the rt extent size and then create realtime files.  This series
tightens the existing checks and refactors the ioctls to use the libxfs
validation functions like the verifiers, mkfs, and repair use.

For v2, we also detect invalid extent size hints on existing filesystems
and mitigate the problem by (a) not propagating the invalid hints to new
realtime files and (b) removing invalid hints when set on directories.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=extsize-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=extsize-fixes
---
 mkfs/xfs_mkfs.c |    7 ++++---
 repair/dinode.c |   28 +++++++++++++++++++++++++++-
 2 files changed, 31 insertions(+), 4 deletions(-)

