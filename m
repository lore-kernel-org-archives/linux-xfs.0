Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD0E384CD4
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 22:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789425024; cv=none; b=SbpPc/ldbdgow4V7jiUfb1FRM7csu//d4JYlV66K80TCAjJnQxOo8JP+b3GAg4feJbpedwQkIfmAbOT0ZYrlHTiU/d3QoWiwzbLudEaDySYxtrM5trrJUavf3oap8fu3IRtaw1K1ZdL2or2oWYhM/7JVlAGeU3GZCxjBejYQMAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789425024; c=relaxed/simple;
	bh=RxPcYhW5l9PCRDb1CPFcK5EJ0bHnBtp6ZP0dIkG6buA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NocYTgUqwTku+lNc9aOAaq5NtwvC7H/tFMWbOtPMqgjrIFeL1JTJ3htYVbBEWB/icBSqcHzz3veb2GGn56ln4ShizEOmIkuhQHIYyVJzDpYEaOGgmAadaO/nUhxJ3Y4/aQNOaifz0USc3J80WjGbRgz538XsWO2sGShXVoR1GdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MzmtpwIv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=I4i9r824; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MzmtpwIv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="I4i9r824"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789425021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qPNBNitSa7DNDmq2ippfvEGpz+tL5r+RNIEZAU1+ScI=;
	b=MzmtpwIvtnM3Yyy6JRx5zBpNJbkn3BZskpKm51bNX2ua63T4QbmJwn9hlK/YZMvX7bX+kt
	pHRytA+mr2O4xdF/fudZB1jURzGv6XYD9VCWMNPnCKbgV49Wn3L/fHUKf4GZGF6nJPX/Di
	MhempCoBO+T62toeIoNAopN3eH4zfc0=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-365-N2BG_wZAP5uSSFfgs2YYbQ-1; Mon, 14 Sep 2026 18:30:20 -0400
X-MC-Unique: N2BG_wZAP5uSSFfgs2YYbQ-1
X-Mimecast-MFC-AGG-ID: N2BG_wZAP5uSSFfgs2YYbQ_1789425020
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-52fc3bff8bdso78701941cf.3
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 15:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789425020; x=1790029820; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qPNBNitSa7DNDmq2ippfvEGpz+tL5r+RNIEZAU1+ScI=;
        b=I4i9r824B5GmweJcJlD99xq0U4ilyyNxG/iSSSSEDk/xTdZ8i4G8LRXytdvvNQfAHx
         tzy5Z+Tn5My8boOLybNfXztlTOWlFf8Pn1McYwk0KGJjVg2lvjBOWwg55qkq0SVZRKNY
         TJpZmyjTr4ERS+zBiagaYvDs8FaVgyWuwYMA2QxU1qr3KDpzf7BJ/JHh4UXeU0X6NbC3
         KovR3uBM1Yg9ty8U17K0+vbTlEDKD4xW9NrgOLyi9diIxI9wxI1qfyN/cvRDs0ET37Ue
         iZ91BkOmLNCI84HmgJBw+/9083DrPQDarUhK5UcqhF1V8tZAav3yXVQpi+myncko9eJR
         1kKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789425020; x=1790029820;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qPNBNitSa7DNDmq2ippfvEGpz+tL5r+RNIEZAU1+ScI=;
        b=cDNewMAJk7dqPC01knpJkLM0uYmmmpqFA1x7i4FNyvt9hhvYuRCfbxfFmHCVDVPlWD
         9hkLc7HwRQjAdFh5YOT/lT/y9y8f0a6pkGDAcw2BBnLMd0xJUzu9LWm9jmiaHHHyz/SX
         PCQv9iq18zM2BQu0sQhpwuDspjEOxqXDuiJsf3EAAZAcQMS8T76HpAfZVKkWza8IPJ5Y
         eGrhFCi5CFn5XGQpDA4kWpwGl86ihyxSPH/0sLt1xdTBXANx2NAF5oY+gTe8ZieevbUh
         VSnLZKsHgvVyYEOeVjZpVvD1lG/zuqeyxsNQ3yxrCNkVFWwKHYho7lHkFHE5iuQ3wst6
         NAVw==
