Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF9D2837B
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995006; cv=none; b=l0oJbs3OexCcpjK4GTvGWKrI4CMhwIPsETRPMYLo3EGZZra9+kTPa6x5W4PQapjcJkpCXvu0aOvARQnuq1/aSw7rUIsNJVabHnwVE79Wc6z+KkFSnGEIppyGKfewJzZOlZ6YnVKV6c/CNtGegCFyx/OFk84ADt+FCi04V7rehbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995006; c=relaxed/simple;
	bh=U3TBYDb7zmIH7detoXHkxxvmFmSEFG4g0tZQbleAiko=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JuEElH9lO+Ax5HkuPHWwIfVH/Y5MbS6XVRm7hbOZr+fX6NfbbkiOgkKTFrZ52IZ0xEkkyV6IngA3F3WTurnjkcLXM1yQGZ2rb0J/NwM/yBz1cWI5fHop3CgN/THwz1fDOAR71gF8AKtDQ/i8ylizsyJ731fFRWuS18tlve3jtec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eC/coDDo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eC/coDDo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04039C4CED3;
	Mon, 23 Dec 2024 23:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995006;
	bh=U3TBYDb7zmIH7detoXHkxxvmFmSEFG4g0tZQbleAiko=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eC/coDDoKUO+dxvuoqYunAD8ni2yaNDoiZ6mv9F3dhHhTM8G/FYE819zr05CUBGWl
	 Y23ZnINSCJ3aMr9AMkY6JnljBn14wNMluXUR+bd4k41pgfBtbwiCec1JXp8HHfuQQx
	 KjgQiZcgQf+M60gmfbR9VT5X5bRyUvE4EFudEX/AMWTHRhi7ZdxNUuPZ+UNoxCZnXy
	 F4SC2cE0WqxvXSWBF/b8Su78Yo45lP+v8RLrNBF9fvzKcHE9cYZOAX9z+cOgiGDUSH
	 efgGx01z/dEr7J5Rf2Xz3P8ZeNiTKXxXgjo3KImZtFY2cJAEABIyuksCuEZmHMzSGa
	 EHDQhtfpgFiuQ==
Date: Mon, 23 Dec 2024 15:03:25 -0800
Subject: [PATCH 26/37] xfs: walk the rt reverse mapping tree when rebuilding
 rmap
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499419165.2380130.18199011295830240015.stgit@frogsfrogsfrogs>
In-Reply-To: <173499418610.2380130.12548657506222792394.stgit@frogsfrogsfrogs>
References: <173499418610.2380130.12548657506222792394.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When we're rebuilding the data device rmap, if we encounter an "rmap"
format fork, we have to walk the (realtime) rmap btree inode to build
the appropriate mappings.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/rmap_repair.c |   53 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index 2a0b9e3d0fbaee..91c17feb49768b 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -31,6 +31,8 @@
 #include "xfs_refcount.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_ag.h"
+#include "xfs_rtrmap_btree.h"
+#include "xfs_rtgroup.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -504,7 +506,56 @@ xrep_rmap_scan_meta_btree(
 	struct xrep_rmap_ifork	*rf,
 	struct xfs_inode	*ip)
 {
-	return -EFSCORRUPTED; /* XXX placeholder */
+	struct xfs_scrub	*sc = rf->rr->sc;
+	struct xfs_rtgroup	*rtg = NULL;
+	struct xfs_btree_cur	*cur = NULL;
+	enum xfs_rtg_inodes	type;
+	int			error;
+
+	if (rf->whichfork != XFS_DATA_FORK)
+		return -EFSCORRUPTED;
+
+	switch (ip->i_metatype) {
+	case XFS_METAFILE_RTRMAP:
+		type = XFS_RTGI_RMAP;
+		break;
+	default:
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	while ((rtg = xfs_rtgroup_next(sc->mp, rtg))) {
+		if (ip == rtg->rtg_inodes[type])
+			goto found;
+	}
+
+	/*
+	 * We should never find an rt metadata btree inode that isn't
+	 * associated with an rtgroup yet has ondisk blocks allocated to it.
+	 */
+	if (ip->i_nblocks) {
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+
+found:
+	switch (ip->i_metatype) {
+	case XFS_METAFILE_RTRMAP:
+		cur = xfs_rtrmapbt_init_cursor(sc->tp, rtg);
+		break;
+	default:
+		ASSERT(0);
+		error = -EFSCORRUPTED;
+		goto out_rtg;
+	}
+
+	error = xrep_rmap_scan_iroot_btree(rf, cur);
+	xfs_btree_del_cursor(cur, error);
+out_rtg:
+	xfs_rtgroup_rele(rtg);
+	return error;
 }
 
 /* Find all the extents from a given AG in an inode fork. */

