Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA95BE48
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pz7Yn81I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48979C433C8;
	Sun, 31 Dec 2023 21:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059481;
	bh=jE3bx2dMNGItyZYpGwK+8chzBjtJJgek0r/vokaBt0M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Pz7Yn81Ir7PbMY7hof5vya3wmIsV6/58Rhtidu29WuQPzlayuoAkk5u94tt4QWgtE
	 7O2J2j+RV2pj8Jnh6asKn8bDtGLIa6h1xAzG1SYBc6u7dVLMD9o+JlUnZyP1QqFfEw
	 ZxtwgYUZASitSb8UcgK/IL1v6WSIhDGw9seLsBmKUYOyOgFuZKORlStvlV4g1NrLvt
	 RgtwqKYnzOL5Nti4yig0F5LhapxJdo1Y/JmOpi5TlUVSBGURLfI2BSwYMZXfvKD+Q/
	 xGgRUkEvtXJJnjgxvnlOh5pO71CAjyzWxEiuHdD59eammGlsJ4q1iXtF3EcES97g8b
	 0iSmrjM/GHbWA==
Date: Sun, 31 Dec 2023 13:51:20 -0800
Subject: [PATCH 26/44] xfs: check that the rtrefcount maxlevels doesn't
 increase when growing fs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404852000.1766284.10949871237508606131.stgit@frogsfrogsfrogs>
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

The size of filesystem transaction reservations depends on the maximum
height (maxlevels) of the realtime btrees.  Since we don't want a grow
operation to increase the reservation size enough that we'll fail the
minimum log size checks on the next mount, constrain growfs operations
if they would cause an increase in the rt refcount btree maxlevels.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c   |    2 ++
 fs/xfs/xfs_rtalloc.c |    2 ++
 2 files changed, 4 insertions(+)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index e78ee67b9dd12..9584c08480f75 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -24,6 +24,7 @@
 #include "xfs_rtgroup.h"
 #include "xfs_rtalloc.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
 
 /*
  * Write new AG headers to disk. Non-transactional, but need to be
@@ -238,6 +239,7 @@ xfs_growfs_data_private(
 
 		/* Compute new maxlevels for rt btrees. */
 		xfs_rtrmapbt_compute_maxlevels(mp);
+		xfs_rtrefcountbt_compute_maxlevels(mp);
 	}
 
 	return error;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 14e17c2b39ef0..54859b32d37fc 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1128,6 +1128,7 @@ xfs_growfs_check_rtgeom(
 		fake_mp->m_features |= XFS_FEAT_REALTIME;
 
 	xfs_rtrmapbt_compute_maxlevels(fake_mp);
+	xfs_rtrefcountbt_compute_maxlevels(fake_mp);
 
 	xfs_trans_resv_calc(fake_mp, M_RES(fake_mp));
 	min_logfsbs = xfs_log_calc_minimum_size(fake_mp);
@@ -1451,6 +1452,7 @@ xfs_growfs_rt(
 		 */
 		mp->m_features |= XFS_FEAT_REALTIME;
 		xfs_rtrmapbt_compute_maxlevels(mp);
+		xfs_rtrefcountbt_compute_maxlevels(mp);
 	}
 	if (error)
 		goto out_free;

