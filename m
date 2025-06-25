Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CB42877DC
	for <linux-xfs@vger.kernel.org>; Wed, 25 Jun 2025 22:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750891806; cv=none; b=Ftwd4b/bSMjqwK69sLQrhd/sYgy2dILT0g2qlhJ2ijX/u8nzGvDpNh1KxALLme0fv6KGbxPBRDBt8+pVHhl7mAe1DNQZ6WHfQKUnRvOrDZPiQsNe2vXdGm0x1H3e8faTho2jkQ7Jwh2H+xMvgyNqF0WQkPbJIlZOKnu0UTw4q7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750891806; c=relaxed/simple;
	bh=xAXvv5pUFPl9JKMopSBUbzzIhUbS6/u9CrsIdCM3WiM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4PwknN4hJHjuPZvQAOKwdi/D3GAYGIIOx5HJoTczj/+bnaCZCS2zJWBAuwjVoq5JoFWxEj9vHBHbfVworTpo3feQfBSIWKnxW8c5mtuGUoptCJSeydtaxknEuwCkE85TSJoZ/BEnF5ygn23FH81nd6vdF1x8VVBOhDnMyRvjRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=lcGyv2m1; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="lcGyv2m1"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2360ff7ac1bso3505965ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jun 2025 15:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1750891803; x=1751496603; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/FohsiEuJ9BIY8fT7PcHL77GMkhUGtG1Yw/E8yCqLGI=;
        b=lcGyv2m1pf4YZ1vEWiIcstsqyexE39t86kGzw17HDvY2uh7/d81sMCTDgP3c510oFy
         ShRPMtYXg4R6Ap9ND/Kb+Xkhuarg8iYCsdLU7Vxf2D8og7Av1FFuybOEima9HUsqyXYx
         jpTkrWoxWLhw7GGdhUJazqj5XGQhv4fThByUPuFZ+RLe//pu7hz2dBKsSvG66K3ZWbzj
         mDoT1Y9GM0Cf7ZB6Ty8vjeYFJOhqb2IJ/eGvJx3L6OB87uT3ZwuLvEzY00Ft2kDTs3By
         1RErhweR0YTj495fBnB9EmwV36jWHJIrpEq/QBR5qWAnQdJ24ZIU7jT2Ptx/sjAr3LiC
         A+Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750891803; x=1751496603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/FohsiEuJ9BIY8fT7PcHL77GMkhUGtG1Yw/E8yCqLGI=;
        b=HOpDqZdd7K8tfLitZmwp81Fp0rpdMWfQO6igGvLkPmQzzajYO4TtSvawdf+X/13+30
         S3+j8P9iJUq0dM2/iBXbxnQsuOh46VHp2V3t5R3He7pngHTFN4ZusZc4ehEudIWxmlHb
         /MZ4MRQ2h6i3VvpQQGhhFpD/3uwzaLtXjsuREqraVmONcuKPwUAaias+ygvN87ARcIyt
         4xo2PRjPonRNObsjElZw/D/inhJcZHAF1DdBeoZmt9kzAczNu/YLn2c9KK2vLlnzZvrP
         D10AMAFFqP9hAJZicEjlVFZ8HmYpGirBtYuw1e5a8rkzQtZtwLt5pVEpD2rKSwLoqkpO
         spCw==
X-Gm-Message-State: AOJu0YzVIJ2NvngaZszatz9mhp3/0bSFX0YcgXHViUaGP9bM8C1wuirA
	M8H3wrIVp6nQMueZXjLoUc/68rww6dCxt+jWeJgzFTY99wKwC8cCL+BfCYS/22I7dvqNZn6sp9P
	tRTT6
X-Gm-Gg: ASbGncufntNMeZa2ZWtoyj8Kpvt9DAGCfRavc3NP7C6+wfKiisyGq5ua5Rm2/NYFvuA
	Zs557PVv8OOFGdgd3VFSnj4ByDKrd5ADPwAUhKVq/+SaFPFj3JXrZiLu8IakyZmIKRSX4FvIL/j
	GPWfRnBcp30ePcJoUSqLDRFPFfiXQNJLlSPJvsnP29WTAsTXX2wzg0ZHOzOrt5N9bMr8JkUNUkD
	qIbZvHShqc0KqVlfI6cyfV3KU7+FTXan0+cz5yGZNcyXav+vQTBklb1LgQRkB6ZF8XYgrJg//SN
	UhWzMZPEuhylALwG9KmyVZOmHYiFeXIwrNs09RQLrSv6t74om07iQlqS74xYQJy+wmkQm2osdyD
	Mr35LCMH7oDSZ1GVfiQ9HtDQOorE+w9C0hcPA
