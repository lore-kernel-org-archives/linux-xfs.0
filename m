Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3252542CAE4
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 21:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785187478; cv=none; b=okyCEdbZxj4WtHG+ouV+agQzG96w5ezcfZtYF3oCrUBcbAHXwRZ+Y/Q/1JHDglHcAH5vGFfHI7EZRqamuTLV7jhWj/c0c4rUIzWe4TZoCwwLjZnMB9voKPbHD89nsaymhKutseaQClFmiBM1ej2vRW0EeB+Ux647gWzMkYpxl0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785187478; c=relaxed/simple;
	bh=5irZFB1XN5m7fpRyd0F6vXnlyVcPBIQh1QapeNopw1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tmfr2OMXxWQLPyb1xMcoLJuvr1WeQ7fsS2qbISoAsoFjo5jGbvFNKipbNgFIj6Zx5uDNtCk3VYxjp8yzH823ftxWoKh0jVpFF1FNXD7YS/HM3fG4TzFeNOSooXTYo8URHzOXx4+NjbQbcmfuYyze0Zb+KSEAAKQDDVgJGKKcgRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vye7wOo1; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vye7wOo1"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2ceb096e675so38614285ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 14:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785187476; x=1785792276; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Fwc+s3HmXnhuQ6ZSS0e/BayybuJcAxIo6JAFClX1stU=;
        b=Vye7wOo1YFuJq4v5MbNSuKmSX2GpQFSEcp8o6d/HPKbbG39FECGizpaY60xiQl1qBq
         jWEg7haV1Tf9KpvTgoUydp1ea8S1RiNTjWZF3Usb0fseu3nApcJ90iVcro8ZyZNsGpeE
         3XjBYwCA9mLyuCz0zX7m9/pzox3F24EmJKSAxeT5vyRZTnFmenyF0/S/mUALQ4LqRgM+
         WE6EgF9M6t5fEGYmHdf8HwtR3hB8bLO7Pvd3eYYhdHJgocyjSfF27D/fZgXIo796HxWp
         HXuEF09wI758vbaf/zYwnnHMIWKiOctjXSTFS6vg1NdF/uFciz0f8Cu14nalo2UXoax2
         X2cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785187476; x=1785792276;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Fwc+s3HmXnhuQ6ZSS0e/BayybuJcAxIo6JAFClX1stU=;
        b=iOV2LMWq2il0LqL2yHQks4Ko1eI2oZmDu5gAn0gGCo1W1px7JJ4r7SzlO/WyGEBwe/
         PrTTWfZEgmm88iy1/xdgBqhpayoRnZGDlVYwPMHg9jZs9/4BJAGNFaW0zXc0pMwq+YGI
         vG3dhogPc8tLRy7HX9LP9GkeXopaaG8bTat4BN1CQgOudHyTSA4i/jDd2rFg2dT1pWbe
         v8DjzY2AkC05JK4R/AQWjeq+PcYWcNb5MEuR9ZqKo3niJV8LcTCpDQLYz9hjchhCdqs7
         8Tqe9boREDqC0kqfhxo1qZd7+nOONZAUwIc7G8fZl1NT3kSJu3U+1zSqAvuXxkEkY11R
         Yg0w==
X-Forwarded-Encrypted: i=1; AHgh+RqUG3IUZLqNVfxfKbh2VMLOi7n7C9pVTfHT8rO/ersNrwFRfEV0vHTkCD0kdln+09/p9kzxLZ8oT6A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCKYKwk2Og8xy9Z4bJ+NlY7i5ktk+KZ9D0H2N3cA23V80QfBfT
	VHYgmrw4cSxAGDgNQyipTIlwoOpEO4j5ghFH+W6zamfuIdBFNScPH2Rn
X-Gm-Gg: AR+sD12n1nSfSWCmXuRo57lW10QBJjAhYs12WRTdRWsZdNXlbP5QEDHqmwY6Fe5qViu
	+OAhiDMF7nL5iaXMo0Smb44XcrzZNvyxsJfT+Qgfsnh1F3BkfucvzCSXSBWjBHJG5VQHXMVEvnD
	oXpkdiIIM4kHajkfzrBzAttv+c46bYIY0PDh2AtgzcasRplaAhyOtNWQH0USz2/rRxbuh5YJjEH
	2qwQ7LKBxce+Ju0VR8w5vncUMoaFPNPFBaOpZp2ohinsatQhVx/r4yoUe9q4BcT7IkWNbFOh2wt
	NNWUU+pP2BI1dxR6XRSb5dCoDny5M1LwsB0dkN8zGJjf+eSHhQzKnlAiZ0WCaAIs4Aii1DWQpkn
	DwsG+hZhncvF59XmTr8qk5BmH5VxBSrw33gZYFtzB6Frwel+HIOwYKSQQ7ptJgFl2eLNflL/cYR
	MSDS+Q/yPVzUrx6RP5TZDUKJdonLGLO+iYlkQSndISYt0sfD9t43cW
X-Received: by 2002:a17:902:e804:b0:2ca:d172:7228 with SMTP id d9443c01a7336-2cfde7a73a4mr104187015ad.11.1785187476604;
        Mon, 27 Jul 2026 14:24:36 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:3::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde7bc338sm40992665ad.43.2026.07.27.14.24.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:24:36 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	hch@lst.de,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: changfengnan@bytedance.com,
	kbusch@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	tytso@mit.edu,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v4 05/21] xfs: convert iomap ops to ->iomap_next()
