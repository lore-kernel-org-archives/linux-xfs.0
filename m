Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D21B101DE
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299512; cv=none; b=SOrl9kiTofleS6d5xBW+UnkPsBDW3siIG9aFi1pFPRBn9eFLVFewMTp4PI2PutLdqtSqfzQWCPQFFRrG2VLaWqo8DjRW7h9lCC8hXWwBK6IBnzlnyhlMyTywe+2JA3Ykv6BNCgJdaBthQ8EIRLk79oup1qXGuJb/HTAgnWq+w6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299512; c=relaxed/simple;
	bh=Bmdug2vfwPORSobNz+uYgDBNJ9QYHM1FeTgERAOmTyI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T9fyRaS+Ex8BYZqjN0mc+FmrzTUrj0J99J6L7Bqw56tIvWaBzIoY2zqa1kRonC/lnRWHcAcJseD3DhZ3lkunnBQkJU2o5TtMa1Kag+vcwSl4qBQT+Raed5CeTTORiZgP/5ugDikWfuxEvQg6tREMuv//iwjkeJo5t33zKSe0BKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z63GfwP0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z63GfwP0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3002C32786;
	Tue, 30 Jul 2024 00:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299511;
	bh=Bmdug2vfwPORSobNz+uYgDBNJ9QYHM1FeTgERAOmTyI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Z63GfwP0pc8GFP7DEtgAGaT/nwijXlNkVgjVH9gIMnYuQhr4etHLq+rH5d2rQDibJ
	 yuLtlWkV7KOwU1ixV5kzjK0q3gmnmCKVE/ViJCWZeR/Y+Oix3tElO2wqZiKI2SesCq
	 3OtG0BdiSzi/JZoAAoCDgbycCzGuTNC1lKEYCI13VsWFeyzAlPoluxQIwXobwyFXnL
	 OmeKkhsjnKvmLZfONzfM12CldBFufydwcVndvCx1WJpVFpMQ7ISh+vdcqV7oOPvZH1
	 dVwxr+py3OGGDuD04JSpY0WcHDNZBw1mcEXqBBW66mW6KwKl2P5mQqqxTacWKHDb5p
	 sJZCbTuPEGMAw==
Date: Mon, 29 Jul 2024 17:31:51 -0700
Subject: [PATCH 031/115] xfs: make XFS_TRANS_LOWMODE match the other
 XFS_TRANS_ definitions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <172229842880.1338752.10132960039094086493.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 330c4f94b0d73e440de3f738a625e38defe1bc15

Commit bb7b1c9c5dd3 ("xfs: tag transactions that contain intent done
items") switched the XFS_TRANS_ definitions to be bit based, and using
comments above the definitions.  As XFS_TRANS_LOWMODE was last and has
a big fat comment it was missed.  Switch it to the same style.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_shared.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index dfd61fa83..f35640ad3 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -124,7 +124,6 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define XFS_TRANS_RES_FDBLKS		(1u << 6)
 /* Transaction contains an intent done log item */
 #define XFS_TRANS_HAS_INTENT_DONE	(1u << 7)
-
 /*
  * LOWMODE is used by the allocator to activate the lowspace algorithm - when
  * free space is running low the extent allocator may choose to allocate an
@@ -136,7 +135,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
  * for free space from AG 0. If the correct transaction reservations have been
  * made then this algorithm will eventually find all the space it needs.
  */
-#define XFS_TRANS_LOWMODE	0x100	/* allocate in low space mode */
+#define XFS_TRANS_LOWMODE		(1u << 8)
 
 /*
  * Field values for xfs_trans_mod_sb.

