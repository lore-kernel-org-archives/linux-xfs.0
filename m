Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 839A5C43217
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Nov 2022 03:09:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbiKQDJc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Nov 2022 22:09:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232548AbiKQDJb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Nov 2022 22:09:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5BB848760
        for <linux-xfs@vger.kernel.org>; Wed, 16 Nov 2022 19:09:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 710AF61FDE
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 03:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0360C433D6;
        Thu, 17 Nov 2022 03:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668654569;
        bh=YToMC5+vzDP5NlTQHjqYAY65L9O8OrKzxMska+SZxhU=;
        h=Date:From:To:Cc:Subject:From;
        b=URk4lLi9gKq4+eaRb1Nb7cq0uL9fjyG0XTwPq70vPmpSLxxtjI1ICxr6PMvo9OKvk
         mFtpHbM/7KK8aDxjBNdXPkNvKxGrjdXe5SkOv0YzOFF8d8ZDdBxWIpDhWjue6M8x91
         I4igmlo+B4wVp5M/KQDO867AwxFbkJNn4yNK0xm/H17obTtxVwQGwujbUfcE45X5xm
         Lfb+HsPJbzAvTZ/3eW0m20yRaGAygATxJ7vFArYvDCxlJ4S9otUYwR1GAsZxvV1y9R
         737HK1RVPrvzd7j6N57jNpL2HFEJpOYBrM5jVIBiwX/kXg4W55iG7Wzfd0Bxs+wFjA
         TVIiDtDFD6Zgw==
Date:   Wed, 16 Nov 2022 19:09:29 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Subject: [GIT PULL 1/7] xfs: fix handling of AG[IF] header buffers during
 scrub
Message-ID: <166865410783.2381691.17025509830045469038.stg-ugh@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

Please pull this branch with changes for xfs for 6.2-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit f0c4d9fc9cc9462659728d168387191387e903cc:

Linux 6.1-rc4 (2022-11-06 15:07:11 -0800)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-fix-ag-header-handling-6.2_2022-11-16

for you to fetch changes up to b255fab0f80cc65a334fcd90cd278673cddbc988:

xfs: make AGFL repair function avoid crosslinked blocks (2022-11-16 15:25:01 -0800)

----------------------------------------------------------------
xfs: fix handling of AG[IF] header buffers during scrub

While reading through the online fsck code, I noticed that the setup
code for AG metadata scrubs will attach the AGI, the AGF, and the AGFL
buffers to the transaction.  It isn't necessary to hold the AGFL buffer,
since any code that wants to do anything with the AGFL will need to hold
the AGF to know which parts of the AGFL are active.  Therefore, we only
need to hold the AGFL when scrubbing the AGFL itself.

The second bug fixed by this patchset is one that I observed while
testing online repair.  When a buffer is held across a transaction roll,
its buffer log item will be detached if the bli was clean before the
roll.  If we are holding the AG headers to maintain a lock on an AG, we
then need to set the buffer type on the new bli to avoid confusing the
logging code later.

There's also a bug fix for uninitialized memory in the directory scanner
that didn't fit anywhere else.

Ths patchset finishes off by teaching the AGFL repair function to look
for and discard crosslinked blocks instead of putting them back on the
AGFL.

v23.2: Log the buffers before rolling the transaction to keep the moving
forward in the log and avoid the bli falling off.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
xfs: fully initialize xfs_da_args in xchk_directory_blocks
xfs: don't track the AGFL buffer in the scrub AG context
xfs: log the AGI/AGF buffers when rolling transactions during an AG repair
xfs: make AGFL repair function avoid crosslinked blocks

fs/xfs/scrub/agheader.c        | 47 +++++++++++++++----------
fs/xfs/scrub/agheader_repair.c | 79 +++++++++++++++++++++++++++++++++++-------
fs/xfs/scrub/common.c          |  8 -----
fs/xfs/scrub/dir.c             | 10 +++---
fs/xfs/scrub/repair.c          | 41 ++++++++++++++--------
fs/xfs/scrub/scrub.h           |  1 -
6 files changed, 128 insertions(+), 58 deletions(-)
