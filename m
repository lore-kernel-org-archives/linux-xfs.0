Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0054C503BE8
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 20:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788467828; cv=none; b=BsLKfv/Yx5gc5pKRDAZkostuGzKJcVFlIg++ZBw7knpPJB4oONzkOiA0A89lP1YukqlCQRXEVjLtUrS55IjgmX5S68Em4CNRNCdp7YV8Gr2oXgIO5aHWOe6rXAqxzJ2Q3IALD6b2Uvu2v3Ih/2pHtSGm8SdjI2sd4EjH4GpP28Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788467828; c=relaxed/simple;
	bh=gxOBxTYWv6L9HWipuLsNwxZdRtgPhnolnfE55wMMTf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QKdx5NpX1IVL6vlFtDlRSquqH3a/57cyV4glhAbSwYvAOeKnvbai/A8waGNbr7yzRPgbKYA6BeSlqwHkqzVf7wiWeN5fXExyJsQr9mkw1l5f/cETbf5eWpXZR/fXGrDRtv8eVjpnkKa7YHKv/nVaIuOHWKxYTRLB+iWv228cS1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J2YWuv52; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=s+qNkQNg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J2YWuv52";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="s+qNkQNg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788467806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ly9bOD5QlbudQQjjiJK26q9tAgqX3o5t2IT3nbj9FL8=;
	b=J2YWuv52HP76UFHZt9lbQi2pO2khtcRN+/e6svhe4rMpdMAVHfUXw6w4Zy8XdWHcdr/Kyj
	QXCTglOy6GWPztEJyBchMvhI9ZrbXMH5le1mvbjuzHNpES6icoeVhMmSZqd1w4rCG6UujC
	iJ1FCPhDjtESx6o2DerauTeiT1+b4fo=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-EiYoI5QsOlaOkNYHYRRtrQ-1; Thu, 03 Sep 2026 16:36:43 -0400
X-MC-Unique: EiYoI5QsOlaOkNYHYRRtrQ-1
X-Mimecast-MFC-AGG-ID: EiYoI5QsOlaOkNYHYRRtrQ_1788467803
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-939665a1ae6so63260385a.0
        for <linux-xfs@vger.kernel.org>; Thu, 03 Sep 2026 13:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1788467803; x=1789072603; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ly9bOD5QlbudQQjjiJK26q9tAgqX3o5t2IT3nbj9FL8=;
        b=s+qNkQNgo8lsOK0teCsRjQgrUeYX3PYWGn9+3DsvwvQT4yw8UrxSjQ38JDfgoGbXJH
         gBHplevfOMZkav7EWtoHxUc8xyaxIDHBrfU51AEpP4/viSBerXm1RKhYUfGSFK1SI8mK
         9fRLbjY6cE0C/gLrumgkRE55XhKcx7U+QH9L9vEyBMvJdYWL17vu7lNrQxQNUPs6ZrcD
         jj7HfvmwbuJtW7tkd+qSgRlHZzxEOah1h4Ey2f3PG5rv/C7jbz/A+o6mvvwUjGlQa4EJ
         2Bpu+1Tbby77osO8V0ZlzRdzu8ye0YaAMzod0V4BlsgsjFy84NEf31kO8ghcntOOOoQ4
         5vzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788467803; x=1789072603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ly9bOD5QlbudQQjjiJK26q9tAgqX3o5t2IT3nbj9FL8=;
        b=c7BMX/SVsR5t9vhref/1c49V+ReL5J6u4j2fmZMcC7/SK6Im4UWqcdx3uwL2x5Nbt5
         qihnScxmZXe1GurBYtbkiWwLEC2iUV9/b3RK6BNvtlDwLoa4FO4p/qq0urx2W+EbwaLx
         fEFlqZPIyOMV4clDaSXYG6i7qN/fO5KVfcmRyax7wv1QeJ23DMi/A2XvJoKeGbBJ2Dd6
         o9ObohilI8XUsnR1+eNcffaqVdxh0vUK66DWHPbqj0p2zV32/iotKEDFkIler3hsPEA4
         m5LfZYFKaJC9HezCKdncwCzyXbjetWNPKf8CWKIey5qukB9a1DnV2r5GFjYIBT4O4407
         g7Lg==
X-Gm-Message-State: AFuF++kP1peMOz37JIRjR+KW0FxXNo7DaBK4Z6FuRfjT8DNQvQpO5g9y
	LmuP1I50IZ1XS5sT/ikfJsWb7rowEXQFmLXQXVDG0IO92vZP6yfxP2LQFVqAUleU5Mj4Xu7z9sU
	JW23B6MK2HIzCv1F8mQU3pekX37Np4KqUTv+9oR183uGvzaMWOsAREK8ZfaETAGee77txGGiCim
	tohY+VkpsPijSRZZxDYpA+bs6C4I23wT1Yxu/zVQG0kQIj
