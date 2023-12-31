Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85112BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PXNrMIvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA41C433C7;
	Sun, 31 Dec 2023 21:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058464;
	bh=KsHhpkVsjTM/GVxto467Za5WgBVoaSafUwE/kzDzTO0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PXNrMIvyNjA/J35KlC75SNzYw8Kghyqnbh4DrfxMjTpmovsegbAFMRTLC0IaTx/G5
	 /h+B8/o3SvzceISAQynVG6cwWjJz4LT6Svmgm3ywSRZSKkftaKK4OHTV3ibG1PtwVa
	 JjBZnBNn5r8yfshH76bXdDYziiC9o3W648xHjcu5TkHJmYlzXi4C908fZEibrSODJk
	 qYlN9DBvXjF+e7hzK/0MXlHgYM5IhdtDUxw5p4HNp4/+6Rye0wMjvmX0WNj0eXzf0V
	 aw49rkh+PIJ/CfEMJUS7f3+7VTpQZt+oRCacq7GqW86hE2zTzBu5/RZPWFfCRiH9LT
	 DmJakb2bnPtLQ==
Date: Sun, 31 Dec 2023 13:34:23 -0800
Subject: [PATCH 10/39] xfs: add realtime rmap btree block detection to log
 recovery
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850062.1764998.3010689403938620693.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
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

Identify rtrmapbt blocks in the log correctly so that we can
validate them during log recovery.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf_item_recover.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 2e617041161e0..c7d86636bd312 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -259,6 +259,9 @@ xlog_recover_validate_buf_type(
 		case XFS_BMAP_MAGIC:
 			bp->b_ops = &xfs_bmbt_buf_ops;
 			break;
+		case XFS_RTRMAP_CRC_MAGIC:
+			bp->b_ops = &xfs_rtrmapbt_buf_ops;
+			break;
 		case XFS_RMAP_CRC_MAGIC:
 			bp->b_ops = &xfs_rmapbt_buf_ops;
 			break;
@@ -768,6 +771,7 @@ xlog_recover_get_buf_lsn(
 		uuid = &btb->bb_u.s.bb_uuid;
 		break;
 	}
+	case XFS_RTRMAP_CRC_MAGIC:
 	case XFS_BMAP_CRC_MAGIC:
 	case XFS_BMAP_MAGIC: {
 		struct xfs_btree_block *btb = blk;

