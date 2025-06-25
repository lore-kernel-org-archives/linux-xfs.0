Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8012877FE
	for <linux-xfs@vger.kernel.org>; Wed, 25 Jun 2025 22:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750891807; cv=none; b=h8EJg+/rspwpDxWo8+U5db9JQ5vD0yB9zSjjIzUTrC24pvpLOFwwkuQxnoeIOYsic9wyvSHwTrORaMfuM1HN+458S2VnZ7HiKsRDDi9shDL10F7c55bsx8TbDH9RX8hSR8qmjZDrwxsaQ3t11dSbKDlx+lkj74R2+KbFVlR7j7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750891807; c=relaxed/simple;
	bh=b+++P7QndNMyrx+KO4BJUU2+tMBy0+DWJePg3vH/KBI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ul82l+fYqGftE+hWsCq08lMh634Io+/M7BRLUWFYmZlazVc+E1Hmt79XSKVhwVfHkWpsoDHz17ZHLTsc/mQLdF7r2zLRi1ZD0Z9FoV59dxzLaqU+T1w66aX4Q6qJruUz2kMwGTrd1QCkOR2+EF3GU+kzQBk1dw41KzTwtZE2uVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=qpB6ecdC; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="qpB6ecdC"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-747abb3cd0bso1410895b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jun 2025 15:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1750891805; x=1751496605; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k9yzBWR5cupYN0Ntrz6YKK6KPJn60StWqtlmGDbu3L4=;
        b=qpB6ecdCuEJ//4pyzgJn2MCfN5BB6vEEkaZfRSg9r0qQt4VZHC5lf68W0sqrb7F/FW
         tQg6DBKijAQ/m+dVYcH89/Q4SFCKr05X18oHeEfTrZHX2Rltl5Huvsr+2ef09jgyUSTw
         pDQKB2kYovoHSc1kI8DKqptmJCEaIa/AyNxjzegU/1wI7OUI46jJM+oWmpmwFi0M44U/
         kJvoWMozBw2LzjD4QmB547u9u8k9KnfkO6fA3LkEl1nF/XGHkoVevSsMfHhSGRZasdYA
         CnHE3jQlNzy8p24HAUzukjtnTIe4v527eDH83VNdoCTJMUn/knQffjpeTqwokwTIc4lm
         bI4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750891805; x=1751496605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k9yzBWR5cupYN0Ntrz6YKK6KPJn60StWqtlmGDbu3L4=;
        b=IZHt2+GR6pXIcxDyhixV+oiN3BOCJT5rpcs8dwbyXAMB3/Naib/4Q0eO9XEp0e9u+M
         A6y78u3XqzMGIIaPogh2StCu1kbV/uMCKBo+gFJVQ4zFLHBi/AFgv08wEybU3wpVFKVy
         2ggnTKNBl9VPIwL8a4fK0D4lJVab0w7OysTKa8neJoYck+PpbjSz3rVWKytG8esMoCrS
         ovhMYsTe3PHuHV2ToffEnd4ZJfPWOhM2bKpLSKHStAGq9H1QesmiVWmNkIuZp7kxpeoM
         iSxxukBCizcf3EjAWD/CtYzVRdcMpBlP2pzrZxJP8PXSP+hTft2uAZewfEUHgoyyKlHF
         zIKA==
X-Gm-Message-State: AOJu0Yz/21ChHJFfZlOJ+ppI0ocwUZ4B5gRk3opDA+i5FDCtC/rr9nRX
	F8bq6730x6yaeAgLUeYb+/DfPNBitw3SxlImsG+bbG81+8BsSRjd06hk3X9H8g9hmKfsJNKMA9W
	22Yul
