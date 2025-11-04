Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E2A2E092D
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 12:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762260669; cv=none; b=Kkqr8g8cKGTERXz4w8eGBPDDO/P1onqDDqtPWOLIgbqGUzZD+Kv5492VQqzMVZXfUO27FNMSONc8jloHQ8DmQeY6zgn37NXpYZM/Ol65efCjE/PstCIQE4YyXh+3ho08WHlWZK1EaIxd89wrRQQ7UYEvKqN7t7JyxRrU1/ccUpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762260669; c=relaxed/simple;
	bh=S3L8yWcPf7Uvvhuw8kb5mV50ABXqzeKjCs/M0blRocI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RsR8bYOWKwzT59RX20X0d1kazSho5mQGJNzxR0YuwPxnqAKZjsm43PZt3E0m8rGDRMI3AyFGHY8Z9Aj9aaWd1HC/Vo0cOaOiI8vFvymRAYwWO7HJ3Qm5OOdpC4RGp6z1bbKYaOOM4JYZEXIXwDx89YsTxhOpCShySgZxf1LAbmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a1g5b/AV; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a1g5b/AV"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-340c39ee02dso2790191a91.1
        for <linux-xfs@vger.kernel.org>; Tue, 04 Nov 2025 04:51:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762260668; x=1762865468; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AM4LaUJGUQ26yP1YfE9/TUkYoY6eJkQufUALxNmpnUs=;
        b=a1g5b/AVw083mhh/EpgN81CSzncrNP02f45pvke2+H2d1K+ePlVS7/AdsD//K9Xnmm
         qLQtCsFfGFCsnt2Y/LqodDoEmtnTjbsPVRijPGMOzjp0GrT6jJL8sdP48Eoy9tWypLhk
         1YEXzboA7S8rYv5hW9Nmuvn7MaNVAdbpT8fGWCOGm1ABaIlRHVIxd8itcTcCtSMsoJRo
         O++Q3h3FigWAIxt9iAnB5dc4USxmpEj8iMHUnvo9xgf9XB0zI+CrA3rKO0RlNI7DVTi+
         zzTaTGet8CBRG/cJ655hUKqPe3QlZrOvO1Mi2xNKjwg7K97c9O/ir94bdqljjK0esjBv
         wxyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762260668; x=1762865468;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AM4LaUJGUQ26yP1YfE9/TUkYoY6eJkQufUALxNmpnUs=;
        b=i3h3F/6pgAQaGUzZdJ9GUu7j2ypreN0vD5bxdwBv7ScGJX4NzCVHe9I1ZY/kn+LiM0
         88ReQPEqnLPB+VT6oQx7oIOwY5ivylk703sd8DOxgKOsV8lT31vZhXgzYeGQezhMOQcF
         fS4X/sfuz+Z3LNi1qLlhwi2MS5XfUczvmWC+boIvh1+OAGLgAbhN7um8b+tBDAYzHJRb
         T2krUyFeAWN7yJrJBPrcbQaSq1p1IOw/sQjL40nPpNbavPqUgyHjgGAEIkwiHR/M8pi/
         5NGIaXdY31go6n+1aMm3hnZkArT6UZIGisy6xD6NPfR3/oP2XTVf8wBgfJDfXfPBbT6f
         vmmA==
X-Gm-Message-State: AOJu0YwUuWIEnkY4szHwBzir0MDf+JQG7hJGidP9qKX3TWDjNtK9VlzA
	/1A/Ox320GJM5MLBmDDq+5HAqEughh603f1gwAKYGJlgUvF3C01oNl6c
X-Gm-Gg: ASbGncuUaDGO/Ds/WdR+xd0hjqPNJEOrypJJmAzAMlc7YbsC7HelvOo+Vi/lviJbFUa
	EvyJxXtpHOwXdiHFTadQAd9EOhxmE3qQxlo8mlcIASHAnCS8sHgEOZZY/U4wl0qFVztn6i/8gFt
	LiJqe8CB2tooESNu5A7Zf0AZCpil8aumd8b+np4BN6ES2dqHnb1Gfc7m+XH8y39sE5y8RwneAG2
	RxmZbWrKYg3GBlK+wTYGuxP+EGWhpwa13fzsXFTqxbIwfqT++/T8S3EOY612NblOc6mIqSwfhQA
	eYgVmk1D7gG4pqgStS48HRgzZsPDeBKj4nmTv9lXOLE24VTMhDgGPVH0JdEZ/tjEJ5aInFrBgiF
	hCn8JB3BY7xTsRVZD4CCyInWuTZapU+jQWXRCnMNE1ne3FVNTMEe7xrCzV4V/A2G7My34BNm9hG
	9HNW2Et63AJijbI9UnVX4ELZhFT3m7OniBRVLbiuPC6Io2Ul8=
X-Google-Smtp-Source: AGHT+IH3JuuEMoP9YT3zyIl/+HUSXK+p3FIZ5E5NT2awhGYYunlZYurin74ce3hTLqp46OSwVZT1sA==
X-Received: by 2002:a17:90b:3946:b0:33b:c9b6:1cd with SMTP id 98e67ed59e1d1-34083074e9bmr20646792a91.19.1762260667843;
        Tue, 04 Nov 2025 04:51:07 -0800 (PST)
Received: from xiaomi-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7acd6d026dcsm2860710b3a.70.2025.11.04.04.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 04:51:07 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>,
	Carlos Maiolino <cem@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org,
	stable@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v6 4/5] xfs: check the return value of sb_min_blocksize() in xfs_fs_fill_super
Date: Tue,  4 Nov 2025 20:50:09 +0800
Message-ID: <20251104125009.2111925-5-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251104125009.2111925-2-yangyongpeng.storage@gmail.com>
References: <20251104125009.2111925-2-yangyongpeng.storage@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

sb_min_blocksize() may return 0. Check its return value to avoid the
filesystem super block when sb->s_blocksize is 0.

Cc: <stable@vger.kernel.org> # v6.15
Fixes: a64e5a596067bd ("bdev: add back PAGE_SIZE block size validation for sb_set_blocksize()")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
---
 fs/xfs/xfs_super.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e85a156dc17d..fbb8009f1c0f 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1662,7 +1662,10 @@ xfs_fs_fill_super(
 	if (error)
 		return error;
 
-	sb_min_blocksize(sb, BBSIZE);
+	if (!sb_min_blocksize(sb, BBSIZE)) {
+		xfs_err(mp, "unable to set blocksize");
+		return -EINVAL;
+	}
 	sb->s_xattr = xfs_xattr_handlers;
 	sb->s_export_op = &xfs_export_operations;
 #ifdef CONFIG_XFS_QUOTA
-- 
2.43.0

