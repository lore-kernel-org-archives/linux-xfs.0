Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DD3125AA
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 00:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782864676; cv=none; b=YybQHUUEYgFU5PDPnPRwYyXgYKIu5AwWC0PKFUm7TJLQuJp60WENbnj+o3/l8SP6lxnX+XrWa79jxyj29XSh8cP+s2yDxdrxf47G3T2eavzTIymvUyZb6nryWPO9k1kBaM/EPSuLRfc4sIf6q8llNd9JjAETu5dQ4Xn2qoIt1Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782864676; c=relaxed/simple;
	bh=zHWmKUCnN9WkUCSZXVq2kyOq9l5T0i6QS1ziiAD3fMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t5MKincNRi/eM6khKPUmwXjV6w9rMm8Ne9Eu/gbWxtue0oiiB64Vzp37iGmnrOvLlHhYLIdPD6lwHMofnMp+NbT/0AStNCIaCGkx91B4BcxTn3uV/rWrc9DSO4DCdcna5UeeGCQQDxV1dI9JnGCLbBnQ1gwBUUp/Pufl3Hgnbfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QqegPpk6; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QqegPpk6"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-6a145935764so27433eaf.3
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 17:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782864673; x=1783469473; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oNPbzx+vXvTNK/IK2NGcoyn2nveTdVJbNDgmvFlw3Co=;
        b=QqegPpk6ZFxWjZ0P0x7QqsQzHJouuNh3I5khH5Vz5JflEAw2IjjYIaYri9/e6AL26O
         boea6qJ9R82kOTnu65PavNPteJx6MyOn7a2zCKB/JPjeERU1EVh//We8vH1N8Or9oa9R
         qhvtERVqtDmluTY1Pkc+uws2upzOGFyPyCXTm947fifCwgY5dDJ+n2d9EyPmGdYHyhTW
         G9AU7EQyg6gdRFwa/jfHbk22OBt4bTYOOsGzIAfYjQkg2+ss7+4cRyV3kMeFlKCL0C8q
         1/SFbOhN6Lz3tw0+4VY4WjDvSoVDg5L6MV2DzILvlg7X4SJmDDxyT8TeZn8OqlrHtwV4
         5FRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782864673; x=1783469473;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oNPbzx+vXvTNK/IK2NGcoyn2nveTdVJbNDgmvFlw3Co=;
        b=bn54vwOtyNQx13FbDrlTUvMSNEeRovSZul8rZHd2Dal97mNwwGIwjVqw/W6vdv/f7Q
         jhV0LqZkX7npt+sHZcqQvwQpFKvW0Lk8iUfdJC4eQY7XOwgSA08v84NAPBTRFCiZSFnx
         L0S1lgW4O7Z09P1WPJjaTjnjuWaZUamm/F09U63cv5BZB+8nj4rpPoyzqD3y1BU7Ai7Y
         t879gKczDgLe5b+qua1YVAs5mgit/5GELq/I1354P37sPT4ABT6SUjzpQ7arywBctFc4
         qfWZiJs6Bc2m543A6TJcMHF+0IeHFwIVTFZU+bO/MJMQ0G6HVb2Fjv3iWAlygRFCwsGy
         JgSg==
X-Forwarded-Encrypted: i=1; AFNElJ+NfYdml9yoVeMnVK74hMnohzzBz2V0exilHRlowuWhUDWHtofgI/3k+XE38oZU/Hrfzhk5zHw/eDA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJaxVAk719q3PVQEVNhSyuXqv8U+F+oz4umyriNfUVgXxyx/+B
	SEpN39CuibYHVBoHwOzR+5mBdYkUco6LqSO7Hq/R2LypFH0Xc6DH0Qr1
