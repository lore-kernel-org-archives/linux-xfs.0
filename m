Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4AE71B5B
	for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2024 09:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719222171; cv=none; b=p1EmQLG3ObOwJmAohl5p/ZH9/Pk2+RITaTxEQgswlpiGeyGPRZauoeOU8y/A8aOBEM9M2U8lcRY1GTZAjMsdNAVfMjh0Dsp2Wt9zh1qS0cHk/FaKG4vbg8ADT4WwYbo4jg42jzyEnKyTbuVZ3e9FO9VQHP7S1wa9hWnNzdxSmFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719222171; c=relaxed/simple;
	bh=b6gQ/a0uNEuWCGf2JCpEZusFOXvzrkdfUntDZuwUXMo=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=uhhs4vgBcDHCS6Rm0+miH5+f5GcKj5TN+XzaWZ1lF75MSlauk0+uQo9LK9D8La1b32UI5Qi8iQBJvIX+DgiyuZmgtGLtI4WBSqRIhC8KshdnmykVhnGpDiIiGmKpQgxGf0G4oJFgYese4XMy47rnoaQtH26/RPWh4d2FBlzA1Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tsrd/T1s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tsrd/T1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66722C2BBFC;
	Mon, 24 Jun 2024 09:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719222170;
	bh=b6gQ/a0uNEuWCGf2JCpEZusFOXvzrkdfUntDZuwUXMo=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=tsrd/T1sq2fPLbAuAJ5FQPogkj7a34sz+PjP8HcZopNYmXcBPhFjAN7Ezv4GaL2G3
	 LjyzRCfbu98UI3uLSKp+TqEN68V35MCVKzMCiFJrvxWIwho592oaetdqa87UFQ7Dib
	 HxUcsHq9rf4gpPWRXtTkB4YSaDGV3mpKvig3oGynNeqRZCk6+C6rwoddeOI1qNDnMo
	 g4XU+y2sNO18VyQacvU5x4ziwoEmQitfY5AzpkZ6GeqfFF5lnKXVnWGwbLeX6fITHO
	 tEmCLwnKTHjLkimSX4w0gyrToPsqo42ZOPb2n2rUu1ip+eTKrOrrV5uAqrYxHDEtSG
	 EbCzfcgGnqQFw==
References: <bug-218230-201763@https.bugzilla.kernel.org/>
 <bug-218230-201763-FKGdPQu2af@https.bugzilla.kernel.org/>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: bugzilla-daemon@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: Re: [Bug 218230] xfstests xfs/538 hung
Date: Mon, 24 Jun 2024 15:09:13 +0530
In-reply-to: <bug-218230-201763-FKGdPQu2af@https.bugzilla.kernel.org/>
Message-ID: <87bk3qoew9.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

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

-- 
Chandan
