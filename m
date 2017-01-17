Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36264 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751152AbdAQEjv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Jan 2017 23:39:51 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 66635AAC7
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jan 2017 04:39:39 +0000 (UTC)
From: jeffm@suse.com
Subject: [PATCH 0/3] xfs_repair: pthread creation failure recovery fixes
Date: Mon, 16 Jan 2017 23:39:30 -0500
Message-Id: <1484627973-11535-1-git-send-email-jeffm@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>

From: Jeff Mahoney <jeffm@suse.com>

Hi all -

I recently had a bug report where xfs_repair in the dracut initramfs
environment was crashing.  It turned out to be due to systemd setting
up cgroup pids limits and pthread_create was failing.  The "real" fix
is to remove that limit, but it created a easily reproducable scenario
with which to test thread creation failure recovery.  A combination of
a small pids limit and MALLOC_PERTURB_ shook out a few bugs.  There's
more work to be done here since it should probably fall back to single
threads whenever we can't create a thread, but I only tackled the cases
that were already being handled gracefully instead of erroring out.

-Jeff

---

Jeff Mahoney (3):
  xfs_repair: clear pthread_t when pthread_create fails
  xfs_repair: add prefetch trace calls to debug thread creation failures
  xfs_repair: fix thread creation failure recovery

 repair/prefetch.c | 49 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 42 insertions(+), 7 deletions(-)

-- 
2.7.1

