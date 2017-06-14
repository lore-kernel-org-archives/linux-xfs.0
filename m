Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52458 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751760AbdFNUiT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jun 2017 16:38:19 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 57FCEC04B329
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jun 2017 20:38:19 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26B9B17106
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jun 2017 20:38:19 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH] xfs: prevent overwrite of pinned log tail
Date: Wed, 14 Jun 2017 16:38:17 -0400
Message-Id: <1497472697-3574-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

If the log tail is pinned, the head pushes right up behind it and
the tail moves forward, it's possible for the next N log buffer
writes to overwrite the previously pinned tail. If those log writes
all happen to partially fail, the filesystem shuts down having
corrupted the tail pointed to by the last good record in the on-disk
log.

On the subsequent mount, log recovery identifies the partially
written buffers, walks the head back to the last good record and
uses the tail for that record. If that tail has been corrupted by
the aforementioned failed log writes, log recovery will likely fail
with log record CRC errors. Even though the tail was moved forward
and safely overwritten at runtime, the broader log recovery failure
leads to the loss of changes beyond the overwritten tail (i.e.,
starting from wherever the tail was pushed forward to) to the
current head.

This is a possible data loss and filesystem corruption vector. To
avoid this problem, leave a buffer of unreservable space behind the
current in-core tail equal to the maximum amount of log data that
can be written out at one time. This ensures that if the log writes
fail, they cannot have overwritten the previous tail and the errors
are detected and the filesystem shuts down before that occurs.

Not-Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This RFC is fallout from the recent log recovery error thread[1]. Note
that there is no confirmation of root cause on that thread atm, but I
suspect something like this could be the culprit.

I was initially thinking we'd need to do something like serialize a log
buffer write against an AIL push before we get into the state where this
problem is possible. As it turns out, I think iclog issue time is much
too late to accomplish something like that because the in-core log
buffers have already been constructed/formatted.

This RFC is a step back from that train of thought and is an experiment
that I believe does actually prevent the problem. I don't think it's a
proper fix, however, for one because it has rather broad ramifications
in that it steals and makes unusable a portion of the on-disk log.
Further, the more I think about this, the more this seems to be a log
recovery problem more than anything. This situation is only possible at
runtime if the in-core tail has been moved forward, meaning the data at
the previous tail has been successfully written back.

Therefore, it seems more like it should be the responsibility of log
recovery to deal with this correctly. For example, if the head is walked
back some number of blocks due to a partially written record, log
recovery should accommodate that the updated tail may be stale if it
points into that range. I think this means the tail may need to be
walked forward to the point where log recovery can be safely attempted.
The challenge there may be to distinguish between a stale tail pointer
and true corruption (where log recovery should actually fail).

This is still not fully thought out. I'm posting this for thoughts or
comments in the meantime. While I can sort of emulate this problem, I
also think I need to enhance the current recipe I have to something that
more resembles a legitimate reproducer. Enough rambling for now...
thoughts or comments appreciated.

Brian

[1] http://www.spinics.net/lists/linux-xfs/msg07499.html

 fs/xfs/xfs_log.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 3731f13..8a4ee89 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1140,6 +1140,7 @@ xlog_space_left(
 	int		tail_cycle;
 	int		head_cycle;
 	int		head_bytes;
+	int		tail_window;
 
 	xlog_crack_grant_head(head, &head_cycle, &head_bytes);
 	xlog_crack_atomic_lsn(&log->l_tail_lsn, &tail_cycle, &tail_bytes);
@@ -1167,6 +1168,28 @@ xlog_space_left(
 		ASSERT(0);
 		free_bytes = log->l_logsize;
 	}
+
+	/*
+	 * Now that we have the physical free space, leave a buffer between how
+	 * far we can push the head behind the tail. If the tail is pinned long
+	 * enough for the head to push right up behind the tail, chances are the
+	 * last good record in the log points to the current tail. If the tail
+	 * moves forward and the next N log buffer writes all happen to fail in
+	 * spectacular fashion (i.e., partial write failure), we'll potentially
+	 * overwrite the tail of the last good record in the log.
+	 *
+	 * This causes problems for log recovery when it identifies the partial
+	 * writes, walks the head back to the end of the last good record in the
+	 * log and attempts to verify that record's tail (the one we've just
+	 * corrupted). To avoid this problem, leave a window of unusable space
+	 * behind the current tail large enough to guarantee that the next N log
+	 * buffers cannot overwrite the old tail. The size is based on the max
+	 * possible number of iclog buffers in flight at one time (plus 1 for
+	 * caution).
+	 */
+	tail_window = log->l_iclog_size * (log->l_iclog_bufs + 1);
+	free_bytes -= MIN(free_bytes, tail_window);
+
 	return free_bytes;
 }
 
-- 
2.7.5

