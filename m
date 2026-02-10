Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CA62D193F
	for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 06:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770703202; cv=none; b=VkcLeKdoig4YAIFgNorujc+m0pOggd7D9trq5GJRqF0vikrpBz1FeA4KzBU/uH+F629+LewvJq7ovoolUE2FHjgvwifPxYD7PohPeP57Se6SUB+ulhf9S4YzFMqRifpcpslY0NoCb/qZ6P1j7Tgz22G04+BsFIsZQQ5NQVot5ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770703202; c=relaxed/simple;
	bh=AmJ72jkmLt93zYSRJNvwVvOhJZq1WK5UnrTvL4LIR28=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VI3mnNlQsCR4UTRr5XUB0eSFTPISNrzHu749AjfClrHAgk36Fx6D6R11wA3yYZfRyNPze0wDudVAxu+kRB/guNEuagIfJpBD1ud1HE1ToPTGx1/1gM2fyxzgPHf7i7RLlD3qI9D1Cc2jTM8wSR97AAUcBeQelby+d/J1Whf9K98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KxPevV+b; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KxPevV+b"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-35621da1a7dso336931a91.0
        for <linux-xfs@vger.kernel.org>; Mon, 09 Feb 2026 22:00:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770703200; x=1771308000; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vSnQjQ052QkE2hFfAkIrvpTu+1Exs0mRI2qMEo53ieY=;
        b=KxPevV+bvK9ZuEMAvoMnPnNLV+bu8lwzOVtEZk1IBONgOXNytYTdQGHcGM9gjHXgZX
         0MahY6p75P7cuRv9dmsreG7T3z1Wvz9UcJjVAUFX1kT951pJAOjiY6OzhcreS38LqfKz
         tZASF9jfbWiFGMfZ930MzfzaGk9odfA/5mjLvEhkG1MKGFnx8F4Ndb/JIQyIaMXjM9Zt
         i6odusEQNNOKB3Di+BfYVO57+n/X8LnpXHRaFzrsRBLov/faK13/A6NIhQ2tlWkou+Sh
         fdVGrLiyLU+EZzQHZZulQQohb/MIvMRTg0fLtCg+eN40W2rhKX3/5yusBlZP4DSCbrw9
         8hVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770703200; x=1771308000;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vSnQjQ052QkE2hFfAkIrvpTu+1Exs0mRI2qMEo53ieY=;
        b=QugvLFD0BYCzsRRnMUlN+qGkfD/C5Hnj2N4QAUE74wcpvG/1ietuna0bB3Pf9811GK
         PKzbuIt4iAWSVzHS5pAjQwV1Xz09k/e58Jc87ozueSh/Z/pV4tDmTBp18nmn4t6vRsJM
         xFpQFuoR/4e6Z+DrQCwMmmLX9zeFlV7GWlEZXBqhBRT/FHljeHV0MxxdMjg59BtBwv/z
         koLkshI75hW75imb1XeQG96Pi4j3oeFdGtzUP44rzP/Cruv+zx6xRPh7QX5FVfmMOSvj
         QfVQRQlIg5NpSJFbGhUxh8zXKTHHGQm2wkQQ/6LoKW6VsGi7lIUv6qlPFeHmEBYlXlsN
         BDwA==
X-Gm-Message-State: AOJu0YxEzX6BpSGRuSoRRqEpqt1aS0ZxITQPjEA8KIiLNDEse4XUch64
	JBSSCaPLUZAqztCW9GtKgkL1lR8ap12GNxEGCyyOibOi0Fi7XaIcjCRW
X-Gm-Gg: AZuq6aKkfGk8hbdKBzA283v9dDfMhGq7cNWeZ0wOxldvA9F/jdAO3VqQ7bNv1oA3d+d
	Om/ocu35Np6fCczUzpqSuFo/EvPQhAPxZwrIYWf+bNzz2Lv+qd6G7HcWgZm7NPjh3OAhfM12jEI
	n+F0mjfc+6bIu/10k+nmbPxeRyTYql3xxQ7Fc5HJJjeksmREjsnj0VB2hTEzqdDtdL+NBFHFPu2
	hfX8uq5qSD7WUAq3ay2ORKnOjIVj+GGZejYfvHIGKVc2noYnLJ2z8eCC5FC8+i7kuxoyPnEwYnn
	QHtEXYtChYyUcaAp21kczSu9iYxh4wcJckkFe4JlhIOVHf5diV6bqoBwCarJluguwf1YdeO6c9U
	CEz7VvMekSqZfx6dQOD3x4zzDUak0A9kc6+oH9GkEwxjSrBPnB/qyd7lqYMvTQAqo1jaopfZh2B
	FSqsTc7IJrE9h6O7np4dT5H3tpPV3q2B7zmtxjMgEo85zidgYUje3DKgLmvmc4
X-Received: by 2002:a17:90b:5348:b0:34a:b4a2:f0c8 with SMTP id 98e67ed59e1d1-354b3e5c2f9mr10682101a91.30.1770703200340;
        Mon, 09 Feb 2026 22:00:00 -0800 (PST)
Received: from zenbook ([159.196.5.243])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-354c7fad6c6sm6028151a91.1.2026.02.09.21.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 22:00:00 -0800 (PST)
From: Wilfred Mallawa <wilfred.opensource@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: [PATCH v2 1/2] xfs: remove duplicate static size checks
Date: Tue, 10 Feb 2026 15:59:41 +1000
Message-ID: <20260210055942.2844783-2-wilfred.opensource@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wilfred Mallawa <wilfred.mallawa@wdc.com>

In libxfs/xfs_ondisk.h, remove some duplicate entries of
XFS_CHECK_STRUCT_SIZE().

Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
---
V1 -> V2 (New patch):
	- Split out the deletions into a seperate patch, and only remove
	  the duplicates under
	  "/* ondisk dir/attr structures from xfs/122 */" label.
---
 fs/xfs/libxfs/xfs_ondisk.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index 2e9715cc1641..601a8367ced6 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
@@ -136,16 +136,7 @@ xfs_check_ondisk_structs(void)
 	/* ondisk dir/attr structures from xfs/122 */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_sf_entry,		3);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_free,	4);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_hdr,		16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_unused,	6);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_free,		16);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_free_hdr,		16);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf,		16);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_entry,	8);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_hdr,		16);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_tail,	4);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_sf_entry,		3);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_sf_hdr,		10);
 
 	/* log structures */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_buf_log_format,	88);
-- 
2.53.0

