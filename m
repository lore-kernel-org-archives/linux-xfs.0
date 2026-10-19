Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792434392;
	b=qH2cLShsk1vODqa9lDxmxwzzcZxuYfYzSBfkhzcm9G0qdP1rnK9Jw++Ez0RptlDRglxp
	 YtGKMy/MBJdQWrftSg0S9I0ZaiCLMp+HBjIM913gbwh78Nj6s0s35miT3cf0jmmo4piPJ
	 UPTIr5kL3wWMl1I8rf5JJ4VZ8/kkVqOvVlKa3c/+OgiLbiws3FBR307A+1FZXBAcXVs6/
	 7UBYBTLfdDwwPsVvc3e5nRTY9F4j4+2Eka2kWP0ZelfqNMowUSrJMTLbwteOb+zTqzdhp
	 ftBWSDxpZreiajS5MHINl3vUU18XsWMgnUSHcMRFRfBjzt6GbFKGfASvtvJQelUWfew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792434392;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=zMU3ZGaDVo+ZRl6ZYDL5930Y9IkhoANgS7JgRJxO4qE=;
	b=aIBBkLi9Er1jTfAgQz1ItMdx5b4jRwCPMbpJxhmntbGVkwQ0rDBeR/f4Pl5B3kylj7iB
	 T7boDsoO0QvUlvWkkoREjsggwJN/1wo2WXAzv7Lfq0Daw+1O9EOCpUBhNm+ZBjt5hv74j
	 MNAi7D0ngD9F+maCH66rHIhsfmjxaWQM8G7wiJ4PK3bRcFGTr7Ok8mUTrqsE7Jwp0bULM
	 hmz4jo++oV723z3+yIMVR9zzZ+Fl5xP9oDQejCetsGn7OkP98RtUw4lYN2/RFIsNGnlNl
	 1/s3RTQ8PluUg6WLkHzR0vBiz0+yxnU0wLcHW52fNhg7WeBADxXnbUzrCvrn0QVBBDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ORYgzabR;
	arc=none smtp.remote-ip=209.85.214.172
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0636F606A320
	for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2026 18:26:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0636F606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ORYgzabR
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ea138a3497so2962715ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2026 11:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792434391; x=1793039191; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=zMU3ZGaDVo+ZRl6ZYDL5930Y9IkhoANgS7JgRJxO4qE=;
        b=ORYgzabRvbzgcU15VA+uuOX6nWJRgMveGk2ncri7VmYqhwTNQ5bv/Ovg2LsgLTITPl
         OT4FpmLVEUGGVc2Te+iUIw5tu+e5/olZctYakpS2hRD0Z6YY28/hW+oH3VeL30rscdhE
         TBsdY9RhEiLpP+u0CaanCgrt5ZzQvBGpor5ucWrCU45qC38rMfrxZGyMN22SYFCy9axs
         Hl/7nak5RS6FbKbEs2lMV/fHqBI//wLCvh/o1RD6mZvk1LhiJDn1VWpWR9aD7s5LtWQk
         ZKrMAvjACS58jgdhm0vUXQNcDVDqyPON5NdraNFNlhcilwybY5yJFuavuhtOTDLSZcVH
         76vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792434391; x=1793039191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=zMU3ZGaDVo+ZRl6ZYDL5930Y9IkhoANgS7JgRJxO4qE=;
        b=HZZvT+qUh3RQZhp/fs7Mqu+ubwzXRFzal7BcwUVkCfIFYPqCOXkv59jfC5OSww5ysH
         49ife5tNyiT/jkuLnh9JKpN2GbeXDYOz0f1/ndY7ABUo4T/XLtISpt4wknzObTdpzSGI
         KNhzPSDJWinuLUWCFoOfIPslCLHD9Sn8IquRzYr+UzTN5orj7d6eAb/xKijQV/uab95m
         Zxdquzq7c0inrtxGBeuH/2jzTT/A+ttL3XQ/mM6bgbP0h0623adQPwirH+NYA6RG2Za3
         qZlUb/RY08s0FScY5chlQ6ue7CEdzT3UcrWWadz9Qgvknj8V+pTbfKYSf248eTjq5bD5
         XhLA==
X-Gm-Message-State: AFq9FYIRVt8eARtsUOdDTAtEZH086g1Qmzg2QL9UHleoL5gl+bjr8eFq
	iNaNhmsS2kr6dUPn9i6yTNlzg2WpXpk7b6DAO2qRZUl6zp7U6toUzdDMQH40kwlk
