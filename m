Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC9C7C76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:15:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240534AbjDFTPA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240525AbjDFTO7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:14:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08FEF2
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:14:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7904C643F3
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:14:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC11C433EF;
        Thu,  6 Apr 2023 19:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680808497;
        bh=9WF+fuZKFhh4iw2LGMJZJDchV4rpE5z/ADmPX7P9YBs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=faWAibwzaZrURibSUeDyLvUCkz1XyKFYf0WOC0+NlIZ5/i4ynRF7tnNne4IixRX1K
         mXghhKyU3sPo8u1FqPKxKArc3fO3MRYHZ2m1tpA+Bmd/Hp5uT2leNqQBnkfwuxUBtA
         CuUAqxsDYMWBB04rKqF/BBqhY7jsT82c5OFElsl5lAz7FJyCgZrTE7yY5Ww8CDBXZ9
         8CCN9Q2eeSS0AH7IPGJJGdJ8bMbQEPcQraeolb/60TaRHHO+SbYlvLvjgctYM11CH6
         4VJIAxpkFzrt3GI0mRMGVbPYXf0RLMpL3b5SfuaQK+3kn3caDH8CGW+ZHPWsAgLwih
         /cw4FsuH+oaeA==
Date:   Thu, 06 Apr 2023 12:14:57 -0700
Subject: [PATCHSET v11 0/2] xfs: online checking of parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080825622.615905.7017300233071761636.stgit@frogsfrogsfrogs>
In-Reply-To: <20230406181038.GA360889@frogsfrogsfrogs>
References: <20230406181038.GA360889@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Update the existing online parent pointer checker to confirm the
directory entries that should also exist.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-online-parent-check

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-online-parent-check
---
 fs/xfs/Makefile            |    2 
 fs/xfs/libxfs/xfs_parent.c |   42 ++++
 fs/xfs/libxfs/xfs_parent.h |   10 +
 fs/xfs/scrub/parent.c      |  501 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.h       |   33 +++
 5 files changed, 587 insertions(+), 1 deletion(-)

