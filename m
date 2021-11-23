Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 400FDC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Nov 2021 19:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239653AbhKWUBJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Nov 2021 15:01:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:38782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232735AbhKWUBJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Nov 2021 15:01:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C67F760240;
        Tue, 23 Nov 2021 19:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637697480;
        bh=kA1iHCKJkbhE5TGUaL1uiAZ16oha8GCeY0R14WNaZf8=;
        h=Subject:From:To:Cc:Date:From;
        b=LQWKdGjyZtqTeseCMc+9bRV5L9rMG6IBgrWeNUhqL3kSuBOZ3nlAJAlNXJzD8Vk7j
         LNZ9+r4KuWj56vCbdvhW/ZaftEgRqQ8+fRBV9KgYeXLgx+twsbyDRflvYxgtWIpdy+
         nktOuo7RCTIiZ8yZ/frsv/xtYZgXmyh3MdZh5XU/pjO3T4023cpI4Kl1VYHYf8rsBH
         qL/IWFcM3XRsbRqpOnnGktAb+z/TebikJWzvFiUqhfh1IKwOg6CaZh3rlBbmpJjiII
         NKncYqEL3DPKxzgg5BvprpJAABLxbiEWn42qBaV9YrgVYMY7K1iCbOdF2G11+lFlhR
         AjlDeMuJjJqmQ==
Subject: [PATCHSET 0/1] fstests: random fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 23 Nov 2021 11:58:00 -0800
Message-ID: <163769748044.881878.3850309120360970780.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Minor update for kernel 5.16.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
 tests/xfs/122.out |    3 +++
 1 file changed, 3 insertions(+)

