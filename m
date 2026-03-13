Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B6D2DEA9D
	for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 00:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773361645; cv=none; b=qXg6H5bfsDNj6yqM7rg84v5nopW+PvofDiLGQ+2dbtuIoRwU4gGH7HZQ4je6JG9JMFspImRsLU4R1nD7vYQvpaPKILJFIbJ+7Wme3tGwKYLj9/YxaUcIecaStUAb6wnS+mdH0sFl6EsF/RgL+QjHSeoaF8BDmqr/w/4/eoVUoXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773361645; c=relaxed/simple;
	bh=rypX12+AdfxCQ1cSDM0e68U0mqIO484wTFIOyha7J1U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pVC85jTNzMzH2AewhVVO5twAnKYUuOJ/1JmXPZThm511wJ3N35/k8Ln4tEP/SGcQJxSRPdTYPYm0ddehHkunVguCqqmmHZBc81gWMCWgqZdBGS7m9mGVmpEzyal1l9lekQjrndWaeR0tIhbO84SYrCLvOEQQBaZg1LpCzRXWK48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FE5RIU69; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FE5RIU69"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-35a211df8e3so385982a91.2
        for <linux-xfs@vger.kernel.org>; Thu, 12 Mar 2026 17:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773361643; x=1773966443; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MT6VPH+QO9HHaPrDH8VC9EQSNASM2LWNprddsvAI/HE=;
        b=FE5RIU69qtnX4AhmJqj0Kn0nmGDsIHde0TH48iKw2pKjM8CZErL+k4mbaPZaAB397W
         A+sB9Sd4ApeuclVfQhHnWeEuDSkDedxXJvVyBkcEJbzWpN1SWuATwnMBT4Gg3ZPSPyZD
         Q6mx770+8g8JqjeMzEw24RlfscnMiFYW701fQ16vc6N21HhcGwtIhiqZwOhF1v1sfir1
         J/JkVNyqJeBPDxu6GDrzuAL/iR0AqBAjPXPnyov1rxmRfyKRr9xdKMTQ0brpO5wPZoOP
         H+MfuN/ZTSMTNwelvdLsb+p7q78BIucCzDA+vdO4hqUtMVB4NZv/NlD1iv3akfKsuE+q
         NXvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773361643; x=1773966443;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MT6VPH+QO9HHaPrDH8VC9EQSNASM2LWNprddsvAI/HE=;
        b=O6uE/eDhJVl6nj7/fFpG8QrUMBzfsEBM4yFMxwsjp00r2HuJH/jCoxJunBzZ5fhq/m
         qiPwk+/T9i1ByDF2P6Fr5Q6TjBEteDUz1egyEU3VEfHJIc+JpHzjoB59+i3DveUehrrP
         9S893vnJ3t09GBi5o2bzLlBv69TG63DliENK6l1yap1IL/c+ifJW5Awzk1c0ITTYnoAY
         sqPo+GDGUHnAaV4j/d9zs9hxGGEGgbxq1hCDHY2p4mPHAOXvtBe8ilxYqsW8neF65WcC
         kKKPWLZ3coYhh+aSnpAgc+OVdTPRXl/xTCbyEaslh+HlQqWB/ji82lVFsEym+QiTnjEw
         7fHg==
X-Forwarded-Encrypted: i=1; AJvYcCXWeyL6hEcnCc+6os1gqdI8JIxUndaKFYEGOL0a8BmJjxeO4++FhG/ylpLINFTMPvkHarWoH3Dfm6A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4ZcQF0Sv7B9xj04ng6Xgek9gNWsgNs0LD5dzVXSWghWaX8STj
	8G8RE9DOOhT23yrqqudhCJZfMC/h7O2DpdtC0D/l1qUj2E7HoE+pMKfO
