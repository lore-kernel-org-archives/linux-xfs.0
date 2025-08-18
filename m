Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D972613AD3F
	for <linux-xfs@vger.kernel.org>; Mon, 18 Aug 2025 05:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755494033; cv=none; b=dnTUMr8rIWoAQ9RGTCNzu9YQ2AOHGSt4cmHf1iWfg6xpIag9WiG1TpUAynyLcBu7vHz0eZSbsZLvPxYd8ncfw0mkSh6qVcMX2O94sw2tLf5RUicsLc+UMJw41K/JhbIPakxBoPhbicRQAkwfUPS9wfnodkL13UrOErkcdYs1fEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755494033; c=relaxed/simple;
	bh=1zbo3VD+KswRLf0t/2+i9+6oS+Vq/cc5CLyeQr6rWCI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hgrnTvexLCy7K7n9ZlyiSXIZs3En8YIoMjvc2yPY4BNKCgw2LD+8QGIg92+FtBf0xE8jVS+oPf9xIBj9ecOhDE9z7NLF3diqaGveuBQB3iBUpt/OMnqtI6YhJg9FvgC4KiLohhFqyjr/xY4eWpMdV3DdDicudYadEBY91xTNlMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QHDdk53e; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QHDdk53e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=rR7NYRjFLYmdVDOLFdFRb4ROZCSw1UD2esNmBvHiuss=; b=QHDdk53eK3uL76fcJPCrgYTjCQ
	cheLuZodf4NiaRn+27mJCXVtK2XO9Od4vossDE+L6BLCTrA0kZLA/uhaQ/L8OEC6JIx+aJU9NjZgE
	E+LQJQkiPRGvoeP+oDHrZIRygAwYxDiNntKCLlbDPEoGckJndc/FME+r9Zq8p4Q7ehKS/BOC8d3ye
	HbuZwRpFN1p3LB2DmZJzlfDW3z2NX4eXrgt7aOC+gELAmSTbzVlIHx1OQMVB90e2MfIYJ4vc7huP7
	LAS1+2Ezg46DCyOKS+7C8sBajS2LpS+o1pXfBpT2N1c3/r/qxayt80AvbGzl/K0NglzrlNOLuIz9c
	s1IJQNnA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1unsBr-00000006Wtt-0Qim;
	Mon, 18 Aug 2025 05:13:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: implement XFS_IOC_DIOINFO in terms of vfs_getattr
Date: Mon, 18 Aug 2025 07:13:43 +0200
Message-ID: <20250818051348.1486572-1-hch@lst.de>
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
 fs/xfs/xfs_ioctl.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index e1051a530a50..21ae68896caa 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1209,21 +1209,24 @@ xfs_file_ioctl(
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
+		 * The randholes tool in xfstests expects the alignment to not
+		 * be smaller than the size of a pointer for whatever reason.
+		 *
+		 * Align the report value to that so that the dword (4 byte)
+		 * alignment supported by many storage devices doesn't trip it
+		 * up.
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

