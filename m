Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F844C433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381160AbiEEQHl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353854AbiEEQHk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:07:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291E82CE19
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:04:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7D9161D53
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1D5C385A8;
        Thu,  5 May 2022 16:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766640;
        bh=gZ2iskXR4+W+tM9R0H3ERCbjTMrdxsEEVlwzMpEg14o=;
        h=Subject:From:To:Cc:Date:From;
        b=DsLjR9bwlIMhBuE72vETc8l/65Znbxg+XAb+HVJr+gYI12WjkIP3cGOz4k/HYH2f7
         FZ1muHvDZ4BBIIcF75pJjdL3iY6CmhOD3z1hzcdhvHuJudSyf1Tn6+osjR9nIRYR7G
         q70KL8NzBV0F56NmSIx8YiwKjdBHYNynwMcW2XNrJYWAQku/ZwUa7jLpRFvCwxvqBC
         91+DstVlIdVUDWmf03Kkxa9N1vdDwwkRCrjTuROlulSpBJ3rw/5JCTu+787ovgGPtM
         QEdCLGEkRQLRiuMIiBKI7Pfx2W7UtgLes/EZbAOv6xVLrtfwvthfDfSY7d68RsTr+W
         9V6bv6s3U9MOw==
Subject: [PATCHSET 0/2] xfsprogs: random fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:03:59 -0700
Message-ID: <165176663972.246897.5479033385952013770.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series contains miscellaneous changes -- a port to mallinfo2, and
fixing a theoretical stack stack overrun in xfs_db.

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
 configure.ac          |    1 +
 db/io.c               |    2 +-
 include/builddefs.in  |    1 +
 m4/package_libcdev.m4 |   18 ++++++++++++++++++
 scrub/Makefile        |    4 ++++
 scrub/xfs_scrub.c     |   47 +++++++++++++++++++++++++++++------------------
 6 files changed, 54 insertions(+), 19 deletions(-)

