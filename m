Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC951990BA
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734637361; cv=none; b=JNFfMzLODl+SBPpoXtDLUt10m1zgd2YxvqEJYJ7ZxwiyQUVN2f1rE+pEhIw7q817rTurma8/swKXmekRvdlO7jlTa+Rl6QYkqX64ibsiZvTQH4NdVMylIo+9fXQM2Sy5jA5EOL0L0Po1WUB9B2TI71KSopmR4U6KDhjkkMHuENw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734637361; c=relaxed/simple;
	bh=iI5tUM+wvRKl+6u+sdByVM+n9xG2zRFkrO8UBgUzFSM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m96qoUXVvXWDQB2LRvpT++hPA71++0ZMoE69otWwSS0PAeoe0o9JRlutO9EQ/McG0gcQBH0u59ZJpeESSAFxreCJ0D5u3aYbWSQXWvOrTF6n8XejIe/tquyU07H5j8sZRV4DOXcvisKjMjjftsaZQm8JSwtVLjc4PD+qry74KxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nkU7A+Cj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nkU7A+Cj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0B3C4CECE;
	Thu, 19 Dec 2024 19:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734637360;
	bh=iI5tUM+wvRKl+6u+sdByVM+n9xG2zRFkrO8UBgUzFSM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nkU7A+CjJDAjznjgznYRt9EkOOsHaCcB+l0UnV0A138i32DYwSVOYzxLMz/h3m+dh
	 sVGQ6XlnjzlZE4UzzreFb5+CUeTnLN1eRgqz4fipJ3Qb6E0BvkYPOArUqjOz3Kv0gD
	 E6DYLsxFKQ21/bU3ont5fZX6IOdYNCDXY5dD0rwZSahKiwky7JJVcx8YFWaXlMa5eK
	 NY142SfAFlXxXix0dMZqqg7+ha/cQQQgbB4ZKEqhLIMRTMn2BnR/JWjBhWkwqU8+dC
	 Syl7NOmo1NS5Unq6c/I/cIugHTdc/38RBjtXCyY70YdOttuZFP+82Eu0KuXE6uWi4z
	 gy8eb3ZOe62ow==
Date: Thu, 19 Dec 2024 11:42:40 -0800
Subject: [PATCH 37/43] xfs: walk the rt reference count tree when rebuilding
 rmap
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463581611.1572761.1500482126048341897.stgit@frogsfrogsfrogs>
In-Reply-To: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
References: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When we're rebuilding the data device rmap, if we encounter a "refcount"
format fork, we have to walk the (realtime) refcount btree inode to
build the appropriate mappings.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/rmap_repair.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index c2c7b76cc25ab8..f5f73078ffe29d 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -33,6 +33,7 @@
 #include "xfs_ag.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtrefcount_btree.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -519,6 +520,9 @@ xrep_rmap_scan_meta_btree(
 	case XFS_METAFILE_RTRMAP:
 		type = XFS_RTGI_RMAP;
 		break;
+	case XFS_METAFILE_RTREFCOUNT:
+		type = XFS_RTGI_REFCOUNT;
+		break;
 	default:
 		ASSERT(0);
 		return -EFSCORRUPTED;
@@ -545,6 +549,9 @@ xrep_rmap_scan_meta_btree(
 	case XFS_METAFILE_RTRMAP:
 		cur = xfs_rtrmapbt_init_cursor(sc->tp, rtg);
 		break;
+	case XFS_METAFILE_RTREFCOUNT:
+		cur = xfs_rtrefcountbt_init_cursor(sc->tp, rtg);
+		break;
 	default:
 		ASSERT(0);
 		error = -EFSCORRUPTED;

