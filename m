Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18403EFD1F
	for <linux-xfs@vger.kernel.org>; Tue,  4 Aug 2026 22:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785880823; cv=none; b=ls2M4faYce2t+y8HRdpAiZ4IUi/eo4t31ZqUABHNEp+BjqWF5SfE60YCxcFBADhu60nWeINMa9l8Hn7eHo3vbHn5JYVH2OpKD2LqO1p4/jCX0NcrL2B+Gt3Y82xY9HRlJ7htQthmkg7RTDqg3lEMtRNJanilMrIGan9fAZthx+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785880823; c=relaxed/simple;
	bh=lzImomLB7VcX1QeNR35stZa/tXhzCK8N/aUXG4r7ZJs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=CzOGi8Teo4BoByN++NV9+ClKfOz7Ql6ZBN1qUzuIHmSH4w1uPVx0/p/mxlWzp5OyN6j+Sfs3HyinWSIyknZ6dcORPLQ12K7t0dY9ZnR2i9kKLU2PCjX4zdCR0tNyN7MT3xSz6bl9S0tKfDKzx+yeZ/abYt2EbquE+9nA8hRe5qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=n2Po/aWo; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=rJAdjibk; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="n2Po/aWo";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="rJAdjibk"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C108B3E72;
	Tue,  4 Aug 2026 22:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785880814; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OlCA0AGAOld1JWr3xa6FuQqbEH3KeaqUp8HFeYuYznw=;
	b=n2Po/aWosnrx8yFT0YZwc0v0hJvougP64pKgI3ZTG+F1V5is1iNn7T5+7suxck2gmemYUk
	C54S+685LjQfFSVvjhJKlGR/VS0yB+xtGznJXpe1fmhgkJwMTKm1vfhpe4H1HPxhbuptt8
	CjZ50Umg+f7JWqHhHqD2lfDaU9fmfPg=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785880810; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OlCA0AGAOld1JWr3xa6FuQqbEH3KeaqUp8HFeYuYznw=;
	b=rJAdjibkmNANWmAj/bWVawAzhBhtXJQDXPY+6N7r5C9e+m+fFs5fGSVk72RdI6DAw3CzHh
	/trktgoYnCa+D9W9NR0Z3fg1KRopkCQGDlVobPtVhx2sBj7RqfK0VP71Cy0EmvV2LqUAss
	Xw047rZR5UoJG/81fA1vysOAJ6V/g0g=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 82C27779BB;
	Tue,  4 Aug 2026 22:00:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id e1EBEelgcmphegAAD6G6ig
	(envelope-from <wqu@suse.com>); Tue, 04 Aug 2026 22:00:09 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v4] iomap: follow the alignment requirement for iomap_dio_hole_iter()
Date: Wed,  5 Aug 2026 07:29:51 +0930
Message-ID: <73bd4d9b39e821453028ca8e567eaad2ebe0fc18.1785880740.git.wqu@suse.com>
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
	NEURAL_HAM_SHORT(-0.20)[-0.991];
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
v4:
- Always align down to fs block size

v3:
- Fix a NULL pointer dereference where @bdev can be NULL for holes

v2:
- Rebased to the latest vfs tree

- Slightly rewords the reproducer
  In fact no special reproducer needed, any test case running fsstress
  can easily trigger it.

  The example provided is just the shortest sequence I used to debug the
  crash.
---
 fs/iomap/direct-io.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index b3368d64e81b..01f26fb3b3b2 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -594,12 +594,19 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 
 static int iomap_dio_hole_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 {
-	loff_t length = iov_iter_zero(iomap_length(iter), dio->submit.iter);
+	loff_t copied = iov_iter_zero(iomap_length(iter), dio->submit.iter);
+	unsigned int bs = i_blocksize(iter->inode);
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

