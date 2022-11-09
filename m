Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CEB4C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiKICFP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:05:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKICFP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:05:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20FB53EE3
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:05:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43068617E1
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E18AC433D6;
        Wed,  9 Nov 2022 02:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959500;
        bh=NiXCAGzAYiUb7e2ne8Q9fHeT0omPw+ZRBVCxMDYzx28=;
        h=Subject:From:To:Cc:Date:From;
        b=D7oHRI3syyjj/c5gU6zR1tMjfXnMgFfaZBQcMQT0F3CZL5M366k2mHCP2T/Emm+Ru
         s2UPGgwjAI41e4lRfZ3/HRkfhcm6G2dz5I0H1UyZMAUU4qOCHHnwSVSSOlcmSbCiFQ
         BCwy+KFrYUb835mGs7z7I8m+ev6BDL+KKGbFlzOCItaayn7ybh8djR7gf7H81GVYw6
         zvU8r20VkukMCeVASa/PHPccJVeDR0GwqVQmg0wM5MBg65SW28ahMvNHzB5hWwLtVf
         6QDjSgiGGEwh4QtR1zsIsqUnRT555sJAv/I4sBDd7gLf11HYyG1Hmty/ilYDXXrsyG
         +r2MBkWTYtDgQ==
Subject: [PATCHSET 0/7] xfsprogs: random fixes for 6.0
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:05:00 -0800
Message-ID: <166795950005.3761353.14062544433865007925.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is a rollup of all the random fixes I've collected for xfsprogs
6.0.  At this point it's just an assorted collection, no particular
theme.  Many of them are leftovers from the last posting.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-fixes-6.0
---
 db/btblock.c             |    2 +
 db/namei.c               |    2 +
 db/write.c               |    4 +-
 io/pread.c               |    2 +
 libfrog/linux.c          |    1 +
 libxfs/libxfs_api_defs.h |    2 +
 libxfs/libxfs_io.h       |    1 +
 libxfs/libxfs_priv.h     |    2 +
 libxfs/rdwr.c            |    8 +++++
 libxfs/util.c            |    1 +
 mkfs/xfs_mkfs.c          |    2 +
 repair/phase2.c          |    8 +++++
 repair/phase6.c          |    9 +++++
 repair/protos.h          |    1 +
 repair/xfs_repair.c      |   77 ++++++++++++++++++++++++++++++++++++++++------
 scrub/inodes.c           |    2 +
 16 files changed, 105 insertions(+), 19 deletions(-)

