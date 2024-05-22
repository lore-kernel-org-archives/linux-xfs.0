Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DD35234
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346376; cv=none; b=cjXylfVwXrN+rWLait/QQAdCkxg+YFmMKexquwreCOMHgJlzWqWQl+ZZtPoLKuEDhhwgruN9xZAbLxzTZ/Im6r1aKHoiSJRVbm8kTCJy44TPyUH3lG08C+tU1K4HrDM5gRnsQwc/eeyWw6Gkk0nhzBDN+28IpMk+9FIM3ckWUhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346376; c=relaxed/simple;
	bh=UIoIfokVwsHD+HMmqExPlAfPjdhAYev6rUBYR/7pWoo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T09GwL1mmb8f3k1g7LQpYsVmBb71qAkv+Hqv3F3xDFVRnJOveUwvUMRL6GtIQoOmQJMfEyqkEf2kThqkLT72s6kklUIDVy2pWnoB0B/QishalgEI9BES9pk5CHe+nrtKV865OdrWmZa7S/A72Tu//VGIQ7cYfF0iaRmFAenhygU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=avmvO21s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="avmvO21s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC90FC2BD11;
	Wed, 22 May 2024 02:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346376;
	bh=UIoIfokVwsHD+HMmqExPlAfPjdhAYev6rUBYR/7pWoo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=avmvO21sAu4clw3v2NH64KFwAiPD+dPuJRQpOubGd88L09qXqW+SVz19MWHq7Ya/6
	 koD1OR+blBjtIGFbvImjUrL8+T6JiFD3T3zk1aVVQHwCGXj7XTwd1c5sC/b+QVTS3h
	 NSFstOYpNKSRpnskD18a8DFtzcogoNBSiB8TrrhkgCrUQja8yKFokLudHAVkNDefVa
	 DMIOR4aBYrciFAHoojX2kSh+CB8+66pVFlXWQ9EszA712OxbedKEgQiMLTb+BrnQyf
	 aJQisNCp8FlGHXRMmfKLHe7RXyPGeyoi8bspGCWZeHutQluE3c/hxArSUsM74FeJjT
	 7ZzEo9IIsqdSQ==
Date: Tue, 21 May 2024 19:52:56 -0700
Subject: [PATCH 016/111] xfs: separate the marking of sick and checked
 metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634531951.2478931.8297664545755126512.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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
index 2bfe2dc40..bec7adf9f 100644
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

