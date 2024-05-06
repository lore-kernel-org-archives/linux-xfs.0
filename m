Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9505D44376
	for <linux-xfs@vger.kernel.org>; Mon,  6 May 2024 04:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714969456; cv=none; b=O+BA6uXIr1ZDDX0SSgfODo04R3NB2jJ4uDkpxAlcmLVXm+5yaLYYknrBPdBNl1kBwAS/6tOK8qhC80j0H6m93J8sSKIF/NB9QVSccjbJsq50U9E1DEqjwGoJcNGEHa5VySBRXht7lhm+IWUI59QGLbIG/s/ENMv/OnTVLQrLLHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714969456; c=relaxed/simple;
	bh=FAO5LYE6I/Ulzf1Oce5YWxuwVXpBI0RfXdh8PqoxbKw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mioucuySm3ejDvOGB08G/s6FF71lzLLVKWRYw/RPJdBrAgpxBf7VMFHXDfu3U4/R8I3W0SumbAxsuB8Ti8z2ufaYoalhn/2l0iKkseetHgOjHd3JsH2MI0qGoJEZ6IAgfVta7bjq7rGF1oBCNTtCKdiIjobWx9spWHhuqcN4CxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M4+DaDkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M4+DaDkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6D3C116B1;
	Mon,  6 May 2024 04:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714969456;
	bh=FAO5LYE6I/Ulzf1Oce5YWxuwVXpBI0RfXdh8PqoxbKw=;
	h=From:To:Cc:Subject:Date:From;
	b=M4+DaDkn4DkB1rAFA59q1poQXLVPh5z46g56bx1r+rnusxb2QS2Lpjv9qXpnEj5be
	 kLFnCSOqqLbz2z4fOzogpqFWtwU5Q69O0HZqCYtkV2fzVQzgHvNVEAGbvd6y8mIaSf
	 UoYNo+UGmsnFfRnaZEkIXMyN3ncVWIRHJMbZsKSruRWYiSAIDzmLvdIPKD0m+OwZV5
	 5unEjNR7AvoqF6DL6q9aYhxkQmcbfrnxb1ZRrqbD2XlTff6vV97jZKCb7TQGuL4nE4
	 s7n8J7L/Za9u6O6GZwzAktnh5WL/iBcNeN6YDdnLWT9vS0aFsoD+EEuInP4ciA0KBY
	 j2z2SYex9cZuA==
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: Linux-XFS mailing list <linux-xfs@vger.kernel.org>
Cc: Darrick J. Wong <djwong@kernel.org>
Subject: [BUG REPORT] Deadlock when executing xfs/708 on xfs-linux's for-next
Date: Mon, 06 May 2024 09:47:33 +0530
Message-ID: <87edaftvo3.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hi,

Executing xfs/708 on xfs-linux's current for-next (commit
25576c5420e61dea4c2b52942460f2221b8e46e8) causes the following hung task
timeout to be printed,