X-Gm-Gg: ASbGncumc+Ep9e+2yaCZ91MJkFTvkpnHqNJi1hhaZn4CW0vOtotjWU9TxVYDffz+SSa
	4uRJziOxjnNPiQ4ZNEbpR9F+ynBj102o0AdBqzDOdtraQjVPto8FKoqmEyIlsc5a73blyINrXvL
	VMluzx08MnRC3VaTirCy0HvlZgIAF0jS9f1uLoRJdRzV2qin7AZzdJl6eSNmZUNm3NSgxWNdJKC
	kSUZa7FFX+JsONhe8iThx7OyZ5i2vdmulD8mRVyRyTSzoiGcbQaffmmSeZhFMZkoIc2w7GOmVkD
	nqD/Vp071xt30EA7pqJzzIhJiHD0a2D5CaR8UROWkeYOJC7EXd62i8VW6avRoj0SgfLQy5qm5R+
	zUvnPi56pYaOHoShDH23sLQ95RipKX6+ErIu9
X-Google-Smtp-Source: AGHT+IFsGb/c2voep53QrEpwgcNcn8F/WstDcbEt3A/UEj4pLQgPU8ssGiA+8e28UGc0+ubt3jhcUw==
X-Received: by 2002:a05:6a20:1443:b0:220:1843:3b7b with SMTP id adf61e73a8af0-2208d06c6c2mr2345536637.4.1750891804656;
        Wed, 25 Jun 2025 15:50:04 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-749b5e20fb8sm5587453b3a.41.2025.06.25.15.50.03
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 15:50:04 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.98.2)
	(envelope-from <dave@fromorbit.com>)
	id 1uUYwK-00000003FO5-0IfD
	for linux-xfs@vger.kernel.org;
	Thu, 26 Jun 2025 08:50:00 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.98)
	(envelope-from <dave@devoid.disaster.area>)
	id 1uUYwJ-000000061eG-408N
	for linux-xfs@vger.kernel.org;
	Thu, 26 Jun 2025 08:49:59 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 1/7] xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock
Date: Thu, 26 Jun 2025 08:48:54 +1000
Message-ID: <20250625224957.1436116-2-david@fromorbit.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250625224957.1436116-1-david@fromorbit.com>
References: <20250625224957.1436116-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

Lock order of xfs_ifree_cluster() is cluster buffer -> try ILOCK
-> IFLUSHING, except for the last inode in the cluster that is
triggering the free. In that case, the lock order is ILOCK ->
cluster buffer -> IFLUSHING.

xfs_iflush_cluster() uses cluster buffer -> try ILOCK -> IFLUSHING,
so this can safely run concurrently with xfs_ifree_cluster().

xfs_inode_item_precommit() uses ILOCK -> cluster buffer, but this
cannot race with xfs_ifree_cluster() so being in a different order
will not trigger a deadlock.

xfs_reclaim_inode() during a filesystem shutdown uses ILOCK ->
IFLUSHING -> cluster buffer via xfs_iflush_shutdown_abort(), and
this deadlocks against xfs_ifree_cluster() like so:

 sysrq: Show Blocked State
 task:kworker/10:37   state:D stack:12560 pid:276182 tgid:276182 ppid:2      flags:0x00004000
 Workqueue: xfs-inodegc/dm-3 xfs_inodegc_worker
 Call Trace:
  <TASK>
  __schedule+0x650/0xb10
  schedule+0x6d/0xf0
  schedule_timeout+0x8b/0x180
  schedule_timeout_uninterruptible+0x1e/0x30
  xfs_ifree+0x326/0x730
  xfs_inactive_ifree+0xcb/0x230
  xfs_inactive+0x2c8/0x380
  xfs_inodegc_worker+0xaa/0x180
  process_scheduled_works+0x1d4/0x400
  worker_thread+0x234/0x2e0
  kthread+0x147/0x170
  ret_from_fork+0x3e/0x50
  ret_from_fork_asm+0x1a/0x30
  </TASK>
 task:fsync-tester    state:D stack:12160 pid:2255943 tgid:2255943 ppid:3988702 flags:0x00004006
 Call Trace:
  <TASK>
  __schedule+0x650/0xb10
  schedule+0x6d/0xf0
  schedule_timeout+0x31/0x180
  __down_common+0xbe/0x1f0
  __down+0x1d/0x30
  down+0x48/0x50
  xfs_buf_lock+0x3d/0xe0
  xfs_iflush_shutdown_abort+0x51/0x1e0
  xfs_icwalk_ag+0x386/0x690
  xfs_reclaim_inodes_nr+0x114/0x160
  xfs_fs_free_cached_objects+0x19/0x20
  super_cache_scan+0x17b/0x1a0
  do_shrink_slab+0x180/0x350
  shrink_slab+0xf8/0x430
  drop_slab+0x97/0xf0
  drop_caches_sysctl_handler+0x59/0xc0
  proc_sys_call_handler+0x189/0x280
  proc_sys_write+0x13/0x20
  vfs_write+0x33d/0x3f0
  ksys_write+0x7c/0xf0
  __x64_sys_write+0x1b/0x30
  x64_sys_call+0x271d/0x2ee0
  do_syscall_64+0x68/0x130
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