X-Gm-Gg: AYBFou2oYs2FBMR4BGwzpshgsfrCZQCLdTR++ylt6eQmp4eK1GNcAypl1MY+oB9NLgb
	Rst1a0uSDvd0sZqbDwdQDyrFMaKczsFzdEcOBOYFogn5LxaPNaQFR0DAwsmqL6yyA5Z47cysh/L
	0WOhjjNwky6d/HE6am5e2ESSeeLUxABRZ+lvKsa3r31U+5HjBZeFeTfG2UQcQIapCWvP1On5Hfh
	V6aJFsjl1GIaMpBXK4BwL8MP3UJ/gylvWuKjizskCtzRXjBzg5AcOSQVH6yL0YmPhkTTMmvSGHi
	G0kdwoTHa4zre7geTCCq5eBIS0fQpMJjtcotxIRjz8917fKTqWCEKiGiXA8ro+aV0ROKXOWjNoJ
	IB1ImOISGB9fi4axyhnVyxYrNFeBhQpbheBWKkDJMWwMXd2C2b1zFof4Qx2E3dN3PKf3hCGaXy8
	rsBWYx4ibMO09xQFQheqAtmMtLaClUHA7Q9E42GDu6cULyx5uWRm7gCB0aiwlUwJDi0FCeUeGBk
	9I9l/hvyplhU4n4F/mHiJ9i3uZTxOCXCSwUX6ogRZaE3vWF
X-Received: by 2002:a17:902:ceca:b0:2e4:4eed:5cc5 with SMTP id d9443c01a7336-2e9a6c1df91mr73850385ad.38.1792434391227;
        Mon, 19 Oct 2026 11:26:31 -0700 (PDT)
Received: from archlinux.tail3acd4.ts.net ([69.110.143.170])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea1517e7cfsm4156375ad.58.2026.10.19.11.26.30
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 11:26:30 -0700 (PDT)
From: Vitali Lovich <vlovich@gmail.com>
To: linux-xfs@vger.kernel.org
Subject: [RFC PATCH v1 2/6] iomap: support generation accounting and caller-registered DIO
Date: Mon, 19 Oct 2026 11:26:16 -0700
Message-ID: <20261019182620.1527591-3-vlovich@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019182620.1527591-1-vlovich@gmail.com>
References: <20261019182620.1527591-1-vlovich@gmail.com>
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

Generation draining requires every DIO request on an opted-in inode to
preserve its admission generation until completion. Convert both generic
iomap DIO and the simple-read path to generation-aware accounting,
reusing their existing internal flag fields.

Allow callers to register DIO before entering iomap with
IOMAP_DIO_ACCOUNTED and pass the saved token in IOMAP_DIO_GENERATION.
Iomap owns that registration and releases it on completion or any early
return, including allocation failures, empty requests and -ENOTBLK.
Callers retrying through the generic path must acquire a fresh admission.
Callers without a registration retain internal iomap accounting.

Pass the flags into iomap_dio_read_simple() and update existing XFS and
ext4 callers to pass zero. Preserve the token through mapping and
submission errors, and read it before bio_put() frees the bio-backed
simple-read struct. The completion lifetime still includes filesystem
end_io work and post-write invalidation.

Signed-off-by: Vitali Lovich <vlovich@gmail.com>
---
 fs/ext4/file.c        |  2 +-
 fs/iomap/direct-io.c  | 36 +++++++++++++++++++++-------
 fs/xfs/xfs_file.c     |  2 +-
 include/linux/iomap.h | 56 +++++++++++++++++++++++++++++--------------
 4 files changed, 67 insertions(+), 29 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 374b4bc25bd5..b4e791b1c32d 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -91,7 +91,7 @@ static ssize_t ext4_dio_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		return generic_file_read_iter(iocb, to);
 	}
 
-	ret = iomap_dio_read_simple(iocb, to, ext4_iomap_begin);
+	ret = iomap_dio_read_simple(iocb, to, ext4_iomap_begin, 0);
 	if (ret == -ENOTBLK)
 		ret = iomap_dio_rw(iocb, to, &ext4_iomap_ops, NULL, 0, NULL, 0);
 	inode_unlock_shared(inode);
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 8b4039d16ce8..25b8625b6175 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -140,7 +140,8 @@ ssize_t iomap_dio_complete(struct iomap_dio *dio)
 	    !(dio->flags & IOMAP_DIO_NO_INVALIDATE))
 		kiocb_invalidate_post_direct_write(iocb, dio->size);
 
