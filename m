Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A391C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235594AbiL3W1T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:27:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235585AbiL3W1Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:27:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392391C90C
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:27:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E529AB81C22
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DBCC433EF;
        Fri, 30 Dec 2022 22:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439233;
        bh=w5fNzhYNWvbI8Bui3kq5Ct2Em5XL5W7QzFdD3Zl5Bdo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MsNARazAiRIlZgmX2iT9dw9/igWLyAmGxqaFWzVtRwKuRwrcP0DDQOkGHvWuQzsD3
         3+6T9FdN4OckIYX3M4GPlikckFz/kIYHtBgzk3t9gH4VRffRMsVchDsloZtt7bjUjX
         zmIuvfHvRHa4QV0rlrIW1H+WPKSTSNp1GbdsO4Dq2XE10R/2EReO+kuTPKactyf6SP
         c9SW9I3DP5fWnKdMsA+SVIA53MS1XW1NhIXRpFHUhSyOjC+o+O47ZI0TJr3k3+cy58
         +nKx1UNrNPh0RClEMgH0JRPE8PhjqBZdJDaZybIOJEF+3IYKsPSWFqBMwmZlVriAgB
         Jf+CFUgYEA2iA==
Subject: [PATCHSET v24.0 0/3] xfs: fix iget usage in directory scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:38 -0800
Message-ID: <167243829892.686639.6418703789098326027.stgit@magnolia>
In-Reply-To: <Y69UceeA2MEpjMJ8@magnolia>
References: <Y69UceeA2MEpjMJ8@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In this series, we fix some problems with how the directory scrubber
grabs child inodes.  First, we want to reduce EDEADLOCK returns by
replacing fixed-iteration loops with interruptible trylock loops.
Second, we add UNTRUSTED to the child iget call so that we can detect a
dirent that points to an unallocated inode.  Third, we fix a bug where
we weren't checking the inode pointed to by dotdot entries at all.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-dir-iget-fixes
---
 fs/xfs/scrub/common.c |   22 -----
 fs/xfs/scrub/common.h |    1 
 fs/xfs/scrub/dir.c    |   79 +++++++------------
 fs/xfs/scrub/parent.c |  203 +++++++++++++++++++++++--------------------------
 4 files changed, 126 insertions(+), 179 deletions(-)

