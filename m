Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87C51C43332
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 01:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EB9123AFB
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 01:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbhAPBZs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Jan 2021 20:25:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:33190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbhAPBZr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Jan 2021 20:25:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E938223A52;
        Sat, 16 Jan 2021 01:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610760297;
        bh=i4BtEBCHh32kwX3QFRwKGaNDPLDViBfD4ClWzqSAErs=;
        h=Subject:From:To:Cc:Date:From;
        b=AYRnSvoEnxGRKBGuijzPRAIz5WA6jiS4clrZ69fNz3y750ZDcUBkB8UjbokPrXYSh
         wADccp5KDcZnnwZ7fuojSzZdUrAWBOzqqbvYvJywgz39TtHGTfOkC0KkVJaLPhzOzK
         dXiFEK7WsQbZ/EXws0mDnMhaa+a2mGL56GPveWrcji83BIh87X+BRxCLzc6tPs7mfH
         kqJNzUlH3xrPhb+a3vWIeOVCc8cUBVISKbVR0TW0z/Do9exs+aqxmchXIeMhdGQT/z
         LU4GDqgpY9yGXmS052s2I/bM2OSEsy9237buDo4Mr46qPySnmYIOSg46xx4jt6x7ID
         CXlD5dwbU7RSQ==
Subject: [PATCHSET v3 0/2] xfs_admin: support upgrading v5 filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Fri, 15 Jan 2021 17:24:56 -0800
Message-ID: <161076029632.3386576.16317498856185564786.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This submission extends xfs_db and xfs_admin to support adding the inode
btree counter and bigtime features to an existing v5 filesystem.

v2: Rebase to 5.10-rc0
v3: respond to reviewer comments

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=fs-upgrades
---
 db/sb.c              |   38 ++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_admin.8 |   12 ++++++++++++
 man/man8/xfs_db.8    |    7 +++++++
 3 files changed, 57 insertions(+)

