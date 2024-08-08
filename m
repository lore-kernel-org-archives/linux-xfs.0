Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4224F18F2D6
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 15:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130909; cv=none; b=SWVWFZvrk0nnWdha6fhpbCfL8dTwdKktx0OAfFEDfXb4tBNKl3pOoHUMqC2KU6RJNPG4c7BXRrxHgTVzu91CL7TgY/POoDJu3D/LYbZKl7GrVga6+LGN/kAt82tTKeZtLp7v1qUkOBQ27uS7j7nAVYMk6148sb52bxDcqI35mZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130909; c=relaxed/simple;
	bh=1ffybEYeulSPO8MW/8FCE0+ONbLCqzpFEfbiRTvgEDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDGVhoGrv9YAfTVCLn1WH5BESVxG5LKBrkRcgr6AlKES4jruj1HTN39YigFBhI2vJUquGsuH9N1j2d+8nHzIWvhUTBu2FML7BoGVLQ9kFdyzx2N6HboiD7Xs+DQALqOSfWQ8DsDNIermIEmNRM6wURfd0rZKvVlMvowzNFnCHfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KZ/HoF5N; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KZ/HoF5N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=C2rqm8DhjKyNE7zY2hAiGy5FC8ZJZ94IpLrv2EErJZQ=; b=KZ/HoF5NJ2/lKaY9VP5raDexKd
	sGG7lw8gF6s9K74sTrhcqy3/kS+5zc+/OmcDu/bTHJ7G4fCDYuNXh/oT9tYBfSgR/KJEHKnQQMRm6
	FhVhlUrB20CQ8tV7trCxzlFUI4KCt69+pQGVq2pZoS/nNa675yRzSMB5Za0qAvdIuCqPSilFLHlKR
	YbBPmy1VMZ37mv9Lo+Pyx+aoZpy4GVk81kpYPU9rq/uKX1wcDhXHdOPg9Ugu6R2cYvqV9r4/QZPbP
	PX77YzmVtXY23TQEHWl4jBNzkVTqfBbSN67qiX+r1rW05xA7Kg4zuFbM8XiFm8aWxmSb8JxfeRZ2h
	3hmlLDjg==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sc53z-00000008kWF-3VMN;
	Thu, 08 Aug 2024 15:28:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/9] xfs: remove the i_mode check in xfs_release
Date: Thu,  8 Aug 2024 08:27:27 -0700
Message-ID: <20240808152826.3028421-2-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240808152826.3028421-1-hch@lst.de>
References: <20240808152826.3028421-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_release is only called from xfs_file_release, which is wired up as
the f_op->release handler for regular files only.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7dc6f326936cad..c7249257155881 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1086,9 +1086,6 @@ xfs_release(
 	xfs_mount_t	*mp = ip->i_mount;
 	int		error = 0;
 
-	if (!S_ISREG(VFS_I(ip)->i_mode) || (VFS_I(ip)->i_mode == 0))
-		return 0;
-
 	/* If this is a read-only mount, don't do this (would generate I/O) */
 	if (xfs_is_readonly(mp))
 		return 0;
-- 
2.43.0

