Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60B8283151
	for <linux-xfs@vger.kernel.org>; Sat, 18 Oct 2025 19:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760816871; cv=none; b=p1a0KIB7L6lsps1Mo3MZkjtx+qvLVdIam1c6+VD59VE4mp1RyFNv7v8OgxbhmfC3FuLQJ5nx2AIMB9H4YfWB+QBJpcpQsYejaMf4TFayYBw1BLItpkuBqODtqmewY5ULXrdq/Rgd5VoNZ2Pf0gu9hCbPfpDQ7hFfo5B89k8nmN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760816871; c=relaxed/simple;
	bh=Cfl4Z2FbFTuUkk0lsxnRbzkKFuArme+w8C49aQPGsGA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Lk5VqflyglqHsfpkwdTiF3sbDzqbTWF7uThC7Jq0LCHKcy/1VwJpwMLp+voQkq0qlvhn8N4XmXfNkcLlRpfOpmfLUIxYjcZnfz2YNTuwAWrzC80vG271/Xf7z4LJ6LUzoUFBXQxscnkvPcJxZ3GXs9LCltEyNZG+gLeqc80cX8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OVtbKs4i; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OVtbKs4i"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7a213c3c3f5so4116323b3a.3
        for <linux-xfs@vger.kernel.org>; Sat, 18 Oct 2025 12:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760816867; x=1761421667; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=c5yV3R8MF8NT84u8F8kj/y6IDmqDUWQnCYW6rOFqRXs=;
        b=OVtbKs4i3gdew5Dzshx8rQa2MnfVZwA7eBX7XkHQ4JQi6r1IwbGocH7ZG3sA3CMZ7f
         BxusPmuqA1FokPkhHUX8D31XDMYMjhEF2GSGZUX72Hs0kmPmZ6H0H0pf0gf5UNJGIpzR
         H0DjBgs/oBshTxmNJzRf68iOo/7iJAzYprajnEO2y11IaaV6acXBg0mvDiA0QVJa8CUC
         TVW7yHQOv66Z8VZ5ETl2rxouEMF8y5NN8dUiinboWZWApthKqfJH+a15NKkO/dWIko/Z
         ksy4OG88o2BYY1obSY86ABqA/Vwd/k7w3KHa9LSW2jRg8Iz30aKx7Zy2VMHm3WC6Y7Dh
         EyRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760816867; x=1761421667;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c5yV3R8MF8NT84u8F8kj/y6IDmqDUWQnCYW6rOFqRXs=;
        b=cCvbQWjcTFjPRyGHuDGvM+oQBhJbXmWW/wyQJUZygc6whC66Hcw4pWYC7aSWhyR+3G
         0iUDgy0FGEJEptLeOSzpioklvdEoKi3vOimwvHhqDFz+Ijwi//g81cbP4lTaQEKDf1dA
         JmpRr5OzY484Dlsz6foFpBxbwl6Y3WOK1st5nXNLdB6RRl1OWQlockb2AmBZzUIsFEhg
         +1mCqLIZQ8SMFg8SjYGknWtM/LJ8orDa1LnIofmrclaA6vn3y3g/Gfo1CmutN6YNhneX
         xYCFwF5i95/fAuZZ41u8/fQNdu60GxBpQNMWOX6odwrqMGg4hnUVYgJ4sFOf3OAeGGb0
         94Uw==
X-Gm-Message-State: AOJu0YzV4vecHFzL/+ZwPPQFShuEvO5+DVsrIVZ3OYQzMSKyw7ja3xYq
	0yww1lhf/wnDP0VtFIes0abb/FaZj+l9ntk8nAi9W/5mAx3rj3/CVSUp
X-Gm-Gg: ASbGnct82o/JzUSIrcK17zX8PR6BgGg7DTiptyamFEAz1zT/XhdGSOM553aIAIob9od
	rfkDMyG4plfTl1qDKsidieDDSPK7+ldwZMcmjikzfg/kmwcnkG1IPdULeCduwZeoC9BSX7yJ1iU
	CgJPvd54cuVO+DjR8rT3F4wVdKZSMvTzrI46/jyLuQWgD3oOICFrB3CSdJEROl/OtwnGYQIj9yg
	rXCRDwLvMmeBchB9FIx2P61Vh51QqgtK6O5x9iIVnqMiC5JwS8Bi0ELrwh2S5V/k8BD84BLeJz/
	J3I7F/mSpHAl8ELNzE+cMMrpujzFaBAp0hfM0Zq+46vlGTJ4wiyswu6kt0j0rH9e3z+joqvD0nm
	f6x5GZXiAPc+BEkVxt+O+VAWJIKJWGC4SfpcDQ5vxhqLhGyNMgk49AUiLX7FGyvEdS2Zfr+MOJZ
	Y+XzNlRZCUmWeXgbx9TMHahAoc1QKa
X-Google-Smtp-Source: AGHT+IG1Pua+a+sQ0qZ4QW/DYh0Y01qkTB8IAIZS/QdD7Qby73bidnVcHrczxog/3EXRJO12bNVf0w==
X-Received: by 2002:a05:6a20:12cb:b0:2ff:eee8:abb5 with SMTP id adf61e73a8af0-334a85fdc5dmr10873862637.60.1760816866916;
        Sat, 18 Oct 2025 12:47:46 -0700 (PDT)
Received: from crl-3.node2.local ([125.63.65.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a2300f25b0sm3502738b3a.49.2025.10.18.12.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 12:47:46 -0700 (PDT)
From: Kriish Sharma <kriish.sharma2006@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linuxfoundation.org,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	Kriish Sharma <kriish.sharma2006@gmail.com>
Subject: [PATCH] xfs: use kmalloc_array() instead of kmalloc() for map allocation
Date: Sat, 18 Oct 2025 19:45:28 +0000
Message-Id: <20251018194528.1871298-1-kriish.sharma2006@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Using kmalloc_array() better reflects the intent to allocate an array of
map entries, and improves consistency with similar allocations across the
kernel.

No functional change intended.

Signed-off-by: Kriish Sharma <kriish.sharma2006@gmail.com>
---
 fs/xfs/xfs_qm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 23ba84ec919a..34ec61e455ff 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1218,7 +1218,7 @@ xfs_qm_reset_dqcounts_buf(
 	if (qip->i_nblocks == 0)
 		return 0;
 
-	map = kmalloc(XFS_DQITER_MAP_SIZE * sizeof(*map),
+	map = kmalloc_array(XFS_DQITER_MAP_SIZE, sizeof(*map),
 			GFP_KERNEL | __GFP_NOFAIL);
 
 	lblkno = 0;
-- 
2.34.1

