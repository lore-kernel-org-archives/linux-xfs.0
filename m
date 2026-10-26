Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793050585;
	b=xUHw6lOUVOmwuVoSq6zsE8LVY9VIXAqmRDxsQVw24ehPqUGYW1YXRGbeMJLdTYZz0Ndi
	 HJ+DdGvvnIKLcTsCRwMfP1EvQRF5qpaI3oMu1hclfY0gz17vPIglIE8pyg2FgtqXh8b0r
	 jh90Xb1tE9/Z/U/M2eVFi0GgSXVn/1DFDOrQKHBl6NTTaU4w6GDIgx93/RpKNEGmJpRsO
	 USCRmn4pU1eHXk/w/WoINpMmYp2SAfv2yummCsSh2cPcapCQGRFhWZgi/q7aRr7LEt1p3
	 s9S4k9OjFA6tsK6nvHmuCg+nER2x56/y1zmK8JbJpB0UdYn7qo8sh93YOcPPWmkuy7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793050585;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Score;
	bh=h4TtMxiD7qIIu9haOuhPNclvY/+UQ3UGNUpsBEbNloQ=;
	b=Irs4J/MrNAvjhHwLm6sTG2s5KogXU890rYGXLl+07KGxTPPMm/Z+qmvaMUmybvLEdXnV
	 eh3BrtJVddoGb+elY2MfUOCkfrw8aWZY8wh/lJU87s92iNiMU76P3vuCDmOsWVgZn9onH
	 7FIqLwNHKH656ztKuwr09zRs2h7Y+rEL7yPe7tG879Ll7HtO2SmRMJPcq81hxmS6D4rEU
	 5f5V/KLvJ08n7jSZj2qYEydBzLy3HMNmGrVLAIABpLHPwFMrNR+BwD2q7xZqsVOSdCxZx
	 BVaVLkpSLTWnOMoIxcxnX4w+Zx8NZlymJnNVvq3CATzmjO7DiGNapbX1YFeoDz0HLpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=bUscyYxT;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=CtlJPjFD;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C26606A327;
	Mon, 26 Oct 2026 21:36:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4C26606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=bUscyYxT;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=CtlJPjFD
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 519E11F387;
	Mon, 26 Oct 2026 21:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793050580; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=h4TtMxiD7qIIu9haOuhPNclvY/+UQ3UGNUpsBEbNloQ=;
	b=bUscyYxTzRHt7QzisXqdXlxQUubRjiOUGOidOft0pS+MW5uKQpOzP97RW1o9ZvAu0mrLSL
	UkNv7f4VGOeLWWU9116tuM5kvC57BVLgh1xpXFIwnFpaikH0J8zpCcuKxJVp4Wck964Ff1
	jtT18Lw6jtTCKd3mXSfU+x1aTc/vrkU=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793050579; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=h4TtMxiD7qIIu9haOuhPNclvY/+UQ3UGNUpsBEbNloQ=;
	b=CtlJPjFDCyd41j9BThmW9qsY23WmTQboRN+liXN7lS6xSvKvQM9D9qNCFj+n+zDsNmz3kx
	urv7G3eSGrDb/GjU+VJwvIMNwMd9lk3sV2+2UHASugLYSplWmRuIqJjzISZsdFVBrmQlxg
	UOFCiTMXtLC+05jKSraiTeafvUixCdU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 34A8E13408;
	Mon, 26 Oct 2026 21:36:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9xdpIdDH32qmdQAAD6G6ig
	(envelope-from <wqu@suse.com>); Mon, 26 Oct 2026 21:36:16 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH v2] iomap: only follow dio alignment requirement if specified
Date: Tue, 27 Oct 2026 08:05:58 +1030
Message-ID: <28b1681495dc0b46d8bf98364e471be9f4eb0ba4.1793050525.git.wqu@suse.com>
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
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

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
Cc: stable@vger.kernel.org
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
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

