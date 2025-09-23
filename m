Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526B51E1DEC
	for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 00:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758587642; cv=none; b=WDJ98jmLSHWX+vhrdwX/LM5eEFrguswvlTLbMkXaq7tPI51LrL3uPCV6Kr0Ul3dN/mkaO4MfIRlDLnRdoGqBZTgB8JIXDcJwPc7AvY78d6icrfYJceLZ+c8y/Zpr6J4ZHK/eApmJHhwkB76Y3zkSPUrRQjEWnpi7mBRrUv9VUfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758587642; c=relaxed/simple;
	bh=s6mhJfy1wLr9wwae+98XWped88EO8RR6Rj9hVh2fPUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kt2Y2rKFuNNrPVRZgDcRpD125UisLCCBkYW/7qH46/8ea20IGfMyzsDwm2hRfXHC8gNKjyrAIjwybRgI7NbAjVa96hICcg7QYMSDt+TCefBFrgiOX9Xr2bTzWgqo8YF/8HlRcNJ4WV6+qorEV0DVrhbFuCxnEvAJpxjouM3hmBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WN7ChBlc; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WN7ChBlc"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-25669596955so45134715ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 22 Sep 2025 17:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758587640; x=1759192440; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+b5voxvHVAQ9evPBAMJkr0K4640egjfoU7iv7FHQ8OE=;
        b=WN7ChBlcUcvD/CuQRoDxSCYlalJJ0DWmeKGqx3nWwxcEPN5o0l1AokBao54AosjfRq
         pUxz5TGfwIjDQR5z79NA+rf78aoBYW413W1trtClWZhZQ1NS4JlZfjwPApjo1O49Mc0f
         3ppRXqdrRYAbwGRA8o6qUrou+9LK7Wj9jhPGqpCnkR/JWtl4HKr5mjkix6upWxacvkL+
         jiXjX1INuAlVoF4l8F9moRa+uALWv4UnUeFjSMdSl09YyyQgQuuH9V8x+8VVt3/JC3Mi
         wdWinT1jC+EKoPCy+/x22/H6yNDU19r+sGI81Of9LeqsLuEmJrT1zFyDY2BVd7uhHFNS
         9pDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758587640; x=1759192440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+b5voxvHVAQ9evPBAMJkr0K4640egjfoU7iv7FHQ8OE=;
        b=J7cm5k7zGVBBKjRoAg5isPovpibTOhIqWmnEI0ZlCzsaH9Co8qYoBdG9pCB0LO4znU
         vdL17q/WqrbRMMgshNtz2pzK79fyPNXncse45WdlSjU6cKJ/IyCtZ7sK/lDexzxx6ubN
         Z74zAmt/65YWqxbihlMm3eVtC2hR6Zvu40gSzYlU9Y8ABlVl53ShLkifXrFQQG2fmSMB
         lFWuTDNATfiX7cYlAHsJn0FR1MXePQ2+Ng0Euo8RRyWPfZ1Km/BKroG+7wmZUnizhoU/
         tE5b1sM/U7v7MewXAnUa6+x16pwFwvDlmBpdgbQazlDjJ/KNOD04G2xcyI+eoeNxFQS/
         bA2g==
X-Forwarded-Encrypted: i=1; AJvYcCVtpEKUEBQAhwrbWRUUuGw+JMRfrFW+T1B2msrFY/o9yog7YMyCwKYCKiACulSG8uEf6PNMTyq6+uI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyoUFDnFVKHZN71hd19VF0vhnou6dVpjtGLyzEG+lA7nSO3in/q
	RG03+9cyF89H00GcTEKmpBEj6jcD36pRjG9/hz4s7fByJtPmkPAOF5lN
X-Gm-Gg: ASbGncuxCh2RG5GxuncLC1qJYdKtcFNuYHeaX3bmpe22HrHQX2r43c7mxiTrF/NDO1e
	dKI5H4mNY7tH8rMQ7R3X6bhYBJ6pa9Qa56BhQgxdcp+H4UvV7A1t46/L9fkVtS6qRFf8F/29MGz
	5+oIA0f7CsiG7jUPC2kWqk9b/lFay1Plzz/HKDgmLeo8GQ2Sx2qTViwwyrWpAkfU53V4Tq7miBK
	6YA8WutqijzsDEbSBg0ka+Xv0gzjQP9n9hjCwDP67U06rKyV08nmcqvlNdHGDYDd2JQVpzsaC4L
	8PZti0MSshE6jF8JVPhllnqreYYAVSw1owGRhJDeqs1KZLKtxBnk6RRcazMKk3RhMPBAn6Epit5
	NqSiULeijX9daVIfUoBHOXpjciFzL85oOATV88YcxXwZbhqJi
X-Google-Smtp-Source: AGHT+IE09TVUGqvhRnJ0j5/kebD7MODetqdlA1rNkjmRk63jDyjVyF8TO49tFsaKOOBbleAow9Cquw==
X-Received: by 2002:a17:903:1209:b0:24f:dbe7:73a2 with SMTP id d9443c01a7336-27cc580deebmr7891545ad.31.1758587639758;
        Mon, 22 Sep 2025 17:33:59 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-26980180bdesm143588125ad.56.2025.09.22.17.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 17:33:59 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: brauner@kernel.org,
	miklos@szeredi.hu
Cc: djwong@kernel.org,
	hch@infradead.org,
	linux-block@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-doc@vger.kernel.org,
	hsiangkao@linux.alibaba.com,
	kernel-team@meta.com,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v4 05/15] iomap: rename iomap_readpage_iter() to iomap_read_folio_iter()
Date: Mon, 22 Sep 2025 17:23:43 -0700
Message-ID: <20250923002353.2961514-6-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250923002353.2961514-1-joannelkoong@gmail.com>
References: <20250923002353.2961514-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

->readpage was deprecated and reads are now on folios.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index dbe5783ee68c..23601373573e 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -422,7 +422,7 @@ static void iomap_bio_read_folio_range(const struct iomap_iter *iter,
 	}
 }
 
-static int iomap_readpage_iter(struct iomap_iter *iter,
+static int iomap_read_folio_iter(struct iomap_iter *iter,
 		struct iomap_readpage_ctx *ctx)
 {
 	const struct iomap *iomap = &iter->iomap;
@@ -487,7 +487,7 @@ int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops)
 	trace_iomap_readpage(iter.inode, 1);
 
 	while ((ret = iomap_iter(&iter, ops)) > 0)
-		iter.status = iomap_readpage_iter(&iter, &ctx);
+		iter.status = iomap_read_folio_iter(&iter, &ctx);
 
 	iomap_bio_submit_read(&ctx);
 
@@ -521,7 +521,7 @@ static int iomap_readahead_iter(struct iomap_iter *iter,
 				return -EINVAL;
 			ctx->cur_folio_in_bio = false;
 		}
-		ret = iomap_readpage_iter(iter, ctx);
+		ret = iomap_read_folio_iter(iter, ctx);
 		if (ret)
 			return ret;
 	}
-- 
2.47.3