Date: Mon, 27 Jul 2026 14:17:42 -0700
Message-ID: <20260727211758.1116539-6-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260727211758.1116539-1-joannelkoong@gmail.com>
References: <20260727211758.1116539-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert xfs iomap_ops to the new ->iomap_next() callback. Each callback is
generated with the DEFINE_IOMAP_ITER_NEXT()/DEFINE_IOMAP_ITER_NEXT_END()
macros, which wrap the iomap_iter_next() helper to finish the previous
mapping if needed and produce the next one. No functional changes are
intended.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/xfs/xfs_file.c  |  4 ++--
 fs/xfs/xfs_iomap.c | 39 +++++++++++++++++++++++++++++----------
 2 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index b733225d2864..768cabf6250b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -859,9 +859,9 @@ xfs_file_dio_write_atomic(
 			NULL, 0);
 
 	/*
-	 * The retry mechanism is based on the ->iomap_begin method returning
+	 * The retry mechanism is based on the ->iomap_next method returning
 	 * -ENOPROTOOPT, which would be when the REQ_ATOMIC-based write is not
-	 * possible. The REQ_ATOMIC-based method typically not be possible if
+	 * possible. The REQ_ATOMIC-based method is typically not possible if
 	 * the write spans multiple extents or the disk blocks are misaligned.
 	 */
 	if (ret == -ENOPROTOOPT && dops == &xfs_direct_write_iomap_ops) {
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 0536e2aeddcc..71c45be8c652 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1037,8 +1037,11 @@ xfs_direct_write_iomap_begin(
 	return error;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(xfs_direct_write_iomap_next,
+		xfs_direct_write_iomap_begin);
+
 const struct iomap_ops xfs_direct_write_iomap_ops = {
-	.iomap_begin		= xfs_direct_write_iomap_begin,
+	.iomap_next		= xfs_direct_write_iomap_next,
 };
 
 #ifdef CONFIG_XFS_RT
@@ -1089,8 +1092,11 @@ xfs_zoned_direct_write_iomap_begin(
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(xfs_zoned_direct_write_iomap_next,
+		xfs_zoned_direct_write_iomap_begin);
+
 const struct iomap_ops xfs_zoned_direct_write_iomap_ops = {
-	.iomap_begin		= xfs_zoned_direct_write_iomap_begin,
+	.iomap_next		= xfs_zoned_direct_write_iomap_next,
 };
 #endif /* CONFIG_XFS_RT */
 
@@ -1274,8 +1280,11 @@ xfs_atomic_write_cow_iomap_begin(
 	return error;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(xfs_atomic_write_cow_iomap_next,
+		xfs_atomic_write_cow_iomap_begin);
+
 const struct iomap_ops xfs_atomic_write_cow_iomap_ops = {
-	.iomap_begin		= xfs_atomic_write_cow_iomap_begin,
+	.iomap_next		= xfs_atomic_write_cow_iomap_next,
 };
 
 static int
@@ -1298,9 +1307,11 @@ xfs_dax_write_iomap_end(
 	return xfs_reflink_end_cow(ip, pos, written);
 }
 
+static DEFINE_IOMAP_ITER_NEXT_END(xfs_dax_write_iomap_next,
+		xfs_direct_write_iomap_begin, xfs_dax_write_iomap_end);
+
 const struct iomap_ops xfs_dax_write_iomap_ops = {
-	.iomap_begin	= xfs_direct_write_iomap_begin,
-	.iomap_end	= xfs_dax_write_iomap_end,
+	.iomap_next	= xfs_dax_write_iomap_next,
 };
 
 /*
@@ -2168,9 +2179,11 @@ xfs_buffered_write_iomap_end(
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT_END(xfs_buffered_write_iomap_next,
+		xfs_buffered_write_iomap_begin, xfs_buffered_write_iomap_end);
+
 const struct iomap_ops xfs_buffered_write_iomap_ops = {
-	.iomap_begin		= xfs_buffered_write_iomap_begin,
-	.iomap_end		= xfs_buffered_write_iomap_end,
+	.iomap_next		= xfs_buffered_write_iomap_next,
 };
 
 int
@@ -2214,8 +2227,10 @@ xfs_read_iomap_begin(
 				 shared ? IOMAP_F_SHARED : 0, seq);
 }
 
+static DEFINE_IOMAP_ITER_NEXT(xfs_read_iomap_next, xfs_read_iomap_begin);
+
 const struct iomap_ops xfs_read_iomap_ops = {
-	.iomap_begin		= xfs_read_iomap_begin,
+	.iomap_next		= xfs_read_iomap_next,
 };
 
 static int
@@ -2302,8 +2317,10 @@ xfs_seek_iomap_begin(
 	return error;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(xfs_seek_iomap_next, xfs_seek_iomap_begin);
+
 const struct iomap_ops xfs_seek_iomap_ops = {
-	.iomap_begin		= xfs_seek_iomap_begin,
+	.iomap_next		= xfs_seek_iomap_next,
 };
 
 static int
@@ -2349,8 +2366,10 @@ xfs_xattr_iomap_begin(
 	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, IOMAP_F_XATTR, seq);
 }
 
+static DEFINE_IOMAP_ITER_NEXT(xfs_xattr_iomap_next, xfs_xattr_iomap_begin);
+
 const struct iomap_ops xfs_xattr_iomap_ops = {
-	.iomap_begin		= xfs_xattr_iomap_begin,
+	.iomap_next		= xfs_xattr_iomap_next,
 };
 
 int
-- 
2.52.0

