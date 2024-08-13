Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63346F2F3
	for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2024 07:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723534802; cv=none; b=HjAHiiz2nSOpA+gD3con9wF/R8fNLBQ0JOif7fYjRC5rfB1ILsMr53qxeMCw95E96FyY65coOiR+Ifj7kOIxDecZIr5hqbjGzIugtzYhFkfk5o0jFf3nfgFkDX8Fybesy/cTPPSEllJKI3I9CTNo7+8QiXDh94A2lEiCXHnFeRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723534802; c=relaxed/simple;
	bh=1ffybEYeulSPO8MW/8FCE0+ONbLCqzpFEfbiRTvgEDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eW8R4aeut+rGLxYDHB09vwiX/mG9VpXeYwg/BDqzdC0dCDXUSAcydiRp3FbzGsapC6fLOtKiAyFsQR75u0i+yBI//jm/BGbCuqcKUQ4dNZEIzj8sBYh/8cnVydQ/50BHx/FO4s8wTZ7VLBoNpX/dKJm9/0D2nY4sQ8S7MMIDSBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=z9fnQYI9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="z9fnQYI9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=C2rqm8DhjKyNE7zY2hAiGy5FC8ZJZ94IpLrv2EErJZQ=; b=z9fnQYI911/A/o7CXp2KZA71fX
	YroFTJ6WcwJT1HsBrPD3QXazDaCyY6jq60GsRM+vAkBAb9CfauzhDVUM+DppFR7AePDXglvQDxHls
	T93qeOFR4z3aPY1g0LoIg9/JP1a2zQaKKHrAnfJy0/L1Pi8jaUeurY75F2F3iHm9kNfZJidKC/r6h
	4O6Zp4Z/63m0G0DPb/WrUk8s4t/tRMZ3Ao1uuahRxE+OR0eMmpXrCdxYDRR5oxWRjhM6z+N9wpZXe
	BnONYeO+V/S9gHT7XNLasj70KrYRAqfbHfCe79+EeFRISidHCOoeX0JR1HXEiRr9SObSYMU2u1jL/
	yI/nfVNg==;
Received: from 2a02-8389-2341-5b80-d764-33aa-2f69-5c44.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d764:33aa:2f69:5c44] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sdm8M-00000002l7s-2rMw;
	Tue, 13 Aug 2024 07:39:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/9] xfs: remove the i_mode check in xfs_release
Date: Tue, 13 Aug 2024 09:39:34 +0200
Message-ID: <20240813073952.81360-2-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240813073952.81360-1-hch@lst.de>
References: <20240813073952.81360-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_release is only called from xfs_file_release, which is wired up as
the f_op->release handler for regular files only.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7dc6f326936cad..c7249257155881 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1086,9 +1086,6 @@ xfs_release(
 	xfs_mount_t	*mp = ip->i_mount;
 	int		error = 0;
 
-	if (!S_ISREG(VFS_I(ip)->i_mode) || (VFS_I(ip)->i_mode == 0))
-		return 0;
-
 	/* If this is a read-only mount, don't do this (would generate I/O) */
 	if (xfs_is_readonly(mp))
 		return 0;
-- 
2.43.0

