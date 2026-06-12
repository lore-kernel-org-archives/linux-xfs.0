Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2698B3AFD12
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 09:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781257917; cv=none; b=dx6oa1ZO32NDgGLYuAQHRrSlNuB+u4WVxcc3bxR2RlxtF6zLUSEvS5BqogHXklH00ZD0CLAFuM1jtdR1Ghpav6emcm52FbgjM9nUMfxI+BuK5W+znIQBqujp0kX3aEvsYfEaK9ZSNn1MKq6b427HI0YA7gXIljLw2ynujiNWJLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781257917; c=relaxed/simple;
	bh=htm1i1rmOsEu+1XHjSEAVsy1jJ2Bio4kj6VuAJ24zBw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0smTqjBAvRWj8a7RhE0lgNd12IAFo2CYCO0GiLhsk8SoXnFR6GgSJkMw1vS8AJtFOVDfhtLM0OxYhM1EsKkmdIVE1bSXY2GLAPfuNaehnlg6AW708hHQTXjtCKZ9Kd3X4RPrjrjRJ29a+PUNlX1cETk029oNU+e4HKbpdSrK7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=G2V3xkIX; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=G2V3xkIX; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="G2V3xkIX";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="G2V3xkIX"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 47FB06B4FE;
	Fri, 12 Jun 2026 09:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781257910; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a1yXB51oASffKACY7JQle8/t35pzbKmVjDxG2alQtRs=;
	b=G2V3xkIXz59zH1DsHEWwY54wt12FGX6nSx+ecPcIybzLDeV4ww3+wGdfsJuCjDrJ8Xx5sg
	kOz5r6U5nOUgYcje+nF0/G/GcRIp9jXXzZ3WqPTsy9OyXBmBs+ICloNnQ/uR3FaEbKwV4D
	SIBtfJLOQqvPu3fCevn3QlrjO8EvmBc=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=G2V3xkIX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781257910; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a1yXB51oASffKACY7JQle8/t35pzbKmVjDxG2alQtRs=;
	b=G2V3xkIXz59zH1DsHEWwY54wt12FGX6nSx+ecPcIybzLDeV4ww3+wGdfsJuCjDrJ8Xx5sg
	kOz5r6U5nOUgYcje+nF0/G/GcRIp9jXXzZ3WqPTsy9OyXBmBs+ICloNnQ/uR3FaEbKwV4D
	SIBtfJLOQqvPu3fCevn3QlrjO8EvmBc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4ACD7779A7;
	Fri, 12 Jun 2026 09:51:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gNBWOrPWK2r+FgAAD6G6ig
	(envelope-from <wqu@suse.com>); Fri, 12 Jun 2026 09:51:47 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v3 4/4] btrfs: use IOMAP_DIO_BOUNCE flag instead of falling back to buffered IO
Date: Fri, 12 Jun 2026 19:21:15 +0930
Message-ID: <2432533b0f5ffaf5d72b918e4c365615622945e0.1781253428.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1781253428.git.wqu@suse.com>
References: <cover.1781253428.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_NONE(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 47FB06B4FE
X-Spam-Score: -3.01

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

So for NOWAIT direct IOs, NODATASUM and RAID0/SINGLE profiles are still
required.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/direct-io.c | 53 ++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index e566a60b0ce5..bbf94056a874 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -818,13 +818,36 @@ static ssize_t btrfs_dio_read(struct kiocb *iocb, struct iov_iter *iter,
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
+	if (need_stable_write(BTRFS_I(file_inode(iocb->ki_filp))))
+		dio_flags |= IOMAP_DIO_BOUNCE;
 
 	return __iomap_dio_rw(iocb, iter, &btrfs_dio_iomap_ops, &btrfs_dio_ops,
-			    IOMAP_DIO_PARTIAL | IOMAP_DIO_FSBLOCK_ALIGNED, &data, done_before);
+			      dio_flags, &data, done_before);
 }
 
 static ssize_t check_direct_IO(struct btrfs_fs_info *fs_info,
@@ -853,8 +876,6 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	ssize_t ret;
 	unsigned int ilock_flags = 0;
 	struct iomap_dio *dio;
-	const u64 data_profile = btrfs_data_alloc_profile(fs_info) &
-				 BTRFS_BLOCK_GROUP_PROFILE_MASK;
 
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		ilock_flags |= BTRFS_ILOCK_TRY;
@@ -868,16 +889,6 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
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
@@ -918,22 +929,6 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
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

