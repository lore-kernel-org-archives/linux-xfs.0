Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B2EBA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hn5FE5Rp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B482C433C7;
	Sun, 31 Dec 2023 21:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057462;
	bh=/TiEWYYItZwvncszQPXShr4QjodL6ZvOgMNItBghsvA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hn5FE5RpttY85FXclefjVzNRZNOtwRKB7BvK5GluBcC+kSwmDTkNuJ/EvDzxN/DGD
	 TBuaMu+bp/V1T5tP4mnyFbcwAcFcyTOaLPeO7gQWOu2azXF8BRYlnWX/gxEmSYFtWd
	 H+YEOuT63jHcwmz2lLzYKuJwnG/eOAidR2453nvl/MHYFnekKVNaP3qjOUuT94p48p
	 +Ua9anTG/xYN1QFZRZ5Y79vwW1RJTLC1fqTSdShQNdflgwpYegx6h9yGjs0s+TrKhL
	 GsV3YxwnhXGq2lvzKS+vcGNEIonZCV4urpnwJs/hqCpx3Mq//1Q8rXvQB5loge5Aum
	 DQR/rAO09N+LA==
Date: Sun, 31 Dec 2023 13:17:41 -0800
Subject: [PATCH 08/24] xfs: always update secondary rt supers when we update
 secondary fs supers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404846370.1763124.5031203573820391747.stgit@frogsfrogsfrogs>
In-Reply-To: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
References: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
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

Make sure that any update to the secondary superblocks in the data
section are also echoed to the secondary superblocks in the realtime
section.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c |    4 ++++
 fs/xfs/xfs_ioctl.c |    3 +++
 2 files changed, 7 insertions(+)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 80811d16dde00..84b311bd185af 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -21,6 +21,7 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_trace.h"
+#include "xfs_rtgroup.h"
 
 /*
  * Write new AG headers to disk. Non-transactional, but need to be
@@ -319,6 +320,9 @@ xfs_growfs_data(
 
 	/* Update secondary superblocks now the physical grow has completed */
 	error = xfs_update_secondary_sbs(mp);
+	if (error)
+		goto out_error;
+	error = xfs_rtgroup_update_secondary_sbs(mp);
 
 out_error:
 	/*
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index a887c1d5d69fb..b140f7ed916c9 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -42,6 +42,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_xchgrange.h"
 #include "xfs_file.h"
+#include "xfs_rtgroup.h"
 
 #include <linux/mount.h>
 #include <linux/namei.h>
@@ -1874,6 +1875,8 @@ xfs_ioc_setlabel(
 	 */
 	mutex_lock(&mp->m_growlock);
 	error = xfs_update_secondary_sbs(mp);
+	if (!error)
+		error = xfs_rtgroup_update_secondary_sbs(mp);
 	mutex_unlock(&mp->m_growlock);
 
 	invalidate_bdev(bdev);

