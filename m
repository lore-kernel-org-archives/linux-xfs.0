Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A4E1FE44A
	for <linux-xfs@vger.kernel.org>; Fri, 28 Feb 2025 08:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740731199; cv=none; b=mAv2JIqOTz6X1sF67ne1427E+IMNXqe2JlxxGbNbJYTirF1bvKUv+owxOsbhT4r3kaCe0eLQYS80Nk0FgZ9KFb+hfxtb/7UiB109CyFJBVLP2RU6RAJ+APYxC4/Mb+jyzYAk9IFYPEoZY2lUZSL91LVk3lSVI03HSTCw7sknbqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740731199; c=relaxed/simple;
	bh=WrPKPh/GOzt4rNjBgY9sC4rtpJQd9G6N48etnqyjqSQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WdvZzpeNEi1TtqiZQ2QicoWR1VTNUO/lZ6/vxiLbV5o1p/LnWgZrThh93FxXqm/5TQCWNV9lTjMtFczC7IE4wu+nhUP0oGvcqmXcAG3om4TfWElTDenGqD1SAM8q1y0eSncwtd50tPGDwz2Re6BU0bT8xZ5z3eyHLr4ZLfK0cQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AF0pUbCz; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AF0pUbCz"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-219f8263ae0so33519485ad.0
        for <linux-xfs@vger.kernel.org>; Fri, 28 Feb 2025 00:26:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740731197; x=1741335997; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BZXARcJ/niy+Y503n9/HgHppZ1ETRmLKiUtWCY7HljE=;
        b=AF0pUbCzx8NhzlHfbzcKP80F+tBPjmLAUMh9ywSXUS3WOoefNhNc3jOqYJTho7wxq/
         MxUEmKYfVrYg8agS66XkwKU1KvmRbsRxqJtpvhy40RXUZqYj+oZ8NcdooOrfZKnC/0B2
         L0hvLs8SKgmi1lN3fS5ktwj2fSZqUgY/avyE0ZZvS/RR/d+6L9QWsirfVVPE52scGFWY
         tRQNZT52eq+WLaKOOgEJygzmFBR1xB80C8jwj61Hu8Dl7ao+3jUTU3CRnOsiSKDrPBq8
         Mw8RnlYUKZuJ3TrPKZEmGilhHn7I9mdGo+T2S6zJTHfFNlppw/8sQ+AwlvgAnLQDwzY+
         AK0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740731197; x=1741335997;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BZXARcJ/niy+Y503n9/HgHppZ1ETRmLKiUtWCY7HljE=;
        b=stPG2vMTP/CelcTCKvsaXcvscL2F2he4CGtorbWT/OYTodqqkkM4M/gCAgxJDYo/Tu
         aoitEgdoHm5k1e1PZuk+85kHVroh/UeD6dgd+NIe72XGJ3AYWkDK/k39kroCwCqxnWWj
         FTFkVgFTeJGmvd29gqm9oLCkJyNTQTfrXIzHIKbgDNtGMVIQ8LznMzMUqMlOMQCfGVxF
         AVpXb7xO7VuTBB88bk+ZEE9ntmHzpaouaBaJg83jgce8Vg+TsVi6dyzEbs6iAd+zMqZp
         QWfgw8FHiU2Php3sG0aKwjeYrDukHgpJ+K6wD3/3WnRXCxXhqL+srBQXQv11LMnH/Fsk
         ZXUA==
X-Gm-Message-State: AOJu0Yxbzo7U4+bcUlFtEeN3WT/hCdP+V5u0kHdYQ59Lwl7fYV4R5up3
	1zKx8mtDSliwpW0H18/kYeTigpjO5V9GBFHcjBkioITElNLDDVzFHaCEqaX0
X-Gm-Gg: ASbGnctiYvPovYdiQrE5WAAPdRb38dllYn5J1bYrckjI66GejJVtgPzLgGUmfruWfAy
	N4uu96F2r6oRKXypISMAlc/vERVMSYOaU34PHISVaYJxAbke4aPHMGWNPBa9mNwaO4yldq6POMq
	pENdKmXqu7JT7S+3xZnskAVOlAISA6bP13+N+t2OajLlegso5feM7tNGaUbxcLOSgbl5xkyAo5G
	mpXK1KxVYZ7uJ85plUqQzazCU+ccOe9dfmAyRJ0u3qdd/4K2HpGNfgdJp/Fo8iu164XXChomzTz
	ULMQlrxBNs+6SNkHskKrr2YKGWeBQA==
X-Google-Smtp-Source: AGHT+IE2CuA3rukwB8wy1XE0cyNwkZ230/JxbklWdqlzCwry9Sy2RIuVwW27zrPBK8PBM0edZt3r/w==
X-Received: by 2002:a17:903:18a:b0:220:c066:94eb with SMTP id d9443c01a7336-22368fafb28mr36598655ad.25.1740731196739;
        Fri, 28 Feb 2025 00:26:36 -0800 (PST)
Received: from localhost ([114.242.33.243])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223501d29cbsm28294695ad.50.2025.02.28.00.26.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 00:26:36 -0800 (PST)
From: Julian Sun <sunjunchao2870@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	Julian Sun <sunjunchao2870@gmail.com>
Subject: [PATCH 2/2] xfs: refactor out xfs_buf_get_maps()
Date: Fri, 28 Feb 2025 16:26:22 +0800
Message-Id: <20250228082622.2638686-3-sunjunchao2870@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250228082622.2638686-1-sunjunchao2870@gmail.com>
References: <20250228082622.2638686-1-sunjunchao2870@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since xfs_buf_get_maps() now always returns 0, we can change
its return type to void, so callers no longer need to check for errors.

Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
---
 fs/xfs/xfs_buf.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4b53dde32689..adb9a84b86fc 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -167,7 +167,7 @@ xfs_buf_stale(
 	spin_unlock(&bp->b_lock);
 }
 
-static int
+static void
 xfs_buf_get_maps(
 	struct xfs_buf		*bp,
 	int			map_count)
@@ -177,12 +177,11 @@ xfs_buf_get_maps(
 
 	if (map_count == 1) {
 		bp->b_maps = &bp->__b_map;
-		return 0;
+		return;
 	}
 
 	bp->b_maps = kzalloc(map_count * sizeof(struct xfs_buf_map),
 			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
-	return 0;
 }
 
 static void
@@ -236,11 +235,7 @@ _xfs_buf_alloc(
 	bp->b_mount = target->bt_mount;
 	bp->b_flags = flags;
 
-	error = xfs_buf_get_maps(bp, nmaps);
-	if (error)  {
-		kmem_cache_free(xfs_buf_cache, bp);
-		return error;
-	}
+	xfs_buf_get_maps(bp, nmaps);
 
 	bp->b_rhash_key = map[0].bm_bn;
 	bp->b_length = 0;
-- 
2.39.5

