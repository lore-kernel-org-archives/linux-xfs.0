Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DB938E8D3
	for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2026 21:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787607665; cv=none; b=fOC5LI9oiR2rXWViT+/prj40jRU14H5XLhVKGEbu/x2cQqco8sSaRqOKsSfPOUfBSsINBgfWu+x41lNh7QQpv9iklTJqireY65EHqwPD1P3tb5OOhpEexvosyg3J3zKRajEv9duwCZf0pIpgRd1znBAJCQhPpbERSCaBmx4+AdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787607665; c=relaxed/simple;
	bh=oOHQ+IhhQpuBVbLqxOM/PjhyARp96b0eU8zO7j6Q8rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=liIHOsVRbjenyw8mMq49c4e7eIQl3K42xeTIHR57xjaTe2mq9V6I+0EfSrHYu5BEYLnqVa1S1iwduolZUA8D9aFp2mmkKnIZPoQ4Sa6oyV5EF0t9qO6lesqtbhcLBqt2m0KiHJaasF6wRy5f+Gd1xHKNIQV2vmJh7G7qFF3an/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S882C2+3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EDbsrUXu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S882C2+3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EDbsrUXu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787607662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i0Ke/THU2iN6PO63Ev0/FEqBPV7aLH+OBw9rqs8tsM8=;
	b=S882C2+3bK6+reBRKe4euHntYOaVVDbN8xxgBOPhqAesi0uylPgxKnUAekbrlQ+5oUs/KD
	NGSjBmm9Av3/qMPKgiIZNGe/Hw+5Q84gtXrhya/7eaIo5or2QdLa3YNoxjMjNMfM+Hc5R4
	Y1bno4lYLlI167/mGuRbpCPWPYIO3+w=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-212-NJPK53u6NH6HB88SDyzxOw-1; Mon, 24 Aug 2026 17:41:01 -0400
X-MC-Unique: NJPK53u6NH6HB88SDyzxOw-1
X-Mimecast-MFC-AGG-ID: NJPK53u6NH6HB88SDyzxOw_1787607661
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4b1bc2e44e0so8616489b6e.0
        for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2026 14:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787607660; x=1788212460; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i0Ke/THU2iN6PO63Ev0/FEqBPV7aLH+OBw9rqs8tsM8=;
        b=EDbsrUXux32U8IarkXQx9q9fQSvPVaclNyZf0o5rLTnLFhWuUF5T4E93UYSgDXWgOg
         zHmt8h2iCGBil/50GaoGJaQuH0cy/AyJQHa3v9PRyU0mD2A7FwgLHHKzYT9/KjazocWi
         9clt3jo/DiSmBpPlBX1wZYk2mzQJ5CX6vWv9IoLTKxheUQ5fFQAAqtYN70gExzMHEXqX
         8+67DChr5LlU89hu39DOZ7ajx8uU+zGOPBLeB51hLszt9iVnUexLAzxWfK8fyEmViNOA
         7oOZ4SkuKbo2Jk4uccOEsdI3Q+3buyIp5h0ouGnFIj4g2tzhD/Jgd1jBME8XPDgbUijO
         4Kxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787607660; x=1788212460;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=i0Ke/THU2iN6PO63Ev0/FEqBPV7aLH+OBw9rqs8tsM8=;
        b=Eb1Eq61YKx7BoLmYq+rO5rJgTop7A/WNMwINe9qCCkV7U/DZ1UZBiPIgEltbeyz2DK
         BR/O2K8xWlu5G32dO1Us954Hncp6GpVu1gNeQ0iTK6FA0gXby/RHfOqul0UIbCsF295o
         HY+WhfXvG7LPNMaU1muimweCrf4zXrAVGTwRxPMtyksTpx74UXhhR2mshdMI5gSHLs3q
         O+MQSoGREl3pjcGo4tpgPYnDAMRZ9Mhu0xkkSoE/UjYnxJ2Q9b1gBxMjDBRCF4uVn6Dx
         KlN8NFH4VWnyUZ/kO5Rd8U1wYTASCUU25+ElBY9vrKn5prMgyRQb7KRLY4cSSCYdoUiw
         pEIg==
