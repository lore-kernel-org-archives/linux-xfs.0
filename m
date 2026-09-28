Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23CF48EC6D
	for <linux-xfs@vger.kernel.org>; Mon, 28 Sep 2026 08:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790585321; cv=none; b=PjBYTiHqXHylHzbTZU8DUjJujC3lJx1t5V0nvzPrchs2Nha+RktPsg/zS0hEq8+w16NINhMcHUHdynRNLsuhe/nf/35bu6YCqndbhzsK67W0btnKGSV7PWZjtuT5dAovXmfCceZjppFlExhhdeCQE20pi+hHOECf8Fg3EcsOFaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790585321; c=relaxed/simple;
	bh=Ml/wRWriMjuOvm8erGnx14aGJ0pVCe7lav+rrtrNSB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUlOkWpp/IEjHrGIyHAGe0HQndVCeg0tYaR9/jYIMGj9xn9pUho74kLM7PWRR7LXGP/yp7O5M3kE/VSPlwEYArC2+9N9Cklui8pV4L/m1+7icbo38TIdmqNgvPwNvbEhDiIIsHRj5ifwHTA99uBVYVtAbISxo2XTMSrity/IR/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AYVmwKTe; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AYVmwKTe"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49fff6f0f87so8284965e9.3
        for <linux-xfs@vger.kernel.org>; Mon, 28 Sep 2026 01:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790585318; x=1791190118; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+Jvy93H4vWasmTh8KcuN5CDwZOVOqi8h4a5W+CL6duU=;
        b=AYVmwKTeOz2um7LlFFac1/QF8nDaG0JweUSC6IEz61mIJ7Cn4HeUcZ6TU7g50UlWfm
         aKfmtM/bZwTv/G12O0iyJ0WYT7jHE5ehha/xl7Q3rx96eawvqxmV2baX1NnNF1b4oxzh
         l+ioHs6igrTQRnoKxXYNx/yTVL0CuFCURjNFTBqx10iI40teMzGaGN8w0Y0EwbEUm0Xm
         JjFE+Dg10NmAYde1IsYCj3gwWKdibV9ow8qDr/L4zDLfgCZe6ITQ0lvbFhmDK2a4bvRz
         gJRBFXNvQ7684Zk/kveOUQJpNgCtTwPomM+zao5oSHIQhT9Z4ad1oreyNwYQ9FqS7+tg
         RScA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790585318; x=1791190118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+Jvy93H4vWasmTh8KcuN5CDwZOVOqi8h4a5W+CL6duU=;
        b=XBUbY5L3mrb7cenE2e1r8+4uQXOaYEAF+xF28bqob3a+IRRxNIxr/96xwJweHy2jXw
         PVwtJqzLqry9TPTd0mR0QJ+AvpqF5Hd5n0qVmKIL/RnGclKsmgKqP3naPLMR6nKMQx1y
         czPt9PKmgOeBpJH49Yi0P4QehdiiOSTQsdA+rK5fUc1oPaoFIHAC1ny1uux5NHvcvxN3
         n+3ZtzH+xxTVAiC/oGrDDgh1stdhBO281gto4cpnQoHAhyhAbkl4+Ku3sCLFbvzfrKsP
         nIOEqbx3SuC2GqJ0T4/V/lsNVGY9bt1CmRIiL2ZjW4SKSOWv7KZsk/7aQxWFo4aKB+8Q
         VYPQ==
X-Forwarded-Encrypted: i=1; AKwUvBx2HCgfcA1FKFe4MI2KfHeqhyrK9NqmjLR4qU43XVRF7wlwP5avxhoB3jJJkH9cK/2f9a6Y3CX2yLc=@vger.kernel.org
X-Gm-Message-State: AFuF++mOgEks3mtMUa+PS6BJnf8DsGKeKrpvQFMWppLQFQflEXfpvP+T
	mUO4fZoCFitx2bKODF98/RSGZiIx3CRSF8Ljifro5LF/PJKI5SudISCg
X-Gm-Gg: AYBFou2Y+0CkstUtOAi7Nu3JahyDcljjVAnJfARKwpMvYQWjVJydjvb3/A7UDDwRFDU
	EQgAkaSKx3JWhd+fdmxRtozHfNSyRgMIXr8SRO79wK11CY/AsJEMfySoIwb09UUFgwsbSz7mQXp
	wOaO9DvHp/ng+fiyRcaJiUbNgqnNc2F3VCmg5nkGEr/EbMm7mNLfHFv7WPeDP41LLLri2/uSQVs
	KscHrEEhPOM+mPC4cCDy6BwPXqKTUo0TAWdp/mXYPTm8dEQXQ6ROdz1kQQ1byAufNRE80J0ZnNL
	ynlSmYRxwrT8aayFCGvySzZUooJpIQ+kMMC9EwZPjiAC85wLMGoNoyAUFk/p7/QK3WGY2sI19ry
	zKQuOZim6hVaTd8Te9TiMwcRgQ//cV5lixm0LugX3XwO9Haz2wI0ibF1tge2j2Jttsk1nj4Geyl
	maxUYF/gGO5cBKAjQ6zRnKo41KNQb3Llko30EmI8QERgxN2AjJLLAK2HVIDof6vFKSfrAfp5Cx0
	FW91lqW1lmTBIYYcbQtQMvrahZJdEZORy4ydg355yOCapAd+jrbjRPmEk1dhB6LKnW3XTLfHEwu
	FIkYa+KYn6QB2XI=
