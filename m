Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E58A22B5A6
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866351; cv=none; b=CfEISYeqcjEOM88SVBeg8KbMDREvMXQKIN3UR+y/rptoU2mDryadcXF4IfUKM1XVpzJEU8MuC8l/B9fkc2RGt2UcUwF4F33cTohhXu1np3iQqSomTopsnVMgGJxxVlDWeSeNa/4FtDoUIhcm5h30g614dTHlicfkbe69RxrJ2wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866351; c=relaxed/simple;
	bh=DKbmVL0+2WcORdoBnr/bPVAP7SA8SmbLWBhhITrJAYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3PtRadyKsOZVsAt9WTGq6oS9yd4x+KSCrAVDDKB26hnbgP3dzzFNf04tNg+2hF4ZQpI9vXeIxSALafD26W9pxcveThNMXFjuu8c7s2pLtiq1mUC34S/gSxHKQ4fpWYhlLPGzLHGjjQqfq3CyAInIhNU6k7l5feuRW5VIJOFcus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cNqIjjq+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cNqIjjq+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0wz0pd+XTksdD2WU2NRAKVysbTapQV/+tfGeaasIQgE=; b=cNqIjjq+YBjSixY05c3GRPM84K
	wldvk1IcIRDJKAqPNp9EdYpCOVFHlRpf5dF+OrhdPrYReUb5u1k5L90Lj39yvSLvFYFMCtPpmrIn4
	93A3o0Hr6rxr9ECK7UldsrscmYdaY10y46eStxmg2W0kWRy7CWjdUouQgKgSr7PjH4Fo30mK5DkgV
	6UMC2sdGbRr7ctoeai/Da1AIi0/xOKUDWLlriox98l334yu8VL24L2+XED1YRbDDvbfEwU6IoY5Si
	5rpLTPRl0Pg8FCItbxkWtgfZs8tSc13jCFWX5TcUa/QPkqzl0j18hA4cLpmWHNInjavsoJ379gddT
	QRr/zTqw==;
Received: from 2a02-8389-2341-5b80-8ced-6946-2068-0fcd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8ced:6946:2068:fcd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkIiT-00000007COY-2WV7;
	Tue, 18 Feb 2025 08:12:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 13/45] xfs: refine the unaligned check for always COW inodes in xfs_file_dio_write
Date: Tue, 18 Feb 2025 09:10:16 +0100
Message-ID: <20250218081153.3889537-14-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250218081153.3889537-1-hch@lst.de>
References: <20250218081153.3889537-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

For always COW inodes we also must check the alignment of each individual
iovec segment, as they could end up with different I/Os due to the way
bio_iov_iter_get_pages works, and we'd then overwrite an already written
block.  The existing always_cow sysctl based code doesn't catch this
because nothing enforces that blocks aren't rewritten, but for zoned XFS
on sequential write required zones this is a hard error.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_file.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 785f6bbf1406..d88a771d4c23 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -721,7 +721,16 @@ xfs_file_dio_write(
 	/* direct I/O must be aligned to device logical sector size */
 	if ((iocb->ki_pos | count) & target->bt_logical_sectormask)
 		return -EINVAL;
-	if ((iocb->ki_pos | count) & ip->i_mount->m_blockmask)
+
+	/*
+	 * For always COW inodes we also must check the alignment of each
+	 * individual iovec segment, as they could end up with different
+	 * I/Os due to the way bio_iov_iter_get_pages works, and we'd
+	 * then overwrite an already written block.
+	 */
+	if (((iocb->ki_pos | count) & ip->i_mount->m_blockmask) ||
+	    (xfs_is_always_cow_inode(ip) &&
+	     (iov_iter_alignment(from) & ip->i_mount->m_blockmask)))
 		return xfs_file_dio_write_unaligned(ip, iocb, from);
 	return xfs_file_dio_write_aligned(ip, iocb, from);
 }
-- 
2.45.2

