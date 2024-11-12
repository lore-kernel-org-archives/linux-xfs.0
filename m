Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9809121745E
	for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 22:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731449968; cv=none; b=Big5J63ugQwzZTpub2z+RBgJN+uRy73RjOtlWoLyzytOittXgX+9dbero3iLtyprasifb0yrLM2ZQWhdd3t56QmjXTA2DE70VkrqLSqMyTbvTw0XEIyx4HMULkVXYmktEsNQDlFg/su6dxLqdGpjJFEgHVdYLtvlz/yHnNcHtN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731449968; c=relaxed/simple;
	bh=kwD3/W5ggXA0vWwxSJ2QDeURLk92O7XRlo4/TAU/o8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G5e8Dvnk/tw2VVFHOv6m+PZm32/ERERi+VjRW0Z4x8KeISa9QwjWRWwsa3RehMnsA9VW9ZwbDU5iHOlYAm50n+4xw3Bb7C/CVEYjj3A64obHj1iFtl/uIuvbWGTtFLQRekvkbLSnuNrZP/vwB6aMIL+sHWwhSoER6SY0bEZYNDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=OEZZtlwf; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="OEZZtlwf"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-720cb6ac25aso5695962b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 14:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1731449966; x=1732054766; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NCrzX8DC94RIQ/x55wiqFNazWZKZh5c+Fo3m/s1Otro=;
        b=OEZZtlwfxxZKwFhQJxZeDGCBE3/tJt72PhL9YAO4CjWBG4jAKYmZEoI/BqoByClWtn
         IkAKeMMebbMohNFIAYOzgSA+LRdqeynjpCczQ93g4KlpXQf9rtk2wKQWkl8FCAw9+klH
         kpV2GcUeWADMf5G+cx2XN/slW++4v0nGGHtZZ68sx0S8PJvPw9VyXyeQjvyY4cw/FTSs
         6PBy3GGHNYnZoi3yRQTwv0JshwlHpzWNGpq5dMnjXMbPiRtbLtujcUPVSxh1Fl2Z6iz1
         +m7fI69qN8xIisLJSDO8+fLcbvgwNBaYPC/cuPkmEMX9SXyon09tIc8hnz6mNALWZGOj
         viPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731449966; x=1732054766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NCrzX8DC94RIQ/x55wiqFNazWZKZh5c+Fo3m/s1Otro=;
        b=u2tfLskNWd3aHe3bBw8xTnmo5XF6QKRlfSjKRmNEza/TZucHQw79nhGTykVgp8vg0U
         BR7vgz3HLxioRcUtTQgwR6emeRPUFfF4WzkWjrvqVQh09Dv3K5SuIrQBj+Ip8ZHJxOdc
         IQTcGV81IhruGjYDf5Gq937UlnkMojQRGxbwf2//R0Gc7Fkr4+1YRCf6j7okyh6EN1KH
         3RvpzduDLQXd489blaQVNED1ssMJfXI1YD+q9trc7cGfzqOxjCPdTbtFlddjbJUtKBfi
         /Cd7o22mYQSRsK96VOThLX8sfEExga+uo9+hn9AoeW9FnqIrC7VFgVB9OEgLJGZgSj3v
         +Gqg==
X-Gm-Message-State: AOJu0YzMJI0E3Ne03bDXIRsMVDlvhOL8429e/U+ajN4ny7HHSuB1ucue
	WRlNrMtwmBfJE9O8qVvLU8Dr4sx+QlCDcpz4GAEXXK9lKXw2IXi7WKo/KU2/lJROiYaolzvDCP+
	D
X-Google-Smtp-Source: AGHT+IHEeUzo9nKt/5sR0cdYOUrFcqbWpz3gHLqetTv5TASsV41P3ElhEzhLprJt5JjVORNdjOv48A==
X-Received: by 2002:a05:6a20:3948:b0:1d8:a29b:8f6f with SMTP id adf61e73a8af0-1dc229440aemr28246599637.16.1731449965918;
        Tue, 12 Nov 2024 14:19:25 -0800 (PST)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7f41f5b3f8fsm10974624a12.19.2024.11.12.14.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 14:19:25 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1tAzEH-00Doox-0p;
	Wed, 13 Nov 2024 09:19:21 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.98)
	(envelope-from <dave@devoid.disaster.area>)
	id 1tAzEH-00000004e87-2xWL;
	Wed, 13 Nov 2024 09:19:21 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 3/3] xfs: prevent mount and log shutdown race
