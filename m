Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCDD320A24
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291670; cv=none; b=lYVqBBUs9ZTUqkn4s7pc3g1z2c3w6ytowNFblNwf4nhh2XAbGa1UiPucyIT+zBOZWt1TOIoBD9vDGotlPAse4PynnzxmXszn1ueM5vp6IgAaMWjibxxCUyZcp0jUR/EjqF8hIwy5iWHNz3eGzRyfScg4DLFNhbF11+tD0TBmaW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291670; c=relaxed/simple;
	bh=Ca+B02oQnuAx+LIzczob2KDb6Rp8AQP6XDyHsTqDkm4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CO9PYI9FDsZkG7kYG+ooVlyl21pR3CjIMLu5j6AV7B4QfmafJ0Vh8r9vo2Zg7/uQC7Dr5i+DnzLaWHmOHfzVV/PioAZ4YOdIlNPTAI40SPTITR/PcnkWfHOZ2vEydQfvK80HMDor4Dg5tpfLAQSy3ecBuaC4uWCYy7R0vtcDilA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RLAmGT5s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RLAmGT5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210A4C4CEF7;
	Mon, 23 Mar 2026 18:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291670;
	bh=Ca+B02oQnuAx+LIzczob2KDb6Rp8AQP6XDyHsTqDkm4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RLAmGT5srm3ZNHyc7zFYdX4K5tarYoS6vDzCE2D0L1p533UKkT7D0+0jmm+Zsgm8+
	 yPCbsf2JsR2gueIVpFmHnCH4zMp4evZRiRxTmo+nIQCozhwc8n+qPXI4KGrZjk5Deh
	 FCk8XXUe8I1DdQLdgaUqoNwY6rSdSEJQLlgrEDRiwpCs9IR4H2qPh7VtCqCJTHsCxi
	 vxRqy1ru4zBTn/CxFjTkq6jkeCcV92bExot+x0h5lJD/JK4m+sJT8uqNq0uLOQmace
	 bvFKv0tESzDBkv2jG/UuVuLZkUtrwZogH6/uTp1ozeByHCojBxxudQlWE07weAw4Yy
	 epJN5iI8W8C+w==
Date: Mon, 23 Mar 2026 11:47:49 -0700
Subject: [PATCH 25/40] xfs: speed up parent pointer operations when possible
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177429121200.2266274.10763636382935688064.stgit@frogsfrogsfrogs>
In-Reply-To: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: d693534513d8dcdaafcf855986d0fe0476a47462

After a recent fsmark benchmarking run, I observed that the overhead of
parent pointers on file creation and deletion can be a bit high.  On a
machine with 20 CPUs, 128G of memory, and an NVME SSD capable of pushing
750000iops, I see the following results:

$ mkfs.xfs -f -l logdev=/dev/nvme1n1,size=1g /dev/nvme0n1 -n parent=0
meta-data=/dev/nvme0n1           isize=512    agcount=40, agsize=9767586 blks
=                       sectsz=4096  attr=2, projid32bit=1
=                       crc=1        finobt=1, sparse=1, rmapbt=1
=                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
=                       exchange=0   metadir=0
data     =                       bsize=4096   blocks=390703440, imaxpct=5
=                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
log      =/dev/nvme1n1           bsize=4096   blocks=262144, version=2
=                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
=                       rgcount=0    rgsize=0 extents
=                       zoned=0      start=0 reserved=0

So we created 40 AGs, one per CPU.  Now we create 40 directories and run
fsmark:

$ time fs_mark  -D  10000  -S  0  -n  100000  -s  0  -L  8 -d ...
# Version 3.3, 40 thread(s) starting at Wed Dec 10 14:22:07 2025
# Sync method: NO SYNC: Test does not issue sync() or fsync() calls.
# Directories:  Time based hash between directories across 10000 subdirectories with 180 seconds per subdirectory.
# File names: 40 bytes long, (16 initial bytes of time stamp with 24 random bytes at end of name)
# Files info: size 0 bytes, written with an IO size of 16384 bytes per write
# App overhead is time in microseconds spent in the test not doing file writing related system calls.

parent=0               parent=1
==================     ==================
real    0m57.573s      real    1m2.934s
user    3m53.578s      user    3m53.508s
sys     19m44.440s     sys     25m14.810s

$ time rm -rf ...

parent=0               parent=1
==================     ==================
real    0m59.649s      real    1m12.505s
user    0m41.196s      user    0m47.489s
sys     13m9.566s      sys     20m33.844s

