Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3892185BB
	for <linux-xfs@vger.kernel.org>; Tue,  4 Feb 2025 18:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738694456; cv=none; b=sdOxHsGx6EkgszWULQzY/tyqmINrSFnhFXANY6CKFJJNHcD+NjvAb+4OFl8tnw+l8QStkVqgNoxDeQRUMc4jm/KKuBUC2t/Er01F1ng5wmt+ByCdqnlVGjd/GYKXvElAg+5ptGpKJGXf2NI/pdlNd79BMkw5qoWTtrnFT0bavIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738694456; c=relaxed/simple;
	bh=gYqlxH8GolKDSLeWnMu2FyjD68HspgIw8aElgRpXgks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omXfgOxRGZ8hcPFFkzTSL4JtVDGzDTB38oFlll/leFqQNfHRc1hzbsajawZnpCZy7wQOpoE+s6l1eNocLROCsy0e2eou+MCLDeERTYmh/73d1PXgk6qKR154n9p+019nTMm05URxYSXaCnEQo/F0a5Insqd3a18w5SwZmUe8ZCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CKxAuvJG; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CKxAuvJG"
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3cda56e1dffso17491235ab.1
        for <linux-xfs@vger.kernel.org>; Tue, 04 Feb 2025 10:40:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738694453; x=1739299253; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oo8+F9cgGTX42PErb22PshF/uqB7G7yJsEj/Ne45U7o=;
        b=CKxAuvJG0pmiOe074jmBtGXyIN7auziL8tfzFnkazDypxba2Am8zHDEz9QX6pWsLfV
         fji5iKR7lr4tb1F7gEnJgjG/rqvgezejGPqrKC0+CykWQ/7XglGuGkWr47Z6YpcJFvPs
         OOtQ+uthI1b8AUEi9EtJ3hp43mvq7ld88ZRyIRGlC6z90UdVJVVDS2FrtcWlXfQpcvVk
         1VnIiJA2fJoKITlPn/OXbV0V0DGKefvJJTp6JEtJ1R87bByjibsg6smHFOwIo6wUIeap
         FLX/5DzpbJiAr15GMEY9ubJWKD8CLnN3rzjZst8XEyt0l8xFtdQzn/am0GJk7rSKMqM9
         8qaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738694453; x=1739299253;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oo8+F9cgGTX42PErb22PshF/uqB7G7yJsEj/Ne45U7o=;
        b=VHwkD+rQyWF09uAGiOH87joCNk8cfAAl59fDjhR/EwG/JDMfFRodNkWecMp/oQI8wH
         rkB2nC5Ysqf2rT410wNs5RKFj5cS1SmSUXi6gG/5vHSEP9IPBvIKKMftE2+nPyp3GtRZ
         d07lIiCeLbhEiamX4S17m5nL10X4VTzWO+o9YmHOTsrEoRokLIKwAjFtPUgNfip/spx1
         qiqjCuyJQzPgjNSq+VAIhb1G7XvSPV1C7M0n6kfwyxhylrfynsDeEkWXTyFA6l09VtMw
         2WYY65A4Q60suuTvJkOnq5JjtcAdV8HR5NpzFNxRLVMpt+bOf7YlDHnvIU3LUpb95TD+
         6YMA==
X-Gm-Message-State: AOJu0Yye6YGCtS24RHa5VRqzgKIBLCfaaOmqQlvnUEz4Id8cAnZ1QNcO
	Ydb0K1nmYQcQ023KEy+YUVHXCePDivZosZaJCM/ec6fLL7XKTGI5B6EwEsbzBW4=
