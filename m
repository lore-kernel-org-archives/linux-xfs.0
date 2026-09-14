Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9F9351C0B
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 22:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789425021; cv=none; b=RhSAl6ijenEwpHFxeSr4SeQnP00kMkg8qZQqSFQMsJ9/1duqhdzPoHtoND4KpAnH5abqaWUEqViIcdZc5xBgtsYIbnAk9aIsLVUttRaAgqvfeapKIoM2k4SPL817/IEfYk9YrT1+xqm9rowqwZ96wRDlYJspEWTIkp2CACS9PrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789425021; c=relaxed/simple;
	bh=wihcWxG8FxVKUyrLfVjD0Veh6PyHeCI14uk6XLuVw14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AeAjQnwdVQWhf1Gsq1YMbSM8utollPEWrr8K7JD4xFz+dQISDLakhmrpSADvoNV8yPQ9lnN/5LfqxkBxWfj6OHXZUs/z7BzRBEzyH7TM6kP5nPQ4QyKItGjPPLPUGh0//XlphEbAxPlFt5ZOmox5BKXtFaYZvpQgRjmD8yEP4es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bck+vbJj; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=JopUlOGp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bck+vbJj";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="JopUlOGp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789425018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NJi0RuqbB12lQav29CeiZY445EZN0sCWiHXa8/hIbGI=;
	b=bck+vbJjLf502NH8Nd1xHAIAlcsXESvyG6oQrJizEjHL3HJT72q0FeCZH3prjj2dsfv+Dn
	InqFAdGcsAXel71GA44Y+BXDxnGIb02FephyIETPY8oNXeeJxRcgICtBk12WJF26Ukz3tx
	gEQy22BB0KYXjmuD71X3cv1gtoO2SnE=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-692-3v6Z42gqNwic53aSNWj-yQ-1; Mon, 14 Sep 2026 18:30:17 -0400
X-MC-Unique: 3v6Z42gqNwic53aSNWj-yQ-1
X-Mimecast-MFC-AGG-ID: 3v6Z42gqNwic53aSNWj-yQ_1789425017
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-530d028f779so43418981cf.2
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 15:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789425017; x=1790029817; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NJi0RuqbB12lQav29CeiZY445EZN0sCWiHXa8/hIbGI=;
        b=JopUlOGpQQleUSPEoMVWigHhPdSwVS0HwSJD6SA1fX2L0waxM+J79vnywQgfi7m+N2
         hdkF6JJd3lY7wyWoM+BOacH1VOFLQW73VhHfQunB8wVazm/xxraIIMSUoUhNoXWvPeu0
         ANr882AvMhwVeGFg5f7yKV4m9+OblboZk8i5hk2wo8BKf5/xJU/6YsII8Gr0seEvYFsM
         oBW8uy5awYuVRBmPcdMcq0UyvXAvCx2fHA6H0rAWg8ergF9vyVWx33swAqo95k2yCuqc
         bE5Ualdf7SUXwFTLMe7UqY3OEA0VnH+RIzBFyHEhAo/cTFN2pG+eLeQhY1qmKH9mtAXY
         S6CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789425017; x=1790029817;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NJi0RuqbB12lQav29CeiZY445EZN0sCWiHXa8/hIbGI=;
        b=ZhnHq1Ibt8mjWOQA8DqrbeRFgMPjQdOl68/aXtA7hF2FvPyF2d/Hm6hyH4j+Mh1v07
         ICe73ghf2Fkj5xVFwRKkdL393qqAWBdF+Mg3Ni9TSoAc5fpu91JiMKIuOj8gUbjc4XiF
         EdPx+VcvHV3z/xuFc6BrMrObOQXdsD5OkbyAXJSHJq4B1CSzvcufd4/zQrYHDVGRUr2w
         UgyY6Daazmp66ISd7XXAjVnIDYUhv3Z1UqydG+yUJFtgVmB2Lbi55tz9FacpZq9sGgn6
         9oiFzUQzm8pps+TC/qx9EuQ3khyJx6lGvEMZHc9UpIxyXck7NNQ+BkaFDj2o5JBiSb6K
         WjeA==
