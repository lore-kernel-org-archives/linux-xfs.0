Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795290130;
	b=sPuGo3wGHaG30OjDqSH0ZMaRAlM4OJJTQ90cOiP79e7GWDjyiM1PziVnjllN3Whw3m1g
	 3p+S8U9vCFKhYgMBZx67A26HLo/NZOE+2lNJi9uhxq2Sa4PzYBOzIhvAy+umwdIkzMXBv
	 XACQ/UX1JeVAWvhTOZWRxan+DAFyuUg67+OBYKI/7vP1c1aWtW0OmGQOY/FQoeMQTN02A
	 JYSQuDkNvCl6Clngu+bmSf8nk+9r4DjPGEGab6LYUbqS+ZFfZn++NXjvgYTqwISsc+BEl
	 u4QSIwa+5/wpNKuQe0bFBSO1CGtX01+mo02+Af5kTppMXh5e6avqXtTZnoLwsb7enGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795290130;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition;
	bh=kAkaJQLKYx8dXyBsUJU/1ojkc6UWjhYE7Ml2F/blS5Y=;
	b=IjrLhW1Om6rBCaZrYskGpKh5M3M5PZj3ge/sXfkLBPs5bNF+9TzZjpMgUUJxH6qSfb3C
	 EedOihjQ3Qd/6BxElA7FVpNaIpwdfI+ByT0NyOEG/U70imu4Hd7MHv3Uw4msGWEBcedK0
	 i2EjNEDwoqTSccwguSOf+ho8tSC2XIp1hW6WcHK6E36B6DCFQJDnrgHaGF8nYTD18Pkea
	 ZPQeL1hCBDQRGkb9l6nJJkDrWp9J++sYn2Eko1HWpfCN/ECOHzQGGzsXSBHzMrLOjFz8b
	 NykP0ZW4vkEzIetxl5EU+WtjawwoDLkDkjG/iyEusM9QiTIJU/O0IS63C/56H2hgo7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i4qD2yIa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749F9606A320
	for <linux-xfs@vger.kernel.org>; Sat, 21 Nov 2026 19:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i4qD2yIa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87EA91F000C0;
	Sat, 21 Nov 2026 19:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795290130;
	bh=kAkaJQLKYx8dXyBsUJU/1ojkc6UWjhYE7Ml2F/blS5Y=;
	h=Date:From:To:Cc:Subject;
	b=i4qD2yIaI5Zqy2g4koR6jyD7+ByKX2kwpkQTwPpTJjnz7heICMHNjmKQZ+Ow9NtCM
	 dxGCChkiSTbaalqFKsI9DJtprvkjcbBOA8eTp7jJIyRv8Il+wVGhwPYBcWwICkGq9a
	 ffWWygENGVj6o6xJL9O00ZzxzhXncmldlV8YdaOb3iOcIbdUdlxewlNr0jmwvvZsIM
	 oSjR9IRaNhGdJoCD1RCLwB2gQk1Aq8hENIMkSF/d5MGnGe+FFFLlgObF3mFYGi4XTQ
	 dodfwGybjg21YPgFq5T9jWAZ2q6toYHijrRnGNTttbM368GwxhZgwHLjvyLF4fIyTr
	 r2OLqTWrueAtg==
Date: Sat, 21 Nov 2026 20:42:06 +0100
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS: Fixes for v7.4-rc4
Message-ID: <awHueLf-qBHxapi-@cronus.toxiclabs.cc>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Linus,

Could you please pull patches included in the tag below?

Mostly this pull includes fixes for a few races, an ordering problem
during init/teardown of proc/sysfs, missing locks, etc.

Also important to mention there is a patch for fs/iomap in this series
which Brauner is aware and agreed for it to go through xfs tree as it
is a dependency for the subsequent xfs patches.

This pull will create a conflict in fs/xfs/xfs_file.c as it clashes with
the following commit:
9e8fc16dc6b4 ("iomap: pass iomap_iter_next_fn directly instead of struct iomap_ops")

If it helps this is how I solved the conflict:

