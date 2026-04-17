Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD7919E819
	for <linux-xfs@vger.kernel.org>; Fri, 17 Apr 2026 02:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776392422; cv=none; b=lH6cLuJCG9ARhov89cyuSU3NObpJwOUAYTxEDwJX+knbiESK9CL3ZkHieUvc6tW7U+CVY0DP/U7u3S22LhoFXYcinnFyMJeC2XoXjNKOuINBkNGFsNnyJvzk3CXEH0FK849GQBq54b11vGsb36N+Q0TDZuZgyiP/8P/ktD8kgVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776392422; c=relaxed/simple;
	bh=5j85XGswc2GOHEzFSMXdQ2SxMifDnZPaFHM3gaXODcs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CelSNv5XV/zp56p1YNEZQ7SPZPWMhG70Eukm5no+LaJmoTP7eVVuRs0DYUs/Mi1E33raRV2+oFlhwbhkmHwB9cLmWUX0Z1VdAT/0emMj73MLGLqfCQLHwR2bDs3OStM6Y/DNMXPCaa8+kzczBmnzEVRWEkXM3RPc3ZXL8vNCsKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QXIhdGLh; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QXIhdGLh"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2b2503753efso1490335ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 16 Apr 2026 19:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776392421; x=1776997221; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aP2NeMu1RlgKc7YK2syJ7UutDazfj2hr54ybuy2pACs=;
        b=QXIhdGLhqYXyObBouzBFkLZ8hTSLGdPraO2vroZz+QZJ20SQ6T5PGMu+siCObJxFmo
         E2j7InPQiXEItAN+HnBy6uLJ+9Ui2xZ23XEpffszMJRIiZgZI2BIAcCvymeDU7wIHTHU
         QRnsUKGHGShaQgOoligJP/ZljpFrHP0Fvz7DYPZ7K+XME8GWgjSVGhB6ehcV5RK0DgKr
         Lh5FDrQDT0fjQR01kMyU+rB3efmsh87eToCOyGyDPTXwgwdFtlRo/rVMcND2+Se6ehhD
         fA8luC0H9mV1JhH2BcSsfj8kgXk/AkhlIF5BPsk8vRSgem7v296WZaZfVgvl2pCgO9B8
         0sVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776392421; x=1776997221;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aP2NeMu1RlgKc7YK2syJ7UutDazfj2hr54ybuy2pACs=;
        b=R4r9UaxrkGD6tZMbewWmAcfANOA9HIa1IwI9jTfFhLHgnf0bwlZCorlcU/g84Lh4rG
         yOtr7rH6E/Sor/igKFK6N1cKwgLmaviS9/Kgn475LR6Ggbb1DvCftax50zxeH9IqLx36
         jS3jcQtHccQhdiMw4m4/FOR6m4eXHMVcQjbkWSLaNs37ucyzCMfiQKCMTw17OJFyd4LE
         41vaq5BCdJCOK6CI2f7fgzy8/O1paw3NfUq8Vse0T+42kc5oDFf7e91Xt7VHmabZ6p8O
         VDO3gkNXITc3dC80qmQKeZ2jRE6m6mCUxBY9QC96FTXoOUPTbWJY9q1mKzBx2FoFCIQn
         WGgw==
X-Gm-Message-State: AOJu0YyGhWmqNigeF8/0lIVWeGADJ/JMzsrdf59N7Vsji2iCXD6XWaoi
	/a+1XkYum1UPcI68bWqxrBewky12D+Yw6meNaoCvPAlWsJjY0NBGnSsn3WPSZg==
X-Gm-Gg: AeBDievr8R0kqUtmAEam02ez0kvsCI2uP0D/gcN5ETRtXlnCFV19HlAWfycqFbiyFcP
	UOYcqnpNQ+MEzzjo556jRWP7SChIon3MNDLUvezVo6xMcr1a6jEWRR1yMAnXHaAlSLe3wsXT3Lw
	f/3mHoAHUY4Lus2GP6K5Rt+fJjNW+gnnSUlaGVUeJnfroxMtr8BzRPjzNFBgLidytNx2cYKLABc
	FoUp39TaBBB3eopFVM5ZCG/W5EjFBMxLoBqPId+raHn17MBivsR2CYdcfFiecFgG/9RftkBZToz
	Y9RoLoTeu9QhM4I3fIIki8jRbPqwbD9UBjN0JyatI1r73FisnIM/+kfQAETOeQIpCM9vR9RLw/w
	9fXpAwh0jYfbNIaHEOZk9rlMX4kE7kbF6wH4wYssRIuHrSFPyiY2BIFCB89QewF/QpMiLpoL3fE
	xxmJZbuS67PW5TmfY0S9GllB3Dy9oxvfucTqNSRzI=
X-Received: by 2002:a17:903:3d49:b0:2b2:3eec:c75f with SMTP id d9443c01a7336-2b5f9f638f0mr6825755ad.28.1776392420915;
        Thu, 16 Apr 2026 19:20:20 -0700 (PDT)
Received: from zenbook ([159.196.5.243])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab0db13sm2569645ad.53.2026.04.16.19.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 19:20:20 -0700 (PDT)
From: Wilfred Mallawa <wilfred.opensource@gmail.com>
To: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	stable@vger.kernel.org
Subject: [PATCH] xfs: fix memory leak for data allocated by xfs_zone_gc_data_alloc()
Date: Fri, 17 Apr 2026 12:16:30 +1000
Message-ID: <20260417021628.2608734-3-wilfred.opensource@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wilfred Mallawa <wilfred.mallawa@wdc.com>

In xfs_zone_gc_mount(), on error, a struct xfs_zone_gc_data allocated
with xfs_zone_gc_data_alloc() is freed with kfree(), however, this
doesn't free the underlying folios or the rmap_irecs.

Use xfs_zone_gc_data_free() to correctly free this memory.

Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
Cc: stable@vger.kernel.org
Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
---
 fs/xfs/xfs_zone_gc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index e7b33d5a8b3d..2520e57e24a8 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -1230,7 +1230,7 @@ xfs_zone_gc_mount(
 	if (data->oz)
 		xfs_open_zone_put(data->oz);
 out_free_gc_data:
-	kfree(data);
+	xfs_zone_gc_data_free(data);
 	return error;
 }
 
-- 
2.53.0

