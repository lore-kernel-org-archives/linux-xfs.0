Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCB84EE3F08
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 17:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236766AbjILRkn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 13:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236676AbjILRkn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 13:40:43 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A93C1
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 10:40:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EBB4C433C7;
        Tue, 12 Sep 2023 17:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694540439;
        bh=14DMVqO0Z+VV+v1BRT/QqG0ZBqSJtT81TfzO+wuEgmc=;
        h=Date:Subject:From:To:Cc:From;
        b=FJ6+ngNKP/EO9PfuZI+Fa1iNI0ogWLP07FGK8C7OPtn05CG1YPbGjOlQbUpR9/NFQ
         MwyF436xR+RVc12DOYu3YR/nsRyQM1mzDgvCXJM1tDSmyoRLMgJFN3XxJHwoXg5xD4
         88Cp+SCQ24CNcazS4gOpUvjjvCZlKn2G3m5ybe4Hv+R5qaCA2dzy+u3kQVXVX7iGRL
         zRXxWRyGq+ikKm9LW93aeBhZMT0pSWfCWVvws3RrApFie6aUWZgzAZe3FfAb1ViVLc
         wXwg23o4cJbFdlzViuNaW0MEaYpXlqzNJQMV/3ArO1WTbUQgdydbKreNWavCWCAEho
         mVbBu34skCIsw==
Date:   Tue, 12 Sep 2023 10:40:38 -0700
Subject: [GIT PULL 7/8] xfs: disallow LARP on old fses
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@gmail.com, djwong@kernel.org
Cc:     bodonnel@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <169454023727.3411463.17582197078544277888.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Chandan,

Please pull this branch with changes.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 49813a21ed57895b73ec4ed3b99d4beec931496f:

xfs: make inode unlinked bucket recovery work with quotacheck (2023-09-12 10:31:07 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/fix-larp-requirements-6.6_2023-09-12

for you to fetch changes up to 34389616a963480b20ea7f997533380ae3946fba:

xfs: require a relatively recent V5 filesystem for LARP mode (2023-09-12 10:31:08 -0700)

----------------------------------------------------------------
xfs: disallow LARP on old fses
Before enabling logged xattrs, make sure the filesystem is new enough
that it actually supports log incompat features.

This has been lightly tested with fstests.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (1):
xfs: require a relatively recent V5 filesystem for LARP mode

fs/xfs/xfs_xattr.c | 11 +++++++++++
1 file changed, 11 insertions(+)

