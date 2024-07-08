Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CFE1CD06
	for <linux-xfs@vger.kernel.org>; Mon,  8 Jul 2024 07:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720424633; cv=none; b=LupA4s7dLh6BvKZP74Ppht0yBXZviD5R1HzxYGPleLwTPX+iP8uEiIzi6cUeJ977LN//N3pVm/1rPhh3Hme5bPNSN6vin4h9S4sbtzGj0qqIuGG0qZh3dAvf2mrxz5TSkVKS6O3u7aVy0ZhvqJkGGn4ZxJJrkyrn+hlMIqPsUjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720424633; c=relaxed/simple;
	bh=199U0J9R4sSAofBAbrDBAsmOc9E1s51Z2EA3CA308rY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uz5MdIT9FiyBfdoTigaQM1jkNCZsV5yz5K2N/ARm1X5i1G2Jyw4DiZ42VrGg0taXyxM+DwiG+x69KpsdbnUht/tNxNFKZS6My/x5x8n08G2UlCbnn9TjNFlt87gZaD9y6TMZqpW5MmxZBYaqIrjDtZ45Rm6/faAdx2xdA5DGBOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TOGgiCeP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TOGgiCeP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB9FC116B1
	for <linux-xfs@vger.kernel.org>; Mon,  8 Jul 2024 07:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720424632;
	bh=199U0J9R4sSAofBAbrDBAsmOc9E1s51Z2EA3CA308rY=;
	h=From:To:Subject:Date:From;
	b=TOGgiCePNP+FbO6wLEIO2dxvORd7kieCjF1Kzb7Jyz9HvrBzfmitgQObq+zNc8yMn
	 XI0f5NrTbiRbwa5nZmneYRjC0Vy0MYzHDe7tPMTJcjz7yQ7Ce/hZ7L3bzvjpejM1op
	 yjO58BUprnoYIKwebp6gnmlEBDXlS9acYmKhY9AZvKwtSF3KjJ+1LwzE0+NnL57xRB
	 y+AZ5OPqjqJ5hhG3XdXsd8PiIgpLjZwTOoqcpTPA/TRMYdIFoIG114j0U7V+1Jo4wa
	 WqnMTd+tDy/4XctWNPei491A3QsmPKuKz4OxUnLguOHOF7ROwkrzcJ3iaamTDi/Ch8
	 DtJqeRm7xaFSA==
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: xfs <linux-xfs@vger.kernel.org>
Subject: [BUG REPORT] xfs/057: Unable to reclaim inodes during fs unmount
Date: Mon, 08 Jul 2024 12:56:27 +0530
Message-ID: <87wmlwib0x.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hi,

On current xfs-linux' for-next (i.e. commit
49cdc4e834e46d7c11a91d7adcfa04f56d19efaf), xfs/057 caused umount to execute in
an infinite loop inside the kernel. The following was obtained by 'perf
record/report',


24.39%  [kernel.kallsyms]                      [k] __lock_acquire.constprop.0
        |          
         --24.13%--0
                   |          
                    --24.12%--0x7f939ab4e8ab
                              entry_SYSCALL_64
                              do_syscall_64
                              syscall_exit_to_user_mode
                              task_work_run
                              cleanup_mnt
                              deactivate_locked_super
                              xfs_kill_sb
                              kill_block_super
                              generic_shutdown_super
                              xfs_fs_put_super
                              xfs_unmountfs
                              xfs_unmount_flush_inodes
                              xfs_reclaim_inodes
                              |          
                               --24.01%--xfs_icwalk
                                         |          
                                          --23.79%--xfs_icwalk_ag
                                                    |          
                                                    |--17.47%--xfs_reclaim_inode
                                                    |          |          
                                                    |          |--11.71%--_raw_spin_lock
                                                    |          |          |          
                                                    |          |           --11.71%--lock_acquire.part.0.isra.0
                                                    |          |                     |          
                                                    |          |                      --11.70%--__lock_acquire.constprop.0
                                                    |          |          
                                                    |           --5.72%--xfs_ilock_nowait
                                                    |                     down_write_trylock
                                                    |                     |          
                                                    |                      --5.71%--lock_acquire.part.0.isra.0
                                                    |                                |          
                                                    |                                 --5.71%--__lock_acquire.constprop.0
                                                    |          
                                                     --5.98%--_raw_spin_lock
                                                               |          
                                                                --5.98%--lock_acquire.part.0.isra.0
                                                                          __lock_acquire.constprop.0

