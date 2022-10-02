Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4997EC433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiJBSY2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiJBSY1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:24:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5B92528C
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:24:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67797B80D81
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131DBC433C1;
        Sun,  2 Oct 2022 18:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735064;
        bh=Yxlcawt06Jjx3wob3daWJf+MpYYBVi2qwDL1g6dTV08=;
        h=Subject:From:To:Cc:Date:From;
        b=qUzQZNY8TRYYmUnh6lprdBJCNQW4Zi/pHs8Ie+XIQHhMos/ot4USCo0Or4hIFXTuJ
         /Z7mNLopkY1ycgpn7zv/2iicBJ6EuMWvOlA520UbQbxKhRkHy7sKoE3S6Bh3VNEZmG
         kiCyEZzsB1hqmzc8Gbt4UjgkAiYGyXU1erIrI6+WB7ViCcf/be4fcpWi+ZbW02Y4/c
         6okQV0efhM7D2lJXRzoWfxsvi78qZKhXOF/SulRw135lgN/Ktw835AYg2XzjluqzkT
         X/pUjCfDdU3ZvF2Ea72fa8sf2vb2EYQz4nsewAqbTJxjZ0NkhMNyvG0J+H9Rs0UhcU
         i8fRC92jaTfiA==
Subject: [PATCHSET v23.1 0/2] xfs: detect incorrect gaps in rmap btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:22 -0700
Message-ID: <166473482288.1084491.14541503667313246834.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Following in the theme of the last two patchsets, this one strengthens
the rmap btree record checking so that scrub can count the number of
space records that map to a given owner and that do not map to a given
owner.  This enables us to determine exclusive ownership of space that
can't be shared.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-detect-rmapbt-gaps

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-detect-rmapbt-gaps
---
 fs/xfs/libxfs/xfs_rmap.c |  198 ++++++++++++++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_rmap.h |   18 +++-
 fs/xfs/scrub/agheader.c  |   10 +-
 fs/xfs/scrub/bmap.c      |   14 +++
 fs/xfs/scrub/btree.c     |    2 
 fs/xfs/scrub/ialloc.c    |    4 -
 fs/xfs/scrub/inode.c     |    2 
 fs/xfs/scrub/rmap.c      |   45 ++++++----
 fs/xfs/scrub/scrub.h     |    2 
 9 files changed, 198 insertions(+), 97 deletions(-)

