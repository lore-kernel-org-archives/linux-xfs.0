Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C2C23BD03
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 20:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789419156; cv=none; b=fF+FpRejuNUtTtPYIJVitHdG2cQPCXf/YUo9CPsoCqVvRV1mBUena3o9x9rzsm3B8QNrr/BuPsxcZOmeomgHrsMsnU+ODum5c45IEYTQ2JESodeZIcPWKpVcTV2pHBNWZOsjC+H9o2i6am4h9X1JEfjk9D0UScKFB6wn8SuyQSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789419156; c=relaxed/simple;
	bh=kP8jWBlRyd2OuW1IcXf19b85ggRheMn+RNVKiI+IuSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etsOP7vhualx46pCgKHEHu8FxJ91NdcjgGQseYCB42sGB8m6652DuP0NqWZ0aHw+SSOiVnWszei8CQaCBnvgX04il4x9b8aJSVr/+dZ+nvJorgFX6d7MicF0TCUfqznGd1ASxOwb22pRgrsomO/LMiMgI+txoCAK8cRWdkDuGas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jWxL1iLC; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=eEUpUano; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jWxL1iLC";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="eEUpUano"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789419153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WGBMvZLp/A3wZ6C4KXPD6YqKfI2U7OpmdbWjOITOqtA=;
	b=jWxL1iLCitHcf9ZGy6c6ww3DfYUPhr/FE+wwcXj9K+rmppDNUedzgyxcGtZUY+QpT8mz/e
	NCecgsS3nZOzOFUsF21KWe+FxQPhhYew3Byg/foN5YEUmVtBV5O0OJjvaLcYXMjJP5ubSc
	q55rqQ3BKOtIsBYExoNNPf8mAPvk+j4=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-gmaqZ2GFPrCOHHkIdUKaFw-1; Mon, 14 Sep 2026 16:52:32 -0400
X-MC-Unique: gmaqZ2GFPrCOHHkIdUKaFw-1
X-Mimecast-MFC-AGG-ID: gmaqZ2GFPrCOHHkIdUKaFw_1789419152
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93a183a0e93so317744685a.1
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 13:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789419152; x=1790023952; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WGBMvZLp/A3wZ6C4KXPD6YqKfI2U7OpmdbWjOITOqtA=;
        b=eEUpUanoE2qQtFY8E20C1+jXDDm9czevigBW+olNWqOvCcNP40lofTpmKzdAudS58m
         BEf11+EmKYQFKpsHSrpcVTzwCUjlOwZrEU0XHEsncd0rdz+ST1qfxOiVDZEm9CirV7ZX
         OFWBpQ33nNanSALK7a8EbE4uPVvhPIAJcuwEYg1aSLZpFAHUSCGoTAD2LZzrY0m78Zu8
         IebJWj3zL6UuLyujeBw7y04r41FMrX8ywU5SFrXW+TI584JMEXbFGkzEXxFtAGvTuIwX
         VLHP3C1XwOxGnU48aP5kkLN6SCW4glQ2rM09Sdr0gRxkXaJlqcVLlhPEqC3miFLKKX0v
         pQzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789419152; x=1790023952;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WGBMvZLp/A3wZ6C4KXPD6YqKfI2U7OpmdbWjOITOqtA=;
        b=LqjYBjKE7wVCYlqjZCZWvinUR/kTi+LLhrib3q22z9v0flGojlxUFHRwPY0t9digii
         vtLS1xCaBLm9W4qowqAqSxIH7fLmeLfDOEcHdBcHx0CTwxyqs4TeL6f9zNo3SgdYopH2
         senfbjrPXUWWXAs0WirNXpTA3GpRbqmuMTo8lkADKFtnzy4N2b5fQbkw1zQW2b7nfs49
         K/+QNYI8nKE0qR9TcQuf2WxNmIxh8YM1QEj163JIELGyM+GqXtVrXUyrG/FCEY9gjSDA
         lZQXC+csP6It2G9loP0616L35dgB0iUu6i+6geXfhiobRDNf7m4MZO/xMSWM2TxU9UwR
         llWw==
X-Gm-Message-State: AFuF++le9uY8JVt21B83syApMohetXNYZzRZcrtdyw19nzXCficTXlo7
	g19ATgqa3gmyuadEeZdyHWMcDOuXKaOkOItLOfe837FLkguPvNlHWBeKSnKvs4ty4HKJn11nKKo
	4S6CrOeruMq0ziN3ybFe+u/lHrdSLaE5IYjczgdslI4Zn8rymhMckV2MqOuYn7P6xeERBwL3cw3
	ZRoy2O5iVeNS39K6vBcr3ykS7j/gZ2X0kB0Y/FaYtY9iLqvek=
