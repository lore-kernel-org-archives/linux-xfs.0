Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DEE18C03A
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185413; cv=none; b=MRpu5s2BMAsbW4aiYRZXwBRfzg7nM2iJG/fgUn+cz6VYAgZ/LQh6sM6JD31eE1PmUuXrPkFoKUVfr1t57zBwsLpcF92/uIpXlpPan8GrG/mTyv4hIjThubzkMrYg9gQ/OCNm8K/TPlXW5r2WeSSBDoEcibeKq33KqqhvRS3aZwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185413; c=relaxed/simple;
	bh=QOsqewRUbe0PGyimK4ufkoNLmMWcUFmc3K/HAF3BxzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mmfze+rc/BNWefmwt53PeU4Zk307MvzBd5fPfcpP+GBwiS59uh/xr519wCZeHK0xz+2MYrQxTB0jZgtN24yz/O3o6vhbs7/sM+EbuDD/jjd1F2DxO7T+aYyK3UDvDpASXB3PjzMSvpG/7/9E/vJz7getDpnPQy8pBJf3QmicDEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=L6OvKh5i; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="L6OvKh5i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0K2ALQXLY+D8g8SNSSbrPfQmxiOA4rEdTCdHO2J9ybU=; b=L6OvKh5ibdbBqwHk6vkiDNZt8e
	x89JDZ1KfH8ip4DasUCdGuEkvQeCTJIDbLqGIVP0Z61PWCiEK+Aexm7dyv6e+tMVIbL3R7YU/ijJ5
	+P/x6XQInTd+YDPenE8s1X7fi5c8aVjRAxhkamoyD7wdpCPIR+gio/WKkNMPaaE9NWmAEzBbVblmU
	cdm1ku8fHDUJovrVVlczR5Ee+4KlKVdRIPqYt9RbGYSfG/JnBG0iFJxAuwNmnZIfZk9r22xu+M3N/
	eI7aDEi0CCp5dTkQq/M2lrauQtDHak0nX90/5a8NDaCCd/Y3zx4Q0NxKYZx8fjTIgQ2P/uC1YJvCG
	LVYkCncQ==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QIl-00000006UMx-0aw6;
	Wed, 09 Apr 2025 07:56:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 12/45] xfs: allow internal RT devices for zoned mode
Date: Wed,  9 Apr 2025 09:55:15 +0200
Message-ID: <20250409075557.3535745-13-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250409075557.3535745-1-hch@lst.de>
References: <20250409075557.3535745-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: bdc03eb5f98f6f1ae4bd5e020d1582a23efb7799

Allow creating an RT subvolume on the same device as the main data
device.  This is mostly used for SMR HDDs where the conventional zones
are used for the data device and the sequential write required zones
for the zoned RT section.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_group.h   | 6 ++++--
 libxfs/xfs_rtgroup.h | 8 +++++---
 libxfs/xfs_sb.c      | 1 +
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/libxfs/xfs_group.h b/libxfs/xfs_group.h
index 242b05627c7a..a70096113384 100644
--- a/libxfs/xfs_group.h
+++ b/libxfs/xfs_group.h
@@ -107,9 +107,11 @@ xfs_gbno_to_daddr(
 	xfs_agblock_t		gbno)
 {
 	struct xfs_mount	*mp = xg->xg_mount;
-	uint32_t		blocks = mp->m_groups[xg->xg_type].blocks;
+	struct xfs_groups	*g = &mp->m_groups[xg->xg_type];
+	xfs_fsblock_t		fsbno;
 
-	return XFS_FSB_TO_BB(mp, (xfs_fsblock_t)xg->xg_gno * blocks + gbno);
+	fsbno = (xfs_fsblock_t)xg->xg_gno * g->blocks + gbno;
+	return XFS_FSB_TO_BB(mp, g->start_fsb + fsbno);
 }
 
 static inline uint32_t
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 9c7e03f913cb..e35d1d798327 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -230,7 +230,8 @@ xfs_rtb_to_daddr(
 	xfs_rgnumber_t		rgno = xfs_rtb_to_rgno(mp, rtbno);
 	uint64_t		start_bno = (xfs_rtblock_t)rgno * g->blocks;
 
-	return XFS_FSB_TO_BB(mp, start_bno + (rtbno & g->blkmask));
+	return XFS_FSB_TO_BB(mp,
+		g->start_fsb + start_bno + (rtbno & g->blkmask));
 }
 
 static inline xfs_rtblock_t
@@ -238,10 +239,11 @@ xfs_daddr_to_rtb(
 	struct xfs_mount	*mp,
 	xfs_daddr_t		daddr)
 {
-	xfs_rfsblock_t		bno = XFS_BB_TO_FSBT(mp, daddr);
+	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
+	xfs_rfsblock_t		bno;
 
+	bno = XFS_BB_TO_FSBT(mp, daddr) - g->start_fsb;
 	if (xfs_has_rtgroups(mp)) {
-		struct xfs_groups *g = &mp->m_groups[XG_TYPE_RTG];
 		xfs_rgnumber_t	rgno;
 		uint32_t	rgbno;
 
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index bc84792c565c..a95d712363fa 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1201,6 +1201,7 @@ xfs_sb_mount_rextsize(
 		rgs->blocks = sbp->sb_rgextents * sbp->sb_rextsize;
 		rgs->blklog = mp->m_sb.sb_rgblklog;
 		rgs->blkmask = xfs_mask32lo(mp->m_sb.sb_rgblklog);
+		rgs->start_fsb = mp->m_sb.sb_rtstart;
 	} else {
 		rgs->blocks = 0;
 		rgs->blklog = 0;
-- 
2.47.2