[ 6328.415475] run fstests xfs/708 at 2024-05-04 15:35:29
[ 6328.964720] XFS (loop16): EXPERIMENTAL online scrub feature in use. Use at your own risk!
[ 6329.258411] XFS (loop5): Mounting V5 Filesystem e96086f0-a2f9-4424-a1d5-c75d53d823be
[ 6329.265694] XFS (loop5): Ending clean mount
[ 6329.267899] XFS (loop5): Quotacheck needed: Please wait.
[ 6329.280141] XFS (loop5): Quotacheck: Done.
[ 6329.291589] XFS (loop5): EXPERIMENTAL online scrub feature in use. Use at your own risk!
[ 7865.474615] INFO: task xfs_io:143725 blocked for more than 122 seconds.
[ 7865.476744]       Not tainted 6.9.0-rc4+ #1
[ 7865.478109] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 7865.479827] task:xfs_io          state:D stack:0     pid:143725 tgid:143725 ppid:117661 flags:0x00004006
[ 7865.481685] Call Trace:
[ 7865.482761]  <TASK>
[ 7865.483801]  __schedule+0x69c/0x17a0
[ 7865.485053]  ? __pfx___schedule+0x10/0x10
[ 7865.486372]  ? _raw_spin_lock_irq+0x8b/0xe0
[ 7865.487576]  schedule+0x74/0x1b0
[ 7865.488749]  io_schedule+0xc4/0x140
[ 7865.489943]  folio_wait_bit_common+0x254/0x650
[ 7865.491308]  ? __pfx_folio_wait_bit_common+0x10/0x10
[ 7865.492596]  ? __pfx_find_get_entries+0x10/0x10
[ 7865.493875]  ? __pfx_wake_page_function+0x10/0x10
[ 7865.495222]  ? lru_add_drain_cpu+0x1dd/0x2e0
[ 7865.496399]  shmem_undo_range+0x9d5/0xb40
[ 7865.497558]  ? __pfx_shmem_undo_range+0x10/0x10
[ 7865.498757]  ? poison_slab_object+0x106/0x190
[ 7865.500003]  ? kfree+0xfc/0x300
[ 7865.501107]  ? xfs_scrub_metadata+0x84e/0xdf0 [xfs]
[ 7865.502466]  ? xfs_ioc_scrub_metadata+0x9e/0x120 [xfs]
[ 7865.503900]  ? wakeup_preempt+0x161/0x260
[ 7865.505105]  ? _raw_spin_lock+0x85/0xe0
[ 7865.506214]  ? __pfx__raw_spin_lock+0x10/0x10
[ 7865.507334]  ? _raw_spin_lock+0x85/0xe0
[ 7865.508410]  ? __pfx__raw_spin_lock+0x10/0x10
[ 7865.509524]  ? __pfx__raw_spin_lock+0x10/0x10
[ 7865.510638]  ? _raw_spin_lock+0x85/0xe0
[ 7865.511677]  ? kasan_save_track+0x14/0x30
[ 7865.512754]  ? kasan_save_free_info+0x3b/0x60
[ 7865.513872]  ? poison_slab_object+0x106/0x190
[ 7865.515084]  ? xfs_scrub_metadata+0x84e/0xdf0 [xfs]
[ 7865.516326]  ? kfree+0xfc/0x300
[ 7865.517302]  ? xfs_scrub_metadata+0x84e/0xdf0 [xfs]
[ 7865.518578]  shmem_evict_inode+0x322/0x8f0
[ 7865.519626]  ? __inode_wait_for_writeback+0xcf/0x1a0
[ 7865.520801]  ? __pfx_shmem_evict_inode+0x10/0x10
[ 7865.521951]  ? __pfx___inode_wait_for_writeback+0x10/0x10
[ 7865.523136]  ? __pfx_wake_bit_function+0x10/0x10
[ 7865.524207]  ? __pfx__raw_spin_lock+0x10/0x10
[ 7865.525243]  ? __pfx__raw_spin_lock+0x10/0x10
[ 7865.526236]  evict+0x24e/0x560
[ 7865.527091]  __dentry_kill+0x17d/0x4d0
[ 7865.528107]  dput+0x263/0x430
[ 7865.529006]  __fput+0x2fc/0xaa0
[ 7865.529927]  task_work_run+0x132/0x210
[ 7865.530891]  ? __pfx_task_work_run+0x10/0x10
[ 7865.531910]  get_signal+0x1a8/0x1910
[ 7865.532917]  ? kasan_save_track+0x14/0x30
[ 7865.533885]  ? kasan_save_free_info+0x3b/0x60
[ 7865.534880]  ? __pfx_get_signal+0x10/0x10
[ 7865.535793]  ? poison_slab_object+0xbe/0x190
[ 7865.536784]  ? __pfx_ioctl_has_perm.constprop.0.isra.0+0x10/0x10
[ 7865.537952]  arch_do_signal_or_restart+0x7b/0x2f0
[ 7865.539014]  ? __pfx_arch_do_signal_or_restart+0x10/0x10
[ 7865.540091]  ? restore_fpregs_from_fpstate+0x96/0x150
[ 7865.541123]  ? __pfx_restore_fpregs_from_fpstate+0x10/0x10
[ 7865.542209]  ? security_file_ioctl+0x51/0x90
[ 7865.543153]  syscall_exit_to_user_mode+0x1c2/0x200
[ 7865.544165]  do_syscall_64+0x72/0x170
[ 7865.545033]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[ 7865.546095] RIP: 0033:0x7f4d18c3ec6b
[ 7865.547033] RSP: 002b:00007ffe2056f878 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 7865.548407] RAX: fffffffffffffffc RBX: 0000000000000001 RCX: 00007f4d18c3ec6b
[ 7865.549757] RDX: 00007ffe2056f880 RSI: 00000000c040583c RDI: 0000000000000003
[ 7865.551047] RBP: 000000001bd46c40 R08: 0000000000000002 R09: 0000000000000000
[ 7865.552317] R10: 00007f4d18d9eac0 R11: 0000000000000246 R12: 0000000000000000
[ 7865.553619] R13: 000000001bd46bc0 R14: 000000001bd46520 R15: 0000000000000004
[ 7865.555005]  </TASK>

The following is the contents from fstests config file,

FSTYP=xfs
TEST_DIR=/media/test
SCRATCH_MNT=/media/scratch
DUMP_CORRUPT_FS=1
SOAK_DURATION=1320

TEST_DEV=/dev/loop16
SCRATCH_DEV_POOL="/dev/loop5 /dev/loop6 /dev/loop7 /dev/loop8 /dev/loop9 /dev/loop10 /dev/loop11 /dev/loop12"
MKFS_OPTIONS='-f -m reflink=1,rmapbt=1, -i sparse=1,'
MOUNT_OPTIONS='-o usrquota,grpquota,prjquota'
TEST_FS_MOUNT_OPTS="$TEST_FS_MOUNT_OPTS -o usrquota,grpquota,prjquota"
USE_EXTERNAL=no
LOGWRITES_DEV=/dev/loop15

-- 
Chandan