X-Gm-Message-State: AFuF++nIMWXhKvkq5qY5XD5P9nEYV/bmcozb0chZteIWKkdJzzYhO1n1
	KlUlwC/cm/ufOLnC1Gi32nO5BzXE2Q+jqgQL/WNP7oCBHLOz6sNFMr3ysB77fuFlMqST2UA2Aik
	bJdPngelsoKt9JOI84rZbvtodn4Ek/GEXeynFxq7TS3Z/yEepwXdlEe3o1S6vSnavyxd9SF/zhh
	zuv1ip3uCSrJcQSFyUEwS73Ao/BRmJdcvmAdlfyvqVa7cgzRY=
X-Gm-Gg: AR+sD118Y5MziSQwXuOHG66Rr50UnBtaVZNgaGeZexaSU8jjfIB7XaTuHbp0DGtRzK0
	+gK6dfWUT9PMYxt6eI9keOwOoGXu7lMwvhFmvPiYovJs4jsnouecUUtJzdIapRroXRVY4N0/Hvl
	aenEe0qUWKSUpKWBvRq2XYDNGnWqzzouYIObp9lFxlOovzJ7k4iPoRQaBStBGh1XvaesBwnP5PY
	SomprOUxQfYIKxNZYFsTfZ3nNL6XatIKnHO/XGeZmYTm9SL3WPQB+ih82vp20JyePRMRjWtETIm
	IWDJNUSsgIGhVo3LXfKQ6V6JzMLUssrpxwXVc2QsdeWbc+jRhKMklDNVYDT7yYtTTdSE5nBS/OF
	31Wptpttqn1bCplcwFeQM/ttONk+FWrdSnzwFksdDIog=
X-Received: by 2002:a05:6808:524c:b0:4b2:5529:ed3c with SMTP id 5614622812f47-4b2ef23b082mr30848559b6e.7.1787607660600;
        Mon, 24 Aug 2026 14:41:00 -0700 (PDT)
X-Received: by 2002:a05:6808:524c:b0:4b2:5529:ed3c with SMTP id 5614622812f47-4b2ef23b082mr30848483b6e.7.1787607659961;
        Mon, 24 Aug 2026 14:40:59 -0700 (PDT)
Received: from big24.xxmyappdomainxx.com (97-127-68-83.mpls.qwest.net. [97.127.68.83])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b32c8355e4sm4174860b6e.11.2026.08.24.14.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 14:40:59 -0700 (PDT)
From: "user.mail" <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: "user.mail" <sandeen@redhat.com>
Subject: [PATCH 1/2] xfs_repair: do not allow cache growth to overflow
Date: Mon, 24 Aug 2026 14:58:59 -0500
Message-ID: <20260824214056.400740-2-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260824214056.400740-1-sandeen@redhat.com>
References: <20260824214056.400740-1-sandeen@redhat.com>
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

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: user.mail <sandeen@redhat.com>
---
 libxfs/cache.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/libxfs/cache.c b/libxfs/cache.c
index d5d9ba56..f8be9b89 100644
--- a/libxfs/cache.c
+++ b/libxfs/cache.c
@@ -79,16 +79,23 @@ cache_init(
 	return cache;
 }
 
-static void
+static int
 cache_expand(
 	struct cache *		cache)
 {
+	int			success = 1;
 	pthread_mutex_lock(&cache->c_mutex);
+	if (cache->c_maxcount <= UINT_MAX/2) {
 #ifdef CACHE_DEBUG
-	fprintf(stderr, "doubling cache size to %u\n", 2 * cache->c_maxcount);
+		fprintf(stderr, "doubling cache size to %u\n",
+			2 * cache->c_maxcount);
 #endif
-	cache->c_maxcount *= 2;
+		cache->c_maxcount *= 2;
+	} else
+		success = 0;
 	pthread_mutex_unlock(&cache->c_mutex);
+
+	return success;
 }
 
 void
@@ -468,7 +475,8 @@ next_object:
 		 */
 		if (priority > CACHE_MAX_PRIORITY) {
 			priority = 0;
-			cache_expand(cache);
+			if (!cache_expand(cache))
+				goto fail;
 		}
 	}
 
@@ -488,6 +496,10 @@ next_object:
 
 	*nodep = node;
 	return 1;
+
+fail:
+	*nodep = NULL;
+	return -1;
 }
 
 void
-- 
2.55.0

