Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617897;
	b=2NhBbavbvJYtptCvGfoHR+c93C1QAfU5JQiEg/zH5egLlEkY1O913TGCrK9SaeGN/0YR
	 b2ANXcvG537ajVO4cVNHq4pjA18mujX5mnGSQSUUvnIeccexesFiF8HEPRgrMvU73b8Ao
	 sWxR1KIonRX5dktXyl3s+yQ9zOIikCOqJRFsXXqV0JMP7VEGSC/J9uv54kA73lfkUaabt
	 amiJ5h1gyoTwwp9FJO3/91wKgn73C/bdKPJVR8OENzmV4cFeYE31xtqkcNPOEmYT3e4y1
	 Qy2eHI6nT9CEcK/E78KZd0GCLl0O+1GcZwNgfS6gD9Awr4CB9wO+tsJl14WflNPVT5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617897;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=HVQEjL523GrM+RlH4QR4i2aIfKAzxPUOlVWnp66sE2k=;
	b=kFT7T6/CPGVuKutTmMMBqG970IAffDy8rlIdh77BBKDSxHMPrLWMlp2qGCGn+yjtgUb+
	 fQc+/3gKeR7YtgXSaAMWQd3B8bmj5X1NSt39Kd+IgST6+Sw/36/fzlf38N/eSsWUVxPke
	 PKuecpaD2EKHqf12RXKSb4tKmnrkZ8svbHV10Yd+oTW9DdDyhJkpSF6Jxj9jFwcMKjmDL
	 AYmK3jIR2ccpRZc0Q5ClbYS+MWAcD7dSZ1scN3DKt+B9cTf05ZUNf6HJSrgY5w2463CKa
	 oCmGDEI2dnCqOqDmquKPoYuyYATogl5EacDS7SCQ+cOr8x/XKafriBzdhWCWh8mlDvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=mtiNRaCD;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D30606A32E
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 14:44:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44D30606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=mtiNRaCD
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HVQEjL523GrM+RlH4QR4i2aIfKAzxPUOlVWnp66sE2k=; b=mtiNRaCDG7LIdTPjzFOfhJsVi1
	rzSkmZh+LWvFNfW6NFaAFNIx5Vo+PRMV/Na9ZNPYEUeMAauzi9jP4fFW6fMNWc8/hJJpKmtiZs53v
	39K3p5XCaxU7GM9tCu4LiB8b3ipP24Y02TptIUCskDUhgPsCKb3P/7aE3WGhA8ulua0Dj+KgMp670
	hRi/e7fs1L7UFQWYUO9eugaPM5C+c0zoHMmmPgKF/IumouwQ30OpPPfkGk193cDid+cBtPTm5NcRN
	+qcCp0obR04QgKy8Mb9DL1BvKFIBFuOQz1lUsb8B7SF3sfqMYNvqGhLtxj0TMbutUHOEju/nsUTbg
	pYyEZtDQ==;
Received: from 2a02-8389-2301-9f00-7ed2-8579-02f4-a961.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:7ed2:8579:2f4:a961] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xWEEx-0000000ADpk-10Z3;
	Wed, 25 Nov 2026 14:44:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 07/15] xfs: remove xlog_write_{partial,full}
Date: Wed, 25 Nov 2026 15:42:28 +0100
Message-ID: <20261125144430.728485-8-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261125144430.728485-1-hch@lst.de>
References: <20261125144430.728485-1-hch@lst.de>
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
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Now that the partial iclog writing has been cleaned up to be easy to
read, stop having a separate full iclog write path that just saves a
tiny number of branches while adding a separate code path, and merge
the trivial loop left in xlog_write_partial into xlog_write.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 64 ++++--------------------------------------------
 1 file changed, 5 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 2b4ec63baac5..811987d5478e 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2043,32 +2043,6 @@ xlog_write_iovec(
 	data->record_cnt++;
 }
 
-/*
- * Write log vectors into a single iclog which is guaranteed by the caller
- * to have enough space to write the entire log vector into.
- */
-static void
-xlog_write_full(
-	struct xfs_log_vec	*lv,
-	struct xlog_write_data	*data)
-{
-	int			index;
-
-	ASSERT(data->bytes_left <= xlog_write_space_left(data) ||
-		data->iclog->ic_state == XLOG_STATE_WANT_SYNC);
-
-	/*
-	 * Ordered log vectors have no regions to write so this
-	 * loop will naturally skip them.
-	 */
-	for (index = 0; index < lv->lv_niovecs; index++) {
-		struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
-
-		xlog_write_ophdr(data, reg, reg->i_len);
-		xlog_write_iovec(data, reg->i_addr, reg->i_len);
-	}
-}
-
 static int
 xlog_write_get_more_iclog_space(
 	struct xlog_write_data	*data)
@@ -2166,24 +2140,6 @@ xlog_write_region(
 	return 0;
 }
 
-static int
-xlog_write_partial(
-	struct xfs_log_vec	*lv,
-	struct xlog_write_data	*data)
-{
-	int			index;
-
-	for (index = 0; index < lv->lv_niovecs; index++) {
-		int			error;
-
-		error = xlog_write_region(data, &lv->lv_iovecp[index]);
-		if (error)
-			return error;
-	}
-
-	return 0;
-}
-
 /*
  * Write some region out to in-core log
  *
@@ -2262,22 +2218,12 @@ xlog_write(
 		xlog_cil_set_ctx_write_state(ctx, data.iclog);
 
 	list_for_each_entry(lv, lv_chain, lv_list) {
-		/*
-		 * If the entire log vec does not fit in the iclog, punt it to
-		 * the partial copy loop which can handle this case.
-		 */
-		if (lv->lv_niovecs &&
-		    lv->lv_bytes > xlog_write_space_left(&data)) {
-			error = xlog_write_partial(lv, &data);
-			if (error) {
-				/*
-				 * We have no iclog to release, so just return
-				 * the error immediately.
-				 */
+		int		i;
+
+		for (i = 0; i < lv->lv_niovecs; i++) {
+			error = xlog_write_region(&data, &lv->lv_iovecp[i]);
+			if (error)
 				return error;
-			}
-		} else {
-			xlog_write_full(lv, &data);
 		}
 	}
 	ASSERT(data.bytes_left == 0);
-- 
2.53.0

