Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568CE42254C
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jul 2026 13:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783432784; cv=none; b=G2L3vyn1vkhEMnvXzMgDtFJx33OfnLEDwUdTu+LIG5/xcereEVU59vZUDbP4ydaNovIXqG5zqo7/NP4qkC8ZpT3ZAFiUM7Z0Aul3Q7MGWmm1J30UJGJ81/LopxQADwkc5r08geNo7MXGjPIzPeRNpjg+xDDzyk2uMEazjaoHdNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783432784; c=relaxed/simple;
	bh=zT/PJSB/X9vWE4hZBw6qbsjL+iFNmQr/XBpWHwP3Uo0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mXMRuOUwbI/eeHZHEi1bPmFmY0m8bseIyzh92AzgPcwhmcEaCu+2qFG+0S1XUE+WBaJqDj/vIyyZ2s6ChwXbD3NNQejLBtVzP3cznzXziVM6Dno0r6kHUfjxrafNb4d+ZwzZSSDlfIj3/d3wFkWWaY56vn9QCnRYdZhuHCfUwYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ww9MUtLC; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ww9MUtLC"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-ca1328b8584so3337306a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 07 Jul 2026 06:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783432782; x=1784037582; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LGFuF2FyGr+a/8CunO9g6M8NWPaHjvODP/XSRSVCSC0=;
        b=Ww9MUtLCmSunDhe0ZJMPva+bLaZ+u5uDrBzjEGZMyTeqOqQDneAP4cWchiv+FqJ+21
         +EFH1y0NGuqt39N86TtwF0PDlfRDIHBPqkfJ7k6lj2XsbKkEK9tKLNOzRliUuq7X4UEy
         y/bMQGBkzTzP+sBq8BUFoXCgzYUVrrYRFc0RIUW4AnS/iIqtbUw8HJRZDPVQVSbcqpTF
         drheLGAzPMT0U/7qM637/AEMeKTBodbxftWTpXZ4etvjdp9HiBVAXXUoXw8r2fiqHv3g
         5SYYuSf1dTTyeCV4DkliA8rSnaAas9x4mGKzdSFNYY1dVoclHETzr+v617p9aD3vIfA8
         suSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783432782; x=1784037582;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LGFuF2FyGr+a/8CunO9g6M8NWPaHjvODP/XSRSVCSC0=;
        b=FBPQ2vBXqRgzYNDEPziearT2AMqebKEg7+30JNXArueRvoFyxiMGprlMdMoOIbwQcn
         wgk54iMmCa6bmKRtr/8yjvbOx8wgz4pPwArg1H54Tlvnzp2KT4aUNdaf83bTCKXaxT4A
         LqGDjSNyNmXfsW2hV7OZiDhTIVKyz8M8S8/vLCgvLRlYRZlbxV3n3bKpKvTrDNTssnGy
         GBqjOErbHYbtYZyopued27SU3goJGd4uPz0YnafVNHktE3uUiM33iMYSxZ0BDjB4mDSj
         4RarYUrHH1XRDdlOcnlh3coSBzFQ5U7Cnh9peewf1hMglEbvscq+T7pYQSgj3ekBJWWM
         yC/g==
X-Gm-Message-State: AOJu0YwtlQi655ghVXT5zTuB92gwb1ZLVl1xQy+K99kxrbvxKOqcdlFV
	kFaNfZBNqad9Jce9KQOgnoJVC/DtKNvIsQhvL8bsTHExkg8u63pBM1NzL+5AbvMYQEA=
X-Gm-Gg: AfdE7clyVIpyNzXasTg/mFscRa+dWfOvcg5W62Phr7BwseRuP/Pxzofz/X5Tc/fWB3N
	1msADtoDZKsB8XyNbUKTKKY0jvBziwYNGf7YSxfSu83LDP2AIGkfDebhm5JcEzTb2ff28u3hbOh
	7dhV3Qr1p7p4EgHn7iOS0KSXfB2Gfn8PnRJ9MEoYv0ng1rCS4VLQOIC6s8USxwvYGtDd5QZgfJ6
	Y/1kQgItzlm87lHVJERFrRaQp8AZSvQzhbHPAG9azA/8pKzCA8J/5QFBjTZ7BVErCUYhDueYonI
	MUFclEdw/t9td+mPm8jh98iRUbMyQvfYTqRlxq5+97Z3BtJ1Q/DWW3e3HdDG4MtqgJBGYhrXn1n
	3LojE0Qi7BwuGV99df/ACk4VyOcyp1V7+AUK6Fog6ufbniAsWVl+AwFSShtcjWCcWMpOqLFiTLR
	lZyOiB
X-Received: by 2002:a05:6a20:d494:b0:398:7ed3:a001 with SMTP id adf61e73a8af0-3c08ec61813mr5974200637.2.1783432781480;
        Tue, 07 Jul 2026 06:59:41 -0700 (PDT)
Received: from beelink.. ([186.22.57.86])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3117483dec6sm9233205eec.11.2026.07.07.06.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 06:59:41 -0700 (PDT)
From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
To: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-kernel@vger.kernel.org,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Subject: [PATCH] xfs: bound da-node entry count against the correct geometry
Date: Tue,  7 Jul 2026 10:59:30 -0300
Message-ID: <20260707135930.3214701-1-qwe.aldo@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_da3_node_verify() bounds the node entry count against the larger of
the directory and attribute geometries because it does not know which
tree the block belongs to. When the directory block size exceeds the fs
block size (e.g. mkfs.xfs -n size=64k -b size=4k), the attribute node
buffer is a single fs block holding only m_attr_geo->node_ents entries,
but a crafted attr node may claim a count up to m_dir_geo->node_ents.
xfs_da3_node_lookup_int() then reads btree[] entries past the buffer
during its binary search -- an out-of-bounds read via getxattr/listxattr
on a mounted crafted image.

The node buffer size identifies its geometry, so bound the count against
that geometry's node_ents rather than the maximum of the two.

Fixes: 7ab610f9e0f1 ("xfs: move node entry counts to xfs_da_geometry")
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
---
 fs/xfs/libxfs/xfs_da_btree.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 9debb95d86fa..897c31147a46 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -240,12 +240,18 @@ xfs_da3_node_verify(
 		return __this_address;
 
 	/*
-	 * we don't know if the node is for and attribute or directory tree,
-	 * so only fail if the count is outside both bounds
+	 * The block was read using either the attribute or the directory
+	 * geometry; its buffer size tells us which one, so bound the entry
+	 * count against that geometry's node_ents.  Only failing when the
+	 * count exceeds max(dir, attr) let a crafted attr node claim a
+	 * dir-sized count and overrun the smaller attr buffer.
 	 */
-	if (ichdr.count > mp->m_dir_geo->node_ents &&
-	    ichdr.count > mp->m_attr_geo->node_ents)
+	if (BBTOB(bp->b_length) == mp->m_attr_geo->blksize) {
+		if (ichdr.count > mp->m_attr_geo->node_ents)
+			return __this_address;
+	} else if (ichdr.count > mp->m_dir_geo->node_ents) {
 		return __this_address;
+	}
 
 	/* XXX: hash order check? */
 
-- 
2.43.0