-	inode_dio_end(file_inode(iocb->ki_filp));
+	inode_dio_end_generation(file_inode(iocb->ki_filp),
+				dio->flags & IOMAP_DIO_GENERATION);
 
 	if (ret > 0) {
 		iocb->ki_pos += ret;
@@ -683,6 +684,12 @@ static int iomap_dio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
  * the correct total number of bytes transferred; this is essential for
  * completing partial requests asynchronously.
  *
+ * When @dio_flags includes IOMAP_DIO_ACCOUNTED, iomap takes ownership of the
+ * caller's registration from inode_dio_try_begin() on entry, with its saved
+ * generation token supplied in IOMAP_DIO_GENERATION. Iomap releases the
+ * registration on completion or any early error or NULL return, including
+ * -ENOTBLK. Callers retrying the request must acquire a fresh registration.
+ *
  * Returns -ENOTBLK In case of a page invalidation invalidation failure for
  * writes.  The callers needs to fall back to buffered I/O in this case.
  */
@@ -701,6 +708,8 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	};
 	bool wait_for_completion =
 		is_sync_kiocb(iocb) || (dio_flags & IOMAP_DIO_FORCE_WAIT);
+	bool accounted = dio_flags & IOMAP_DIO_ACCOUNTED;
+	bool generation = dio_flags & IOMAP_DIO_GENERATION;
 	struct blk_plug plug;
 	struct iomap_dio *dio;
 	loff_t ret = 0;
@@ -708,11 +717,13 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	trace_iomap_dio_rw_begin(iocb, iter, dio_flags, done_before);
 
 	if (!iomi.len)
-		return NULL;
+		goto out_account;
 
 	dio = kmalloc_obj(*dio);
-	if (!dio)
-		return ERR_PTR(-ENOMEM);
+	if (!dio) {
+		ret = -ENOMEM;
+		goto out_account;
+	}
 
 	dio->iocb = iocb;
 	atomic_set(&dio->ref, 1);
@@ -809,7 +820,10 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 			goto out_free_dio;
 	}
 
-	inode_dio_begin(inode);
+	if (!accounted)
+		generation = inode_dio_begin_generation(inode);
+	if (generation)
+		dio->flags |= IOMAP_DIO_GENERATION;
 
 	blk_start_plug(&plug);
 	while ((ret = iomap_iter(&iomi, ops)) > 0) {
@@ -894,6 +908,9 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 
 out_free_dio:
 	kfree(dio);
+out_account:
+	if (accounted)
+		inode_dio_end_generation(inode, generation);
 	if (ret)
 		return ERR_PTR(ret);
 	return NULL;
@@ -937,6 +954,7 @@ static ssize_t iomap_dio_simple_complete(struct iomap_dio_simple *sr)
 	struct bio *bio = &sr->bio;
 	struct kiocb *iocb = sr->iocb;
 	struct inode *inode = file_inode(iocb->ki_filp);
+	bool generation = sr->dio_flags & IOMAP_DIO_GENERATION;
 	ssize_t ret;
 
 	if (unlikely(bio->bi_status)) {
@@ -956,7 +974,7 @@ static ssize_t iomap_dio_simple_complete(struct iomap_dio_simple *sr)
 		bio_release_pages(bio, false);
 		bio_put(bio);
 	}
-	inode_dio_end(inode);
+	inode_dio_end_generation(inode, generation);
 	trace_iomap_dio_complete(iocb, ret < 0 ? ret : 0, ret);
 	return ret;
 }
