Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB2739FD9
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052747; cv=none; b=gtFuoSo00hKJJRoCLtusqrlZRgT2+cZj+uf/Agm+2FSbHsXi9G9avtyyjHLXTEddUTxbB0A+aNCffDEXZUltAENGKKbUsFSaKNID4yuqOs+hOI0doEUVAFXP+q/JeMbeVhkBGQSzi4Lh3w2r//cILJNqmVVxhO/Osx7XH3QP98Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052747; c=relaxed/simple;
	bh=FO9w6D7Rd/QBwNtk8zpN83wA4kZ3cXihwq2rw2NyP9I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JWc0i4ledVDhY6gO3IoVOZmc9OrD/O8yF/+aKW6IsgVSxAZgveHiqOoEzAYsWJ7VJJaYZVI3rY2LebB9Df8n3iu7WQZX3UT8a0c3DpH0afUmJL/nAkxQT9ygZ8zvan3Vm69fzIEpeS+HaOJYiF1icPQo2nq01jb0nPSU32qTlRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aifb5EOB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aifb5EOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10A0C4CECE;
	Fri, 13 Dec 2024 01:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052746;
	bh=FO9w6D7Rd/QBwNtk8zpN83wA4kZ3cXihwq2rw2NyP9I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aifb5EOBrlRf3pEO2z4sM81JGVoyjOmrvZ/nQmkgdigulfczGHM8FmGdPuy2xliHr
	 In4smTfdWgvKuTOo4H+MAXTTBDwnWUr1z0Y06qbE6+fbZqNjuc7Cgi697jduOvhrJx
	 iIdDZwmQjJjHGMfw+Mu7gsq8vT32vkJcsrf4HAD0J7+1tG8AteHpsTBLYTJ3NtSGBt
	 hwd3cDMV+qHfRR3UB9lwaup8xYwdz426pBxPll9CYbHwCr8s0oiowd5e50a+eZXGov
	 KvvJ60+qiBT7ayhQ09TrI4py+oT2Rpb740jgy/teemkeJ9qFwOrH/sUVLqF4g0OF1w
	 mvxIJpLjXz5Ew==
Date: Thu, 12 Dec 2024 17:19:06 -0800
Subject: [PATCH 34/43] xfs: scrub the metadir path of rt refcount btree files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405125149.1182620.2553301724738000525.stgit@frogsfrogsfrogs>
In-Reply-To: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
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