X-Google-Smtp-Source: AGHT+IFZ4Tn0gqyjAgqsf54jAEDgjG/6syhzR4cG8NxptKjDkkQMwFNvC+H2uAbePcEF8SeJxriscA==
X-Received: by 2002:a17:902:ce10:b0:235:e76c:4353 with SMTP id d9443c01a7336-238e9df0ca2mr17679975ad.51.1750891803432;
        Wed, 25 Jun 2025 15:50:03 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d86091d9sm141584925ad.124.2025.06.25.15.50.02
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 15:50:02 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.98.2)
	(envelope-from <dave@fromorbit.com>)
	id 1uUYwK-00000003FO7-0PBg
	for linux-xfs@vger.kernel.org;
	Thu, 26 Jun 2025 08:50:00 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.98)
	(envelope-from <dave@devoid.disaster.area>)
	id 1uUYwJ-000000061eK-480j
	for linux-xfs@vger.kernel.org;
	Thu, 26 Jun 2025 08:49:59 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 2/7] xfs: catch stale AGF/AGF metadata
Date: Thu, 26 Jun 2025 08:48:55 +1000
Message-ID: <20250625224957.1436116-3-david@fromorbit.com>
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

There is a race condition that can trigger in dmflakey fstests that
can result in asserts in xfs_ialloc_read_agi() and
xfs_alloc_read_agf() firing. The asserts look like this:

 XFS: Assertion failed: pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks), file: fs/xfs/libxfs/xfs_alloc.c, line: 3440
.....
 Call Trace:
  <TASK>
  xfs_alloc_read_agf+0x2ad/0x3a0
  xfs_alloc_fix_freelist+0x280/0x720
  xfs_alloc_vextent_prepare_ag+0x42/0x120
  xfs_alloc_vextent_iterate_ags+0x67/0x260
  xfs_alloc_vextent_start_ag+0xe4/0x1c0
  xfs_bmapi_allocate+0x6fe/0xc90
  xfs_bmapi_convert_delalloc+0x338/0x560
  xfs_map_blocks+0x354/0x580
  iomap_writepages+0x52b/0xa70
  xfs_vm_writepages+0xd7/0x100
  do_writepages+0xe1/0x2c0
  __writeback_single_inode+0x44/0x340
  writeback_sb_inodes+0x2d0/0x570
  __writeback_inodes_wb+0x9c/0xf0
  wb_writeback+0x139/0x2d0
  wb_workfn+0x23e/0x4c0
  process_scheduled_works+0x1d4/0x400
  worker_thread+0x234/0x2e0
  kthread+0x147/0x170
  ret_from_fork+0x3e/0x50
  ret_from_fork_asm+0x1a/0x30

I've seen the AGI variant from scrub running on the filesysetm
after unmount failed due to systemd interference:

 XFS: Assertion failed: pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) || xfs_is_shutdown(pag->pag_mount), file: fs/xfs/libxfs/xfs_ialloc.c, line: 2804
.....
 Call Trace:
  <TASK>
  xfs_ialloc_read_agi+0xee/0x150
  xchk_perag_drain_and_lock+0x7d/0x240
  xchk_ag_init+0x34/0x90
  xchk_inode_xref+0x7b/0x220
  xchk_inode+0x14d/0x180
  xfs_scrub_metadata+0x2e2/0x510
  xfs_ioc_scrub_metadata+0x62/0xb0
  xfs_file_ioctl+0x446/0xbf0
  __se_sys_ioctl+0x6f/0xc0
  __x64_sys_ioctl+0x1d/0x30
  x64_sys_call+0x1879/0x2ee0
  do_syscall_64+0x68/0x130
  ? exc_page_fault+0x62/0xc0
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Essentially, it is the same problem. When _flakey_drop_and_remount()
loads the drop-writes table, it makes all writes silently fail. The
as reported to the fs as completed successfully, but they are not
issued to the backing store. The filesystem sees the successful
write completion and marks the metadata buffer clean and removes it
from the AIL.

If this happens at the same time as memory pressure is occuring,
the now-clean AGF and/or AGI buffers can be reclaimed from memory.

Shortly afterwards, but before _flakey_drop_and_remount() runs
unmount, background writeback is kicked and it tries to allocate
blocks for the dirty pages in memory. This then tries to access the
AGF buffer we just turfed out of memory. It's not found, so it gets
read in from disk.

This is all fine, except for the fact that the last writeback of the
AGF did not actually reach disk. The AGF on disk is stale compared
to the in-memory state held by the perag, and so they don't match
and the assert fires.

Then other operations on that inode hang because the task was killed
whilst holding inode locks. e.g:

 Workqueue: xfs-conv/dm-12 xfs_end_io
 Call Trace:
  <TASK>
  __schedule+0x650/0xb10
  schedule+0x6d/0xf0
  schedule_preempt_disabled+0x15/0x30
  rwsem_down_write_slowpath+0x31a/0x5f0
  down_write+0x43/0x60
  xfs_ilock+0x1a8/0x210
  xfs_trans_alloc_inode+0x9c/0x240
  xfs_iomap_write_unwritten+0xe3/0x300
  xfs_end_ioend+0x90/0x130
  xfs_end_io+0xce/0x100
  process_scheduled_works+0x1d4/0x400
  worker_thread+0x234/0x2e0
  kthread+0x147/0x170
  ret_from_fork+0x3e/0x50
  ret_from_fork_asm+0x1a/0x30
  </TASK>