X-Gm-Gg: ATEYQzzCkF3FS6EVx2NOeXF1UC1NkDGcQHDgyF0763E85hvmdfrgNz6fB0Y6NkaLlMp
	VJmCtbiTd0D2yEoL5QGzawfH1Ahw/DqjPFqcir0IRMFtIOatqv3bxFOV4YV/W6O/xKxlxa5v5Gy
	qY44b92fMr8etdbAb2k850UigYi63YlkPD6rU3nhfFPOrSikOtQYYdvMs61rjo2fZpvogsRQA9f
	cdE/rraADc7TRD5PsnUk8qwfIa4GD07DwTl6LJSFfg4SgKXG6SuzKwEBvUg1AkdYy2JBfETHokK
	hZSN+uuaT4hspDT8jRw3vWCDVf0f+T6CPJJk/+LYmhZ3HSiuRlaZByrYpQGYLosqlMF+m9Ko23J
	vtWK7CKJBFKzWQxygiIpzv4F81ugkUd0KxQXsa+nEeNeEOXUD2HzFR8Tik29vedawDIKY+sIeA2
	5WSOuLja2Ryjwgt+IPqo0B1b7XLbaRrjxUSm9+ngTXm9+WQVZ9fCxS9nyimI+J
X-Received: by 2002:a17:90b:498b:b0:359:fd9a:c506 with SMTP id 98e67ed59e1d1-35a220553f3mr1288240a91.29.1773361643204;
        Thu, 12 Mar 2026 17:27:23 -0700 (PDT)
Received: from zenbook ([159.196.5.243])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35a02ba23adsm6528427a91.0.2026.03.12.17.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 17:27:22 -0700 (PDT)
From: Wilfred Mallawa <wilfred.opensource@gmail.com>
To: "Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Cc: Alistair Francis <alistair.francis@wdc.com>,
	Damien Le'Moal <dlemoal@kernel.org>,
	linux-xfs@vger.kernel.org,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 1/3] xfs: add write pointer to xfs_rtgroup_geometry
Date: Fri, 13 Mar 2026 10:24:54 +1000
Message-ID: <20260313002456.3823811-1-wilfred.opensource@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wilfred Mallawa <wilfred.mallawa@wdc.com>

Source kernel commit: c6ce65cb17aa9321687d1b8a842487f839e1a548

There is currently no XFS ioctl that allows userspace to retrieve the
write pointer for a specific realtime group block for zoned XFS. On zoned
block devices, userspace can obtain this information via zone reports from
the underlying device. However, for zoned XFS operating on regular block
devices, no equivalent mechanism exists.

Access to the realtime group write pointer is useful to userspace
development and analysis tools such as Zonar [1]. So extend the existing
struct xfs_rtgroup_geometry to add a new rg_writepointer field. This field
is valid if XFS_RTGROUP_GEOM_WRITEPOINTER flag is set. The rg_writepointer
field specifies the location of the current writepointer as a block offset
into the respective rtgroup.

[1] https://lwn.net/Articles/1059364/

Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
---
 libxfs/xfs_fs.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index d165de607..185f09f32 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -995,7 +995,8 @@ struct xfs_rtgroup_geometry {
 	__u32 rg_sick;		/* o: sick things in ag */
 	__u32 rg_checked;	/* o: checked metadata in ag */
 	__u32 rg_flags;		/* i/o: flags for this ag */
-	__u32 rg_reserved[27];	/* o: zero */
+	__u32 rg_writepointer;  /* o: write pointer block offset for zoned */
+	__u32 rg_reserved[26];	/* o: zero */
 };
 #define XFS_RTGROUP_GEOM_SICK_SUPER	(1U << 0)  /* superblock */
 #define XFS_RTGROUP_GEOM_SICK_BITMAP	(1U << 1)  /* rtbitmap */
@@ -1003,6 +1004,8 @@ struct xfs_rtgroup_geometry {
 #define XFS_RTGROUP_GEOM_SICK_RMAPBT	(1U << 3)  /* reverse mappings */
 #define XFS_RTGROUP_GEOM_SICK_REFCNTBT	(1U << 4)  /* reference counts */
 
+#define XFS_RTGROUP_GEOM_WRITEPOINTER  (1U << 0)  /* write pointer */
+
 /* Health monitor event domains */
 
 /* affects the whole fs */
-- 
2.53.0

