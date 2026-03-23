Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA35299AAB;
	Mon, 23 Mar 2026 21:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774299618; cv=none; b=g5V1E1NH/gJ+UGzSWR+2zJCu1ebSyLHobUKJ8PelxBeEovi0dVcKYXrLyh40Hm+z4/vCbQ9Tlf8RS6ph7ctE6fEIpcdVUfZGl1hkIUkb0w3gFtxgin3ZbIdeX4pB5bGzaXuckUhRpxdCVUTm160Kf54jtfci0OP5nf6tdGwP8Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774299618; c=relaxed/simple;
	bh=S6fGhE/o2xAfNdt3szTUUCNWsdix3N8psukAcCjJ0Zg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hb8uUztDtjcr6Bymy5kbtjnNnEYSx2UBeFkom8vlz5EanFk3WvJ4m215+QZ9PvqofvxNth67aWPNr/IgE4WHyqFGW28i731RS8cIBZmv7hfTRqVWlWt/Cdf12qoz7Os8X7/24N/ssX3eVlyXty/1JWAOBoKsOh92pUjxM3Z7fB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=smT3GIi3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="smT3GIi3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00316C4CEF7;
	Mon, 23 Mar 2026 21:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774299618;
	bh=S6fGhE/o2xAfNdt3szTUUCNWsdix3N8psukAcCjJ0Zg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=smT3GIi3+Jbqd6QUuWTEOvybEA1vbL4/vi4hjUF3Nf/DuTEVNW5xkOi8cqZhgDB69
	 9YOxa3ZjSfflmQ8NHV5BT4z+pcO1fskkzGK1DpUlcNdZhyBlQN64gK4u7WHo46RGUK
	 +pdehm7vhHkKbizKj2xGwtbYPBvFWGfStknS+cfbQsvTZs+MRJb8aBS1I5GYfnfQHb
	 n5Uh8uPSYQbzfmrrxA4QkOMTOdEaJG2Zc72sT4/ssX/78gMpiL1nPf7UiTFSP6k9iD
	 6hk6dpHVheJPUHtYtCFN1qnEF8h1qKe8oCkq9ZHWFC9Vs2ZA9sfUfgjGCmBLLucfmz
	 +dfwNZaxkSQCQ==
Date: Mon, 23 Mar 2026 14:00:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Zorro Lang <zlang@redhat.com>,
	linux-xfs@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>,
	axboe@kernel.dk, linux-block@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH] iomap: fix lockdep complaint when reads fail
Message-ID: <20260323210017.GL6223@frogsfrogsfrogs>
References: <20260319194303.efw4wcu7c4idhthz@doltdoltdolt>
 <20260320163444.GE6223@frogsfrogsfrogs>
 <acDbFtQw0mom798e@infradead.org>
 <20260323152231.GG6223@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323152231.GG6223@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

Zorro Lang reported the following lockdep splat:

"While running fstests xfs/556 on kernel 7.0.0-rc4+ (HEAD=04a9f1766954),
a lockdep warning was triggered indicating an inconsistent lock state
for sb->s_type->i_lock_key.

"The deadlock might occur because iomap_read_end_io (called from a
hardware interrupt completion path) invokes fserror_report, which then
calls igrab.  igrab attempts to acquire the i_lock spinlock. However,
the i_lock is frequently acquired in process context with interrupts
enabled. If an interrupt occurs while a process holds the i_lock, and
that interrupt handler calls fserror_report, the system deadlocks.

"I hit this warning several times by running xfs/556 (mostly) or
generic/648 on xfs. More details refer to below console log."