X-Received: by 2002:a05:600c:4745:b0:49d:2562:d670 with SMTP id 5b1f17b1804b1-49fe7b6ffbfmr216288885e9.14.1790585317664;
        Mon, 28 Sep 2026 01:48:37 -0700 (PDT)
Received: from andreayoga.localdomain (93-42-14-189.ip84.fastwebnet.it. [93.42.14.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a0017652d1sm182584705e9.5.2026.09.28.01.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 01:48:37 -0700 (PDT)
From: Andrea Parri <parri.andrea@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>
Cc: Andrea Parri <parri.andrea@gmail.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3 4/4] iomap: don't lose a failed direct I/O bio's error when zeroing the tail
Date: Mon, 28 Sep 2026 10:48:09 +0200
Message-ID: <0cbce1012f5333690be36a9adafb3e190fe2ca77.1790342457.git.parri.andrea@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1790342457.git.parri.andrea@gmail.com>
References: <cover.1790342457.git.parri.andrea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iomap_dio_bio_iter() falls through to the sub-block tail zeroing when
the data bio submission fails, so that the rest of the block is still
zeroed and stale data is not exposed.  The zeroing result was assigned
to ret, which overwrote the submission error with the successful
zeroing result (zero) and the failed write was reported as success.

iomap_dio_zero() can only return an error from a can't-happen
WARN_ON_ONCE() (nr_vecs exceeding BIO_MAX_VECS, which the existing
comment there says "shall never be reached" for any in-tree
filesystem), so it isn't a real runtime failure worth reporting to
userspace, let alone one worth losing the actual submission error for.
Make iomap_dio_zero() return void and drop the error handling at both
call sites instead of threading the result through a separate
variable.

Fixes: 10553a91652d ("iomap: fix iomap_dio_zero() for fs bs > system page size")
Cc: <stable@vger.kernel.org> # v6.12
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Assisted-by: LLM
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
---
 fs/iomap/direct-io.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 8b4039d16ce89..7f1e85f95a469 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -296,7 +296,7 @@ u32 iomap_finish_ioend_direct(struct iomap_ioend *ioend)
 	return vec_count;
 }
 
-static int iomap_dio_zero(const struct iomap_iter *iter, struct iomap_dio *dio,
+static void iomap_dio_zero(const struct iomap_iter *iter, struct iomap_dio *dio,
 		loff_t pos, unsigned len)
 {
 	struct inode *inode = file_inode(dio->iocb->ki_filp);
@@ -305,14 +305,14 @@ static int iomap_dio_zero(const struct iomap_iter *iter, struct iomap_dio *dio,
 	int nr_vecs = max(1, i_blocksize(inode) / folio_size(zero_folio));
 
 	if (!len)
-		return 0;
+		return;
 
 	/*
 	 * This limit shall never be reached as most filesystems have a
 	 * maximum blocksize of 64k.
 	 */
 	if (WARN_ON_ONCE(nr_vecs > BIO_MAX_VECS))
-		return -EINVAL;
+		return;
 
 	bio = iomap_dio_alloc_bio(iter, dio, nr_vecs,
 				  REQ_OP_WRITE | REQ_SYNC | REQ_IDLE);
@@ -328,8 +328,6 @@ static int iomap_dio_zero(const struct iomap_iter *iter, struct iomap_dio *dio,
 		len -= io_len;
 	}
 	iomap_dio_submit_bio(iter, dio, bio, pos);
-
-	return 0;
 }
 
 static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
@@ -541,10 +539,7 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 	if (need_zeroout) {
 		/* zero out from the start of the block to the write offset */
 		pad = pos & (fs_block_size - 1);
-
-		ret = iomap_dio_zero(iter, dio, pos - pad, pad);
-		if (ret)
-			goto out;
+		iomap_dio_zero(iter, dio, pos - pad, pad);
 	}
 
 	do {
@@ -582,8 +577,7 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 		/* zero out from the end of the write to the end of the block */
 		pad = pos & (fs_block_size - 1);
 		if (pad)
-			ret = iomap_dio_zero(iter, dio, pos,
-					     fs_block_size - pad);
+			iomap_dio_zero(iter, dio, pos, fs_block_size - pad);
 	}
 out:
 	/* Undo iter limitation to current extent */
-- 
2.53.0