diff --cc fs/xfs/xfs_file.c
index d61ea8e2c8e4,8070a07e601f..ad1ce4f99ad8
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@@ -1980,11 -2039,22 +2040,22 @@@ __xfs_write_fault
                lock_mode = XFS_MMAPLOCK_EXCL;
        }

-       if (IS_DAX(inode))
+       /*
+        * The caller picked the zoned or the regular path with no lock held.
+        * The realtime flag cannot change under the MMAPLOCK, so look at it
+        * again, and start over if it has changed.
+        */
+       if (xfs_is_zoned_inode(ip) != !!ac) {
+               xfs_warn_ratelimited(ip->i_mount,
+                       "RT flag modifying during page fault for inode 0x%llx.",
+                       inode->i_ino);
+               ret = VM_FAULT_NOPAGE;
+       } else if (IS_DAX(inode)) {
                ret = xfs_dax_fault_locked(vmf, order, true);
-       else
+       } else {
 -              ret = iomap_page_mkwrite(vmf, &xfs_buffered_write_iomap_ops,
 +              ret = iomap_page_mkwrite(vmf, xfs_buffered_write_iomap_next,
                                ac);
+       }
        xfs_iunlock(ip, lock_mode);

        sb_end_pagefault(inode->i_sb);

Thanks,
Carlos

"The following changes since commit 7ba9663607b31108b4350b604a3c85ae86c67c19:

  xfs: kill xfs_trans_set/clear_context() helpers (2026-11-03 15:39:53 +0100)

are available in the Git repository at:

  git://git.kernel.org:/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.4-rc4

for you to fetch changes up to 855abf2cf8cd69a248362ca4b518de9387dd6bf5:

  xfs: test for realtime and reflink under the pNFS locks (2026-11-16 11:45:49 +0100)

----------------------------------------------------------------
xfs: fixes for Linux v7.4-rc4

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Chris Mason (11):
      xfs: don't skip the flush before shifting extents
      xfs: flush the shifted range before changing the file
      xfs: don't change the block map under a dirty folio
      iomap: don't punch delalloc under a dirty EOF block
      xfs: test for reflink after the dio write checks
      xfs: test for always COW after the dio write checks
      xfs: refuse fallocate racing with realtime flag changes
      xfs: take the MMAPLOCK in xfs_fileattr_set()
      xfs: restart faults racing with realtime flag changes
      xfs: don't enable DAX on zoned inodes
      xfs: test for realtime and reflink under the pNFS locks

Christoph Hellwig (2):
      xfs: always call xfs_update_stable_writes in xfs_ioctl_setattr_xflags
      xfs: refuse writes to files racing with realtime inode flag changes

Daejun Park (2):
      xfs: break layouts before swapping extents
      xfs: wait for direct I/O before swapping extents

Eric Sandeen (1):
      xfs: properly order xfsstats proc/sysfs init and teardown

Hengyu Liang (1):
      xfs: fix f_bfree underflow in statfs()

Rik van Riel (1):
      xfs: keep successful near rt allocations

Yiqing Wu (2):
      xfs: remove unused variable in xchk_stats_estimate_bufsize()
      xfs: remove unused variable in xrep_tempfile_copyin()

 fs/iomap/buffered-io.c  |  34 +++++++++++--
 fs/xfs/scrub/stats.c    |   3 +-
 fs/xfs/scrub/tempfile.c |   3 +-
 fs/xfs/xfs_bmap_util.c  |  30 ++++++++----
 fs/xfs/xfs_file.c       | 123 ++++++++++++++++++++++++++++++++++++++----------
 fs/xfs/xfs_inode.c      |   3 +-
 fs/xfs/xfs_ioctl.c      |  27 ++++++++---
 fs/xfs/xfs_iops.c       |   4 ++
 fs/xfs/xfs_pnfs.c       |  32 +++++++------
 fs/xfs/xfs_reflink.c    |   2 +-
 fs/xfs/xfs_rtalloc.c    |   6 ++-
 fs/xfs/xfs_super.c      |  24 +++++-----
 12 files changed, 212 insertions(+), 79 deletions(-)"
