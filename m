Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A23419C540
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772496933; cv=none; b=RwtLgOBm/bOO9JU+EuodUvG5RCyumy2RyerX3eX79UmxeWo/DggsKrnmL98tVPNC1IwhOvKqQmG9/kCLwAf4vqCTA0AYdrNCgN6CpluEScWmAS2Bk3kb/NnBLE/v41IFabldti1sUIp6D0hdyad8gjq7IrCrOss95yDsHfUeE4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772496933; c=relaxed/simple;
	bh=7gjCgUrmHFe5T/grZQKYY19Kxai+CNdj6RSKS5xYNBk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G3okqHhwukBMctPkBvAOHpr7+bTsWoYQk3ct0WiYlAuY+IZcm/+j0rBXu+Keyj+GYiTNz/JYQ7q4K0n2j8/m+CVo7Q/m3zj4LqyuUH0INAtTBEPApSqAv51Hm92cpYnyLw9OW0cQg/cMuF98MaO1Zrs79iKEwnG35HJcSSw5Pig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AYJ7DX8Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AYJ7DX8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23FAC19423;
	Tue,  3 Mar 2026 00:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772496933;
	bh=7gjCgUrmHFe5T/grZQKYY19Kxai+CNdj6RSKS5xYNBk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AYJ7DX8ZhOp/5szHEfZmsk8tiAGELokhTuSIbe0bVAsUQXVEm1fSYvdXz3fRH4bOS
	 ZMem2dvSCuh+EV8wuq79ifnEgp5FFHOmDW/IYOlcxlvfjhFA1u8QY8hJ1d1xwEqG3A
	 GVblIt24WL26ajMLXMWNdNC93gyk5RySHXMX5Sj8nepTYVtbd7ABDX0dGeUhqmpx1r
	 YX6QbMoSRnhwuRofarg09BH1rVdF0MyiiGUp0I89lIWJkUjB5y1iW85VdcaHczxX93
	 CETJ3BSWbqKNPWEKuHbBbQW7XpORCM2btEgP9sjg7KqaDXA62/futz/RrKv8rs38Br
	 SFnbahpIMv6fQ==
Date: Mon, 02 Mar 2026 16:15:32 -0800
Subject: [PATCH 13/36] xfs: directly include xfs_platform.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249638015.457970.3116482293268198380.stgit@frogsfrogsfrogs>
In-Reply-To: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: cf9b52fa7d65362b648927d1d752ec99659f5c43

