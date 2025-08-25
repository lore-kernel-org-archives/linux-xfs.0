Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D287C2E6108
	for <linux-xfs@vger.kernel.org>; Mon, 25 Aug 2025 11:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756120795; cv=none; b=S4Vk8qpxdyFZ7n92CWcV8zJ1QV8PXCnMnFIvGkUTC6JHCJi7dkG1zSb079z5DUr5oSd27QI6KCY6GWtITug1YZ94ZUK4wps57ZBRjvjjtKE7IH5DdzYSM2HiIirkk1YVWrseUxZ/AEH/ADiBoBGIZGivChnpKDmGD8wjJX42K30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756120795; c=relaxed/simple;
	bh=mXa1ae3S48kCHLt9IjEMEdZfxnWt2IKncmPYrkAnfL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q808JzM5AHdE37Wb66rrrvxQANyPUyl+wVn0ch+bno0Rnz9iWsWx50FOZZqbegmIHForxw/3oAVTnehy5qAQKnEw0lyZcMijKYsmHqBFPfoVgPk4R4r7yLVszh61TMvNTtom2E2O9M11HxJGJtKRpb6xGowrl69jXxi8NBQ9teg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QZUy6ThF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QZUy6ThF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JQP5BTsATzgxmeImquEtvNKiKchpssqkG9QPkfUp6bQ=; b=QZUy6ThFwYxbQRf+eXzVpfnVV1
	8W3Au7zdaiJBfVTYWqdBcs4eN0yzDzXeHmhUihOmHpNhRf8S+v/XaSLeDfE+zHcyqvdQ6wfMQWVUm
	i0h//MOZG/Mi9Z0rRGYuGLLoVkuovS9cqNo1p8x8dQiVHJ+/N9QCas9QIhYsgxvK3EtpZl8zUD+Fj
	8YAX1QBN9/8oGFsI9Vkl3kBjrFUTKzmdr3zSgvLtagz3J2Ibp5U/2ED04eXjh3zrB7tERiJSlO2X1
	+ioAA9VkIuLqDUdOGx9Sz2LdWhqZ+UvMZb4ypbO94ioFOjN1PLiiN7klmRLpt+8mU2K7zHka63ZuN
	EZWK+qsw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uqVEv-00000007ixT-0fvq;
	Mon, 25 Aug 2025 11:19:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 2/2] xfs: use bt_nr_blocks in xfs_dax_translate_range
Date: Mon, 25 Aug 2025 13:19:36 +0200
Message-ID: <20250825111944.460955-3-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250825111944.460955-1-hch@lst.de>
References: <20250825111944.460955-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Only ranges inside the file system can be translated, and the file system
can be smaller than the containing device.

Fixes: f4ed93037966 ("xfs: don't shut down the filesystem for media failures beyond end of log")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_notify_failure.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index fbeddcac4792..3726caa38375 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -165,7 +165,7 @@ xfs_dax_translate_range(
 	uint64_t		*bblen)
 {
 	u64			dev_start = btp->bt_dax_part_off;
-	u64			dev_len = bdev_nr_bytes(btp->bt_bdev);
+	u64			dev_len = BBTOB(btp->bt_nr_blocks);
 	u64			dev_end = dev_start + dev_len - 1;
 
 	/* Notify failure on the whole device. */
-- 
2.47.2

