Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5D6386453
	for <linux-xfs@vger.kernel.org>; Fri, 31 Jul 2026 09:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785489113; cv=none; b=aN84lNaV3/QscMY30n9SUOO7PiezLVjqd96y3/hKPLxcftFHpunRcsj6ZPmBjMENpACAy9Uk6jArHZwVm/3xfjkC0pEMYH+Mu1ItKGYktzV/BIuLBdyHSF8ymc/0kbQVNx4+yQOLmN9+xRpVyNhypqC1nkJC4BWmRCsoJqU1WdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785489113; c=relaxed/simple;
	bh=EXDgL32CU8+11JRWs2p8ED9vG88KYSWEcXRA6aX/piU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=XFRyJO1Tia0LBNmpreJlrhRh9o2liHSGrmeA+QNcZmNi8stKfDBr9xzT6FeUw7oic7gBYvjBvpcJhhQVV0G+Q7yWe/mhmceyk21bjsBZtR//FP5SKamQhA5SioFdrTVLMMLXZyYBYy6+TUVnqMDlcq3WkV7d9JJJJblDbJ4zqBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nNiivWOZ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=BaN1pOX9; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nNiivWOZ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="BaN1pOX9"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4498F7DE71;
	Fri, 31 Jul 2026 09:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785489106; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ZWmVuvs2r9X/ORunpHEg56gXXQpdK5iG70eQZZEdo5Q=;
	b=nNiivWOZx538Meu+S9TbzgjqQDnJ6LF4NpzXd1mO6qbvn6OpsDkGSdg7w3E3izBbikCSHc
	KCXxaUx2EaCaalUFFPR7/30t+IYbPZAPuf93PEBTkJfI4rF6jXXP6rCE/5EHOxQIVbLJ4f
	48ZWFdFJIpiYO+T0mmBZSdNAVoX50Io=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=BaN1pOX9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785489102; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ZWmVuvs2r9X/ORunpHEg56gXXQpdK5iG70eQZZEdo5Q=;
	b=BaN1pOX9Q7KAOHotOFS9SsvJw13kSoOZ9BKZcAqGLoh9CRfT8JyUpvS2hVIcAIs+Qxg5iM
	9iS2eQrr28Bva3BkR11H2rhE++1BJuNrTfFV/UIQgNVJsl9KM6dtHIIszG+Ks2twNmdymJ
	ky3NN/hdb2KwLb507hdh18HJCvtO7Pw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A54C3779B0;
	Fri, 31 Jul 2026 09:11:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Nr5uFcxmbGojRAAAD6G6ig
	(envelope-from <wqu@suse.com>); Fri, 31 Jul 2026 09:11:40 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v2] iomap: follow the alignment requirement for iomap_dio_hole_iter()
Date: Fri, 31 Jul 2026 18:41:14 +0930
Message-ID: <9209e7204fc6b7b60c28f196750084be8a2faba8.1785489008.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 4498F7DE71
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_NONE(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:mid,suse.com:email,suse.com:dkim];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

[BUG]
On the latest development branch, btrfs with 8K block size on 4K page
sized systems will fail all test cases that run fsstress.

One very short example would be:

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
iomap_dio_hole_iter() is responsible for zeroing out the buffer for a
hole, which calls iov_iter_zero() to zero the range.

However btrfs disables page fault during its __iomap_dio_rw() call, so
iov_iter_zero() can fail at any page boundary.

When the fs block size is larger than page size, iov_iter_zero() may
only have zeroed one page, which is not aligned to the fs block size.

Such one page long range is passed back to btrfs, which triggers the
above ASSERT().

[FIX]
For iomap_dio_hole_iter() round down the copied length, and revert
any excessive range that is beyond the aligned copied length.
Also use @aligned_copied for the size increment and iter advancement.

This should only affect btrfs, which is the only fs utilizing iomap dio
with page fault disabled.

Fixes: 001397f5ef49 ("iomap: add IOMAP_DIO_FSBLOCK_ALIGNED flag")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
- Rebased to the latest vfs tree

- Slightly rewords the reproducer
  In fact no special reproducer needed, any test case running fsstress
  can easily trigger it.

  The example provided is just the shortest sequence I used to debug the
  crash.
---
 fs/iomap/direct-io.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 64c6b7286c20..f170976d9de0 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -594,12 +594,20 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 
 static int iomap_dio_hole_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 {
-	loff_t length = iov_iter_zero(iomap_length(iter), dio->submit.iter);
+	loff_t copied = iov_iter_zero(iomap_length(iter), dio->submit.iter);
+	unsigned int bs = iomap_dio_alignment(iter->inode, iter->iomap.bdev,
+					      dio->flags);
+	loff_t aligned_copied = round_down(copied, bs);
 
-	dio->size += length;
-	if (!length)
+	/*
+	 * If fs block size is larger than page size, page fault failure
+	 * can cause @copied to be page aligned but not fs block aligned.
+	 */
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

