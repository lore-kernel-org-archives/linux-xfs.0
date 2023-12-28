Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C0563A8
	for <linux-xfs@vger.kernel.org>; Thu, 28 Dec 2023 07:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FInXzmiJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=zUGAB3khcb2EqUcWbrO+QdDyA2Zx5YkVOEYqFUSWCkI=; b=FInXzmiJVWD1JMynSQcaD5dToF
	gDJ/0tSvrMC7kvT44gwEWk4YlL53z5yOT22RHux81d4UVXLdCTfcXeHV1WWK0nfuSSnqND40PlcWY
	8y2OVkGih8Gjr0FH2eEiP9bWV2UDMcOmw/rG2N6cND7tvlM+Nj8mfGbHEoQ4bPnrLoQB3NU5JDlNG
	4XyPyr+2SkQ0CzH6zqp7iiPvv9dbDUPIoi/4QSYANh8U748sl4IzXHsl7RC3o/4jCRvHkD3wIT6Qb
	P9208G3PwDJ1JMjuYn+goypBOme0ivLo6GIYiLgJNkooN23s0u1h57lmzJ6AdtnC2Kr6hSnsJkpi5
	3drBYwgQ==;
Received: from 128.red-83-57-75.dynamicip.rima-tde.net ([83.57.75.128] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rIkkX-00GKit-1l;
	Thu, 28 Dec 2023 07:24:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: chandan.babu@oracle.com
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>
Subject: [PATCH v2 1/2] xfs: fix a use after free in xfs_defer_finish_recovery
Date: Thu, 28 Dec 2023 07:24:09 +0000
Message-Id: <20231228072410.359908-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

dfp will be freed by ->recover_work and thus the tracepoint in case
of an error can lead to a use after free.

Store the defer ops in a local variable to avoid that.

Fixes: 7f2f7531e0d4 ("xfs: store an ops pointer in struct xfs_defer_pending")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---

- add a comment

 fs/xfs/libxfs/xfs_defer.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index ca7f0ac0489604..75c5b3a2c2cba4 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -915,12 +915,14 @@ xfs_defer_finish_recovery(
 	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
+	const struct xfs_defer_op_type	*ops = dfp->dfp_ops;
 	int				error;
 
-	error = dfp->dfp_ops->recover_work(dfp, capture_list);
+	/* dfp is freed by recover_work and must not be accessed afterwards */
+	error = ops->recover_work(dfp, capture_list);
 	if (error)
 		trace_xlog_intent_recovery_failed(mp, error,
-				dfp->dfp_ops->recover_work);
+				ops->recover_work);
 	return error;
 }
 
-- 
2.39.2

