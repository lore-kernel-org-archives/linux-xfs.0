Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 851EBC7619A
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 03:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbjDLDs3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 23:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDLDs3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 23:48:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBC010C0
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 20:48:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC38A629DF
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 03:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24230C433EF;
        Wed, 12 Apr 2023 03:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681271307;
        bh=Ba12Kihk+Xd3tJm7QCt9zgvBJ+yVNjskTCKJu5/eKTc=;
        h=Date:Subject:From:To:Cc:From;
        b=O/uZ+nbT/b83WSyvOIPOXmKs2R68T8bfXfKOGdhyAO4bl7Y4XC/NMzVbPEqAKAtLp
         tMK3tJZnOvYQMQc8GkLu09glLjK3fZ/ZRWBoPTCC29zru60jcegSopV5s90XDHynTU
         hMSfN5HhYIOEAo8Jdd1TnZlCgQbVdT6N5SaxoHXstjTwKZlGXPZVfJKRKWD7bHErzv
         a80DDdkQ0mZI8AMgLYp5jvSA//VgCyCpgxUhP0V9DyqGEWc8IfKr1BEern75p77QpK
         iIahDe4wHCHEulgx1YPhIbD1juqqvPLC4un3u9nsJTrKO/rLYnrMpyOhnzDv5KaO0P
         CSyLw/8wcYWLQ==
Date:   Tue, 11 Apr 2023 20:48:26 -0700
Subject: [GIT PULL 14/22] xfs: fix bugs in parent pointer checking
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     dchinner@fromorbit.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168127095051.417736.2174858080826643116.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

Please pull this branch with changes for xfs.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 0916056eba4fd816f8042a3960597c316ea10256:

xfs: fix parent pointer scrub racing with subdirectory reparenting (2023-04-11 19:00:20 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-parent-fixes-6.4_2023-04-11

for you to fetch changes up to 0916056eba4fd816f8042a3960597c316ea10256:

xfs: fix parent pointer scrub racing with subdirectory reparenting (2023-04-11 19:00:20 -0700)

----------------------------------------------------------------
xfs: fix bugs in parent pointer checking [v24.5]

Jan Kara pointed out that the VFS doesn't take i_rwsem of a child
subdirectory that is being moved from one parent to another.  Upon
deeper analysis, I realized that this was the source of a very hard to
trigger false corruption report in the parent pointer checking code.

Now that we've refactored how directory walks work in scrub, we can also
get rid of all the unnecessary and broken locking to make parent pointer
scrubbing work properly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------

