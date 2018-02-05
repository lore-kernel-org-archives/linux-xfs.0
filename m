Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35294 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752582AbeBERqD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Feb 2018 12:46:03 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4AD6249012
        for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2018 17:46:03 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D93A60C4D
        for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2018 17:46:03 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/4] xfs: rmapbt block and perag reservation fixups
Date: Mon,  5 Feb 2018 12:45:57 -0500
Message-Id: <20180205174601.51574-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here's another version of the rmapbt perag reservation fixup. This
series splits the original patch into two: one for the
rename/non-functional changes and another for the logical fix. This
series also includes a couple new patches related to an issue
encountered during testing of the previous patch. I have an xfstests
test for the latter issue sketched out that I'll follow up with once
it's formalized.

Thoughts, reviews, flames appreciated.

Brian

v1:
- Split original perag res. fix into two patches.
- Additional patches for block res. issue.
rfc: https://marc.info/?l=linux-xfs&m=151741074520114&w=2

Brian Foster (4):
  xfs: shutdown if block allocation overruns tx reservation
  xfs: account format bouncing into rmapbt swapext tx reservation
  xfs: rename agfl perag res type to rmapbt
  xfs: account only rmapbt-used blocks against rmapbt perag res

 fs/xfs/libxfs/xfs_ag_resv.c    | 39 ++++++++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_ag_resv.h    | 31 +++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_alloc.c      | 14 +++-----------
 fs/xfs/libxfs/xfs_rmap_btree.c |  4 ++++
 fs/xfs/xfs_bmap_util.c         | 29 ++++++++++++++++++++---------
 fs/xfs/xfs_mount.h             | 11 ++++++-----
 fs/xfs/xfs_reflink.c           |  2 +-
 fs/xfs/xfs_trans.c             | 12 ++++++++----
 8 files changed, 95 insertions(+), 47 deletions(-)

-- 
2.13.6

