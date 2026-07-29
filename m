Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E26486B98
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 13:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785330212; cv=none; b=i7ea0g1XgCWfI3UpX5yCryT4WDofUpHN+h+OotnUvcyw0ktGNwwb3rpOOI59ABoYSYwe/kxxAPjSmTjKASq4s0Sa6oiCZWNWMTsbEUJ7phaMODkuLvUahVScMi3vWR425AIc3Yf6h5CgKS/TVv/RK8lqXa7Tl+zZHMcDfVZhMTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785330212; c=relaxed/simple;
	bh=9ECNl3sWm7M5ZhzBIX/V9ZGyOla31wn5gGKQ51oMYWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EP3bQcWt0LH8N/yeJCItYyNtZIv0Jg9IC/0WkYetbJ9emVpp33S3BN/r7skmDW7CTC7HGmIXsJWbHaG/HiIyKxPeBvx/ITfYYhw30Go2xsdtQL8ktqCBuR+73VkL5DdN7rPM6RNhf7v2TGPgSczI+8ec+8ymFinBtROXjwJA8LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=S1xpJU90; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="S1xpJU90"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=gXY3Uc47jHnIxrFJAOm8GI3GTUhTIDWV2QrBQbihg6Q=; b=S1xpJU90DGnQZv0qcrBQqLsJEr
	nOBH1nyMw0LBMb/T8HwuOT+gllNxyHavpxF5Mt1NvUMLhZLlW9k3TmWOiS8/DdepKaG+Mwzmq12Aw
	JtPoAdJuh7D2mRv/iA6RSU3vZcJFyd1wL+jElRX9/m88Qeb3tUByCTVLM+1RC7pser5FmCu5ok/kh
	nrbKDJYHEQQnJ3tqiYVwvf9cFFwyy4INHYiTukZOZvV4jrlI47rLkLiLWvHGi93thNVyTr7yjrb6+
	aB9u2x0o++WBSntAJPC9Pv+myly+WlDEZ8wK1z+i61sVaiSrU6x/WiD3aotoYhFUlWAsoOVNSQvt4
	SQq0voyQ==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp3wV-00000004WkI-1gPp;
	Wed, 29 Jul 2026 13:03:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 07/16] xfs: split out the handler for XFS_IOC_SWAPEXT
Date: Wed, 29 Jul 2026 15:03:06 +0200
Message-ID: <20260729130320.2282183-8-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260729130320.2282183-1-hch@lst.de>
References: <20260729130320.2282183-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Split out a helper for XFS_IOC_SWAPEXT to keep the stack variables out of
xfs_file_ioctl and to clean up the main ioctl handler flow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6a7c570ea535..eeff0678d5bf 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1262,6 +1262,25 @@ xfs_ioc_readlink_by_handle(
 	return xfs_readlink_by_handle(file, &hreq);
 }
 
+static int
+xfs_ioc_swapext(
+	struct file		*file,
+	void __user		*arg)
+{
+	struct xfs_swapext	sxp;
+	int			error;
+
+	if (copy_from_user(&sxp, arg, sizeof(sxp)))
+		return -EFAULT;
+
+	error = mnt_want_write_file(file);
+	if (error)
+		return error;
+	error = xfs_swapext(&sxp);
+	mnt_drop_write_file(file);
+	return error;
+}
+
 /*
  * These long-unused ioctls were removed from the official ioctl API in 5.17,
  * but retain these definitions so that we can log warnings about them.
@@ -1361,18 +1380,8 @@ xfs_file_ioctl(
 	case XFS_IOC_ATTRMULTI_BY_HANDLE:
 		return xfs_attrmulti_by_handle(filp, arg);
 
-	case XFS_IOC_SWAPEXT: {
-		struct xfs_swapext	sxp;
-
-		if (copy_from_user(&sxp, arg, sizeof(xfs_swapext_t)))
-			return -EFAULT;
-		error = mnt_want_write_file(filp);
-		if (error)
-			return error;
-		error = xfs_swapext(&sxp);
-		mnt_drop_write_file(filp);
-		return error;
-	}
+	case XFS_IOC_SWAPEXT:
+		return xfs_ioc_swapext(filp, arg);
 
 	case XFS_IOC_FSCOUNTS:
 		return xfs_ioc_fs_counts(mp, arg);
-- 
2.53.0

