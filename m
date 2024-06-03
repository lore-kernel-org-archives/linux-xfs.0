Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDDF259C
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441349; cv=none; b=lGQ9HbA3fR6xBqFPq1x4P25CzBHDg3xE68NoKgQ29dkOOmm9wxybGvdAVknViqGsXz2azEp4hNwoKN/GKO4Qwmd21X/0MSKL4CkKjHqioMRZlZSHcyk1loLWG5gxwwFAK1htFDdQXQWXMFWWxkaNy7U0qcWkwbn99aeAsFqAUYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441349; c=relaxed/simple;
	bh=JCjMln1/QCpo/82ZBzWrwZYtKaCJcm9g6B5j7bDwP/o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q1RIOU8X/g96T42FleA+9V2Zsn5kSrlHJist1Wxj4cIBcT/1LNW9PR122ggIQQST2V4cDq4E7SdgEYY6HrvOPVZrWuDFW8GWXjJnJh4U4kftahL+InaHz6nT0ZdfXFp35bmz3+BVEAVXBnrlr1rOPsYRNNjppXV2wKs7MdVzv7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hnXVyuRU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hnXVyuRU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88AD6C2BD10;
	Mon,  3 Jun 2024 19:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441349;
	bh=JCjMln1/QCpo/82ZBzWrwZYtKaCJcm9g6B5j7bDwP/o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hnXVyuRU9L5Hhe2xZYHOIPHdKr7RE5IoM9w9XWemzAFAD3M0q5PtfX9BflF4b3kpj
	 QX5p1CE6hHzetNBPMk6i0D9MaeAdN90l3axzZxaBjcl8O3j6HV1Nq8/Kz/ycUwIGQT
	 vSeb18EMRr7sChGmWD1hulO9QV87XyuEq/dq79pT20DrbJ3Ef2w5GyzedY1oGDex2E
	 ZrqFj694XL+kO92vT/VDn/ILwhdS0Gz4L20EbCkfP1Oy1CrKCbXdtyMwesd/J+jpui
	 d7eTG+D7PDg5d2o9WNxTeMQ7fBwDBZEldNYK7snX/UmgxFTJT/HllsVHAhqA8qo8Ff
	 jTTtdVNDoHDRQ==
Date: Mon, 03 Jun 2024 12:02:29 -0700
Subject: [PATCH 040/111] xfs: remove the unnecessary daddr paramter to
 _init_block
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744039974.1443973.7121388776320866379.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Source kernel commit: 11388f6581f40e7d5a69ce5f8b13264eca7c2c5c

Now that all of the callers pass XFS_BUF_DADDR_NULL as the daddr
parameter, we can elide that too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_bmap_btree.c    |    4 ++--
 libxfs/xfs_btree.c         |   19 ++++++++++++++++---
 libxfs/xfs_btree.h         |    2 +-
 libxfs/xfs_btree_staging.c |    5 ++---
 4 files changed, 21 insertions(+), 9 deletions(-)


diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 65ba3ae8a..2d8411809 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -37,8 +37,8 @@ xfs_bmbt_init_block(
 		xfs_btree_init_buf(ip->i_mount, bp, &xfs_bmbt_ops, level,
 				numrecs, ip->i_ino);
 	else
-		xfs_btree_init_block(ip->i_mount, buf, &xfs_bmbt_ops,
-				XFS_BUF_DADDR_NULL, level, numrecs, ip->i_ino);
+		xfs_btree_init_block(ip->i_mount, buf, &xfs_bmbt_ops, level,
+				numrecs, ip->i_ino);
 }
 
 /*
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 372a521c1..2386084a5 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1150,8 +1150,8 @@ xfs_btree_set_sibling(
 	}
 }
 
-void
-xfs_btree_init_block(
+static void
+__xfs_btree_init_block(
 	struct xfs_mount	*mp,
 	struct xfs_btree_block	*buf,
 	const struct xfs_btree_ops *ops,
@@ -1192,6 +1192,19 @@ xfs_btree_init_block(
 	}
 }
 
+void
+xfs_btree_init_block(
+	struct xfs_mount	*mp,
+	struct xfs_btree_block	*block,
+	const struct xfs_btree_ops *ops,
+	__u16			level,
+	__u16			numrecs,
+	__u64			owner)
+{
+	__xfs_btree_init_block(mp, block, ops, XFS_BUF_DADDR_NULL, level,
+			numrecs, owner);
+}
+
 void
 xfs_btree_init_buf(
 	struct xfs_mount		*mp,
@@ -1201,7 +1214,7 @@ xfs_btree_init_buf(
 	__u16				numrecs,
 	__u64				owner)
 {
-	xfs_btree_init_block(mp, XFS_BUF_TO_BLOCK(bp), ops,
+	__xfs_btree_init_block(mp, XFS_BUF_TO_BLOCK(bp), ops,
 			xfs_buf_daddr(bp), level, numrecs, owner);
 }
 
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 56901d259..80be40ca8 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -440,7 +440,7 @@ void xfs_btree_init_buf(struct xfs_mount *mp, struct xfs_buf *bp,
 		__u64 owner);
 void xfs_btree_init_block(struct xfs_mount *mp,
 		struct xfs_btree_block *buf, const struct xfs_btree_ops *ops,
-		xfs_daddr_t blkno, __u16 level, __u16 numrecs, __u64 owner);
+		__u16 level, __u16 numrecs, __u64 owner);
 
 /*
  * Common btree core entry points.
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index 47ef8e23a..39e95a771 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -410,9 +410,8 @@ xfs_btree_bload_prep_block(
 		ifp->if_broot_bytes = (int)new_size;
 
 		/* Initialize it and send it out. */
-		xfs_btree_init_block(cur->bc_mp, ifp->if_broot,
-				cur->bc_ops, XFS_BUF_DADDR_NULL, level,
-				nr_this_block, cur->bc_ino.ip->i_ino);
+		xfs_btree_init_block(cur->bc_mp, ifp->if_broot, cur->bc_ops,
+				level, nr_this_block, cur->bc_ino.ip->i_ino);
 
 		*bpp = NULL;
 		*blockp = ifp->if_broot;

