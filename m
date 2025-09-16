Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047162F28F9
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 23:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758066644; cv=none; b=Hoj7E4LN6YQBbXm+4u4IHPAXDKcxneakgHWMnUaS56b5VY4Yflaggu+QS2DEXmcXBDCrVaDlrca5WUseGuPKV6MccJc3g6BCZ7kA9MDWBAZxkidM+AcHqo0sGFzcq0Xh/Ug6sTfa9SzeEEdE8xm9FV8z5RJXDxMfavG+MyIuAFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758066644; c=relaxed/simple;
	bh=cSOs0ggmeUUrVpri4iN4r8ZrO/BSOihac/gCm8TE6hU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ECjNPcdJwsdm4abIACTcqAZGVnPFZR3mQqcxlXpHISKuRuOPSeqoyVBkT1E8wZEs4rOHSPd4qC072UKOIea4zOZlGXLJiHJYi2CmnhCYKU/TsmyI1Xo092k8TpfOirUMsCvoFW9aabRcuNY6WG6uc662PRBhevvsRWUkjN9+kGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SddxPqw3; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SddxPqw3"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-251fc032d1fso68144625ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 16:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758066642; x=1758671442; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NtkikFt4BtrmbQJg7Y/O3dHsGuO2kmoVpS/7wvQkr7w=;
        b=SddxPqw3gajZM8mKvuVoc1r6ZEpFpDhnpbPJua1wnBjiIMeL3/7AmcqOjK96GFBqk1
         gcofnts5+9DxdjBPdtk3dTTeKknmvvHGXswxWDdYOL9ICzBSJZD2jXplMOfsUzv3SMdb
         Eow2jGU6q/iBXXnA1zoPLHdalzHVobHZO/UFwx2nZ1xslqCaVdlNEzPII+gkNwiLc1gN
         nePDBL47qNbzxgJfVfXb7ME3tASU8RBrxZEB47YqM4Kas0Y858iUD1fKyN4ws01AxMqd
         3ulNGekxRZ8zF3mthvEekVR8AnIVmvG/qfBHcDJEVNT4xxf9D9YX0jWH2HtQcLsYQgze
         gxgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758066642; x=1758671442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NtkikFt4BtrmbQJg7Y/O3dHsGuO2kmoVpS/7wvQkr7w=;
        b=VJkEM2puINtAetHlzBYGYZrlpP63VRTnTuveRH+JRFq/vZLXXkAvV1Aow5FKYWudI3
         qEU/6meTVUf4LjFkmVn4whqzgKxSe8Kr9JK8QjJ+++8rQ0tXbLj94iE2Q/cFIdmuIoFH
         euP6gyPCHafcLqdL6koFZK8mL6iaD9r5BURchptoUK3YcqlsOLqnXgrvmoLI0TjYH6ON
         U4ol9h3oMhvLfYhHwy0ZpRixuxDn4JRGFRieafYQ6q8a0OwaxSkcIsbvxWnsqwwVKQGb
         AAT/FnF3q/SDpYmr0wAWzjlJg/UEEoS1z87m+2MsvANlhTtxHcbrE8Xu6/PEpOOoTuyd
         TFTg==
X-Forwarded-Encrypted: i=1; AJvYcCXhfh+HxTS+Ji+2nxCyNj26TZFAmaXhe6Eq1elPTykCWs1xZOLz3mSpIqaoCddzF8mAWNxjX+ILthY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxurF7rRXHHUP5+KQ0/gfLtIYxvCr7dQrh7T3sXPfa0/Tzm0Bl0
	Ykj40UCi6HO0f3L1kzNxtTuY1bPG3mo28EltZIrt5YzI74ugtxI1jNDi
X-Gm-Gg: ASbGnctLp2UzDHVKJ5T9Uths8eGomLrRGIfbgK1fqK9Iklr2dR1ipPyiIzOFwFZ7XUr
	/dcdHQLM1xUrXBraF95dsj6cZ18oO9U3WnkEZQrddx96iuve9DEOGF0bY6RXZi4xsuOS8/LSK0b
	sBqcCfK0hqeW3ZbGelvG8us/YWqGhSmuC7K7I4RA9+IRvpf/ZED4na1W6Njft+IIadAo0IRPSpx
	Zz/SCSHw2zIPqzSlSHgmbhEPrtHyA7lcFGGvZNY9wgw2Dpf95mcCKtyrW/6GpIUyEdiAN9o3hIh
	WRJetipdMFJ27F4bDbx/4ubRRKClA9CsXNMqyGgRdSNoi2Vklc1fp95GqRZ7FekxopKdSeGiFWa
	ab5PSNtS14N/kZ80w8K+HrRZWwIKQcJdsuEfEFHaWiQH0ZgBR68eU02SwbiyC
X-Google-Smtp-Source: AGHT+IHdovCfa/eZKPRHnJED5+v89Pj6T7KBimTC+ZT+9vXMwhXFVHkOLh5LwFfiyiIiumWkMExMbw==
X-Received: by 2002:a17:903:22c9:b0:266:64b7:6e38 with SMTP id d9443c01a7336-2681390362dmr865485ad.46.1758066642373;
        Tue, 16 Sep 2025 16:50:42 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:49::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2680889f449sm3525245ad.102.2025.09.16.16.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 16:50:42 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: brauner@kernel.org,
	miklos@szeredi.hu