X-Gm-Gg: AfdE7clG1ta014WiqghQMKk+uw49KP30Ucff2qGyCqHc8hebTWK23+xFfoyBNP4RTJ3
	CvBkJR1jcrO6JlfndobH6ienAqcqbppAhwYNXKhwL5SOhkNDYqIUHoZCoMvD3KlifXPO8hpCPXo
	1lhxNHO5DqV/yy897wXL97+hgz41omFnI1D+j6tYdWVqd5MPEyBur9C7kwKipnmk2gCXwfPn/rm
	RxBJ1Lx6DPDvagoMfy0PnVNI4E3BH0gtHawW7DTbaIopfp+qtuHRyQfff3+XIPyiLGbCG3onOLe
	VQlss7L8n7LWZRulk5ylrDOwxPYjiLrrulyytUcO/wuRBVjdTrWKso//gLIuiomdW8Sudx5X/3K
	rEjnD5/wMPiZ0A7svd6gk8kRTjxFip3H7eEVY2iSl4jkqSR4rQixfc3vi3Uzfmw9BzUlEOSf+7I
	gmo4Ts9UX5ptJOdkSfsCvu/vEAiBkN+qt/h2WqykXVne3h94M/c1m8lXFH7kh2KaQ=
X-Received: by 2002:a05:6820:4dc2:b0:6a0:a791:6885 with SMTP id 006d021491bc7-6a1890a59b5mr4146462eaf.23.1782864673320;
        Tue, 30 Jun 2026 17:11:13 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-44c5f7b8b80sm366853fac.0.2026.06.30.17.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 17:11:12 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: brauner@kernel.org,
	hch@lst.de
Cc: djwong@kernel.org,
	willy@infradead.org,
	hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 02/18] xfs: convert iomap ops to ->iomap_next()