along with this dmesg, for which I've cleaned up the stacktraces:

 run fstests xfs/556 at 2026-03-18 20:05:30
 XFS (sda3): Mounting V5 Filesystem 396e9164-c45a-4e05-be9d-b38c2c5c6477
 XFS (sda3): Ending clean mount
 XFS (sda3): Unmounting Filesystem 396e9164-c45a-4e05-be9d-b38c2c5c6477
 XFS (sda3): Mounting V5 Filesystem bf3f89c3-3c45-4650-a9c7-744f39c0191e
 XFS (sda3): Ending clean mount
 XFS (sda3): Unmounting Filesystem bf3f89c3-3c45-4650-a9c7-744f39c0191e
 XFS (dm-0): Mounting V5 Filesystem bf3f89c3-3c45-4650-a9c7-744f39c0191e
 XFS (dm-0): Ending clean mount
 device-mapper: table: 253:0: adding target device (start sect 209 len 1) caused an alignment inconsistency
 device-mapper: table: 253:0: adding target device (start sect 210 len 62914350) caused an alignment inconsistency
 buffer_io_error: 6 callbacks suppressed
 Buffer I/O error on dev dm-0, logical block 209, async page read
 Buffer I/O error on dev dm-0, logical block 209, async page read
 XFS (dm-0): Unmounting Filesystem bf3f89c3-3c45-4650-a9c7-744f39c0191e
 XFS (dm-0): Mounting V5 Filesystem bf3f89c3-3c45-4650-a9c7-744f39c0191e
 XFS (dm-0): Ending clean mount

 ================================
 WARNING: inconsistent lock state
 7.0.0-rc4+ #1 Tainted: G S      W
 --------------------------------
 inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
 od/2368602 [HC1[1]:SC0[0]:HE0:SE1] takes:
 ff1100069f2b4a98 (&sb->s_type->i_lock_key#31){?.+.}-{3:3}, at: igrab+0x28/0x1a0
 {HARDIRQ-ON-W} state was registered at:
   __lock_acquire+0x40d/0xbd0
   lock_acquire.part.0+0xbd/0x260
   _raw_spin_lock+0x37/0x80
   unlock_new_inode+0x66/0x2a0
   xfs_iget+0x67b/0x7b0 [xfs]
   xfs_mountfs+0xde4/0x1c80 [xfs]
   xfs_fs_fill_super+0xe86/0x17a0 [xfs]
   get_tree_bdev_flags+0x312/0x590
   vfs_get_tree+0x8d/0x2f0
   vfs_cmd_create+0xb2/0x240
   __do_sys_fsconfig+0x3d8/0x9a0
   do_syscall_64+0x13a/0x1520
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
 irq event stamp: 3118
 hardirqs last  enabled at (3117): [<ffffffffb54e4ad8>] _raw_spin_unlock_irq+0x28/0x50
 hardirqs last disabled at (3118): [<ffffffffb54b84c9>] common_interrupt+0x19/0xe0
 softirqs last  enabled at (3040): [<ffffffffb290ca28>] handle_softirqs+0x6b8/0x950
 softirqs last disabled at (3023): [<ffffffffb290ce4d>] __irq_exit_rcu+0xfd/0x250

 other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(&sb->s_type->i_lock_key#31);
   <Interrupt>
     lock(&sb->s_type->i_lock_key#31);

  *** DEADLOCK ***

 1 lock held by od/2368602:
  #0: ff1100069f2b4b58 (&sb->s_type->i_mutex_key#19){++++}-{4:4}, at: xfs_ilock+0x324/0x4b0 [xfs]

 stack backtrace:
 CPU: 15 UID: 0 PID: 2368602 Comm: od Kdump: loaded Tainted: G S      W           7.0.0-rc4+ #1 PREEMPT(full)
 Tainted: [S]=CPU_OUT_OF_SPEC, [W]=WARN
 Hardware name: Dell Inc. PowerEdge R660/0R5JJC, BIOS 2.1.5 03/14/2024
 Call Trace:
  <IRQ>
  dump_stack_lvl+0x6f/0xb0
  print_usage_bug.part.0+0x230/0x2c0
  mark_lock_irq+0x3ce/0x5b0
  mark_lock+0x1cb/0x3d0
  mark_usage+0x109/0x120
  __lock_acquire+0x40d/0xbd0
  lock_acquire.part.0+0xbd/0x260
  _raw_spin_lock+0x37/0x80
  igrab+0x28/0x1a0
  fserror_report+0x127/0x2d0
  iomap_finish_folio_read+0x13c/0x280
  iomap_read_end_io+0x10e/0x2c0
  clone_endio+0x37e/0x780 [dm_mod]
  blk_update_request+0x448/0xf00
  scsi_end_request+0x74/0x750
  scsi_io_completion+0xe9/0x7c0
  _scsih_io_done+0x6ba/0x1ca0 [mpt3sas]
  _base_process_reply_queue+0x249/0x15b0 [mpt3sas]
  _base_interrupt+0x95/0xe0 [mpt3sas]
  __handle_irq_event_percpu+0x1f0/0x780
  handle_irq_event+0xa9/0x1c0
  handle_edge_irq+0x2ef/0x8a0
  __common_interrupt+0xa0/0x170
  common_interrupt+0xb7/0xe0
  </IRQ>
  <TASK>
  asm_common_interrupt+0x26/0x40
 RIP: 0010:_raw_spin_unlock_irq+0x2e/0x50
 Code: 0f 1f 44 00 00 53 48 8b 74 24 08 48 89 fb 48 83 c7 18 e8 b5 73 5e fd 48 89 df e8 ed e2 5e fd e8 08 78 8f fd fb bf 01 00 00 00 <e8> 8d 56 4d fd 65 8b 05 46 d5 1d 03 85 c0 74 06 5b c3 cc cc cc cc
 RSP: 0018:ffa0000027d07538 EFLAGS: 00000206
 RAX: 0000000000000c2d RBX: ffffffffb6614bc8 RCX: 0000000000000080
 RDX: 0000000000000000 RSI: ffffffffb6306a01 RDI: 0000000000000001
 RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
 R10: ffffffffb75efc67 R11: 0000000000000001 R12: ff1100015ada0000
 R13: 0000000000000083 R14: 0000000000000002 R15: ffffffffb6614c10
  folio_wait_bit_common+0x407/0x780
  filemap_update_page+0x8e7/0xbd0
  filemap_get_pages+0x904/0xc50
  filemap_read+0x320/0xc20
  xfs_file_buffered_read+0x2aa/0x380 [xfs]
  xfs_file_read_iter+0x263/0x4a0 [xfs]
  vfs_read+0x6cb/0xb70
  ksys_read+0xf9/0x1d0
  do_syscall_64+0x13a/0x1520

Zorro's diagnosis makes sense, so the solution is to kick the failed
read handling to a workqueue much like we added for writeback ioends in
commit 294f54f849d846 ("fserror: fix lockdep complaint when igrabbing
inode").

Cc: Zorro Lang <zlang@redhat.com>
Link: https://lore.kernel.org/linux-xfs/20260319194303.efw4wcu7c4idhthz@doltdoltdolt/
Fixes: a9d573ee88af98 ("iomap: report file I/O errors to the VFS")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/iomap/bio.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
index fc045f2e4c459e..edd908183058f5 100644
--- a/fs/iomap/bio.c
+++ b/fs/iomap/bio.c
@@ -8,7 +8,10 @@
 #include "internal.h"
 #include "trace.h"
 
-static void iomap_read_end_io(struct bio *bio)
+static DEFINE_SPINLOCK(failed_read_lock);
+static struct bio_list failed_read_list = BIO_EMPTY_LIST;
+
+static void __iomap_read_end_io(struct bio *bio)
 {
 	int error = blk_status_to_errno(bio->bi_status);
 	struct folio_iter fi;
@@ -18,6 +21,52 @@ static void iomap_read_end_io(struct bio *bio)
 	bio_put(bio);
 }
 
+static void
+iomap_fail_reads(
+	struct work_struct	*work)
+{
+	struct bio		*bio;
+	struct bio_list		tmp = BIO_EMPTY_LIST;
+	unsigned long		flags;
+
+	spin_lock_irqsave(&failed_read_lock, flags);
+	bio_list_merge_init(&tmp, &failed_read_list);
+	spin_unlock_irqrestore(&failed_read_lock, flags);
+
+	while ((bio = bio_list_pop(&tmp)) != NULL) {
+		__iomap_read_end_io(bio);
+		cond_resched();
+	}
+}
+
+static DECLARE_WORK(failed_read_work, iomap_fail_reads);
+
+static void iomap_fail_buffered_read(struct bio *bio)
+{
+	unsigned long flags;
+
+	/*
+	 * Bounce I/O errors to a workqueue to avoid nested i_lock acquisitions
+	 * in the fserror code.  The caller no longer owns the bio reference
+	 * after the spinlock drops.
+	 */
+	spin_lock_irqsave(&failed_read_lock, flags);
+	if (bio_list_empty(&failed_read_list))
+		WARN_ON_ONCE(!schedule_work(&failed_read_work));
+	bio_list_add(&failed_read_list, bio);
+	spin_unlock_irqrestore(&failed_read_lock, flags);
+}
+
+static void iomap_read_end_io(struct bio *bio)
+{
+	if (bio->bi_status) {
+		iomap_fail_buffered_read(bio);
+		return;
+	}
+
+	__iomap_read_end_io(bio);
+}
+
 static void iomap_bio_submit_read(struct iomap_read_folio_ctx *ctx)
 {
 	struct bio *bio = ctx->read_ctx;
