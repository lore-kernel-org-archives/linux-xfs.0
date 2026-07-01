Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FED10F1
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 00:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782864708; cv=none; b=dAz/q39mEciI3mhXOHnLdgipiqz4q6f1MoTaruiMFqKsBrRePjnGZ3VaYgHAJbEzYqJVFSFoyDnn/A8F6Pp5m3jJ73ez4ZXMxvi99huoBnp1edJBzS34Isvoj1EyY4Ur6pVPODfkUpXuGjLWY5/XDxZAr4pnt1ubP0hNGAyKnDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782864708; c=relaxed/simple;
	bh=B0Sh1ggTorqRsvxtr7y8/kgsmh9XzrpKAa81LdQ1q54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bpAyIB1HvUCKI5uBclU75iFQKSXSnkbtHZR1H3shCFuAS4KTI/E4/ZLwOQYNYtd3hLKkv4YeERprIuMikSmjBjBEf6gwfaI6WO2nxFb97d81+adr7p3b1IVw6ikEiOyPwve6IB+dv8lZVMR6OCBOeTGvMo2qHv2Y7eOv0xVlflI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WNa/DiTi; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WNa/DiTi"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-44aeefa1c00so37456fac.0
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 17:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782864705; x=1783469505; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ErwUIUAFnJvR8Yr1JXbNUfRvAxBJYDZo6TwpYEonw24=;
        b=WNa/DiTiFoc5fHarfnRL9ABIu616R24nEYICfQ2rf0j8QkSN222MyPlnSgmgTs7miC
         MaFQ9WGt+zHyEBe1FjUox6LffnouNpwLOrvemBhx+cfWNunhlW3x5mT8pASPQfroXmTg
         tlyv3UHc9FnyI9D+J6+UFN81volVwoaffjnQQ4am4Pm6IBPfvze/xipXgbGEkmLLewlg
         54f71XDrb6bpXcfoMVL2w4hePosDZt/082ixZsbAMynfpV0OtwyexGfFZxjN+QO+hojm
         BuZ2w5o/x2o3SUKhtKxTUVW/qj5wfXEMkOce089/Amg9xjXcH120vgWRTLzsQtectQwv
         SpXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782864705; x=1783469505;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ErwUIUAFnJvR8Yr1JXbNUfRvAxBJYDZo6TwpYEonw24=;
        b=DTIoO4KsgxkViIRGvEtOdW+0Q/dZbxFs5EUxeT3tJc/pPSHqWg262iEeUZnCiVIuZe
         f4fhLZlDCGrx3TedCi1CNkSmMZef6l8Jkyk/BuLvc65Vhu1T83YqRqyTDFkQ0WVpVnSA
         +8MLVNz7q5CEGk4O9dVODS9FhRz15LqxCYSctav5nRaZe1dKIfpqV9M1os1qtcewAo2e
         i3G5QvltgHBnR9N98Q6sAcuPpcsDqALamTiXM7kgK8hLWL0eY9tR2dJn4MQ+fgxYSFuK
         MNiA1r7RJq2EsoQg0IpsbOvmSspVtsSb1ldGkzr02dnX5paH9qFWQ7aUxFNH2FI2W9tG
         kZVw==
X-Forwarded-Encrypted: i=1; AHgh+Rpdc8zgCedBfl7Bn0xJFDYVfKZkO6Ty/Gglyo6IXE+N5c37LViFu1bhCWA0urnJ/ye+ht0LAbca4Vg=@vger.kernel.org
X-Gm-Message-State: AOJu0YylXSYgXuYymdnviJ+I6S3tW5mGhaXaeGd4vuojRheQYQBZ9o1L
	R9NW0LF9fg/SFsz8liFkyox4F5yAMiAou7WnARTpWmXy/iyRlbB35eHI
X-Gm-Gg: AfdE7ckpwW87loz3Ae6ByAo4Sb0J5v5d36UbvGktUbHOtJzOIlYV63TbGKZlJNpP7Dl
	/kC8Hj53Jgjtxc/Mu5DTZk6rWMwMANPP0/m6G/OaTCRdeLXk0WLhLmGIl+mKKPiCKL64GX2+23L
	EEQ2EWl0jJ5gLU2z4vjAnFi3IHMCf/E0/BRayDZ7TmqLND5lfVoN4GabSDoXyczz9QYHPRBXjSY
	Niufn7jrDnAGSpu28qk9dY8OAY8e66klG2rV1K9hLbGzC2o23G5WiGzGcHmuziSn8y4GQ2zjlLI
	1IIIY6jRthDraV5oP3TySOnTt+wkaSmDz5TMYGNyTLLhMaUXdfTVTJIIFy+lD/3OL19D9SEVedy
	aTLP8ONMxYIvl7GjpYnXqdSgq+p2ln6OzyhZDGZRdj9+cRTmtksysRK9CoAJaSBqDPIQqqKLJ8q
	FfEQH0ofOPWpXFw9giopHvJbWZbdRQlRsOee5wkwXwYVn0cwyPCPJBBeLIYz9rE1obNfSUxpFiW
	pc=
X-Received: by 2002:a05:6871:228c:b0:423:1cc1:f878 with SMTP id 586e51a60fabf-44ae322e0e2mr2197943fac.29.1782864704979;
        Tue, 30 Jun 2026 17:11:44 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4f::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-44c62027e5esm314905fac.9.2026.06.30.17.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 17:11:44 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: brauner@kernel.org,
	hch@lst.de
Cc: djwong@kernel.org,
	willy@infradead.org,
	hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 08/18] zonefs: convert iomap ops to ->iomap_next()
Date: Tue, 30 Jun 2026 17:09:23 -0700
Message-ID: <20260701000949.1666714-9-joannelkoong@gmail.com>
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

Convert zonefs iomap_ops to the new ->iomap_next() callback. This uses the
iomap_process() helper, which finishes the previous mapping if needed
and produces the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/zonefs/file.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/zonefs/file.c b/fs/zonefs/file.c
index 5ada33f70bb4..a29a8756d660 100644
--- a/fs/zonefs/file.c
+++ b/fs/zonefs/file.c
@@ -57,8 +57,15 @@ static int zonefs_read_iomap_begin(struct inode *inode, loff_t offset,
 	return 0;
 }
 
+static int zonefs_read_iomap_next(const struct iomap_iter *iter,
+				  struct iomap *iomap, struct iomap *srcmap)
+{
+	return iomap_process(iter, iomap, srcmap, zonefs_read_iomap_begin,
+			     NULL);
+}
+
 static const struct iomap_ops zonefs_read_iomap_ops = {
-	.iomap_begin	= zonefs_read_iomap_begin,
+	.iomap_next	= zonefs_read_iomap_next,
 };
 
 static int zonefs_write_iomap_begin(struct inode *inode, loff_t offset,
@@ -106,8 +113,15 @@ static int zonefs_write_iomap_begin(struct inode *inode, loff_t offset,
 	return 0;
 }
 
+static int zonefs_write_iomap_next(const struct iomap_iter *iter,
+				   struct iomap *iomap, struct iomap *srcmap)
+{
+	return iomap_process(iter, iomap, srcmap, zonefs_write_iomap_begin,
+			     NULL);
+}
+
 static const struct iomap_ops zonefs_write_iomap_ops = {
-	.iomap_begin	= zonefs_write_iomap_begin,
+	.iomap_next	= zonefs_write_iomap_next,
 };
 
 static int zonefs_read_folio(struct file *unused, struct folio *folio)
-- 
2.52.0

