Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F010EEE3F08
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 17:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbjILRkN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 13:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237163AbjILRkM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 13:40:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E23310D3
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 10:40:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B810EC433C7;
        Tue, 12 Sep 2023 17:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694540407;
        bh=N4q3BUsDgryrPD5soZtx7mXP9wa6yek5B2LH7Ecj9to=;
        h=Date:Subject:From:To:Cc:From;
        b=Th60IFV7LCCBDKjjnel2v0D6E0IZy5FuFfi3qpZMmFbs+yIMDxcjKrD9krGFAYqBA
         JkTnCaz1zUdctM4wzGwmXBZCsr15D4Vhqp5mjuIqpGVFGAug/JoUWTXVS8Wr4aSQXw
         En0j3v6uqApHM2uHMQ8OQOZBNtDz+/tgbm2Q7j7x++jY17VBpg5+ZdRzytjgEQQlye
         9uSoLnNintaX7oQcUmD4tJeel4jNrXxEiKSYL034zE9X5K9BmL2R4E7bH8SIs0K6Pb
         AtQuRwNj0Gc0VYM0GKVm8IOfJpjrdUyEr9Jb5ZmfSAVuOws/J8L86JH4A6sxDzUyuu
         /YTi2fXtkOH7g==
Date:   Tue, 12 Sep 2023 10:40:07 -0700
Subject: [GIT PULL 5/8] xfs: reload the last iunlink item
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@gmail.com, djwong@kernel.org
Cc:     david@fromorbit.com, dchinner@redhat.com,
        linux-xfs@vger.kernel.org, sshegde@linux.vnet.ibm.com
Message-ID: <169454023537.3411463.1875006072622672736.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 3c919b0910906cc69d76dea214776f0eac73358b:

xfs: reserve less log space when recovering log intent items (2023-09-12 10:31:07 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/fix-iunlink-6.6_2023-09-12

for you to fetch changes up to 68b957f64fca1930164bfc6d6d379acdccd547d7:

xfs: load uncached unlinked inodes into memory on demand (2023-09-12 10:31:07 -0700)

----------------------------------------------------------------
xfs: reload the last iunlink item
It turns out that there are some serious bugs in how xfs handles the
unlinked inode lists.  Way back before 4.14, there was a bug where a ro
mount of a dirty filesystem would recover the log bug neglect to purge
the unlinked list.  This leads to clean unmounted filesystems with
unlinked inodes.  Starting around 5.15, we also converted the codebase
to maintain a doubly-linked incore unlinked list.  However, we never
provided the ability to load the incore list from disk.  If someone
tries to allocate an O_TMPFILE file on a clean fs with a pre-existing
unlinked list or even deletes a file, the code will fail and the fs
shuts down.

This first part of the correction effort adds the ability to load the
first inode in the bucket when unlinking a file; and to load the next
inode in the list when inactivating (freeing) an inode.

This has been lightly tested with fstests.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (1):
xfs: load uncached unlinked inodes into memory on demand

fs/xfs/xfs_inode.c | 80 ++++++++++++++++++++++++++++++++++++++++++++++++++----
fs/xfs/xfs_trace.h | 25 +++++++++++++++++
2 files changed, 100 insertions(+), 5 deletions(-)

