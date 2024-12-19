Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E2A1A0BF1
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636923; cv=none; b=Ikvtl7vWABR9bLG8F5UNB1QWq96uaKWFdnTzrAVx8ne5szv9Gy40DwiAzRM2l1lwTKU860OPgA8PF5LF8AI8kwpO9ex1mp79AVC0XcGO+WvDQfN6Smt+eTpfy08O7R0KPxcoOxnsU3GABvh2RBycGwTRwuQo1/6XjkkZfrx54og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636923; c=relaxed/simple;
	bh=btHwRF31cvl6HWAFraCteuWEteK+RPKJoDHa0kSJ2Is=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DjcCbODHfOy7LgSzrCD7N4qicxFnc7T/JgGBMA28VOdp0yUJk/dpwzxW1Qjk/xGUiuMZc6Ca4n//ZQOwBSlK7bzTbG6A+GjTOnaSWKLyJP2k0dKf3+vA5qQY62qJjkTexv7mOwO80ZFKxLGqOQzR4pRRKS1UwYrQvhDB09oTTqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gudcw+vT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gudcw+vT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BF5C4CECE;
	Thu, 19 Dec 2024 19:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636923;
	bh=btHwRF31cvl6HWAFraCteuWEteK+RPKJoDHa0kSJ2Is=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Gudcw+vTNzqCVU4z0EnnrbKhlPmW++XEwaWaFIdNYzTbTAOetxZ8n2Cf0l/S1qmJJ
	 bvId8DQvkHnVuG2dPgJBejS6DdwRrUgAsbTlgGWTja6MwQ8hg9zC+pyGWoZiKi0QDl
	 gcVP05VsMetgey+NCTkSMiEUqnsZ5RVUWwABZxX6ml3AJUPA4OoRxWLMn379ckFYo/
	 ypbAycMWB7icqxp3p6SwtmnZJP1JE4WI7DLyQAVuKcdUnxFh6oqW/oBsHBSnSil3g3
	 3iWrVWsF8kPGaM1QMrPMTXSpAiAy7ChyanTOOgVpN3OSJfR4jaBNLJDF+lqjEEcENI
	 /sUfdn+oohjMQ==
Date: Thu, 19 Dec 2024 11:35:22 -0800
Subject: [PATCH 09/43] xfs: add realtime refcount btree block detection to log
 recovery
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463581132.1572761.75332600078413039.stgit@frogsfrogsfrogs>
In-Reply-To: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
References: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Identify rt refcount btree blocks in the log correctly so that we can
validate them during log recovery.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf_item_recover.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 4f2e4ea29e1f57..b05d5b81f642da 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -271,6 +271,9 @@ xlog_recover_validate_buf_type(
 		case XFS_REFC_CRC_MAGIC:
 			bp->b_ops = &xfs_refcountbt_buf_ops;
 			break;
+		case XFS_RTREFC_CRC_MAGIC:
+			bp->b_ops = &xfs_rtrefcountbt_buf_ops;
+			break;
 		default:
 			warnmsg = "Bad btree block magic!";
 			break;
@@ -859,6 +862,7 @@ xlog_recover_get_buf_lsn(
 		break;
 	}
 	case XFS_RTRMAP_CRC_MAGIC:
+	case XFS_RTREFC_CRC_MAGIC:
 	case XFS_BMAP_CRC_MAGIC:
 	case XFS_BMAP_MAGIC: {
 		struct xfs_btree_block *btb = blk;