and it's all down hill from there.

Memory pressure is one way to trigger this, another is to run "echo
3 > /proc/sys/vm/drop_caches" randomly while tests are running.

Regardless of how it is triggered, this effectively takes down the
system once umount hangs because it's holding a sb->s_umount lock
exclusive and now every sync(1) call gets stuck on it.

Fix this by replacing the asserts with a corruption detection check
and a shutdown.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c  | 41 ++++++++++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_ialloc.c | 31 ++++++++++++++++++++++++----
 2 files changed, 60 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 7839efe050bf..000cc7f4a3ce 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3444,16 +3444,41 @@ xfs_alloc_read_agf(
 
 		set_bit(XFS_AGSTATE_AGF_INIT, &pag->pag_opstate);
 	}
+
 #ifdef DEBUG
-	else if (!xfs_is_shutdown(mp)) {
-		ASSERT(pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks));
-		ASSERT(pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks));
-		ASSERT(pag->pagf_flcount == be32_to_cpu(agf->agf_flcount));
-		ASSERT(pag->pagf_longest == be32_to_cpu(agf->agf_longest));
-		ASSERT(pag->pagf_bno_level == be32_to_cpu(agf->agf_bno_level));
-		ASSERT(pag->pagf_cnt_level == be32_to_cpu(agf->agf_cnt_level));
+	/*
+	 * It's possible for the AGF to be out of sync if the block device is
+	 * silently dropping writes. This can happen in fstests with dmflakey
+	 * enabled, which allows the buffer to be cleaned and reclaimed by
+	 * memory pressure and then re-read from disk here. We will get a
+	 * stale version of the AGF from disk, and nothing good can happen from
+	 * here. Hence if we detect this situation, immediately shut down the
+	 * filesystem.
+	 *
+	 * This can also happen if we are already in the middle of a forced
+	 * shutdown, so don't bother checking if we are already shut down.
+	 */
+	if (!xfs_is_shutdown(pag_mount(pag))) {
+		bool	ok = true;
+
+		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
+		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
+		ok &= pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks);
+		ok &= pag->pagf_flcount == be32_to_cpu(agf->agf_flcount);
+		ok &= pag->pagf_longest == be32_to_cpu(agf->agf_longest);
+		ok &= pag->pagf_bno_level == be32_to_cpu(agf->agf_bno_level);
+		ok &= pag->pagf_cnt_level == be32_to_cpu(agf->agf_cnt_level);
+
+		if (XFS_IS_CORRUPT(pag_mount(pag), !ok)) {
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGF);
+			xfs_trans_brelse(tp, agfbp);
+			xfs_force_shutdown(pag_mount(pag),
+					SHUTDOWN_CORRUPT_ONDISK);
+			return -EFSCORRUPTED;
+		}
 	}
-#endif
+#endif /* DEBUG */
+
 	if (agfbpp)
 		*agfbpp = agfbp;
 	else
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 0c47b5c6ca7d..750111634d9f 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2801,12 +2801,35 @@ xfs_ialloc_read_agi(
 		set_bit(XFS_AGSTATE_AGI_INIT, &pag->pag_opstate);
 	}
 
+#ifdef DEBUG
 	/*
-	 * It's possible for these to be out of sync if
-	 * we are in the middle of a forced shutdown.
+	 * It's possible for the AGF to be out of sync if the block device is
+	 * silently dropping writes. This can happen in fstests with dmflakey
+	 * enabled, which allows the buffer to be cleaned and reclaimed by
+	 * memory pressure and then re-read from disk here. We will get a
+	 * stale version of the AGF from disk, and nothing good can happen from
+	 * here. Hence if we detect this situation, immediately shut down the
+	 * filesystem.
+	 *
+	 * This can also happen if we are already in the middle of a forced
+	 * shutdown, so don't bother checking if we are already shut down.
 	 */
-	ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
-		xfs_is_shutdown(pag_mount(pag)));
+	if (!xfs_is_shutdown(pag_mount(pag))) {
+		bool	ok = true;
+
+		ok &= pag->pagi_freecount == be32_to_cpu(agi->agi_freecount);
+		ok &= pag->pagi_count == be32_to_cpu(agi->agi_count);
+
+		if (XFS_IS_CORRUPT(pag_mount(pag), !ok)) {
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
+			xfs_trans_brelse(tp, agibp);
+			xfs_force_shutdown(pag_mount(pag),
+					SHUTDOWN_CORRUPT_ONDISK);
+			return -EFSCORRUPTED;
+		}
+	}
+#endif /* DEBUG */
+
 	if (agibpp)
 		*agibpp = agibp;
 	else
-- 
2.45.2

