Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37AFBA3F
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 13:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752671007; cv=none; b=FUDmhKhB2+hG/u6HxWXtzSPgQ1oVlz3GYZ90DCQRwqUTZ0QFv2qm5FZTVDC3VMoWr+WfTm72JRVg4L7A3r3GaEK+3kkBCJOmQUXqUaVco2lXfp9Tu+ds0fH98TyN6Tk78MY9lhxUPLbINvz4YtVmd03vDQCD0aEgtlweipXD3G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752671007; c=relaxed/simple;
	bh=tt4T5nmSkDyPN5Ljbz8GtnLs3INSC3pdZ9WRCh2STGw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XHxOdgJkYVTIkeKFpbJvunqXuB2DjLgyDi1DurvGRCSpnU/wcV4n3oiyja4A82zrnWwStxaaKZL/s9jrFPecMNDD5sQ1aAJJ4WfrqiTueAKXgln/mBoDbq2hthnC4tCiD64r4on1/1hn0PPpTEGGel9CoMmg5xRqTnfVnwUAWB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=y2Guo5Rp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="y2Guo5Rp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=KCDJR6frJebjhVckceOMuplyMPEXeLi8c/loYeWjGL4=; b=y2Guo5Rp10BhU70rxXEOiBrRHK
	MOCuEB85hpZerBuXO9TICnTyLo079OL/jhMAZl1ardFTT3y0/GrJp2FRca4HOH4os0DjCsYkKAaZm
	AFQozEXtoYvFxl33EuMGAushLeeRKGIf76rQfD9WholGOYenIxmpwp8baKZLkEOZRBczOjUDVYxxu
	a4A/2XiyXyeeJgsORp/nHG5wmxtltJ9kcALD3EHH2apSNbLFIMx/JDp/9yoSbbAgcssuahIA5mKbn
	GSPNlapSG19Y4vCtyx2KyuisIL37ZfKk0zB7HWDlm+1hM1qJ1+LSbNLwpa0j8FAbISD29V44bBwqg
	bZitS3AA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uc1nA-00000007kkm-4AQR;
	Wed, 16 Jul 2025 13:03:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: improve the xg_active_ref check in xfs_group_free
Date: Wed, 16 Jul 2025 15:03:19 +0200
Message-ID: <20250716130322.2149165-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Split up the XFS_IS_CORRUPT statement so that it immediately shows
if the reference counter overflowed or underflowed.

I ran into this quite a bit when developing the zoned allocator, and had
to reapply the patch for some work recently.  We might as well just apply
it upstream given that freeing group is far removed from performance
critical code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_group.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_group.c b/fs/xfs/libxfs/xfs_group.c
index 20ad7c309489..792f76d2e2a0 100644
--- a/fs/xfs/libxfs/xfs_group.c
+++ b/fs/xfs/libxfs/xfs_group.c
@@ -172,7 +172,8 @@ xfs_group_free(
 
 	/* drop the mount's active reference */
 	xfs_group_rele(xg);
-	XFS_IS_CORRUPT(mp, atomic_read(&xg->xg_active_ref) != 0);
+	XFS_IS_CORRUPT(mp, atomic_read(&xg->xg_active_ref) > 0);
+	XFS_IS_CORRUPT(mp, atomic_read(&xg->xg_active_ref) < 0);
 	kfree_rcu_mightsleep(xg);
 }
 
-- 
2.47.2

