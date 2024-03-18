Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F68C59B59
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798621; cv=none; b=mSOf9q5Rct3H9Fqkls4VP8VWFLmfauFofSmbAk5Ovy1URMHbiit/f4USm4Y5zgzEbLlW50L/5+cPrVqXadQt41nofV3CqHtmu8vApDUE3ntYwAvQogrbQhIM/Ue3pwOBL4UXEkUPQg0fApW+UDy5Vlp1wUTRz44/GHIU4npe/ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798621; c=relaxed/simple;
	bh=cNQi+7EKFyyGRRO2CSyoNxcF7tigU80bRjedbNsXCks=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t4nsVlxkIrgVbvmaYKC3ZraXseIl7mG4d3b6DNJoEAceso7w9ryozu/UaboqrXf4gRMQ9bFhGkRaOyv9mllKfMBT9a/oiy53BpvsSEuKxHf7fFDmD9Shsl8bTeYD/cG2iYhTMj9+EAXLX/dfwE/jg1xYYzghqmfH+BhkKJe7TFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B4PCctHo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B4PCctHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24D9C433F1;
	Mon, 18 Mar 2024 21:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798621;
	bh=cNQi+7EKFyyGRRO2CSyoNxcF7tigU80bRjedbNsXCks=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=B4PCctHobBs5dISAFEOBZBEViYwvuhYsPgh1IDWZXsifzNB0iPTdXUji6HdEhCP9D
	 mNzvdoB6WRMbS5YI0A7UwMksn2Xvaxj93bIDHO3Syz91HAzFnC3bAn5vIDa4KsYBC1
	 byvG/jF6HbyPBFJY42C6kPzmP1dr3Vxy38EuU1mfpfl8hBtvazD+slitTpbc9z+Yd2
	 HhqCaGKFN0q6nQL3SEg8Pcnkw752f/p6SrfLVA65OVFDJGX+97DuZqqxxat37I5ATU
	 ZZJbK4sOEGrqw6yjADxAkmebr1klpTj2UHcjOezCiFlCLXjC4ZTa2T5Eels3CYcWEc
	 8kMnUTAdpF4Qg==
Date: Mon, 18 Mar 2024 14:50:20 -0700
Subject: [PATCH 09/23] xfs: check parent pointer xattrs when scrubbing
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802841.3808642.11240116549747491201.stgit@frogsfrogsfrogs>
In-Reply-To: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
References: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
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

Check parent pointer xattrs as part of scrubbing xattrs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 2ad109fdd1998..46cc284deaac9 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -17,6 +17,7 @@
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_attr_sf.h"
+#include "xfs_parent.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/dabtree.h"
@@ -205,6 +206,19 @@ xchk_xattr_actor(
 		return -ECANCELED;
 	}
 
+	/* Check parent pointer geometry. */
+	if (attr_flags & XFS_ATTR_PARENT) {
+		if (!xfs_has_parent(sc->mp)) {
+			xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, args.blkno);
+			return -ECANCELED;
+		}
+
+		if (!xfs_parent_valuecheck(sc->mp, value, valuelen)) {
+			xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, args.blkno);
+			return -ECANCELED;
+		}
+	}
+
 	/* Does this name make sense? */
 	if (!xfs_attr_namecheck(sc->mp, name, namelen, attr_flags)) {
 		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, args.blkno);

