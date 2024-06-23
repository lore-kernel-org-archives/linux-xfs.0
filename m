Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B5F17C77
	for <linux-xfs@vger.kernel.org>; Sun, 23 Jun 2024 05:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719120944; cv=none; b=AvHbLqf0SEzpGerVbzvmpnkKzSEDcXTopJh/kwUvFPgUpJPZqF1cxvDXzhB5zB0sTuZpJEl/wODTJl5spQHa04JKC6XZPizFBBM4gr+vA0uiTa7GQIHrFsVntpKJUaEOZzYfzjw6sNqn/IqyuDIDWOubLZw58LFZ2raFRS2C3zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719120944; c=relaxed/simple;
	bh=7ImR1cJrLGuYRIdiUrc57pJNv7JRdI8kFzjEElUY9bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=guVfSRWRnrGfyBKQ/Q9RaPyoc9/AxcaZakhuVA70GEMGjvWkDePFiPgcg6pmg9uYH/AtEvsMX3tY0ZQKiFCRHmcwFk4nA0Ye8RCZOM5aoWTvaqocmZamNaX476BeN5CUJrZeIRf42cZkCJafUbBcjKHqjqzCSqsRtwW7/abOrX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2oz9l0mq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2oz9l0mq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=g30x6+i89UtGLI9kG86blJP0PV9XoyqjE8wfLs+XJxQ=; b=2oz9l0mq33YmZXKGKCpCmkpgid
	YVH0pr4D0wIQb5vutI70n85nWDYb+MPfPxOMPiY4SyWY5Vt+LqTiTsxObCMS4JJtQCX9A7rzRRj93
	mgJ//uIJf+5dkZFgyAo+IFBInEwn4HOGiTkbsJvS8L44LCG0O6JL3k7o4Bu+RF7InziG5ta0Tyz2o
	/aqmhQvCRoA2EMqsS2Ez830Lt25RhzhzO0+L9xYZuSFxQSzV8IqiO0Jv+8xpS0M8jUENG3v5GC/a5
	WCknS7dqg8fWxDIge9QPbOi9K6erRIWA5cOGsEW+8yyBJ/9rXkhiDXhc417qUwXws/4SWn/axttDZ
	odBeKvOQ==;
Received: from 2a02-8389-2341-5b80-9456-578d-194f-dacd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9456:578d:194f:dacd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sLFt8-0000000DOEU-1CSg;
	Sun, 23 Jun 2024 05:35:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 02/10] xfs: remove the i_mode check in xfs_release
Date: Sun, 23 Jun 2024 07:34:47 +0200
Message-ID: <20240623053532.857496-3-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240623053532.857496-1-hch@lst.de>
References: <20240623053532.857496-1-hch@lst.de>
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
---
 fs/xfs/xfs_inode.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 38f946e3be2da3..9a9340aebe9d8a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1552,9 +1552,6 @@ xfs_release(
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

