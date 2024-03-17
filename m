Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846ED1CA85
	for <linux-xfs@vger.kernel.org>; Sun, 17 Mar 2024 15:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710690487; cv=none; b=etMjKxidOvyNH+0l37FH+5vf1vRhf4yDGEXDk7grb806eMSCBUYHna0Ba2P7nxbbvtzmiYG6NC/Y9rGzc6tWyeRVCAi3/R6sIAkvCut+hn9vDTO/e2Oz/NVN1wadAoicE9sIDiTm3Kje3GOtnVISk8DDPmeX2M1/DSPa8+ocM/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710690487; c=relaxed/simple;
	bh=qXxDEQtn/XB5MDmUD/l0idw+x9pNLWoaaLD6V9lFy4g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LxBsdSeLN0PKu8qqZ5Q4Wym8ApqcqElJY032yc11FVoNYaPCTj6wxKWk5gVp5J0b7BR3sbGwXL5YXOb4HbRKbavQ78/UXXz/xzVcLCBLgSb/yJyjS2mrjtqDH5qM9Lua5fdDc2Tw0UswQLwSAp1rKMgAHD6na97u/WhaKAUUUSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=STbt3N21; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="STbt3N21"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-33e162b1b71so3274928f8f.1
        for <linux-xfs@vger.kernel.org>; Sun, 17 Mar 2024 08:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1710690484; x=1711295284; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=I1/ILuYKRTR9hc7wiDsKsn9WptuOvIHMyzKs0l5GSkc=;
        b=STbt3N21GXRmOTglnRDapcV/wxbkNSvBToaLlBrxtAoMKnxEa1yg97KyA7L0kIL7uo
         34xxt1DA532/lJNbDaSEWj5RxM69zfSGNzGFzoyxAEaa3gdgN4yCrmnK1BztHhy4jddR
         l+oCs0uJFbMTFpAGjLpoUvJ74mFxe4sngU+F3i6uTnOJMwC33vwEhbhyouwI1/dbq5Gp
         gMzkIYj52WOGnZvKMUmAo3t4oJ5usbO1rLpxt4QFd0nWUZowrw3f1gZEs7IeZzoZylpz
         FlQx+4IBfFzR7hgrtzmGC96WP0zLOrcFNoc1hV+jIx9IPNf0Phzlo+FvaOJIff01hKeK
         E00w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710690484; x=1711295284;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I1/ILuYKRTR9hc7wiDsKsn9WptuOvIHMyzKs0l5GSkc=;
        b=H1BFfRiFkojTZ7nZgcLzUeeNHvcVm5n5EbpAs+z2cIfO+M/MAKGN1rYRah59kYW28w
         VWB6ZxdTrz8+wbKLlbiOvTFIkDufjqwG57KbvAU4oXM5eyhofODS8/BDgteFzAyxV0pq
         h20AuxfIutrUSRyfspe0xfMiyJkmGDP+wT6qgUnVnASxHs8fVOe0BIUh6rKIbfNpCKWk
         rqoJpAXjBZuKJ4N8WgfQKRbREphwY30ZLsfp/J7vBTmEiLOhivbjvz8vRFITvvdZ1akZ
         Hy2g12OZytGsp+u6Ruci4oW/0C3D19VsCE4HGONYmjwH2+76WMg1Z11tmgPtoYpJZOaz
         79Fg==
X-Forwarded-Encrypted: i=1; AJvYcCX2tWpkmB1dVcP8ivADpeTjIFNir+Nmrg0odF9BJMKO1KPna/d3iud9VIHb2lYpXWxtc5Q+wgaIfUjtc72MgKjCJHmpPabwQhjT
X-Gm-Message-State: AOJu0YwjFzwhpzPzaboz6jxlgQaNn19WfWTPKAWgI6UgBe6rBXRkjP02
	c7ALNyqOAcRD8DN/oHpDePmx9+rLZQ5Db6SfgOc4sotCgCFa6rJGrdiFqDMWNU8=
X-Google-Smtp-Source: AGHT+IGAVGv55SM4obM+qSDvbMP4XmlQQ6CPIEt7Tum/LfPyMtRYmGIXVXbJFrvc1kpyB7U6CSeEsg==
X-Received: by 2002:a5d:61c2:0:b0:33e:7750:781d with SMTP id q2-20020a5d61c2000000b0033e7750781dmr6929837wrv.56.1710690483754;
        Sun, 17 Mar 2024 08:48:03 -0700 (PDT)
Received: from fedora.fritz.box (aftr-82-135-80-212.dynamic.mnet-online.de. [82.135.80.212])
        by smtp.gmail.com with ESMTPSA id bv17-20020a0560001f1100b0033dd9b050f9sm7731246wrb.14.2024.03.17.08.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Mar 2024 08:48:03 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@toblux.com>
Subject: [PATCH] xfs: Fix typo in comment
Date: Sun, 17 Mar 2024 16:47:32 +0100
Message-ID: <20240317154731.2801-2-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

s/somethign/something/

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
 fs/xfs/xfs_log_priv.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index e30c06ec20e3..25b6d6cdd545 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -683,7 +683,7 @@ xlog_valid_lsn(
  * flags to control the kmalloc() behaviour within kvmalloc(). Hence kmalloc()
  * will do direct reclaim and compaction in the slow path, both of which are
  * horrendously expensive. We just want kmalloc to fail fast and fall back to
- * vmalloc if it can't get somethign straight away from the free lists or
+ * vmalloc if it can't get something straight away from the free lists or
  * buddy allocator. Hence we have to open code kvmalloc outselves here.
  *
  * This assumes that the caller uses memalloc_nofs_save task context here, so
-- 
2.44.0

