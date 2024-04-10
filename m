Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC3F391
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 01:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712711006; cv=none; b=AGhvSzW2LUNV6SHpTGHuckXE0r7+sErh865Mvk+q6H4CpQ2PvzOwiHBnbm2ooMBb94ltbejzWOSc0GTZzL1uXUhDXQgVPWUb3nNnU8Bwp7ersSYAzdkOqqZUoQj+95bIm2GK/eZBS1GLMgrfNa2us8BQAWLyH9KuVIRkQHb4C6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712711006; c=relaxed/simple;
	bh=q6exp7NnZBLsf4xo43lDb7Y3SZNtQQlJqRCE1Erm6GM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZqlE5y3g6o90lL4xn42DLhVJOc0zS6Wb8WJ68K895IW5lW9rkggLv6LVZEu6x4HR+arjSonoWk6VXOy9dAEl/Iae9KfWqfIYa5eItiCNkIKbaMr4SDi9D8JBe7Am3dC1YPCGlvlF1uWy0vSOCddnidI69tteZZZU718g1HQ4fBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XDx+9JgJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XDx+9JgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BD6C433F1;
	Wed, 10 Apr 2024 01:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712711005;
	bh=q6exp7NnZBLsf4xo43lDb7Y3SZNtQQlJqRCE1Erm6GM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XDx+9JgJFhg+281SJL/gIX35PCC31tKyxQVvsffUDJmBXkcw9RVEFQUiXEg9/Uf4o
	 a8D5ScXAbKh+26MQop1lzOgIpMhCt4euHHAVtaTN86eoWXxbc9LP1O4obDuDdx2lVq
	 wEnbRYE/C+sn3eVRol6sAA4IJUnxkGlA6sd1uGCDUMZ+NgAryOLAervnXEuRmH8Nzy
	 LzQpBLc4vEgbPFrMBAF36rkQnMqvtXBj29xGhjr7VRpQoQO7Jyuow195l1QYOrMTy3
	 u2YDOuNVlUyuSiM3R46DcD7GPxC/cmx2p9UdUmNXRctsuIwiznM8SmZVt8vkQjPWKS
	 sDudvBjVovtHA==
Date: Tue, 09 Apr 2024 18:03:25 -0700
Subject: [PATCH 6/7] xfs: check parent pointer xattrs when scrubbing
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270970567.3632713.8784234263889465896.stgit@frogsfrogsfrogs>
In-Reply-To: <171270970449.3632713.16827511408040390390.stgit@frogsfrogsfrogs>
References: <171270970449.3632713.16827511408040390390.stgit@frogsfrogsfrogs>
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
 fs/xfs/scrub/attr.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index fe51a17661831..b91234bbd58aa 100644
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
@@ -208,6 +209,13 @@ xchk_xattr_actor(
 		return -ECANCELED;
 	}
 
+	/* Check parent pointer record. */
+	if ((attr_flags & XFS_ATTR_PARENT) &&
+	    !xfs_parent_valuecheck(sc->mp, value, valuelen)) {
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, args.blkno);
+		return -ECANCELED;
+	}
+
 	/*
 	 * Local and shortform xattr values are stored in the attr leaf block,
 	 * so we don't need to retrieve the value from a remote block to detect

