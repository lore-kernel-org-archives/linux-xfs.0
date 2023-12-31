Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CEEBE48
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pd4jPxM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD62C433C7;
	Sun, 31 Dec 2023 21:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059231;
	bh=JHmeHBKLmKbnpHhi6WprZOGcLny5LV4Sa19vbbGv7B4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Pd4jPxM8IPRFszW+jAVRPKuMn3Yc4NW+QbXNH7VICz2cQ1OO774HyuucE4jwmePTk
	 1HL1cwfk16bVsAzYIw4idDiB3ufZc2/NeRNy2HO1fZ0YA602KmEgp4Je/CsRaiKdPR
	 MvkTIjsBOSZJuWLUjLgtZT9yNkvhJV54QVTEJMm4U2t7SELajGvhxKanMR/qdN3avk
	 nl0UMeSN1jvAnlUN/Zn9whr1c5Fx4O/zAn2L/6hne5tnn27GvloiXUlUHnlOgcZZNY
	 ShMMXICkpUgIucjghr86wgswj/ly1uKFQAOUlHTlF+y1GzIEHSKl2EQSLR5Pp1RC6e
	 WQWAsCGMsGHiw==
Date: Sun, 31 Dec 2023 13:47:10 -0800
Subject: [PATCH 10/44] xfs: add realtime refcount btree block detection to log
 recovery
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404851743.1766284.10397022615627765088.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf_item_recover.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index c7d86636bd312..ebe7f2c3cf635 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -268,6 +268,9 @@ xlog_recover_validate_buf_type(
 		case XFS_REFC_CRC_MAGIC:
 			bp->b_ops = &xfs_refcountbt_buf_ops;
 			break;
+		case XFS_RTREFC_CRC_MAGIC:
+			bp->b_ops = &xfs_rtrefcountbt_buf_ops;
+			break;
 		default:
 			warnmsg = "Bad btree block magic!";
 			break;
@@ -772,6 +775,7 @@ xlog_recover_get_buf_lsn(
 		break;
 	}
 	case XFS_RTRMAP_CRC_MAGIC:
+	case XFS_RTREFC_CRC_MAGIC:
 	case XFS_BMAP_CRC_MAGIC:
 	case XFS_BMAP_MAGIC: {
 		struct xfs_btree_block *btb = blk;

