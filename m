Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711C326B0BC
	for <linux-xfs@vger.kernel.org>; Mon, 18 Aug 2025 05:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755493647; cv=none; b=b6tQcs7U3A/DaaPYDhsFE+n4a6/eiQEz67sp54HbEGshN7AdGRKBnjeB5UbzEZM05mx7CQwJG2xPSoN7xZKmaxj7GCf/n8MI8/EOpeTqsneA38HOExHPGbz+sZIdsB8UWTln1kiRm3AIXDQpS+uevQ4l8Cs6WFabCw5ABANO+MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755493647; c=relaxed/simple;
	bh=Iux7IrzCLzvYhhMxsIj5HyyxNU1V2SsmH9T8rZbYXrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aKu25ObUJAyPuvGgnFILExSTlpkJiNUH6LrF/OueFTRkkX57J+Jp48Z0wHy/BX4Mg8pP2Ei3PMcr26MtSMa/xH9Jhhgd/PT9KOJg8u/zpwYTrCjGUYcOulsVo2ASUM1ckf+1u0NySuHlK+KSNjxAHL7tXvAefn6BQsQqDULLOUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VJLAOlCZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VJLAOlCZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kHbphyR4Nh1l1kNGw/pZpVGBvnL7K8zVhHTMlj7tGQA=; b=VJLAOlCZN8A55IDzGpYqSXpEy8
	lz22GdUOyvp36KJjiZDb9c7IbOVGkJL3Ouq2WFQziR+wRMupIHDXep3D4K1bBNkfHLucFPZle7LmP
	J0f3bGklUzwA/8Xs6aa/rYKtYOFXK0BNxpasM4OqFKW/f8fVcOItnw4My5JRP3iCD8b8NSQYJxyi2
	P+ahFuCDq9zy0GcOHl1Jjm6mUQ48D6g7fNsRyWN2hxWplGCxMJ72fEyGAjawRrej93l48lsqd4zdz
	NWuM/zPT6OjkZW5KztKxxIrTceAHR01rXgSDZR/LOEuWsX2qk71MYvRDZuATk9hZdm70g7mys9yMq
	58DFbk2Q==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uns5d-00000006WZ0-2lkC;
	Mon, 18 Aug 2025 05:07:26 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: reject swapon for inodes on a zoned file system earlier
Date: Mon, 18 Aug 2025 07:06:45 +0200
Message-ID: <20250818050716.1485521-4-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250818050716.1485521-1-hch@lst.de>
References: <20250818050716.1485521-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

No point in going down into the iomap mapping loop when we known it
will be rejected.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 1ee4f835ac3c..a26f79815533 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -760,6 +760,9 @@ xfs_vm_swap_activate(
 {
 	struct xfs_inode		*ip = XFS_I(file_inode(swap_file));
 
+	if (xfs_is_zoned_inode(ip))
+		return -EINVAL;
+
 	/*
 	 * Swap file activation can race against concurrent shared extent
 	 * removal in files that have been cloned.  If this happens,
-- 
2.47.2

