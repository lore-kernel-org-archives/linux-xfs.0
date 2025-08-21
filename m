Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E25B38CF83
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807646; cv=none; b=qSnhpp9ZFjxB/kPAb1ncL6Ksp/7Ri5deuZDYsUMN7+HPZ4mNpaiflgkOqWxbb8DrDdVgnegA6hALeiuMJYuesexY/247VJody4w2yVldDEC+JNo98aM+Fbv4/mk4LRP00DAfkM0+mjBJ/i013NQ55ryyeEnXE5zU3Gma5EAIa/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807646; c=relaxed/simple;
	bh=MCFryGt8OvI9I73T/3uykYAdJBu4EwKq4BQ7zZxDWuE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DbaKcXfxCCCK2E28zg+tXA2u0rNY6HF/LzjqcIucNs1oCodmEeC52UxniXMbQeCEDkodslkhB4Sxr50EaHhooeRAOIBSMdW64ocia5KOiVx1oSlSx7KUPQJmPzAXpriXcZEZBd1N8jh5R9Ap3Slda22gyBsAMe1mB3TpTjiX2R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=XbtCyXsE; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="XbtCyXsE"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-71d71bcab6fso11592717b3.0
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807644; x=1756412444; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lSiPe2GSvHZEVcD4vFKlapaYeiYpuc+3T8lPvcFai6c=;
        b=XbtCyXsEmrWBsd6yDF9IiegwUNgVXBlCVrPUJumMYWKm7MJYHgiOSQhrDwWG76DwYN
         ZMX8+pAhrNnDAN2d9AzJUoQTUVkEq925Neajk4k8/tRVDbFiEeeHFZCYnLmN+u+oh8JP
         CqtSTnWdN8a4ABBbWzDbXBKx9UZOf3C7Jf1Xogt4mPwpIunt4vOSlUa5H2mb2gjxA1B1
         0sN38P91d53XHZkvAjCjcuLmQyM+36kwS9UR3r8AMu8/7EmQ6YZc+nhV73a1IVoN7dh1
         RjaMsoUO8PKkIsPaBJI7EvFq6PUq93VWXeWkZMkt4m0sQEsP5aJBb0OGWzckH+1smCDM
         HFxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807644; x=1756412444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lSiPe2GSvHZEVcD4vFKlapaYeiYpuc+3T8lPvcFai6c=;
        b=aIMx0kgptTx3fNyGwZsYDqBvBHtlmDj+v3G6jIkBFZor1g8sL1V1iGJt4nKDDmAEsx
         Dgt8fbjqNOIyZUKa5E5Y8SnVF6WGi0ZZMZqhWVlngTjWoSwH3D8biJFfFpyJYzorIwFi
         3t3WEbcqnu/ZCTaA5asVQB6W9WEWYVb1ZzOhWoIBXsYdeipILx+ug+gunM4y7779hTfd
         7NJfUOcYEscTOIzAU1tU1seMIhC99MFrpNrKBI9HGDJcsm1em5FAXYh14L5h3Zn2b08I
         1Ub67LSIU4G0kIUHeTxAf9ELEECRH/l0FOy8Hq8tbwt4vOJHta3fBEI03+KxV5zDBHPQ
         H2Sg==
X-Forwarded-Encrypted: i=1; AJvYcCV5MTl1tkdrAElq+D/18nnO5kDdZP9AJ2foLLpkh2tLEYPKhtrbregY1CJ1eVR22ykZPTodOjdyECk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbOmCHsz3REP/azgYQIlcPFKgWHWGa1CURzrKpbNZt43fZEIYR
	AEdwnZL3SVCSVLzlhs5GU9W3Qz+hSfOHsFjFBZGRDlyXqs2+KR2e1onnhq77LKEwArQ=
X-Gm-Gg: ASbGncs3c0hVcUH4BQqgYVCZqaM4YOrNhY4NviCtz6o3MGrzrXdVKFakxBiEVuWzavV
	uhKu08e+5B/ClfHeR8f8nfkA0Thr/RIruS0CshI6MjCqyFATFY0AARZGBSha7sAmnZ0OQjlT03i
	hkUW3RTVrSIeO7xnG3AZ6+fEWF/0s6ktsG7JukA9tb/dl7TUb0Ru/X79H40fBDSLsnzpa8pNetK
	OOtPZb64X3wuRjs59ssiNp2z7eAbMAtev/vi4nzcT02/S3qnyaSejyXCbX8FqS9gMACLxyg5y0C
	4o/QNpiTaETeKIo5+XsFd6mgMRHUD4TcgwX7wcsu6X22c8Adqaao061GtfDI3CL5mFpKeO93qEF
	a50fR7/Kv/z3HSlhVX3oKUHwOPgRe5HoEOCjkdNSpRnggmaNpWYvSDxQY6nbrDuI9GbWO2w==
X-Google-Smtp-Source: AGHT+IGDgf7aCeL2nL93909EYOEt+b6G5wwfK4meP/GDmXRwGfXQkKjEhZnhShlvmG9gTGb/wy4z9A==
X-Received: by 2002:a05:690c:6c0d:b0:71f:c6c5:c55c with SMTP id 00721157ae682-71fdc3d1834mr6237357b3.26.1755807643782;
        Thu, 21 Aug 2025 13:20:43 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71e6e05c0bbsm46459507b3.43.2025.08.21.13.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:20:43 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 19/50] fs: make evict_inodes add to the dispose list under the i_lock
Date: Thu, 21 Aug 2025 16:18:30 -0400
Message-ID: <9aacbf6b90ed4a980a49cb4d4eaa3d2fefa1a7d8.1755806649.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755806649.git.josef@toxicpanda.com>
References: <cover.1755806649.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the future when we only serialize the freeing of the inode on the
reference count we could potentially be relying on ->i_lru to be
consistent, which means we need it to be consistent under the ->i_lock.
Move the list_add in evict_inodes() to under the ->i_lock to prevent
potential races where we think the inode isn't on a list but is going to
be added to the private dispose list.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/inode.c b/fs/inode.c
index b4145ddbaf8e..07c8edb4b58a 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -991,8 +991,8 @@ void evict_inodes(struct super_block *sb)
 
 		__iget(inode);
 		inode_lru_list_del(inode);
-		spin_unlock(&inode->i_lock);
 		list_add(&inode->i_lru, &dispose);
+		spin_unlock(&inode->i_lock);
 
 		/*
 		 * We can have a ton of inodes to evict at unmount time given
-- 
2.49.0

