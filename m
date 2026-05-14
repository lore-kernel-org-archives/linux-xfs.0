Received: from mail-pj1-f66.google.com (mail-pj1-f66.google.com [209.85.216.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD5131AF33
	for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 16:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778774842; cv=none; b=uSBU/mr+co3D51XDBNe46k+ZuhyXGUDnL1Fw2cpDpqTXwTGyPfWTaH0GWCULgajOZlX8jnd/iA3qePqOAVF+Sh6BmccHG+M6nYXGTK2wJZxLQJvZIpJSRwAmFChPApDXSaQJozFQdiKi/dGfBMP+OkqBDnsSj5Kzaw8qVA6zAcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778774842; c=relaxed/simple;
	bh=FVTUG/4xkMXTb1X9qaDdg5ObG9NX3sFDqwFVAHxN1kk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=AR1bIty3lZa2qxyzhGsPYHTn5Mh9Lc6/EmnsSBgyOX+oHfDVjZfYRxSV3Ie/Be5oYm1VnCHxsJwFUKRqilBP7L1gNLGHlbVPMpDu6CkepmtpFrBuMtTRx19I+hv+GMuhJTYSnp4ORqCUaxKbuMV6Aor75O2W6VRu920MSzMCmsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gHYNnCx/; arc=none smtp.client-ip=209.85.216.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gHYNnCx/"
Received: by mail-pj1-f66.google.com with SMTP id 98e67ed59e1d1-366087480d8so7321305a91.3
        for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 09:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778774841; x=1779379641; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xZBFX5zjwHu5P1DUvlI+NaYzNR+wqWefatYxwvoYC14=;
        b=gHYNnCx/MwrNpE5bmB9gFRlmU2l8bqHRb/9d/AjmB6xP3Z5sxfuE5Q463TcqKZ67yW
         TQhtb/NArBKPvWhAScb0BqR5yu/mxTQsKWt4Ia2d8zPWHxSd1TaxYr9GHNrbwUrthVdN
         o6ocEnQMYLCn7LQJ56UPh/J0WMXj+PtgxOgxgpK2eLvl7xK+Au9EKDGs36tekQnYNTPW
         dU9UaNPIIqYigHaA7O3lfiu7y3AOpiqsnZsy/xmmY1zK+C8mPpg1kMwGjMQMyCahlTFJ
         qzHkWivpbGl6H4kOjBw/FzgMIT9ycL9wGD7tb6q9MzrG/XUTDzHlTdcDrtId4T5kz8Ot
         Nc+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778774841; x=1779379641;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xZBFX5zjwHu5P1DUvlI+NaYzNR+wqWefatYxwvoYC14=;
        b=nt7uVrlLx8S91VT/YgBuKaZ7HiTWJ4hW34kwpWRsC1tnZeIVvOqU2sCJrBsH8nRt5a
         jNFb80+3k21YA7pKjpgpbLWcEVyHrHPmCnK8wfpnDm0tm5q24N4TEfGkFhvD2wYk3Yix
         KMD4SQDJiQSe4GeqJyv0XlI+APENTy+gS3OoT6i9Dh51kHWp/xHgPKnmopCqy200Sdxf
         RiAQepGg3Ayo+XJivj9SNBjDTdAlSD01tTtXhErRFpQGaTRcC/ITRkq6H80qTyUZNgiX
         IOty4wQa9s4OcrXUATTMDPdQV3NmkKv0mackjs2mTgFSE2gDR/3yqS6PifVjYH+cJ7kb
         xZwA==
X-Gm-Message-State: AOJu0YwRyDOf+6BvcVG5M6BWN4Ht70hGX5WCwoL67uS2a8k0MJvAm1FL
	4BV5iwtDr9asN3NntUVMDLaH4T8JvGdc0NZ7TIGoSHh1c2/vlUPItoeJ
X-Gm-Gg: Acq92OEtHAN9RAiO/QMuleP+/I6sSSGkQb45Bu3+wxt9nWdLx8YwgZwOaXrIxQjeHqW
	nFuqJcQannIr9bp78t/xGtbwntmXL7imEx5XpEQtSaOLs9yIyeOYb79+mV2eh0W/OzgNkUW9CkQ
	utzRYq+sIwV+qJ2EQzVNCKWcP+LLlaw0bNNZUAiTHn1THpNmDXNZnVvGLwZ5WDL0y6xD+OTRL9Q
	Qc+G7q+l2UjoRu2p6vtl4d0uGz971JSkcQ1vZJ0YiutQA1E8CGk0qJhkGTPjZ8MmvrBED5thyr8
	fFuExxzbCSaBSy25qemtB+LuMVu9AgmzSHWDc93HptsOuVd+j/b4rCAZPAjKxct1wWhiTA0ii9N
	tmEFh8qffCGDBcLLBAYcpmeQXdp7DfIx7EjYssDfrbROVVVGoloJ+q+ZAc5IBVfqwwATTroepvS
	v3O8GOj/qmsIct1bk0x4c3OPnofa1kMOs3iNmnfAVuYg==
X-Received: by 2002:a17:90b:2248:b0:368:341a:a925 with SMTP id 98e67ed59e1d1-36951c97685mr14970a91.23.1778774840424;
        Thu, 14 May 2026 09:07:20 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36951434eafsm83602a91.10.2026.05.14.09.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 09:07:20 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zerocling0077@gmail.com,
	2045gemini@gmail.com,
	Zhang Cen <rollkingzzc@gmail.com>
Subject: [PATCH] xfs: drain inodegc before quota teardown on mount failure
Date: Fri, 15 May 2026 00:07:12 +0800
Message-Id: <20260514160712.2260541-1-rollkingzzc@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_mountfs() starts background inodegc before mount completion. If a
later setup step fails, the out_agresv unwind can release the quota
inodes via xfs_qm_unmount_quotas() while m_qflags still leave dqattach
enabled, and the common failure path can destroy mp->m_quotainfo via
xfs_qm_unmount() before the first common inodegc drain.

That leaves two teardown windows for an inodegc worker that resumes
xfs_inactive(): dqget can still need qi_*quotaip after
xfs_qm_unmount_quotas(), and the quota cache lookup still dereferences
mp->m_quotainfo until xfs_qm_unmount() finishes. Normal unmount and the
quotacheck abort path already drain inodegc before those teardown
stages.

Fix this by draining inodegc twice on the mount failure path: once on
out_agresv before dropping AG reservations and calling
xfs_qm_unmount_quotas(), and again on the common teardown path before
xfs_qm_unmount(). Keep xfs_unmount_flush_inodes() in place afterwards so
that reclaim queued by quota, realtime, root, or metadir teardown still
runs after xfs_qm_unmount() releases quota inodes on partially
initialized mounts.

The buggy scenario involves two paths, with each column showing the order
within that path:

path A label: mount failure unwind      path B label: inodegc worker
1. xfs_mountfs() starts inodegc and     1. Recovery or eviction leaves an
   later jumps into out_agresv.            ordinary inode queued for
                                           background inactivation.
2. out_agresv used to reach             2. xfs_inodegc_worker() runs
   xfs_qm_unmount_quotas(), which          xfs_inactive() on that inode.
   releases qi_*quotaip while           3. xfs_inactive() calls
   m_qflags still allow dqattach.          xfs_qm_dqattach().
3. The common unwind later reached      4. dqattach follows m_qflags into
   xfs_qm_unmount(), which purged          dqget, which may need the quota
   dquots and destroyed                    inodes and mp->m_quotainfo being
   mp->m_quotainfo.                        torn down by the unwind.
4. The first common inodegc drain
   used to happen only after quota
   teardown had started.

Sanitizer validation reported:
general protection fault
Call trace:
  xfs_qm_dqget_cache_lookup() (?:?)
  trace_function() (kernel/trace/trace.h:806)
  xfs_qm_dqget_inode() (?:?)
  ring_buffer_unlock_commit() (kernel/trace/ring_buffer.c:4306)
  xfs_qm_dqattach_locked() (?:?)
  srso_alias_return_thunk() (arch/x86/include/asm/nospec-branch.h:375)
  xfs_qm_dqattach() (?:?)
  xfs_free_eofblocks() (?:?)
  xfs_inactive() (?:?)
  xfs_inodegc_worker() (?:?)
  process_one_work() (kernel/workqueue.c:3200)
  worker_thread() (?:?)
  kthread() (?:?)
  _raw_spin_unlock_irq() (kernel/locking/spinlock.c:204)
  ret_from_fork() (?:?)
  __switch_to() (?:?)
  ret_from_fork_asm() (?:?)

Fixes: ab23a7768739 ("xfs: per-cpu deferred inode inactivation queues")

Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>

---
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index b24195f570cd..e8a870482d1a 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1228,6 +1228,12 @@ xfs_mountfs(
 	return 0;
 
  out_agresv:
+	/*
+	 * Drain ordinary inodegc before we drop per-AG reservations or tear
+	 * down quota state.  Background inactivation can still attach dquots
+	 * here, and dqget can still need the quota inodes.
+	 */
+	xfs_inodegc_flush(mp);
 	xfs_fs_unreserve_ag_blocks(mp);
 	xfs_qm_unmount_quotas(mp);
 	if (xfs_has_zoned(mp))
@@ -1236,24 +1242,25 @@ xfs_mountfs(
 	xfs_rtunmount_inodes(mp);
  out_rele_rip:
 	xfs_irele(rip);
-	/* Clean out dquots that might be in memory after quotacheck. */
-	xfs_qm_unmount(mp);
  out_free_metadir:
 	if (mp->m_metadirip)
 		xfs_irele(mp->m_metadirip);
 
 	/*
-	 * Inactivate all inodes that might still be in memory after a log
-	 * intent recovery failure so that reclaim can free them.  Metadata
-	 * inodes and the root directory shouldn't need inactivation, but the
-	 * mount failed for some reason, so pull down all the state and flee.
+	 * Flush inodegc before we destroy quotainfo.  This is the first drain
+	 * for paths that bypass out_agresv, and it also catches any reclaim
+	 * queued by the quota, realtime, root, or metadir teardown above.
 	 */
 	xfs_inodegc_flush(mp);
 
+	/* Clean out dquots that might be in memory after quotacheck. */
+	xfs_qm_unmount(mp);
+
 	/*
 	 * Flush all inode reclamation work and flush the log.
 	 * We have to do this /after/ rtunmount and qm_unmount because those
-	 * two will have scheduled delayed reclaim for the rt/quota inodes.
+	 * will have scheduled delayed reclaim for the rt/quota/root/metadir
+	 * inodes.
 	 *
 	 * This is slightly different from the unmountfs call sequence
 	 * because we could be tearing down a partially set up mount.  In
