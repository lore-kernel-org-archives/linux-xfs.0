Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AA049483A
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 11:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435684; cv=none; b=JTzyUtE98ZMmNQtgWlS0T3jvqsw3FDMWjP4bU/ZnamS5N2bsVrGljj3BiYK26N+cU1kqW7XeoR4O7j7zc4Z8hjjQ+V3hzAEsRZe9LGhMkc6iVUGItQgZAkWgRvKk/1kq71H+WzZMsuNgGr80kmYeNu7bRnpnfM9xAwe0mYlFLPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435684; c=relaxed/simple;
	bh=Ua76YFNzCK7tc93yuAxSN9PD/kq66oFtAygVYa0whxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SMMdDdXVIgVQtTjznGkzVw95z+zzvZtTOTkgXJuc0YOwQngkcZ1QvKspsLdxEs5yhgWFloj4s6ZUq6mN3+lKTVYgoHJRF5T450cH1aDh7deEfe4UwgniTkalry+mVRSm7NDiRwAh5XiAGwTe9AS7kwGG13SebkKJGV96levsxRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RXGgUIJr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RXGgUIJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382AF1F00A3D;
	Thu,  3 Sep 2026 11:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788435673;
	bh=+UqEMty/gAaaPiTaecOWjWPqr9RbwBYVGYGEFmP5U5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RXGgUIJr94RYeZC1n1unSF3x/2hY+woTYQofDOciXF05UUrdODI97/4j5nV5VjKh2
	 vrnMhDg8KmGuTxIdid7XqBCiKnovi4QZCjjk5FO5HM7T09bk7UG+0ang64Pi7uycFY
	 mjQVhaAHgnOduhtVwovd1cEV0fNGV7AocD2xiEsnPyPz0I5q8YOBKUXMwsNsC3zxkT
	 iW4NFDY4VIrlvEqJuScJGwQUSQ5dCyJUO4hmBNLtduHV8RTrHMl/IEB0IwtW9Qq2ZC
	 GFVCxCHE2hVvK9K5LuqkRdg2t/YeC0+JBKv4Qaen77lyW22yCiDx5iRMwIgvQp23EW
	 ZVee/ffsdwtAQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	aalbersh@kernel.org
Cc: bestswngs@gmail.com,
	brauner@kernel.org,
	cem@kernel.org,
	chuck.lever@oracle.com,
	cmaiolino@redhat.com,
	dawei.feng@seu.edu.cn,
	djwong@kernel.org,
	gaoyingjie@uniontech.com,
	hch@lst.de,
	jiapenglin@tencent.com,
	roland.mainz@nrubsig.org,
	xmei5@asu.edu
Subject: [PATCH v2 08/23] xfs: add a xfs_rmap_inode_owner helper
Date: Thu,  3 Sep 2026 13:39:50 +0200
Message-ID: <20260903114022.570210-9-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903114022.570210-1-aalbersh@kernel.org>
References: <20260903114022.570210-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: f882fc7dd9f04f73d94379deb9e68d8db613c976

Add a small wrapper for initializing the rmap owner to i_ino.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap.c | 2 +-
 libxfs/xfs_rmap.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 1bd65a0cba26..23cc5bb46272 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -813,7 +813,7 @@ xfs_bmap_local_to_extents(
 	args.mp = ip->i_mount;
 	args.total = total;
 	args.minlen = args.maxlen = args.prod = 1;
-	xfs_rmap_ino_owner(&args.oinfo, ip->i_ino, whichfork, 0);
+	xfs_rmap_inode_owner(&args.oinfo, ip, whichfork, 0);
 
 	/*
 	 * Allocate a block.  We know we need only one, since the
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 7188459f61cf..6016fd5fcad9 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -37,6 +37,8 @@ xfs_rmap_ino_owner(
 	if (whichfork == XFS_ATTR_FORK)
 		oi->oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
 }
+#define xfs_rmap_inode_owner(oi, ip, whichfork, offset) \
+	xfs_rmap_ino_owner(oi, (ip)->i_ino, whichfork, offset)
 
 static inline bool
 xfs_rmap_should_skip_owner_update(
-- 
2.55.0

