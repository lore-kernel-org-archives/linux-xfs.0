Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8222E3360
	for <linux-xfs@vger.kernel.org>; Mon, 25 Aug 2025 11:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756120514; cv=none; b=t4/F9+KqhEmHnQpiH7waf84aqE6JNGXP0uKiP3Whb3qdBMGwORhanYARwAMFPd3WVkspvkGUj/OvoIXnPZnRhAq6amUw4O5EOw2dVxKH7jUYHBaJvGUoCBNUzUyB2pqYnVSlPoTcvg8H5bTIP54PoPo0a8ZKRVcxcaWw7C8hQww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756120514; c=relaxed/simple;
	bh=4BtLkYqrIdAixOCwdttu/mbBfftRH9gpAFFdSn2HBgI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m03gsASzHdrSmU4VFE2gBms6Aj30PgP5T5WZgIGpkWJoXpy5jaS1QT9i/WnrVWU7Yk9CUyK+bZa93l1wc+yd1YlZUsNNK2Ys5sfIJ74SyW92Y43yqHhSZXckc6c5/PSWUy1/TltkcoH64o8+EAYDUnzIYEtvnUmIpArxxJVhnAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZIGWKi2B; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZIGWKi2B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Y50ENBAymDlLBGbOTST2/CyyYu5XedEalCeYJF6cuLM=; b=ZIGWKi2Bh3Trg/wEXs/xc9r8Oh
	nvgjDVUESBfSDeo61/s9U8lbjTTo/13j8ZMYzi8O1z3qGAMS9Rxpj3Dyz9v1aU4LJp87WGL5SElwU
	9ypXfZCOdtIIWF2GJpGKjBw1K5+6qlTAzTf7B68zD21tog3kPJDLtsEWRDVdnxMgFf1qwqpIAPkdd
	bW7nGt1HP5/kvmSjRY8MHbFSyr+AarWhstD95syN4T/0Iec9h7Clq9ACKH4/4LjkDmalTFW6NDMxh
	Exs3S4eQchEoqcb4c1Gk7aryoaZm2HQNXPrY7ph5nVBhLnRXmVb3OSCWpgW9Wuwp71gFR4iT71PXE
	Qc0CPvdA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uqVAN-00000007idN-3J5r;
	Mon, 25 Aug 2025 11:15:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: implement XFS_IOC_DIOINFO in terms of vfs_getattr
Date: Mon, 25 Aug 2025 13:15:00 +0200
Message-ID: <20250825111510.457731-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Use the direct I/O alignment reporting from ->getattr instead of
reimplementing it.  This exposes the relaxation of the memory
alignment in the XFS_IOC_DIOINFO info and ensure the information will
stay in sync.  Note that randholes.c in xfstests has a bug where it
incorrectly fails when the required memory alignment is smaller than the
pointer size.  Round up the reported value as there is a fair chance that
this code got copied into various applications.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---

Changes since v1:
 - update the comment

 fs/xfs/xfs_ioctl.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index e1051a530a50..ff0a8dc74948 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1209,21 +1209,21 @@ xfs_file_ioctl(
 				current->comm);
 		return -ENOTTY;
 	case XFS_IOC_DIOINFO: {
-		struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
+		struct kstat		st;
 		struct dioattr		da;
 
-		da.d_mem = target->bt_logical_sectorsize;
+		error = vfs_getattr(&filp->f_path, &st, STATX_DIOALIGN, 0);
+		if (error)
+			return error;
 
 		/*
-		 * See xfs_report_dioalign() for an explanation about why this
-		 * reports a value larger than the sector size for COW inodes.
+		 * Some userspace directly feeds the return value to
+		 * posix_memalign, which fails for values that are smaller than
+		 * the pointer size.  Round up the value to not break userspace.
 		 */
-		if (xfs_is_cow_inode(ip))
-			da.d_miniosz = xfs_inode_alloc_unitsize(ip);
-		else
-			da.d_miniosz = target->bt_logical_sectorsize;
+		da.d_mem = roundup(st.dio_mem_align, sizeof(void *));
+		da.d_miniosz = st.dio_offset_align;
 		da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
-
 		if (copy_to_user(arg, &da, sizeof(da)))
 			return -EFAULT;
 		return 0;
-- 
2.47.2

