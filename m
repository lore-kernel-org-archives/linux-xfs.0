Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074D438CFBD
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807655; cv=none; b=Vdi4TPmmDjZVP2OSw7zwKYjbXVglhxFfjWQelU6sHpdRJN5NER9+PIcqdGd3PY5uvXLyZ5f07yqHpGcNRpvYOQfFZkZEbnTTGeHZ2pKL/RdRUtVZ8d8C56oIgT3gE7+UYYq4qhi/NaLHLsPR9fgUCK/L6y24J6XE7HzZCCr4R8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807655; c=relaxed/simple;
	bh=0lJmklD4oxs+QmY0EdOdZ2TKHxQWMnxFR9kZzYDsLSQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMKxEy1JIZp71YMoQiuzXAWBVbQDUdzQw6xWcD/NHYRWbrowHMNrxuWAMnpnC3ZIB/uZaMEPH6lI/zWs/m9Xm/S6iFD34WwTqT9PzxVnehnxdD0W6rV1gBq1yaxSUgWCNAxllvUBmgfh2kZj1N+UrxHY1E9K7QTv/9x9fySZZNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=3FnSnXr2; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="3FnSnXr2"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-71fab75fc97so13250327b3.3
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807653; x=1756412453; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pjkT2Nr/N4rw5SgF7OU0ePclbgK+JFKERg5adjLRg54=;
        b=3FnSnXr2Gj5yC8LL+E8khTsGRxQamoR5vf1dQWNL4hxgzLoq/lAjbNhEDY+7v1VghA
         hpnXAwgQ/zOa/dK8jd5kYbjpGbKaojRnnoOaDQFsicvONuE77VBScYZiX0x1wkYQcwP+
         /9AhsJDlL6L+2+b/E/BHisu5fzYxOPuQpQvAsOpCmc2rwO9ClErZtv1MD0chfwZMcut6
         NVZ3y0AMCblXREB/tHmAAPERlFqUrw1Qbw2hMx33CoksEQutGTjBXAP8QfUKwT5Ze8N4
         72noxgyDc/0S0dGpqOqnechN/3lyTkk2ODALTSRMOuG7JUENrIlz2pXVS+6UP2Q/SHcn
         YuXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807653; x=1756412453;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pjkT2Nr/N4rw5SgF7OU0ePclbgK+JFKERg5adjLRg54=;
        b=KHQp7yr7jzCzUtSQftV4v0lK2kv48RUDc0o9MwpPj0QBzIVN5NbmBcaN9oCqcSHA5s
         9TIr7FV20LswqyVHHgnjt3se6o4UC8hwjeR/GMYB4+BuiVI0uNxGv9DBxUZAaeQmHn2o
         VnlTusVFhZQmZI6ffydhHxQQe9QDimwcrWKeTnBIX7T2RjBYRa2Fcah9YpvfpxtlU7KY
         uu6OlGFzd/vwTS4HD6S+t6YxZYZZmEhU6ykJJLlOpDkBedzIijgA+G6/gV0LPDBOAPkc
         Br21wVuJcQ66LEBqB02VKb5p7I0LkPGTMdNk+qwo+ulW90wtUr4hrcY3wMdf+N/czooc
         mM8w==
X-Forwarded-Encrypted: i=1; AJvYcCWatKrP+LL4zrqTUL4WeJ7sN+OCDoNzp9QU7qn4e+N9uAhr1wXVhoI9RgQGLQEGmeoCLNE1+u0RUGY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1rzOnx5DzsEGUsAc4P8mCMWEVXBf5LbqM7SASbiVpECUlVJam
	PjZF7Xqm0sKNmMkUQk5EKHnsBT3BKUCcCxqLU63+AHnmUvo4OhQYWM5aVcTNB/veTMg=
X-Gm-Gg: ASbGncsfop+PXnV+cpNn3zk+MG7pesSkxv4O4YsiH7fey1UsrKDA+KSi6fcjL0XzMak
	wRRf4t2tNIN3UBms5CT/fNVFICZFz2RX9Uac7WMsqaJy9KYKf5DbeMP98Zd0hLVqCcGtxanmQGo
	3lXuhLeTJy384w83BrxLGCqgkmKNB6gZGc9G8kN/zzDI3fqKGkR9oIDz0CJLbOSxYKnMoiQqIgC
	wunWRe8q33jJuS0++fHPooNM71F1R1Kg0OTHkNVy6mWDsx6blLuqj/9wlX8DHDzWq4uHUwb/h4X
	YX+sXjPN2R1pnwZQ7iVrJF0KUpCp+jvE7a3y8b8EQuQZKZpgWwf/AMcpHcdwKvnj0j277sMRDYK
	8MHcREHidYSmQvXz1TZq+ILmsau5AABtkX44MeXH4hv2eo5xJaQlYmW6U8og=
X-Google-Smtp-Source: AGHT+IHkbsShVmVIQwfdIh0hUjUE61OmSFNVWODMerAHLv7/HcdmGwNwtKO6+Co21rSFectU4cHp5g==
X-Received: by 2002:a05:690c:45c3:b0:71c:44eb:fae6 with SMTP id 00721157ae682-71fdc3cdb12mr6675767b3.27.1755807652956;
        Thu, 21 Aug 2025 13:20:52 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-5f52b903320sm54724d50.0.2025.08.21.13.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:20:52 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 25/50] fs: remove I_WILL_FREE|I_FREEING check from __inode_add_lru
Date: Thu, 21 Aug 2025 16:18:36 -0400
Message-ID: <e42de7e9cd9b5fb17d159dda3de200b1800d671b.1755806649.git.josef@toxicpanda.com>
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

We only want to add to the LRU if the current caller is potentially the
last one dropping a reference, so if our refcount is 0 we're being
deleted, and if the refcount is > 1 then there is another ref holder and
they can add the inode to the LRU list.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/inode.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 6b772b9883ec..c61400f39876 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -613,8 +613,6 @@ static void __inode_add_lru(struct inode *inode, bool rotate)
 
 	lockdep_assert_held(&inode->i_lock);
 
-	if (inode->i_state & (I_FREEING | I_WILL_FREE))
-		return;
 	if (refcount_read(&inode->i_count) != 1)
 		return;
 	if (inode->__i_nlink == 0)
-- 
2.49.0

