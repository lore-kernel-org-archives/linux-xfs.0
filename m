Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44BD3DAC11
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 07:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711609384; cv=none; b=ILS5xswLFJbqAxV+PCk6FqghNW6L8320xgso+29cahzMfBb3PVf7PGLmvGWJ7BtpX2oB+jzqhx+EQ8sXoc62hesqhtquStqZ1KrQo4lu3S9iscPeHbY1H1pdKrOfSGO9LxmXkZzkrlOfNoA48KWmjih+dEOy581rTXVJ5PGzBRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711609384; c=relaxed/simple;
	bh=dZErzrZ9Fy/ErczLZobwO3JYOEJjz5fL9yB6s9UwvQ8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TuK/VKvvwMa9Z0wkhM5VbNhcyAQcovlIA2Pdg96PEq8S7AcdClzfUasQbGTgkF4tmaxwHGzxKIgXIeV41AQN7v5Q+O+3A3h+sd8A8u7AoFER161gi4nz4NMuKi/kKVhA0Ri1rGY3nEyyjNri6RTMDdkyg4/sfy1jFi9eIigawwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JsVP0lyy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JsVP0lyy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=RvR+nhIJLaqIYIwAP7rYu4lVGzQbbYSku6ZcliVxDDI=; b=JsVP0lyyvtvxtOnJibQWqe+8E7
	lK6aCTvHfE3HFqQ70QVLBq8zdsvM/wU+s3EUcmhSS5WvuyQeJD9ilyIAvtOx8KcRYlhhmmIbV2q/o
	zopbAtc/lAMsRDXgRWQptXEu9ZIuJxWqfZ05ekudpJJ1mMxVfqcR9B7MZgq+HcygJu3brGLX54PCP
	in/38mF4WTF73mm4CBC2xxhPOPIJPWj8VCs/cB2TIq5w3dZwylFwBrWeqWsGdWbakWmHmCQb7nzzW
	tOITWau9mBngUyI2Wp7HPOW+GAH2r3m0NTrUloDJ5hBig4m7/QtsRtlV9dUlzFBtRVidrQrTMwlmH
	Wa6Wc6cA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpjmv-0000000CnfJ-2ZaA;
	Thu, 28 Mar 2024 07:03:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/6] xfs: check if_bytes under the ilock in xfs_reflink_end_cow_extent
Date: Thu, 28 Mar 2024 08:02:51 +0100
Message-Id: <20240328070256.2918605-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240328070256.2918605-1-hch@lst.de>
References: <20240328070256.2918605-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Accessing if_bytes without the ilock is racy.  Move the check a little
further down into the ilock critical section.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 7da0e8f961d351..df632790a0a51c 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -731,12 +731,6 @@ xfs_reflink_end_cow_extent(
 	int			nmaps;
 	int			error;
 
-	/* No COW extents?  That's easy! */
-	if (ifp->if_bytes == 0) {
-		*offset_fsb = end_fsb;
-		return 0;
-	}
-
 	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
 			XFS_TRANS_RESERVE, &tp);
@@ -751,6 +745,12 @@ xfs_reflink_end_cow_extent(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
+	/* No COW extents?  That's easy! */
+	if (ifp->if_bytes == 0) {
+		*offset_fsb = end_fsb;
+		goto out_cancel;
+	}
+
 	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 			XFS_IEXT_REFLINK_END_COW_CNT);
 	if (error == -EFBIG)
-- 
2.39.2

