Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEC834A799
	for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 01:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785374562; cv=none; b=h/8JrqFwk0m6181zEduqrV2aihvaGeA2r3iKa3i+eVcdwvWrimRfz3eEhfJdj0hCtiFoAClhGqh+yOvw3TAYz0g/bYTrJXmOxgqHfCD3Lp2ZoAi/I0zWFRCzAFRb8x32K1+DRKS0J6QwItE2JdpM/oMxGdgLuGp4fmyjxPGeSwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785374562; c=relaxed/simple;
	bh=/4qAEzUQBFKLtCXPBStUoJsGxRzkUMLWb4q0GwsVhfo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=u6XLArNfJ6nhXzcj1z3D3ugPeL1ACXvPh1XjJnSZY5ZDXGTXG6UucmMYD1JBbbiTGlZjIXTnwBQqQtrtGEyWVBtY12USJp3t1OEJj4+nJ7tS/5Kdy1cvebXcsj8yTj8WUUUdGcK+5i1BtZIIpB8d7XT0tT0kWtRCYqmbP2sSJlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=glFDgoi0; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=SI6JH9Oa; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="glFDgoi0";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="SI6JH9Oa"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7D0EE7CD71;
	Thu, 30 Jul 2026 01:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785374554; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Nv/Vy1FGQZPL9hLmzLnXj02eJ10QS/d3Ra28Ulno1rs=;
	b=glFDgoi0Jx+XW7v9VHXxv+6xeGMJr7Zmv4Wn7iPHw4fXemV5WY2Z/CmMTsfrwKK19Id0AA
	zRzQIDkQAnm//88b9EGz7OZ7U8gQ2eOgGD+h6QzayXLt9ebFsrp/9w1t+j61rk8E4YSEEi
	wIb8TqDEThfJQm7NcaEKWrji/89NsqQ=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785374550; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Nv/Vy1FGQZPL9hLmzLnXj02eJ10QS/d3Ra28Ulno1rs=;
	b=SI6JH9Oab6t8pZGQcBAbPuInI+ppgQ1Zbvfw0BrlQgeV9ChdjPo9zWH3Sg8q7ZsoH1fgLd
	r1sa1EAqeOtucQe02E+Ptk9/15gKuzNraKAE77D48z5hhaIgr5DZD2DX527T+etCUXvoLm
	LgXB+f5kZajxPETd6/N9hrTwqK8gEsk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D974E779CC;
	Thu, 30 Jul 2026 01:22:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1+rhIVSnamquJgAAD6G6ig
	(envelope-from <wqu@suse.com>); Thu, 30 Jul 2026 01:22:28 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] iomap: follow the alignment requirement for iomap_dio_hole_iter()
Date: Thu, 30 Jul 2026 10:52:10 +0930
Message-ID: <e69cc8a4a9c3f641b97872b50f04c397880077cd.1785374485.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[]

[BUG]
On the latest development branch, btrfs with 8K block size on 4K page
sized systems will fail the following fsstress workload:

 # $fsstress -n 4 -d $mnt -s 1785675805 -v
 0/0: dwrite - no filename
 0/1: creat f0 x:0 0 0
 0/1: creat add id=0,parent=-1
 0/2: write dontcache f0[259 1 0 0 0 0] [816411,3620] 0
 0/3: dread - xfsctl(XFS_IOC_DIOINFO) f0[259 1 0 0 32 820031] return 25, fallback to stat()
 0/3: dread f0[259 1 0 0 32 820031] [483328,81920] 0

