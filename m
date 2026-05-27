Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603273F58FE
	for <linux-xfs@vger.kernel.org>; Wed, 27 May 2026 12:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779885187; cv=none; b=YAhLxAB5X4jC5ZV4FVV1GV1C1WA0+wqLx8S8bLGlh81QCLqWTs+Mw9Box0kSGvK56llx+O0kFPSwEIdJP7PvhVulPaLOHf7UtxlMHCUGEdcKTrflx3VY4173MICe+m57hNYI0gogstGoveSLyPQgL1OZDMLi6j3jseB8svfmfVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779885187; c=relaxed/simple;
	bh=2iH9PUNqjxl76+jcExJ/2A5zsgOZGGTp3ZKgC091QPs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=INh0yPk9LuP107EZ6MH0Jxvz4bGJM5C7akv6dMU9TdVlchgVzof4isgfwZk/Ra66fnK4k2UMgKsbY1eMUZFM15aXNwP8H7oAyDRIurRsn1yIhzEglhc1XV0fmtVAA3sYZhJcGhEUXXkZZBqDZ30gpdjw5HcvoWdXqGSS81hmMno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hKvmhsqf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hKvmhsqf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=olcx0etDo2UgJplfjbkeZnVDcn6IqsojmK76+43yjVc=; b=hKvmhsqfJeBxViwPU3J8vrthxm
	uFJTEuO/VVar2b3gxvEKylZb7qY8neunSvkE8VXjw8zxmNv0k4GagjuEAaBHWJJ6hsaKDppqjYJXn
	wgJOJTBnd5pbX3YFP3vbN1vvY9soG4TcrtBKIzqvJMideuI8vwzI6zNAxw7AWq3oSlHAmhOvOxR8O
	zQxI9Sul2y9bljfB+QayXWI3wc2PlY+RXzseh7pgvapNMBJxIEVo9ks3xnRY6ZB3IPKx4srxXz9vD
	Gq+hzyIfeKcx7qsCb88MvIIQMpaS7QQN1Jade2u2mDot2IxbOtdqIYddtr7afRwsftndDPQuuS5mB
	vFYrvsrQ==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSDRI-000000045zG-1MYW;
	Wed, 27 May 2026 12:32:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: abort mount if xfs_fs_reserve_ag_blocks fails
Date: Wed, 27 May 2026 14:32:37 +0200
Message-ID: <20260527123243.2316101-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_mountfs currently ignores all errors from xfs_fs_reserve_ag_blocks,
which can lead to the mount path continuing on corruption errors.
Fix the check to only ignore -ENOSPC as in other callers, and unwind for
all other errors.

Fixes: 81ed94751b15 ("xfs: fix log intent recovery ENOSPC shutdowns when inactivating inodes")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_mount.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index b24195f570cd..7aa51826b1ca 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1149,9 +1149,12 @@ xfs_mountfs(
 	 * blocks.
 	 */
 	error = xfs_fs_reserve_ag_blocks(mp);
-	if (error && error == -ENOSPC)
+	if (error) {
+		if (error != -ENOSPC)
+			goto out_rtunmount;
 		xfs_warn(mp,
-	"ENOSPC reserving per-AG metadata pool, log recovery may fail.");
+"ENOSPC reserving per-AG metadata pool, log recovery may fail.");
+	}
 	error = xfs_log_mount_finish(mp);
 	xfs_fs_unreserve_ag_blocks(mp);
 	if (error) {
-- 
2.53.0