Parent pointers increase the system time by 28% overhead to create 32
million files that are totally empty.  Removing them incurs a system
time increase of 56%.  Wall time increases by 9% and 22%.

For most filesystems, each file tends to have a single owner and not
that many xattrs.  If the xattr structure is shortform, then all xattr
changes are logged with the inode and do not require the the xattr
intent mechanism to persist the parent pointer.

Therefore, we can speed up parent pointer operations by calling the
shortform xattr functions directly if the child's xattr is in short
format.  Now the overhead looks like:

$ time fs_mark  -D  10000  -S  0  -n  100000  -s  0  -L  8 -d ...

parent=0               parent=1
==================     ==================
real    0m58.030s      real    1m0.983s
user    3m54.141s      user    3m53.758s
sys     19m57.003s     sys     21m30.605s

$ time rm -rf ...

parent=0               parent=1
==================     ==================
real    0m58.911s      real    1m4.420s
user    0m41.329s      user    0m45.169s
sys     13m27.857s     sys     15m58.564s

Now parent pointers only increase the system time by 8% for creation and
19% for deletion.  Wall time increases by 5% and 9% now.

Close the performance gap by creating helpers for the attr set, remove,
and replace operations that will try to make direct shortform updates,
and fall back to the attr intent machinery if that doesn't work.  This
works for regular xattrs and for parent pointers.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr.h   |    6 +++
 libxfs/xfs_attr.c   |   99 +++++++++++++++++++++++++++++++++++++++++++++++++--
 libxfs/xfs_parent.c |   14 ++++---
 3 files changed, 109 insertions(+), 10 deletions(-)


diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 0e51d0723f9aa3..8244305949deb9 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -573,7 +573,7 @@ struct xfs_trans_res xfs_attr_set_resv(const struct xfs_da_args *args);
  */
 static inline bool
 xfs_attr_is_shortform(
-	struct xfs_inode    *ip)
+	const struct xfs_inode    *ip)
 {
 	return ip->i_af.if_format == XFS_DINODE_FMT_LOCAL ||
 	       (ip->i_af.if_format == XFS_DINODE_FMT_EXTENTS &&
@@ -649,4 +649,8 @@ void xfs_attr_intent_destroy_cache(void);
 int xfs_attr_sf_totsize(struct xfs_inode *dp);
 int xfs_attr_add_fork(struct xfs_inode *ip, int size, int rsvd);
 
+int xfs_attr_setname(struct xfs_da_args *args, int rmt_blks);
+int xfs_attr_removename(struct xfs_da_args *args);
+int xfs_attr_replacename(struct xfs_da_args *args, int rmt_blks);
+
 #endif	/* __XFS_ATTR_H__ */
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 175f8572b0f930..0b45e72b5478b4 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1027,6 +1027,91 @@ xfs_attr_add_fork(
 	return error;
 }
 
+/*
+ * Decide if it is theoretically possible to try to bypass the attr intent
+ * mechanism for better performance.  Other constraints (e.g. available space
+ * in the existing structure) are not considered here.
+ */
+static inline bool
+xfs_attr_can_shortcut(
+	const struct xfs_inode	*ip)
+{
+	return xfs_inode_has_attr_fork(ip) && xfs_attr_is_shortform(ip);
+}
+
+/* Try to set an attr in one transaction or fall back to attr intents. */
+int
+xfs_attr_setname(
+	struct xfs_da_args	*args,
+	int			rmt_blks)
+{
+	int			error;
+
+	if (!rmt_blks && xfs_attr_can_shortcut(args->dp)) {
+		args->op_flags |= XFS_DA_OP_ADDNAME;
+
+		error = xfs_attr_try_sf_addname(args);
+		if (error != -ENOSPC)
+			return error;
+	}
+
+	xfs_attr_defer_add(args, XFS_ATTR_DEFER_SET);
+	return 0;
+}
+
+/* Try to remove an attr in one transaction or fall back to attr intents. */
+int
+xfs_attr_removename(
+	struct xfs_da_args	*args)
+{
+	if (xfs_attr_can_shortcut(args->dp))
+		return xfs_attr_sf_removename(args);
+
+	xfs_attr_defer_add(args, XFS_ATTR_DEFER_REMOVE);
+	return 0;
+}
+
+/* Try to replace an attr in one transaction or fall back to attr intents. */
+int
+xfs_attr_replacename(
+	struct xfs_da_args	*args,
+	int			rmt_blks)
+{
+	int			error;
+
+	if (rmt_blks || !xfs_attr_can_shortcut(args->dp)) {
+		xfs_attr_defer_add(args, XFS_ATTR_DEFER_REPLACE);
+		return 0;
+	}
+
+	args->op_flags |= XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE;
+
+	error = xfs_attr_sf_removename(args);
+	if (error)
+		return error;
+
+	if (args->attr_filter & XFS_ATTR_PARENT) {
+		/*
+		 * Move the new name/value to the regular name/value slots and
+		 * zero out the new name/value slots because we don't need to
+		 * log them for a PPTR_SET operation.
+		 */
+		xfs_attr_update_pptr_replace_args(args);
+		args->new_name = NULL;
+		args->new_namelen = 0;
+		args->new_value = NULL;
+		args->new_valuelen = 0;
+	}
+	args->op_flags &= ~XFS_DA_OP_REPLACE;
+
+	error = xfs_attr_try_sf_addname(args);
+	if (error != -ENOSPC)
+		return error;
+
+	xfs_attr_defer_add(args, XFS_ATTR_DEFER_SET);
+	return 0;
+}
+
 /*
  * Make a change to the xattr structure.
  *
@@ -1107,14 +1192,19 @@ xfs_attr_set(
 	case -EEXIST:
 		if (op == XFS_ATTRUPDATE_REMOVE) {
 			/* if no value, we are performing a remove operation */
-			xfs_attr_defer_add(args, XFS_ATTR_DEFER_REMOVE);
+			error = xfs_attr_removename(args);
+			if (error)
+				goto out_trans_cancel;
 			break;
 		}
 
 		/* Pure create fails if the attr already exists */
 		if (op == XFS_ATTRUPDATE_CREATE)
 			goto out_trans_cancel;
-		xfs_attr_defer_add(args, XFS_ATTR_DEFER_REPLACE);
+
+		error = xfs_attr_replacename(args, rmt_blks);
+		if (error)
+			goto out_trans_cancel;
 		break;
 	case -ENOATTR:
 		/* Can't remove what isn't there. */
@@ -1124,7 +1214,10 @@ xfs_attr_set(
 		/* Pure replace fails if no existing attr to replace. */
 		if (op == XFS_ATTRUPDATE_REPLACE)
 			goto out_trans_cancel;
-		xfs_attr_defer_add(args, XFS_ATTR_DEFER_SET);
+
+		error = xfs_attr_setname(args, rmt_blks);
+		if (error)
+			goto out_trans_cancel;
 		break;
 	default:
 		goto out_trans_cancel;
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 12e4299840b8ef..d82c38197f4696 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -26,6 +26,7 @@
 #include "xfs_trans_space.h"
 #include "defer_item.h"
 #include "xfs_health.h"
+#include "xfs_attr_leaf.h"
 
 struct kmem_cache		*xfs_parent_args_cache;
 
@@ -199,8 +200,8 @@ xfs_parent_addname(
 	xfs_inode_to_parent_rec(&ppargs->rec, dp);
 	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
 			child->i_ino, parent_name);
-	xfs_attr_defer_add(&ppargs->args, XFS_ATTR_DEFER_SET);
-	return 0;
+
+	return xfs_attr_setname(&ppargs->args, 0);
 }
 
 /* Remove a parent pointer to reflect a dirent removal. */
@@ -221,8 +222,8 @@ xfs_parent_removename(
 	xfs_inode_to_parent_rec(&ppargs->rec, dp);
 	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
 			child->i_ino, parent_name);
-	xfs_attr_defer_add(&ppargs->args, XFS_ATTR_DEFER_REMOVE);
-	return 0;
+
+	return xfs_attr_removename(&ppargs->args);
 }
 
 /* Replace one parent pointer with another to reflect a rename. */
@@ -247,12 +248,13 @@ xfs_parent_replacename(
 			child->i_ino, old_name);
 
 	xfs_inode_to_parent_rec(&ppargs->new_rec, new_dp);
+
 	ppargs->args.new_name = new_name->name;
 	ppargs->args.new_namelen = new_name->len;
 	ppargs->args.new_value = &ppargs->new_rec;
 	ppargs->args.new_valuelen = sizeof(struct xfs_parent_rec);
-	xfs_attr_defer_add(&ppargs->args, XFS_ATTR_DEFER_REPLACE);
-	return 0;
+
+	return xfs_attr_replacename(&ppargs->args, 0);
 }
 
 /*

