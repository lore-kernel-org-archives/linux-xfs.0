Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBA42F7ADE
	for <linux-xfs@vger.kernel.org>; Fri, 19 Dec 2025 15:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766158915; cv=none; b=PX+F+ptCh9i/fLq4YIZ/Z/ZsPYkfCElAcIHpZSiGoCbRYUUOUARYUvWi/JIHQK3ya7J3fU+d/vJ4EH6tNz9c0bXWcADTnO9giv0zVx/1PjNtEZMCWxmcPPT09IbHRF4kTPQKsCV/NnAKVoVLcv92BKahP6/5G9yUs88Pz9BYAmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766158915; c=relaxed/simple;
	bh=qF6k4JDNvTsvU03wQenjry9LLeWf3OtdzZr+yLBinE0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=qFxU/3qpd3lf33gl5OX6OaSQ7Z3g7xKhQEbvGKGIvdW/+dognOzc7V+OfOZmTJFz9PffEeYtbA4fItqI3jw2EZvM5sgikfA8YMmzRNFut33uATnj2F0BxWzvlhjXKvQbo8pn0JxW6Z9pZBWswQvNPINrMuGVoD/4nylQ4YXu8xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BU1XtyG2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BU1XtyG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CCCC4CEF1;
	Fri, 19 Dec 2025 15:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766158915;
	bh=qF6k4JDNvTsvU03wQenjry9LLeWf3OtdzZr+yLBinE0=;
	h=Date:From:To:Cc:Subject:From;
	b=BU1XtyG2FveyMLjWwrx6DrAaXBbUQ6LEZh0NN1Wags5GYLHD6hya0y1OMWldTQWit
	 rhXHtczvJ9KbRdIJsd2YMxvQbb9uEb/CWbAnnRDcwoE6Y9FRDi9+8XHyj9lQl0IHE6
	 0pNcEUwYLC/pNtjc0Ihro2kdaDfcqWGTEUuTxDnbN9FBY3J+39gY/BW+GlcSESPXMx
	 MRpykmPahF9YzMqp87DiE5TN5H5osxcpMJIIeaQgx3SKNsW7dty0CEZP9hvRNz+RVf
	 hbxOHQ9vPocMRiTmaHvAAmnGHh+YBR5T35437Tgs7w442ux7PYp74OMS5Sr74Fpnt0
	 QMtodXEmare+A==
Date: Fri, 19 Dec 2025 07:41:54 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH] xfs: speed up parent pointer operations
Message-ID: <20251219154154.GP7753@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

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
19% for deletion.  Wall time increases by 5% and 9%.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.h |    1 +
 fs/xfs/libxfs/xfs_attr.c      |    2 +-
 fs/xfs/libxfs/xfs_parent.c    |   36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 589f810eedc0d8..da95de8199dd24 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -49,6 +49,7 @@ void	xfs_attr_shortform_create(struct xfs_da_args *args);
 void	xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff);
 int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
 int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args);
+int	xfs_attr_try_sf_addname(struct xfs_da_args *args);
 int	xfs_attr_sf_removename(struct xfs_da_args *args);
 struct xfs_attr_sf_entry *xfs_attr_sf_findname(struct xfs_da_args *args);
 int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 9d1e5ccab106ca..6ca0ee538131a8 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -349,7 +349,7 @@ xfs_attr_set_resv(
  * xfs_attr_shortform_addname() will convert to leaf format and return -ENOSPC.
  * to use.
  */
-STATIC int
+int
 xfs_attr_try_sf_addname(
 	struct xfs_da_args	*args)
 {
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 69366c44a70159..40db7042a30975 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -29,6 +29,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_attr_item.h"
 #include "xfs_health.h"
+#include "xfs_attr_leaf.h"
 
 struct kmem_cache		*xfs_parent_args_cache;
 
@@ -202,6 +203,16 @@ xfs_parent_addname(
 	xfs_inode_to_parent_rec(&ppargs->rec, dp);
 	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
 			child->i_ino, parent_name);
+
+	if (xfs_inode_has_attr_fork(child) &&
+	    xfs_attr_is_shortform(child)) {
+		ppargs->args.op_flags |= XFS_DA_OP_ADDNAME;
+
+		error = xfs_attr_try_sf_addname(&ppargs->args);
+		if (error != -ENOSPC)
+			return error;
+	}
+
 	xfs_attr_defer_add(&ppargs->args, XFS_ATTR_DEFER_SET);
 	return 0;
 }
@@ -224,6 +235,10 @@ xfs_parent_removename(
 	xfs_inode_to_parent_rec(&ppargs->rec, dp);
 	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
 			child->i_ino, parent_name);
+
+	if (xfs_attr_is_shortform(child))
+		return xfs_attr_sf_removename(&ppargs->args);
+
 	xfs_attr_defer_add(&ppargs->args, XFS_ATTR_DEFER_REMOVE);
 	return 0;
 }
@@ -250,6 +265,27 @@ xfs_parent_replacename(
 			child->i_ino, old_name);
 
 	xfs_inode_to_parent_rec(&ppargs->new_rec, new_dp);
+
+	if (xfs_attr_is_shortform(child)) {
+		ppargs->args.op_flags |= XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE;
+
+		error = xfs_attr_sf_removename(&ppargs->args);
+		if (error)
+			return error;
+
+		xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->new_rec,
+				child, child->i_ino, new_name);
+		ppargs->args.op_flags |= XFS_DA_OP_ADDNAME;
+
+		error = xfs_attr_try_sf_addname(&ppargs->args);
+		if (error == -ENOSPC) {
+			xfs_attr_defer_add(&ppargs->args, XFS_ATTR_DEFER_SET);
+			return 0;
+		}
+
+		return error;
+	}
+
 	ppargs->args.new_name = new_name->name;
 	ppargs->args.new_namelen = new_name->len;
 	ppargs->args.new_value = &ppargs->new_rec;
