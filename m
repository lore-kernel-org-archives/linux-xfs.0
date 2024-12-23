Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605A313FEE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995756; cv=none; b=RJW1Hn8B0k0iuQ53ElGg9AJBy1I5Gl5royI+8DruvIsth6n7EJAVJ25ClX9r7zPmtJMW4ZDOfl09lXGOxmyg9VPlEulfHh2rg0abZS93H25Uofe//BD8+tXTvHiR5Mt3qXLE3cZPEhc1gPGex3qg8zulYDXEBTr4y1r7FZgRKuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995756; c=relaxed/simple;
	bh=iI5tUM+wvRKl+6u+sdByVM+n9xG2zRFkrO8UBgUzFSM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tr/NPp+Ize5q5VgB+Q01GHfr2Ds+IESCpmi0RIbPOJP6nTDq4SbN0HqAUZJm32aJWuMYNGMNme/L1OjX5v3UcXbFyF2SJ0ZXfSzXivaU1gzsr+JohWo7ftvN2I4lZHLQXXzvr8cmwPzVD5R6fAYsTqfkQuGrkVeOxN4f+wyJO1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FcgZWJSv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FcgZWJSv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2511C4CED3;
	Mon, 23 Dec 2024 23:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995756;
	bh=iI5tUM+wvRKl+6u+sdByVM+n9xG2zRFkrO8UBgUzFSM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FcgZWJSvMhC33Flud4BxYIMp8u+UsJRZasu2Ry4CzPmoe5bYZ6tpB9zNcVQMj5hSM
	 2qFTZDcIsTF9F+yNZANW6RFz7rOX/7sfItQGALe1DjLDCx6ciF46fdxuJ4BD8UfVq8
	 VWvy/1Bq8jCksPJnsWrkdFP3ZypFgXyhwyDyagGtPgF74j0M9LM0BAaG1Gd64wLqqe
	 nyEWYjInq9Z4Ws/ac3eIsgiajDDAJoxw59QPXprNEPzWuB2kLfM4pVOolyYB9z2VGn
	 X3NyUWCrGsJRHrjWhxK2UIDoFV63pcqVQhuwYYtGOrIN4bxkGcc/goA3DZf43sWTVO
	 NoxSL4offIMTA==
Date: Mon, 23 Dec 2024 15:15:55 -0800
Subject: [PATCH 37/43] xfs: walk the rt reference count tree when rebuilding
 rmap
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420571.2381378.17675139072688744141.stgit@frogsfrogsfrogs>
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

