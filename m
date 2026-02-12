Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3F12773E9
	for <linux-xfs@vger.kernel.org>; Thu, 12 Feb 2026 22:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770936635; cv=none; b=gGuUHRcP/Ypd4BbH40GNQZFmpH71gKF2YPQqyFLa6se80TbUJbwRHo+Ezhl6atr9J8HHFxKuVFup2aCXOmQGjCT2kQbejBzb4msFtVj4Vspwe6i/uWltDZyI8pPIqlNK4Og1cb+f/4NCHUOW3h8y2XGcY0yha4DZPetcEdhhYX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770936635; c=relaxed/simple;
	bh=S4L8KEV+oGSnV0gsH17knwwqvPWzTD5JbFKFruKQbyE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cgkzOnbIKIIdnBT82fUwNfVL4oSioMJHJlWZFc5dXAQ4J/8gh/gcQbzk2g5DpvvF5Yj1GwtWUCDUiufaBarByRRWOz0oHWc8yBIUwjfHb9b2ZzGTbkCzE4anC2iFDoEudgLWbS4+WhX2oDAhW1gUQBlmVs1rY+gyetaYkN9TyXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cvdAQxcN; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cvdAQxcN"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-823c56765fdso244682b3a.1
        for <linux-xfs@vger.kernel.org>; Thu, 12 Feb 2026 14:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770936634; x=1771541434; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XSMZQKY+yJGeWhWXBDSGG53MrRgkzS8SHGkIqFhf/2Q=;
        b=cvdAQxcNrvKc8JpuTeXXeEaQG4hQNdLipRzOYs9/WCFZMDKf8F8wrOtrLWTQEt3YFj
         uC9TjgCZJ5FyS10X7IdHB8kxqtKd5qwdGY1kaTym3NELyDXAN5AYc0r3qpSthF2XMFIL
         NcdqIAAY8I51kCqwp7ISZt/t4Sm4xdUTp7e3wSyrTZRNdFDIx/h92jj2n1GGh0L26HsI
         l9ebEaCdjjSd6Xa8vxbyrP7M/PUj8FfEFZtp/keU167iv3SP6hzsauDQp5Awe5dk/KmD
         RVh6aAMPc9ZuLKWcTYwLGWKbNaG3DC/gnb3mmT0s4faoXx9ckA3/ZCoZuD4uRxqN+wdd
         4Sqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770936634; x=1771541434;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XSMZQKY+yJGeWhWXBDSGG53MrRgkzS8SHGkIqFhf/2Q=;
        b=hoG6+WW5GO/RQjumiuQj9Or1QS4pXjBh+4wbw0wD4i5KDUddW4vk0j9BDx1wUJv+nD
         vudczcAiwKNuavASeYE8O736Hd7oOBfn8i1D8bF2wM9rrb4bUsOFWIkCo6RRpWaQxNbu
         DRcNzhQUNluixXORpJZYrtEEoqc22HjgZa8cK6U4sRRwYK6CxjLJkSya+hzlV3ys0k0s
         TwqzBzB+D6GNJMtqY0tIhJ0yftTWFXy0Ra/dfNPksTyGgEmk3P8EiI+GnT+p5V+XTtaO
         EBaStA/2scMPlY+XvdZO2R0q21kHeBbNnkTzuweVopCl3QG8oFuo1DYNzxB8wVPo5Gu4
         HGDg==
X-Gm-Message-State: AOJu0YyYIFHVCg7otJyCziRdIB4xWllJw+x0TUNQdu7vUV1vxMu2gvWP
	Gt6CgF8u7aYKAXJRm2/1PuKcg43AO5q6is+S491sFqTORl5okrR4FS/s
X-Gm-Gg: AZuq6aJRqTJc2rDnw+soAVn+NuTfD0ePhud253dsIAt8qqYb39iDfVxbOuum4xNr6U/
	c+iddWYecLMEzCRglUOyMOF93L8rKARPAWYsrsAJ+WTz1upDgES1oeBaZBal0mP7msLSD9Eh0Bb
	YoIaUClfXZf91Lo7psoni1PgUx6/2MD1uMZfokpdyKvLDmEzXKix5Id05CWxtxVArrkj309Igus
	VSgKmSNFCleJPct2br2ifOvphdef8WzFfDTmPjZXPrkWRATtcI40zVOzaMSFjYC/xN/uHjlNm++
	js0UPXErbAZiwdNZMp7sfb8WZWAkKUBBUHiLHB5kqcUfGU7zd3+RCJdGhgwkMThnJxBGA0FLApD
	i+PzR4EMutk37ZXym/vMWZLk5SLTsjVoNT/PaBeupP4aCaqptDlIy5hpwSaCAl2P4Fy3u/+uOl4
	dbM7dRoEAhdLvtnsBxEjH4/bIIloaDYh56OuEUyHUjmD7wXcIY98l1L+RtXb9+
X-Received: by 2002:a05:6a00:2917:b0:81f:4294:6080 with SMTP id d2e1a72fcca58-824c9516134mr870b3a.20.1770936633758;
        Thu, 12 Feb 2026 14:50:33 -0800 (PST)
Received: from zenbook ([159.196.5.243])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824c6a3e15bsm297446b3a.19.2026.02.12.14.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 14:50:33 -0800 (PST)
From: Wilfred Mallawa <wilfred.opensource@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: [PATCH v2] xfs: fix code alignment issues in xfs_ondisk.c
Date: Fri, 13 Feb 2026 08:50:06 +1000
Message-ID: <20260212225005.732651-2-wilfred.opensource@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wilfred Mallawa <wilfred.mallawa@wdc.com>

Fixup some code alignment issues in xfs_ondisk.c

Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
V1 -> V2:
	- Reword the subject to clarify that this change is style related
---
 fs/xfs/libxfs/xfs_ondisk.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index 1914ffe59202..23cde1248f01 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
@@ -73,7 +73,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_free_hdr,		64);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_leaf,		64);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_leaf_hdr,		64);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_entry,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_entry,	8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_hdr,		32);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_map,		4);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_name_local,	4);
@@ -116,7 +116,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_da_intnode,		16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_da_node_entry,		8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_da_node_hdr,		16);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_free,		4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_free,	4);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_hdr,		16);
 	XFS_CHECK_OFFSET(struct xfs_dir2_data_unused, freetag,	0);
 	XFS_CHECK_OFFSET(struct xfs_dir2_data_unused, length,	2);
-- 
2.53.0