X-Gm-Gg: AYBFou1BmPdyMPZkb+mm6Zb6PnR3K5FNlA/C+kOwGIWaBtQ33v5GQn0rbi6LGdKiVas
	5sIPE+QnxZCkNKBDvedSac4OM74o51O+FUJXN3yv4Abt2r1d1LuWEwbltU5gEuCCi72gn9fONj5
	O40qHVp4dyc9nftBrvPmsMwGgRVWjKKHLnL+dR0deiCveNUaa/9dbCFOJ+3oycBCJf06g3hbbvF
	gA724zRkM45BZPeE1kwvsX99lYW9IrisJ+HDSQHGEUi+kvJsxtsOmJEQLdbws3XmsR2698RRwiB
	/YrYkT9klLGucej1Rj3BQRNROIF3agVYFpGoXfXwuQ9SE87OG3iyamknhddr/sEBEjapz9krNnW
	hpAQTBVn3ACpzFuuKVRiXWmjjEnc/ghnRXYr3Kwj5
X-Received: by 2002:a05:620a:17a7:b0:939:57ad:4586 with SMTP id af79cd13be357-93980360d91mr136027285a.16.1788467803165;
        Thu, 03 Sep 2026 13:36:43 -0700 (PDT)
X-Received: by 2002:a05:620a:17a7:b0:939:57ad:4586 with SMTP id af79cd13be357-93980360d91mr136021785a.16.1788467802585;
        Thu, 03 Sep 2026 13:36:42 -0700 (PDT)
Received: from big24.tailafb26a.ts.net (97-127-68-83.mpls.qwest.net. [97.127.68.83])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9397faf927bsm51152485a.8.2026.09.03.13.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 13:36:42 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/2] xfs_repair: do not allow cache growth to overflow
Date: Thu,  3 Sep 2026 13:42:44 -0500
Message-ID: <20260903203638.1094907-3-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903203638.1094907-1-sandeen@redhat.com>
References: <20260903203638.1094907-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Nothing stops cache_expand() from growing c_maxcount (via *2)
repeatedly until it overflows.

Add a bounds check here and return failure if for any reason we try to
grow too much.

With the prior fixes, we should never get this far, but it's worth
defending against anyway.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/cache.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/libxfs/cache.c b/libxfs/cache.c
index 21e4c0c0..2339fa7d 100644
--- a/libxfs/cache.c
+++ b/libxfs/cache.c
@@ -79,16 +79,28 @@ cache_init(
 	return cache;
 }
 
-static void
+/*
+ * Double the cache size limit, and return success (or not)
+ */
+static bool
 cache_expand(
 	struct cache *		cache)
 {
+	bool			expanded = false;
+
 	pthread_mutex_lock(&cache->c_mutex);
+	/* do not overflow c_maxcount */
+	if (cache->c_maxcount <= UINT_MAX / 2) {
 #ifdef CACHE_DEBUG
-	fprintf(stderr, "doubling cache size to %u\n", 2 * cache->c_maxcount);
+		fprintf(stderr, "doubling cache size to %u\n",
+			2 * cache->c_maxcount);
 #endif
-	cache->c_maxcount *= 2;
+		cache->c_maxcount *= 2;
+		expanded = true;
+	}
 	pthread_mutex_unlock(&cache->c_mutex);
+
+	return expanded;
 }
 
 void
@@ -378,9 +390,8 @@ __cache_node_purge(
  * hit, in which case this will all be over quickly and painlessly.
  * Otherwise, we allocate a new node, taking care not to expand the
  * cache beyond the requested maximum size (shrink it if it would).
- * Returns zero if hit in cache, one if a new node was allocated.  If
- * allocation fails with a genuine ENOMEM we return -1 with a NULL
- * *nodep; in every other case a node is returned.
+ * Returns zero if hit in cache, one if a new node was allocated, or
+ * -1 if a new node cannot be obtained.
  */
 int
 cache_node_get(
@@ -494,8 +505,13 @@ next_object:
 				ret = -1;
 				goto out;
 			}
+			/* Fail if we can't expand the cache any futher. */
+			if (!cache_expand(cache)) {
+				node = NULL;
+				ret = -1;
+				goto out;
+			}
 			priority = 0;
-			cache_expand(cache);
 		}
 	}
 
-- 
2.55.0

