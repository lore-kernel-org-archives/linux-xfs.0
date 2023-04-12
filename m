Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B85CC77B6E
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 03:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbjDLDsO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 23:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjDLDsN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 23:48:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E4D10C0
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 20:48:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0205C629DF
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 03:48:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BAEEC433D2;
        Wed, 12 Apr 2023 03:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681271291;
        bh=l+G402CTO76jw1ugCH1eYB+2StZ2m0rcSphemHWlg7Y=;
        h=Date:Subject:From:To:Cc:From;
        b=q8IesSaxu+8Bfh4kwH05UG2H/iOlTjWQCnOHTmTla3fZlnJmX6z2c+LdEjJ1p8xKt
         TgwUc0AuvY4qxQhc37u64IsnJraopssSHdq3vBFkVD2VMOc1HmjTRCRQ7JS7S5uJ5G
         hq1Ve55+ky62r88sI+24EYMGdrM4/4VXhi1d4nDryCm1GhfEbd/uj0nKRXNKBs6I/2
         xaesPaCRSVqgkGO/UneinTNzNNZvWBTTRfLRPV6BG8qefY/gg9mFe9+kaJbOPf6+rD
         Z+YCSwUBDDdZOG1J+fkGJWslNyZ79NL0otE+8U+5G3jYoODMdJPVlS1vxwA9iPR+eq
         f8qYKlh7H+LFg==
Date:   Tue, 11 Apr 2023 20:48:10 -0700
Subject: [GIT PULL 13/22] xfs: fix iget/irele usage in online fsck
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     dchinner@fromorbit.com, djwong@kernel.org
Cc:     dchinner@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <168127094955.417736.8034002722203014684.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 30f8ee5e7e0ccce396dff209c6cbce49d0d7e167:

xfs: ensure that single-owner file blocks are not owned by others (2023-04-11 19:00:16 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-iget-fixes-6.4_2023-04-11

for you to fetch changes up to 1fc7a0597d237c17b6501f8c33b76d3eaaae9079:

xfs: don't take the MMAPLOCK when scrubbing file metadata (2023-04-11 19:00:22 -0700)

----------------------------------------------------------------
xfs: fix iget/irele usage in online fsck [v24.5]

This patchset fixes a handful of problems relating to how we get and
release incore inodes in the online scrub code.  The first patch fixes
how we handle DONTCACHE -- our reasons for setting (or clearing it)
depend entirely on the runtime environment at irele time.  Hence we can
refactor iget and irele to use our own wrappers that set that context
appropriately.

The second patch fixes a race between the iget call in the inode core
scrubber and other writer threads that are allocating or freeing inodes
in the same AG by changing the behavior of xchk_iget (and the inode core
scrub setup function) to return either an incore inode or the AGI buffer
so that we can be sure that the inode cannot disappear on us.

The final patch elides MMAPLOCK from scrub paths when possible.  It did
not fit anywhere else.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (12):
xfs: use the directory name hash function for dir scrubbing
xfs: streamline the directory iteration code for scrub
xfs: xfs_iget in the directory scrubber needs to use UNTRUSTED
xfs: always check the existence of a dirent's child inode
xfs: remove xchk_parent_count_parent_dentries
xfs: simplify xchk_parent_validate
xfs: fix parent pointer scrub racing with subdirectory reparenting
xfs: manage inode DONTCACHE status at irele time
xfs: fix an inode lookup race in xchk_get_inode
xfs: rename xchk_get_inode -> xchk_iget_for_scrubbing
xfs: retain the AGI when we can't iget an inode to scrub the core
xfs: don't take the MMAPLOCK when scrubbing file metadata

fs/xfs/Makefile        |   1 +
fs/xfs/scrub/bmap.c    |   9 +-
fs/xfs/scrub/common.c  | 328 ++++++++++++++++++++++++++++++++----------
fs/xfs/scrub/common.h  |  11 +-
fs/xfs/scrub/dir.c     | 240 ++++++++++---------------------
fs/xfs/scrub/inode.c   | 191 +++++++++++++++++++++----
fs/xfs/scrub/parent.c  | 308 +++++++++++++---------------------------
fs/xfs/scrub/readdir.c | 375 +++++++++++++++++++++++++++++++++++++++++++++++++
fs/xfs/scrub/readdir.h |  19 +++
fs/xfs/scrub/scrub.c   |   2 +-
fs/xfs/xfs_icache.c    |   3 +-
fs/xfs/xfs_icache.h    |  11 +-
12 files changed, 1009 insertions(+), 489 deletions(-)
create mode 100644 fs/xfs/scrub/readdir.c
create mode 100644 fs/xfs/scrub/readdir.h