We can't change the lock order of xfs_ifree_cluster() - XFS_ISTALE
and XFS_IFLUSHING are serialised through to journal IO completion
by the cluster buffer lock being held.

There's quite a few asserts in the code that check that XFS_ISTALE
does not occur out of sync with buffer locking (e.g. in
xfs_iflush_cluster). There's also a dependency on the inode log item
being removed from the buffer before XFS_IFLUSHING is cleared, also
with asserts that trigger on this.

Further, we don't have a requirement for the inode to be locked when
completing or aborting inode flushing because all the inode state
updates are serialised by holding the cluster buffer lock across the
IO to completion.

We can't check for XFS_IRECLAIM in xfs_ifree_mark_inode_stale() and
skip the inode, because there is no guarantee that the inode will be
reclaimed. Hence it *must* be marked XFS_ISTALE regardless of
whether reclaim is preparing to free that inode. Similarly, we can't
check for IFLUSHING before locking the inode because that would
result in dirty inodes not being marked with ISTALE in the event of
racing with XFS_IRECLAIM.

Hence we have to address this issue from the xfs_reclaim_inode()
side. It is clear that we cannot hold the inode locked here when
calling xfs_iflush_shutdown_abort() because it is the inode->buffer
lock order that causes the deadlock against xfs_ifree_cluster().

Hence we need to drop the ILOCK before aborting the inode in the
shutdown case. Once we've aborted the inode, we can grab the ILOCK
again and then immediately reclaim it as it is now guaranteed to be
clean.

Note that dropping the ILOCK in xfs_reclaim_inode() means that it
can now be locked by xfs_ifree_mark_inode_stale() and seen whilst in
this state. This is safe because we have left the XFS_IFLUSHING flag
on the inode and so xfs_ifree_mark_inode_stale() will simply set
XFS_ISTALE and move to the next inode. An ASSERT check in this path
needs to be tweaked to take into account this new shutdown
interaction.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c | 8 ++++++++
 fs/xfs/xfs_inode.c  | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 726e29b837e6..bbc2f2973dcc 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -979,7 +979,15 @@ xfs_reclaim_inode(
 	 */
 	if (xlog_is_shutdown(ip->i_mount->m_log)) {
 		xfs_iunpin_wait(ip);
+		/*
+		 * Avoid a ABBA deadlock on the inode cluster buffer vs
+		 * concurrent xfs_ifree_cluster() trying to mark the inode
+		 * stale. We don't need the inode locked to run the flush abort
+		 * code, but the flush abort needs to lock the cluster buffer.
+		 */
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		xfs_iflush_shutdown_abort(ip);
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		goto reclaim;
 	}
 	if (xfs_ipincount(ip))
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ee3e0f284287..761a996a857c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1635,7 +1635,7 @@ xfs_ifree_mark_inode_stale(
 	iip = ip->i_itemp;
 	if (__xfs_iflags_test(ip, XFS_IFLUSHING)) {
 		ASSERT(!list_empty(&iip->ili_item.li_bio_list));
-		ASSERT(iip->ili_last_fields);
+		ASSERT(iip->ili_last_fields || xlog_is_shutdown(mp->m_log));
 		goto out_iunlock;
 	}
 
-- 
2.45.2