Date: Tue, 30 Jun 2026 17:09:17 -0700
Message-ID: <20260701000949.1666714-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260701000949.1666714-1-joannelkoong@gmail.com>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert xfs iomap_ops to the new ->iomap_next() callback. This uses the
iomap_process() helper, which finishes the previous mapping if needed
and produces the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/xfs/xfs_file.c  |  4 +-
 fs/xfs/xfs_iomap.c | 96 +++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 88 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 845a97c9b063..7f8bef1a9954 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -857,9 +857,9 @@ xfs_file_dio_write_atomic(
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
index 225c3de88d03..4fa1a5c985db 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1037,8 +1037,18 @@ xfs_direct_write_iomap_begin(
 	return error;
 }
 
+static int
+xfs_direct_write_iomap_next(
+	const struct iomap_iter *iter,
+	struct iomap		*iomap,
+	struct iomap		*srcmap)
+{
+	return iomap_process(iter, iomap, srcmap, xfs_direct_write_iomap_begin,
+			NULL);
+}
+
 const struct iomap_ops xfs_direct_write_iomap_ops = {
-	.iomap_begin		= xfs_direct_write_iomap_begin,
+	.iomap_next		= xfs_direct_write_iomap_next,
 };
 
 #ifdef CONFIG_XFS_RT
@@ -1089,8 +1099,18 @@ xfs_zoned_direct_write_iomap_begin(
 	return 0;
 }
 
+static int
+xfs_zoned_direct_write_iomap_next(
+	const struct iomap_iter *iter,
+	struct iomap		*iomap,
+	struct iomap		*srcmap)
+{
+	return iomap_process(iter, iomap, srcmap,
+			xfs_zoned_direct_write_iomap_begin, NULL);
+}
+
 const struct iomap_ops xfs_zoned_direct_write_iomap_ops = {
-	.iomap_begin		= xfs_zoned_direct_write_iomap_begin,
+	.iomap_next		= xfs_zoned_direct_write_iomap_next,
 };
 #endif /* CONFIG_XFS_RT */
 
@@ -1274,8 +1294,18 @@ xfs_atomic_write_cow_iomap_begin(
 	return error;
 }
 
+static int
+xfs_atomic_write_cow_iomap_next(
+	const struct iomap_iter *iter,
+	struct iomap		*iomap,
+	struct iomap		*srcmap)
+{
+	return iomap_process(iter, iomap, srcmap,
+			xfs_atomic_write_cow_iomap_begin, NULL);
+}
+
 const struct iomap_ops xfs_atomic_write_cow_iomap_ops = {
-	.iomap_begin		= xfs_atomic_write_cow_iomap_begin,
+	.iomap_next		= xfs_atomic_write_cow_iomap_next,
 };
 
 static int
@@ -1298,9 +1328,18 @@ xfs_dax_write_iomap_end(
 	return xfs_reflink_end_cow(ip, pos, written);
 }
 
+static int
+xfs_dax_write_iomap_next(
+	const struct iomap_iter *iter,
+	struct iomap		*iomap,
+	struct iomap		*srcmap)
+{
+	return iomap_process(iter, iomap, srcmap, xfs_direct_write_iomap_begin,
+			xfs_dax_write_iomap_end);
+}
+
 const struct iomap_ops xfs_dax_write_iomap_ops = {
-	.iomap_begin	= xfs_direct_write_iomap_begin,
-	.iomap_end	= xfs_dax_write_iomap_end,
+	.iomap_next	= xfs_dax_write_iomap_next,
 };
 
 /*
@@ -2168,9 +2207,19 @@ xfs_buffered_write_iomap_end(
 	return 0;
 }
 
+static int
+xfs_buffered_write_iomap_next(
+	const struct iomap_iter *iter,
+	struct iomap		*iomap,
+	struct iomap		*srcmap)
+{
+	return iomap_process(iter, iomap, srcmap,
+			xfs_buffered_write_iomap_begin,
+			xfs_buffered_write_iomap_end);
+}
+
 const struct iomap_ops xfs_buffered_write_iomap_ops = {
-	.iomap_begin		= xfs_buffered_write_iomap_begin,
-	.iomap_end		= xfs_buffered_write_iomap_end,
+	.iomap_next		= xfs_buffered_write_iomap_next,
 };
 
 static int
@@ -2214,8 +2263,17 @@ xfs_read_iomap_begin(
 				 shared ? IOMAP_F_SHARED : 0, seq);
 }
 
+static int
+xfs_read_iomap_next(
+	const struct iomap_iter *iter,
+	struct iomap		*iomap,
+	struct iomap		*srcmap)
+{
+	return iomap_process(iter, iomap, srcmap, xfs_read_iomap_begin, NULL);
+}
+
 const struct iomap_ops xfs_read_iomap_ops = {
-	.iomap_begin		= xfs_read_iomap_begin,
+	.iomap_next		= xfs_read_iomap_next,
 };
 
 static int
@@ -2302,8 +2360,17 @@ xfs_seek_iomap_begin(
 	return error;
 }
 
+static int
+xfs_seek_iomap_next(
+	const struct iomap_iter *iter,
+	struct iomap		*iomap,
+	struct iomap		*srcmap)
+{
+	return iomap_process(iter, iomap, srcmap, xfs_seek_iomap_begin, NULL);
+}
+
 const struct iomap_ops xfs_seek_iomap_ops = {
-	.iomap_begin		= xfs_seek_iomap_begin,
+	.iomap_next		= xfs_seek_iomap_next,
 };
 
 static int
@@ -2349,8 +2416,17 @@ xfs_xattr_iomap_begin(
 	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, IOMAP_F_XATTR, seq);
 }
 
+static int
+xfs_xattr_iomap_next(
+	const struct iomap_iter *iter,
+	struct iomap		*iomap,
+	struct iomap		*srcmap)
+{
+	return iomap_process(iter, iomap, srcmap, xfs_xattr_iomap_begin, NULL);
+}
+
 const struct iomap_ops xfs_xattr_iomap_ops = {
-	.iomap_begin		= xfs_xattr_iomap_begin,
+	.iomap_next		= xfs_xattr_iomap_next,
 };
 
 int
-- 
2.52.0

