Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6E41292F3
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423955; cv=none; b=b6/g84Tn2pzrO++Ydwrw3uXZmGMa8F3hYSuiAQBzZGkznuPBzYv+xN3G0eK6BbDp0ZgfJ35XUJp0to6eff+ajfSIBz8RyNmAJeZ63Jbpia6Pw5VtvfSBUXMimNbRqLM71r8m9aqE+foBHV9Wc5fSuAb9enjTzcJOqAqOf4m3XkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423955; c=relaxed/simple;
	bh=0sDpUmtsp8zoGiCzyOp877xh6JNv/2TxdeWqbyCA1rw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ujms8zNWBSnOYiJsIfaAMxysf1AB+xObarlsKDj6Bdega6nD6PrK4fRblgy4rnnuUYZfmuXfkVTyu5MkluZYn3PcLVblgHJo9IfGn/D9e95WQs42KzSAZv2ljtBOtGicO2qZMVZ530E7dd7991Z7Tz+IgWD4xYIOK+ZT6CdN1hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ioRImmqX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ioRImmqX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5793FC433F1;
	Tue, 26 Mar 2024 03:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423955;
	bh=0sDpUmtsp8zoGiCzyOp877xh6JNv/2TxdeWqbyCA1rw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ioRImmqXzEy8e5es8kDgxAnvLKESDfYHvhF7yzockmWlv3MrWWxW9hz3UOBDjnCdC
	 DcjOvKLcWLQlFg9fSj/v5aOvOJ3WXSMZv+Y07O++FMxWOfg4oAa2delj5Mn86FVs3x
	 AqZKYN1E2/wXMhaMNiLX5n9A3Q7luKTbeDklXqYOGuTv+lWd2w2IjtqAiL0F8GjkGj
	 clmUEwDGNumCncx+KUjVkpcIkPn4DG/eXls7STy7NxAXFzPepEyv5v7lpvdpn5sn6b
	 xZxAaeUOPRhBEudfICwBQIxA+jJ8sUdN+LaGSzSGYkSUrI4lrd2c40bx7/RyebB8O2
	 Od7Z5jDsUwN0A==
Date: Mon, 25 Mar 2024 20:32:34 -0700
Subject: [PATCH 016/110] xfs: separate the marking of sick and checked
 metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131615.2215168.12920979875668021870.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: 0b8686f19879d896bbe2d3e893f433a08160452d

Split the setting of the sick and checked masks into separate functions
as part of preparing to add the ability for regular runtime fs code
(i.e. not scrub) to mark metadata structures sick when corruptions are
found.  Improve the documentation of libxfs' requirements for helper
behavior.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_health.h |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 2bfe2dc404a1..bec7adf9fcf7 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -111,24 +111,45 @@ struct xfs_fsop_geom;
 				 XFS_SICK_INO_DIR_ZAPPED | \
 				 XFS_SICK_INO_SYMLINK_ZAPPED)
 
-/* These functions must be provided by the xfs implementation. */
+/*
+ * These functions must be provided by the xfs implementation.  Function
+ * behavior with respect to the first argument should be as follows:
+ *
+ * xfs_*_mark_sick:        Set the sick flags and do not set checked flags.
+ *                         Runtime code should call this upon encountering
+ *                         a corruption.
+ *
+ * xfs_*_mark_corrupt:     Set the sick and checked flags simultaneously.
+ *                         Fsck tools should call this when corruption is
+ *                         found.
+ *
+ * xfs_*_mark_healthy:     Clear the sick flags and set the checked flags.
+ *                         Fsck tools should call this after correcting errors.
+ *
+ * xfs_*_measure_sickness: Return the sick and check status in the provided
+ *                         out parameters.
+ */
 
 void xfs_fs_mark_sick(struct xfs_mount *mp, unsigned int mask);
+void xfs_fs_mark_corrupt(struct xfs_mount *mp, unsigned int mask);
 void xfs_fs_mark_healthy(struct xfs_mount *mp, unsigned int mask);
 void xfs_fs_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
 		unsigned int *checked);
 
 void xfs_rt_mark_sick(struct xfs_mount *mp, unsigned int mask);
+void xfs_rt_mark_corrupt(struct xfs_mount *mp, unsigned int mask);
 void xfs_rt_mark_healthy(struct xfs_mount *mp, unsigned int mask);
 void xfs_rt_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
 		unsigned int *checked);
 
 void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask);
+void xfs_ag_mark_corrupt(struct xfs_perag *pag, unsigned int mask);
 void xfs_ag_mark_healthy(struct xfs_perag *pag, unsigned int mask);
 void xfs_ag_measure_sickness(struct xfs_perag *pag, unsigned int *sick,
 		unsigned int *checked);
 
 void xfs_inode_mark_sick(struct xfs_inode *ip, unsigned int mask);
+void xfs_inode_mark_corrupt(struct xfs_inode *ip, unsigned int mask);
 void xfs_inode_mark_healthy(struct xfs_inode *ip, unsigned int mask);
 void xfs_inode_measure_sickness(struct xfs_inode *ip, unsigned int *sick,
 		unsigned int *checked);