The xfs.h header conflicts with the public xfs.h in xfsprogs, leading
to a spurious difference in all shared libxfs files that have to
include libxfs_priv.h in userspace.  Directly include xfs_platform.h so
that we can add a header of the same name to xfsprogs and remove this
major annoyance for the shared code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_platform.h         |    6 +++---
 libxfs/Makefile               |    2 +-
 libxfs/buf_mem.c              |    2 +-
 libxfs/cache.c                |    2 +-
 libxfs/defer_item.c           |    2 +-
 libxfs/init.c                 |    2 +-
 libxfs/inode.c                |    2 +-
 libxfs/iunlink.c              |    2 +-
 libxfs/kmem.c                 |    2 +-
 libxfs/logitem.c              |    2 +-
 libxfs/rdwr.c                 |    2 +-
 libxfs/topology.c             |    2 +-
 libxfs/trans.c                |    2 +-
 libxfs/util.c                 |    2 +-
 libxfs/xfblob.c               |    2 +-
 libxfs/xfile.c                |    2 +-
 libxfs/xfs_ag.c               |    2 +-
 libxfs/xfs_ag_resv.c          |    2 +-
 libxfs/xfs_alloc.c            |    2 +-
 libxfs/xfs_alloc_btree.c      |    2 +-
 libxfs/xfs_attr.c             |    2 +-
 libxfs/xfs_attr_leaf.c        |    2 +-
 libxfs/xfs_attr_remote.c      |    2 +-
 libxfs/xfs_bit.c              |    2 +-
 libxfs/xfs_bmap.c             |    2 +-
 libxfs/xfs_bmap_btree.c       |    2 +-
 libxfs/xfs_btree.c            |    2 +-
 libxfs/xfs_btree_mem.c        |    2 +-
 libxfs/xfs_btree_staging.c    |    2 +-
 libxfs/xfs_da_btree.c         |    2 +-
 libxfs/xfs_defer.c            |    2 +-
 libxfs/xfs_dir2.c             |    2 +-
 libxfs/xfs_dir2_block.c       |    2 +-
 libxfs/xfs_dir2_data.c        |    2 +-
 libxfs/xfs_dir2_leaf.c        |    2 +-
 libxfs/xfs_dir2_node.c        |    2 +-
 libxfs/xfs_dir2_sf.c          |    2 +-
 libxfs/xfs_dquot_buf.c        |    2 +-
 libxfs/xfs_exchmaps.c         |    2 +-
 libxfs/xfs_group.c            |    2 +-
 libxfs/xfs_ialloc.c           |    2 +-
 libxfs/xfs_ialloc_btree.c     |    2 +-
 libxfs/xfs_iext_tree.c        |    2 +-
 libxfs/xfs_inode_buf.c        |    2 +-
 libxfs/xfs_inode_fork.c       |    2 +-
 libxfs/xfs_inode_util.c       |    2 +-
 libxfs/xfs_log_rlimit.c       |    2 +-
 libxfs/xfs_metadir.c          |    2 +-
 libxfs/xfs_metafile.c         |    2 +-
 libxfs/xfs_parent.c           |    2 +-
 libxfs/xfs_refcount.c         |    2 +-
 libxfs/xfs_refcount_btree.c   |    2 +-
 libxfs/xfs_rmap.c             |    2 +-
 libxfs/xfs_rmap_btree.c       |    2 +-
 libxfs/xfs_rtbitmap.c         |    2 +-
 libxfs/xfs_rtgroup.c          |    2 +-
 libxfs/xfs_rtrefcount_btree.c |    2 +-
 libxfs/xfs_rtrmap_btree.c     |    2 +-
 libxfs/xfs_sb.c               |    2 +-
 libxfs/xfs_symlink_remote.c   |    2 +-
 libxfs/xfs_trans_inode.c      |    2 +-
 libxfs/xfs_trans_resv.c       |    2 +-
 libxfs/xfs_trans_space.c      |    2 +-
 libxfs/xfs_types.c            |    2 +-
 libxfs/xfs_zones.c            |    2 +-
 repair/zoned.c                |    2 +-
 66 files changed, 68 insertions(+), 68 deletions(-)
 rename libxfs/{libxfs_priv.h => xfs_platform.h} (99%)


diff --git a/libxfs/libxfs_priv.h b/libxfs/xfs_platform.h
similarity index 99%
rename from libxfs/libxfs_priv.h
rename to libxfs/xfs_platform.h
index 825915d7d91924..c2ad300169c6ec 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/xfs_platform.h
@@ -34,8 +34,8 @@
  * define a guard and something we can check to determine what include context
  * we are running from.
  */
-#ifndef __LIBXFS_INTERNAL_XFS_H__
-#define __LIBXFS_INTERNAL_XFS_H__
+#ifndef _XFS_PLATFORM_H
+#define _XFS_PLATFORM_H
 
 /* CONFIG_XFS_* must be defined to 1 to work with IS_ENABLED() */
 #define CONFIG_XFS_RT 1
@@ -604,4 +604,4 @@ int xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 #define irix_sgid_inherit		(false)
 #define vfsgid_in_group_p(...)		(false)
 
-#endif	/* __LIBXFS_INTERNAL_XFS_H__ */
+#endif	/* _XFS_PLATFORM_H */
diff --git a/libxfs/Makefile b/libxfs/Makefile
index c5e2161c33096a..83c8592e5fe536 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -26,7 +26,7 @@ HFILES = \
 	listxattr.h \
 	init.h \
 	iunlink.h \
-	libxfs_priv.h \
+	xfs_platform.h \
 	linux-err.h \
 	topology.h \
 	buf_mem.h \
diff --git a/libxfs/buf_mem.c b/libxfs/buf_mem.c
index 77396fa95b4138..15c61966db4384 100644
--- a/libxfs/buf_mem.c
+++ b/libxfs/buf_mem.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "libxfs.h"
 #include "libxfs/xfile.h"
 #include "libxfs/buf_mem.h"
diff --git a/libxfs/cache.c b/libxfs/cache.c
index af20f3854df93e..389afeff4a1f16 100644
--- a/libxfs/cache.c
+++ b/libxfs/cache.c
@@ -10,7 +10,7 @@
 #include <unistd.h>
 #include <pthread.h>
 
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 3dc938d514e65e..4fc2c74a548c91 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/init.c b/libxfs/init.c
index a5e898539c9eb2..5d8b4a153e28da 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -7,7 +7,7 @@
 #include <sys/stat.h>
 #include "init.h"
 
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/inode.c b/libxfs/inode.c
index 1ce159fcc9d61a..dc7e227e8ee92f 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -4,7 +4,7 @@
  * All Rights Reserved.
  */
 
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "libxfs.h"
 #include "libxfs_io.h"
 #include "init.h"
