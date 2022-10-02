Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C426CC433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiJBSYm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiJBSYl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:24:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BA8D83
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:24:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C062B80D81
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A58C433C1;
        Sun,  2 Oct 2022 18:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735075;
        bh=RjRIn6WEhGsOVA+EwLAvkNKaJ+kpCF6eiHvJHvzWrVQ=;
        h=Subject:From:To:Cc:Date:From;
        b=iCsbCncqRFoL/hXgHSx+Yg5a3RsHDKxIKy1UqzZtYjoEAV0c2hWVvB9uRsPIXofiU
         1oX48YYFY5l3+CViL87Z7rGlhpCRZptmTTsgjnahmaeHp7e4/QhMDmo8JEsARlfj4r
         zNQq81hsjpJSkBk7tJj0kkroA+NdQRmkQYdv/PSoRux1B8uMosIdB7ooB6qBysIu13
         gcTy1kWoLXAwbUsdKmhShGzqvC11OJZnSgL3ldl/NwRc+AH3nVg8JEVhXaMq3kbrEU
         UxzyjwUjK7Ful0F03pAmb0LdZXagJQwCcqXW5say8O/C7z0JKT5nZBHh1sYV2yDZiJ
         mX5TpuXRkFjqA==
Subject: [PATCHSET v23.1 0/3] xfs: fix iget/irele usage in online fsck
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:29 -0700
Message-ID: <166473482923.1084685.3060991494529121939.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset fixes a handful of problems relating to how we get and
release incore inodes in the online scrub code.  The first patch fixes
how we handle DONTCACHE -- our reasons for setting (or clearing it)
depend entirely on the runtime environment at irele time.  Hence we can
refactor iget and irele to use our own wrappers that set that context
appropriately.

The second patch fixes a race between the iget call in the inode core
scrubber and other writer threads that are allocating or freeing inodes
in the same AG by changing the behavior of xchk_iget (and the inode core
scrub setup function) to return either an incore inode or the AGI buffer
so that we can be sure that the inode cannot disappear on us.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-iget-fixes
---
 fs/xfs/scrub/common.c |  251 +++++++++++++++++++++++++++++++++++++++++--------
 fs/xfs/scrub/common.h |    8 ++
 fs/xfs/scrub/dir.c    |    2 
 fs/xfs/scrub/inode.c  |  163 ++++++++++++++++++++++++++++----
 fs/xfs/scrub/parent.c |    5 -
 fs/xfs/scrub/scrub.c  |    2 
 fs/xfs/xfs_icache.c   |    3 -
 fs/xfs/xfs_icache.h   |    1 
 8 files changed, 368 insertions(+), 67 deletions(-)

