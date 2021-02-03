Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B706C433DB
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 19:44:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B79464F60
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 19:44:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbhBCToh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 14:44:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:44836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230438AbhBCTof (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Feb 2021 14:44:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FD4264F92;
        Wed,  3 Feb 2021 19:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612381423;
        bh=LJ/GeoQyAh1Re7NxksEvAL6wlMWYtylw9DSPclIgAtE=;
        h=Subject:From:To:Cc:Date:From;
        b=e5HxpEUpSGLURJCb55MTwFAaNEfZJXj2jmdCbumGvH9UaD3I1DlqAhdi0RHiyjxxS
         6yAlNf4zbZfq64JL2ic9iIdmGroAFlEYUVHnJSbYh+n/rn6vVM2VsbM1OiTo1gKstC
         WZq/JlW399ghbdstqzvJsau2yicPvo7a7rvVi3zciHnNlEfvrphm0r4ydrE6QGZmnZ
         b5El1e7rTRh6CedYWaNbuZvdZxZXwYHm/71SSGlzG4Uw+ea/ZVox8z9kleOTGbcjrg
         U+la3DhKbp/+fsxN2hRX6NVCXFRyuis9f0KXJU0tSSeaTJkiBtbH8eBX4mOIWaCr5k
         ThnBP3K1u72AQ==
Subject: [PATCHSET v4 0/2] xfs_admin: support upgrading v5 filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@lst.de
Date:   Wed, 03 Feb 2021 11:43:42 -0800
Message-ID: <161238142268.1278478.11531156340909081942.stgit@magnolia>
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
v4: document which kernel version these new features showed up in

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=fs-upgrades
---
 db/sb.c              |   36 ++++++++++++++++++++++++++++++++++++
 man/man8/xfs_admin.8 |   13 +++++++++++++
 man/man8/xfs_db.8    |    7 +++++++
 3 files changed, 56 insertions(+)