diff --git a/libxfs/iunlink.c b/libxfs/iunlink.c
index 53e36cdc3439b2..2d4dd0aee0b87b 100644
--- a/libxfs/iunlink.c
+++ b/libxfs/iunlink.c
@@ -4,7 +4,7 @@
  * All Rights Reserved.
  */
 
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "libxfs.h"
 #include "libxfs_io.h"
 #include "init.h"
diff --git a/libxfs/kmem.c b/libxfs/kmem.c
index 2e293518024fe3..718b190ad54607 100644
--- a/libxfs/kmem.c
+++ b/libxfs/kmem.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 
 /*
  * Simple memory interface
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index 062d6311b942ae..d8d86d919cf4d7 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -4,7 +4,7 @@
  * All Rights Reserved.
  */
 
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 3419e821ef0a29..6c57bedef54852 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -5,7 +5,7 @@
  */
 
 
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "init.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
diff --git a/libxfs/topology.c b/libxfs/topology.c
index 366165719c84ed..dc2aaa17ab3bda 100644
--- a/libxfs/topology.c
+++ b/libxfs/topology.c
@@ -10,7 +10,7 @@
 #include <fcntl.h>
 #include <sys/stat.h>
 
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "libxcmd.h"
 #include <blkid/blkid.h>
 #include "xfs_multidisk.h"
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 64457d1710bbd6..c89b035ffeaf10 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -5,7 +5,7 @@
  * All Rights Reserved.
  */
 
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/util.c b/libxfs/util.c
index 23cdaba80fe4c3..b4588fe122d5ce 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -4,7 +4,7 @@
  * All Rights Reserved.
  */
 
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "libxfs.h"
 #include "libxfs_io.h"
 #include "init.h"
diff --git a/libxfs/xfblob.c b/libxfs/xfblob.c
index 00f8ed5e5a7bef..597aeb75641641 100644
--- a/libxfs/xfblob.c
+++ b/libxfs/xfblob.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "libxfs.h"
 #include "libxfs/xfile.h"
 #include "libxfs/xfblob.h"
