Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550B22E65D
	for <linux-xfs@vger.kernel.org>; Thu, 16 Apr 2026 03:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776308812; cv=none; b=kmeueuEReQ/fVlNd/waYIYE/iRO9NVKPK3Oc50vPyFJOuBdlIT+4uNqqtV2kFrnjmslBQNKZPlpLtwuRA8Jzn84vUhEWRXR9gJMjKcpsQJB8hnru8Tj+HzjQ9vVXz1tUi3P9/eLrExOA/jF+97DrEt5j6TUPJhxJ9eMBKNpoWjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776308812; c=relaxed/simple;
	bh=2I63PklS8RTMy4ZBeNJKH5O9yBN3sFjLFkFF7J32HPQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GBCHd9r2QkIysBLl/E48RYlmfRQ3xNJEBHyqyerBKE9mV4iacgBQX04o53nXWUuhLhZuWHtiHvlt52yG0CnEGihkI2F4YA2FZdEsvx0a4wg/yuEsW9YWG48eaGNohlR7s6QBbtqwGWyHIBkwKzZr5T75uclz3VufUzd6yoAfb5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c5xOjVjk; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c5xOjVjk"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-82f68b3aaf7so577753b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 15 Apr 2026 20:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776308811; x=1776913611; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZLwFWID41PK+d9iSUqQXYtWXn+ddFgZMpYD1ReTw9mk=;
        b=c5xOjVjk7TuFm5MB6lwedJy1MqdOq2qCUgT2W0wTYlqXXGBxr6j4FK/7mfwTMGmO0g
         x1/W5/Fe5UpM55ONkUq4dz71yU9OMqkYvgwZOtkyXanOx0n53220JWW4Iu8xIh/4nP6y
         TiTdUe+Xr8vRs5H5/aUISLCKVV/fK9oY4ZFskeFvcGb3wRDhq3UE8s8tTSOiWBYbqM2f
         CEsKSABToJaTlls2XbSAlbihfI9g+xYsxwaVH3vEfFs6NgvXKOnf05Wf7zGkew5FR/ut
         kc2d08KaKgeFtZ4TbmSDlm92m3/XOm5yNFZeb+994Z69QBpto33gAF6Xi5TnsJBkczvg
         NBsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776308811; x=1776913611;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZLwFWID41PK+d9iSUqQXYtWXn+ddFgZMpYD1ReTw9mk=;
        b=EX6vO3N2KkDSMws0hNEHqkVJuNNBzfYzCYvXY/G7N986QDX5ZXv9IOrT4dLhUaFlRt
         EfRYxJlVRc/EB1+yyJV9NQkOQa45MAe8i03FrZ6GGta2GwIKU0dpLcr6w381LF36EL5g
         TYM4sIA/ew+YloN5uqESCO+5/R0THnivdahmc+JW2X2OLcnQQzKdyX6TETy2f/0FvwgX
         UvQSJ4Rk8V6Z14lpVfbPOAAKXpa8mATCo0UP58fXQAVX6Wylk2tIbUm2wmn0ufN60zw6
         MZrNyLvxykMuj0xLN8LYI8Psr+daA9GDnDQW1574YsIlC3afKgrFaQ8w0FH4CK7YQeyX
         7MwQ==
X-Forwarded-Encrypted: i=1; AFNElJ9vIARvbBRy8T65fJ3iQf3MAbYv3HdMCYaZcrzxMFm03jePhl6XTVBsZXqANV5sF4bxHiskUcMEqLM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOHjWAqDwmVV9ygugRHlkwiZV4Cpe0VBhLfozazl5ncR2F+wVk
	0CekRDSD0Aj9BCaBJt7n0n6p6Q4RXmTW3Ylu6L6SpJ/C7SLFSmLdtvYS
