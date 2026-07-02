Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A142C21C7
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 16:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009213; cv=none; b=h07tB33uZFtdSq316hJTdq5YvDqOrxvqhvSEUhrl2/1Osf0/3BCfMlmobLgwUdggU9S9pEBKZYCFYM0EK3c+DFBRMOZFVW5iamGJCLnKUD23HnHWlR/Av//e28N/WmMXZSyM58dCaDqevrDcVmtyuEclnZfO9jgrtvfnOt62U4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009213; c=relaxed/simple;
	bh=W3ykyHJ37TovsPUJiEbET053NEuh8bNtDCvV2PssdlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Si+5Zl9hzSJ8jI8LkxpN3xiw5HvlU301/VAo4tx/PUrahVslE1T855kfy7tWEA09WJFL2mHEwc0dHves42ibMHzcIOuAwmZQ30zr6hZY0nn2+FHgU0pB0HLmJ0Ok4sXdYn0LX7mVhaOQsmNchNWXsRPCjtRYDDR1C0sA8VnRokE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MyxZ/yu2; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MyxZ/yu2"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2c7c61b5292so23815475ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jul 2026 09:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783009212; x=1783614012; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i2AVbRbeCtbFImQ+3TpP2Z0P3hlECgR0k0w4DL2MbTU=;
        b=MyxZ/yu2qs3extwId7DVva65DrLC7kYrHrf2/az/8pF/AvhEo1Hk4YexgCtjhWnsNF
         z2N6sCzwS3G4e1E7iEAoqybvlo7tk7UN9TFGMOm4IzXneZmNhidQka/T+pe4PQDIfID5
         sCRGfWt/seXVuzz1E7NGGkp3wngQkyheUuFwrxcYzRvY+Ayk38BYcsP5A1eehYa7FiC/
         pFAt1nHB8CBgwJ7mSWN2ZmZ7iBCcc8KUY1jlzFgmMNoC7XWcFcAi9LDKBYV2LW6A/lch
         M29XAdra9rMvF8aKhGYfHMfEQOwliYHvUqxSP0oKQlnWfRxbxxawuNSqvN5fwroE5YZI
         DPig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783009212; x=1783614012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i2AVbRbeCtbFImQ+3TpP2Z0P3hlECgR0k0w4DL2MbTU=;
        b=B14IS73plCO77otk3WWGnhb7NJICesF5Attl8dFfIwmTOamYW0DWUUBbu3Yj6p/Cb4
         YiX9u3BkzasVBw5j92lBWeuiwlA1NE2xLeR6lxdyY5UvwtkkjK7k+Qo2k9Jgrfw8ILs4
         xbP5DHtSrS1CmtIbtxUyZDF8Lv7RfMFTha7x9iO1+T0zJau+fpNA+7KGIcw9VzaJR4Yc
         8p2ckGXEI2elJvjMQG2TY6a9g6eFpdy3Awj8b3MUXyfMa/2Hqhtn/OsTrF1hDkoQvueX
         kzhpXnxJPT1VpIAijhW2HC6crgl1za8yBOJDrp0NDaFqlLGhgVgULTeW2/DijO9KjIMY
         mwhw==
X-Gm-Message-State: AOJu0YycYfqS1u6o9feqXveAVMZPwAaE9bXx+J7VlSZPNh7+BBkupBQD
	ap0N8vybmFgF4uFQfEybb7pH0e8EcpNcNVFfzZ8OJZvQhQSblPt+kQ9KLThFXHuW
X-Gm-Gg: AfdE7cnMM3+BNn8cBMP+kP3qkaEQXInkKxwSdNyRCILSewaBiJr6ouJghbzlRWbf1jj
	M43bAL48FH6FmW8fC9qhq97F5FiFPKKMrYJhtUDxbB5dBsBLVw7JcLMOEjWW3Fv37HLJiUuiuAI
	+3DLLa5aSfkZT1KK6KpKvqx0sn4sXznri+OQU/gyEguePt5XGLKJ2fbmjXEPjw0ABeXZWYE/52M
	I/bD53Z72GAx5EbXlKHtq7+4AIoYyTxROkP05z3iB21S/UGJamwpKxTPKnQiwSFSNVzGUptsIuv
	jc73F6xXemSUvJCgXxyCzbgzLN65vXVBLeReu5zcP5YJa+v6T/0MLdFyzYLj4eyehP8h4xR2TQy
	AT8JvL00YElcOTcBpXKNy1k18ywV63k/stPO1sBsG+BP5XyL+fW4pEJcQv+EmX2tv6lwffwjU4L
	Y+8O6sK9nu5P064eziRNQFu9UFfvOPTC8f0coqxcK47d1bY2pemZbtUQZuNg==
X-Received: by 2002:a17:902:f547:b0:2c9:97a9:2099 with SMTP id d9443c01a7336-2ca9123c3d9mr60038525ad.45.1783009211262;
        Thu, 02 Jul 2026 09:20:11 -0700 (PDT)
Received: from fx.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b3c85b345sm16493826c88.10.2026.07.02.09.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 09:20:10 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 1/3] xfs: drop ASSERT(0) on unrecognized log item type
Date: Thu,  2 Jul 2026 09:19:58 -0700
Message-ID: <20260702162000.3548359-2-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260702162000.3548359-1-bestswngs@gmail.com>
References: <20260702162000.3548359-1-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The item type passed to ITEM_TYPE() comes from the on-disk log, so a
fuzzed or crafted image can reach the "unrecognized type" path in
xlog_recover_reorder_trans() and trip its ASSERT(0) on a
CONFIG_XFS_DEBUG kernel.  The -EFSCORRUPTED return handles it fine; drop
the assert.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 fs/xfs/xfs_log_recover.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 5f984bf5698a..a1b373c68f0e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1912,7 +1912,6 @@ xlog_recover_reorder_trans(
 			xfs_warn(log->l_mp,
 				"%s: unrecognized type of log operation (%d)",
 				__func__, ITEM_TYPE(item));
-			ASSERT(0);
 			/*
 			 * return the remaining items back to the transaction
 			 * item list so they can be freed in caller.
-- 
2.43.0

