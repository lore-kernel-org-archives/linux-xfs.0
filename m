Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A8117BEBF
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479542; cv=none; b=TJPtKhqM7HWhYKnu2aKK9jf4XqKrmztj0eqVqxraV4sKYVN1XJ/I+ufczAILDqIxUx6dS5mXr17Lls829vcy4FRiDs98+r9hPxNL+jx7J9J9s7+y1AJ/IwvkiVE366msoofX6S3NP0jk2wdVcZbKIT8oi6lbXIA3vgJsulR3GGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479542; c=relaxed/simple;
	bh=xNhY9/C5LZaTSsQ7tsRDvj8heywUEY06y6VgVbvIwfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sPok5sBEYn95mlyH2rR5LFSasSw1ztO9UyS2jqljfZ9cn7rUIf/tDybJuPEDKedrHWuPlsR/1J1T8+omyDo/SqAi36oyvE0jXd1jqR44jREAgqDPKYiP6D/q4NADRBnE36zh+8qLHgxHcA1cY8TaAIdHyPSPL7qnEq0SAUiLBM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A8ep/9Tb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A8ep/9Tb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479540;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sc4xU01mk/3qZsFQGDaB37qCPIwdDLKQZ4wD3ATLNsQ=;
	b=A8ep/9TbOIIwhMuw6MtKTYr50aS/xV65nSr4DH5jY0N8tuGSBIpHHyZz+XizVIS0Pur4cA
	gxOAc9OCUEe3aedcudtnltNhSI5cX4UYUAegl8fQPvF+WLUaEAN36l1fGguBOBtmZLwtja
	DhfcUbNYjStU2G9Poh3SP/o+6Ia/hLc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472-y2Bf4pD0OCawLKBLDR93Mw-1; Sun, 29 Dec 2024 08:38:58 -0500
X-MC-Unique: y2Bf4pD0OCawLKBLDR93Mw-1
X-Mimecast-MFC-AGG-ID: y2Bf4pD0OCawLKBLDR93Mw
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4361c040ba8so10048495e9.1
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:38:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479536; x=1736084336;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sc4xU01mk/3qZsFQGDaB37qCPIwdDLKQZ4wD3ATLNsQ=;
        b=heJj51QzeOQFtRSbai+r2OlPlems19+oG/JjJzs5YEbahkfdWIH7SI04KmXAsSiK2W
         6UtKU+1nNqcNYDWVZuwUuckODygDwou1rKOhmFzkFlXjjTccNYhu+TGrVVeTxOBTK0D8
         cEkN1Ht52QjTG+P8n/tS4QqaFsext3M21tOuqA0gSxS+RtUbF10fH38/XoiDAXhYRsiX
         Pd4+RLd3EGNRHuzOaWbnL4KnHn96sAI8fSgTfyZbHETB9PrdX6A8mcuot8pXsTKIKyZ6
         KIusD82pPyobjgnGxcS0cn8wawcItxf8tqDSVEa7joxi3mxE1iIO0rytYCJU0APIpP78
         m/Tg==
X-Gm-Message-State: AOJu0YypD3DdlZK6uEBD4AFVe3L329Dk5Sq6uT18p9SVj/FYFLLe/vkY
	cLjnt0GOi1ATr2a5Lw9XKP+Gq9/mJTKOpBt2pV6nsgzoN8zDORUvKcfO8G1EDo8Se0soR8Ki9dD
	RraeGwMzXogwfP7/+QdyG5AecigFM6EpTHX/bERDRfTrZP5HOQZ1XFGAz1B85W/uedYshSFAjUp
	KmxAuOaNyZRLPMrto+88OB+nqo/T2SDGLEmFVLCzmP
X-Gm-Gg: ASbGncujivGdpLvnK/JqFAHr99lgPKUbBxRwphUSX64wLYEbABw+bmAy19wpb1fHrEi
	CjJGayox1IvmMCCdUkYiqyitFvn1IVbMJW2RWv/SySEIS72sJUeBzBDum6TDqHoDw9Gsg64I1Bj
	WPxbb/9PLECVVglB9sVMpM2l4slqXirUpHEgUW4oBcyzASirK2CD1GI9kxm2vtPjH1VNjv/yU07
	Gl8LodGk5rHKlrwF3llWT0KwNnkf7L4VeECOGmbG8csoFemISTfGQXj6ILz93R7Pwvf5CvVGLll
	DGB37YUXrXrYWzI=
X-Received: by 2002:a05:600c:5488:b0:436:5165:f21f with SMTP id 5b1f17b1804b1-43668b498ddmr251886625e9.26.1735479535941;
        Sun, 29 Dec 2024 05:38:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGcYgekaz4XDyXDT/gJ/qncBqDCxQr7ciuBAr7eyoCG3hWGJZ5vpCN1jHOdGaUeJpaeTOHGNw==
X-Received: by 2002:a05:600c:5488:b0:436:5165:f21f with SMTP id 5b1f17b1804b1-43668b498ddmr251886495e9.26.1735479535548;
        Sun, 29 Dec 2024 05:38:55 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c8474c2sm27093127f8f.55.2024.12.29.05.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:38:55 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 05/14] libxfs: add xfs_calc_chsum()
Date: Sun, 29 Dec 2024 14:38:27 +0100
Message-ID: <20241229133836.1194272-6-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133836.1194272-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20241229133836.1194272-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andrey Albershteyn <aalbersh@redhat.com>

Calculate CRC of the buffer which will not be placed in this same
buffer (common case for all other xfs_cksum.h uses).

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/libxfs/xfs_cksum.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_cksum.h b/fs/xfs/libxfs/xfs_cksum.h
index 999a290cfd72..90884ed0ef23 100644
--- a/fs/xfs/libxfs/xfs_cksum.h
+++ b/fs/xfs/libxfs/xfs_cksum.h
@@ -79,4 +79,16 @@ xfs_verify_cksum(char *buffer, size_t length, unsigned long cksum_offset)
 	return *(__le32 *)(buffer + cksum_offset) == xfs_end_cksum(crc);
 }
 
+/*
+ * Helper to calculate the checksum of a buffer which is outside of the buffer
+ */
+static inline uint32_t
+xfs_calc_cksum(char *buffer, size_t length, uint32_t *dst)
+{
+	uint32_t crc = crc32c(XFS_CRC_SEED, buffer, length);
+	if (dst)
+		*dst = crc;
+	return crc;
+}
+
 #endif /* _XFS_CKSUM_H */
-- 
2.47.0

