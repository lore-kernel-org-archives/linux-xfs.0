Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792997327;
	b=O9mrjxGkPhy3PGmzJMrGykCYW7sMlRALZI6Oapip/23BEaFmqi1FKgXqPM3QQiYc/3A+
	 x2p+ZDLjD+wrHvo92BQFLPXRla/4O+PtB7pr49vhEMbr1ab9V/7csL8NOvjU2X6ijhh04
	 3lim7uY6oxeHSto7tzZWlhx/pR4SXttbkQGk/f1BwG7Re7RrCVJZFn0ma9uWWrJkbv12z
	 +cE+5slYf+8598YGCpxSUwNseQ+iSBdcoji+WOcchgg/ZE167CD/2TA6fTdLVAbHtL54M
	 rPIRPSHu2sUkEKB/qzCPHeGHenPJ0r+UeT/oKAC1b1Rlso7u47LpyPUmoIY5s4K/p2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792997327;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=6SYtVd4CVR46l3U3CLp+YsdzpJcvQkabNRi0opV71vI=;
	b=DyYnN1eAxeIOnyeWFuryp/5uW+YHnRsWBEscz3kKvCbHMxYh4/UhE4b0t0lRqE8ZIZwl
	 uf3sYgJbsiKUtp0TaO6+M+BNbsMLVLSAnsJDIyJcgqPrtRiDkXuD6Oec9UvC2TV5gFXI6
	 +zzYTUeVai8+K4CIHQHuE8q4NZXM0dCEsJqUniY3sPZVA2d7rqfnvMkLGhuxR0Lu/toVP
	 IfGrITD3fch/qUu5adMDbPzi89BFErjp7YFOGAFNRl0n2aI63cmr3NMMDGXSUOCOF/2zC
	 YzY96xLVi7QxC7Q8J3ZZSml3WVFrQjal7dcn9qTptZRNDzDZAVcRLPzf8px9+ItBkrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=pB7yboWZ;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=pB7yboWZ;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0585C606A31F;
	Mon, 26 Oct 2026 06:48:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0585C606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=pB7yboWZ;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=pB7yboWZ
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BF3901F453;
	Mon, 26 Oct 2026 06:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792997318; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=6SYtVd4CVR46l3U3CLp+YsdzpJcvQkabNRi0opV71vI=;
	b=pB7yboWZs3AuGtJ3iJiuBeDI7mNR5IXjA++oJYsK5gqF+WSvgnDcK3/rqEHwc5Zl0qFFtx
	GBHUVeQnp0jrpUY3ehabQ+wJdSCYM3fQM+Q1dtVqMOGKdzb9G6l15vflssD4ZVpOaycR1A
	kqR2pBm+009whGEt5b7RCZ5x8Uv7KOY=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=pB7yboWZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792997318; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=6SYtVd4CVR46l3U3CLp+YsdzpJcvQkabNRi0opV71vI=;
	b=pB7yboWZs3AuGtJ3iJiuBeDI7mNR5IXjA++oJYsK5gqF+WSvgnDcK3/rqEHwc5Zl0qFFtx
	GBHUVeQnp0jrpUY3ehabQ+wJdSCYM3fQM+Q1dtVqMOGKdzb9G6l15vflssD4ZVpOaycR1A
	kqR2pBm+009whGEt5b7RCZ5x8Uv7KOY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7027D13408;
	Mon, 26 Oct 2026 06:48:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6flVK8P33mrhTwAAD6G6ig
	(envelope-from <wqu@suse.com>); Mon, 26 Oct 2026 06:48:36 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH] iomap: only follow dio alignment requirement if specified
Date: Mon, 26 Oct 2026 17:18:13 +1030
Message-ID: <9fae60fcce5ae356deef5e38931124b9634dba3b.1792997261.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BF3901F453
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -12.01

