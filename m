Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45D98C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 19:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237883AbiCITYF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 14:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237839AbiCITYC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 14:24:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9295B5FD5
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 11:22:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E99E6179E
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 19:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93149C340E8;
        Wed,  9 Mar 2022 19:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646853756;
        bh=CeCLArnM/hKu8v6BOTBALuiDFaSf+fgZp43vOH43n1s=;
        h=Subject:From:To:Cc:Date:From;
        b=cw9F1Le1QpSY1G9I8kMZNMsRolvSAgYgH2p6PKPvKw8Ur/TpWYbHNy2tBypsl+hSN
         RqFjC9Xrds4QgCzNMC00Ix4amnRmGcIZkX8ZlTpPp4xB0ump8zHfYak+pzR/GudcuG
         hORovMMfI8HEaWzHVk5d3pMJsp4WmBl7NU59Nb85O6fGZpX3yx7ZjBPrBrb+EPUuh6
         5fKkzrjbuI7uoa+L7e8ineaYX8hUTaiTtR5DT5KERbHwlx8sryNhd+gbJw1x5xDIYe
         DZywD6zCIo3U5//MD4+TNXhQ31+uN9aG3fEd0zCnAhNFb8VdvyScZXYV+sy1rJgfDi
         ZGaxHwx73LBnA==
Subject: [PATCHSET 0/2] xfs: constify dotdot global variable
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 09 Mar 2022 11:22:36 -0800
Message-ID: <164685375609.496011.2754821878646256374.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I was auditing the code base when I noticed that the xfs_name_dotdot
variable is both global and mutable.  In theory, someone could change
the contents of that variable (either through misuse or by exploiting a
kernel bug) which would then break the directory code, so let's shut
down that attack surface by making it const.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=constify-dotdot-5.18
---
 fs/xfs/libxfs/xfs_dir2.c      |   18 +++++++++++-------
 fs/xfs/libxfs/xfs_dir2.h      |    6 +++---
 fs/xfs/libxfs/xfs_dir2_priv.h |    5 +++--
 fs/xfs/scrub/parent.c         |    6 ++++--
 fs/xfs/xfs_export.c           |    3 ++-
 5 files changed, 23 insertions(+), 15 deletions(-)

