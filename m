Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A18390951
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807670; cv=none; b=oEFSXHykDwRRPJyjqWJI3bWdcExs+X/7PlQyYcixIlTNpM3UjBHzZN/OV4ua/mfTXfoqm+hf0/E4YlY9VcZArT2m+zKNHHszyMaNo4S/RoOMHbSQQH/5eRCVcHp/4eL40hD0btQRMB1KuDzatcQMnTeRuMIQ6vpScvmBLHKzOog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807670; c=relaxed/simple;
	bh=wctmqEmUpM1KjsZSQp5EFVFe+I/02AT+kFbU82cRaBw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KvgMGzjrlC4/NTWQ1qLvg45ze27pn6oKZ10zRLga4N7N1HpX8k/Ne34wsPbcBui1iCP0m7NNg9q3prl8WkxeotyEMXfjUk89+382DW4AtLA+FfOl+zj1WJfXRoiUVFkSuKiF89Ya0JT2nK/5sPXUb7qcMj8XOoJmcEpxIzARBUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=XT3KipCB; arc=none smtp.client-ip=209.85.219.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="XT3KipCB"
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-e951dd06849so65278276.2
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807668; x=1756412468; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pmjKaUwpj2DkmXlSJQoP2X7HjPrWpM7VXZkID8fwcAw=;
        b=XT3KipCB2jm6p152EyvrmRuqDRnjVcKIqaBwalMD7j2PyAoVdhlZtb1eZJwVf5A+WO
         PdAyXmiyjm6CzYXR7EUWG42Rm4JE/qM9YWEF0tXQVbP3kBHV98IKnpHgY+TmBU9VpZnf
         fwdbfVwt6AX8etvG9yApD/zYDVUlCGdoO7JXxrHNcRUj6j26i+59jzlCWy+Lsm/DphYY
         x0C3+0JtTbVRjLse7D60UFjkG6k4HGxQjxWzlADS/rfRCtLvh7G/pnQeSZo87xSCuTFo
         UfmmjmLop4AhyXmKAT7yp7/hGz7TZqxvJzZMEYo5T7t+ZTVRtGLGR1JykPAeJW7gvb4J
         qXHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807668; x=1756412468;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pmjKaUwpj2DkmXlSJQoP2X7HjPrWpM7VXZkID8fwcAw=;
        b=ms45ZrirnOpQh3UtWzKuzfuA4i/Hglsszv6smwJHYp+AqlcDjAC/rQo8Plj6/ZQFG9
         O4Uo6qhSbSkrBmcljFJ42IXkwq2GgGxDlAwmYZduXkstQZI4arZj7OR0JWgqedj5emRW
         oWMxO7TbO5obHjqW5WV1CdLDwOcXi2TSc+LJOeUNYh/Z8xx8s/rIURrH/fEY1I+zQ7Gm
         3p9YwKofq69Z8+95cixagqUrBvztPTcstrduE/AT9Aq6XCgOeW10WURCEyX5dOOHbtXy
         92pF19ZH1RryOqnRyXgV167Cl7TFGz6grpFyq87biRXXQFl8SXPdsRhXW06I9Vj0L8/S
         25gQ==
X-Forwarded-Encrypted: i=1; AJvYcCUH1BpDLN0jNCRNF9rNbIdWB+rFqv45mlPUHvTXY1dHgNX8qccguw+qZcsVN0W2lKB/FW9WWSixbMY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmF14VCHqK30knQB+euCdDQVR5M1G5tHjWnRzqvcpc+Gs8JCmb
	5iFXZrKhOxcl8ByrTJl9wUbdFX7ooLRrXaF5wi32/EJ7QEY6AMJB0alq+/V5QTtadjk=
X-Gm-Gg: ASbGncuOmxoMvVo7bTPrflWanptXGnsxrIsfzKWOB62ZVy3ZNqzVSCPTjt2cc5HWMqL
	IlgyZh4djPEk4Y2JMUDcogQEnChFtjb+ZO4I2Bd0rkqDvHfZKjafMJGH4Jcv/0E4J14vkqbJtmu
	QGikfVyf4S4Yb9/1zTzx6TgFokcZnf1QUTARiGE9zvhWXfAUFZng7oRJljoLWpXkKy8U+rlV4cP
	eLowL4DZkbbyE/c+XWe/ZeeWRL3TOUIIRfVQ8cqs9BIomfesDjmOxy161wwucnri3ViaunfviX3
	yJjOUqRnUckmDBJj4wHYOxpYRiVvCGOaSJhJh6RybjcNIwsVi8/UqfiuefBJDSf2g3BeFYEx47A
	U4od2LnApykeFhwjbYKNPHKJWMvfY3JMt6CQFpPS0JbDXPO394/PxSYfMZqA=
X-Google-Smtp-Source: AGHT+IH/T0dsDptJxPlJ9vX/O/NjsuJx3EIZW8Vubo/2lIk8PPtNqr+h2Z1PZdabpWGsbTrFvzNw7g==
X-Received: by 2002:a05:6902:6c02:b0:e94:e1e5:377d with SMTP id 3f1490d57ef6-e951c2da511mr1105376276.51.1755807667754;
        Thu, 21 Aug 2025 13:21:07 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e94e3942c33sm3133839276.28.2025.08.21.13.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:21:06 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 34/50] ext4: stop checking I_WILL_FREE|IFREEING in ext4_check_map_extents_env
Date: Thu, 21 Aug 2025 16:18:45 -0400
Message-ID: <0350442f4267245bb0104506c95c05a1cc42e96b.1755806649.git.josef@toxicpanda.com>
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

Instead check the refcount to see if the inode is alive.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5b7a15db4953..7674c1f614b1 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -425,7 +425,7 @@ void ext4_check_map_extents_env(struct inode *inode)
 	if (!S_ISREG(inode->i_mode) ||
 	    IS_NOQUOTA(inode) || IS_VERITY(inode) ||
 	    is_special_ino(inode->i_sb, inode->i_ino) ||
-	    (inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW)) ||
+	    ((inode->i_state & I_NEW) || !refcount_read(&inode->i_count)) ||
 	    ext4_test_inode_flag(inode, EXT4_INODE_EA_INODE) ||
 	    ext4_verity_in_progress(inode))
 		return;
-- 
2.49.0

