Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913BD3F9F37
	for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 12:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784293002; cv=none; b=ajDS6vy6jJZS2FVH8O77Gtqa3rvlgoXD/iD/aQm1J1Xtjqaz1HBrfOpj+FeYIEOQmSIzyOFs+nVYndp8dJU2O9Pd3grpxQQ2qyaHV/pxKbO3TiK9qlr+4KMiMXSV6nrC6ydr7Z5yr2XRY1i9b/x6xK0EOB2U0tlBsniawB5liwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784293002; c=relaxed/simple;
	bh=lXrVmbK2ygqg4SUgG451jmxScN2te58JgpnCseQP+QA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=p5+lWegWAyFavm2+xykNyeL5xTLm2iGp51XdSYJFK7mV6JP4QZ7XbMxmMMT7aFNDaw3yJPZJUHtjLkhRz2dFPGtxqcXax+sShpc9roFek9icUeBiTz1xiyUyziF4yipehwrdOm/YctCutAISO3OW+ScGU/AyDkw/nBB9LubzKFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=N+aQQ4EO; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="N+aQQ4EO"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260717125638epoutp03ba999e402872d651aec3885c1cafc0ce~DFQdW4YBm3100331003epoutp035
	for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 12:56:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260717125638epoutp03ba999e402872d651aec3885c1cafc0ce~DFQdW4YBm3100331003epoutp035
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1784292998;
	bh=JKuHkLTOh2D5Lecx1IbVxREv40PpAdCrRwTlABXfzng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+aQQ4EOERBNpwczOzm11VuZlOzwz+H3xx9Mke+kzTQ+gffcesSmGd6Z6IgXZSH5T
	 Bn7EQX6YrE9SNCoTT/WUYeFs13eypVxLV/xjb7DSZaxfYR5E76rocgRsaO/TGGJepn
	 qlDfP3g07/8agqp21YimPS8L+hj0GzXpysYoiWyA=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260717125637epcas5p2d553847cf12928b681e76b2afa3eaf24~DFQcwZFRo1691716917epcas5p2O;
	Fri, 17 Jul 2026 12:56:37 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.90]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4h1qfs008gz6B9m4; Fri, 17 Jul
	2026 12:56:37 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260717125636epcas5p2b68dd498717813e0b395b9d57d9d97df~DFQbDansu0531105311epcas5p2e;
	Fri, 17 Jul 2026 12:56:36 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260717125633epsmtip25356287c20c0aed3c3ca368c42b01e5f~DFQYz_kI61293812938epsmtip25;
	Fri, 17 Jul 2026 12:56:33 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	jack@suse.cz, cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org,
	ritesh.list@gmail.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com, Kanchan Joshi
	<joshi.k@samsung.com>, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v4 4/6] xfs: generic AG set based steering
Date: Fri, 17 Jul 2026 18:25:36 +0530
Message-Id: <20260717125538.508925-5-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260717125538.508925-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260717125636epcas5p2b68dd498717813e0b395b9d57d9d97df
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260717125636epcas5p2b68dd498717813e0b395b9d57d9d97df
References: <20260717125538.508925-1-joshi.k@samsung.com>
	<CGME20260717125636epcas5p2b68dd498717813e0b395b9d57d9d97df@epcas5p2.samsung.com>

Improve allocator concurrency and reduce interleaving by introducing
fixed sized AG set.
Use low bits of the inode as a hash to select AG within the AG set.
Overall, a file will try to use the same AG (and contiguity is maintained),
but multiple files will be spread across all AGs in the target AG set.

Suggested-by: Dave Chinner <dgc@kernel.org>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d64defeda645..fd1a3aa4ad3f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3192,6 +3192,36 @@ xfs_bmap_select_minlen(
 	return args->maxlen;
 }
 
+#define	GENERIC_AG_SET_SZ	(2)
+
+static inline xfs_agnumber_t
+xfs_default_ag_set_size(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	return min_t(xfs_agnumber_t, GENERIC_AG_SET_SZ, mp->m_sb.sb_agcount);
+}
+
+static xfs_agnumber_t
+xfs_ag_to_ag_set(
+	struct xfs_bmalloca	*ap,
+	xfs_agnumber_t		base_agno)
+{
+	struct xfs_inode	*ip = ap->ip;
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_agnumber_t		set_size;
+
+	/* Apply fanning only for regular file data */
+	if (!(ap->datatype & XFS_ALLOC_USERDATA))
+		return base_agno;
+
+	set_size = xfs_default_ag_set_size(ip);
+	/* Fan out within the AG set using low bits of the inode */
+	return (base_agno + (XFS_INO_TO_AGINO(mp, I_INO(ip)) % set_size)) %
+		mp->m_sb.sb_agcount;
+}
+
 static int
 xfs_bmap_btalloc_select_lengths(
 	struct xfs_bmalloca	*ap,
@@ -3587,8 +3617,16 @@ xfs_bmap_btalloc_best_length(
 {
 	xfs_extlen_t		blen = 0;
 	int			error;
+	xfs_agnumber_t		target_ag, start_ag;
 
 	ap->blkno = XFS_INODE_TO_FSB(ap->ip);
+
+	/* fan out initial AG across the generic AG set */
+	start_ag = XFS_FSB_TO_AGNO(args->mp, ap->blkno);
+	target_ag = xfs_ag_to_ag_set(ap, start_ag);
+	if (target_ag != start_ag)
+		ap->blkno = XFS_AGB_TO_FSB(args->mp, target_ag, 0);
+
 	if (!xfs_bmap_adjacent(ap))
 		ap->eof = false;
 
-- 
2.25.1