Which triggered the following ASSERT():

 assertion failed: IS_ALIGNED(state->start, blocksize) && IS_ALIGNED(state->end + 1, blocksize), in fs/btrfs/extent-io-tree.c:346 (unaligned extent state, blocksize=8192 start=487424 end=565247 state=0x0)
 ------------[ cut here ]------------
 kernel BUG at fs/btrfs/extent-io-tree.c:346!
 Oops: invalid opcode: 0000 [#1] SMP
 CPU: 4 UID: 0 PID: 648 Comm: fsstress Tainted: G            E       7.2.0-rc5-custom+ #431 PREEMPT(full)  7c507bd40d65e4d871e698b22d80f1306bbec543
 Tainted: [E]=UNSIGNED_MODULE
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2022
 RIP: 0010:validate_extent_state.part.0.isra.0.cold+0x24/0x26 [btrfs]
 Call Trace:
  <TASK>
  insert_state+0x34/0x1a0 [btrfs 6924944583e4bc91a7c5183a1e7908e745a9b0c8]
  set_extent_bit+0x440/0x8d0 [btrfs 6924944583e4bc91a7c5183a1e7908e745a9b0c8]
  btrfs_lock_extent_bits+0x58/0x380 [btrfs 6924944583e4bc91a7c5183a1e7908e745a9b0c8]
  btrfs_dio_iomap_begin+0x319/0xb70 [btrfs 6924944583e4bc91a7c5183a1e7908e745a9b0c8]
  iomap_iter+0x1a2/0x370
  __iomap_dio_rw+0x236/0x8d0
  iomap_dio_rw+0x12/0x30
  btrfs_direct_read+0x15f/0x290 [btrfs 6924944583e4bc91a7c5183a1e7908e745a9b0c8]
  btrfs_file_read_iter+0x42/0x90 [btrfs 6924944583e4bc91a7c5183a1e7908e745a9b0c8]
  vfs_read+0x25e/0x380
  ksys_read+0x73/0xe0
  do_syscall_64+0xe1/0x790
  entry_SYSCALL_64_after_hwframe+0x4b/0x53
 RIP: 0033:0x7fc3f129318e
  </TASK>

[CAUSE]
Btrfs has recently introduced more strict extent_state alignment checks,
which means functions like btrfs_lock_extent() will require the range
to be block size aligned.

But in the above workload, iomap_dio_hole_iter() only zeroed 4K, then
hit a page fault. In that case the iov_iter is still advanced 4K bytes,
then btrfs_dio_iomap_begin() is called for the remaining range, which is
no longer block size (8K) aligned, triggering the ASSERT().

This shows that, although iomap_dio_bio_iter() is properly respecting
the alignment requirement, iomap_dio_hole_iter() is not doing the same
thing.

[FIX]
Extract a helper, iomap_dio_alignment(), to calculate the alignment first.

Then for iomap_dio_hole_iter() round down the copied length, and revert
any excessive range that is beyond the aligned copied length.
Also use @aligned_copied for the size increment and iter advancement.

Fixes: 001397f5ef49 ("iomap: add IOMAP_DIO_FSBLOCK_ALIGNED flag")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/iomap/direct-io.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index e2cd5f92babe..94747963cb1f 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -403,6 +403,18 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
 	return ret;
 }
 
+/*
+ * File systems that write out of place and always allocate new blocks
+ * need each bio to be block aligned as that's the unit of allocation.
+ */
+static unsigned int iomap_dio_alignment(const struct iomap_iter *iter,
+					const struct iomap_dio *dio)
+{
+	if (dio->flags & IOMAP_DIO_FSBLOCK_ALIGNED)
+		return i_blocksize(iter->inode);
+	return bdev_logical_block_size(iter->iomap.bdev);
+}
+
 static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 {
 	const struct iomap *iomap = &iter->iomap;
@@ -414,18 +426,9 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 	bool need_zeroout = false;
 	u64 copied = 0;
 	size_t orig_count;
-	unsigned int alignment;
+	const unsigned int alignment = iomap_dio_alignment(iter, dio);
 	ssize_t ret = 0;
 
-	/*
-	 * File systems that write out of place and always allocate new blocks
-	 * need each bio to be block aligned as that's the unit of allocation.
-	 */
-	if (dio->flags & IOMAP_DIO_FSBLOCK_ALIGNED)
-		alignment = fs_block_size;
-	else
-		alignment = bdev_logical_block_size(iomap->bdev);
-
 	if ((pos | length) & (alignment - 1))
 		return -EINVAL;
 
@@ -588,12 +591,15 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 
 static int iomap_dio_hole_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 {
-	loff_t length = iov_iter_zero(iomap_length(iter), dio->submit.iter);
+	loff_t copied = iov_iter_zero(iomap_length(iter), dio->submit.iter);
+	const unsigned int alignment = iomap_dio_alignment(iter, dio);
+	const loff_t aligned_copied = round_down(copied, alignment);
 
-	dio->size += length;
-	if (!length)
+	iov_iter_revert(dio->submit.iter, copied - aligned_copied);
+	dio->size += aligned_copied;
+	if (!aligned_copied)
 		return -EFAULT;
-	return iomap_iter_advance(iter, length);
+	return iomap_iter_advance(iter, aligned_copied);
 }
 
 static int iomap_dio_inline_iter(struct iomap_iter *iomi, struct iomap_dio *dio)
-- 
2.54.0

