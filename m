Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE9B1482F2
	for <linux-xfs@vger.kernel.org>; Sun,  6 Oct 2024 14:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728226385; cv=none; b=WkxQHiPiG+g75LryxNxBzQSrq2/EI654gg4Yt9aAHh7YbzHizrFFes+IEIH8p1ZlDpLJZElpcni8CTnqHrc9c/ttxJmxiYD3K3tEwvzqD1UoAhxwcOIs27IED9SU7LIdv993HfpOsTO5hTeUFtIy89v9gXK5mwQDCRNyw8uhXG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728226385; c=relaxed/simple;
	bh=rhJ9GRZNgwHY1raVKmWuJN9qtyI0iNeH7MHZzGrpBag=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nc6ksvz9SaZxuLG4kc8J4aM5dhDILvqH+CMXSK2wrWfFX8BPA+3KtwVLrn0M8qGsewyYVSqDpgUmPJDLb86Aip9LtjdQ2jdP66zQLETR8A2jM2wSGQHq63Qf13lVMtqDQ91T4uYhQTbeLSiU/Ln42ApjDp1xobW2F1147XDJLtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com; spf=pass smtp.mailfrom=shopee.com; dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b=P4kxfRrn; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shopee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b="P4kxfRrn"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2e0af6e5da9so2703149a91.2
        for <linux-xfs@vger.kernel.org>; Sun, 06 Oct 2024 07:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1728226383; x=1728831183; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8AqnyP+Byv1dd6vDoQ+Ar0AhPFXyUFcqkrKiBNXDFDI=;
        b=P4kxfRrnfOTUhLfMRH36lD5Mqw+3Xxj3VHD7XPNLOPXVjsu6G29ugkz5H4tpAugc+n
         Xtx/suJum5v5aCre6gIJADij2Yco+SwdNJUSDrDwmRUV7VAn3hhY+UhG9cqAPYwQ1M+w
         6z/JLlfkQ62Eb/TA16NpzPexB7SXb9xSWx8+NpwKY3uOPKzhFpIlzh0oTj1cjAumRKLQ
         c8T05yj3l0d0e+OQjqhfG71sWqpWMCaQgj2qD4aFTQ1cVkoiPhOwJSyHszsFj0xaZLvJ
         BZJ8+WXbk7UPP3YKlcIwYcQZuXl67tGeN8LLZVSRS4EtQMsoiwT7cj8KBD4TCAL/ffVF
         Rw8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728226383; x=1728831183;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8AqnyP+Byv1dd6vDoQ+Ar0AhPFXyUFcqkrKiBNXDFDI=;
        b=YEX7/liw3YtY7j37aats6Ye9U2BvINCKhz5o2k17K7XLO6Ik0RBPUnkkHLOWGjhyOj
         F11piFTefBe3FAYgMTRgq2ygVusi9JkD5Kn8boybm/l+YkApepgl2bg05X8zGKN+UIZg
         zLoXr83FcFkGpu4gDGm73Up8ONPYY2ToxG5YCyy9Jn5iVyVolXXrAjnfon6CWHuDSRaw
         l6j7RtOl/+q8Tz0+zZYq23/dAVIVDbe8YgSeexxrUWj7gOSsPyNmr+7mQU0+pr9AQ7jh
         +QLitgYcH/JE2w3t3UB1OqrhLfCj7JwXBcS9gcMS56CGiAwZNNM6rlBwCDx7bNEGdR1E
         gGyA==
X-Forwarded-Encrypted: i=1; AJvYcCUmXoQ4cHBchoGcvCY7t6AWgoe8CvaQUos83+U2MhmeX8i+ncd/d0RDldDtb/Ea8qiQBKD9owHETvM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6O5l/Y9UT5KV87GcGiOrjprUNWyjJzhSnxtpqoQtv/Sxk9/Ag
	geibFAVULdSLlg0Hmom8y/XdWj/34qdW92W+42IjX7wkVYdK8V2PMa7iq1NnQek=
X-Google-Smtp-Source: AGHT+IGPeVAO5tVDuO+R32h3LCBclCg7gEXpFP9t2p1QktdHAai9ZNmvTFB36rtLf2nnkg375yrefw==
X-Received: by 2002:a17:90b:4f87:b0:2d8:8430:8a91 with SMTP id 98e67ed59e1d1-2e1e6221b1dmr11933090a91.10.1728226383035;
        Sun, 06 Oct 2024 07:53:03 -0700 (PDT)
Received: from localhost.localdomain ([143.92.64.17])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e1e8664bfasm5213680a91.44.2024.10.06.07.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Oct 2024 07:53:02 -0700 (PDT)
From: Tang Yizhou <yizhou.tang@shopee.com>
X-Google-Original-From: Tang Yizhou
To: jack@suse.cz,
	hch@infradead.org,
	willy@infradead.org,
	akpm@linux-foundation.org,
	chandan.babu@oracle.com
Cc: linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Tang Yizhou <yizhou.tang@shopee.com>
Subject: [PATCH v2 2/3] mm/page-writeback.c: Fix comment of wb_domain_writeout_add()
Date: Sun,  6 Oct 2024 23:28:48 +0800
Message-Id: <20241006152849.247152-3-yizhou.tang@shopee.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241006152849.247152-1-yizhou.tang@shopee.com>
References: <20241006152849.247152-1-yizhou.tang@shopee.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tang Yizhou <yizhou.tang@shopee.com>

__bdi_writeout_inc() has undergone multiple renamings, but the comment
within the function body have not been updated accordingly. Update it
to reflect the latest wb_domain_writeout_add().

Signed-off-by: Tang Yizhou <yizhou.tang@shopee.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 mm/page-writeback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 3af7bc078dc0..68e48749c947 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -586,7 +586,7 @@ static void wb_domain_writeout_add(struct wb_domain *dom,
 	/* First event after period switching was turned off? */
 	if (unlikely(!dom->period_time)) {
 		/*
-		 * We can race with other __bdi_writeout_inc calls here but
+		 * We can race with other wb_domain_writeout_add calls here but
 		 * it does not cause any harm since the resulting time when
 		 * timer will fire and what is in writeout_period_time will be
 		 * roughly the same.
-- 
2.25.1

