Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D80227FD62
	for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 11:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768823240; cv=none; b=tLHUduxh+pDcrvEHTj8VhGjylip8L1hjxFFKPoFDNBafQjNJo4CzEr7Of4Hhmh4W5VOxJdj+V+k2xF7OkTBj0uZTXWh3aouwbVhgRaxAvxh3TIU4573SxblMaZ+Ppx3qNN0cDy7Hn6kg0A0em5hIGRXFx7lazEQMGhjMRA3/814=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768823240; c=relaxed/simple;
	bh=eqg7KbREGq7jAca1PpCMrESZIotLgoSb3xuY4Q8fXWU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jE560OS/KMJW4EWUwjoNypK97FcCmmN2u8qZxCQ2NQtMgOTQMzUaT6Lp6iCQ/NPnlhKDjLYb9qoeDO6BqvwHImQMW+abigOQ0bYh0gmS1w9fIL+lZ4XoYLUp1/6kDh8mIPSdSw8Iy6crazxQywN5L7A7wxMCibEIL2qA/oD53fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V/DvgD0J; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V/DvgD0J"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a0d0788adaso27063095ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 03:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768823238; x=1769428038; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sDDv7OL59gi3gbiLq9ntFV/7uA1PHLr9GEPlCGYXxn4=;
        b=V/DvgD0J8GIcBc5+7pgvgxkOc7IG97K/Z58C1KqobV0+v7CkmhrXx3IJXWxUwVIou/
         0F1ZjMFDbI3NEwfc0EoCP6oKog5gil8AGTRbHyFrwuBy0ccZ36s+V0PtwJEY4IC19Zra
         SmpnbWufgEPbCK8eQd2OdxCOoC5GLg3d96+Xq8nP/z6bcR8oaenKY2FKZ+FbUFXODdp/
         0V8e7H52Wp0+Jv54/US6pkmQUpBnS9jOWMpKz1XebZhEuBdEzezSEGHzYq2E6ZEVqmvb
         7nEYmhdq+jrFntDQxM6VFloz2eiI4nZVbk7vwLmDsHWRidRN7XzkQX3VuJU6M1Ok4b8l
         aZdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768823238; x=1769428038;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sDDv7OL59gi3gbiLq9ntFV/7uA1PHLr9GEPlCGYXxn4=;
        b=sH6hV+x5i4REHnW/N6RPTez2cUvrb3KimE+bcCXh5eXb+o/UIZEDlQum9zP/6JGPXV
         RxHag9wnPyzkE3CD6Bhg29R9aGZKIieXKL8US523MpenXELpbAgMzCbCAK87s2BaJrcg
         8r5HbHM1s1NSByXJGSbvUfjOcANybs4yQBDwz6cj77V6Ob29ArShph7JMn6gEW1T4uJi
         gEGZDa+w2rPv3uAMQYq3iPyCo+ZM9BKzP3C8caWJfE40LLqNkayq236dIAUCw4B+ukrA
         levtwmqGKNV3OKQVG3KgOx3gShmmYTfZii++G6JO5YEQUS1HFakAy+wx40Bs3paZrEvD
         bd/w==
X-Gm-Message-State: AOJu0Yy9U2qdE/qy19dOIdjcci2XxsdXeREaB1ytXEDdR5aPfvxxS2LT
	DchayzGuaKXvWknnyrJC5JraYO0oFPw/5gOG+AFIC6B4eDva2IsNVYj9a50QHw==
X-Gm-Gg: AZuq6aJOgOsSn0DLs1kv2zaRNuBPlO0e7IKG2KqYdOIl7mtKUEwqD5R2I4/EyGtNPf+
	1G1FqMV9DGJT11z+/GvJs9aCjc5TJE92s/fhFFQNClDggK4tiMlrc7xBCTIBKRErec9ogAAe7nP
	+rANZiPsJf9u6LYGaquwuVYHtSYvzRpqO8ekIcdjUEfkV7Ve0bHrgDg/k9olGU0FKIktH2CU8LE
	LzRXFpvIdsW/vbcV9KDtKRiJ5lVdYRJOQQmZVfmAZ/o08pHIzh4b5pOcAcfVhus+MAvGW3EeB+6
	7FlKNMhJciVcitRFx+6Vb2dJ7Wcrp/xgfyxOcEX8kZsyxuWPP129kwXx5faRsIjeoRTQafGLxAP
	Wm1CObpB345Ca0XmkTklH+D0/vcwHgjQ5NLCG7dAIKg2EUhHl3duaINhoXDoZJw8s0q4rgGk0Qv
	onlPkJo8I7NEiLWuhgKUZHeEXWndJZUfYbwCWRI7J5pFVod3RqyNzRmyE09FB5CeLH5rtzq6eYU
	Qk=
X-Received: by 2002:a17:903:244d:b0:2a0:8f6f:1a12 with SMTP id d9443c01a7336-2a717543531mr109883385ad.17.1768823238020;
        Mon, 19 Jan 2026 03:47:18 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.204.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a71941c200sm88662755ad.95.2026.01.19.03.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 03:47:17 -0800 (PST)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	djwong@kernel.org,
	hch@infradead.org,
	nirjhar.roy.lists@gmail.com
Subject: [PATCH v1] xfs: Fix calculation of m_rtx_per_rbmblock
Date: Mon, 19 Jan 2026 17:16:40 +0530
Message-ID: <2e0f36968b112303466c5e07a88c7e9949f769fe.1768822986.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

m_rtx_per_rbmblock of struct xfs_mount should use the function
xfs_rtbitmap_rtx_per_rbmblock() to calculate the number of rt
extents tracked per bitmap file block instead of always
calculating it as mp->m_blockwsize << XFS_NBWORDLOG.
When metadir/rtgroups is enabled, the number of tracked extents
per bitmap file block is slightly less than sizeof(fsblock) in
bits, since some bytes are reserved by struct xfs_rtbuf_blkinfo.

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 fs/xfs/libxfs/xfs_sb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 94c272a2ae26..b2b4d7f21a5d 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1268,7 +1268,7 @@ xfs_sb_mount_common(
 	mp->m_agno_log = xfs_highbit32(sbp->sb_agcount - 1) + 1;
 	mp->m_blockmask = sbp->sb_blocksize - 1;
 	mp->m_blockwsize = xfs_rtbmblock_size(sbp) >> XFS_WORDLOG;
-	mp->m_rtx_per_rbmblock = mp->m_blockwsize << XFS_NBWORDLOG;
+	mp->m_rtx_per_rbmblock = xfs_rtbitmap_rtx_per_rbmblock(mp);
 
 	ags->blocks = mp->m_sb.sb_agblocks;
 	ags->blklog = mp->m_sb.sb_agblklog;
-- 
2.43.5

