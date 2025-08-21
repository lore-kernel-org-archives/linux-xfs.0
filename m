Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFEA38B679
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807635; cv=none; b=fww9s9favOon5L8eUHXiiLPFfC/iKHlH6ydgG7Cp2wTsDMTNcdHi8uPQVUnVSsfYt+AS7QT/pusvarnWaTLkSE2DdJUzmpT3BVpS8vyGRwlIJ/qZjkx7/VEhiSf1Rv0QOZ6dvBJgX+saXXfeoNetnGpRSBlo8TNGWZ7CKRHHkHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807635; c=relaxed/simple;
	bh=2lSccGeZgoSX9aVaaFdQWb29wL+DUPO/GAFShbd8K+M=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eunjiZ9n47bTgV+4YmunROJoz8yZPi9G4R3j99YVm+NcuE/U8K2Fi31z8UQivKgB2xFcX21HVFXgLC4Fs4apZ4QR0Fdd9Rg/siPEjmc/Sww0FcBUtp0FC2ZDXCXFpOabUjH5Q1OYwYdHiuVuX1C0/fDzN+YiP9+SwtdG/bQHcsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=zESJVNbk; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="zESJVNbk"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-71d71bcab6fso11591587b3.0
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807633; x=1756412433; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t6l/bS5zsFklKVceeWUebv0jSoLqiCtfylVlw96dX9A=;
        b=zESJVNbk2y3O8iYx0gwy3rxb0boWcrpPCTc0SvkjoX3yy0ZAxhHS+NsTE0PKR1mKLv
         zDiDSPUnjyQs5E0n+3TfR+Fi7C+NXtBkaC0C7FBHu2PYmOEtCDlDnh6s4bc9c2uLiLa1
         rhFEr7QAe8a0NVjWAkpzMwHH3dEsDFuFHzggAwUrt7gHL/UpsWgJfG+9VugQ8F0FE8Cc
         tDCF0ZLPtG69sqH4bmxy21FyDKet/4cS4qvxKAqvW+35Rwv44JENm61kC2QUQZdf0X+w
         knms9jQilY/lsOosNJYrueNdZwvGgE/LFUH6X8Q/BuFehfEAwoBrG+VA9FCBjCzvntDV
         MEgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807633; x=1756412433;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t6l/bS5zsFklKVceeWUebv0jSoLqiCtfylVlw96dX9A=;
        b=RvnHcaUv/TCnrNxkYphEuH6hBFu+B6d63MfgbFJ67hlMHkYHBkJMSS1bfdPuIxAUpg
         IFOh86lhkdCSgWKd9VPd2B6G56LLxRwX3+ppZNxjUfVjEerwsdEnOCaJu5LoTIxuqpRD
         uPgvMwcvhXqtM0Qm3mYqRM6JCrjnDnJ/cTFaW4NCwO+Bkv19aklOVkkzaz73WGIRR72a
         zAbBNj9XPujgYF7/61ERAeFvHV7b+5TzH22R1adb+ad4MkXBq5IGC8C3mu6f++e8djjm
         f88wb0TvQnt14Swoehf8PsW1P8I9WaHzEnXlB+trjee566D5Q38AtkJXZRPO2ci04/xv
         yJjw==
X-Forwarded-Encrypted: i=1; AJvYcCW5o/xh9HYQKXH4eGNwGCT332Mq7+yK8woFdL6OD8jXnExi7ZAIc+2uPV5IjD+9VNeOlloHFXqGiQg=@vger.kernel.org
X-Gm-Message-State: AOJu0YybBhZoawx/TWngX2lah6ohu/jwe3mk+VKSkN5FVzpPWtC37vFg
	ygi+QmvwqN+z5N36GUsK8euOkhQ+1m0fVA52EUZva1DIKPS0N3g228O4yWOOlhyof6c=
X-Gm-Gg: ASbGncsXmQuY96gdcQQWCUhgvdGcXtdQPfffMiTTqEqUjp7fseQkMgAcsMmD3ONLjUY
	XF9pwwGHJYTuZCaA8Hdh+7hzna1LLy81RkSn7XPdfALV8KAdGWrpwRIhjsdiQEpLlYly5lc1xm2
	OHsJVq7sZPM0P8LUcCF5Zl2172zT2sUsQjj/5GPNvLifCIOO4lEmIPtZ/e0MA2IZwEN9fiogPA2
	ZUbThepXAfB+DK8RbiS7yBv5mRr5uIzUr39Z+iuxDh8vvR9BIZEtqxeokywYrHXKQbksMLH3t7T
	3vVUyNTjRhKVla1KRvSjscn0Yyi5Ved0TyTkBXAxlfIov1Api3pjzwEgoNdPjXSCfG6ce8Ik4kw
	N9aezvTNceorRo52X61nqjmALlaCkNvKIgNT4qYV7co9HvXpL3YtbrS81e2ED/0hvpAn1xg==
X-Google-Smtp-Source: AGHT+IENgnB2uo7YbHtB+DxWNcnBLhyOt4jJNvfUugyviv21T/VvDjUt9O60NwAaV2wQMgUkTBA/BA==
X-Received: by 2002:a05:690c:48c8:b0:71f:b944:ff9 with SMTP id 00721157ae682-71fdc43915bmr7196657b3.44.1755807633295;
        Thu, 21 Aug 2025 13:20:33 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-5f52c8b347csm50443d50.6.2025.08.21.13.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:20:32 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 12/50] fs: rework iput logic
Date: Thu, 21 Aug 2025 16:18:23 -0400
Message-ID: <51eb4b2eef8ee1f7bb4f0974b048dc85452d182d.1755806649.git.josef@toxicpanda.com>
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

Currently, if we are the last iput, and we have the I_DIRTY_TIME bit
set, we will grab a reference on the inode again and then mark it dirty
and then redo the put.  This is to make sure we delay the time update
for as long as possible.

We can rework this logic to simply dec i_count if it is not 1, and if it
is do the time update while still holding the i_count reference.

Then we can replace the atomic_dec_and_lock with locking the ->i_lock
and doing atomic_dec_and_test, since we did the atomic_add_unless above.

This is preparation for no longer allowing 0 i_count inodes to exist.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/inode.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 16acad5583fc..814c03f5dbb1 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1928,22 +1928,23 @@ void iput(struct inode *inode)
 	if (!inode)
 		return;
 	BUG_ON(inode->i_state & I_CLEAR);
-retry:
-	if (atomic_dec_and_lock(&inode->i_count, &inode->i_lock)) {
-		if (inode->i_nlink && (inode->i_state & I_DIRTY_TIME)) {
-			/*
-			 * Increment i_count directly as we still have our
-			 * i_obj_count reference still. This is temporary and
-			 * will go away in a future patch.
-			 */
-			atomic_inc(&inode->i_count);
-			spin_unlock(&inode->i_lock);
-			trace_writeback_lazytime_iput(inode);
-			mark_inode_dirty_sync(inode);
-			goto retry;
-		}
-		iput_final(inode);
+
+	if (atomic_add_unless(&inode->i_count, -1, 1)) {
+		iobj_put(inode);
+		return;
 	}
+
+	if (inode->i_nlink && (inode->i_state & I_DIRTY_TIME)) {
+		trace_writeback_lazytime_iput(inode);
+		mark_inode_dirty_sync(inode);
+	}
+
+	spin_lock(&inode->i_lock);
+	if (atomic_dec_and_test(&inode->i_count))
+		iput_final(inode);
+	else
+		spin_unlock(&inode->i_lock);
+
 	iobj_put(inode);
 }
 EXPORT_SYMBOL(iput);
-- 
2.49.0

