Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967FE4C8C6B
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 15:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790349687; cv=none; b=P28pJzgQYDE2/ZoZ65FzadwADKPbfSrkp5Qgk150ck9KklOhYfiIlMAxjfjmURUjLV1Y/PSmM1x6ykcrlI5qabcWKaG9uplFEKYMeSJJaSgHvTLy83yPQ87bIo9eq+FuAkhgy+Tv80j+g0GHM0R1jC+2mJD5YrpENIXLarsaoi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790349687; c=relaxed/simple;
	bh=H6GPgPKns9O/v848dXOJyPekJxp3GAGZA5Fw+Wmw3ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gar/Rtje6hg3HoGKv5PD5d8H10elcaGp1pmbEUhYp//bhBHeA/POjlW1Sp3z2Si+FwDqU5R9fSoh8Woz8rOPwFFRt8yO7uuVDUzv3xCyXdqFihKW0rRHEAcOZ9NuWou6zrC3Bi7g78WlGD60fk9zlefzaifIPzw/0PIdPVdwzCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NvM78mC/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NvM78mC/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cGkghryYJCjAQEQ/ahfrCdX+PpPsvxx+24uvIwWrXZ4=; b=NvM78mC/Sq4q1rmTzVeCRYvgA6
	9CaHauNDzvFwV3Hj00TZqQOj3dcBn70uGeCZxT0+s0nG2iEmSMfW7l0d7JpDldQ/mXFF1u/lHGqWC
	AtvAE1HslWz/6XKWW3v1SFZ4nALuQMe0nyyiuhX435B7hvp7E2w8hz7cw/7uC2hRE8++hx8IQg/z1
	q/13sX1uu12esFSy/XCVYovoBb081w1mEotr4k3Fy6n2oEwek8At+4X4WrmmjgsrX2H7bDfMuYwfY
	GRZtc7vn9JDec3BVkDugzppF2IFqMaokds5BYCKuckDoOaWvbKxnoZNaSyauwAHW/syzPHj+1l97P
	XLlMec4Q==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xA7jp-0000000DldB-19Ol;
	Fri, 25 Sep 2026 15:21:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 06/13] libxfs: remove the unused xfs_inode_log_item.ili_fsync_fields field
Date: Fri, 25 Sep 2026 17:20:25 +0200
Message-ID: <20260925152107.3386097-7-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925152107.3386097-1-hch@lst.de>
References: <20260925152107.3386097-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

To prepare for reusing the kernel version of the struct.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/logitem.c         | 1 -
 libxfs/stubs/xfs_trans.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index 6e56e476d1ea..d09ff75e9ce2 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -231,7 +231,6 @@ xfs_inode_item_precommit(
 	 * (ili_fields) correctly tracks that the version has changed.
 	 */
 	spin_lock(&iip->ili_lock);
-	iip->ili_fsync_fields |= (flags & ~XFS_ILOG_IVERSION);
 	if (flags & XFS_ILOG_IVERSION)
 		flags = ((flags & ~XFS_ILOG_IVERSION) | XFS_ILOG_CORE);
 
diff --git a/libxfs/stubs/xfs_trans.h b/libxfs/stubs/xfs_trans.h
index 9b6a47988147..fcd58930cc85 100644
--- a/libxfs/stubs/xfs_trans.h
+++ b/libxfs/stubs/xfs_trans.h
@@ -40,7 +40,6 @@ struct xfs_inode_log_item {
 	unsigned int		ili_dirty_flags;	/* dirty in current tx */
 	unsigned int		ili_last_fields;	/* fields when flushed*/
 	unsigned int		ili_fields;		/* fields to be logged */
-	unsigned int		ili_fsync_fields;	/* ignored by userspace */
 	spinlock_t		ili_lock;
 };
 
-- 
2.53.0

