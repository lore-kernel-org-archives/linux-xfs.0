Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47738 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726003AbfADBG4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jan 2019 20:06:56 -0500
Date: Thu, 3 Jan 2019 17:06:44 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [GIT PULL] xfs: more updates for v4.21
Message-ID: <20190104010644.GC21010@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, sandeen@sandeen.net

Hi Linus,

Here are a couple more small bug fixes for 4.21-rc1.  It has undergone
the usual testing regimen and merges cleanly with 4.20 final.  Let me
know if you encounter any problems with the merge.

--D

The following changes since commit 65eed012d1f2d0f0bf0ffc036826d58147de77b8:

  xfs: reallocate realtime summary cache on growfs (2018-12-21 18:45:18 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.21-merge-3

for you to fetch changes up to 90be9b86da9039fe6cf2880dc16fd0b0899603a5:

  xfs: xfs_fsops: drop useless LIST_HEAD (2018-12-29 10:47:58 -0800)

----------------------------------------------------------------
Changes since last update:
- Remove a couple of unnecessary local variables.

----------------------------------------------------------------
Julia Lawall (2):
      xfs: xfs_buf: drop useless LIST_HEAD
      xfs: xfs_fsops: drop useless LIST_HEAD

 fs/xfs/xfs_buf.c   | 1 -
 fs/xfs/xfs_fsops.c | 1 -
 2 files changed, 2 deletions(-)
