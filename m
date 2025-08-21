Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B824F39192F
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807680; cv=none; b=mpCz+MJQwO5a5vk03VKrybGxnBI5goCPYF5Sa+hfNluIJHx/6yoEI9NCvx0Pf4Z8L1ulCcmbmTWrpTwRizyLhYWviafK48JohHCVMh1WrID73eutaUdYU8tF5Df6VNi3pF3pBIIfoUj+xC05vp5A2uMLAIK9H7Hd5j4YZy+7yZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807680; c=relaxed/simple;
	bh=l9LGL5YoR+E74x5+N/Eq/UXBXN/oa7FDffUkNr02mvs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uStsdItMXlGwJMP9ppbeo2wU9nnkh37rbrHilfvvd3V0VajYo5xJPfrrIRzE7m7UrPF7JvMoUHNMuuivW2EmZ185uVwySjHniireHsEKbi+bQjrgBMlbBfWSujgkO2UP5d8Tu00mSGmGcDdeP4EAEuT/vhmqnXXUBJ4p/dlUUvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=0xrRm3+m; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="0xrRm3+m"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-71d60504db9so11650377b3.2
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807677; x=1756412477; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6A8xX7Mkw85UitdhfeCIWR7erYk+tgthiF9HNGtDW90=;
        b=0xrRm3+mKVWYP/+dwHCORPrPDAjir0w4zx3zLOwCTKGB+pDuowu8CcuA5AxVOv7AqE
         ObUCrRWYbHPjdlD7w1VFDcTl//pv/aFW9Jno7uOXMn7wT+eE/IaC6jiT5zPtEfaJKfiK
         eEGADrUX3oa9tvHvMGYVQO1HkMGWO4JBOoLFeQN0iadnnQzovw2YRSnWeFPhsf5pzT5R
         SEyLTBVJIC2ruab/aGzXU1f6Tmiu4rh3sFMIfCUH71vtcz8PAHxkOe/0wFDUQY0Yva8w
         IKGvY9VZ2FnDHM+zLKW9puN/37D3jJbayuFX5g9yNhpI5VgQkyVRlFg9mh6/k92Y6TiF
         2ZIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807677; x=1756412477;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6A8xX7Mkw85UitdhfeCIWR7erYk+tgthiF9HNGtDW90=;
        b=trxwO85J7xgxvL20P4Gvu2PObhIAyGJT9OrWX7SApSa+64yTv9lTQ4PgAgALh7GaC9
         LMdX9zZOo++PUk7F7AgwkvrPS0ebf9ce0vw+GtuAY2L8qdgoMs/6xLiuZp9La2KqoOdI
         9nELbPaXKRzB/PEH5gAX7cmYYDTvgDbEb1AIi71DtVDR2mwtX60Jxk4qoBKyHVKp2HLj
         GVKx+MN05wz4wsD+0aphOO22Y36XOjmNDagZhJ3J+S2xjguqARlzB+QMM0eeErfnhUWH
         io8+PlqRhTbyf+u05gNri1G5nCCwcsYmuROJbPotN/5ypt3ziyrgcqeDztPt2TrkgRLN
         Gz5w==
X-Forwarded-Encrypted: i=1; AJvYcCWIMQv55pBpwrdDQiJNMjYnhqzeNUGlz9rTZPSKZIkwxgX9BQOC3EXR8hM9Ncdxtm0eiGiCPxixaRs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwFU/JztfWzpnWjZjT9TZ8E6z93QQYgkCe5UMzfkb9DjDIgdRH
	naxyG/pOuwXGsvZkXeX+UuBuCjeGUN0ncH+Het81TGyuxAGJOZRN+XYgzrADivbIzqc=
X-Gm-Gg: ASbGncvgLbBqKpJlsSip0Fk0K9LJy7/IsZgIf9t8CPypP8hxGQAGvNnf32MY6d1f8QI
	6MeDwd7rWSBQIfSfoXTYpQuLJz2EIfOVzmBhd6lKTEPtcDqyAUKMAJl14aLPQSFQfIwMQpF9fwL
	XsoNQ9jns3vTGSATp8kC/65xuwdHiKihhbXiqo5SsnNSSYAPPdhp7NFnUiGFuQ5f64n/5VIKSud
	isiJsbhCJpHvKdjaBJ3BW/0cN/u4W3NmSxF7esoj+kww8aazn2qTDhHhKXa9fPUSotSIbfNq1Pj
	6+HX/DdsSME8x6KZFpfT2aWLA+fck80nLWyBnaGeiFdCxvZaoxCjlyGCAgG4o3DBSjG/jm/YuJO
	aht6Aq1gTu76lbIPzU6nqo3EgQneTD6EzR1fK/FxMJL/BWr9sHVvUgoJr2U4=
X-Google-Smtp-Source: AGHT+IEslmPaAmy8j7deq0G6NJW1ig6p7tgKnrmQqRmoW4yzMeUV0UVc/9ZPvIEXnYkUv+t0w0Cs7g==
X-Received: by 2002:a05:690c:e0e:b0:71f:9a36:d33b with SMTP id 00721157ae682-71fdc412c54mr7580807b3.45.1755807676808;
        Thu, 21 Aug 2025 13:21:16 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71e6e0b039dsm46055887b3.59.2025.08.21.13.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:21:16 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 40/50] landlock: remove I_FREEING|I_WILL_FREE check
Date: Thu, 21 Aug 2025 16:18:51 -0400
Message-ID: <e54edfc39b9b19fe8ff8c4c7e8b5fe06caa78fc9.1755806649.git.josef@toxicpanda.com>
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

We have the reference count that we can use to see if the inode is
alive.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 security/landlock/fs.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index 570f851dc469..fc7e577b56e1 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -1280,23 +1280,8 @@ static void hook_sb_delete(struct super_block *const sb)
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		struct landlock_object *object;
 
-		/* Only handles referenced inodes. */
-		if (!refcount_read(&inode->i_count))
-			continue;
-
-		/*
-		 * Protects against concurrent modification of inode (e.g.
-		 * from get_inode_object()).
-		 */
 		spin_lock(&inode->i_lock);
-		/*
-		 * Checks I_FREEING and I_WILL_FREE  to protect against a race
-		 * condition when release_inode() just called iput(), which
-		 * could lead to a NULL dereference of inode->security or a
-		 * second call to iput() for the same Landlock object.  Also
-		 * checks I_NEW because such inode cannot be tied to an object.
-		 */
-		if (inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW)) {
+		if (inode->i_state & I_NEW) {
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
@@ -1308,10 +1293,11 @@ static void hook_sb_delete(struct super_block *const sb)
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
-		/* Keeps a reference to this inode until the next loop walk. */
-		__iget(inode);
 		spin_unlock(&inode->i_lock);
 
+		if (!igrab(inode))
+			continue;
+
 		/*
 		 * If there is no concurrent release_inode() ongoing, then we
 		 * are in charge of calling iput() on this inode, otherwise we
-- 
2.49.0

