Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59C037059B
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222914; cv=none; b=qiLsdmwXOTIo3yHs5n/wvpNGMELO9vUvRVkHfdbUr2VnH6weOM7VDbuPmrTHk6oRJ1yxdv4qzRNntFfowrqp4BCyo9Mq2TCwPwUa8zLGQJIzdxgvqzR28seyTSicrGnSC0f6j+HxCkcrmMyBJaaXoTvGfuOqrKL8XK1hE2SmXuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222914; c=relaxed/simple;
	bh=dwwe0MEH5iO3x5aF5QurpKCYlNFdYiCh2i6JCishoj4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjfyEzFd3gyVqT++ZA1KQglqZqWuVkI+lGnP9isAxG7hl3e9vWqERERWyKEAC8XK7AQoC9h23ZbcVuLAUD132vkAhUPmaVKB1OmzM7GY+Z1yDq/sq/DayZpZvlSrMxTVecj75gBNs7WxTIqSmgnThwUtUTdi7x08pLzqQT2IU20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=du07Fhm+; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="du07Fhm+"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-71d5fb5e34cso144677b3.0
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222912; x=1756827712; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yqvplDu+lNSK1bVRdwN5sEI2iN4Y4F8Nug6abxM7ea0=;
        b=du07Fhm+E2K75A21FLUay2gY/LIECLDwj8QJpWSLT7JEI1eYR/PzKjv9AjIMUAf+3Y
         0mQyMgg26Y+H5drT1jRmdaTurj79cVC4zl+yNoF+SyXJOrSR8tlTcsbHyeCr0OqeeEr2
         g5wnR7B7nVP50zr+WRcdoT8MQWTVYTZ+BrM1HqoNHvtdKCTP/LGgri6n6gz/zJOU6fnO
         f0Hf7bCn3xUYy2SpN28T5B8cWL6ZEuQck6b5rhndsVyIz69FYDYg/0bitHGlJmD+a3Zq
         zi+KbNH7jLO6Mnc+dpu9whKOdXv8DtVurbaJZdq624RXiQE1gWtjCVBWShg010G51Zui
         LfKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222912; x=1756827712;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yqvplDu+lNSK1bVRdwN5sEI2iN4Y4F8Nug6abxM7ea0=;
        b=Th0ftxggR8LyRcX/aiPnmijv9d7xlxKe4i5B0u1BdyDyjQrYgyp+gz4hfY0C4Wm/E/
         XKLaA2JaynWb2ysPbUzyBq+du7JuycwBCHFjkpQ18BHkWeM/AhbLOV+VqLp2gXi/6s0j
         YOCs0nqkgsg+vWB0w9NfxhTHRGoLljmwP5gR1bXdExNewjGR9tXB3Jxvf5Sh+NaQsF7o
         eaCU4KXsbtgH9I7EI9idcRVbT7OpfIQ4qrwYJhSjbgtCDAMg7XlulphG53mvkNeOQRQp
         /HDpp5s/y50HmQh6Ap4bYRlb5Nm7TYNxE0iZ030RvLfYLsey3ku+szUuvKGg+F8cbXU1
         Vumg==
X-Forwarded-Encrypted: i=1; AJvYcCWxFYPoInnBXNgzr3iaTcHr+7dPLbr+eCDrlH03YpbGK74zm4+RzRzMwI7vs+AEgEfgPxPTTvg3L0o=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywv4x5VOPTFL9DbLflXK4oIA3vYKw5Qk7km2mOPnzpKbqorWsbE
	QZ2eq3h7h89xaPUZHOjWm8CVyCjBJkbIfF3JcX+nCd97jYGB976ua7pFPve0o6fpZv8=
X-Gm-Gg: ASbGnct0P5qngHvWlnGfPpRIxxv6/YSa2PVGx0UYGAZ39xEkXTLK4WZH9PB5cvKO7Ak
	BncxB7VLByr6V20I4XJg4q6Nxle2/QtpmAeolgYSmwUgxJlvEA27Gnu9m//IQRD9V/PjEGasLpz
	88rKGU0bUzrKr+a2k3Sk1BAr9Lh6vH0pvCUEK3lOxB48hb1/kinybHAizfDiGz0kVIlR66TRR7t
	Jw7vSeuFQlc8FUAfuIyW1cV8HKjW6O1JgK59ZF4w2dfQmiGJPJwWYyDz+UAL25lNfPS1+uycVNo
	dK+60Z/BbV6v+g7QkZCEoZt/tbrKRGMdyKwKxCYPjs5AGYeTDdp5yiGMAT+hx2sDMTBDs3Fsq6D
	p+d8r9eEAfZ3RKCjWvuwKcoliT2nQAnsoA/3vy5R1nu3YLrJmO4QhhBeaZCo=
X-Google-Smtp-Source: AGHT+IEmTijuWh+ST4YjRGo7H4pufM7FApdnNjecK9pfpFaUwQCk/e/q5IjGGvh2/UXNpr28Nq68Jg==
X-Received: by 2002:a05:690c:2606:b0:721:2c21:3614 with SMTP id 00721157ae682-72132cd7378mr19923627b3.22.1756222911738;
        Tue, 26 Aug 2025 08:41:51 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-5f65a223d29sm2530427d50.5.2025.08.26.08.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:41:50 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 43/54] fs: change inode_is_dirtytime_only to use refcount
Date: Tue, 26 Aug 2025 11:39:43 -0400
Message-ID: <caa80372b21562257d938b200bb720dcb53336cd.1756222465.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1756222464.git.josef@toxicpanda.com>
References: <cover.1756222464.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We don't need the I_WILL_FREE|I_FREEING check, we can use the refcount
to see if the inode is valid.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 include/linux/fs.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index b13d057ad0d7..531a6d0afa75 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2628,6 +2628,11 @@ static inline void mark_inode_dirty_sync(struct inode *inode)
 	__mark_inode_dirty(inode, I_DIRTY_SYNC);
 }
 
+static inline int icount_read(const struct inode *inode)
+{
+	return refcount_read(&inode->i_count);
+}
+
 /*
  * Returns true if the given inode itself only has dirty timestamps (its pages
  * may still be dirty) and isn't currently being allocated or freed.
@@ -2639,8 +2644,8 @@ static inline void mark_inode_dirty_sync(struct inode *inode)
  */
 static inline bool inode_is_dirtytime_only(struct inode *inode)
 {
-	return (inode->i_state & (I_DIRTY_TIME | I_NEW |
-				  I_FREEING | I_WILL_FREE)) == I_DIRTY_TIME;
+	return (inode->i_state & (I_DIRTY_TIME | I_NEW)) == I_DIRTY_TIME &&
+	       icount_read(inode);
 }
 
 extern void inc_nlink(struct inode *inode);
@@ -3432,11 +3437,6 @@ static inline void __iget(struct inode *inode)
 	refcount_inc(&inode->i_count);
 }
 
-static inline int icount_read(const struct inode *inode)
-{
-	return refcount_read(&inode->i_count);
-}
-
 extern void iget_failed(struct inode *);
 extern void clear_inode(struct inode *);
 extern void __destroy_inode(struct inode *);
-- 
2.49.0