Cc: hch@infradead.org,
	djwong@kernel.org,
	hsiangkao@linux.alibaba.com,
	linux-block@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com,
	linux-xfs@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH v3 10/15] iomap: add bias for async read requests
Date: Tue, 16 Sep 2025 16:44:20 -0700
Message-ID: <20250916234425.1274735-11-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250916234425.1274735-1-joannelkoong@gmail.com>
References: <20250916234425.1274735-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Non-block-based filesystems will be using iomap read/readahead. If they
handle reading in ranges asynchronously and fulfill those read requests
on an ongoing basis (instead of all together at the end), then there is
the possibility that the read on the folio may be prematurely ended if
earlier async requests complete before the later ones have been issued.

For example if there is a large folio and a readahead request for 16
pages in that folio, if doing readahead on those 16 pages is split into
4 async requests and the first request is sent off and then completed
before we have sent off the second request, then when the first request
calls iomap_finish_folio_read(), ifs->read_bytes_pending would be 0,
which would end the read and unlock the folio prematurely.

To mitigate this, a "bias" is added to ifs->read_bytes_pending before
the first range is forwarded to the caller and removed after the last
range has been forwarded.

iomap writeback does this with their async requests as well to prevent
prematurely ending writeback.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/iomap/buffered-io.c | 55 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 47 insertions(+), 8 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 561378f2b9bb..667a49cb5ae5 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -420,6 +420,38 @@ const struct iomap_read_ops iomap_bio_read_ops = {
 };
 EXPORT_SYMBOL_GPL(iomap_bio_read_ops);
 
+/*
+ * Add a bias to ifs->read_bytes_pending to prevent the read on the folio from
+ * being ended prematurely.
+ *
+ * Otherwise, if the ranges are read asynchronously and read requests are
+ * fulfilled on an ongoing basis, there is the possibility that the read on the
+ * folio may be prematurely ended if earlier async requests complete before the
+ * later ones have been issued.
+ */
+static void iomap_read_add_bias(struct folio *folio)
+{
+	iomap_start_folio_read(folio, 1);
+}
+
+static void iomap_read_remove_bias(struct folio *folio, bool *cur_folio_owned)
+{
+	struct iomap_folio_state *ifs = folio->private;
+	bool finished, uptodate;
+
+	if (ifs) {
+		spin_lock_irq(&ifs->state_lock);
+		ifs->read_bytes_pending -= 1;
+		finished = !ifs->read_bytes_pending;
+		if (finished)
+			uptodate = ifs_is_fully_uptodate(folio, ifs);
+		spin_unlock_irq(&ifs->state_lock);
+		if (finished)
+			folio_end_read(folio, uptodate);
+		*cur_folio_owned = true;
+	}
+}
+
 static int iomap_read_folio_iter(struct iomap_iter *iter,
 		struct iomap_read_folio_ctx *ctx, bool *cur_folio_owned)
 {
@@ -429,7 +461,7 @@ static int iomap_read_folio_iter(struct iomap_iter *iter,
 	struct folio *folio = ctx->cur_folio;
 	size_t poff, plen;
 	loff_t delta;
-	int ret;
+	int ret = 0;
 
 	if (iomap->type == IOMAP_INLINE) {
 		ret = iomap_read_inline_data(iter, folio);
@@ -441,6 +473,8 @@ static int iomap_read_folio_iter(struct iomap_iter *iter,
 	/* zero post-eof blocks as the page may be mapped */
 	ifs_alloc(iter->inode, folio, iter->flags);
 
+	iomap_read_add_bias(folio);
+
 	length = min_t(loff_t, length,
 			folio_size(folio) - offset_in_folio(folio, pos));
 	while (length) {
@@ -448,16 +482,18 @@ static int iomap_read_folio_iter(struct iomap_iter *iter,
 				&plen);
 
 		delta = pos - iter->pos;
-		if (WARN_ON_ONCE(delta + plen > length))
-			return -EIO;
+		if (WARN_ON_ONCE(delta + plen > length)) {
+			ret = -EIO;
+			break;
+		}
 		length -= delta + plen;
 
 		ret = iomap_iter_advance(iter, &delta);
 		if (ret)
-			return ret;
+			break;
 
 		if (plen == 0)
-			return 0;
+			break;
 
 		if (iomap_block_needs_zeroing(iter, pos)) {
 			folio_zero_range(folio, poff, plen);
@@ -466,16 +502,19 @@ static int iomap_read_folio_iter(struct iomap_iter *iter,
 			*cur_folio_owned = true;
 			ret = ctx->ops->read_folio_range(iter, ctx, plen);
 			if (ret)
-				return ret;
+				break;
 		}
 
 		delta = plen;
 		ret = iomap_iter_advance(iter, &delta);
 		if (ret)
-			return ret;
+			break;
 		pos = iter->pos;
 	}
-	return 0;
+
+	iomap_read_remove_bias(folio, cur_folio_owned);
+
+	return ret;
 }
 
 int iomap_read_folio(const struct iomap_ops *ops,
-- 
2.47.3

