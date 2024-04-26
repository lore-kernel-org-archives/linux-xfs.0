Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EDF374CC
	for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 22:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714168904; cv=none; b=WcG9P40JZUkDgPDgHBhSqnNJr6tGH8am9D2GYd+EjyvP17hvKmxCo1YP+JT5VNEGy34sV+QD7MmmLdgeQjmno3+1BF5Vv73ZDIogg+53LWXmzr5sPMhYV4tVqSz1CrZbFdrv+GuvOFxpRvFUXw4Q7DgTy+tmqJmp/Qp5LZwss+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714168904; c=relaxed/simple;
	bh=12evQ9RO5KwT8EVOLbTdF0+8edFHUWGZFX3EE3n2bmM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aympcdcE2VabLpYwgmRglKeLkSIN8z58lNiC1dZvaVEnmRbMOat6z+kbmBNdh7CRkObmaz5pM8HNfJIxMlKH0RHRycJ453Zwz+OIy4ApVf9BwZ9B8PEbyTiPnz1DHTqIquF0zGyuQU6bjZx6E/DKB5i6elwei71Wx9u/3nkt0ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=b8vg+1gk; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="b8vg+1gk"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-572229f196bso3270266a12.0
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 15:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1714168900; x=1714773700; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BB2zFTU/erO4wKsgmr35cNULPijutgrXH6T0vxGc6pY=;
        b=b8vg+1gkvqOc8L3OI2L7c+EiRigjwp6CSe3IZ2XTl2ZFzHI+HNAZ1QSWESTv11WHWk
         a5p08Kr6lR4WwO09pP9FNvHTnkDnPK7+YM1mscRFe8sl6g6gGyR+0fK1r0wuOEdwkn1N
         gYb6vAAgEje5hHQFjTzHFh0cvioPYhCyuxWwlz2WPiQasaOKa8A4uT40SSAqLC7w4VeM
         4QPcM3pRNGzhDT8klzospkG0J72eWO2On22ly/bJZZKZlevUSKBj32yjKZdSiG801GzL
         scokmcFv+/6p4sdcvCvkBp+/SXvjccoYC9GwBnHu47IoO0QFo8fh/URO/RUWrDf67yJC
         mTfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714168900; x=1714773700;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BB2zFTU/erO4wKsgmr35cNULPijutgrXH6T0vxGc6pY=;
        b=AbrJGnffSnMWWHOlYiKv4Qdo1G4GixehpJ5Dz+j8RhoeyayZy+NJ/mGwlDnmchBwrU
         bfhUTvmIClzdukHKXmdaVGTkrGA7XjXdO6ogDlghwMK/nWuoj65ZLlv9ipODxjHC0CJL
         NWJhqg03zq5K+ux5e95SaiHqevEfjUSvc/Dr1Xx7aKZFbyOTX2o2QwoFvgc6qZ2xoSva
         cZeMB0bpPH/KkFFQJruhB3vEna43N5yHbzRs/H2lX1J741iTbCpIh55ivQ3XCTyGJAhf
         a1I7PsgZQz9BZcVkOWHufTfjOUrHyWcUZqv7xG4hjsPosFxPn8j9YKAQeFRoMb6YL2be
         uGMw==
X-Forwarded-Encrypted: i=1; AJvYcCWFFEOIuZgEMDFxFkKQGLmoYDyl8ZhgSB6UUM5yigjACzXRrJe4A8B8oGvUx/i9tdVborTz+Rys42uVK9jgoxcSbU1JkUE+WopJ
X-Gm-Message-State: AOJu0YyVT6MGqo1rhNyZM6Lsy+PPlMkmGa8wJFac2+W7zbU/Ljf4i9/k
	6BUycCAXiaOJM43FMfY6hl9eKoPeYLPn/WzlyA0HhKnRAkffVbi+kqE0xV2gNt0=
X-Google-Smtp-Source: AGHT+IHwJ31F8r0Gkiz3UIjqIwqVvHqBw/6zhyN+VKRD2TKkKzS2KqGxPMJQfVuGryBMrXQQAFyKjA==
X-Received: by 2002:a50:d4c8:0:b0:570:5e7f:62cb with SMTP id e8-20020a50d4c8000000b005705e7f62cbmr2100446edj.29.1714168899809;
        Fri, 26 Apr 2024 15:01:39 -0700 (PDT)
Received: from fedora.fritz.box (aftr-82-135-80-212.dynamic.mnet-online.de. [82.135.80.212])
        by smtp.gmail.com with ESMTPSA id r19-20020aa7cb93000000b00572031756a8sm6560719edt.16.2024.04.26.15.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 15:01:39 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>,
	Colin Ian King <colin.i.king@gmail.com>,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@toblux.com>
Subject: [PATCH] xfs: Use kmemdup() instead of kmalloc() and memcpy()
Date: Sat, 27 Apr 2024 00:00:47 +0200
Message-ID: <20240426220046.181251-2-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixes the following two Coccinelle/coccicheck warnings reported by
memdup.cocci:

	xfs_dir2.c:343:15-22: WARNING opportunity for kmemdup
	xfs_attr_leaf.c:1062:13-20: WARNING opportunity for kmemdup

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 5 ++---
 fs/xfs/libxfs/xfs_dir2.c      | 3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index ac904cc1a97b..7346ee9aa4ca 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1059,12 +1059,11 @@ xfs_attr3_leaf_to_shortform(
 
 	trace_xfs_attr_leaf_to_sf(args);
 
-	tmpbuffer = kmalloc(args->geo->blksize, GFP_KERNEL | __GFP_NOFAIL);
+	tmpbuffer = kmemdup(bp->b_addr, args->geo->blksize,
+			GFP_KERNEL | __GFP_NOFAIL);
 	if (!tmpbuffer)
 		return -ENOMEM;
 
-	memcpy(tmpbuffer, bp->b_addr, args->geo->blksize);
-
 	leaf = (xfs_attr_leafblock_t *)tmpbuffer;
 	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
 	entry = xfs_attr3_leaf_entryp(leaf);
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 4821519efad4..3ebb959cdaf0 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -340,12 +340,11 @@ xfs_dir_cilookup_result(
 					!(args->op_flags & XFS_DA_OP_CILOOKUP))
 		return -EEXIST;
 
-	args->value = kmalloc(len,
+	args->value = kmemdup(name, len,
 			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_RETRY_MAYFAIL);
 	if (!args->value)
 		return -ENOMEM;
 
-	memcpy(args->value, name, len);
 	args->valuelen = len;
 	return -EEXIST;
 }
-- 
2.44.0

