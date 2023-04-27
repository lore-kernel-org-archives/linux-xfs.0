Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAFD3C77B73
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Apr 2023 22:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344330AbjD0Ws4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 18:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbjD0Ws4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2023 18:48:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B177E2106
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 15:48:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D43664009
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 22:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB457C433D2;
        Thu, 27 Apr 2023 22:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682635734;
        bh=PZYyEQ8m+t7g4aoKIHxXgCOdm0hjbqvRad1FRQj/Qn0=;
        h=Subject:From:To:Cc:Date:From;
        b=Q7BiP9fYzjUhy4uVeXIbdvejx15ULJHq+HGoghlld9l0q//xwilfFm73qjUlbXHU0
         50F49EPHynAs4doWNZqBqHymosGLgPmmCH8X6qXtIp9AdxkWYbO8DSm3P0sRLtVmKb
         CAUcVNSYg4pYy5m47kmj5jnnL2Xsr/mSchbfUkC78lJgjhe7vNxS0Eel23usVYUlvj
         1Mfa0mtiom1e7kR+deYDE23rrQXOZ23BH/vbbcZ8SMpcXsJuiheL+JI8CJON5om8a8
         bWZ3vqhcSf41oRUYv5DrbzjICoGjrZHkGNyQYnboU3/jGl5GJ0dCijSRSDv3OyK4aY
         mOcBFUBFZOd1A==
Subject: [PATCHSET 0/4] xfs: bug fixes for 6.4-rc1
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 27 Apr 2023 15:48:54 -0700
Message-ID: <168263573426.1717721.15565213947185049577.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here are some assorted bug fixes for 6.4:

 * A regression fix for the allocator refactoring that we did in 6.3.
 * Fix a bug that occurs when formatting an internal log with a stripe
   alignment such that there's free space before the start of the log
   but not after.
 * Make scrub actually take the MMAPLOCK (to lock out page faults) when
   scrubbing the COW fork
 * If we call FUNSHARE on a hole in the data fork, don't create a
   delalloc reservation in the cow fork for that hole.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=kernel-fixes-6.4
---
 fs/xfs/libxfs/xfs_ag.c   |   10 +++++-----
 fs/xfs/libxfs/xfs_bmap.c |    5 +++--
 fs/xfs/scrub/bmap.c      |    4 ++--
 fs/xfs/xfs_iomap.c       |    5 +++--
 4 files changed, 13 insertions(+), 11 deletions(-)

