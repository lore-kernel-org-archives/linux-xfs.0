Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDA54C7D
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608985; cv=none; b=VFUpk+fi1c21xPXC01za9SC5tZXmnXaatyRqXgiRHtVkdFXbblm8pHdqCgWmpqtlw4wefTqAR9kfbkklNvUqoe8OdXofivfCFilIBBNWKLOXSz0r1p7Olh8BR9tqcz/+zxylsh7mm4tS+IOh3mvVk1Ne8/lhde146OunzlbYHgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608985; c=relaxed/simple;
	bh=00AtEmssL5Xh7J+NmWOkf82pxFhIyDsMOQlAs54wUyU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pJddp5Pj0NKQWspkorrLbXYo7QxFSj/Jm7A94Mi1pvFxo4sWeHtlBd/8hbmo80rCIxeJtQZLd+REKmeIzCWD3Prm11nuPd2ghDk2fer9cmFDDQP5M8vcuXu07XOkO98oK+7tEwqYSdX9IXKr3cTeTuhRS8He0cj/awjiVXPX9xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RCXtIj6O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RCXtIj6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937EEC4CEC5;
	Fri, 11 Oct 2024 01:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608985;
	bh=00AtEmssL5Xh7J+NmWOkf82pxFhIyDsMOQlAs54wUyU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RCXtIj6O5+NyfgxcA6T1ehNTDo1mTY+iep15YafIKiMecYx/ehKWDQoN91JtRSmPe
	 quIOgG6QJFA+96pvNhqAGMupLRTkLzY/Emgg+xSA+MmOw08tTFA7O7FJ2Wg1to2n/9
	 eQqh6i3/MXhAXGccqADrAArgh0lZf177A54JNpUcqP0rE3oKD+eBvssB6OeyGp5BDV
	 uXbUQWj7o4tjQO2etVC+pc++zOticYkffnfWCe8afrc4cyUtCJDSKG77CYc4yjcbnb
	 ROIDPy9ROAwp7Lg8pbELuF2i/Vd7zYOOHi/0q/DkT+zhIAfNUT0DLRhrMNrRbyHm2O
	 IIe+suqazXmUw==
Date: Thu, 10 Oct 2024 18:09:45 -0700
Subject: [PATCH 31/36] xfs: add a xfs_rtbno_is_group_start helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860644778.4178701.16054050216083032242.stgit@frogsfrogsfrogs>
In-Reply-To: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
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

Make the boundary condition flag more clear and implement it by
a single masking operation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtgroup.h |    9 +++++++++
 fs/xfs/xfs_iomap.c          |    3 +--
 2 files changed, 10 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index a0dfe3eae3da6e..f3ee5b8177cc72 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -141,6 +141,15 @@ xfs_rtb_to_rgbno(
 	return xfs_fsb_to_gbno(mp, rtbno, XG_TYPE_RTG);
 }
 
+/* Is rtbno the start of a RT group? */
+static inline bool
+xfs_rtbno_is_group_start(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno)
+{
+	return (rtbno & mp->m_groups[XG_TYPE_RTG].blkmask) == 0;
+}
+
 static inline xfs_daddr_t
 xfs_rtb_to_daddr(
 	struct xfs_mount	*mp,
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index ed35191c174f65..fc952fe6269385 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -133,8 +133,7 @@ xfs_bmbt_to_iomap(
 		 * single RTG.
 		 */
 		if (XFS_IS_REALTIME_INODE(ip) && xfs_has_rtgroups(mp) &&
-		    xfs_rtb_to_rtx(mp, imap->br_startblock) == 0 &&
-		    xfs_rtb_to_rtxoff(mp, imap->br_startblock) == 0)
+		    xfs_rtbno_is_group_start(mp, imap->br_startblock))
 			iomap->flags |= IOMAP_F_BOUNDARY;
 	}
 	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);