diff --git a/libxfs/xfile.c b/libxfs/xfile.c
index b83797751b87ba..6532197ce6ab29 100644
--- a/libxfs/xfile.c
+++ b/libxfs/xfile.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "libxfs.h"
 #include "libxfs/xfile.h"
 #include <linux/memfd.h>
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index ea64e9eac58945..8ccd67672b4e00 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -5,7 +5,7 @@
  * All rights reserved.
  */
 
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_ag_resv.c b/libxfs/xfs_ag_resv.c
index 842e797b2f9c68..052d187330460e 100644
--- a/libxfs/xfs_ag_resv.c
+++ b/libxfs/xfs_ag_resv.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 311f5342d6e982..9f92bd77fad76c 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 1604e1bb625116..54f0ff75a23805 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 4b985e054ff84c..72b701f1b6dcae 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 29e9a419d07c8b..ff1085f0b3afe4 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 82217baf405bc1..89d01aa7b051e8 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_bit.c b/libxfs/xfs_bit.c
index 3f97fa3e725686..f05a07c0f75da3 100644
--- a/libxfs/xfs_bit.c
+++ b/libxfs/xfs_bit.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_log_format.h"
 #include "xfs_bit.h"
 
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index f2f616e521759e..96975f88497add 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 252da347b06e15..6038c45674557b 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 1404d86fb96394..4ab0d8d3789b18 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_btree_mem.c b/libxfs/xfs_btree_mem.c
index 2b98b8d01dce0d..5fa4a9787c99ab 100644
--- a/libxfs/xfs_btree_mem.c
+++ b/libxfs/xfs_btree_mem.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index d82665ef78398e..4300c058807ba5 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2020 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 37be99bd54c772..969bfc9dee909d 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 8f6708c0f3bfcd..5bd3cbe4cfa1a3 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index d5f2e516e5bfea..2ca6bf198ba54f 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index 82da0d3275e366..29b5b158c80d1f 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index 65e6ed8791ed9f..1fb43cdfdd6d04 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 7c0bba51288142..b89350b03b8724 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index c94d00eb99c874..9d8bb27f716fe4 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index aaf73cd35ca753..1a67cdd6a70706 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
index 599d03ac960b7b..329aceca005db7 100644
--- a/libxfs/xfs_dquot_buf.c
+++ b/libxfs/xfs_dquot_buf.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
index 8e39324d42ca25..5566f9faf45612 100644
--- a/libxfs/xfs_exchmaps.c
+++ b/libxfs/xfs_exchmaps.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_group.c b/libxfs/xfs_group.c
index 03c508242d52f6..cb841514750978 100644
--- a/libxfs/xfs_group.c
+++ b/libxfs/xfs_group.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2018 Red Hat, Inc.
  */
 
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 1da6f07fa030d0..31c818f9870f8d 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index dab9b61bd2006f..e0d886f324d89c 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_iext_tree.c b/libxfs/xfs_iext_tree.c
index cdbb72d6387823..5b2b926ab2285f 100644
--- a/libxfs/xfs_iext_tree.c
+++ b/libxfs/xfs_iext_tree.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2017 Christoph Hellwig.
  */
 
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_bit.h"
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index e2c87ca03cc39b..0802bc376073d8 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 329d52cc524a16..87afe671886ede 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -4,7 +4,7 @@
  * All Rights Reserved.
  */
 
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index 85d4af41d56de5..ccd38f18c3ed55 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_log_rlimit.c b/libxfs/xfs_log_rlimit.c
index 2b9047f5ffb58b..37712b2f87572e 100644
--- a/libxfs/xfs_log_rlimit.c
+++ b/libxfs/xfs_log_rlimit.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2013 Jie Liu.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_metadir.c b/libxfs/xfs_metadir.c
index 253fbf48e170e0..bffe9ba9129002 100644
--- a/libxfs/xfs_metadir.c
+++ b/libxfs/xfs_metadir.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_metafile.c b/libxfs/xfs_metafile.c
index 9c3751f58161e0..8d98989349d086 100644
--- a/libxfs/xfs_metafile.c
+++ b/libxfs/xfs_metafile.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 84220f10a1f409..12e4299840b8ef 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2022-2024 Oracle.
  * All rights reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_da_format.h"
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index f9714acd9a5a1b..5c362e0e901124 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 44d942e9d098e1..5a39dbbc635ca4 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2016 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 33e856875db419..9da10afe3578b5 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2014 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index d7b9fccc3a0f5d..c39faa4aac6c2b 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2014 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 354ebb8d066e09..7a06305b4e11dd 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index d012ca73000d86..af4eafb20bc138 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index 77191f073a10bb..f893677e0fcd32 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index 633dca0333f4e7..7191bf445c399b 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <djwong@kernel.org>
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 3e2d3c6da19631..b29077dcd0aed7 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index 1c355f751e1cc7..d29eae498c493e 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2012-2013 Red Hat, Inc.
  * All rights reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/libxfs/xfs_trans_inode.c b/libxfs/xfs_trans_inode.c
index 90eec4d3592dea..ef404e7f0f6e91 100644
--- a/libxfs/xfs_trans_inode.c
+++ b/libxfs/xfs_trans_inode.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index b3b9d22b54515d..9294b72e61b77e 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2010 Red Hat, Inc.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_trans_space.c b/libxfs/xfs_trans_space.c
index 373f5cc24977a8..9b8f495c9049cc 100644
--- a/libxfs/xfs_trans_space.c
+++ b/libxfs/xfs_trans_space.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2000,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
diff --git a/libxfs/xfs_types.c b/libxfs/xfs_types.c
index 4e24599c369397..67c947a47f1478 100644
--- a/libxfs/xfs_types.c
+++ b/libxfs/xfs_types.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2017 Oracle.
  * All Rights Reserved.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
 #include "xfs_shared.h"
diff --git a/libxfs/xfs_zones.c b/libxfs/xfs_zones.c
index 90e2ba0908be5d..e31e1dc0913efe 100644
--- a/libxfs/xfs_zones.c
+++ b/libxfs/xfs_zones.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2023-2025 Christoph Hellwig.
  * Copyright (c) 2024-2025, Western Digital Corporation or its affiliates.
  */
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
diff --git a/repair/zoned.c b/repair/zoned.c
index 07e676ac7fd3f6..c721709d137064 100644
--- a/repair/zoned.c
+++ b/repair/zoned.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2024 Christoph Hellwig.
  */
 #include <ctype.h>
-#include "libxfs_priv.h"
+#include "xfs_platform.h"
 #include "libxfs.h"
 #include "xfs_zones.h"
 #include "libfrog/zones.h"