I noticed that 66 xfs inodes had XFS_IFLUSHING flag set and the flag is never
cleared. This causes xfs_reclaim_inode() to return back to the caller without
freeing these inodes.

Unfortunately, I am unable to recreate the bug.

The following is from the dmesg log:
  [11154.874186] run fstests xfs/057 at 2024-07-05 04:23:26
  [11155.685899] XFS (loop16): Mounting V5 Filesystem 0313cedd-1cea-4c58-9fde-6cf7896ac67c
  [11155.700962] XFS (loop16): Ending clean mount
  [11155.971856] XFS (loop5): Mounting V5 Filesystem 7c161a2e-e85a-4f29-91c3-5ef1bbd92f14
  [11155.981646] XFS (loop5): Ending clean mount
  [11155.984130] XFS (loop5): Quotacheck needed: Please wait.
  [11155.997672] XFS (loop5): Quotacheck: Done.
  [11188.028961] XFS (loop5): Unmounting Filesystem 7c161a2e-e85a-4f29-91c3-5ef1bbd92f14
  [11191.038552] XFS (loop5): Mounting V5 Filesystem 7c161a2e-e85a-4f29-91c3-5ef1bbd92f14
  [11191.052389] XFS (loop5): Ending clean mount
  [11221.299133] XFS (loop5): Injecting error (false) at file fs/xfs/xfs_log.c, line 1849, on filesystem "loop5"
  [11221.302411] XFS (loop5): Intentionally corrupted log record at LSN 0x1000250d3. Shutdown imminent.
  [11221.304993] XFS (loop5): Injecting error (false) at file fs/xfs/xfs_log.c, line 1849, on filesystem "loop5"
  [11221.307158] XFS (loop5): Intentionally corrupted log record at LSN 0x100025113. Shutdown imminent.
  [11221.309697] XFS (loop5): log I/O error -5
  [11221.309807] XFS (loop5): Injecting error (false) at file fs/xfs/xfs_log.c, line 1849, on filesystem "loop5"
  [11221.311068] XFS (loop5): log I/O error -5
  [11221.311076] XFS (loop5): Filesystem has been shut down due to log error (0x2).
  [11221.311081] XFS (loop5): Please unmount the filesystem and rectify the problem(s).
  [11221.321602] XFS (loop5): Intentionally corrupted log record at LSN 0x100025153. Shutdown imminent.
  [11222.109007] XFS (loop5): Unmounting Filesystem 7c161a2e-e85a-4f29-91c3-5ef1bbd92f14

The following is the fstests configuration used for testing:
  FSTYP=xfs
  TEST_DIR=/media/test
  SCRATCH_MNT=/media/scratch
  DUMP_CORRUPT_FS=1
  RECREATE_TEST_DEV=true
  
  TEST_DEV=/dev/loop16
  TEST_LOGDEV=/dev/loop13
  SCRATCH_DEV_POOL="/dev/loop5 /dev/loop6 /dev/loop7 /dev/loop8 /dev/loop9 /dev/loop10 /dev/loop11 /dev/loop12"
  MKFS_OPTIONS='-f -m crc=1,reflink=0,rmapbt=0, -i sparse=0 -lsize=1g'
  TEST_FS_MOUNT_OPTS="-o logdev=/dev/loop13"
  MOUNT_OPTIONS='-o usrquota,grpquota,prjquota'
  TEST_FS_MOUNT_OPTS="$TEST_FS_MOUNT_OPTS -o usrquota,grpquota,prjquota"
  SCRATCH_LOGDEV=/dev/loop15
  USE_EXTERNAL=yes
  LOGWRITES_DEV=/dev/loop15

-- 
Chandan
