Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B85EAC77B6E
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 03:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjDLDtD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 23:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDLDtA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 23:49:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6423410C0
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 20:48:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08F426298F
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 03:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63665C4339B;
        Wed, 12 Apr 2023 03:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681271338;
        bh=kFKu42g/lIpvNTJZ67kOTIUcJ2pseGD+MYr5gMf/xo0=;
        h=Date:Subject:From:To:Cc:From;
        b=M6+dYkFvz13CG7VLofDrAauDq+46DZzz0lfcKWjFk9kYWYqEGPPj74O7UEExRMlNg
         5qldsNQrFCCMuBdjHJFP8dtaz+tueR4vp0BS6lsK0PJeBbpUefFnSEvY6o49N3ADY5
         kmT5zc+eVZgTCDh13+rUQln69dTklqoZTrFVk8VWlVJlgWIZYx27B7n3SP2poQ+xsf
         a0HEGdT6cEB4l2LWGGy4rM7T5e7tIffnfKmLz/R9YcjS78FfdmetcjXqe5/UAuFCux
         xg9dYjJmD70BzSERr2r/+AwayBDVPDq7l5wPga7UskCbSpgXose/IjrFtVPl6wtNHO
         tC6ouCn3PwXrw==
Date:   Tue, 11 Apr 2023 20:48:58 -0700
Subject: [GIT PULL 16/22] xfs: merge bmap records for faster scrubs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     dchinner@fromorbit.com, djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <168127095245.417736.9350032118598729884.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 6bb9209ceebb07fd07cec25af04eed1809c654de:

xfs: always check the existence of a dirent's child inode (2023-04-11 19:00:18 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-merge-bmap-records-6.4_2023-04-11

for you to fetch changes up to 1e59fdb7d6157ff685a250e0873a015a2b16a4f2:

xfs: don't call xchk_bmap_check_rmaps for btree-format file forks (2023-04-11 19:00:26 -0700)

----------------------------------------------------------------
xfs: merge bmap records for faster scrubs [v24.5]

I started looking into performance problems with the data fork scrubber
in generic/333, and noticed a few things that needed improving.  First,
due to design reasons, it's possible for file forks btrees to contain
multiple contiguous mappings to the same physical space.  Instead of
checking each ondisk mapping individually, it's much faster to combine
them when possible and check the combined mapping because that's fewer
trips through the rmap btree, and we can drop this check-around
behavior that it does when an rmapbt lookup produces a record that
starts before or ends after a particular bmbt mapping.

Second, I noticed that the bmbt scrubber decides to walk every reverse
mapping in the filesystem if the file fork is in btree format.  This is
very costly, and only necessary if the inode repair code had to zap a
fork to convince iget to work.  Constraining the full-rmap scan to this
one case means we can skip it for normal files, which drives the runtime
of this test from 8 hours down to 45 minutes (observed with realtime
reflink and rebuild-all mode.)

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (14):
xfs: remove xchk_parent_count_parent_dentries
xfs: simplify xchk_parent_validate
xfs: fix parent pointer scrub racing with subdirectory reparenting
xfs: manage inode DONTCACHE status at irele time
xfs: fix an inode lookup race in xchk_get_inode
xfs: rename xchk_get_inode -> xchk_iget_for_scrubbing
xfs: retain the AGI when we can't iget an inode to scrub the core
xfs: don't take the MMAPLOCK when scrubbing file metadata
xfs: change bmap scrubber to store the previous mapping
xfs: accumulate iextent records when checking bmap
xfs: split xchk_bmap_xref_rmap into two functions
xfs: alert the user about data/attr fork mappings that could be merged
xfs: split the xchk_bmap_check_rmaps into a predicate
xfs: don't call xchk_bmap_check_rmaps for btree-format file forks

fs/xfs/libxfs/xfs_bmap.h |   2 +-
fs/xfs/scrub/bmap.c      | 388 ++++++++++++++++++++++++++++++-----------------
fs/xfs/scrub/common.c    | 328 ++++++++++++++++++++++++++++++---------
fs/xfs/scrub/common.h    |  11 +-
fs/xfs/scrub/dir.c       |  14 +-
fs/xfs/scrub/inode.c     | 191 +++++++++++++++++++----
fs/xfs/scrub/parent.c    | 237 ++++++++++-------------------
fs/xfs/scrub/scrub.c     |   2 +-
fs/xfs/xfs_icache.c      |   3 +-
fs/xfs/xfs_icache.h      |  11 +-
10 files changed, 765 insertions(+), 422 deletions(-)

