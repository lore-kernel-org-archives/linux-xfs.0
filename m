Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793143719;
	b=g0lNS2bFJTOSnyGjpPzjRXALVZHQ0rF/9SxFn8V+XddZ0mawqaDK5YrmjFSP9K8w3onF
	 fyYBPbYnzUi0Jwv25VkIdy+sG2PFttT9NacfYoY6CnrCCSnBUP6fqAUo5cdUK6gMHF/9X
	 ExFN54gJ5hFZ+A+v2/kvkoBdcU/TLGgV7GAtuobyroTkpaT5EcoGPX9cfhbxDGai69ymd
	 RYW9V8qI2sglHVZoWgbht46Ov+Bi6Hi3Oq+2IZeVDuAqSeoxl86BKUGix879PKlBSle03
	 EpVHJ0WO4Xywcr1ClL1kFB6/5iAWdHWF2SC8ZR+xUXJkWU1gCQHiHCrlPAPQKfzPNiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793143719;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=+ATlGoOVknM6NwVjn4flzNNb7j2Gcucnj/4DPzZI+ms=;
	b=ja/alO7jrIL4gqWfgObMUgZyhoU4GU5hhfaK7Jg0sfmUaRsF/n5IFeZnmt7acwnR2dgS
	 Do9DjPECpmAp8IEVueW8sbxOWxayI0SvkbHvYZYXHahLx2Ov9KoWhAilxW8nQSFfbUkx/
	 /HodNRsiI605MbRpTCb+fsaRMnYnxfgHZnrU77vy2ignnP38PkY57KLFnMakW5YqkGdaL
	 0OvVbStgF/5E2ueJrUDCZRPG5Cds8dRVW87oRXjhAvLMrVyKsf96Ves/cy1408tGtS+a5
	 JLHcRzIQtlWbBGPt7gduAMdCpvs+xcg5KcmENLeEgLP5EYRIutOxY40KE5QKF8MMQqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=iCPtS522;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=iCPtS522;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13F9606A31A;
	Tue, 27 Oct 2026 23:28:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A13F9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=iCPtS522;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=iCPtS522
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5FF3522002;
	Tue, 27 Oct 2026 23:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793143716; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=+ATlGoOVknM6NwVjn4flzNNb7j2Gcucnj/4DPzZI+ms=;
	b=iCPtS522kANSIt2uEM+Ot9hyESE6ZZHcyNEPz2KXWxyGAJAPlQUCBZs34WAhfHQTDjtrRb
	yFsS/pBhc4u48SqceW80dsiGQ+4jB2cpwWCHg03rczOwUx7iYfFSTYmwNcyAByjncX3ra9
	NNDxrpBqngM5m8UyxU/iS70+MhzR5Dk=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=iCPtS522
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793143716; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=+ATlGoOVknM6NwVjn4flzNNb7j2Gcucnj/4DPzZI+ms=;
	b=iCPtS522kANSIt2uEM+Ot9hyESE6ZZHcyNEPz2KXWxyGAJAPlQUCBZs34WAhfHQTDjtrRb
	yFsS/pBhc4u48SqceW80dsiGQ+4jB2cpwWCHg03rczOwUx7iYfFSTYmwNcyAByjncX3ra9
	NNDxrpBqngM5m8UyxU/iS70+MhzR5Dk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 424D81321C;
	Tue, 27 Oct 2026 23:28:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kCylJKEz4WogMAAAD6G6ig
	(envelope-from <wqu@suse.com>); Tue, 27 Oct 2026 23:28:33 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: "Pankaj Raghav(Samsung)" <pankaj.raghav@linux.dev>
Subject: [PATCH v3] iomap: only follow dio alignment requirement if specified
Date: Wed, 28 Oct 2026 09:58:11 +1030
Message-ID: <1559d839fc32f47db7e8da8c8b2a5ea9b63afb46.1793143679.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 5FF3522002
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
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.com:+]
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

Also update the comment of IOMAP_DIO_FSBLOCK_ALIGNED flag, to indicate
that both bio and hole zeroing are all fs block aligned.

Fixes: 4025185cf953 ("iomap: follow the alignment requirement for iomap_dio_hole_iter()")
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Pankaj Raghav(Samsung) <pankaj.raghav@linux.dev>
---
Changelog:
v3:
- Drop CC: stable
  The commit is only in the v7.4 release cycle, not affecting any stable
  release.

- Add Reviewed-by tag from Pankaj

v2:
- Update the comment of IOMAP_DIO_FSBLOCK_ALIGNED
  To indicate that hole zeroing is also affected.
---
 fs/iomap/direct-io.c  | 26 ++++++++++++++++----------
 include/linux/iomap.h |  3 ++-
 2 files changed, 18 insertions(+), 11 deletions(-)

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
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 59718f73c15a..5254430844b2 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -693,7 +693,8 @@ struct iomap_dio_ops {
 #define IOMAP_DIO_PARTIAL		(1 << 2)
 
 /*
- * Ensure each bio is aligned to fs block size.
+ * Ensure every operation, including bio and hole zeroing, is aligned to fs
+ * block size.
  *
  * For filesystems which need to calculate/verify the checksum of each fs
  * block. Otherwise they may not be able to handle unaligned bios.
-- 
2.56.0

