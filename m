Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52614 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753118AbdBIUiA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Feb 2017 15:38:00 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/3] xfs: restore and enhance xfs indlen test
Date: Thu,  9 Feb 2017 14:43:41 -0500
Message-Id: <1486669424-45274-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

Hi all,

This series is associated with the "buffered write and indlen fixes"
series recently posted to the XFS list. These patches move the original
test to the XFS directory as it now depends on an XFS-specific
mechanism, restore the effectiveness of the original test, and finally
enhance the test to reproduce the newly identified problems fixed by the
kernel patches. Thoughts, reviews, flames appreciated.

Brian

Brian Foster (3):
  xfstests: move generic indlen reservation test to xfs dir
  tests/xfs: update indlen res. test to use fail writes mechanism
  tests/xfs: update indlen res. test to include larger write pattern

 tests/generic/033     |  84 --------------------------------------
 tests/generic/033.out |   4 --
 tests/generic/group   |   1 -
 tests/xfs/289         | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/289.out     |   2 +
 tests/xfs/group       |   1 +
 6 files changed, 112 insertions(+), 89 deletions(-)
 delete mode 100755 tests/generic/033
 delete mode 100644 tests/generic/033.out
 create mode 100755 tests/xfs/289
 create mode 100644 tests/xfs/289.out

-- 
2.7.4

