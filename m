Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7A154F8A
	for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2024 10:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708941911; cv=none; b=JoQUxv0W/cKfxmAA8XnsmlISPR2lk3Z+GZfUbSRTBiBLReTiROQmsIMcQdOOGtG4F3YAuugeyT8OfVSfi4eupp9bkS0Hlka7kwe9EubWhF7loqF9f/qsoEzsdPHqFdMyMBU1lRZLIZOTKhzu3LwU8PnuPOAtEhWkRNzkiPbbz2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708941911; c=relaxed/simple;
	bh=syqXh4vUMRzdDXWvB98CBmevsmeiaK/CYv/FJinayh4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Mk6yUdnTSWlVSvg0ido/Z++2tHlNYWgmiRfPE/370CDiqrq8VAMTa5HKmk5h+G9KujOkOMPWVDWIv0CMOOZBCkY3dSUVhsgXjdlHp0FtTq0veTk/FzTYPjmmV3rGaVWgQ/y2GF3241LRe7wK5tFucuAsaD7bYJlBou+odzkq1WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CQ0UeZfl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CQ0UeZfl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qccrgRdQwJ2fTuQNghNDhQPQEsrE8uR+BWXLqtZ4jO8=; b=CQ0UeZflpoXT5vd1rxuxT/u6H8
	0teroZE/8F2vYp39ojOyht4Xpuu5CTON/GmzAcBxoHocBzl1Fnx6X19XC5AA1zObJVRrT+1Q88J2V
	wNpcevJ4I7I98ygXza8Yy+55OnwCFGXsI0Dsmo68EhUqletzj5X2MuKw9SgO2Ji5M3I4sZ+E+zkRK
	7Iev6rmoGw+5/mE+ZjUn8qZ0VeJriNzg/XJjBzlauRZGK/rkmpl+Jwj+9+bIBoPOAiBAEbGatM4QP
	72HOhdRDqgZhxIzZhMzSyM68bEqeXLrDQZlkpwABWPOaVU5T7AudIh1LljI64u1AQckPcOEhtpO31
	ad9fm5uA==;
Received: from 213-147-167-65.nat.highway.webapn.at ([213.147.167.65] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reXrA-0000000HX6L-2qYI;
	Mon, 26 Feb 2024 10:05:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 09/10] xfs: stop the steal (of data blocks for RT indirect blocks)
Date: Mon, 26 Feb 2024 11:04:19 +0100
Message-Id: <20240226100420.280408-10-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240226100420.280408-1-hch@lst.de>
References: <20240226100420.280408-1-hch@lst.de>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index fc42f17f86e1f0..2732084e3aebff 100644
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
+			 * So we have to try to increase our reservations here,
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

