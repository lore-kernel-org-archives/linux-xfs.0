Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD143356778
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 20:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789419153; cv=none; b=MEd4u70uXDUlf6bpuwAvAdqBJiIY4ZPKO1UBJAMHvI4VlKD5hyYisOAXs6/MjPXl1eO40FRlGX1t1C6XRIYz4jdGFCju9ts9rAF0GDvXK5kTKAVsT2lEpzAOZ9ko8OtK7c2QzNbFxzDLq4RWfxvYDO2t8mYaYvtseRwjL6jZOz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789419153; c=relaxed/simple;
	bh=BiAnJeKw2QwRcDtp1z4Uz0jCBgEpTgyfqDNACBGK2Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujrz9Mulmob1u3iooTT9N0qa6+b6YiLT00MHdPnbfY+lAQmw0nJUl8XUBSullLgHhZv6zgsMrmUaWePfxeOagKHFz2FctzVxIYR7YlQnIS049QB1nM7hUrJGesNbT91hoMG8m+Wg6jj4X2gKpxSzB4FnfsDX+muPzEoF3KG+aO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rx3oJpMs; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=N7YH9DS4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rx3oJpMs";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="N7YH9DS4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789419150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yAOp7XKALD0CClNk5gXeMpaXQmoGGavTz5udWZ4Q7Ls=;
	b=Rx3oJpMs5x8T/VPYX8y8CrgQET1ovfvxtxor//1QRUQPY+yVB/sMuiuD0w13dH2NA/4dAC
	vLpfLjuqRIIr+A7NpZOSssgiJncrk2u6PuPN5FYDZ6IpjESOwp9hw8lsoyLuPQtTvTdeKD
	dbBGt4fphPf7d1Dw/3ZqEizlfvlN+n0=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-219-SA8CYoFyPF6qUFdpuQrQfQ-1; Mon, 14 Sep 2026 16:52:29 -0400
X-MC-Unique: SA8CYoFyPF6qUFdpuQrQfQ-1
X-Mimecast-MFC-AGG-ID: SA8CYoFyPF6qUFdpuQrQfQ_1789419149
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-936e393061dso599248085a.2
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 13:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789419149; x=1790023949; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yAOp7XKALD0CClNk5gXeMpaXQmoGGavTz5udWZ4Q7Ls=;
        b=N7YH9DS49Rf+vYflBzrqdDhkM/g4x4MHMFy5M5ktHugIZJoanb6Ugb4PRirtKzXtWV
         82Ap5W4ycxHiOC8DzIXLy2nv+vstV47oAqIcB6GUPUGFTftymxQVhz3v6Ht5SmaaX+qA
         o4E7cGVVs672KRDhORJIP0bqoSMsikjCYF0wYuKMLXIvy+8v0hnnBomlG7izpmniTbal
         Q+rLR1qhOPwYARiJjsGgAmnm3+CdqFnwUZAMHbWgRKsgB/11hiHxGMVeiUGf0MGzPiw4
         nZX1F/ZOB3FTU0w16qE5l/0Za/tAK3T8a9mBiXtmZsS+8tsHwpmJfCiscK48loE/1muX
         ODLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789419149; x=1790023949;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yAOp7XKALD0CClNk5gXeMpaXQmoGGavTz5udWZ4Q7Ls=;
        b=DtcEpQjd05kh16eNb7QNahh+LLxrUTQveMUa3eEiqqFcaEzSYM5cKEP6XJeUTKKUzH
         6kK2bvjq1liacrYGjQwYvTdqtmh6legc15iSARvH0Em8S+zCBmfpLm5dwzAK2x49uMEB
         qBRuhkRJwJSHqHBqyvi5KhUvqH06lZ/qCVlGNCNawFRV3cEggZqtFFcCyXkFi1TWFA4e
         Cefv2mnE6tlKNdxs2lwT+FMd5AzbaVCiwLplJMQcI9syNr3G8Gqg2rD39reLM1ekZTQD
         Dk5aTT/91U+y++up9QTqGETTgKFS54eOJ8T8OUVUk15d7S7IpmCvSGouym3h3UauzkNP
         PbNQ==
