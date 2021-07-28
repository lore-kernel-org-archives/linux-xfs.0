Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4DCEC432BE
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:16:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFF0B60462
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbhG1VQg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 17:16:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231574AbhG1VQf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jul 2021 17:16:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61C056103B;
        Wed, 28 Jul 2021 21:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627506993;
        bh=EX18q5LBxPHy54x7MirliA3ezZ1QJBUAmPnheFxtmps=;
        h=Subject:From:To:Cc:Date:From;
        b=T8gecr/xXrz+tYxk5h6Umasy2pxsIr16O5p7jyeZLoINpx8W4BkNoHU2Li/BIjh65
         IK8fqPi32r+D9+lSLCLWHod5UdChC6gCzjxUNwLPmkgC3YPDBGF4TLMw9q2Qw/XHZl
         ID0zcYm/FOLH03+FoHZENenI6PM3gdPrK6wevRJfME4Z2Vn6srec5EyY7Z6CiBCwrl
         Hd3C9Fya/fXqk9uAgqEU+MP35+X03EdciiJZhgDLxH1lRjcBLAyz+Flh8YZq4W9vrU
         9RcjljiTeQR5+eymlsHUi4H5pXLNS3jjNePx6jw1z6fgL9DVLB9vC8Ywnnm+40wddq
         WZmGXNOODj7Nw==
Subject: [PATCHSET v2 0/1] xfs_io: small improvements to statfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 28 Jul 2021 14:16:33 -0700
Message-ID: <162750699314.45983.15238050911081991698.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Change the statfs command so that you can invoke any combination of the
three state calls.

v2: Fix broken stuff pointed out by maintainer

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=statfs-fixes
---
 io/stat.c         |  140 ++++++++++++++++++++++++++++++++++++++---------------
 man/man8/xfs_io.8 |   26 ++++++++--
 2 files changed, 123 insertions(+), 43 deletions(-)

