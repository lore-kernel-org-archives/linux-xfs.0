Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA18A7464
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230606; cv=none; b=r4GDhTOXKvdQt1SFrvh6tn7+jVaMSd6APDIh3KZtStLH13FX6hVO5Tg1gQ57D5iBXi0KjPp35h6zHzOjpaX5O0d8NNurpmqoZoFZJdA2te1Cev2y/Y0N1REvqJcsK75OYDGk1P39eeK70u8s03vySjhGUTMrq03fSCVKsfQn/Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230606; c=relaxed/simple;
	bh=XmBYplJz1Dvqfdk8XVvjTU/Pv08ibIXAtVHVau0Lc98=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fM39WuDs7Tt5cc2Y7m67jdQAiD5EHO1QTt3aVMsvT2tpUIIy7otqJ/CJW7o4bqVSfwMawCgeYmQHFd7YMrTbWMU5taAOWMvq7uzlFEplMNmUGnaxNrGi252KhFwEx6wqzuOdgi7fr1cjqZn1+FvU1bskO8PSVaJ3M456Eh+vyNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JNr586oo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JNr586oo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3F0C113CC;
	Tue, 16 Apr 2024 01:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230606;
	bh=XmBYplJz1Dvqfdk8XVvjTU/Pv08ibIXAtVHVau0Lc98=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JNr586ooGNhYiDqy2sC0G/mCT+E2ggyc7RkgNBiziv2OXaPuDdisLzg+j6UOMtb3W
	 BOy/l2T1BPfdO4GLKyCYGnCFaomFWfuKoyesrhu1fkHhnQ2TJ+GEMmYLSIY5CC4kV/
	 Du4jiEwU4F5D+gRJa6tl+z8oLYijyfcCfqTrKYB/hYynwoS+XLd08nDvClLb5RVNg8
	 W25wS7ap6LA5HdnXxhAiGUwojDgNm0gZdzXT7Oy2W67WIkrnGk8qn82WhQsYm50kWQ
	 Gkip+r7DcGP6c57CgA+cvxEyw8oQetsI9ovN9DroJZEMC2fVnTaIbyTlGcThfgL+W2
	 vlaIfiKMQo/SA==
Date: Mon, 15 Apr 2024 18:23:26 -0700
Subject: [PATCH 04/14] xfs: check opcode and iovec count match in
 xlog_recover_attri_commit_pass2
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de,
 hch@infradead.org
Message-ID: <171323027138.251201.2756602055478753695.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027037.251201.2636888245172247449.stgit@frogsfrogsfrogs>
References: <171323027037.251201.2636888245172247449.stgit@frogsfrogsfrogs>
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

Check that the number of recovered log iovecs is what is expected for
the xattri opcode is expecting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr_item.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index e5e7ddbc594b9..d3559e6b24b7d 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -737,6 +737,7 @@ xlog_recover_attri_commit_pass2(
 	const void			*attr_value = NULL;
 	const void			*attr_name;
 	size_t				len;
+	unsigned int			op;
 
 	attri_formatp = item->ri_buf[0].i_addr;
 	attr_name = item->ri_buf[1].i_addr;
@@ -755,6 +756,32 @@ xlog_recover_attri_commit_pass2(
 		return -EFSCORRUPTED;
 	}
 
+	/* Check the number of log iovecs makes sense for the op code. */
+	op = attri_formatp->alfi_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		/* Log item, attr name, attr value */
+		if (item->ri_total != 3) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		/* Log item, attr name */
+		if (item->ri_total != 2) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
+	default:
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				     attri_formatp, len);
+		return -EFSCORRUPTED;
+	}
+
 	/* Validate the attr name */
 	if (item->ri_buf[1].i_len !=
 			xlog_calc_iovec_len(attri_formatp->alfi_name_len)) {