[BUG]
After commit 4025185cf953 ("iomap: follow the alignment requirement for
iomap_dio_hole_iter()"), generic/091 fails on both xfs and ext4:

 FSTYP         -- ext4
 PLATFORM      -- Linux/x86_64 btrfs-vm 7.3.0-custom+ #6 SMP PREEMPT_DYNAMIC Mon Oct 26 16:04:56 ACDT 2026
 MKFS_OPTIONS  -- -F /dev/mapper/test-scratch1
 MOUNT_OPTIONS -- -o acl,user_xattr /dev/mapper/test-scratch1 /mnt/scratch

 generic/091  6s ... [failed, exit status 1]- output mismatch (see /home/adam/xfstests/results//generic/091.out.bad)
     --- /home/adam/xfstests/tests/generic/091.out	2022-05-11 11:25:30.766666664 +0930
     +++ /home/adam/xfstests/results//generic/091.out.bad	2026-10-26 16:43:49.387401669 +1030
     @@ -1,7 +1,25 @@
      QA output created by 091
      fsx -N 10000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
     -fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
     -fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
     -fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
     -fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
     -fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -W
     ...
     (Run 'diff -u /home/adam/xfstests/tests/generic/091.out /home/adam/xfstests/results//generic/091.out.bad'  to see the entire diff)
 Ran: generic/091
 Failures: generic/091
 Failed 1 of 1 tests

[CAUSE]
The failed command of fsx is COPY_RANGE:

 copy range: 0x6800 to 0xa200 at 0x3f200
 do_copy_range:: Resource temporarily unavailable
 LOG DUMP (8 total operations):
 1(  1 mod 256): SKIPPED (no operation)
 2(  2 mod 256): SKIPPED (no operation)
 3(  3 mod 256): WRITE    0x14400 thru 0x211ff	(0xce00 bytes) HOLE
 4(  4 mod 256): FALLOC   0x72bf4 thru 0x76221	(0x362d bytes) EXTENDING
 5(  5 mod 256): SKIPPED (no operation)
 6(  6 mod 256): INSERT 0x11000 thru 0x13fff	(0x3000 bytes)
 7(  7 mod 256): TRUNCATE DOWN	from 0x79221 to 0xa800
 8(  8 mod 256): COPY 0x6800 thru 0xa1ff	(0x3a00 bytes) to 0x3f200 thru 0x42bff
 Log of operations saved to "/mnt/test/junk.fsxops"; replay with --replay-ops
 Correct content saved for comparison
 (maybe hexdump "/mnt/test/junk" vs "/mnt/test/junk.fsxgood")

Both ext4 and xfs only require direct IO to be aligned to the logical
block size of the device, not the fs block size. So the 0x3a00 bytes
read at 0x6800 is allowed, and should succeed.

But that range is a hole, and that commit makes iomap_dio_hole_iter()
round the zeroed length down to the fs block size unconditionally.
The first iteration zeroes 0x3a00 bytes but only advances 0x3000 bytes,
then the next iteration zeroes the remaining 0xa00 bytes, which is
rounded down to 0, so -EFAULT is returned.

As ext4 and xfs do not pass IOMAP_DIO_PARTIAL, the whole read fails
with -EFAULT, which is then converted to -EAGAIN by copy_splice_read().
Every retry of fsx hits the same -EAGAIN, failing the run.

That commit breaks all direct reads which range is not fs block aligned
for ext4 and xfs.

[FIX]
Do not revert the range unless the dio has IOMAP_DIO_FSBLOCK_ALIGNED flag.

iomap_dio_hole_iter() is only called for reads, and for now only btrfs
reads can reach this path with the flag set. Btrfs has the proper
fallback when dio returns -EFAULT.

Fixes: 4025185cf953 ("iomap: follow the alignment requirement for iomap_dio_hole_iter()")
Cc: stable@vger.kernel.org
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/iomap/direct-io.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 45bb24934f3d..ad041ac3252a 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -590,18 +590,24 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 static int iomap_dio_hole_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 {
 	loff_t copied = iov_iter_zero(iomap_length(iter), dio->submit.iter);
-	unsigned int bs = i_blocksize(iter->inode);
-	loff_t aligned_copied = round_down(copied, bs);
 
-	/*
-	 * If fs block size is larger than page size, page fault failure
-	 * can cause @copied to be page aligned but not fs block aligned.
-	 */
-	iov_iter_revert(dio->submit.iter, copied - aligned_copied);
-	dio->size += aligned_copied;
-	if (!aligned_copied)
+	if (dio->flags & IOMAP_DIO_FSBLOCK_ALIGNED) {
+		loff_t aligned_copied = round_down(copied,
+						   i_blocksize(iter->inode));
+
+		/*
+		 * For fs passing IOMAP_DIO_FSBLOCK_ALIGNED flag, if fs block
+		 * size is larger than page size, page fault failure
+		 * can cause @copied to be page aligned but not fs block
+		 * aligned.
+		 */
+		iov_iter_revert(dio->submit.iter, copied - aligned_copied);
+		copied = aligned_copied;
+	}
+	dio->size += copied;
+	if (!copied)
 		return -EFAULT;
-	return iomap_iter_advance(iter, aligned_copied);
+	return iomap_iter_advance(iter, copied);
 }
 
 static int iomap_dio_inline_iter(struct iomap_iter *iomi, struct iomap_dio *dio)
-- 
2.56.0

