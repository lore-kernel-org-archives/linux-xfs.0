Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF339226884
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824418; cv=none; b=o/Lpe0iY12HikilQgqAIWVPppimDcaDcvCXb4IqZGAn7+kIORKdcmtXpMVUnM/8KNZ7KmVQRUb1mbYeSpHKHggUiFQflxHgVLB1OVJBzLctGcCCb1Ogb99NfHrQKQ/cBLEL8SoUo3daaQX4AchDfE6g+79ax50obgZumqhOqlac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824418; c=relaxed/simple;
	bh=xxe/wco2+FxmUqwc4rbP8Q7xhJ+HEahJ+e8Z/Ff20II=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VznOnZtKAfY+afMA69by+Y5faUR1CtNT51nKylRKMTBHZQ424aohH76lUp8wiwTxuT2jMSqjJLEnFWTEkd3W59H6ThXbFXB/1bOR5znxcpyJ9oJqYxY2Epqbn5eJFAYJuDNQyFs/qKHRrlia0xHuqLOH/m26S4bU097JO8ES2uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vGe0VHne; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vGe0VHne"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=w1dKplKACJ0T2nuCiMyrQwjARp91GLwOpY1LxHoeLGk=; b=vGe0VHneZfl1UUyXbC9jARtzVC
	+Exb2xuvJ04Aeets7lGv8THVwtEEbzoNQ5UWB33RMWduCVihLDYcCJZ8ZXEXzK2MZyboPXGd6E0/O
	SM0hp/xHiLOR/H89KRY8iD69caSdSy9dExmfsaoezbz09rsY1Uujp4UVJkLf+mk/cYyRBLyaH8UBz
	26RqYzFRQC7+1FgjN8LUvfEB9vVy1a0QMHMZAWLyR5IIekGdYToGkL75kBPrA+7+GAeRfVh5RCydF
	MZ+Uz0Bpp5TsXgt/MeSTU2Gn7TQfhL0emENXlRG6H+q9D08Unk+QAnzt2q8bcpRrZzZM++8iwF+ox
	KFLQotvA==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfvf6-00000005Qoj-02dj;
	Thu, 06 Feb 2025 06:46:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 36/43] xfs: enable the zoned RT device feature
Date: Thu,  6 Feb 2025 07:44:52 +0100
Message-ID: <20250206064511.2323878-37-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206064511.2323878-1-hch@lst.de>
References: <20250206064511.2323878-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Enable the zoned RT device directory feature.  With this feature, RT
groups are written sequentially and always emptied before rewriting
the blocks.  This perfectly maps to zoned devices, but can also be
used on conventional block devices.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index e2cf3af120a3..c99f94c481d2 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -408,7 +408,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_NREXT64 | \
 		 XFS_SB_FEAT_INCOMPAT_EXCHRANGE | \
 		 XFS_SB_FEAT_INCOMPAT_PARENT | \
-		 XFS_SB_FEAT_INCOMPAT_METADIR)
+		 XFS_SB_FEAT_INCOMPAT_METADIR | \
+		 XFS_SB_FEAT_INCOMPAT_ZONED)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
-- 
2.45.2

