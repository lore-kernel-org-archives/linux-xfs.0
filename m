Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB56071B5B
	for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2024 09:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719222173; cv=none; b=kkTuxOcJkOu5Tq/wLJ+LaNCxXT/qm1pXh1aWyDgDTjUQcA92af1674R57u6v8h0Rq7XtGbW+7LiF9F3MLBkcSWr3GaXLUmzAcNv7p4Yriqy1Vw1iFGupKUVo9EHSglwJEwgKmF9GhuTRxPZckhDc1BVaxvHT2ZdDQmdt+ZCjEUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719222173; c=relaxed/simple;
	bh=a5TncNxc9pRUO3ZIUW5FwbUV55+KpglcShg/4IsZkI4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=U5b/zhv0rMeRKoq6BxxCf4/oyZQ9+IMQ4+80x59ZUwbj1xMUDpzPgu1CdG7fdCQC0zbuYTjWX2jPjZxI2ZEs3HonrObsPZvc/hcKYFCYRRhcZH/ok4MclSnlB4p1RQng8lTTLOg8oKHiaFbUe4oywMepfwEGwTPuVQ5r8KYTGk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j14FdHx3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j14FdHx3"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 67662C4AF0D
	for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2024 09:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719222172;
	bh=a5TncNxc9pRUO3ZIUW5FwbUV55+KpglcShg/4IsZkI4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=j14FdHx32RsUY5qKsD/6hfYzxH3bm1hqDW37B4cTmg0oRl/lVp1jlgDfEviEPVIPD
	 qYBrHX9MFZPKXyFV49D+Y78Ua2kLO9WDSx6SpC/G2tp36DBXqjGAMqjJszuPDqEcgy
	 grnlDgNesFDTg7dRL/2ZMte160/KCOqFz3izDrrYVxdsTSzyJIqYvCpmQDmtjJbvgx
	 Brkx6+KwMFpib6KrgP623JLkmztJ98aGEpA23CaEKcV81+shGS3uwjrwtLv6DjKtRo
	 tfc4Ujf/miKW3KV8GJ338Z09QsX3bmuPY2LDx80GZbWtf3aEmeH0F4mTt/innpHCxS
	 knx4oX+EcZUow==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 61524C53BB9; Mon, 24 Jun 2024 09:42:52 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 218230] xfstests xfs/538 hung
Date: Mon, 24 Jun 2024 09:42:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: chandanbabu@kernel.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218230-201763-U2vMSafKRz@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218230-201763@https.bugzilla.kernel.org/>
References: <bug-218230-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D218230

--- Comment #2 from chandanbabu@kernel.org ---
>
> I have root caused the bug and hope to post the patches soon.

Sorry, I had forgotten about this bug. Luis reminded me about this
recently. The patches I had written turned out to be incorrect. However, the
following provides the root cause analysis of the bug.

Executing xfs/538 on a Linux v6.6 kernel can lead to the following
deadlock,

   |------------------+------------------+------------------|
   | Task A           | Task B           | Task C           |
   |------------------+------------------+------------------|
   | Lock AG 1's AGF  |                  |                  |
   |                  | Lock AG 2's AGI  |                  |
   |                  | Wait for lock on |                  |
   |                  | AG 1's AGF       |                  |
   |                  |                  | Lock AG 3's AGF  |
   |                  |                  | Wait for lock on |
   |                  |                  | AG 2's AGI       |
   | Wait for lock on |                  |                  |
   | AG 3's AGF       |                  |                  |
   |------------------+------------------+------------------|

As illustrated above, Task B and C are violating the AG locking order
rule i.e. AGI/AGF must be locked in increasing AG order and that
within an AG, AGI must be locked before an AGF.

