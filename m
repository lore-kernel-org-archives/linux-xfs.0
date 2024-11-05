Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF075216435
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845560; cv=none; b=rUSpCzHOkDELrOQlr/dk6Pm3AjZB448FjWdAZFaoO5jDSW2/zW3SRD4uveBVAPye1JX6GtnVpQoChTG2liBm3faauTOc+JVSjZR+t8OZoen+xMi3Vh7Moq764Y2BnN/vVKtkI4jlX8nqU9ZaSd8A9sTyS5Gyy5WvGJ3vyGnhrg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845560; c=relaxed/simple;
	bh=tiT81Z46aWVUeqOMMtrmRKIZGl92kzdSOrdG6N95Y9c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NMAwg869mDpPK9jFsvjUPzf7/b8TW8Gx4FPQFtIQVtGVFldIAheoTXKRqdvrQZrEATHaDQWBG8v6AaFGR8uPOSzSsbN4COT6UjHu1dnUqfd4zMVyS4mCjNUIXj/fteXe5rO6M+nHCOqNw3zNyXsWmU/52gM8oVYSEQrQLbKAHkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W5C1I3CT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W5C1I3CT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82D2C4CECF;
	Tue,  5 Nov 2024 22:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845560;
	bh=tiT81Z46aWVUeqOMMtrmRKIZGl92kzdSOrdG6N95Y9c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=W5C1I3CTnlx8SEI61IDq6Ms7lxK9HJJ56VWcKRCzaZ3isjSPRF94aXstm20an5i6n
	 eCLhB3nPY287VgziOTMql2Q64vvbW/iyB5rLzkqRGIVIzZqcYanQlZ/a9YvnAYUKiE
	 dfSQMEAda5ejd1badj6zoPXk+1XcFm9YPcbhqJIZTSYSA6LIeCam4pQfJmeB9gze0W
	 8upjXmSfDIVk06ce70FVQiiQ+moz0r9vmf9N/D7as6YEwvzeF5PvHVfOqhh/wxl/D5
	 uIPkLjgiUGZzzwevst/xZ6lkPWWgmZqs963OFpCtI20N1eFm5xIOgeQjUzOvgSUCed
	 r01X8ZzRhkMag==
Date: Tue, 05 Nov 2024 14:26:00 -0800
Subject: [PATCH 08/21] xfs: add a xfs_qm_unmount_rt helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084397076.1871025.3977766604028177554.stgit@frogsfrogsfrogs>
In-Reply-To: <173084396885.1871025.10467232711863188560.stgit@frogsfrogsfrogs>
References: <173084396885.1871025.10467232711863188560.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

RT group enabled file systems fix the bug where we pointlessly attach
quotas to the RT bitmap and summary files.  Split the code to detach the
quotas into a helper, make it conditional and document the differing
behavior for RT group and pre-RT group file systems.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_qm.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index b94d6f192e7258..3663c4f89ed8a1 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -29,6 +29,7 @@
 #include "xfs_health.h"
 #include "xfs_da_format.h"
 #include "xfs_metafile.h"
+#include "xfs_rtgroup.h"
 
 /*
  * The global quota manager. There is only one of these for the entire
@@ -210,6 +211,16 @@ xfs_qm_unmount(
 	}
 }
 
+static void
+xfs_qm_unmount_rt(
+	struct xfs_mount	*mp)
+{
+	if (mp->m_rbmip)
+		xfs_qm_dqdetach(mp->m_rbmip);
+	if (mp->m_rsumip)
+		xfs_qm_dqdetach(mp->m_rsumip);
+}
+
 /*
  * Called from the vfsops layer.
  */
@@ -223,10 +234,13 @@ xfs_qm_unmount_quotas(
 	 */
 	ASSERT(mp->m_rootip);
 	xfs_qm_dqdetach(mp->m_rootip);
-	if (mp->m_rbmip)
-		xfs_qm_dqdetach(mp->m_rbmip);
-	if (mp->m_rsumip)
-		xfs_qm_dqdetach(mp->m_rsumip);
+
+	/*
+	 * For pre-RTG file systems, the RT inodes have quotas attached,
+	 * detach them now.
+	 */
+	if (!xfs_has_rtgroups(mp))
+		xfs_qm_unmount_rt(mp);
 
 	/*
 	 * Release the quota inodes.

