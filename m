Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AA84A0C
	for <linux-xfs@vger.kernel.org>; Fri, 27 Jun 2025 05:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751002496; cv=none; b=a8nslahK7wi4QvwcmbN/R9LcCPoMr4bNBUtFAe/Ym7+v3MiawD604GadpdA9HBtYJUG4kCMPvYR9CtbXY5lQMGf8rX8grjss+RFyAXo8ZukOWi6dnzWwxYhsVtOd63j63vRfIiq5N+dLaL6+F7SDAjlcM/OvhFUzgo5SU00g0MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751002496; c=relaxed/simple;
	bh=gRMvd6yyd2T+iGylj2sKhhUXMBLmLgTjGCZzVuzoA9E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=r4zylmGKS/uWniqEWqY5+pJO93UWFwvNLBCkFiO2tRMmzieoadjhR8dNUXjCE+cJFPeHrba84Ftw2bQtsR/5t9pmdQ5dYvjbEQ7he/Wgvzew2+UDIrpkTNmXstVzkR2gc9NwbifntC4nc0hqsDwsj6fM94vflckez6Xe/RkPG6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Wz4mlBfN; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Wz4mlBfN"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751002482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=R+XanjQCXGfmpNHqAkipJpPWqbw+txEndPBxVTTVf9Q=;
	b=Wz4mlBfNkzZHxRl4mDzlmhBoWxIgQAahFtv8GuiQNOVhV/PjkVPqgZK1LMf7gcu6skoodI
	CWD1LF/4cJB48yeVNQX6bHLaN9SMZTZsumin2neCuhoHs4tF+n6Scl+gNAZrRonOR5xgxS
	t6cvTl+94zwRxL6wzlR3zseVHoN/lq0=
From: Youling Tang <youling.tang@linux.dev>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	youling.tang@linux.dev,
	Youling Tang <tangyouling@kylinos.cn>
Subject: [PATCH] xfs: add FALLOC_FL_ALLOCATE_RANGE to supported flags mask
Date: Fri, 27 Jun 2025 13:33:44 +0800
Message-Id: <20250627053344.245197-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Youling Tang <tangyouling@kylinos.cn>

Add FALLOC_FL_ALLOCATE_RANGE to the set of supported fallocate flags in
XFS_FALLOC_FL_SUPPORTED. This change improves code clarity and maintains
by explicitly showing this flag in the supported flags mask.

Note that since FALLOC_FL_ALLOCATE_RANGE is defined as 0x00, this addition
has no functional modifications.

Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
---
 fs/xfs/xfs_file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 48254a72071b..d7f6b078d413 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1335,7 +1335,8 @@ xfs_falloc_allocate_range(
 }
 
 #define	XFS_FALLOC_FL_SUPPORTED						\
-		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
+		(FALLOC_FL_KEEP_SIZE |					\
+		 FALLOC_FL_ALLOCATE_RANGE | FALLOC_FL_PUNCH_HOLE |	\
 		 FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |	\
 		 FALLOC_FL_INSERT_RANGE | FALLOC_FL_UNSHARE_RANGE)
 
-- 
2.34.1