Task B's call trace:
  context_switch (kernel/sched/core.c:5382:2)
  __schedule (kernel/sched/core.c:6695:8)
  schedule (kernel/sched/core.c:6771:3)
  schedule_timeout (kernel/time/timer.c:2143:3)
  ___down_common (kernel/locking/semaphore.c:225:13)
  __down_common (kernel/locking/semaphore.c:246:8)
  down (kernel/locking/semaphore.c:63:3)
  xfs_buf_lock (fs/xfs/xfs_buf.c:1126:2)
  xfs_buf_find_lock (fs/xfs/xfs_buf.c:553:3)
  xfs_buf_lookup (fs/xfs/xfs_buf.c:592:10)
  xfs_buf_get_map (fs/xfs/xfs_buf.c:702:10)
  xfs_buf_read_map (fs/xfs/xfs_buf.c:817:10)
  xfs_trans_read_buf_map (fs/xfs/xfs_trans_buf.c:289:10)
  xfs_trans_read_buf (./fs/xfs/xfs_trans.h:212:9)
  xfs_read_agf (fs/xfs/libxfs/xfs_alloc.c:3153:10)
  xfs_alloc_read_agf (fs/xfs/libxfs/xfs_alloc.c:3185:10)
  xfs_alloc_fix_freelist (fs/xfs/libxfs/xfs_alloc.c:2658:11)
  xfs_alloc_vextent_prepare_ag (fs/xfs/libxfs/xfs_alloc.c:3321:10)
  xfs_alloc_vextent_iterate_ags (fs/xfs/libxfs/xfs_alloc.c:3506:11)
  xfs_alloc_vextent_first_ag (fs/xfs/libxfs/xfs_alloc.c:3641:10)
  xfs_bmap_exact_minlen_extent_alloc (fs/xfs/libxfs/xfs_bmap.c:3434:10)
  xfs_bmap_alloc_userdata (fs/xfs/libxfs/xfs_bmap.c:4084:10)
  xfs_bmapi_allocate (fs/xfs/libxfs/xfs_bmap.c:4129:11)
  xfs_bmapi_write (fs/xfs/libxfs/xfs_bmap.c:4438:12)
  xfs_symlink (fs/xfs/xfs_symlink.c:271:11)
  xfs_vn_symlink (fs/xfs/xfs_iops.c:419:10)
  vfs_symlink (fs/namei.c:4480:10)
  vfs_symlink (fs/namei.c:4464:5)
  do_symlinkat (fs/namei.c:4506:11)
  __do_sys_symlink (fs/namei.c:4527:9)
  __se_sys_symlink (fs/namei.c:4525:1)
  __x64_sys_symlink (fs/namei.c:4525:1)
  do_syscall_x64 (arch/x86/entry/common.c:50:14)
  do_syscall_64 (arch/x86/entry/common.c:80:7)
  entry_SYSCALL_64+0xaa/0x1a6 (arch/x86/entry/entry_64.S:120)

Task B above locked AG 2's AGI, allocated an ondisk inode, then tried
to allocate blocks (required for holding pathname representing the
symbolic link) from AG 1. This happened due to
xfs_bmap_exact_minlen_extent_alloc() iterating across AGs starting
from AG 0.

Task C's call trace:
  context_switch (kernel/sched/core.c:5382:2)
  __schedule (kernel/sched/core.c:6695:8)
  schedule (kernel/sched/core.c:6771:3)
  schedule_timeout (kernel/time/timer.c:2143:3)
  ___down_common (kernel/locking/semaphore.c:225:13)
  __down_common (kernel/locking/semaphore.c:246:8)
  down (kernel/locking/semaphore.c:63:3)
  xfs_buf_lock (fs/xfs/xfs_buf.c:1126:2)
  xfs_buf_find_lock (fs/xfs/xfs_buf.c:553:3)
  xfs_buf_lookup (fs/xfs/xfs_buf.c:592:10)
  xfs_buf_get_map (fs/xfs/xfs_buf.c:702:10)
  xfs_buf_read_map (fs/xfs/xfs_buf.c:817:10)
  xfs_trans_read_buf_map (fs/xfs/xfs_trans_buf.c:289:10)
  xfs_trans_read_buf (./fs/xfs/xfs_trans.h:212:9)
  xfs_read_agi (fs/xfs/libxfs/xfs_ialloc.c:2598:10)
  xfs_ialloc_read_agi (fs/xfs/libxfs/xfs_ialloc.c:2626:10)
  xfs_dialloc_try_ag (fs/xfs/libxfs/xfs_ialloc.c:1690:10)
  xfs_dialloc (fs/xfs/libxfs/xfs_ialloc.c:1803:12)
  xfs_create (fs/xfs/xfs_inode.c:1020:10)
  xfs_generic_create (fs/xfs/xfs_iops.c:199:11)
  vfs_mkdir (fs/namei.c:4120:10)
  do_mkdirat (fs/namei.c:4143:11)
  __do_sys_mkdir (fs/namei.c:4163:9)
  __se_sys_mkdir (fs/namei.c:4161:1)
  __x64_sys_mkdir (fs/namei.c:4161:1)
  do_syscall_x64 (arch/x86/entry/common.c:50:14)
  do_syscall_64 (arch/x86/entry/common.c:80:7)
  entry_SYSCALL_64+0xaa/0x1a6 (arch/x86/entry/entry_64.S:120)

Task C above was trying to allocate an inode chunk to serve a mkdir()
syscall request. Task C locked AG 3's AGF and searched for the
required extent. However, the only suitable extent was found to be
straddling xfs_alloc_arg->max_agbno. Hence, it moved to the next AG
and ended up wrapping around the AG list.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
