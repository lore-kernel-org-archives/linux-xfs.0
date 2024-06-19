Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5CD824BB
	for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2024 11:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718798077; cv=none; b=HI4TEzJZf4waoeXhuykgTy/pyAj41ezNlxztai5qgByx9eQ1pGaiDOIAVv7rhTmc1lE7NR9OJj7NGCNGvQzyE3+e4hwOV+rxPACuDfDVwkTneFTopTYkqTJ2JZzM5MR5oiFmvT2tRonL/t4joDcP8CJmvQ4TQ9M7mvP2axcaD8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718798077; c=relaxed/simple;
	bh=jPjG01ghYZdxqCrg2F/0tumct+naG0lC2sFeniAFdbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdWYu0/iLSJnhbTOBJr4L19qeulhGnqXubbZsda7qVj7fzeDWR6/arZrkjQpfmePGk46IUxuAPuwqc3md+zyzhh8HQvJIPDk/siC/t/F/BG+2z5VIWdvtaqOZy7+MeeQ+SLaOQI2Auv3zDmraJ0zbQ5J8GzhBIr9pwLILGrIEI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UVq99BCp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UVq99BCp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dzbJPBFeMrFU7Sh/Q2vx8nZdNm1RMn3h3JYJuqf7Tu4=; b=UVq99BCpDOJ1/5097r00IBEBkv
	a10hg5OPjPhd77zFDXQDwemXCL1kQGxwqzb4nhzwaOR+lqsPrEqfhZdaorkgljSdC+/pzzmxWgeYG
	RX0jtkOS0nJ9qKiKXxmlwDH3FEOGDUm/i9WXVMuGw+ytHknVVTI6/o2PRFhvn8/6g8ervDnIab7yr
	W9NsMqxVwGntHbqhuAOD2DjDMnHVewzfBpvbZDj35AfHNc5Y6xuMZJ/6pYYRtlZJW4qck1QaEnc9g
	RMkwzdDzGR+FQJgkz4SLu7Hi/OLxT5EHNo2krjhbhqmWYmxgwjv/v/aDH4RUNmSCk/Ktsmm6/ZsOY
	cLOckKXA==;
Received: from 2a02-8389-2341-5b80-3836-7e72-cede-2f46.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3836:7e72:cede:2f46] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJtta-000000014OI-1Sqs;
	Wed, 19 Jun 2024 11:54:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/6] xfs: cleanup xfs_ilock_iocb_for_write
Date: Wed, 19 Jun 2024 13:53:52 +0200
Message-ID: <20240619115426.332708-3-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240619115426.332708-1-hch@lst.de>
References: <20240619115426.332708-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Move the relock path out of the straight line and add a comment
explaining why it exists.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index b240ea5241dc9d..74c2c8d253e69b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -213,14 +213,18 @@ xfs_ilock_iocb_for_write(
 	if (ret)
 		return ret;
 
-	if (*lock_mode == XFS_IOLOCK_EXCL)
-		return 0;
-	if (!xfs_iflags_test(ip, XFS_IREMAPPING))
-		return 0;
+	/*
+	 * If a reflink remap is in progress we always need to take the iolock
+	 * exclusively to wait for it to finish.
+	 */
+	if (*lock_mode == XFS_IOLOCK_SHARED &&
+	    xfs_iflags_test(ip, XFS_IREMAPPING)) {
+		xfs_iunlock(ip, *lock_mode);
+		*lock_mode = XFS_IOLOCK_EXCL;
+		return xfs_ilock_iocb(iocb, *lock_mode);
+	}
 
-	xfs_iunlock(ip, *lock_mode);
-	*lock_mode = XFS_IOLOCK_EXCL;
-	return xfs_ilock_iocb(iocb, *lock_mode);
+	return 0;
 }
 
 static unsigned int
-- 
2.43.0

