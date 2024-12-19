Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129D81AAA0D
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636595; cv=none; b=BPQReBJH1vaSVbGgZ6AWDV2r9evdfVxJLRWwaDeDFPd3aZUjfdPD1nb864rdWOzTZFaznMAdx49tF3l9da8YRWERICUbUOjO+2VFr9TvX4IwP+gmlJ+on+uEZXZDMz33uvyQz3+3BuPdK07Zn07KDxLjGuA80qDoJ+jFgkWWRhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636595; c=relaxed/simple;
	bh=LJeeT8vzjOfPK1AQLMoUW6goHcDwk6tBYUGWmd0C5NM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dAzUyM3bw6ddhvTzJq58xG6juR+XlmJDU4Hc/C+NFb5tivKkN809uVk0psyWI44Z6akNB2sT8t5mMcF8TF+XAcFAwsEbOxrQJ5PfvI/YLIot3AqeGB++fiZcx6OPquWVdNWhybGQ9OE7V2x3AU1UDmMoOs15fbE16X8IR2Dfv3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dncuppDP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dncuppDP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C1DC4CECE;
	Thu, 19 Dec 2024 19:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636595;
	bh=LJeeT8vzjOfPK1AQLMoUW6goHcDwk6tBYUGWmd0C5NM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dncuppDPRGN2o4CIHLOR+y+1OArfE0UkvkvQbfnpkrtVEwttUSUWNFi1TRyn2Olo3
	 iOgNDIifCE3qwQAJ+T41KI+GrxcBi11yb+IoirNTessrpBzJSStr+96xziOO3x0Aug
	 Rct1fUiVLBL+LGnF8V2surLP9QaYk582jksPDpciRZ2tz31l4FRu63jRjMD3pvzI64
	 ezRkIu2fo5/V9cYMgbZFKSwsJ2MnmvT0FhUJRR8z7m7cx/S6PdaYfPMdxhtq4HoyVa
	 pRSrr2WIKYN5TQ0h6s/XXe5vAKwVajr+G5KuHP2Wq9T29K+jSua134QBRT6xvSrlQx
	 Uj1rv7YZp3BUg==
Date: Thu, 19 Dec 2024 11:29:54 -0800
Subject: [PATCH 25/37] xfs: scrub the metadir path of rt rmap btree files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463580186.1571512.12757790342325928102.stgit@frogsfrogsfrogs>
In-Reply-To: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
References: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