X-Gm-Gg: ASbGnctxpG8XEzNhxViyhmf7epYO5MRiKwH46iTzrj9DGlmLbXkTFPHnVvQcWVAjpOT
	2F1sMw6Z/PG/CpbaWPjsVnptsqoov1x4CIP4uSICTPUQkygwr+/spKi77WMmvPg7PfzAwnYkeJS
	R9Sf+fvmH73seYru4J53b8VGOTml2NG6LkSswWo/Mf9C4dr2INWJ40dd5rwIR+NnqHX9b2BGXmC
	f3feb2Sx9Zh45R2jiBfGCoGUljxATmAYXGJo3yNVoCM2kGcyCbVLAtS7K+2s8xIQ66vqiJj8Hor
	qAcDFFdxDW7Kl0BQaBo=
X-Google-Smtp-Source: AGHT+IHhjl49fZxNydJuwYuMXm5SUF7HB9j8noa/xkA4OIWSen7IjQa2Z7d8wcUPEBj1HU5DBmVfWQ==
X-Received: by 2002:a05:6e02:16ce:b0:3cf:b87b:8fd4 with SMTP id e9e14a558f8ab-3cffe4b4021mr219647845ab.15.1738694453378;
        Tue, 04 Feb 2025 10:40:53 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec745b5054sm2843148173.44.2025.02.04.10.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 10:40:52 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: cem@kernel.org,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] xfs: flag as supporting FOP_DONTCACHE
Date: Tue,  4 Feb 2025 11:40:00 -0700
Message-ID: <20250204184047.356762-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250204184047.356762-1-axboe@kernel.dk>
References: <20250204184047.356762-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Read side was already fully supported, and with the write side
appropriately punted to the worker queue, all that's needed now is
setting FOP_DONTCACHE in the file_operations structure to enable full
support for read and write uncached IO.

This provides similar benefits to using RWF_DONTCACHE with reads. Testing
buffered writes on 32 files:

writing bs 65536, uncached 0
  1s: 196035MB/sec
  2s: 132308MB/sec
  3s: 132438MB/sec
  4s: 116528MB/sec
  5s: 103898MB/sec
  6s: 108893MB/sec
  7s: 99678MB/sec
  8s: 106545MB/sec
  9s: 106826MB/sec
 10s: 101544MB/sec
 11s: 111044MB/sec
 12s: 124257MB/sec
 13s: 116031MB/sec
 14s: 114540MB/sec
 15s: 115011MB/sec
 16s: 115260MB/sec
 17s: 116068MB/sec
 18s: 116096MB/sec

where it's quite obvious where the page cache filled, and performance
dropped from to about half of where it started, settling in at around
115GB/sec. Meanwhile, 32 kswapds were running full steam trying to
reclaim pages.

Running the same test with uncached buffered writes:

writing bs 65536, uncached 1
  1s: 198974MB/sec
  2s: 189618MB/sec
  3s: 193601MB/sec
  4s: 188582MB/sec
  5s: 193487MB/sec
  6s: 188341MB/sec
  7s: 194325MB/sec
  8s: 188114MB/sec
  9s: 192740MB/sec
 10s: 189206MB/sec
 11s: 193442MB/sec
 12s: 189659MB/sec
 13s: 191732MB/sec
 14s: 190701MB/sec
 15s: 191789MB/sec
 16s: 191259MB/sec
 17s: 190613MB/sec
 18s: 191951MB/sec

and the behavior is fully predictable, performing the same throughout
even after the page cache would otherwise have fully filled with dirty
data. It's also about 65% faster, and using half the CPU of the system
compared to the normal buffered write.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/xfs/xfs_file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index f7a7d89c345e..358987b6e2f8 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1626,7 +1626,8 @@ const struct file_operations xfs_file_operations = {
 	.fadvise	= xfs_file_fadvise,
 	.remap_file_range = xfs_file_remap_range,
 	.fop_flags	= FOP_MMAP_SYNC | FOP_BUFFER_RASYNC |
-			  FOP_BUFFER_WASYNC | FOP_DIO_PARALLEL_WRITE,
+			  FOP_BUFFER_WASYNC | FOP_DIO_PARALLEL_WRITE |
+			  FOP_DONTCACHE,
 };
 
 const struct file_operations xfs_dir_file_operations = {
-- 
2.47.2

