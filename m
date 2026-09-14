Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD37237187E
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 22:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789425021; cv=none; b=l40HUnf4v/G4HU52xVSzU0oVVunJlr/VbuSk2fVZ0KkzmlbT4ZSa/CkfWnpre+rFpgq8uZ9z8rVrp7L3iAusdtKUDbY5clGKbB8LAiK1kTSyd0XRYVy2lYIc4VYcXqPFACX2+ks5rqmvm3WOnkA+IMXulrw4I3OCBsUDG5lYRZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789425021; c=relaxed/simple;
	bh=b60YzEB2H/rbdcE72wxmPmelhWRKxWNgAZElpkpDyjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2kN2jJfsYSnNNcIo1sOrxEhmrSZHHIJj5FwsGiLNZ806pmcCytCIqM8HDptN9q/OpL+mhTryhLSf0uJddwgYsaX2bZvt28+OCH3y0wa0J7X0PfvVBQeucrIH3edsrpQHoeGtMxVqCLOw0I8VcNML2mhRzm3fbnFqNtK6VqKgcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NPbUqFtq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZTjULtmJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NPbUqFtq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZTjULtmJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789425018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5LWE/FCt72EyvG3VPp7sUnuuARvoCHfcap6Prz6l09Q=;
	b=NPbUqFtqVsEacvlZpleAYIRYUXQINXeGi4ZaqidLR8juXcl4tsEa4UEqJL+TrAwDydVmQz
	t6u6ZDNrS6EteomcX7E1FhsBhccfYaraqGR6UHLnRLfXsyj32ioiRg/D69knpMKnhzN+Lu
	y/C+xeISgCgXVz164dQUsKfaXPhoJr4=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-30-BC5WPjUcNUyxNFZxuaivWw-1; Mon, 14 Sep 2026 18:30:17 -0400
X-MC-Unique: BC5WPjUcNUyxNFZxuaivWw-1
X-Mimecast-MFC-AGG-ID: BC5WPjUcNUyxNFZxuaivWw_1789425017
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-530256c61b4so79998741cf.3
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 15:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789425017; x=1790029817; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5LWE/FCt72EyvG3VPp7sUnuuARvoCHfcap6Prz6l09Q=;
        b=ZTjULtmJX9TKdB/UwjHmp0G939zTCAcZXQwszguTvpB0DCpfvxSppNo2/Akl3bej0k
         fhwCB0+UovbNJAzxBd8cRHpIxiHnMlKQSLntCuKtDy0TY7xqVAeEdvKGpbYNJxQX02X2
         EHAD8CNeKnyuKsu2DZ6CrTEUkL+u/tg0dHtZMRmP/SmPJ2ywlfQqmoNj90rTbS8Cjnv6
         nz7fdN7NoLILPI9VvCxA4Fi+85nj/tjflYck9V+rolh+QqXygqpO+nsyDWMmXaR8+EIt
         ziJYUxzGMu79XM6oOwziLmLpufBJhmtbtt01DjUTXXlwcsUOrjXcubHWgsScVfuJenTo
         MwaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789425017; x=1790029817;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5LWE/FCt72EyvG3VPp7sUnuuARvoCHfcap6Prz6l09Q=;
        b=HFlvKRA9hCLwEPxDnGkcOnEG/JaFIm0uhBSCsCJNaQ/pzk6yYadcaxKSQWoHOoGtml
         T3iv/HqpTnzBAlOE0mJwiPR3HkpyYAST6ns07Hz+BLEimfd5PLd9kdz/64rwATVqibtt
         aghu6tAL/6SMocCeKC3juSvurGqyLydRJyxaeB3zTw1zVS19axPc1kkCuyhkuTet5LeR
         YYm85OxJ9Gew/k22B0aBTbG9J8aTXZ8BRA7Jnt19YScBzrJK2GWGjg47M9p1Cv6tp8tM
         wbqakAJV1NMMmHCl8K3wZB7xhDiNGHtAU+cjPHBR06zbZjuZ7tC1OtGc6DD5mxL6zFK1
         L2ew==
X-Gm-Message-State: AFuF++naYItKWrVkqZXRi7bg9kA0PzxYWRWBlGKyjWfWdK0kZS8FRrfL
	8SpBI550bMVJs8yCk8yrPwfqSefvV6vhA19G36vHtKB28//E5nz4TacMHHS47UPE0xCQB013Xza
	mCPLtl4SSAY3uMo7CzD8LScwM4fSX8iLDHf4xTdoFA1IHS6hz8n29RDOqFABjSn7N+bKlXCBDBR
	ZZO2EotqJ6S950MSbr1e+p0b9E19qcYlDIPb6GEt5KIrLUI4s=
