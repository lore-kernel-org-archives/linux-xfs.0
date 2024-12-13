Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD842629
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052026; cv=none; b=BaWvyWJLV/8GkM+uMzPu9MvzKAwywSEcg2aq33PGFDF13DAIs2eYancx/gH+7w31KynTUH++ChoQlT1oV3Q6uZjv1SSxK+p6BR0c/STt20duP1ZLEif8Zb34E/8zdOB5rd/k3UqQbdEXJhCu1rC3E4VYRX42uevpFd1KcZKSy4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052026; c=relaxed/simple;
	bh=Fwjs/kBV21i3Odcw9HpOgGCPxlZ0GnJjW649x1tBc1c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZNhkE7dObAJxb3P+ea07/0K/PfHLbQvPcJtiTBs803XQCaefy7LqyCJ3p7smeyMEH0GiN9XMgnaEMvcj3kHFrYXzE8bMERZse2k+f8f5wBOk5w+EOOa5CPLoL1oDrkI4jDu4MUddy53/z4nB8+rjaUdgKprGa0PjwKVFBzPrx7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kUdHmumx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kUdHmumx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58960C4CED3;
	Fri, 13 Dec 2024 01:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052026;
	bh=Fwjs/kBV21i3Odcw9HpOgGCPxlZ0GnJjW649x1tBc1c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kUdHmumxHV5BM2C2xtpPpnm7+0ZzPPjyEfKGehhtiIPNWVy2FxkJGRFoK8K0pMaVG
	 ApurqTwNmboe3ZvfulTKExqMdsUXpxWOfMQcsXEaDUenB+ODTY+YZYG5UJH/DyTimd
	 NlAOXhZlrmL+h652r71MUzZ+8Ax/nOwYQfAaRxU2Tg6uKOj+TxuTP1wIXOVn/E7YPW
	 god/QutJ+ICM8G5ynqgU+I38pB13s640RbmgEwLl+llmkX1UeA/9L8wQQ7C2F1X9op
	 9pOLGvz8uxH1YX/yco36/BuTqc9DxFQFkNs9Vqk2VS85SsMYig3XVBAbr75oHL+Zv7
	 /Sb8qFrbYxKWw==
Date: Thu, 12 Dec 2024 17:07:05 -0800
Subject: [PATCH 25/37] xfs: scrub the metadir path of rt rmap btree files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405123744.1181370.14108227241545412092.stgit@frogsfrogsfrogs>
In-Reply-To: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
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
directory tree path to the rmap btree file for each rt group.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h  |    3 ++-
 fs/xfs/scrub/metapath.c |    3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 34fcbcd0bcd5e3..d42d3a5617e314 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -830,9 +830,10 @@ struct xfs_scrub_vec_head {
 #define XFS_SCRUB_METAPATH_USRQUOTA	(5)  /* user quota */
 #define XFS_SCRUB_METAPATH_GRPQUOTA	(6)  /* group quota */
 #define XFS_SCRUB_METAPATH_PRJQUOTA	(7)  /* project quota */
+#define XFS_SCRUB_METAPATH_RTRMAPBT	(8)  /* realtime reverse mapping */
 
 /* Number of metapath sm_ino values */
-#define XFS_SCRUB_METAPATH_NR		(8)
+#define XFS_SCRUB_METAPATH_NR		(9)
 
 /*
  * ioctl limits
diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index c678cba1ffc3f7..74d71373e7edf1 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -21,6 +21,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_attr.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -246,6 +247,8 @@ xchk_setup_metapath(
 		return xchk_setup_metapath_dqinode(sc, XFS_DQTYPE_GROUP);
 	case XFS_SCRUB_METAPATH_PRJQUOTA:
 		return xchk_setup_metapath_dqinode(sc, XFS_DQTYPE_PROJ);
+	case XFS_SCRUB_METAPATH_RTRMAPBT:
+		return xchk_setup_metapath_rtginode(sc, XFS_RTGI_RMAP);
 	default:
 		return -ENOENT;
 	}

