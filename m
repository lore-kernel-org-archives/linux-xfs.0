Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E023B4E83
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 08:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781597589; cv=none; b=PcxbOiv7xe2d8fIBUhbX9UT/M9iaYPe/skvFrxqzWZwNeyAE6iQP2/4yXWSuYc4+YT6veUawFbRsqvPTI1XJxaVwHd9Co3bzhRQC2E/apr0teO+MOp6NFSbafc7Pr0UeKjKAv1/Ap0PfsrJ+b+vgr61CfgABdZiUrm2svZPYkXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781597589; c=relaxed/simple;
	bh=asmNYBjowFPg6CyA5JI9bVNtTb46SjMHa7Ne4MK5H9Q=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q6RJgK7Ee4EGKDCeTUzldYf1ebTJnTTbYAoDkFvOeEpJoZTZZeXHxwuZK9OPxnjoC04IhjwTCyLF0eV3jbHYegBV+k62bQSpRuqrGPT5c81sXUuzAZrHXF0puh6JlH9x/Yzh/sT3QvSuHApmYHbVK5IQCBF14566OsfzhEmlmNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RWzr/u7L; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RWzr/u7L; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RWzr/u7L";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RWzr/u7L"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 27BEF7607B;
	Tue, 16 Jun 2026 08:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781597586; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IcrU7lQtCwNtqDVJ11P7GocSwgPwPYOLdQTj/eQMsOw=;
	b=RWzr/u7LjunJVK7ZogNZ6iyAT/nPqp5HGr6r1ncELExrS4ZBDB+n0IJZ8DCVU9evtz0/DD
	QWn3k9JGfAM32a3CIPARLFc5iFf+2Rd8GZ2r6gcI5TQRfq3L9X5+lQ9bS+hvNzZNF3lI1D
	Z2GIz6y/pyoZN25R2zD620Xe5Ak7O1k=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="RWzr/u7L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781597586; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IcrU7lQtCwNtqDVJ11P7GocSwgPwPYOLdQTj/eQMsOw=;
	b=RWzr/u7LjunJVK7ZogNZ6iyAT/nPqp5HGr6r1ncELExrS4ZBDB+n0IJZ8DCVU9evtz0/DD
	QWn3k9JGfAM32a3CIPARLFc5iFf+2Rd8GZ2r6gcI5TQRfq3L9X5+lQ9bS+hvNzZNF3lI1D
	Z2GIz6y/pyoZN25R2zD620Xe5Ak7O1k=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2B67A779A8;
	Tue, 16 Jun 2026 08:13:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yCG2Mo8FMWrWawAAD6G6ig
	(envelope-from <wqu@suse.com>); Tue, 16 Jun 2026 08:13:03 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v4 3/3] btrfs: use IOMAP_DIO_BOUNCE flag instead of falling back to buffered IO
Date: Tue, 16 Jun 2026 17:42:37 +0930
Message-ID: <1a89047dac91b6b12d190c37cd7bb3d8328b2073.1781597506.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1781597506.git.wqu@suse.com>
References: <cover.1781597506.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 27BEF7607B
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

Previously btrfs forces direct writes to fall back to buffered ones if the
inode has data checksum or the profile has duplication.

That fallback is to avoid the content being modified that the final
content may mismatch with the checksum or the other mirrors.

That brings a pretty huge performance cost, which already caused some
concern at that time.

