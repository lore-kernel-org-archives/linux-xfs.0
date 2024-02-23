Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A9312E43
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 07:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708672582; cv=none; b=bSU+SjcQxWp58QLIJo1oKFY5PMZup9+nxcWKZGOfQb4Ug8lRs/uklROnklHTjxthb9r8fy2Cv2MYMsX3yf8eRgzRLRI7W1ymtl/zCmhIRTa+6RvH9xKRlOmUVKiaxlX5Mvjmor1A7jRnBOOAXXXQLKTjR4qzr7sBi2yWZqZkp9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708672582; c=relaxed/simple;
	bh=rzdqb/cOCzGowlOq17vcawC7JIAprnQwlQXx9i5mJ8o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n2QaLKUGisI4xVpCBqvYYy08buc4yo5Pomfw52Qcvx11sjik9yMIl0VNbYhxx4bf4tO6eIuLwlcPvftgLQ6L+KWAok03TBlQXrywV4X6pc0yVj7kJy28KKs7VGVcSi0h46muSWO7WYu6zyaHDCggt6F1ciK5jqFZb/NHaBUert8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SN13iL3d; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SN13iL3d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+kaZaTgYvfyPAFr/YnB1yC/g4XkAr4sfzyTQzH3zG/s=; b=SN13iL3dnUTDbdB+eiy0VEBr5P
	t0uOU9goNmCN63R/DI25xCiPM5tQ4JVZFx0Z/33DgX3bnI0IBZo3tsYMFn/jhtZpWufZZe2DGQYt3
	kzzDyu66ldNxnLMICY+FfgE9P6ABFnJ8q2UmP/TmaDQ5KTjEsnpGPrD77LLoEN52iQc0LeHeKACH1
	5Ma7fgqbdpSaY2vzQnGnVVUK03P8xeq29GVZc/bJWsrQEjaPMWoO02y6jF6ZWZyyTGdlzl93kF2AE
	B+9/dlkyFv13ntCkBUszMnO9K6Eb2VR2yN1W9S5gpR10z1LmXZpyIdAolZH/+lIv151SCKPRZhRVm
	VNVOT6qA==;
Received: from [2001:4bb8:19a:62b2:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rdPmv-00000008Gxl-2lC7;
	Fri, 23 Feb 2024 07:16:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 09/10] xfs: stop the steal (of data blocks for RT indirect blocks)
Date: Fri, 23 Feb 2024 08:15:05 +0100
Message-Id: <20240223071506.3968029-10-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240223071506.3968029-1-hch@lst.de>
References: <20240223071506.3968029-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When xfs_bmap_del_extent_delay has to split an indirect block it tries
to steal blocks from the the part that gets unmapped to increase the
indirect block reservation that now needs to cover for two extents
instead of one.

This works perfectly fine on the data device, where the data and
indirect blocks come from the same pool.  It has no chance of working
when the inode sits on the RT device.  To support re-enabling delalloc
for inodes on the RT device, make this behavior conditional on not
beeing for rt extents.  For an RT extent try allocate new blocks or
otherwise just give up.

Note that split of delalloc extents should only happen on writeback
failure, as for other kinds of hole punching we first write back all
data and thus convert the delalloc reservations covering the hole to
a real allocation.

Note that restoring a quota reservation is always a bit problematic,
but the force flag should take care of it.  That is, if we actually
supported quota with the RT volume, which seems to not be the case
at the moment.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d7fda286a4eaa0..4fa178087073b1 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4912,6 +4912,30 @@ xfs_bmap_del_extent_delay(
 		WARN_ON_ONCE(!got_indlen || !new_indlen);
 		stolen = xfs_bmap_split_indlen(da_old, &got_indlen, &new_indlen,
 						       del->br_blockcount);
+		if (isrt && stolen) {
+			/*
+			 * Ugg, we can't just steal reservations from the data
+			 * blocks as the data blocks come from a different pool.
+			 *
+			 * So we have to try to increase out reservations here,
+			 * and if that fails we have to fail the unmap.  To
+			 * avoid that as much as possible dip into the reserve
+			 * pool.
+			 *
+			 * Note that in theory the user/group/project could
+			 * be over the quota limit in the meantime, thus we
+			 * force the quota accounting even if it was over the
+			 * limit.
+			 */
+			error = xfs_dec_fdblocks(mp, stolen, true);
+			if (error) {
+				ip->i_delayed_blks += del->br_blockcount;
+				xfs_trans_reserve_quota_nblks(NULL, ip, 0,
+						del->br_blockcount, true);
+				return error;
+			}
+			xfs_mod_delalloc(ip, 0, stolen);
+		}
 
 		got->br_startblock = nullstartblock((int)got_indlen);
 
@@ -4924,7 +4948,8 @@ xfs_bmap_del_extent_delay(
 		xfs_iext_insert(ip, icur, &new, state);
 
 		da_new = got_indlen + new_indlen - stolen;
-		del->br_blockcount -= stolen;
+		if (!isrt)
+			del->br_blockcount -= stolen;
 		break;
 	}
 
-- 
2.39.2

