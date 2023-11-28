Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E876B0
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 07:38:13 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 044DF227A87; Tue, 28 Nov 2023 16:38:09 +0100 (CET)
Date: Tue, 28 Nov 2023 16:38:08 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: XBF_DONE semantics
Message-ID: <20231128153808.GA19360@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)

Hi Darrick,

while reviewing your online repair series I've noticed that the new
xfs_buf_delwri_queue_here helper sets XBF_DONE in addition to waiting
for the buffer to go off a delwri list, and that reminded me off an
assert I saw during my allocator experiments, where
xfs_trans_read_buf_map or xfs_buf_reverify trip on a buffer that doesn't
have XBF_DONE set because it comes from an ifree transaction (see
my current not fully thought out bandaid below).

The way we currently set and check XBF_DONE seems a bit undefined.  The
one clear use case is that read uses it to see if a buffer was read in.
But places that use buf_get and manually fill in data only use it in a
few cases.  Do we need to define clear semantics for it?  Or maybe
replace with an XBF_READ_DONE flag for that main read use case and
then think what do do with the rest?

---
From 80d148555ca261777ad728455a9a240e0007f54e Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Mon, 13 Nov 2023 12:02:15 -0500
Subject: xfs: remove the XBF_DONE asserts in xfs_buf_reverify and
 xfs_trans_read_buf_map

When xfs_trans_read_buf_map is called from xfs_inode_item_precommit
through xfs_imap_to_bp, we can find an inode buffer that doesn't have
XBF_DONE because xfs_ifree_cluster doesn't read the buffer but instead
just gets it before marking all buffers stale.

[  206.728129] ------------[ cut here ]------------
[  206.728573] WARNING: CPU: 0 PID: 6320 at fs/xfs/xfs_trans_buf.c:256 xfs_trans_read_buf_map+0x20
[  206.728971] Modules linked in:
[  206.729099] CPU: 0 PID: 6320 Comm: kworker/0:124 Not tainted 6.6.0+ #1598
[  206.729368] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 044
[  206.729744] Workqueue: xfs-inodegc/nvme1n1 xfs_inodegc_worker
[  206.729984] RIP: 0010:xfs_trans_read_buf_map+0x2ab/0x570
[  206.730295] Code: 0f 84 ae fe ff ff b9 4e 01 00 00 48 c7 c6 c8 62 0d 83 48 c7 c2 a5 15 ff 82 3d
[  206.731131] RSP: 0018:ffffc9000751fc38 EFLAGS: 00010246
[  206.731414] RAX: 0000000002110040 RBX: ffff88824c47dbd8 RCX: 0000000000000000
[  206.731748] RDX: ffff88824c47dc90 RSI: 0000000000000000 RDI: ffff8881705b46c0
[  206.732139] RBP: ffffc9000751fca8 R08: ffff888106416e00 R09: ffffc9000751fca8
[  206.732428] R10: ffff8881e09faa00 R11: ffff8881e09fb408 R12: 0000000000000001
[  206.732786] R13: ffff88810ddb2000 R14: ffffffff82b36660 R15: ffffc9000751fcf0
[  206.733092] FS:  0000000000000000(0000) GS:ffff888277c00000(0000) knlGS:0000000000000000
[  206.733460] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  206.733797] CR2: 00007f9833f399c0 CR3: 00000002113de000 CR4: 0000000000750ef0
[  206.734131] PKRU: 55555554
[  206.734320] Call Trace:
[  206.734438]  <TASK>
[  206.734537]  ? xfs_trans_read_buf_map+0x2ab/0x570
[  206.734824]  ? __warn+0x80/0x170
[  206.735051]  ? xfs_trans_read_buf_map+0x2ab/0x570
[  206.735342]  ? report_bug+0x18d/0x1c0
[  206.735533]  ? handle_bug+0x41/0x70
[  206.735679]  ? exc_invalid_op+0x17/0x60
[  206.735852]  ? asm_exc_invalid_op+0x1a/0x20
[  206.736054]  ? xfs_trans_read_buf_map+0x2ab/0x570
[  206.736262]  ? xfs_trans_read_buf_map+0x6b/0x570
[  206.736500]  xfs_imap_to_bp+0x60/0xc0
[  206.736668]  xfs_inode_item_precommit+0x172/0x2a0
[  206.736947]  ? xfs_iunlink_item_precommit+0xae/0x220
[  206.737191]  xfs_trans_run_precommits+0x60/0xc0
[  206.737460]  __xfs_trans_commit+0x67/0x3a0
[  206.737668]  xfs_inactive_ifree+0xfb/0x1f0
[  206.737889]  xfs_inactive+0x22f/0x420
[  206.738059]  xfs_inodegc_worker+0xa3/0x200
[  206.738227]  ? process_one_work+0x171/0x4a0
[  206.738450]  process_one_work+0x1d8/0x4a0
[  206.738651]  worker_thread+0x1ce/0x3b0
[  206.738864]  ? wq_sysfs_prep_attrs+0x90/0x90
[  206.739074]  kthread+0xf2/0x120
[  206.739216]  ? kthread_complete_and_exit+0x20/0x20
[  206.739482]  ret_from_fork+0x2c/0x40
[  206.739675]  ? kthread_complete_and_exit+0x20/0x20
[  206.740074]  ret_from_fork_asm+0x11/0x20
[  206.740402]  </TASK>

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c       | 1 -
 fs/xfs/xfs_trans_buf.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9bf79172efc824..4ff9f1b1abb698 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -863,7 +863,6 @@ xfs_buf_reverify(
 	struct xfs_buf		*bp,
 	const struct xfs_buf_ops *ops)
 {
-	ASSERT(bp->b_flags & XBF_DONE);
 	ASSERT(bp->b_error == 0);
 
 	if (!ops || bp->b_ops)
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 8e886ecfd69a3b..575922c64d4d3a 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -253,7 +253,6 @@ xfs_trans_read_buf_map(
 		ASSERT(bp->b_transp == tp);
 		ASSERT(bp->b_log_item != NULL);
 		ASSERT(!bp->b_error);
-		ASSERT(bp->b_flags & XBF_DONE);
 
 		/*
 		 * We never locked this buf ourselves, so we shouldn't
-- 
2.39.2

