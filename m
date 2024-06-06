Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CAFC13C
	for <linux-xfs@vger.kernel.org>; Thu,  6 Jun 2024 03:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717643685; cv=none; b=Ep7bvw4I+9hNyuuJBDdh8L+ZkmLik/MUEyfUdABV/RpxwwGRn8fJcXPA3n6zEWDIuGJ2pxsnHVKw9DgpBnHZcRvaa0os0EpbK/IqPFvt0TFoF1lqBK45j5K7uPdixbG96Y2TKIVvQrggXdHUfx8KVJIIhTT+jU7cLo6GOiCUQXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717643685; c=relaxed/simple;
	bh=YH+wQYETa0lXD6o5PXpj45h9EZdLrUDItNVwWiD4ZiE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XZ1eGlZ3wPPlC/oJsA16eqO7tjzkOe9/zGK/GHN8o3mnfdbJNlz0xsK9Nm39QxNIvIxaJCMW5FvgpX2DcHr6uuA2Ffbwl5HkCJuW7fxOGKbRIse9AfPlBnU+5gFeXHu1lI7+/K0Szms6hwl+yJ4Ak9ZEJkH+e93XnHGigLWDD+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Slf++1/L; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Slf++1/L"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-70276322ad8so500852b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 05 Jun 2024 20:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717643683; x=1718248483; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6Oqy5CCWLXP7ZhHc0UGby/SOa4BMyRjulF8zBUzOgmM=;
        b=Slf++1/LVolwG1w8C75gJ6XDaYBn9dX/r5JgBgQGDdbGIJRBA3rShgl3ZXay7PnN48
         Bi35imBrmSkPIIidyhMbtWfaPrhtgTeaxBJWFzeC0UoCw34kAJs8yNo9S5taHI5rrhJq
         RFeQYEJhXTT9ZvcmDd3yTixRtJ7Vc3MKX3Oq9mP0yE0N0pF/59AV2ZpzwOyEwm8ArFUr
         atviMWWGu9E9JFMSeyQWebv3yn7yNFXmIvyfKS+BHNzXKrwwXMKUVsyLneb/MayPItXL
         Y3BHAMvQu9KSfjrsna3bMAFV6jYG079n//o6dNr7eR3rlcDEkEd7WZ26AGe+wjVmnQCN
         T9EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717643683; x=1718248483;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6Oqy5CCWLXP7ZhHc0UGby/SOa4BMyRjulF8zBUzOgmM=;
        b=HgUQDsxByPR12oO32AHlJk0T2Pk2lGbzQ0W2cM7Drfb6hSiytxlC6TxN8Bdo8hOplC
         1Kz5qnDqV5LrGHY/Dl3IPOIeRAk7a2ASDlqD7Ezp21xXKMie8E4IRPpru+MPtHL1BfNT
         T8Cn/FqPITb+zYATR8pjCeBMM/bE4jz9qyKCZc2oBEBWM50Wx9VMwRS2mmcsT2oVUG1N
         F6xb9ZmuHjfJK5hzGHyUklAo1Q3jfuuq4w89T4KyhfzXUiKj6Fv2FW/1gRQZmjxV2Xme
         qBxrVA3jPdsY0qF35wTOGIbHIJkBPgopU3yv7kuo50RcyPua7Gq+y6oi5qbe1dyFwbP+
         i6QQ==
X-Gm-Message-State: AOJu0Yzhv0/3VNAom/rYc8r+lpSCCG8S+xagM75a3JsBhYMSsuzw5jbc
	l3vJ/ewYKQKc3dx5ao+b0SLqXX844xhMTALibxx69q6F2uGJxDIfNP7FtSDhJuI=
X-Google-Smtp-Source: AGHT+IFT63y3jdMlYaxMqDQLpii+CW8Og5ECmafgGyiQx3dgeNfp2LKDL/17VNVbwnBRz8yQjDmTcA==
X-Received: by 2002:a05:6a00:1903:b0:702:58a0:25ab with SMTP id d2e1a72fcca58-703e5a42cb8mr4908621b3a.31.1717643682801;
        Wed, 05 Jun 2024 20:14:42 -0700 (PDT)
Received: from localhost.localdomain ([47.238.252.167])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-703fd52c316sm229633b3a.208.2024.06.05.20.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 20:14:42 -0700 (PDT)
From: lei lu <llfamsec@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: david@fromorbit.com,
	lei lu <llfamsec@gmail.com>,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH v3] xfs: don't walk off the end of a directory data block
Date: Thu,  6 Jun 2024 11:14:16 +0800
Message-Id: <20240606031416.90900-1-llfamsec@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds sanity checks for xfs_dir2_data_unused and xfs_dir2_data_entry
to make sure don't stray beyond valid memory region. Before patching, the
loop simply checks that the start offset of the dup and dep is within the
range. So in a crafted image, if last entry is xfs_dir2_data_unused, we
can change dup->length to dup->length-1 and leave 1 byte of space. In the
next traversal, this space will be considered as dup or dep. We may
encounter an out of bound read when accessing the fixed members.

In the patch, we check dup->length % XFS_DIR2_DATA_ALIGN != 0 to make
sure that dup is 8 byte aligned. And we also check the size of each entry
is greater than xfs_dir2_data_entsize(mp, 1) which ensures that there is
sufficient space to access fixed members. It should be noted that if the
last object in the buffer is less than xfs_dir2_data_entsize(mp, 1) bytes
in size it must be a dup entry of exactly XFS_DIR2_DATA_ALIGN bytes in
length.

Signed-off-by: lei lu <llfamsec@gmail.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_dir2_data.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index dbcf58979a59..71398ce0225f 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -178,6 +178,12 @@ __xfs_dir3_data_check(
 		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
 		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
 
+		if (offset > end - xfs_dir2_data_entsize(mp, 1)) {
+			if (end - offset != XFS_DIR2_DATA_ALIGN ||
+			    be16_to_cpu(dup->freetag) != XFS_DIR2_DATA_FREE_TAG)
+				return __this_address;
+		}
+
 		/*
 		 * If it's unused, look for the space in the bestfree table.
 		 * If we find it, account for that, else make sure it
@@ -188,6 +194,8 @@ __xfs_dir3_data_check(
 
 			if (lastfree != 0)
 				return __this_address;
+			if (be16_to_cpu(dup->length) % XFS_DIR2_DATA_ALIGN != 0)
+				return __this_address;
 			if (offset + be16_to_cpu(dup->length) > end)
 				return __this_address;
 			if (be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) !=
-- 
2.34.1