Date: Wed, 13 Nov 2024 09:05:16 +1100
Message-ID: <20241112221920.1105007-4-david@fromorbit.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241112221920.1105007-1-david@fromorbit.com>
References: <20241112221920.1105007-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

I recently had an fstests hang where there were two internal tasks
stuck like so:

[ 6559.010870] task:kworker/24:45   state:D stack:12152 pid:631308 tgid:631308 ppid:2      flags:0x00004000
[ 6559.016984] Workqueue: xfs-buf/dm-2 xfs_buf_ioend_work
[ 6559.020349] Call Trace:
[ 6559.022002]  <TASK>
[ 6559.023426]  __schedule+0x650/0xb10
[ 6559.025734]  schedule+0x6d/0xf0
[ 6559.027835]  schedule_timeout+0x31/0x180
[ 6559.030582]  wait_for_common+0x10c/0x1e0
[ 6559.033495]  wait_for_completion+0x1d/0x30
[ 6559.036463]  __flush_workqueue+0xeb/0x490
[ 6559.039479]  ? mempool_alloc_slab+0x15/0x20
[ 6559.042537]  xlog_cil_force_seq+0xa1/0x2f0
[ 6559.045498]  ? bio_alloc_bioset+0x1d8/0x510
[ 6559.048578]  ? submit_bio_noacct+0x2f2/0x380
[ 6559.051665]  ? xlog_force_shutdown+0x3b/0x170
[ 6559.054819]  xfs_log_force+0x77/0x230
[ 6559.057455]  xlog_force_shutdown+0x3b/0x170
[ 6559.060507]  xfs_do_force_shutdown+0xd4/0x200
[ 6559.063798]  ? xfs_buf_rele+0x1bd/0x580
[ 6559.066541]  xfs_buf_ioend_handle_error+0x163/0x2e0
[ 6559.070099]  xfs_buf_ioend+0x61/0x200
[ 6559.072728]  xfs_buf_ioend_work+0x15/0x20
[ 6559.075706]  process_scheduled_works+0x1d4/0x400
[ 6559.078814]  worker_thread+0x234/0x2e0
[ 6559.081300]  kthread+0x147/0x170
[ 6559.083462]  ? __pfx_worker_thread+0x10/0x10
[ 6559.086295]  ? __pfx_kthread+0x10/0x10
[ 6559.088771]  ret_from_fork+0x3e/0x50
[ 6559.091153]  ? __pfx_kthread+0x10/0x10
[ 6559.093624]  ret_from_fork_asm+0x1a/0x30
[ 6559.096227]  </TASK>

[ 6559.109304] Workqueue: xfs-cil/dm-2 xlog_cil_push_work
[ 6559.112673] Call Trace:
[ 6559.114333]  <TASK>
[ 6559.115760]  __schedule+0x650/0xb10
[ 6559.118084]  schedule+0x6d/0xf0
[ 6559.120175]  schedule_timeout+0x31/0x180
[ 6559.122776]  ? call_rcu+0xee/0x2f0
[ 6559.125034]  __down_common+0xbe/0x1f0
[ 6559.127470]  __down+0x1d/0x30
[ 6559.129458]  down+0x48/0x50
[ 6559.131343]  ? xfs_buf_item_unpin+0x8d/0x380
[ 6559.134213]  xfs_buf_lock+0x3d/0xe0
[ 6559.136544]  xfs_buf_item_unpin+0x8d/0x380
[ 6559.139253]  xlog_cil_committed+0x287/0x520
[ 6559.142019]  ? sched_clock+0x10/0x30
[ 6559.144384]  ? sched_clock_cpu+0x10/0x190
[ 6559.147039]  ? psi_group_change+0x48/0x310
[ 6559.149735]  ? _raw_spin_unlock+0xe/0x30
[ 6559.152340]  ? finish_task_switch+0xbc/0x310
[ 6559.155163]  xlog_cil_process_committed+0x6d/0x90
[ 6559.158265]  xlog_state_shutdown_callbacks+0x53/0x110
[ 6559.161564]  ? xlog_cil_push_work+0xa70/0xaf0
[ 6559.164441]  xlog_state_release_iclog+0xba/0x1b0
[ 6559.167483]  xlog_cil_push_work+0xa70/0xaf0
[ 6559.170260]  process_scheduled_works+0x1d4/0x400
[ 6559.173286]  worker_thread+0x234/0x2e0
[ 6559.175779]  kthread+0x147/0x170
[ 6559.177933]  ? __pfx_worker_thread+0x10/0x10
[ 6559.180748]  ? __pfx_kthread+0x10/0x10
[ 6559.183231]  ret_from_fork+0x3e/0x50
[ 6559.185601]  ? __pfx_kthread+0x10/0x10
[ 6559.188092]  ret_from_fork_asm+0x1a/0x30
[ 6559.190692]  </TASK>

