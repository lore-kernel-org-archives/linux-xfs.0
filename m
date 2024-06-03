Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C9C482D8
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 08:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717401751; cv=none; b=YBuM1kQCm7ZfEvc/vW5lu8JTxfT9tCgX5XnRybiL+W79MHKwKupj8g9ObdrVlqZ6kEXsRf71Jv5XPs+HIcgVlDeLSRXJS4JexJ443XpWL+x7vXDO6/Zol3wnfO5IM3YAJo6hoqLchheE1lCtX5dZtgTW/293lLLqjMv+fORSdQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717401751; c=relaxed/simple;
	bh=+XozhzG1+nj2GVfs5bFyd3hPBSoQvH46y8RI2MDmPng=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=q99TsTd6gsar9rTzjlvt8YCEnFvhaQkhVdnfHGwF3LxEmyFUa2d8vipLqd0c8A5c1SgENiXOgVhKfCzGmzXc0uK/1sLSR/G21+vC4PBkgn3eTb/54jnpwV43SRU6tHu1C/8AkrbRwmLIRMbSmpIIRuxfFQgawuGFdrFz0R9eHG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dZY0m2r3; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dZY0m2r3"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7ea7d9b1d69so126620039f.1
        for <linux-xfs@vger.kernel.org>; Mon, 03 Jun 2024 01:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717401749; x=1718006549; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/xEWiTgCnbXnrNN8C5qV2U8YeqYeOwSv2GOlmlrAiKg=;
        b=dZY0m2r3pICR52ODUKIA6c1fj0R2W4JpjruDZ+KMf9OLNDaBIBY8H6uFlnNYAn571s
         YPJ+FFGuV86zxW6xXtpnskjEWv/fPXhOhMSTzUirAtHJjiAOyQbXCpeQQQC0YOr54pvJ
         vxEFys5xhbEBe7TPAYpM8xKoDRiafsQBjt6WLEhdPtNkEIDxUidHtTXehSdFLeFvqCEM
         SGKghZPdu9by234q8U2NOHaysy9wf1GTQOzx1+Laiebh3lVWqF8iybXMyKXd8NDxcAeu
         cL8Y3w4R0sRZji8vw9/dvLVr2Vkg3CpnZDej1Wvzsoy/vsGh142xikx2RaQnuzN8Oxar
         iBoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717401749; x=1718006549;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/xEWiTgCnbXnrNN8C5qV2U8YeqYeOwSv2GOlmlrAiKg=;
        b=vNOrfZIN0jgAtZgb4h7Q9OYDiyx5w7WV+rrn47ciQEDizDOLGhymS7eodxemkFrgh1
         Qjs5lcq6qwbbll02Ih6F/YTdG2FZG+bdTPVHZufoCSknuwXNduBYoifSDv9OOCN8BpLQ
         /NQ8aqepaM7bRA0sGUsh8BcsBNMzyTNF6a5znAK0yehK/lVB7Qel8/5YZW+SkPxJ9V1J
         QJ0UjiQBsmfz5Dd3S4WTw5PfS225PEFtsjxNQXj7PDhfDRBCPAVVZtCikCtMUEQtXTf7
         MagTbx+ACB+c1wXgf4K/7Qu26T3t4nValDmgFxfA9ueAEvLETqKzoY8RKoQfeTLxs5Dp
         2dFw==
X-Gm-Message-State: AOJu0Yw0yxjyTbJzju521BEW9dchfPUgRjmy4ojYGPNXnVwd/5T4CiZg
	ETK4MD9/sbcrJhsOR/rhLYHhonZWsYSRcM1fyzMGOmRiIwHZFHeRd5GucImTBqk=
X-Google-Smtp-Source: AGHT+IHCWwHOPLiQCOCi1EQ6KVhVyDQv5FHdoJSGnKhhIJVDyPcT0iIM4oV4IVSV2btNwIyR5Hkpgg==
X-Received: by 2002:a05:6602:2c95:b0:7de:cb15:1b17 with SMTP id ca18e2360f4ac-7eaffed1911mr1044074339f.9.1717401748770;
        Mon, 03 Jun 2024 01:02:28 -0700 (PDT)
Received: from localhost.localdomain ([47.238.252.167])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70242b09133sm5140154b3a.178.2024.06.03.01.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jun 2024 01:02:28 -0700 (PDT)
From: lei lu <llfamsec@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: lei lu <llfamsec@gmail.com>
Subject: [PATCH v2] xfs: don't walk off the end of a directory data block
Date: Mon,  3 Jun 2024 16:01:46 +0800
Message-Id: <20240603080146.81563-1-llfamsec@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds sanity checks for xfs_dir2_data_unused and xfs_dir2_data_entry
to make sure don'y stray beyond valid memory region. Before patching, the
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
---
 fs/xfs/libxfs/xfs_dir2_data.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index dbcf58979a59..dd6d43cdf0c5 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -178,6 +178,11 @@ __xfs_dir3_data_check(
 		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
 		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
 
+		if (offset > end - xfs_dir2_data_entsize(mp, 1))
+			if (end - offset != XFS_DIR2_DATA_ALIGN ||
+			    be16_to_cpu(dup->freetag) != XFS_DIR2_DATA_FREE_TAG)
+				return __this_address;
+
 		/*
 		 * If it's unused, look for the space in the bestfree table.
 		 * If we find it, account for that, else make sure it
@@ -188,6 +193,8 @@ __xfs_dir3_data_check(
 
 			if (lastfree != 0)
 				return __this_address;
+			if (be16_to_cpu(dup->length) % XFS_DIR2_DATA_ALIGN != 0)
+				return __this_address;
 			if (offset + be16_to_cpu(dup->length) > end)
 				return __this_address;
 			if (be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) !=
-- 
2.34.1

