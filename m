Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04621DE4F6
	for <linux-xfs@vger.kernel.org>; Sat, 13 Sep 2025 03:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757734652; cv=none; b=Z8W8ePllFJrC2XAqLvCw+rLssrAn6gp7NsgKUkQw6FS/9SAHWkAPb3nBSYTA1E62eS5fNoqQOZxSQ3cAskc61Q2t/CZyWmf3I5f3T2T8bjJUrzcADjxUUw3d5meaneiOU1nGKorj3sdJRDinz7MjPyN5XoSFkxw0lKY0RWgLxsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757734652; c=relaxed/simple;
	bh=nbmHvENF6wiVd4LFNsW3/Myx/TXvx5lSSh9ejpw6OMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dq09JfbZSE6F5jSyCNhl4buF5K7iLiCgpf0y8yN9Ee5MW+trUQpKTVxUME8gjXTMi8MoYZERXZOwvEg6qUE5+owR+px93QletQFqxAlNRiv43yhS4WjjzgVe3o/JP8FDmnuCpUFVCpJxNMrzkWrEc1XliQdXuHcIAD8A55m/ja4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RFYNYJ/t; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RFYNYJ/t"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-77616dce48cso914928b3a.0
        for <linux-xfs@vger.kernel.org>; Fri, 12 Sep 2025 20:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757734650; x=1758339450; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jP93xN6gwLHr70Ds3prjvKvRcobCNOyB/BNk5HT+4PY=;
        b=RFYNYJ/tuvLylsma9+lf6Nz3v0bne1J3fs6cSSuHfOMuE4Bmjym6fiENFu3AnC5nDI
         qQ7FD97rwLEKV4BsfEbjt3y5kR5cYom8qKFcii2ZHSPiEiIyA2CXnj86TVBmlFhtfA58
         zYzy60+RfPbmNNo4585c6usLQi1YESPXcGFJy4Ow2CRxvJlSa8rhM4CuUB9vrcTv7Zog
         Z+SvPWy+XeKj6lFFlD45eSBPZrQOdWwR9U831mUcW8hrol0JMpUQYH5KVIWMmvo7+HWb
         qnB7Ma12V6sJETFmvWITmKXT83qHetMPxRoKRuugYUu7O0iOJ6gOwKaOFMo2ijOlAfjE
         7l6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757734650; x=1758339450;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jP93xN6gwLHr70Ds3prjvKvRcobCNOyB/BNk5HT+4PY=;
        b=LYLxnw9V0CUppLVFQp7YpmqX4kumd74t0gfmGG/nhF6EMJxb2YbQh0CDb94PMValEn
         2UIadQBw1+pjsUIAEBdPCDt3xja6bUp+BdHQk6d4CFDjn9/+Ru8ggiqvRVNk4m9x7nmu
         RDQaHCuZy+TCIaDX0DKWQA/Ex9BCMzkOllkpd5LpImo2ZksheL5MeTaSqh1dXBbDPd/c
         cfyGlxbu0gcUZqVRvuAePdq2eGqiYQfHAAxpgc64JjKM548KkjR+dGcusEerr0svGTY7
         ZlohIOsmzNTOTmMTql6P4vfdn0YiDtFwxlMB+sHCpH20VqYcLoX/Z9o9g54UtNKolHRn
         gjmg==
X-Forwarded-Encrypted: i=1; AJvYcCXPmAjtQrEqoL01G4TMoegKDtI/3J9YLwJS5DCavQKRkRanktarr9vPXZAJuWp23zlBesTevmxXD1A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzymOI3SAAUoCwaxFg1C1Q2sBXY4VvRmTWjOltdVaY5+LxbQTIz
	PYFx1TNQNfBbwU35r6pBmf1fl/Ab9WLgJrdChHX+sIKHfkZFhqCk412o
X-Gm-Gg: ASbGncs7TI/8g6btCOQzlf1RNbrhtlN13F/KSl5MgyuNurXzXPRXeadmqX+JBW7P6Mr
	y2m4vcjxH+YpdH7DgtXeKT9trLc+4yBrLLuepHfiikzPbr6c+3Fhhe7X9EN6SLdL4yHB/PjY+31
	pIBVqRXwSiiMbDr2AsJgqTlRf1m8ij86malRYPTbZ1IqmJBp/Jmvc48QxFr3+aeQ14xe8JAhj5K
	YaYrHFipRjN/T3b6dNe3Y0gjVNFFSmbyFh5Knl7CXyMgxz6vEw3f0iyUc+cRZTpgMV+PicfMv1g
	yGEXfn2PJQ0QYYNM9ur24v6tmHSDWpsMibaAtBZGyPqcHg8IZPxKBRpwUWXAs2BeHWMSi9yV80Z
	5VNt3EKkYloSY4xzM9iOl++sLTvveMm+JU7zQsg2Sjoz2k3njN+f2pUU=
X-Google-Smtp-Source: AGHT+IFUutBth5XkTwW1pC/OkCDAZih9KHUCMdYgxnZ59EYAd9MvBO/hHD+Z59SU25Og0yzU16T+xQ==
X-Received: by 2002:a05:6a21:6da7:b0:24e:e270:2f55 with SMTP id adf61e73a8af0-2602c14caccmr5977282637.35.1757734649906;
        Fri, 12 Sep 2025 20:37:29 -0700 (PDT)
Received: from VM-16-24-fedora.. ([43.153.32.141])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dd98b439asm7150770a91.15.2025.09.12.20.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 20:37:29 -0700 (PDT)
From: alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To: hch@infradead.org,
	brauner@kernel.org
Cc: djwong@kernel.org,
	yi.zhang@huawei.com,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: [PATCH 1/4] iomap: make sure iomap_adjust_read_range() are aligned with block_size
Date: Sat, 13 Sep 2025 11:37:15 +0800
Message-ID: <20250913033718.2800561-2-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250913033718.2800561-1-alexjlzheng@tencent.com>
References: <20250913033718.2800561-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jinliang Zheng <alexjlzheng@tencent.com>

iomap_folio_state marks the uptodate state in units of block_size, so
it is better to check that pos and length are aligned with block_size.

Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
---
 fs/iomap/buffered-io.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index fd827398afd2..0c38333933c6 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -234,6 +234,9 @@ static void iomap_adjust_read_range(struct inode *inode, struct folio *folio,
 	unsigned first = poff >> block_bits;
 	unsigned last = (poff + plen - 1) >> block_bits;
 
+	WARN_ON(*pos & (block_size - 1));
+	WARN_ON(length & (block_size - 1));
+
 	/*
 	 * If the block size is smaller than the page size, we need to check the
 	 * per-block uptodate status and adjust the offset and length if needed
-- 
2.49.0

