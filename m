Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38482 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751578AbdBCSe0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Feb 2017 13:34:26 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/2] divide indirect blocks fairly on delalloc extent split
Date: Fri,  3 Feb 2017 13:34:23 -0500
Message-Id: <1486146865-47286-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Patrick Dung <mpatdung@gmail.com>

Hi all,

These are a couple fixes for dealing with delalloc indlen reservations
that happen to be less than the worst case res as calculated by
xfs_bmap_worst_indlen().

Patch 1 prevents an unexpected in-core allocation and assert failure in
the delalloc extent merge case. Patch 2 reworks xfs_bmap_split_indlen()
to more fairly divide indlen blocks when an extent is split and the
existing reservation is not sufficient. The current scheme doesn't
properly deal with extents that are already under-reserved and can lead
to indlen == 0 cases fairly easily.

The latter issue was reported by Patrick[1] and reproduced simply by
copying a large sparse vdisk image using 'cp --sparse=always.' These
patches survive xfstests with and without rmapbt without regression.

Brian

[1] http://www.spinics.net/lists/linux-xfs/msg03935.html

Brian Foster (2):
  xfs: handle indlen shortage on delalloc extent merge
  xfs: split indlen reservations fairly when under reserved

 fs/xfs/libxfs/xfs_bmap.c | 67 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 46 insertions(+), 21 deletions(-)

-- 
2.7.4

