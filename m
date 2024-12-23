Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212B818A6D7
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995319; cv=none; b=LuvPvKG19y+vQaE2E74s8+9KO/YeSE7lyzHQTF0q5y1luBPwohEIgOW6Y6RIRHSVdujXI9347SIUlHVWes07kPMnROBTeKO8kF092W2PaRhYACoYFjyVkEdX+DbT+nU+9um78PQrD4VYdMzsUDwzD7NCFeyYVGfrsUAfjh6If2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995319; c=relaxed/simple;
	bh=btHwRF31cvl6HWAFraCteuWEteK+RPKJoDHa0kSJ2Is=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PIdwpwqtL5tCiyPY1A1Yrbsw9vA04/2JzEsw1ERvilrPcIuH3QgF6n77ysagfi34fVmJuc7alORjr8dnbLrtHzJ+Gsn5Yj/6BudsddyYWJoqw/sTOu0KxCwobZxpFaIJLfnAhf5lYfdIh+nufLLXamNx9QliKOXh/rmaGsumnI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KKKdllu+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KKKdllu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A4BC4CED3;
	Mon, 23 Dec 2024 23:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995318;
	bh=btHwRF31cvl6HWAFraCteuWEteK+RPKJoDHa0kSJ2Is=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KKKdllu+06+ZAm05tMWeBQm3yMhUOLBzsZGmz7h3y4pDrnZcY8lAEt1+fKtsSZFlq
	 T3ao8i86RjE1htYgzz2SalVQamzlXsE1bZVIv51wTrs6JuD7U+c5jg8IC8vwN/wJWm
	 mYYVxc8S3OsyZ1ssk2SBgI2WKIOMP5ShOyg1dtsndtwSjRze21jxWAD/96A0zJ/q76
	 W6i17Qfkv8AdQJAeKasxmxV1GoK5ZZFdS1I5cc3+phMZXAngDKlJUFrEH6U6c7kdAP
	 Nk89kkQcZrQqf25w8ngb40wft3za7QClKPeliYUZY7VYc44sUz2Yg5bLpWyq+oFZfW
	 /370gmAhpZ2vg==
Date: Mon, 23 Dec 2024 15:08:38 -0800
Subject: [PATCH 09/43] xfs: add realtime refcount btree block detection to log
 recovery
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420092.2381378.597579411738728189.stgit@frogsfrogsfrogs>
In-Reply-To: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
References: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
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