X-Gm-Gg: AeBDiet5dINn+kOy13tcZgDzdMzyigGOdCKOeu74SHfobea0Pm4VtShO387C95dNKX3
	rpvBdTYUbh4jDaWPo+pbnkeVgq4U0GTvqT1FKNR0y9RRaQtbnXDdykmD87B1LwS1VUo0hK6zyaN
	3ZtZBUF4iK17MYRBJ5PwsxP8L0sOrlEz8AMBQM4Che7x41vXdUdpgQWzT434BOg0lfuzQkFQcAI
	uax/PyF7y9qjBnT3A5GpO1Fnz5AqjsKPtVl1SiVMck71RgBaYSbda4NL4wauAZxD/wG242FgHGJ
	iBcWR4V9VuJvXWusWhlN9o3he6SLOeoqlpNy80MLZHc94F0bdWc/b69Hqxtl2HV2cFlSqgOGD7C
	yFI+WnEgx33X4uAF+KgiFx5AfmeN3LpL8fkx2elS2dgxUWuOlbSlmqb3GZ2qPBxe4w6itlmTzZj
	QDt/xHnQnboz/P18DmuXt92HvDLWEgdv7mMUl8w+eJOTyNLzCp9gQpLjM=
X-Received: by 2002:a05:6a00:b80c:b0:82f:111:7e60 with SMTP id d2e1a72fcca58-82f0c323e1bmr25358052b3a.37.1776308810616;
        Wed, 15 Apr 2026 20:06:50 -0700 (PDT)
Received: from localhost.localdomain ([240e:694:e20:401::4])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-82f67418a47sm3490993b3a.48.2026.04.15.20.06.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Apr 2026 20:06:50 -0700 (PDT)
From: Fengnan Chang <fengnanchang@gmail.com>
X-Google-Original-From: Fengnan Chang <changfengnan@bytedance.com>
To: brauner@kernel.org,
	djwong@kernel.org,
	hch@infradead.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Cc: lidiangang@bytedance.com,
	Fengnan Chang <changfengnan@bytedance.com>
Subject: [PATCH] iomap: avoid memset iomap when iter is done
Date: Thu, 16 Apr 2026 11:06:42 +0800
Message-Id: <20260416030642.26744-1-changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When iomap_iter() finishes its iteration (returns <= 0), it is no longer
necessary to memset the entire iomap and srcmap structures.

In high-IOPS scenarios (like 4k randread NVMe polling with io_uring),
where the majority of I/Os complete in a single extent map, this wasted
memory write bandwidth, as the caller will just discard the iterator.

Use this command to test:
taskset -c 30 ./t/io_uring -p1 -d512 -b4096 -s32 -c32 -F1 -B1 -R1 -X1
-n1 -P1 /mnt/testfile
IOPS improve about 5% on ext4 and XFS.

However, we MUST still call iomap_iter_reset_iomap() to release the
folio_batch if IOMAP_F_FOLIO_BATCH is set, otherwise we leak page
references. Therefore, split the cleanup logic: always release the
folio_batch, but skip the memset() when ret <= 0.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
---
 fs/iomap/iter.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index c04796f6e57f..91eb5e6165ff 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -15,8 +15,6 @@ static inline void iomap_iter_reset_iomap(struct iomap_iter *iter)
 	}
 
 	iter->status = 0;
-	memset(&iter->iomap, 0, sizeof(iter->iomap));
-	memset(&iter->srcmap, 0, sizeof(iter->srcmap));
 }
 
 /* Advance the current iterator position and decrement the remaining length */
@@ -106,6 +104,9 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 	if (ret <= 0)
 		return ret;
 
+	memset(&iter->iomap, 0, sizeof(iter->iomap));
+	memset(&iter->srcmap, 0, sizeof(iter->srcmap));
+
 begin:
 	ret = ops->iomap_begin(iter->inode, iter->pos, iter->len, iter->flags,
 			       &iter->iomap, &iter->srcmap);
-- 
2.39.5 (Apple Git-154)

