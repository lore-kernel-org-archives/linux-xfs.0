Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44339 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfGXGfB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 02:35:01 -0400
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 0/6] xfs: stable fixes for v4.19.y - circa v4.19.60
Date: Wed, 24 Jul 2019 06:34:45 +0000
Message-Id: <20190724063451.26190-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, Alexander.Levin@microsoft.com
Cc: gregkh@linuxfoundation.org, stable@vger.kernel.org, amir73il@gmail.com, Luis Chamberlain <mcgrof@kernel.org>

Sasha,

you merged my last set of XFS fixes. I asked for one patch to not be
merged yet as one issue was not yet properly fixed. After some further
review I have identified commits which do fix the kernel crash reported
on kz#204223 [0] with generic/388, this patch set applies on top of the
last one I sent you.

These commits do quite a bit of code refactoring, and the actual fix
lies hidden in the last commit by Darrick. Due to the amount of changes
trying to extract the fix is riskier than just carring the code
refactoring. If we're OK with the code refactor for stable, its my
recommendation we keep the changes to match more with upstream and
benefit from other fixes. The code refactoring was merged on v4.20 and
Darrick's fix is the only fix upstream since the code was merged.

If others disagree with this approach please speak up.

I've run a full set of fstests against the following sections 12 times and
have found no regressions against the baseline:

xfs
xfs_logdev
xfs_nocrc_512
xfs_nocrc
xfs_realtimedev
xfs_reflink_1024
xfs_reflink_dev

Review from others is appreciated.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=204223

Allison Henderson (4):
  xfs: Move fs/xfs/xfs_attr.h to fs/xfs/libxfs/xfs_attr.h
  xfs: Add helper function xfs_attr_try_sf_addname
  xfs: Add attibute set and helper functions
  xfs: Add attibute remove and helper functions

Brian Foster (1):
  xfs: don't trip over uninitialized buffer on extent read of corrupted
    inode

Darrick J. Wong (1):
  xfs: always rejoin held resources during defer roll

 fs/xfs/libxfs/xfs_attr.c       | 231 ++++++++++++++++++---------------
 fs/xfs/{ => libxfs}/xfs_attr.h |   2 +
 fs/xfs/libxfs/xfs_bmap.c       |  54 +++++---
 fs/xfs/libxfs/xfs_bmap.h       |   1 +
 fs/xfs/libxfs/xfs_defer.c      |  14 +-
 fs/xfs/xfs_dquot.c             |  17 +--
 6 files changed, 183 insertions(+), 136 deletions(-)
 rename fs/xfs/{ => libxfs}/xfs_attr.h (98%)

-- 
2.18.0
