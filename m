Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B66BC47083
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 22:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F199D60FDC
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 22:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbhEaWmN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 May 2021 18:42:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231717AbhEaWmN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 31 May 2021 18:42:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 010B3611CA;
        Mon, 31 May 2021 22:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622500833;
        bh=QDOR0bNmWPCdx7ct2iu+RmZpzzOX7HdbRkeVpBIHhpk=;
        h=Subject:From:To:Cc:Date:From;
        b=lSZ/t0bbx5YbSq2dScFxSRKCUAoBT4cOvafJqFIonK0nqYmYpUR+h7gAUcAkoa1CN
         7BR67GL695uzljhqDfHQXot8xCJVjYVJI4bzmJwhU7ICp7ysmRDf2fQ/FaIQu2ZkvI
         9phf4ZmwK0yIr0xEXLH377Md/D4hOF+6iWMeFjH95RltZ0VX8Ujsq1qsH+Ct7ZvHG7
         ItXGZZkxVC2zcDD6Art+9LZXzmUvXlRgHIX3pZl4BNhW9cSdaVhS7MmFvQYVMcT9VK
         oITiDJxu5AzXc/I1QGCJcZV8AFax8cxUDUadNJtsRSEsBsf6NW9QcctQDQkeG1Gt4q
         OjWi/+N1PxKxg==
Subject: [PATCHSET 0/3] xfs: various unit conversion
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Mon, 31 May 2021 15:40:32 -0700
Message-ID: <162250083252.490289.17618066691063888710.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Crafting the realtime file extent size hint fixes revealed various
opportunities to clean up unit conversions, so now that gets its own
series.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=unit-conversion-cleanups-5.14
---
 fs/xfs/libxfs/xfs_inode_buf.c |    2 +-
 fs/xfs/xfs_bmap_util.c        |    6 +++---
 fs/xfs/xfs_inode.c            |   25 +++++++++++--------------
 fs/xfs/xfs_iops.c             |    4 ++--
 4 files changed, 17 insertions(+), 20 deletions(-)