X-Gm-Gg: AYBFou0j6T4/thRqOFjs8c5RLDvfsooQTMkr5lyoducK8Dl7mKVp536rImwmYfBucBY
	lSTfLOrLBr8rWnSNtqS2y1fvwCgjAn5O8hX9Oetas8HsOyYdAWpu0SybV1KXkEBcM6Y/h4FOth8
	CkLcguyxaPGri+R3yruS/5xXjjH6N2/H1szP6kMVEof1codnhj8afzmrzOZ8KpdHg/MjjhJplz+
	zIqmuIy0nX2kOHyBx6Cj3maiGEf8TqwXfxnDIG9/QOULmYNUcdB9mUfApzu9KSfE9whObzIRd3M
	a58EwTH4adPXdu9FSd5E0z0c0QVbON9dOees683jPw89l24HKzxpTGdqPkntcLb4nApT1lmm9l6
	KYgP3g0JP+OYtrM0TTUQ+fJGheAaYgIXg8qpbgg==
X-Received: by 2002:a05:620a:170b:b0:939:6cd7:9706 with SMTP id af79cd13be357-93a298071b2mr602941285a.21.1789419151844;
        Mon, 14 Sep 2026 13:52:31 -0700 (PDT)
X-Received: by 2002:a05:620a:170b:b0:939:6cd7:9706 with SMTP id af79cd13be357-93a298071b2mr602935685a.21.1789419151350;
        Mon, 14 Sep 2026 13:52:31 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e7f1da12sm1099236785a.9.2026.09.14.13.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 13:52:30 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 08/14] xfs: remove unused mp argument from xfs_rtrefcount_broot_space_calc()
Date: Mon, 14 Sep 2026 15:46:13 -0500
Message-ID: <20260914205221.1516254-9-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914205221.1516254-1-sandeen@redhat.com>
References: <20260914205221.1516254-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_rtrefcount_btree.c | 6 +++---
 fs/xfs/libxfs/xfs_rtrefcount_btree.h | 3 +--
 fs/xfs/scrub/rtrefcount_repair.c     | 3 +--
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index 22acc1411aac..0e0b0c7ba80d 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -311,7 +311,7 @@ xfs_rtrefcountbt_broot_realloc(
 	unsigned int		old_size = ifp->if_broot_bytes;
 	const unsigned int	level = cur->bc_nlevels - 1;
 
-	new_size = xfs_rtrefcount_broot_space_calc(mp, level, new_numrecs);
+	new_size = xfs_rtrefcount_broot_space_calc(level, new_numrecs);
 
 	/* Handle the nop case quietly. */
 	if (new_size == old_size)
@@ -658,7 +658,7 @@ xfs_iformat_rtrefcount(
 	}
 
 	broot = xfs_broot_alloc(xfs_ifork_ptr(ip, XFS_DATA_FORK),
-			xfs_rtrefcount_broot_space_calc(mp, level, numrecs));
+			xfs_rtrefcount_broot_space_calc(level, numrecs));
 	if (broot)
 		xfs_rtrefcountbt_from_disk(ip, dfp, dsize, broot);
 	return 0;
@@ -748,7 +748,7 @@ xfs_rtrefcountbt_create(
 
 	/* Initialize the empty incore btree root. */
 	broot = xfs_broot_realloc(ifp,
-			xfs_rtrefcount_broot_space_calc(mp, 0, 0));
+			xfs_rtrefcount_broot_space_calc(0, 0));
 	if (broot)
 		xfs_btree_init_block(mp, broot, &xfs_rtrefcountbt_ops, 0, 0,
 				I_INO(ip));
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.h b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
index a99b7a8aec86..aeef004ffdc9 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
@@ -129,7 +129,6 @@ xfs_rtrefcount_broot_ptr_addr(
  */
 static inline size_t
 xfs_rtrefcount_broot_space_calc(
-	struct xfs_mount	*mp,
 	unsigned int		level,
 	unsigned int		nrecs)
 {
@@ -148,7 +147,7 @@ xfs_rtrefcount_broot_space_calc(
 static inline size_t
 xfs_rtrefcount_broot_space(struct xfs_mount *mp, struct xfs_rtrefcount_root *bb)
 {
-	return xfs_rtrefcount_broot_space_calc(mp, be16_to_cpu(bb->bb_level),
+	return xfs_rtrefcount_broot_space_calc(be16_to_cpu(bb->bb_level),
 			be16_to_cpu(bb->bb_numrecs));
 }
 
diff --git a/fs/xfs/scrub/rtrefcount_repair.c b/fs/xfs/scrub/rtrefcount_repair.c
index 2b939960c7dd..c78a6d2990c5 100644
--- a/fs/xfs/scrub/rtrefcount_repair.c
+++ b/fs/xfs/scrub/rtrefcount_repair.c
@@ -596,8 +596,7 @@ xrep_rtrefc_iroot_size(
 	unsigned int		nr_this_level,
 	void			*priv)
 {
-	return xfs_rtrefcount_broot_space_calc(cur->bc_mp, level,
-			nr_this_level);
+	return xfs_rtrefcount_broot_space_calc(level, nr_this_level);
 }
 
 /*
-- 
2.55.0

