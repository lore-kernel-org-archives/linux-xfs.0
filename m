Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D07E17592
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481389; cv=none; b=XKSvraHOAIHLU667Ilk3kwl9ha8rW8dzDfxxOy1eBE07/DGTZcr0OmdrXKhkZJ+dFNkIz0OHXd2JXE9oUZ000qnED4Y5BFCYaL7Ju9BdBKNviCzdH6EkJuSg2xBuMcGduHHssHl5ZDSOaSYTgC9Noc56+HhDPVv6m31Dewhuxqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481389; c=relaxed/simple;
	bh=cxUryCxKCKTWbh6yKAX4PK8gIXz9Iniq1MZAjgN/S0o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=evzTtba1842KDbUy+9ShypjauYbpwwzuJH/KPoN5ls2jaySn3ClW86XzAh3yr2uP6gqaP+BAUVi9zZw1RGe7b1patKswdxAdw2SOYEvYHp1J0yREGFDne68FxNzdYLy8EUrRqGgy9dQFbYDAVX3sIhKaEqXmw1FSqs9mdrihXs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=v2bSO5QQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="v2bSO5QQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JdP1xE0/Yffrrsz7zq7/Ib4Nuvl59nzDz49qauCStqE=; b=v2bSO5QQUZwBHSp6gBFPw83vYQ
	aIt+hQUOQSC2VSQ7pab0gT00GUUhGjDTRVpo+F5xQ9mZNtBq3tKVurIvVekmT3RKSNb/dM4Tsyllc
	7YyRKqj+0vk7d+dDbZpaXpyGZlt8Tq+ruxKS+9AFfgEEHtZF/d99zdnPxPBXiHXu70jUus/KyUIkF
	cNhZ0pSiVn0E7R4AHGNa0UsZ7tB+lgExvieGuJjd/o1u3+fjwoq0tp4amHoHRw/dMV4niitoAPyjU
	EDvqnnqr6g4RavzuCrML9JiwXjXDwffyrcANYEDCYkazmNYb/vvCObXWV2IbT6RrEDvlymeemOlhc
	zXHmmsew==;
Received: from [2001:4bb8:188:7ba8:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1mvb-00000006NjR-2Ec3;
	Tue, 30 Apr 2024 12:49:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 06/16] xfs: remove the buffer allocation size in xfs_dir2_try_block_to_sf
Date: Tue, 30 Apr 2024 14:49:16 +0200
Message-Id: <20240430124926.1775355-7-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240430124926.1775355-1-hch@lst.de>
References: <20240430124926.1775355-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

We've already calculated the size of the short form directory in the
size variable when checking if it fits.  Use that for the temporary
buffer allocation instead of overallocating to the inode size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2_sf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index fad3fd28175368..d02f1ddb1da92c 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -281,11 +281,11 @@ xfs_dir2_try_block_to_sf(
 	trace_xfs_dir2_block_to_sf(args);
 
 	/*
-	 * Allocate a temporary destination buffer the size of the inode to
-	 * format the data into.  Once we have formatted the data, we can free
-	 * the block and copy the formatted data into the inode literal area.
+	 * Allocate a temporary destination buffer to format the data into.
+	 * Once we have formatted the data, we can free the block and copy the
+	 * formatted data into the inode literal area.
 	 */
-	sfp = kmalloc(mp->m_sb.sb_inodesize, GFP_KERNEL | __GFP_NOFAIL);
+	sfp = kmalloc(size, GFP_KERNEL | __GFP_NOFAIL);
 	memcpy(sfp, &sfh, xfs_dir2_sf_hdr_size(sfh.i8count));
 
 	/*
-- 
2.39.2