X-Gm-Message-State: AFuF++msm5jY27Ha81uQXF8fttNWO8ShgJv8tvrTIdx/+o9GDfChaZ5v
	BSTB9jDFy7M7pXIQqIzHfLitAyxV5ucE4i06riKOHtlMuuI2uRMGH9//bVOzt3ZkiQ6qY3I9XtX
	WB18bQgnREGbEdP9MfibtCrZIofGhbPokpXGl8FClXy0zL4KQNmlhWUcnJ+BH+axUpgRJjUkA6y
	Y+6a1N39rlnrDQFT2J9frIO01Z3WI8CW33dtU81xObiHjkVc4=
X-Gm-Gg: AYBFou0KYXNaMtQ8X5Gxii4JIEQ2epwwHektHM5eBLyzsRuCHwaReFl3R1mpIROuTsx
	U73l7YCH/L+soxas7LFSGTTkB/jf6g1azg92mslsoDGHNaDw2G5JqaCMKTj9Udlc7QLVutwylhi
	Y9k4FY7077JHxTUqv8IGNR5aZiHB7JQFSXRW+0zKUlMaIssstRxI6mG77dpvu6whO41EC48BgTC
	fCRR/lzlwCN+UhMJ84DNejBwgfE5ubcOGXXP1nnu1pibGn017bP9ErxtSaz5DjtYb2aBwWYFkGh
	ONv6kUbtEOh7bZh5z8zX4WORX3G5Z17+33uQD/1gz6DuU/FJ12pgxsapEM1jmNJbodPeZ08t8iW
	QbfZR6tU0Obl7CiruKrjrCkzXYguT+25wOGo9Mg==
X-Received: by 2002:a05:622a:248f:b0:530:b2e2:9033 with SMTP id d75a77b69052e-5310d08ebf3mr70825081cf.51.1789425019243;
        Mon, 14 Sep 2026 15:30:19 -0700 (PDT)
X-Received: by 2002:a05:622a:248f:b0:530:b2e2:9033 with SMTP id d75a77b69052e-5310d08ebf3mr70823921cf.51.1789425018506;
        Mon, 14 Sep 2026 15:30:18 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530fa03dc30sm56084041cf.15.2026.09.14.15.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 15:30:18 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2 09/14] xfs: remove unused mp argument from xfs_rtrefcount_broot_space()
Date: Mon, 14 Sep 2026 17:28:55 -0500
Message-ID: <20260914223007.1587017-10-sandeen@redhat.com>
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
 fs/xfs/libxfs/xfs_rtrefcount_btree.c | 2 +-
 fs/xfs/libxfs/xfs_rtrefcount_btree.h | 2 +-
 fs/xfs/scrub/inode_repair.c          | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index 1983c8408442..7e4ae607aab2 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -602,7 +602,7 @@ xfs_rtrefcountbt_from_disk(
 	unsigned int			maxrecs;
 	unsigned int			rblocklen;
 
-	rblocklen = xfs_rtrefcount_broot_space(mp, dblock);
+	rblocklen = xfs_rtrefcount_broot_space(dblock);
 
 	xfs_btree_init_block(mp, rblock, &xfs_rtrefcountbt_ops, 0, 0,
 			I_INO(ip));
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.h b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
index aeef004ffdc9..9ab6ecf90ba5 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
@@ -145,7 +145,7 @@ xfs_rtrefcount_broot_space_calc(
  * btree root block.
  */
 static inline size_t
-xfs_rtrefcount_broot_space(struct xfs_mount *mp, struct xfs_rtrefcount_root *bb)
+xfs_rtrefcount_broot_space(struct xfs_rtrefcount_root *bb)
 {
 	return xfs_rtrefcount_broot_space_calc(be16_to_cpu(bb->bb_level),
 			be16_to_cpu(bb->bb_numrecs));
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 42e0d7a6c7fd..cdfde3cea5fb 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1405,7 +1405,7 @@ xrep_dinode_ensure_forkoff(
 			break;
 		case XFS_METAFILE_RTREFCOUNT:
 			rcdr = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
-			dfork_min = xfs_rtrefcount_broot_space(sc->mp, rcdr);
+			dfork_min = xfs_rtrefcount_broot_space(rcdr);
 			break;
 		default:
 			dfork_min = 0;
-- 
2.55.0

