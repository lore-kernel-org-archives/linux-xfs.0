Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F0E20B7EE
	for <linux-xfs@vger.kernel.org>; Mon,  3 Feb 2025 16:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738600474; cv=none; b=abKvliyY6mK0hDsrTRfhDmP1mGhkZs1ygoPXwheEXs+YaQQSVS6K4ODCPXowFdpzkl37+oA86jwku3YQWGGWUp+TQrWWLeQCIq+MKcqL3d8xFXP4taySGc4/OlgcPCCua106uEyK+4/75XSP+rx7L29N2EK/yRLZv0kwhU2NcwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738600474; c=relaxed/simple;
	bh=gYqlxH8GolKDSLeWnMu2FyjD68HspgIw8aElgRpXgks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZHWbHvt7uFDSBQ50SjvEw4mPCVltEceiIYIoxEgeRuyLIelgdu9M2wXQDAT8yKzzqvA5Zk1dQrA3doJDbY5krw1lHap2GFDEH3GeO5amlsmMWW2T3GJZDuxCnG68Bqxb9zN1SljuY/PWo4zKr+E21LiClgdl49pgfbA95lnteo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OyfHL3+r; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OyfHL3+r"
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-844e9b8b0b9so315158139f.0
        for <linux-xfs@vger.kernel.org>; Mon, 03 Feb 2025 08:34:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738600470; x=1739205270; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oo8+F9cgGTX42PErb22PshF/uqB7G7yJsEj/Ne45U7o=;
        b=OyfHL3+rgfR9sbk7PIfEYGsiaGAriQ7O/C+s2SSOln04HVzfDgN36XDL45pfzJjOgh
         CJvJbg1AIJzcFY7XidZl+OLXic2I5D3OdIFw780Tg3Ly+1J9hSgacSLyWrenBth6mUW+
         YSdUoLH4JwmBIs/duss3/lucyvCggOFCDgz+6HM8JLi9m4obeLCCGjaRfNSeJBXTY6fk
         obUU9sxGkF+Aj65jYtT7uBPYw8UuqvKUlFSp6jq5slKuFhP71hsAaxSdxjAix/KQYn+8
         7Wz+cpyTBOPlB8iSsWDVSV1Dglq8vW84L74B72aeR/0Zd0txrh1lm5kkqdviKtIEHapG
         LVmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738600470; x=1739205270;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oo8+F9cgGTX42PErb22PshF/uqB7G7yJsEj/Ne45U7o=;
        b=bSaVRZ2QUKn9iIuV8ivTtfU5HPy40MSkIwraR+WlLJdi3lSPzDbRvMYTaybU2Gc16y
         xWbiBicHgScf6gbzSniNlcxf/TkCdFlrYOlfBUK8WaLXYNtQlREwbZ1rrV63cC0gzmc7
         LnBzujPjFSOC0Z52OjnpOg4YC9aKcdCFz9kK7m+kqvnEJ5iKZzF8lXoBy7fgOiWqgf1a
         KW8z/888dJMWPFOYBKVWpJR+OJ5R3ghDacoJ139SwJC2u+Enla6ZqRDHaExtBWzhPJ3V
         JqLK826cSKrwqAZuYzCT7MxoyHS5EOsKnGnbc4exyqmSqqECY1tS6rtFbFxERxRU5L25
         Z9Rg==
X-Gm-Message-State: AOJu0YwvwmlJWJMn81KIBbKCIqtwO3T2yGdm82M15B5+bu0xjyeZgi2R
	TwGCXWhf5lsvWas2KNzkGj+tPF5RpCsH4L5ufeHya/hSfCAsJJ2X0x4VI0FMlSLnsgY1KM46fPH
	EU7Q=
X-Gm-Gg: ASbGncvQGZF4ovhCXgeEBSd5CkdIr5X8urDYDmhnSNOZ8rrcx3n9sVn5umlVk9NlE2p
	MX5VIzIF4NAAWHpHUg0yUbpd8e3jRe9+oFD2SF7p17Cl2yd1V2syTPoSSJzIQIFwDX4HsBJ1RLe
	4pe30ZMuq3chm27zjx/ynj5r9Sk9/EHdP0XPNzmYW4vJX+3OMN8JBlvTUPk5i1mjkto2tV1HxgX
	tcJGuRV1JuWNT6SUi17J/LeDAMd4wMgo4xtXYt0Tuj4WCciPXB+cYI9HygAKMqbYxbO2enBS/A1
	r/V9T6MT7ooW3d+x2uk=
X-Google-Smtp-Source: AGHT+IGhuZqS5aS+0wOtqyvYjOvPyZTM/MsPLunTQ/uiDL6W1jTju6XhivTYDzn9yaWTRLqWMtOWNg==
X-Received: by 2002:a05:6602:610a:b0:854:a268:9bbd with SMTP id ca18e2360f4ac-854a2689c1bmr1546872239f.1.1738600470707;
        Mon, 03 Feb 2025 08:34:30 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec746c917esm2279580173.129.2025.02.03.08.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2025 08:34:29 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: cem@kernel.org,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] xfs: flag as supporting FOP_DONTCACHE
Date: Mon,  3 Feb 2025 09:32:39 -0700
Message-ID: <20250203163425.125272-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250203163425.125272-1-axboe@kernel.dk>
References: <20250203163425.125272-1-axboe@kernel.dk>
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