X-Gm-Message-State: AFuF++lnYjLsPOEV1U1ONIykJXGeZSb4WMAxAVOs3nCgAwE58o/r6kN2
	jKWKM+jSy28FETNcRZiRbxlUmslet5riMte+QIHCy5KX6cgVwl2IhPLeb16s2Al5f7A2k5ZptV/
	+jHfem/k3VfuIE7+HZmagxmvHROFv7qswgdJYSRuibzF0k/wqQfWklr3NOP6/lCubFWZZXKzkJL
	JVCPjMqAXO/m0MyvsPx8SaFaFqYpERcH+y/4Dyk+x1rYbmIMc=
X-Gm-Gg: AYBFou2YxyJF8wkQ0XdVohw5IYfDWJ9tkjONJJK8QzcarFyU8O/QGtdMGuD4tXZjOs8
	NdG+hyhP8R6VwmZq56uBZfX6dOlBnJlxHROEjdGSEHV3EyevETQfVXp2fbvyf+2uSR1PrfU/Q5r
	drvofsIljqhC2vtbHnGO3Llkr6cTP+gMLcbIPeX8zZQ8q8vbxeQtCoPuXsIVLjRCpqhIQ8VwRSB
	vWBT38+1ulY2Ni0WG/E50d3eJws/zA0bSqMZYCwTm7n6oANLrdgLN/Gg3kDg7DcH9puzpTtbOos
	WM3IYKG/wdvgn9gmZxY9TsH5MgvVS6JTHL6XNlhzHpZhnZBgb25IrFQcFnVxzUazEUXMpS10BlR
	haF8DeqpkBYDJdqBRoJnzf71BOiK9h66qXcOhNw==
X-Received: by 2002:a05:620a:649a:b0:939:6dea:374c with SMTP id af79cd13be357-93a29bf903emr538649285a.48.1789419149115;
        Mon, 14 Sep 2026 13:52:29 -0700 (PDT)
X-Received: by 2002:a05:620a:649a:b0:939:6dea:374c with SMTP id af79cd13be357-93a29bf903emr538641085a.48.1789419148323;
        Mon, 14 Sep 2026 13:52:28 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e7f1da12sm1099236785a.9.2026.09.14.13.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 13:52:27 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 05/14] xfs: remove unused mp argument from xfs_inobt_rec_check_count()
Date: Mon, 14 Sep 2026 15:46:10 -0500
Message-ID: <20260914205221.1516254-6-sandeen@redhat.com>
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
 fs/xfs/libxfs/xfs_ialloc.c       | 2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c | 1 -
 fs/xfs/libxfs/xfs_ialloc_btree.h | 5 ++---
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 58dac4d505ba..19b513b11692 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -615,7 +615,7 @@ xfs_inobt_insert_sprec(
 
 	trace_xfs_irec_merge_post(pag, nrec);
 
-	error = xfs_inobt_rec_check_count(mp, nrec);
+	error = xfs_inobt_rec_check_count(nrec);
 	if (error)
 		goto error;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 1376e8630449..1f0bace2f144 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -687,7 +687,6 @@ xfs_inobt_irec_to_allocmask(
  */
 int
 xfs_inobt_rec_check_count(
-	struct xfs_mount		*mp,
 	struct xfs_inobt_rec_incore	*rec)
 {
 	int				inocount = 0;
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
index 300edf5bc009..e04c63c66f39 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.h
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
@@ -57,10 +57,9 @@ unsigned int xfs_inobt_maxrecs(struct xfs_mount *mp, unsigned int blocklen,
 uint64_t xfs_inobt_irec_to_allocmask(const struct xfs_inobt_rec_incore *irec);
 
 #if defined(DEBUG) || defined(XFS_WARN)
-int xfs_inobt_rec_check_count(struct xfs_mount *,
-			      struct xfs_inobt_rec_incore *);
+int xfs_inobt_rec_check_count(struct xfs_inobt_rec_incore *);
 #else
-#define xfs_inobt_rec_check_count(mp, rec)	0
+#define xfs_inobt_rec_check_count(rec)	0
 #endif	/* DEBUG */
 
 int xfs_finobt_calc_reserves(struct xfs_perag *perag, struct xfs_trans *tp,
-- 
2.55.0

