Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47766 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750842AbdK3S6h (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Nov 2017 13:58:37 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6DB01356CF
        for <linux-xfs@vger.kernel.org>; Thu, 30 Nov 2017 18:58:37 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 500FE60BE5
        for <linux-xfs@vger.kernel.org>; Thu, 30 Nov 2017 18:58:37 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 0/7] xfs: inode transaction reservation fixups
Date: Thu, 30 Nov 2017 13:58:29 -0500
Message-Id: <20171130185836.18481-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here's v2 of the inode tx reservation fixups. This drops the agfl fixup
patch for the time being and adds some additional reservation fixups and
refactoring based on Dave's feedback. This survives xfstests in a few
different configurations and also happens to survive my inode unlink
reservation overrun tests.

Thoughts, reviews, flames appreciated.

Brian

v2:
- Update AGI unlinked list and truncate reservations
- Update commit log for ifree refactor patch.
- Additional refactoring patches.
- Dropped agfl fixup patch.
v1: https://marc.info/?l=linux-xfs&m=151181428031884&w=2

Brian Foster (7):
  xfs: print transaction log reservation on overrun
  xfs: include inobt buffers in ifree tx log reservation
  xfs: fix up agi unlinked list reservations
  xfs: truncate transaction does not modify the inobt
  xfs: include an allocfree res for inobt modifications
  xfs: refactor inode chunk alloc/free tx reservation
  xfs: eliminate duplicate icreate tx reservation functions

 fs/xfs/libxfs/xfs_trans_resv.c | 202 ++++++++++++++++++++---------------------
 fs/xfs/xfs_log.c               |   4 +-
 2 files changed, 99 insertions(+), 107 deletions(-)

-- 
2.13.6

