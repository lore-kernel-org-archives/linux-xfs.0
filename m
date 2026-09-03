Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0832249365D
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 11:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435660; cv=none; b=i8+T8HVji/eEVsfMWK7YUOhwmUi3x91L8XBTrFmtNQksFlsl18KFgx44iBmMZDKjvmU5p+Hqov4X1fAzlT2bNLa8RpNfzkKzoLUPpz9Ni16YeFQUrlvftZm1xqnBQ1bnKeLxMk/e6o3GpIL+g5INeGuyKUX2bUovgqDupuePj6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435660; c=relaxed/simple;
	bh=mVLgJJLmT08bcEcsfZIHQ+zeiBJSOUVHGbOL3B4Ni/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OgnEI7zAPdPcAvgHIRcPygteWYbQAa+axCtQKxmhK5FaYsv39PXvx7Uabf+0eCvXPB/Qj/qsIHbxNnxWuLt2zcWDX2hBUVUOQARhj0QHF+1xFxcRFrmXjX1uOpvPZu9PghK1/UZQdxl2BOPbg+N8HylbBUHtaWapE8dpsUoRLV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KoBNvugX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KoBNvugX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF3F1F00A3A;
	Thu,  3 Sep 2026 11:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788435648;
	bh=6Zrz3UfBvqBfS/jN0JQOMXXMoBStuxMx0rDHjvl1tMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KoBNvugXsp7BqGi7vQyhroHnpj8mam7ud+swOTqVKsuiMBQBQlefTUrnCKp96kw/F
	 Y3MIDzpF5FO4HaEGLzO/CBEUVtb5INJF0D07h9+08UDfeemV98tLaNaMkRDaz0Fpp0
	 8r86BuEISgi7QUWYmWy6uukoNw8Wha1b417EBBRPF8eMEAvf95n+9mOak03uTfRPZg
	 9QhajAETmxjhSLisDO23ph2RlmGcQYCfDifWU4G6sAQYzPnecDIsZwUtxC5Yl3YS5h
	 Mbv6dtpXF+3b9eJG+0aAv1C9nHJ/HYm5914ndak3lElL0RGe6XzRtstibwf8KuGA5k
	 jOy6zaHAjqMeg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	aalbersh@kernel.org
Cc: bestswngs@gmail.com,
	brauner@kernel.org,
	cem@kernel.org,
	chuck.lever@oracle.com,
	cmaiolino@redhat.com,
	dawei.feng@seu.edu.cn,
	djwong@kernel.org,
	gaoyingjie@uniontech.com,
	hch@lst.de,
	jiapenglin@tencent.com,
	roland.mainz@nrubsig.org,
	xmei5@asu.edu
Subject: [PATCH v2 01/23] libxfs: convert diff_items helpers to cmp_int
Date: Thu,  3 Sep 2026 13:39:43 +0200
Message-ID: <20260903114022.570210-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903114022.570210-1-aalbersh@kernel.org>
References: <20260903114022.570210-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Convert each log item type's ->diff_items implementation to use cmp_int
like we did for the kernel a while ago.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/defer_item.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 4fc2c74a548c..5d72ee0706f0 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -50,7 +50,7 @@ xfs_extent_free_diff_items(
 	struct xfs_extent_free_item	*ra = xefi_entry(a);
 	struct xfs_extent_free_item	*rb = xefi_entry(b);
 
-	return ra->xefi_group->xg_gno - rb->xefi_group->xg_gno;
+	return cmp_int(ra->xefi_group->xg_gno, rb->xefi_group->xg_gno);
 }
 
 /* Get an EFI. */
@@ -252,7 +252,7 @@ xfs_rmap_update_diff_items(
 	struct xfs_rmap_intent		*ra = ri_entry(a);
 	struct xfs_rmap_intent		*rb = ri_entry(b);
 
-	return ra->ri_group->xg_gno - rb->ri_group->xg_gno;
+	return cmp_int(ra->ri_group->xg_gno, rb->ri_group->xg_gno);
 }
 
 /* Get an RUI. */
@@ -404,7 +404,7 @@ xfs_refcount_update_diff_items(
 	struct xfs_refcount_intent	*ra = ci_entry(a);
 	struct xfs_refcount_intent	*rb = ci_entry(b);
 
-	return ra->ri_group->xg_gno - rb->ri_group->xg_gno;
+	return cmp_int(ra->ri_group->xg_gno, rb->ri_group->xg_gno);
 }
 
 /* Get an CUI. */
@@ -563,7 +563,7 @@ xfs_bmap_update_diff_items(
 	struct xfs_bmap_intent		*ba = bi_entry(a);
 	struct xfs_bmap_intent		*bb = bi_entry(b);
 
-	return ba->bi_owner->i_ino - bb->bi_owner->i_ino;
+	return cmp_int(ba->bi_owner->i_ino, bb->bi_owner->i_ino);
 }
 
 /* Get an BUI. */
-- 
2.55.0

