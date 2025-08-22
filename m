Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB6E274B3D
	for <linux-xfs@vger.kernel.org>; Fri, 22 Aug 2025 08:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755851180; cv=none; b=Vj0HZpi2AEy8uSoEmrYU4Ys4MPgl/8tsQ9FVZcPXM8gakblOCPo0GbVuywyXu91ZnsTaV8ec3J8DkytajWai8vOQ7VbUfwDXd7U7dhWz4LF/FXsosNhnVFPLEFqE6ewGyfP0PG6ObuZfe3p31nkd+HaJgc42jCUqu2synWPZE9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755851180; c=relaxed/simple;
	bh=3Y7pt99HGaa7ArnnUwqQ7vjbh1bOmBAGpcnzoKd5MYY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=p0o3AnxoCo2/8A+XBzx9zP+RGNWyhvD0P4ICgCBgJFd2buaFJtupAyv7cFuGiNqvNNMuGBS6aMrzk7nqNmvHfKMQX2v8kZ+WpD5qNo+SBwTmHph9NfbTe/oWpS2Syy4hBM0kA7CEaurZMu9mdp20vdJXGjQ8aSwzvOhpCamsKwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=MMgFtaoU; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="MMgFtaoU"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-7e87061a6d5so198299885a.2
        for <linux-xfs@vger.kernel.org>; Fri, 22 Aug 2025 01:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755851177; x=1756455977; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ox9fNV0dmc12yYwQJgBEIVF6B4bp0ZnRQ4q5/+iuAzU=;
        b=MMgFtaoUFingLICaeC3qsvgTJhvjRW1AKtIkw83fYOsqoHoCdBkXKUflETkAhekV9O
         YsIc7iW+kGGcC6+78E3n9TQPn15G9ImgGoyqx67d4LiaFeGdSpMLMG4kTf+fXWLTztOu
         4ZMD1V/8OR2K4w9O0ThZjG7ZnRCi1yH5lJ8zsx4R4QX+vM/U8Dbvz/oSRQr+ipXGW4Gx
         gxmJCxs+2QOsN5uQSamDhrge5KaqAt9a4pePgR4Qqgeiexf7LfwG55Y7JhylG8jYokXu
         AAHhYE37QKZsGSWBJOH8y08qRkiMXyYnUZP2bNPmp2hczI+Nrg2z2jmSjyA9cLQ3fFNL
         vpXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755851177; x=1756455977;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ox9fNV0dmc12yYwQJgBEIVF6B4bp0ZnRQ4q5/+iuAzU=;
        b=hyBdbcPB8mLNMhmgLDDAIC8T8tXraK6mRR+wzMBGqH05KmH79DGhDMCCRcg3ZRRGgx
         N6g7Gk2pFrc/7Gw9hwHi/ZBy8aFtYbuMHk0O0DeqxkE+ctSTGsK3VS/lVF6e8XoSaAUH
         +x9Gkj0BZBkFqNuTlyhZhjef/BGdlCg/R5g7GO/2jikCh2gLzE50K7PXYIebY4UE7r6v
         pZqVrC2pzGDW8UUxlWSX5p3ODum5VRozI8sI6FtCOPOsTh562t21GNKTpl9mkWz6bVIA
         J+AzL9b9KQepcv3p0c5P6zpMGfpqAAUmGe3U46wN/lAdnLTKQur8rmH/3MMofuTI/b0b
         j/Kg==
X-Gm-Message-State: AOJu0YygvNEOkSq7NuoBFDM72fILrXsooYBRbXMepIN/ywSLObGyCRZ8
	7Vt9vxEne27yDNFVjWMmlym+Uos/bPBtXjj8ulYHrsHggb1MU6i+5bt65wGKVfTKlAQ=
X-Gm-Gg: ASbGncvlR6aCyQjJUVMLj+jpblyjHJXxG1rfOTK6sDv92SHgpO6+S5pCla4oBi9uWG1
	L2rdy/bkl308afYF96V/M3gy6ZyLHFp2ajOaaySahDkEt73sVuGep7/ObiQ4yW+FxBWO9+1VSP0
	UVdRazosoS2PdPRtcse135sCmxlEeSeO84sbHrBV6lWKMv/e7Dj9px0Ms/agU+DHH9jc9Vg+7Ia
	f7t/vvwW/gQfQT4WsCMtNX6OXj6wUw9s1t5nNN9kW9yZTNakV3xhJl4Lao3gqejY8GSeYfR5v1Q
	x99sXX5zErDQ+MUnqZSspbxL/gmuZhNW2vw3CZ9j9mdv0ho4kEczykjADZlO+E6Kqk/p++vv8pv
	EVynd3supzP2qqeymwkhnA9mePtftk8wpXGO+agle4MU745joWdX0+328Uq8=
X-Google-Smtp-Source: AGHT+IHzishO1R6hzkVbz5CN/NEks268S4RTP6J//EZTRKNtZrnibnc35ncixCIvJiWDrXp5Euygxg==
X-Received: by 2002:a05:620a:294b:b0:7e6:9c7f:baa9 with SMTP id af79cd13be357-7ea10f88ebemr262093685a.16.1755851176675;
        Fri, 22 Aug 2025 01:26:16 -0700 (PDT)
Received: from localhost.localdomain ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e87e191a42sm1293893185a.54.2025.08.22.01.26.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 22 Aug 2025 01:26:16 -0700 (PDT)
From: Fengnan Chang <changfengnan@bytedance.com>
To: brauner@kernel.org,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Fengnan Chang <changfengnan@bytedance.com>
Subject: [PATCH] iomap: allow iomap using the per-cpu bio cache
Date: Fri, 22 Aug 2025 16:26:06 +0800
Message-Id: <20250822082606.66375-1-changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When use io_uring with direct IO, we could use per-cpu bio cache
from bio_alloc_bioset, So pass IOCB_ALLOC_CACHE flag to alloc
bio helper.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
---
 fs/iomap/direct-io.c  | 6 ++++++
 include/linux/iomap.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 6f25d4cfea9f..85cc092a4004 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -341,6 +341,9 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 	    !bdev_iter_is_aligned(iomap->bdev, dio->submit.iter))
 		return -EINVAL;
 
+	if (iter->flags & IOMAP_ALLOC_CACHE)
+		bio_opf |= REQ_ALLOC_CACHE;
+
 	if (dio->flags & IOMAP_DIO_WRITE) {
 		bio_opf |= REQ_OP_WRITE;
 
@@ -636,6 +639,9 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		iomi.flags |= IOMAP_NOWAIT;
 
+	if (iocb->ki_flags & IOCB_ALLOC_CACHE)
+		iomi.flags |= IOMAP_ALLOC_CACHE;
+
 	if (iov_iter_rw(iter) == READ) {
 		/* reads can always complete inline */
 		dio->flags |= IOMAP_DIO_INLINE_COMP;
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 73dceabc21c8..6cba9b1753ca 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -196,6 +196,7 @@ struct iomap_write_ops {
 #endif /* CONFIG_FS_DAX */
 #define IOMAP_ATOMIC		(1 << 9) /* torn-write protection */
 #define IOMAP_DONTCACHE		(1 << 10)
+#define IOMAP_ALLOC_CACHE	(1 << 11)
 
 struct iomap_ops {
 	/*
-- 
2.20.1