X-Gm-Message-State: AFuF++nG7l7YimVvLwsF/QA6xYUtftWn3SdrBn8AK2CYu57QzAhu+eeG
	x4pMKUjfHv/2ufbT7/Oyz+h0/tkz50xHaZ5pNFmtvW3A/E7aHyop5Uyts88UEKaNri9U0iBrUlN
	JFVrXnBTBpeVFMKLhoLIvRosis6YA/fbyn2JhS1tVKs1TCZpuj7BZl9/1yGuy1IEw02zVqwKD0c
	80xutha8rICVh1lkzRlFpDF/uVIajNvozxYRrAkvMc6gfMqNo=
X-Gm-Gg: AYBFou1M/ACUTELIfUAgGjHTusVXYypEoX/vph9RuvtsUc7Iz+S4M8SBGU0o5RsTBow
	aAMyOhwcLXsfKi+gZsaHbyhHjVLnr6+kw2KiBiTh4Hw9dDGPHJ7dvz73ytWA4T8rWzuTAQNUmut
	q8OsyymQTkqdqAT6Am45RtQ4ntv1n84cxMzwmHMXul0MX3E2E6dbVkg0kr7ATBDm0Y5wrGOMJ7j
	wGYTGb1NC7fjVNs5Rq9R47HKgadlIhbChyosyGOt3QS2BEckPvFMBNaoOoxBPZLQApeRQhW1QAb
	ZiD8xWUGs8UKOd3bS7fy+rg4PIUV+COUJ0CvYLJZIWxe1pYNEENY+dnAD4LI32BDLnS92QkRmrq
	5UUoVtdbmaP1aM2l2xN5JI1GNapj7uYxfcX6cjQ==
X-Received: by 2002:a05:622a:a1a:b0:530:e1b1:eae7 with SMTP id d75a77b69052e-5310d030f64mr69745071cf.47.1789425013335;
        Mon, 14 Sep 2026 15:30:13 -0700 (PDT)
X-Received: by 2002:a05:622a:a1a:b0:530:e1b1:eae7 with SMTP id d75a77b69052e-5310d030f64mr69743561cf.47.1789425012281;
        Mon, 14 Sep 2026 15:30:12 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530fa03dc30sm56084041cf.15.2026.09.14.15.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 15:30:11 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2 03/14] xfs: remove unused mp and ops arguments from xfbtree_rec_bytes()
Date: Mon, 14 Sep 2026 17:28:49 -0500
Message-ID: <20260914223007.1587017-4-sandeen@redhat.com>
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
 fs/xfs/libxfs/xfs_btree_mem.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree_mem.c b/fs/xfs/libxfs/xfs_btree_mem.c
index 1d83a4251cee..3d5c7a014d4f 100644
--- a/fs/xfs/libxfs/xfs_btree_mem.c
+++ b/fs/xfs/libxfs/xfs_btree_mem.c
@@ -73,9 +73,7 @@ xfbtree_destroy(
 
 /* Compute the number of bytes available for records. */
 static inline unsigned int
-xfbtree_rec_bytes(
-	struct xfs_mount		*mp,
-	const struct xfs_btree_ops	*ops)
+xfbtree_rec_bytes(void)
 {
 	return XMBUF_BLOCKSIZE - XFS_BTREE_LBLOCK_CRC_LEN;
 }
@@ -118,7 +116,7 @@ xfbtree_init(
 	const struct xfs_btree_ops	*ops)
 {
 	unsigned long long		owner = xfbt->owner;
-	unsigned int			blocklen = xfbtree_rec_bytes(mp, ops);
+	unsigned int			blocklen = xfbtree_rec_bytes();
 	unsigned int			keyptr_len;
 	int				error;
 
-- 
2.55.0

