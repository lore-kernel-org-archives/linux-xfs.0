Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040A2143746
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718925299; cv=none; b=CWKSnhYZNLxYFamW96qWlzhHfbdad9DerQC6C71Z3JeYX4l9OKumkIgeycOFtiU15pKqeqgmm8UZoSO4dOuyzBYL1mLv1P0y4N2kepKjKi3cE5aQu0FOsC/E8hQeOfDJgpN6T2TUftxQylXH4JNXSec5Iqg/5zey7RRaz0+YMY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718925299; c=relaxed/simple;
	bh=PYAsbZHpUYq3rmnmpeEGsbiuFMumhVIEI8YJErzyRhc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bP4sraxQ+x2atMF8qcAdjYIAWuCEJkHNXVMUOVAqt9qRZ8IZM6zuB5a5wEj4EAKwfTkVhxa/3nNXwNC5ECJDAlW4RODZyZXw8E7DqyXyrWv93XeS6/5hASJfgWU1p4l7m52f9b50/8ydUU/EI3wuL9KFU/UaTBZF+8PevNj1nVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JSZ2gtdg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JSZ2gtdg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A357C2BD10;
	Thu, 20 Jun 2024 23:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718925298;
	bh=PYAsbZHpUYq3rmnmpeEGsbiuFMumhVIEI8YJErzyRhc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JSZ2gtdgSeIR2gYXOAUNHCShfOgB2jMhJbk/A761JVp+ErvDmTD04SpmtU5RDiNIT
	 pYBHDBRYisYUFXzPs9yae7NKnfroGt0tEE5eGm5eLv6AM/j+tOIwDj1hR2nkAUB1yr
	 vdKqaDYGp07zhzPC7aokJu56dSs44CQLU7WGd3PADbB89cWqw+Nmvxu187yQd3usYs
	 D9BpGtKV+3VG8V79Iar4x4OKc7cJBjjTQmopmfoY/qHqFwnkcoqZ93iEuc4uFwp6gO
	 EeIVX5fYxOqZ5ZE+xY8Ybfg5yxTn/cBqspdtpNEZ9ai2p+ebcY4zV/0pnTv08AbAst
	 fmQL+mbJEGSUw==
Date: Thu, 20 Jun 2024 16:14:58 -0700
Subject: [PATCH 6/6] xfs: honor init_xattrs in xfs_init_new_inode for !ATTR fs
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, chandanbabu@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171892459334.3192151.413694580283882579.stgit@frogsfrogsfrogs>
In-Reply-To: <171892459218.3192151.10366641366672957906.stgit@frogsfrogsfrogs>
References: <171892459218.3192151.10366641366672957906.stgit@frogsfrogsfrogs>
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

xfs_init_new_inode ignores the init_xattrs parameter for filesystems
that do not have ATTR enabled.  As a result, the first init_xattrs file
to be created by the kernel will not have an attr fork created to store
acls.  Storing that first acl will add ATTR to the superblock flags, so
subsequent files will be created with attr forks.  The overhead of this
is so small that chances are that nobody has noticed this behavior.

However, this is disastrous on a filesystem with parent pointers because
it requires that a new linkable file /must/ have a pre-existing attr
fork, and the parent pointers code uses init_xattrs to create that fork.
The preproduction version of mkfs.xfs used to set this, but the V5 sb
verifier only requires ATTR2, not ATTR.  There is no guard for
filesystems with (PARENT && !ATTR).

It turns out that I misunderstood the two flags -- ATTR means that we at
some point created an attr fork to store xattrs in a file; ATTR2
apparently means only that inodes have dynamic fork offsets or that the
filesystem was mounted with the "attr2" option.

Fixes: 2442ee15bb1e ("xfs: eager inode attr fork init needs attr feature awareness")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b699fa6ee3b6..aa134687027c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -42,6 +42,7 @@
 #include "xfs_pnfs.h"
 #include "xfs_parent.h"
 #include "xfs_xattr.h"
+#include "xfs_sb.h"
 
 struct kmem_cache *xfs_inode_cache;
 
@@ -870,9 +871,16 @@ xfs_init_new_inode(
 	 * this saves us from needing to run a separate transaction to set the
 	 * fork offset in the immediate future.
 	 */
-	if (init_xattrs && xfs_has_attr(mp)) {
+	if (init_xattrs) {
 		ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
 		xfs_ifork_init_attr(ip, XFS_DINODE_FMT_EXTENTS, 0);
+
+		if (!xfs_has_attr(mp)) {
+			spin_lock(&mp->m_sb_lock);
+			xfs_add_attr(mp);
+			spin_unlock(&mp->m_sb_lock);
+			xfs_log_sb(tp);
+		}
 	}
 
 	/*

