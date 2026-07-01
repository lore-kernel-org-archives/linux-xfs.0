Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A3515E5DC
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 00:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782864691; cv=none; b=XjLXAJJ99NKDjUJ4LTesD5nb4ZISAgDCvUvWHYnva8XLxwXdBTnvOvnqOFv/BsOTsBWIRef42LnuGQM6WM+DHplDhEvaglbB/2X+SIzTJP06g4Jpa35TV6jOS5VIgEJaUPxC64ht5PiAZoJ9MIgDVbqOfrybDe9WPykk23+vqEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782864691; c=relaxed/simple;
	bh=lARvSuawiV3hPRfc+1WuShqKRb08isXcI3sp8qVKngU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjR79hzLjQ1ArSi7BbCky/R4i93tKoXoRI6r4L2pYtUwPGjHU3QOQpr5mcvpPR03819rNAn626SDwquh4G2bEooy3ioXHqiP7pH8zupgsynKsOFQeHRV9YCFvb+0+7dTcFQkR52NyJ4MQeIR8dgJFMTwBZMMaB0SomrJJwlb8hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N2XhwIbv; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N2XhwIbv"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7ea9c6ea7deso64622a34.3
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 17:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782864689; x=1783469489; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4vqoaRZS+wir94bOkLTsUmkUx9RZ3pvp4I8Lfye5kj8=;
        b=N2XhwIbv5/LkGpvbqeXTFR8WtnPhKbdxxYQPQaJM1wnUGM7gmUrxMXe57L3bYJDxj5
         wRvfAm2xx8JeOaRIEkY5iwMZXF/zdOrFz0YcO7xiJ1FaVHwEUSJLoILUadDEMuLZAObn
         FDXguekBaBg+0xvN/u6JDkWnYVwk+nxziOdqs7pjmaD5WReAcfV+v78NwNkE89duErbO
         5HIRtnIrRG4+UVsB0AgQENiHiiFDT5TAXYBSZ8CCB15FblejW1n6+xHquuv76UvqOlcD
         SmTNkrJUXilkG7d4TePJ9D0oVOk8kN35pKQ2g6DESC+0rAsrr96mQFmUpwvY+x1HIebj
         +wzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782864689; x=1783469489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4vqoaRZS+wir94bOkLTsUmkUx9RZ3pvp4I8Lfye5kj8=;
        b=RbKpsG4Ii0w38GwrE36I3+kKx27whXWzLOhq8RrN7vdpe6ecOydSTy8dyqphkSo3S5
         w3IeaMvtkI0LskyUil7eToYs+naRJ1ohGEMjO13TWchPrx5FMu4xeDnhxCiDFsHeGJYs
         a4DqWbDtYY8PdFXkcH2MZztMErIHj498rwV/R/HtD29u4KX5+WRbrVeaLbNfWdd29oi5
         oaZLUUZ/Bu/NAvK9k4iaz8imuXeZnJ8bTBw1FJT3eAp3xjYBgD8Au63OfpoY0FtLViVq
         AtVD01D3EL+FQgj0Ud0USbeo8Rk/G2JSbB9wj/R1OPpGIswPYRwwXsUYzDrxawNZpRI8
         TfUw==
X-Forwarded-Encrypted: i=1; AFNElJ/HuPdDopta3w+pHFs59iFPMRlslhddnH2bNdnUSErVfxj+XUAcc4n2wGY8q9wVSOCBKUm6Rt3Dp94=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcC7pkEVB5oo4A+vOJGgbt91WhptMiPqsdVkxCARDDI/DhXZJt
	pAtHMIlu3mJx69SoHGORDv9exEhjv+2r2ETIa5bCHFMYtoJoLPw8Paod
X-Gm-Gg: AfdE7clNpQtyt4wU09/YDHtVxFF4h9wshgyOEgeD8SWF7Du5Ly6MmCpzz9thxNmAcXO
	aOvCKi9fFi8NEdSJttuaRot2Juk+zlxbAr9jDCZQdImRR7zkO2H/YLPEHojypfJq4QkoXnK0anw
	nfJm97Q3HTCCjag3hUFRZCwjkLLZJpaiuf+bUzPha9e99kkdoD6Q0hW42pIsErhMCPFo8i1qUhH
	J80A2ziDCvV5WuArLjwpj+YaRjE5EjZtsVGdXkUqu30knf4g1OHtqRhFoG8+9O58lf6HVBcaTxd
	mAThSC55CZjAc1UAZlC4FI4e4KOpsdS7AvbhctNYlb7bx/zYv9uAG/VUEvJk0VvrtiwG6MkMJP9
	d9EvVM2uF6Mpi3LShGsh8BvZ4kvO8agHbKHqUHgD+NaWrRDuwLEj/pJx9rEgVziy8xrtMsDPCoa
	R735c1HeCUv0+x3fdik8B9MYg+oWMUtBrVERjoe0SFOw6kFuhLKltDq2iS3L3aDeF/
X-Received: by 2002:a05:6830:4901:b0:7e9:b537:102c with SMTP id 46e09a7af769-7e9ec743f22mr4579267a34.25.1782864689485;
        Tue, 30 Jun 2026 17:11:29 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4b::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e9f328636dsm2558647a34.9.2026.06.30.17.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 17:11:28 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: brauner@kernel.org,
	hch@lst.de
Cc: djwong@kernel.org,
	willy@infradead.org,
	hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	ntfs3@lists.linux.dev (open list:NTFS3 FILESYSTEM),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 04/18] ntfs3: convert iomap ops to ->iomap_next()
Date: Tue, 30 Jun 2026 17:09:19 -0700
Message-ID: <20260701000949.1666714-5-joannelkoong@gmail.com>
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

Convert ntfs3 iomap_ops to the new ->iomap_next() callback. This uses the
iomap_process() helper, which finishes the previous mapping if needed
and produces the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/ntfs3/inode.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index c43101cc064d..c5676c51a3a4 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -2101,9 +2101,15 @@ const struct address_space_operations ntfs_aops_cmpr = {
 	.invalidate_folio = iomap_invalidate_folio,
 };
 
+static int ntfs_iomap_next(const struct iomap_iter *iter, struct iomap *iomap,
+			   struct iomap *srcmap)
+{
+	return iomap_process(iter, iomap, srcmap, ntfs_iomap_begin,
+			     ntfs_iomap_end);
+}
+
 const struct iomap_ops ntfs_iomap_ops = {
-	.iomap_begin	= ntfs_iomap_begin,
-	.iomap_end	= ntfs_iomap_end,
+	.iomap_next	= ntfs_iomap_next,
 };
 
 const struct iomap_write_ops ntfs_iomap_folio_ops = {
-- 
2.52.0