But later upstream commit c9d114846b38 ("iomap: add a flag to bounce
buffer direct I/O") introduced a new method by copying the content into
new pages, and do all the operations based on the newly allocated pages.

So let btrfs to utilize the new flag for direct writes if we require
stable folios.

There is a quick benchmark, using the following fio setup:

 fio --name=randwrite --filename $mnt/foobar --ioengine=libaio --size=4G \
     --rw=randwrite --iodepth=64 --runtime=60 --time_based --direct=1 \
     --bs=$blocksize

Unit is MiB/s.

 Blocksize | Zero-copy (*) | Buffered |   Bounce
-----------+---------------+----------+-----------
        4K |          35.1 |     17.1 |      33.8
       64K |           522 |      251 |       492

*: This is done by reverting the commit 968f19c5b1b7 ("btrfs: always
   fallback to buffered write if the inode requires checksum")

Although with page bouncing the performance is only around 95% of
true-zero copy, it's still almost double the performance of buffered
fallback.

There will be a small change in behavior, since we're using
IOMAP_DIO_BOUNCE flag to allocate new folios, NOWAIT flag will
immediately fail.

So for true NOWAIT direct IOs, NODATASUM and RAID0/SINGLE profiles are
still required.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/direct-io.c | 58 ++++++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index e566a60b0ce5..bb457649902e 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -818,13 +818,41 @@ static ssize_t btrfs_dio_read(struct kiocb *iocb, struct iov_iter *iter,
 			    IOMAP_DIO_PARTIAL | IOMAP_DIO_FSBLOCK_ALIGNED, &data, done_before);
 }
 
+static bool need_stable_write(struct btrfs_inode *inode)
+{
+	const u64 data_profile = btrfs_data_alloc_profile(inode->root->fs_info) &
+				 BTRFS_BLOCK_GROUP_PROFILE_MASK;
+
+	/* Data checksum requires stable buffer. */
+	if (!(inode->flags & BTRFS_INODE_NODATASUM))
+		return true;
+	/*
+	 * Any profile with mirror/parity will require stable buffer.
+	 * Otherwise the mirror may differ from each other.
+	 *
+	 * Thus only SINGLE and RAID0 doesn't require stable buffer.
+	 */
+	if (data_profile != 0 && data_profile != BTRFS_BLOCK_GROUP_RAID0)
+		return true;
+	return false;
+}
+
 static struct iomap_dio *btrfs_dio_write(struct kiocb *iocb, struct iov_iter *iter,
 					 size_t done_before)
 {
 	struct btrfs_dio_data data = { 0 };
+	unsigned int dio_flags = IOMAP_DIO_PARTIAL | IOMAP_DIO_FSBLOCK_ALIGNED;
+
+	if (need_stable_write(BTRFS_I(file_inode(iocb->ki_filp)))) {
+		/* For now no support for BOUNCE and NOWAIT direct write. */
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			return ERR_PTR(-EAGAIN);
+
+		dio_flags |= IOMAP_DIO_BOUNCE;
+	}
 
 	return __iomap_dio_rw(iocb, iter, &btrfs_dio_iomap_ops, &btrfs_dio_ops,
-			    IOMAP_DIO_PARTIAL | IOMAP_DIO_FSBLOCK_ALIGNED, &data, done_before);
+			      dio_flags, &data, done_before);
 }
 
 static ssize_t check_direct_IO(struct btrfs_fs_info *fs_info,
@@ -853,8 +881,6 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	ssize_t ret;
 	unsigned int ilock_flags = 0;
 	struct iomap_dio *dio;
-	const u64 data_profile = btrfs_data_alloc_profile(fs_info) &
-				 BTRFS_BLOCK_GROUP_PROFILE_MASK;
 
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		ilock_flags |= BTRFS_ILOCK_TRY;
@@ -868,16 +894,6 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	if (iocb->ki_pos + iov_iter_count(from) <= i_size_read(inode) && IS_NOSEC(inode))
 		ilock_flags |= BTRFS_ILOCK_SHARED;
 
-	/*
-	 * If our data profile has duplication (either extra mirrors or RAID56),
-	 * we can not trust the direct IO buffer, the content may change during
-	 * writeback and cause different contents written to different mirrors.
-	 *
-	 * Thus only RAID0 and SINGLE can go true zero-copy direct IO.
-	 */
-	if (data_profile != BTRFS_BLOCK_GROUP_RAID0 && data_profile != 0)
-		goto buffered;
-
 relock:
 	ret = btrfs_inode_lock(BTRFS_I(inode), ilock_flags);
 	if (ret < 0)
@@ -918,22 +934,6 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 		btrfs_inode_unlock(BTRFS_I(inode), ilock_flags);
 		goto buffered;
 	}
-	/*
-	 * We can't control the folios being passed in, applications can write
-	 * to them while a direct IO write is in progress.  This means the
-	 * content might change after we calculated the data checksum.
-	 * Therefore we can end up storing a checksum that doesn't match the
-	 * persisted data.
-	 *
-	 * To be extra safe and avoid false data checksum mismatch, if the
-	 * inode requires data checksum, just fallback to buffered IO.
-	 * For buffered IO we have full control of page cache and can ensure
-	 * no one is modifying the content during writeback.
-	 */
-	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)) {
-		btrfs_inode_unlock(BTRFS_I(inode), ilock_flags);
-		goto buffered;
-	}
 
 	/*
 	 * The iov_iter can be mapped to the same file range we are writing to.
-- 
2.54.0

