Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9913D1D79B3
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995709; cv=none; b=uGhmzA8FdtHDstKhv0kmwAlAGtpJ/pKJve9o3Wx1emcvdeLCvfuAj4O307MqFjwH1zCkBASb3m6e3wN0zmr85cHaYfLbfZqSUyg9SZQ4ZYivM5yYAkLEMF5gFkneeluUpXXZe2Pmu0yG06GZfuRLGCqYesKWeKuc9m7qxzv8XDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995709; c=relaxed/simple;
	bh=YfET5qqKv8cthm8Hyiw3a6tY5ZS8Y4Bkk3pZuWIwf80=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KrY6Xrhcoi6igz2NxxYEF0OfUDbGEowxdtTXbTpnQ+N3Ub6OxBTuCxSKBanZFr7xmPVz2oVMuloqBVvsrlKcWT+hmP89k8FUEOzSjJ5vssTZIo5QZzD/brBD2E2HrUa2smm/IEujnEBS1r6VyfaKBJ7u2ROEPmiBFZyc1wgUT7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eD0KOD2E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eD0KOD2E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CABBC4CED3;
	Mon, 23 Dec 2024 23:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995709;
	bh=YfET5qqKv8cthm8Hyiw3a6tY5ZS8Y4Bkk3pZuWIwf80=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eD0KOD2Erq94gLUGEUE9JrPeVuAAJ7aAaP4bxmQZRkIz/n9PZHAJBycA6FFyUIege
	 ANXKPUl3QbG/nhaPLbpO66iYEYmxIXbDAO1ZaVQVkQsKBbtA5kU3535KejNrPevBMx
	 pYnUH8OAHB4cVLL/mv28VuxYre42DQAQJqs0nkz1qilZHmXyj42Ezt8L3bpQSmLRFv
	 mfmpp9AgaxkkPPVC+U6pEEu6BRA9jCKweP6SO/rix8IQuqDed0pIROuTN9j0X/+Fww
	 LJsSqFTjxA8W14XE24PHzQxLfOuf1HN3PKEH4AyG5ntX4ZNUYS56ou61N6XTgVsd6s
	 a/i61RT6Iypig==
Date: Mon, 23 Dec 2024 15:15:08 -0800
Subject: [PATCH 34/43] xfs: scrub the metadir path of rt refcount btree files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420521.2381378.1769683116150026964.stgit@frogsfrogsfrogs>
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

Add a new XFS_SCRUB_METAPATH subtype so that we can scrub the metadata
directory tree path to the refcount btree file for each rt group.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_fs.h  |    3 ++-
 fs/xfs/scrub/metapath.c |    3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index a4bd6a39c6ba71..2c3171262b445b 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -832,9 +832,10 @@ struct xfs_scrub_vec_head {
 #define XFS_SCRUB_METAPATH_GRPQUOTA	(6)  /* group quota */
 #define XFS_SCRUB_METAPATH_PRJQUOTA	(7)  /* project quota */
 #define XFS_SCRUB_METAPATH_RTRMAPBT	(8)  /* realtime reverse mapping */
+#define XFS_SCRUB_METAPATH_RTREFCOUNTBT	(9)  /* realtime refcount */
 
 /* Number of metapath sm_ino values */
-#define XFS_SCRUB_METAPATH_NR		(9)
+#define XFS_SCRUB_METAPATH_NR		(10)
 
 /*
  * ioctl limits
diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index 74d71373e7edf1..e21c16fbd15d90 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -22,6 +22,7 @@
 #include "xfs_attr.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -249,6 +250,8 @@ xchk_setup_metapath(
 		return xchk_setup_metapath_dqinode(sc, XFS_DQTYPE_PROJ);
 	case XFS_SCRUB_METAPATH_RTRMAPBT:
 		return xchk_setup_metapath_rtginode(sc, XFS_RTGI_RMAP);
+	case XFS_SCRUB_METAPATH_RTREFCOUNTBT:
+		return xchk_setup_metapath_rtginode(sc, XFS_RTGI_REFCOUNT);
 	default:
 		return -ENOENT;
 	}

