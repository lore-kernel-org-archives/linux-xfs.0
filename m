Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698741F956
	for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 20:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753820024; cv=none; b=hDoGlUs6VhBRk9oEYVagGs9wOVPM98M28JohjfwlnRfVxFbNlVhNgBP4FVPPCM6tqSsd1WIf/NuGdFHoqJvlm8b6uo/NFYEV4Wp3+wWy5x2wpYgliiVHLNjr49XHebYCq+/oNOstREBR5oZwBB0nGja4c3nujkOh+CcJnd12bj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753820024; c=relaxed/simple;
	bh=6Su0gWaeBunGiKideg+uT9dtMUK580lMCxQm8S/dXps=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q48YgD68FMRx0g6QkI62QjpiGBQL+y3AHvfsbCBCa2a7x3m1M9kJN4cgV2wzHWW2BRkqAOmeZn4u6LBrxHs+f2jUWbLnKgL0ObuKM/t9na/uJ5cwCGjUImFiAKGNZICR2IyzUhShsqgvRGj02h6T+/9jmaq3VKqUEmNf9+fR6v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A5dpmdkF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A5dpmdkF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D381EC4CEEF;
	Tue, 29 Jul 2025 20:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753820023;
	bh=6Su0gWaeBunGiKideg+uT9dtMUK580lMCxQm8S/dXps=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=A5dpmdkF9PIdhhU2rjW40QtitqOpPxNbjfelIGiA8LWfXRMnGUH9x1KSVkmewCMrg
	 8cWYkRezieX158R5OUyDh78TKtyGYYgs5OFljJzaXfRpI26xRjEiCC93wGTW1EMblP
	 eLayB2H4amnJHdPnRH6tVQBiuISp0w3aGAdiagB9yICElZuuPG5RNyxaE0bTcgvfE7
	 5EYQfSi2E4FIUJ38IVc43Uc30BO9EXLXQU/f+VYQEpaNSG3772P0nan3aM+yLzHw35
	 ht73D99qzu5wIxXXKwSkyfxDS5O6y/7jqm36B7Yzc0laUitetiJvhhQlvzUjrav15U
	 Jhop1JfQ7FdZQ==
Date: Tue, 29 Jul 2025 13:13:43 -0700
Subject: [PATCH 1/2] xfs: catch stale AGF/AGF metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, dchinner@redhat.com,
 linux-xfs@vger.kernel.org
Message-ID: <175381998797.3030433.11443248265409409000.stgit@frogsfrogsfrogs>
In-Reply-To: <175381998773.3030433.8863651616404014831.stgit@frogsfrogsfrogs>
References: <175381998773.3030433.8863651616404014831.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: db6a2274162de615ff74b927d38942fe3134d298

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
loads the drop-writes table, it makes all writes silently fail. Writes
are reported to the fs as completed successfully, but they are not
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
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_alloc.c  |   41 +++++++++++++++++++++++++++++++++--------
 libxfs/xfs_ialloc.c |   31 +++++++++++++++++++++++++++----
 2 files changed, 60 insertions(+), 12 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 6675be78a7dae8..a9fb29ea9978c4 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -3440,16 +3440,41 @@ xfs_alloc_read_agf(
 
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
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index fa9d94abb69862..8fd149e184a6f2 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2796,12 +2796,35 @@ xfs_ialloc_read_agi(
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