This is an ABBA deadlock where buffer IO completion is triggering a
forced shutdown with the buffer lock held. It is waiting for the CIL
to flush as part of the log force. The CIL flush is blocked doing
shutdown processing of all it's objects, trying to unpin a buffer
item. That requires taking the buffer lock....

For the CIL to be doing shutdown processing, the log must be marked
with XLOG_IO_ERROR, but that doesn't happen until after the log
force is issued. Hence for xfs_do_force_shutdown() to be forcing
the log on a shut down log, we must have had a racing
xlog_force_shutdown and xfs_force_shutdown like so:

p0			p1			CIL push

   			<holds buffer lock>
xlog_force_shutdown
  xfs_log_force
   test_and_set_bit(XLOG_IO_ERROR)
   						xlog_state_release_iclog()
						  sees XLOG_IO_ERROR
						  xlog_state_shutdown_callbacks
						    ....
						    xfs_buf_item_unpin
						    xfs_buf_lock
						    <blocks on buffer p1 holds>

   			xfs_force_shutdown
			  xfs_set_shutdown(mp) wins
			    xlog_force_shutdown
			      xfs_log_force
			        <blocks on CIL push>

  xfs_set_shutdown(mp) fails
  <shuts down rest of log>

The deadlock can be mitigated by avoiding the log force on the
second pass through xlog_force_shutdown. Do this by adding another
atomic state bit (XLOG_OP_PENDING_SHUTDOWN) that is set on entry to
xlog_force_shutdown() but doesn't mark the log as shutdown.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c      | 11 +++++++++++
 fs/xfs/xfs_log_priv.h |  1 +
 2 files changed, 12 insertions(+)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 26b2f5887b88..05daad8a8d34 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3455,6 +3455,16 @@ xlog_force_shutdown(
 	if (!log)
 		return false;
 
+	/*
+	 * Ensure that there is only ever one log shutdown being processed.
+	 * If we allow the log force below on a second pass after shutting
+	 * down the log, we risk deadlocking the CIL push as it may require
+	 * locks on objects the current shutdown context holds (e.g. taking
+	 * buffer locks to abort buffers on last unpin of buf log items).
+	 */
+	if (test_and_set_bit(XLOG_SHUTDOWN_STARTED, &log->l_opstate))
+		return false;
+
 	/*
 	 * Flush all the completed transactions to disk before marking the log
 	 * being shut down. We need to do this first as shutting down the log
@@ -3487,6 +3497,7 @@ xlog_force_shutdown(
 	spin_lock(&log->l_icloglock);
 	if (test_and_set_bit(XLOG_IO_ERROR, &log->l_opstate)) {
 		spin_unlock(&log->l_icloglock);
+		ASSERT(0);
 		return false;
 	}
 	spin_unlock(&log->l_icloglock);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index b8778a4fd6b6..f3d78869e5e5 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -458,6 +458,7 @@ struct xlog {
 #define XLOG_IO_ERROR		2	/* log hit an I/O error, and being
 				   shutdown */
 #define XLOG_TAIL_WARN		3	/* log tail verify warning issued */
+#define XLOG_SHUTDOWN_STARTED	4	/* xlog_force_shutdown() exclusion */
 
 static inline bool
 xlog_recovery_needed(struct xlog *log)
-- 
2.45.2

