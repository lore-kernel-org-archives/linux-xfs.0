Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E38C7619A
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Apr 2023 00:50:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjDMAuj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 20:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDMAuh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2023 20:50:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B9B2717
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 17:50:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE04663929
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 00:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C5FC433EF;
        Thu, 13 Apr 2023 00:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681347035;
        bh=Qov28d88L36b3wt4RWARginD2Yi9ZYEmV23tmYVVj90=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EjJP8MyTjKkZfa70lc8bqULV5HTfbhN/vEgHgBcpYvXmiN9qSpqMrfOHEEbzsdnTr
         KmleBKBQrIT62w857QTmyrD1rjsW0FYVo1czoAwwsuEMeZ5RNIXDgoX6jvc1PA1gDS
         xrdFpUzLmteQZUpuvpKcLoEP+LMEdDgnSnL8rpUD+KRQVHAQepR0ECcSxgmWEaAtiT
         6rs+kKmaYMvxfQCT3feF4Ma/tT7H5tcfKdNU8jLawJQzizaqsm8uM31Gs17gLZnU5b
         +XGBKIRpEwFGANE6fFVKs6RgPN/kXmyw91hKR7ASyUQyVyY77EiNQGbxlbH71P3eXF
         EHnlYpIIlG/7Q==
Date:   Wed, 12 Apr 2023 17:50:34 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Subject: [GIT PULL v2 14/22] xfs: fix bugs in parent pointer checking
Message-ID: <20230413005034.GS360889@frogsfrogsfrogs>
References: <168127095051.417736.2174858080826643116.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168127095051.417736.2174858080826643116.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

Please pull this branch with changes for xfs.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 6bb9209ceebb07fd07cec25af04eed1809c654de:

xfs: always check the existence of a dirent's child inode (2023-04-11 19:00:18 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-parent-fixes-6.4_2023-04-12

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
Darrick J. Wong (3):
xfs: remove xchk_parent_count_parent_dentries
xfs: simplify xchk_parent_validate
xfs: fix parent pointer scrub racing with subdirectory reparenting

fs/xfs/scrub/common.c |  22 -----
fs/xfs/scrub/common.h |   1 -
fs/xfs/scrub/parent.c | 226 +++++++++++++++++---------------------------------
3 files changed, 76 insertions(+), 173 deletions(-)

