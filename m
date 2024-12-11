Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1B61EC4E3;
	Wed, 11 Dec 2024 12:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733918591; cv=none; b=uMSMTBHBwKGJp6QxjPXsAOPVrEMf0A3+sgxT3dRLPqNGh6+9oq158G8enbbHmvUPW5yQC5azLtS2xKTNYMvb0NhsBlx2tafoZ021cAwyR2VmOVvfBa5eIRGeUh/2kumH7nTrKKbb2csc3hvBUASWmR6dbAh5qlLNhhOJKggo35A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733918591; c=relaxed/simple;
	bh=U/FA17bRARhz/OH9vDb0zhfRRZAWzAU9QR5iGTQ83s0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XqZW7y36/JQI2VsydLQ/dnlk/ncivBwJNJGZtSDZqvOFCfDTv2VryTdnh39Rk8U7h7fxRJHcD0XsZPeNoRoSnpejL6weQ0cQSQYeFQs74FRZA3dvFqB33vUu83c35hv+4W++I+kTYSJ3i1wcXkaOUUo6EhbFjyYV4k81iOPTBjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dJypURUV; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dJypURUV"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-216401de828so27849135ad.3;
        Wed, 11 Dec 2024 04:03:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733918590; x=1734523390; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+80OGSZHS3zxkO7V3dRKVOrQn9UKerL0YbqvYsgrGwU=;
        b=dJypURUVZUw84ANd6oIIlUezrR/0bZMavEFHt26uqXTxrPpjgnmkmiMljhiVNirKRG
         tzQM8/zeDfXREX5uwYWkOpcWlzsq+amfgogOVShY9vCh9s+oRaRXoi69gAGJskFkayj1
         VoUgo7NyCfbyfEAm0z+F0y6QC8Wae1Zm2S3VzfhPs5I4A8Gnw/Uci2i4wz5GrqUxEE8H
         u0KxoKX1/yOcDWuwdqB3MDQyOu7Dmk/QUffGJf3xapR7QDreEMv9OJ3U+r+dR7CVFpV6
         Hz8nZXyr8XKHG73nJk5499FAq0nZMDfoA5PkN5n3P3YaGzXxYd/z2IrSYxHFWT1i4Ule
         y3kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733918590; x=1734523390;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+80OGSZHS3zxkO7V3dRKVOrQn9UKerL0YbqvYsgrGwU=;
        b=tLbBZXGzppbNyytFzTZzo8zy8GOrjrxXAie/PGGYAjk/NIyg7PrChFpMR7NJu5z7Ra
         Yr2FIJ9LQj+7339C/cfdfqyaG1C/INuL9jwaA4ml1LGVlezlJrBfqlSi7La5n2sId7Dy
         aJLVhPAEJ0B5Q66eiVUpgsypDnzbnAxlXJYKn1fzxpQPsAiB5zg2OMFquJfc4JIOw29K
         TgcmnxrrPu+bHJin9woJewbgpf/vkFzn7Fqbr3ZlvLZFMFPqJWUH3NQ/oTJcFDYtVLvD
         rfhFY4dDLTYzIUIiJeXkFJlzNscPfIeS9FjNnO98djMymD5QBQVdFSyAlhm2nAahMYZ+
         SL/g==
X-Forwarded-Encrypted: i=1; AJvYcCW2Zev+WOXMgBdEJw/VQWvr3fLkqrvtdkYZHhWhSarGAgcK9p+8k2D8o9J2todeEkhvcl5fCppMfJDc@vger.kernel.org, AJvYcCXO9scwew3qBIsJUbp29kLECVj5kgnZRipUXSGkb0cZweVKmj2YqqSoezdS4+R2d2nyrOJB109Tex/Nfeo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7ogCwaNiMWjMG9BXlIPUjQVhKfmZ+NdJAv6T4k1DY4doaQKl1
	qWgJ7YaKD51GRSEFqzO1n7DZh28BMet28O5kVggeKsINAQX5hL2cOTdJMw==
X-Gm-Gg: ASbGncsaq2NhqbTDTEXDcbfrYqRwLNgB0a+0IKKnci54TMgVkcGLeFRE+9UmvEesm5n
	s/Yv43NztKHCECoIF3SVBNam1da6Rbx7vk/P0BcBuO0cVAjLnYoy3NST7y0LT4/306Si2dKRMVX
	3YOoEHO3lPDq3UugIK+OVOyQhf6pA+1fmjFC67Z90U4vDbBiNhUEjwFSn2QXa9y5AAaqnWahtux
	duzGIqbfZTQZPbS/b9mb3ZeOTPaME3zatI0Zx1x0M4cwm9op/CH0nbVZwfzr79ocC9Jfg==
X-Google-Smtp-Source: AGHT+IEdLkpKBOvRX2kHF0FNDcluqyXnJ3fTjrYfoCfbvfFbotXiPXlANf1ywQumS/ppqpMhN9Bwzw==
X-Received: by 2002:a17:902:dacc:b0:216:46f4:7e5a with SMTP id d9443c01a7336-2177854a024mr38150645ad.45.1733918589432;
        Wed, 11 Dec 2024 04:03:09 -0800 (PST)
Received: from localhost.localdomain ([119.28.17.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-215f8f0cf61sm105149725ad.188.2024.12.11.04.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2024 04:03:08 -0800 (PST)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: dchinner@redhat.com,
	cem@kernel.org
Cc: djwong@kernel.org,
	chandanbabu@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jinliang Zheng <alexjlzheng@tencent.com>,
	Dave Chinner <david@fromorbit.com>
Subject: [PATCH v3] xfs: fix the entry condition of exact EOF block allocation optimization
Date: Wed, 11 Dec 2024 20:03:04 +0800
Message-ID: <20241211120304.3244443-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.41.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When we call create(), lseek() and write() sequentially, offset != 0
cannot be used as a judgment condition for whether the file already
has extents.

Furthermore, when xfs_bmap_adjacent() has not given a better blkno,
it is not necessary to use exact EOF block allocation.

Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
---
Changelog:
- V3: use ap->eof to mark whether to use the EXACT allocation algorithm
- V2: https://lore.kernel.org/linux-xfs/Z1I74KeyZRv2pBBT@dread.disaster.area/
- V1: https://lore.kernel.org/linux-xfs/ZyFJm7xg7Msd6eVr@dread.disaster.area/T/#t
---
 fs/xfs/libxfs/xfs_bmap.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 5255f93bae31..2b95279303d3 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3566,12 +3566,12 @@ xfs_bmap_btalloc_at_eof(
 	int			error;
 
 	/*
-	 * If there are already extents in the file, try an exact EOF block
-	 * allocation to extend the file as a contiguous extent. If that fails,
-	 * or it's the first allocation in a file, just try for a stripe aligned
-	 * allocation.
+	 * If there are already extents in the file, and xfs_bmap_adjacent() has
+	 * given a better blkno, try an exact EOF block allocation to extend the
+	 * file as a contiguous extent. If that fails, or it's the first
+	 * allocation in a file, just try for a stripe aligned allocation.
 	 */
-	if (ap->offset) {
+	if (ap->eof) {
 		xfs_extlen_t	nextminlen = 0;
 
 		/*
@@ -3739,7 +3739,8 @@ xfs_bmap_btalloc_best_length(
 	int			error;
 
 	ap->blkno = XFS_INO_TO_FSB(args->mp, ap->ip->i_ino);
-	xfs_bmap_adjacent(ap);
+	if (!xfs_bmap_adjacent(ap))
+		ap->eof = false;
 
 	/*
 	 * Search for an allocation group with a single extent large enough for
-- 
2.41.1

