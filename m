Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24730127B62
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440974; cv=none; b=GPfYLVkdjeZs9hkmyIb6HtGJrjPA3dwFLVwW24+q94io49EKFLx++1hqO7K5OS3/4M0Fk3Ld1g7551szFQ3gky36rsNELSIRqoFq0PPCELE5vRg+0TGMCHYmBIvpWJ1NTZKgLuit/H+WMbO0OSzYqTmZQmwL49C1gBt7eiySmq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440974; c=relaxed/simple;
	bh=uGzv+R5Anm06IQLHIUP3RAjBOACIGxtOswt9zRY/MUA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jXRW9rr3ESr1AxZRW59X+/2uNWjeMRMW85xuLdEuIXqCQ0+waybsfcZcHBWBKFSv9NhX8zZjhjI28N7lJNrCWkff5e4Cc+7y8afMz5GWF2NDFZtaPRWOkO9km6Q4GX7zlyMitmMGfT7atDBylh23ikAWWw16y+3kYUQch6NX+tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ITUQPlsG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ITUQPlsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFBE6C2BD10;
	Mon,  3 Jun 2024 18:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440974;
	bh=uGzv+R5Anm06IQLHIUP3RAjBOACIGxtOswt9zRY/MUA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ITUQPlsGPVskAXSAz5RyFT3TupajIraV+az/PxyjDH6BrpMDCGXIvzInaIhAXTTFY
	 t9oPpCqbxCqr31oUblOSMFCHLhoPu0zY5mdgOYxH9rQXNrm39sLc9ufRbrXslh30js
	 VKg1a6cwvDnYAIktFGxPGZ5V7uhIhsHioRrsThZpke+7rIT84U0DMqhvW3vZ962qdq
	 VjrFqHLdwD4H+SB0k7Qggx6Bl2Ou7tVTR8bfMc00L0yrsjWsgNvPS5R7CUJrZKsS7o
	 jmQg3B2T9wHpal/kFrFCij1+s6syjg5xHn7E5MqqCKl0aBgeb0JF1MaZLKmf8oMqRg
	 BDEWcmpz9w7JA==
Date: Mon, 03 Jun 2024 11:56:13 -0700
Subject: [PATCH 016/111] xfs: separate the marking of sick and checked
 metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744039608.1443973.8324087218491764495.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
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

