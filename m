Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45232 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753864AbdGJN2B (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Jul 2017 09:28:01 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5AB1778EB0
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jul 2017 13:28:01 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DDC05DC1D
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jul 2017 13:28:01 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 0/6] xfs: log recovery wrap and tail overwrite fixes
Date: Mon, 10 Jul 2017 09:27:54 -0400
Message-Id: <20170710132800.19506-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This is v2 of the tail overwrite detection series. Patches 1-4 include
mostly minor changes to fix up some error handling issues and whatnot.
Patch 5 is new and updates both of the torn write and tail overwrite
detection mechanisms to handle corruption errors along with crc mismatch
errors. Patch 6 is also new and a trivial introduction of a tracepoint.

This has survived a decent amount of testing to this point with various
block sizes, logbsize values, and feature settings (debug on/off, crc
on/off, reflink on/off) on a couple different arches (x86-64, ppc64).
Thoughts, reviews, flames appreciated.

Brian

v2:
- Fix 64-bit division.
- Fix up error checking in xlog_verify_[head|tail]() to only move tail
  tail on corruption and otherwise fail mount immediately.
- Added patch 5 to handle -EFSCORRUPTED on head/tail verification.
- Added patch 6 to introduce log head/tail tracepoint.
v1: http://www.spinics.net/lists/linux-xfs/msg07974.html
- Add patch to fix log recovery header wrapping problem.
- Replace transaction reservation rfc with log recovery based fix.
- Replace custom log pinning sysfs knob with error injection tag.
rfc: http://www.spinics.net/lists/linux-xfs/msg07623.html

Brian Foster (6):
  xfs: fix recovery failure when log record header wraps log end
  xfs: always verify the log tail during recovery
  xfs: fix log recovery corruption error due to tail overwrite
  xfs: add log item pinning error injection tag
  xfs: handle -EFSCORRUPTED during head/tail verification
  xfs: add log recovery tracepoint for head/tail

 fs/xfs/xfs_error.c       |   3 +
 fs/xfs/xfs_error.h       |   4 +-
 fs/xfs/xfs_log_recover.c | 157 +++++++++++++++++++++++++++++------------------
 fs/xfs/xfs_trace.h       |  18 ++++++
 fs/xfs/xfs_trans_ail.c   |  17 ++++-
 5 files changed, 137 insertions(+), 62 deletions(-)

-- 
2.9.4

