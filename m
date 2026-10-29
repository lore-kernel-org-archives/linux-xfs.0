Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793307108;
	b=QWpy6xZFqE4Cwxr23Dqqrcpczk736jddba55eJGU6w029+oxwtNxqSxpGdK13tBcs+zB
	 bI4vSGGs2AxcMX4NfwoGdUm80PfDYLhKaIi+g6EQCEMzR6RtCaI/NKcnTSqv7PCzwFCrr
	 FZPvCv0Wy2Hm24Yg8fTfmbaUxTC2ddeZCeDzbxPm9p4sWjENkRO4F3Jye0KKf98E2C7aS
	 BU8OhVj/p4f8E06dDPnWkRGi71DNSe7xZWpJudG+9MWLoEf/j18AHbYZQbAR8BTXkcmEB
	 M7qKp6S8YN/UJzL1VP2U9P07YvnrOINiLlUc+SFSRRyZdJnRsrBON90LF3bWF5MuwmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793307108;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Score;
	bh=RdeptIPG1aMF2zMuVlv65CiM+a455QAQAz2c9ztPVnw=;
	b=tQkUfIJl+mdNKOaucFGUY9YXUDIYRcyaByh8UFal58IpjsnJLn0ZFAJlLPduIgj+9gAD
	 hzcE1nOq1/P/S1Hv5fALS86umnnltzGbE4CQ/v8PjX/MQK1nkMCV1eLXrfpRw53G8+Bf9
	 TSxDN6guRHuM4g1FzrEy8XkVS4CobJ7hprAFj04FISriP/xVAlDtfxOGPB6+3tz3wxmoh
	 vouZhTB7zNloL2pez0KC6ckLbgGDqb1kDqzGTJyRSVacSsY6nbwmeuRxmnU2FPwQKaVNz
	 gc2t7G+bX5rHzHeYUddh2p4hHtI7IaAFf1mEg7LtH+1rDdrJ293vI53EBbfjWKQex5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=og3qckoP;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=QrS5na9y;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CE2606A322;
	Thu, 29 Oct 2026 20:51:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85CE2606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=og3qckoP;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=QrS5na9y
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6CC2722275;
	Thu, 29 Oct 2026 20:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793307105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RdeptIPG1aMF2zMuVlv65CiM+a455QAQAz2c9ztPVnw=;
	b=og3qckoPEUs84oWLaSyFrTl+bsGq7Qo6i8iwyAfjAIIrAq4Lx4rOPvls7stAZPdUL/AR4Y
	kTu+NpvI/Z6MKmHCLhbsIUU1Au8KVr5UYYVvYuTxUcCv2WFnX8ridjetJlESPXiGvthlCg
	AgmZfBmRJcrQb8Y+HulYqClbZzoHQEE=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793307104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RdeptIPG1aMF2zMuVlv65CiM+a455QAQAz2c9ztPVnw=;
	b=QrS5na9y7Zx9GPCDEbrPsJTjg3i939yEAWaCxqbeyOjnoV3CX8XxtZCDfMqeFVw/+RCI1Y
	8qp49dgTTprajlA1FtsT+MM74v6d5ApB+xcRd1SSrn11Bxn8sPpiBsTEXhTK9zVrIDzkLu
	G8DQwBV3CPuqPrgOfM9w25EuxX2+9mI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5932513419;
	Thu, 29 Oct 2026 20:51:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CMGKKt2x42qmUgAAD6G6ig
	(envelope-from <wqu@suse.com>); Thu, 29 Oct 2026 20:51:42 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: "Pankaj Raghav(Samsung)" <pankaj.raghav@linux.dev>
Subject: [PATCH v4] iomap: only follow dio alignment requirement if specified
Date: Fri, 30 Oct 2026 07:21:23 +1030
Message-ID: <0e89c49b6f7804081f4041007b81ac620a153830.1793307063.git.wqu@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,linux.dev:email];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

After commit 4025185cf953 ("iomap: follow the alignment requirement for
iomap_dio_hole_iter()"), generic/091 fails on both xfs and ext4.

The reason is that ext4 and xfs (except COW write) do not require full
block alignment for direct IO. They are totally fine reading a sub-block
range.

That commit fails any direct read of sub-block holes/prealloc, even those
filesystems can handle it without any problem.

Fix the regression by only follow the block alignment if the
IOMAP_DIO_FSBLOCK_ALIGNED flag is set.

Fixes: 4025185cf953 ("iomap: follow the alignment requirement for iomap_dio_hole_iter()")
Reviewed-by: Pankaj Raghav(Samsung) <pankaj.raghav@linux.dev>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v4:
- Use a shorter commit message to explain the problem.

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

