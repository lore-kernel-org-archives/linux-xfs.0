Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A23A10A3E
	for <linux-xfs@vger.kernel.org>; Mon, 30 Jun 2025 01:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751245991; cv=none; b=LiAI+xc2KZYnCG6MwA0RCxDAYqgUWIyjJTheHH3lr+ijB5RR4V9YURh7MPjUl4va/z2mT9A9sg9OTC/mfjHuf9H5waYAsEjkvlOneL6YA/ycZbjCfVw66vecCjZx3YaRBam84axF72PodYIAFa/OskL8uTrd1TEzm45AE8cIYO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751245991; c=relaxed/simple;
	bh=JyY6x3WO4O3rSyD/50PCDFcxJh6dR4x2/UGZdiqYXI4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pRFNVB8HgRvZbr+zN6dd59ofEIKHl6JTnpHgIWuEVkS9lxon0Kq+TD0EqmJKVmYjFSQupWSHnO8YXrCEHwg2RkfeAL8CMqXVpZsDaAI+Y9M766rwxdF5agNJoo9/E6z7fPVVXv5RvHe3BbV2eWt6gAaB+KNdmf4srlWe6Uxr+Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=G/HT7h5k; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="G/HT7h5k"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751245977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=u7uGCW/EzKj4i/CdQK+s8UE/LRLBYUvZIt9q7yiB3JU=;
	b=G/HT7h5kjbwJ8MDlOFudWTtgwpE1n1u9xWZfphoWVM1gpnh7VBF9E8sigMbG+TVT58c+pN
	osVpDcEWs4kjO0pIPUvvfavkygTKeKMYJflf8O9N3QJ1D/6XxR8Rh2Eyce3lNLXXpw6seo
	N700UNt0U98e6+cEog8rQUz7meZLQc8=
From: Youling Tang <youling.tang@linux.dev>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	youling.tang@linux.dev,
	Youling Tang <tangyouling@kylinos.cn>,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH v2] xfs: add FALLOC_FL_ALLOCATE_RANGE to supported flags mask
Date: Mon, 30 Jun 2025 09:11:48 +0800
Message-Id: <20250630011148.6357-1-youling.tang@linux.dev>
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

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
---
 fs/xfs/xfs_file.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 48254a72071b..0b41b18debf3 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1335,9 +1335,10 @@ xfs_falloc_allocate_range(
 }
 
 #define	XFS_FALLOC_FL_SUPPORTED						\
-		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
-		 FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |	\
-		 FALLOC_FL_INSERT_RANGE | FALLOC_FL_UNSHARE_RANGE)
+		(FALLOC_FL_ALLOCATE_RANGE | FALLOC_FL_KEEP_SIZE |	\
+		 FALLOC_FL_PUNCH_HOLE |	FALLOC_FL_COLLAPSE_RANGE |	\
+		 FALLOC_FL_ZERO_RANGE |	FALLOC_FL_INSERT_RANGE |	\
+		 FALLOC_FL_UNSHARE_RANGE)
 
 STATIC long
 __xfs_file_fallocate(
-- 
2.34.1

