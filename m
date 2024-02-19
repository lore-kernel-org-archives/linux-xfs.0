Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD09EC8D6
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 06:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708324506; cv=none; b=KAdtMboD6cjRS346bs4KAOChbwef5gMxU6PayNs7QBUMYeD3iIqcudtTb4aK4IInOaeKgnTELxirIoRNVHCF/coBRUXXehUf3dHKxFoBod8B6TXVYv6OQhuhmC28f1uyJpnhtIvyuIPS2/UIeAO/SL4leKSv3TSRj9P+Y2qg0TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708324506; c=relaxed/simple;
	bh=NSDV8WbI+qC4taJkKBl1QRR6nwUqqUk5EL/Qgdr4itk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gCEqevbTW2pFYavMYWA7IUI7pc/OCYtaH6J2CflaDhGfp4mVNFlg62R6xD3qolAq1VTY2UEb2jTmFrCFrJ21brPKITCGun+j25545qLdzBPMm/ww2VcIY9Gwj5YCMB2/8D5A5+yUaaQsYta8SbzhLBigDeQ1JQyKFqrDsSewKF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aJsDFXUP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aJsDFXUP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=uN08Sg6SnOtohYxmJaGosDSHupZSZD2LqAXIV8nF9MY=; b=aJsDFXUP8VhCF67S9Kalh4aM6s
	ggP4JNtClJSgpMtjcLVg0QCHOTPuMDaw7I7oep37vjw3fqXUDo4lMCneqQuYf+ZbUtUel61KsE8tg
	DWYVXheFAFjBhyc02YWO7tHYIdKlC76KNQJN3SKn5sf3Ybx/usyoR6hVYCnKdOT7MplunzqZW6e5+
	yAI0t9TVRL4wVRPyqZPiYBs0AgZ/Yj2gMlkNqhIJY5/E/hvW6/y9DK86kloky9Pp3lyJp2N/N7+WC
	S2xuNWBtewptZm/Op3l8o0xFCjelquqQsOhq+SEBeONyLKa0sTwUPjnre6mQP78+GIyZpQnIZSxxa
	5/FAAzDw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbxF1-00000009GOK-49RU;
	Mon, 19 Feb 2024 06:35:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 8/9] xfs: stop the steal (of data blocks for RT indirect blocks)
Date: Mon, 19 Feb 2024 07:34:49 +0100
Message-Id: <20240219063450.3032254-9-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240219063450.3032254-1-hch@lst.de>
References: <20240219063450.3032254-1-hch@lst.de>
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
index 8a84b7f0b55f38..a137abf435eeba 100644
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

