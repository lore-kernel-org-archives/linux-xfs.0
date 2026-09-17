Received: from mail-pz2-f40.google.com (mail-pz2-f40.google.com [74.125.228.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741744CDDE3
	for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2026 20:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789675724; cv=none; b=OK/emksct8WDKwN6fbUG1HpHn+CASP8GLSrRUQSOFLD9rtJgqYfuE42Xd+14FpBl6RSBxCfFg6Ef8Avs+9l2pyH45Wj3zFMWAqCtsAjISa7fgG3DQaxLrcJX1741ddZR6CfrmEn0MDNOPuQBUqDR8CjgnwxMHeBh1nKfU5pEFoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789675724; c=relaxed/simple;
	bh=c3HGRrbnWOWFQra+UhT4B1+Acx3bI7Nw6k8KeWp9BS8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YgRR08042ljN3I3SKjqZT60GWh25hMxlCScY4qf1HxJFx4nctkRJUUArgvb97ZQfH9uFwjOxPUyBnTifPsVEjex4LNeuXZ7LJ33kk72fwEjrMU/U1IRmVJtfPckIthb48wr3sc1thkgvuML6m7dtqfwIeP3EWEP8z4T8NGZ2VPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jen6q8ym; arc=none smtp.client-ip=74.125.228.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jen6q8ym"
Received: by mail-pz2-f40.google.com with SMTP id 41be03b00d2f7-cc52bd91929so318343a12.2
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2026 13:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789675723; x=1790280523; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=uxeSOe3mpO7CBa/xPERrffZOLH3W4cgq9X5vRuIxJTQ=;
        b=jen6q8ymJASpncWVXVmPn46vw7aI+VLYZASMpnX1Vkq4SxTuimukIAoLc+KHMIftUK
         f4YZdBIc5yEtahTyca+iwKJCqeKZX0TVR3n+T/U94iJKL5blp+6zzZ/xGnHSMEvWE9go
         BnH9EnYa1eArbzw4TU6gi7vlu4Labi/Yoe4S00RPu4XnNCDMcRQrQ7teI1z1msNTrVBr
         N61v6s6M+CVYxE9HE7HniccQV961hIOiBV1FcS8EEo/mt5c/rxsK0D9qP2ZcqCC/VqCE
         qKXWvAB9FPUBJkywv4g+yfQhdUtXYywsFbut65gY95T9POuSvudbCUr1K0CeRlSDYtjF
         0m9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789675723; x=1790280523;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uxeSOe3mpO7CBa/xPERrffZOLH3W4cgq9X5vRuIxJTQ=;
        b=Eo42SVUphurhKG/6gA+dhHJOI3stpl6nSldns7Na2vI42mYbGVJJAxrk8H1I60vs0Z
         o5o+rSaugtRAq6A8nTKkgpm9wShsz8WucUhL47Fcgiz7xewv2zVemRVQAXpF7WRmojc6
         CswiCPylPRfRdzWpzUZQq3Tftp5G/xX6pRypIcR1u/gPogrsxRc0YXg1J8AWlJ1tQIUg
         VMHnYdUL046JuWIDWIWKP/hRvecyAt8HU6n2nbwfWL560cNJKmbND/AvfvzdmpyOLSly
         xTaRbZEe28+9hcCYBGIsjA5Dl1vTAfnkSrQOlZzaoxH0iNMelwO7vyaJFl9WUEKrSEr0
         ybSA==
X-Forwarded-Encrypted: i=1; AKwUvByunXCO5YQlpKBg9IAFSVnq4BaYEi6CJ9I4Rcf6aufcp2fWFGRYOfdSpOLYYXAn31OgByTOmHZGY1E=@vger.kernel.org
X-Gm-Message-State: AFuF++nOOX8ypEUeOFyRUcUwKAU6/alyOo+Qqvalve5m77BVGHuUX8dY
	ty/5qp/IvmtPGFlJ3rR0MdXBLVyw+mY+A5ruK+/bRef+w02cOqkz/uG9
X-Gm-Gg: AYBFou1RWU6SWmF6pOk3xd4K6LIfVwnnczGGITAF4QObxAPGgunjBuKene6KcVgJLxQ
	WMirkpJ8UGX5cfWH9Jjcaod4uA3diiaW8u/QOHPrDPkdgQ5b3tP1F8+FZnhmU9aNlsEzpUiM33z
	ZvPoSW/GefEZ6kQueqVW0/XHwGANmibAhPoK72AwuJCf+bR9BB5WNNt218z51bbIj5OvnG2e9KI
	JOe2eXQRE2UM2BGYTZFo3SA7/DnHEsGKDjuKhOT+niYdUQpR15wP/YOjWjVlwe6mzhDqM2EXQ95
	esY+pCoBKeIVom884kgSln40wx6GeBlO03S5vpn0VgMPG2Bm0O61d/aihjPXI/nZ3we3WRjoBWW
	PXB8kD+iDtLE8UXSgPTu9TXPj4lnmjL3XCAj8O5LJG5gv0JZ2k4YZZ2JyMd3neoIdmihLuybPPB
	3RrB5WNUyi0mBBlyS5ZkRstd5nwC68+S+H3cnZSXxiyOUTWc1Mm+hO0KzHrZBMLxvsiRF7D5DIm
	w==
X-Received: by 2002:a17:90b:35d0:b0:398:9c00:29ec with SMTP id 98e67ed59e1d1-39e54d365a8mr510352a91.20.1789675722693;
        Thu, 17 Sep 2026 13:08:42 -0700 (PDT)
Received: from G15-5520 ([103.246.195.44])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bf5b2753csm33881159eec.31.2026.09.17.13.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 13:08:42 -0700 (PDT)
From: Lalit Shankar Chowdhury <lalitshankarch@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org (open list:XFS FILESYSTEM),
	linux-kernel@vger.kernel.org (open list)
Cc: Lalit Shankar Chowdhury <lalitshankarch@gmail.com>
Subject: [PATCH] xfs: replace kvmalloc_array with kvzalloc_objs
Date: Thu, 17 Sep 2026 20:08:35 +0000
Message-ID: <20260917200835.31027-1-lalitshankarch@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace kvmalloc_array() with the more concise kvzalloc_objs()
implementation.

Signed-off-by: Lalit Shankar Chowdhury <lalitshankarch@gmail.com>
---
 fs/xfs/xfs_zone_alloc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 28c1e48909fa..82615045aa4c 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -1238,8 +1238,7 @@ static unsigned long *
 xfs_alloc_bucket_bitmap(
 	struct xfs_mount	*mp)
 {
-	return kvmalloc_array(BITS_TO_LONGS(mp->m_sb.sb_rgcount),
-			sizeof(unsigned long), GFP_KERNEL | __GFP_ZERO);
+	return kvzalloc_objs(unsigned long, BITS_TO_LONGS(mp->m_sb.sb_rgcount));
 }
 
 static struct xfs_zone_info *
-- 
2.53.0