@@ -990,7 +1008,7 @@ static void iomap_dio_simple_end_io(struct bio *bio)
 }
 
 ssize_t __iomap_dio_read_simple(struct kiocb *iocb, struct iov_iter *iter,
-		struct iomap_iter *iomi)
+		struct iomap_iter *iomi, bool generation)
 {
 	gfp_t gfp = (iomi->flags & IOMAP_NOWAIT) ? GFP_NOWAIT : GFP_KERNEL;
 	struct iomap_dio_simple *sr;
@@ -1029,7 +1047,7 @@ ssize_t __iomap_dio_read_simple(struct kiocb *iocb, struct iov_iter *iter,
 	}
 	sr = container_of(bio, struct iomap_dio_simple, bio);
 	sr->iocb = iocb;
-	sr->dio_flags = 0;
+	sr->dio_flags = generation ? IOMAP_DIO_GENERATION : 0;
 
 	bio->bi_iter.bi_sector = iomap_sector(&iomi->iomap, iomi->pos);
 	bio->bi_ioprio = iocb->ki_ioprio;
@@ -1074,7 +1092,7 @@ ssize_t __iomap_dio_read_simple(struct kiocb *iocb, struct iov_iter *iter,
 out_bio_put:
 	bio_put(bio);
 out_dio_end:
-	inode_dio_end(iomi->inode);
+	inode_dio_end_generation(iomi->inode, generation);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(__iomap_dio_read_simple);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index d8202da15aca..d4446887453f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -255,7 +255,7 @@ xfs_file_dio_read(
 				&xfs_dio_read_bounce_ops, IOMAP_DIO_BOUNCE,
 				NULL, 0);
 	} else {
-		ret = iomap_dio_read_simple(iocb, to, xfs_read_iomap_begin);
+		ret = iomap_dio_read_simple(iocb, to, xfs_read_iomap_begin, 0);
 		if (ret == -ENOTBLK)
 			ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, NULL,
 					0, NULL, 0);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index bc7ae6327dbf..ca11e4b6c8c4 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -673,6 +673,16 @@ struct iomap_dio_ops {
  */
 #define IOMAP_DIO_BOUNCE		(1 << 4)
 
+/*
+ * IOMAP_DIO_ACCOUNTED indicates the caller has already registered this
+ * request with inode_dio_try_begin(); iomap takes ownership of the
+ * registration and releases it on completion or early return (including
+ * -ENOTBLK). IOMAP_DIO_GENERATION carries the generation token returned
+ * by that admission and is only meaningful with IOMAP_DIO_ACCOUNTED.
+ */
+#define IOMAP_DIO_ACCOUNTED	(1 << 5)
+#define IOMAP_DIO_GENERATION	(1 << 6)
+
 ssize_t iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
 		unsigned int dio_flags, void *private, size_t done_before);
@@ -690,7 +700,8 @@ void iomap_dio_bio_end_io(struct bio *bio);
  * writes, zero-length I/O, and larger requests need the generic iomap direct
  * I/O path.
  *
- * Does not support iomap_dio_ops, dio_flags, done_before or private data.
+ * Does not support iomap_dio_ops, done_before, private data, or dio_flags
+ * other than IOMAP_DIO_ACCOUNTED and IOMAP_DIO_GENERATION.
  * The range must also stay within i_size and encrypted inodes must use the
  * generic iomap direct I/O path.
  *
@@ -702,9 +713,10 @@ void iomap_dio_bio_end_io(struct bio *bio);
  * is never advanced.
  */
 ssize_t __iomap_dio_read_simple(struct kiocb *iocb, struct iov_iter *iter,
-		struct iomap_iter *iomi);
+		struct iomap_iter *iomi, bool generation);
 static __always_inline ssize_t iomap_dio_read_simple(struct kiocb *iocb,
-		struct iov_iter *iter, iomap_iter_begin_fn begin)
+		struct iov_iter *iter, iomap_iter_begin_fn begin,
+		unsigned int dio_flags)
 {
 	struct iomap_iter iomi = {
 		.inode		= file_inode(iocb->ki_filp),
@@ -712,39 +724,47 @@ static __always_inline ssize_t iomap_dio_read_simple(struct kiocb *iocb,
 		.len		= iov_iter_count(iter),
 		.flags		= IOMAP_DIRECT,
 	};
+	bool accounted = dio_flags & IOMAP_DIO_ACCOUNTED;
+	bool generation = dio_flags & IOMAP_DIO_GENERATION;
 	ssize_t ret;
 
-	if (!iomi.len)
-		return 0;
+	if (!iomi.len) {
+		ret = 0;
+		goto out_account;
+	}
 
 	/*
 	 * Simple dio is an optimization for small IO. Filter out large IO
 	 * early as it's the most common case to fail for typical direct IO
 	 * workloads.
 	 */
-	if (iomi.len > iomi.inode->i_sb->s_blocksize)
-		return -ENOTBLK;
-	if (iocb->ki_pos + iomi.len > i_size_read(iomi.inode))
-		return -ENOTBLK;
-	if (IS_ENCRYPTED(iomi.inode))
-		return -ENOTBLK;
+	ret = -ENOTBLK;
+	if (iomi.len > iomi.inode->i_sb->s_blocksize ||
+	    iocb->ki_pos + iomi.len > i_size_read(iomi.inode) ||
+	    IS_ENCRYPTED(iomi.inode))
+		goto out_account;
 
 	ret = kiocb_write_and_wait(iocb, iomi.len);
 	if (ret)
-		return ret;
+		goto out_account;
 
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		iomi.flags |= IOMAP_NOWAIT;
 
-	inode_dio_begin(iomi.inode);
+	if (!accounted) {
+		generation = inode_dio_begin_generation(iomi.inode);
+		accounted = true;
+	}
 	ret = begin(iomi.inode, iomi.pos, iomi.len, iomi.flags, &iomi.iomap,
 			&iomi.srcmap);
-	if (ret) {
-		inode_dio_end(iomi.inode);
-		return ret;
-	}
+	if (ret)
+		goto out_account;
 
-	return __iomap_dio_read_simple(iocb, iter, &iomi);
+	return __iomap_dio_read_simple(iocb, iter, &iomi, generation);
+out_account:
+	if (accounted)
+		inode_dio_end_generation(iomi.inode, generation);
+	return ret;
 }
 
 #ifdef CONFIG_SWAP
-- 
2.56.0