X-Gm-Gg: AYBFou1PYuS5LqHdX3eOxBpXTC7BQ9Q4+vVAbp55sdUIqnY45QxVpLPRxagcYfU/OQj
	D1mNNuu2uUfU2JMA5moFVbDUdc22psTbDXWJD3rTK8evGHn0VPCmXSYth//l3JiM1b/2jMbQqVp
	YkB0iIm6lQ21al9UrM7W7LWuhGu0r5pxo9x83wR5BAk9T5OB2wQ+qhyXh72dA+xYg/34XO2cHVv
	DxSFKwnyvvLu+Zy07PbF4gGCDLEpR1kZUi6UNXFc0NVy3LYbIjk37bz+IPyVbiAvLkzApPSE1Zg
	nHsVRiDtyq2VixH/IECj1gXzl+nCRjhl0UeCPoWWirT3EocK11/17jfKUIGDvRP89cgXHkg1EqE
	JJYWhrfn8dHVnI122bR2DAPCSWIW0vvMnDXSqXA==
X-Received: by 2002:a05:622a:48d:b0:530:42e5:f3a3 with SMTP id d75a77b69052e-5310d0316afmr68407941cf.44.1789425017132;
        Mon, 14 Sep 2026 15:30:17 -0700 (PDT)
X-Received: by 2002:a05:622a:48d:b0:530:42e5:f3a3 with SMTP id d75a77b69052e-5310d0316afmr68406891cf.44.1789425016549;
        Mon, 14 Sep 2026 15:30:16 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530fa03dc30sm56084041cf.15.2026.09.14.15.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 15:30:15 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2 07/14] xfs: remove unused tp argument from xfs_rmap_update_hook()
Date: Mon, 14 Sep 2026 17:28:53 -0500
Message-ID: <20260914223007.1587017-8-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914223007.1587017-1-sandeen@redhat.com>
References: <20260914223007.1587017-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_rmap.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 34d218de21a9..37780a0526d8 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -904,7 +904,6 @@ xfs_rmap_hook_enable(void)
 /* Call downstream hooks for a reverse mapping update. */
 static inline void
 xfs_rmap_update_hook(
-	struct xfs_trans		*tp,
 	struct xfs_group		*xg,
 	enum xfs_rmap_intent_type	op,
 	xfs_agblock_t			startblock,
@@ -952,7 +951,7 @@ xfs_rmap_hook_setup(
 	xfs_hook_setup(&hook->rmap_hook, mod_fn);
 }
 #else
-# define xfs_rmap_update_hook(t, p, o, s, b, u, oi)	do { } while (0)
+# define xfs_rmap_update_hook(p, o, s, b, u, oi)	do { } while (0)
 #endif /* CONFIG_XFS_LIVE_HOOKS */
 
 /*
@@ -975,7 +974,7 @@ xfs_rmap_free(
 		return 0;
 
 	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
-	xfs_rmap_update_hook(tp, pag_group(pag), XFS_RMAP_UNMAP, bno, len,
+	xfs_rmap_update_hook(pag_group(pag), XFS_RMAP_UNMAP, bno, len,
 			false, oinfo);
 	error = xfs_rmap_unmap(cur, bno, len, false, oinfo);
 
@@ -1220,7 +1219,7 @@ xfs_rmap_alloc(
 		return 0;
 
 	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
-	xfs_rmap_update_hook(tp, pag_group(pag), XFS_RMAP_MAP, bno, len, false,
+	xfs_rmap_update_hook(pag_group(pag), XFS_RMAP_MAP, bno, len, false,
 			oinfo);
 	error = xfs_rmap_map(cur, bno, len, false, oinfo);
 
@@ -2721,7 +2720,7 @@ xfs_rmap_finish_one(
 	if (error)
 		return error;
 
-	xfs_rmap_update_hook(tp, ri->ri_group, ri->ri_type, bno,
+	xfs_rmap_update_hook(ri->ri_group, ri->ri_type, bno,
 			ri->ri_bmap.br_blockcount, unwritten, &oinfo);
 	return 0;
 }
-- 
2.55.0

