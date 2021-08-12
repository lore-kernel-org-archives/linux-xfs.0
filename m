Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B459C432BE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 00:58:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77491601FD
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 00:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbhHLA7U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Aug 2021 20:59:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232704AbhHLA7T (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Aug 2021 20:59:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FB476105A;
        Thu, 12 Aug 2021 00:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628729935;
        bh=LSW/dReDC0BvEQ7uuGvnuIr3ZpmL1nrq1bn+rZjKG1E=;
        h=Subject:From:To:Cc:Date:From;
        b=HpCpqQJoVJP8U8/f9PSwd0K2KqeuSxVFqjZdwN586qMHuOjM1llpzKt8oGLdpRp0J
         1v/KbtY5L/vLQrAq/MKpHySfVUeK/qYZtQBYmVQr4TYAMpzCvnjPbaVhn1LO02ivHp
         DAVkO2HQH/e9ywg/GahPzrfQk3OsRuZLpXHXC7fAaT+xiyExUh4bFoKIWeOaZfRyEK
         lITkTI/lwSENM/R0JasFx9HTQq5y+Ap74R8f4pZEy2Zezw8GIoquLM5rLr30UjyjGJ
         yNoKrcZj9Bs5rah66l3uqD2m5bAjmXC+4RPSy3M9thj501eKVfalEpfmN3oW/32MPj
         j9HjwOT0fffEg==
Subject: [PATCHSET 0/2] xfs: more random tweaks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 11 Aug 2021 17:58:55 -0700
Message-ID: <162872993519.1220748.15526308019664551101.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

These two patches are not really related at all.  The first patch
removes an unnecessary agno parameter from the scrub context because we
can just use the pag reference kept in the same context.

The second patch adds trace points for fs shutdowns to make it a little
easier to trace recoveryloop test activities.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes-5.15
---
 fs/xfs/scrub/agheader.c        |    2 +-
 fs/xfs/scrub/agheader_repair.c |   34 +++++++++++++++++++++-------------
 fs/xfs/scrub/common.c          |    3 ---
 fs/xfs/scrub/repair.c          |   18 +++++++++---------
 fs/xfs/scrub/scrub.c           |    3 ---
 fs/xfs/scrub/scrub.h           |    1 -
 fs/xfs/xfs_error.h             |   12 ++++++++++++
 fs/xfs/xfs_fsops.c             |    3 +++
 fs/xfs/xfs_mount.h             |    6 ++++++
 fs/xfs/xfs_trace.c             |    1 +
 fs/xfs/xfs_trace.h             |   27 +++++++++++++++++++++++++++
 11 files changed, 80 insertions(+), 30 deletions(-)

