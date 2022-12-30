Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4062FC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbiL3XAq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiL3XAp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:00:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF75FDCF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:00:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 741F0B81D95
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:00:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327C2C433D2;
        Fri, 30 Dec 2022 23:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441242;
        bh=2cOTc2ZJpBIzhPdkNU9IQq7XC0cn0MCoSyJHdTYzP6w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=M9OJnS7c2+MRdMFnki6CFuW/FZnRHK3xWoNmA7lCxZk3SijIcs4aV7lpwSq6VI5u1
         CNUlFH2zQswj7qFK7TzaHGnOrS4DcxCj6Sh5hb+gHHKMGcTNF0+H/vPtue55lwBLl9
         MaJou4xaUlw0xZpSAldjFN4RnKSYdlPEyKbsi+LX8GonqnsXdCdNQ0VqoGhJio9tht
         VX4h9qNihCXPXnlGcP4UJ/x9gzNf3GnOGV+2GNq1/n6Mzg65+uHC/W2pdnmInPBSt/
         yHudXfgzx+mg9i75jA4fKLjdoO9RRltCuy+E5i6IQu4uxD9J0xSWKxxBNB6vyBifl8
         8wKfozY1wJXrA==
Subject: [PATCHSET v24.0 0/4] xfs: online scrubbing of realtime summary files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:38 -0800
Message-ID: <167243835873.692714.18058284706535171995.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset implements an online checker for the realtime summary
file.  The first few changes are some general cleanups -- scrub should
get its own references to all inodes, and we also wrap the inode lock
functions so that we can standardize unlocking and releasing inodes that
are the focus of a scrub.

With that out of the way, we move on to constructing a shadow copy of
the rtsummary information from the rtbitmap, and compare the new copy
against the ondisk copy.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-rtsummary

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-rtsummary
---
 fs/xfs/Makefile          |    6 +
 fs/xfs/scrub/bmap.c      |    6 -
 fs/xfs/scrub/common.c    |   63 +++++++++--
 fs/xfs/scrub/common.h    |   16 ++-
 fs/xfs/scrub/dir.c       |    3 -
 fs/xfs/scrub/inode.c     |   11 +-
 fs/xfs/scrub/parent.c    |   10 +-
 fs/xfs/scrub/quota.c     |   15 +--
 fs/xfs/scrub/rtbitmap.c  |   48 +-------
 fs/xfs/scrub/rtsummary.c |  262 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c     |   17 ++-
 fs/xfs/scrub/scrub.h     |    4 +
 fs/xfs/scrub/trace.h     |   34 ++++++
 fs/xfs/xfs_trace.h       |    3 +
 14 files changed, 411 insertions(+), 87 deletions(-)
 create mode 100644 fs/xfs/scrub/rtsummary.c

