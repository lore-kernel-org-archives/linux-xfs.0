Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D099192590;
	Thu,  7 Nov 2024 07:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730963003; cv=none; b=DMLUK+h7A0mObC0b9MYGtKXvkdFf+MhrazpR/e/IZYDfmX8Hu+rphFq3UGmuM9jrObDqnmf+Gkx3kT4HzK0W+g8o4MTlkBo9wAiUVmjKJSmX1UOsuWiNtdZ931CQZA+bknNSWwZuaXXGV1vkaoNmovYrcAql7m/EZnIWsqtDcu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730963003; c=relaxed/simple;
	bh=QSnARRy14JiYr+ZU6QB/x2aKO3py6LrsAndtrC2tucY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VZ+UKRa56LhDn929/VMACNfEzqiSchF00TgjKBawzkfNmroQvMPuX1uuhEoAIAQh5GQgRcdEpqFiehA0y6wOp7w5W78ZX35jLraqvTHKU03CDdMDZscXp5hKG/QJgSlHf4WnMhCUyU9eP9AV9y2cHIIsGeyaU0ZgkbAw0AL/Gq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SKimkn0K; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SKimkn0K"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-7ea7e2ff5ceso501440a12.2;
        Wed, 06 Nov 2024 23:03:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730963002; x=1731567802; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yKXk7y7+DWGhXnWzs2Nf+nojqizRex6j2FV42fWmgGM=;
        b=SKimkn0KgG+m5OQGwfRxGG8vNqrLxMsib4nnrvyyqiOjiswcXNoA52PGltQ+l4FaE5
         QVASDSF8nH0sRZ4fwgZtTSHjEEiRHJm9KHAUs3fc46bV0BxEK11tb//FuHjTYKfXvtfB
         rPemVnuFZwq0TUJ5IVhVr4OdltShGWHdvKgGU8nerzMSPk61GVxBzxMuSLx1rOnfUwrv
         T61naVqVRgKp6K6KPAFZ+YWsVyyIK9HyNNJIl/RcpcSm5EuJ7RGyPQEjLJ+0P3AHjhhp
         I02W62t7VC5W1TB231JZEQiZM3OUdTwxs8xmLv2OG/XsQ9ur2+tzCszPeC7JzdNpVrPh
         D5SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730963002; x=1731567802;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yKXk7y7+DWGhXnWzs2Nf+nojqizRex6j2FV42fWmgGM=;
        b=dUUy65wgL0Gf6OPkHGlXsDa6jRVbVWiyyFxT5VFeWZ6cu4VksL6FGPkx3VlLwgwci4
         w9YkFhais3zGOZccBUvsdOLVjQQqfJX2qr8Df1SJBWtru4SAvnqJnFII41xvpx5wp0mM
         UNcOvU9fhzA+chXY7dcxMzomac2UABDfY7itYHv2UgxBaa5oqd1mIAX5TwD7HjginNc0
         RmbR/AjP1iauuOdeh8uVKN6CJuiPcKFMT0HxnabCeWI0DPquwWgGGLXgU+eSHZ7h2EOF
         ca6UTp0N11dQ9cVnFMvM+zqfwDU4eKfiLvNJrN8ShMbGve2Fob9YkeDdxG1xuyMQGAv7
         BTwg==
X-Forwarded-Encrypted: i=1; AJvYcCUNQxB0CqyCR0hsdoJJhIZ2WMv0BlhnluATF3XyFgPNQ4GqSzxp5QbrInaBzJvuV1HA/tX1eHrj3kfUer4=@vger.kernel.org, AJvYcCVtu7O1xst/5bd+RBNvf7XMSZelisDSKl5tdwvHtEVt+6pYxJpT0ZpPnfb5LfK//AIFmyT7xCL5TZeF@vger.kernel.org
X-Gm-Message-State: AOJu0YytpKRDE4DEzYiSU1RWs7MBjOTLdVRt3iiqN8pWmSq8VMWWtF10
	tpxQDcvYKoovV3a3Tcbf6AiWL3k9AcBUVdurL78BJjEObvi1n7qN/74+ew==
X-Google-Smtp-Source: AGHT+IG4fAUttPAezJ2jsgnVG9JTTBQ7TTzRipjFB9v7xddpodiwBjsWVMjWTVLtoqSO17li7akQOA==
X-Received: by 2002:a05:6a20:3d8a:b0:1db:ff57:562b with SMTP id adf61e73a8af0-1dc17b2b62dmr149615637.31.1730963001607;
        Wed, 06 Nov 2024 23:03:21 -0800 (PST)
Received: from localhost.localdomain ([119.28.17.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e9a5f5ffb7sm804730a91.13.2024.11.06.23.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 23:03:21 -0800 (PST)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: dchinner@redhat.com
Cc: djwong@kernel.org,
	chandanbabu@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: [PATCH] xfs: fix extent length after xfs_alloc_compute_diff()
Date: Thu,  7 Nov 2024 15:03:00 +0800
Message-ID: <20241107070300.13535-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.41.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After xfs_alloc_compute_diff(), the length of the candidate extent
may change, so make necessary corrections to args->len.

Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 22bdbb3e9980..6a5e6cc7a259 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1069,6 +1069,10 @@ xfs_alloc_cur_check(
 	if (bnew == NULLAGBLOCK)
 		goto out;
 
+	args->len = XFS_EXTLEN_MIN(bnoa + lena - bnew, args->maxlen);
+	if (args->len < acur->len)
+		goto out;
+
 	/*
 	 * Deactivate a bnobt cursor with worse locality than the current best.
 	 */
-- 
2.41.1

