Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ED17C197A0
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Nov 2023 17:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbjKPRfG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Nov 2023 12:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjKPRfF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Nov 2023 12:35:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715E2182
        for <linux-xfs@vger.kernel.org>; Thu, 16 Nov 2023 09:35:02 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156DFC433C7;
        Thu, 16 Nov 2023 17:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700156102;
        bh=qrWaayJJGVCZai72tHGWQJTr5bstQaiqIh3l3MjRD3M=;
        h=Date:Subject:From:To:Cc:From;
        b=ItxO6undMFjZiYpx8Ln2praY0Jk4O3Sue9t6dyi7y+T694VCJO5iIvS+0deFnr8+d
         Guhyp8Uzop+vbMrIrOCxrWvISmjZc7eoe3FSi8Rl7vbjpNUq6IYQzeFVbH0/kfZRS6
         Qvv6t/j/ukeMXyQUWjbelRHKl1XBHp9u0w7A0Vq4tBxKGUNNEE9njBlLXVkZDf918f
         4/c9nc0PpYYzv619BRXcs9nCiYj5EWeFfDRUVgtdfcYqUz5dUHEX2hRPo+KRWLNuJF
         sNBbXmpkTmm6ZLKB9arQtS1NSv9XkTc7vvwQilKajEww5EYbVRwnB1NGoEbjBHfsOc
         GkTArtHYrTJKA==
Date:   Thu, 16 Nov 2023 09:35:00 -0800
Subject: [GIT PULL 1/3] fstests: reload entire iunlink lists
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     david@fromorbit.com, fstests@vger.kernel.org, guan@eryu.me,
        hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170015608586.3373797.8830890617259854780.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Zorro,

Please pull this branch with changes for fstests.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 11914614784735c504f43b5b6baabaa713375984:

fstests: generic/353 should accomodate other pwrite behaviors (2023-10-27 20:19:19 +0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git tags/fix-iunlink-list_2023-11-16

for you to fetch changes up to 22ee90ae2da798d7462579aeb4b17d8b44671e9d:

xfs: test unlinked inode list repair on demand (2023-11-16 09:11:57 -0800)

----------------------------------------------------------------
fstests: reload entire iunlink lists [v5]

This is the second part of correcting XFS to reload the incore unlinked
inode list from the ondisk contents.  Whereas part one tackled failures
from regular filesystem calls, this part takes on the problem of needing
to reload the entire incore unlinked inode list on account of somebody
loading an inode that's in the /middle/ of an unlinked list.  This
happens during quotacheck, bulkstat, or even opening a file by handle.

In this case we don't know the length of the list that we're reloading,
so we don't want to create a new unbounded memory load while holding
resources locked.  Instead, we'll target UNTRUSTED iget calls to reload
the entire bucket.

Note that this changes the definition of the incore unlinked inode list
slightly -- i_prev_unlinked == 0 now means "not on the incore list".

v2: rebase to for-next, resend without changes
v3: add necessary prerequisites
v4: fix accidental commit to wrong patch
v5: add more review tags

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
common: make helpers for ttyprintk usage
xfs: test unlinked inode list repair on demand

common/fuzzy       |   4 +-
common/rc          |  36 ++++++++-
tests/xfs/1872     | 111 +++++++++++++++++++++++++++
tests/xfs/1872.out |   5 ++
tests/xfs/1873     | 215 +++++++++++++++++++++++++++++++++++++++++++++++++++++
tests/xfs/1873.out |   6 ++
tests/xfs/329      |   4 +-
tests/xfs/434      |   2 +-
tests/xfs/435      |   2 +-
tests/xfs/436      |   2 +-
tests/xfs/444      |   2 +-
tests/xfs/516      |   2 +-
12 files changed, 381 insertions(+), 10 deletions(-)
create mode 100755 tests/xfs/1872
create mode 100644 tests/xfs/1872.out
create mode 100755 tests/xfs/1873
create mode 100644 tests/xfs/1873.out

