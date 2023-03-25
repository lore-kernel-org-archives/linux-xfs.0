Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 694A6C6FD1F
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Mar 2023 18:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjCYSif (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Mar 2023 14:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCYSie (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Mar 2023 14:38:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56602D41
        for <linux-xfs@vger.kernel.org>; Sat, 25 Mar 2023 11:38:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7091560C7E
        for <linux-xfs@vger.kernel.org>; Sat, 25 Mar 2023 18:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47DEC433D2;
        Sat, 25 Mar 2023 18:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679769512;
        bh=BSY78yH6gZLwvqC0XUcpg6kjTsVnv/IhxkiFA5nFEl8=;
        h=Date:From:To:Cc:Subject:From;
        b=gi1R6lXs6LGaB/hpOc6ZPe6ag5lvMycH2EyNvDyze3CQaJKa2EnfsloPO4FqpwPTE
         mxn9t70X6GyATs3boRamqduiQ77tbEuU2L8pZoI9PupfOGiZS3ioY6PcgIBPiejV/s
         c62DqamwduFnSitXVsl2dTYoou6op6eaWccuTpR2bgpEBY29Ghlzs3ipl5sLyQ4amD
         Y3F1uI2XoQjuPNC2sZLf1qi0qWjnwYP5oYOcAWicUZanVQ0HWYDurAlsCWAZFS6w8V
         +YDy5PIAunGsP4cI95QBdMVGKtrKxr+nA5R1/C+MFtqRL+zc3SQgTT+6nYRKF6IMqc
         YnYU3qMjMgKNQ==
Date:   Sat, 25 Mar 2023 11:38:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, torvalds@linux-foundation.org
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org
Subject: [GIT PULL 3/3] xfs: more bug fixes for 6.3-rc3
Message-ID: <167976583288.986322.6784084002958308994.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

Please pull this branch with yet more bug fixes.  The first bugfix
addresses a longstanding problem where we use the wrong file mapping
cursors when trying to compute the speculative preallocation quantity.
This has been causing sporadic crashes when alwayscow mode is engaged.
The other two fixes correct minor problems in more recent changes

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit e9b60c7f97130795c7aa81a649ae4b93a172a277:

pcpcntr: remove percpu_counter_sum_all() (2023-03-19 10:02:04 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.3-fixes-7

for you to fetch changes up to 4dfb02d5cae80289384c4d3c6ddfbd92d30aced9:

xfs: fix mismerged tracepoints (2023-03-24 13:16:01 -0700)

----------------------------------------------------------------
More fixes for 6.3-rc3:

* Fix the new allocator tracepoints because git am mismerged the
changes such that the trace_XXX got rebased to be in function YYY
instead of XXX.
* Ensure that the perag AGFL_RESET state is consistent with whatever
we've just read off the disk.
* Fix a bug where we used the wrong iext cursor during a write begin.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
xfs: pass the correct cursor to xfs_iomap_prealloc_size
xfs: clear incore AGFL_RESET state if it's not needed
xfs: fix mismerged tracepoints

fs/xfs/libxfs/xfs_alloc.c | 10 ++++++----
fs/xfs/xfs_iomap.c        |  5 ++++-
2 files changed, 10 insertions(+), 5 deletions(-)
