Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53168 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752574AbeFFDAu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 23:00:50 -0400
Date: Tue, 5 Jun 2018 20:00:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [[PATCH V2]] xfs: convert to SPDX license tags
Message-ID: <20180606030041.GS9437@magnolia>
References: <20180606021024.11896-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180606021024.11896-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jun 06, 2018 at 12:10:24PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Remove the verbose license text from XFS files and replace them
> with SPDX tags. This does not change the license of any of the code,
> merely refers to the common, up-to-date license files in LICENSES/
> 
> This change was mostly scripted. fs/xfs/Makefile and
> fs/xfs/libxfs/xfs_fs.h were modified by hand, the rest were detected
> and modified by the following command:
> 
> for f in `git grep -l "GNU General" fs/xfs/` ; do
> 	echo $f
> 	cat $f | awk -f hdr.awk > $f.new
> 	mv -f $f.new $f
> done
> 
> And the hdr.awk script that did the modification (including
> detecting the difference between GPL-2.0 and GPL-2.0+ licenses)
> is as follows:
> 
> $ cat hdr.awk
> BEGIN {
> 	hdr = 1.0
> 	tag = "GPL-2.0"
> 	str = ""
> }
> 
> /^ \* This program is free software/ {
> 	hdr = 2.0;
> 	next
> }
> 
> /any later version./ {
> 	tag = "GPL-2.0+"
> 	next
> }
> 
> /^ \*\// {
> 	if (hdr > 0.0) {
> 		print "// SPDX-License-Identifier: " tag
> 		print str
> 		print $0
> 		str=""
> 		hdr = 0.0
> 		next
> 	}
> 	print $0
> 	next
> }
> 
> /^ \* / {
> 	if (hdr > 1.0)
> 		next
> 	if (hdr > 0.0) {
> 		if (str != "")
> 			str = str "\n"
> 		str = str $0
> 		next
> 	}
> 	print $0
> 	next
> }
> 
> /^ \*/ {
> 	if (hdr > 0.0)
> 		next
> 	print $0
> 	next
> }
> 
> // {
> 	if (hdr > 0.0) {
> 		if (str != "")
> 			str = str "\n"
> 		str = str $0
> 		next
> 	}
> 	print $0
> }
> 
> END { }
> $
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/Makefile                    | 14 +-------------
>  fs/xfs/kmem.c                      | 14 +-------------
>  fs/xfs/kmem.h                      | 14 +-------------
>  fs/xfs/libxfs/xfs_ag_resv.c        | 16 +---------------
>  fs/xfs/libxfs/xfs_ag_resv.h        | 16 +---------------
>  fs/xfs/libxfs/xfs_alloc.c          | 14 +-------------
>  fs/xfs/libxfs/xfs_alloc.h          | 14 +-------------
>  fs/xfs/libxfs/xfs_alloc_btree.c    | 14 +-------------
>  fs/xfs/libxfs/xfs_alloc_btree.h    | 14 +-------------
>  fs/xfs/libxfs/xfs_attr.c           | 14 +-------------
>  fs/xfs/libxfs/xfs_attr_leaf.c      | 14 +-------------
>  fs/xfs/libxfs/xfs_attr_leaf.h      | 14 +-------------
>  fs/xfs/libxfs/xfs_attr_remote.c    | 14 +-------------
>  fs/xfs/libxfs/xfs_attr_remote.h    | 14 +-------------
>  fs/xfs/libxfs/xfs_attr_sf.h        | 14 +-------------
>  fs/xfs/libxfs/xfs_bit.c            | 14 +-------------
>  fs/xfs/libxfs/xfs_bit.h            | 14 +-------------
>  fs/xfs/libxfs/xfs_bmap.c           | 14 +-------------
>  fs/xfs/libxfs/xfs_bmap.h           | 14 +-------------
>  fs/xfs/libxfs/xfs_bmap_btree.c     | 14 +-------------
>  fs/xfs/libxfs/xfs_bmap_btree.h     | 14 +-------------
>  fs/xfs/libxfs/xfs_btree.c          | 14 +-------------
>  fs/xfs/libxfs/xfs_btree.h          | 14 +-------------
>  fs/xfs/libxfs/xfs_da_btree.c       | 14 +-------------
>  fs/xfs/libxfs/xfs_da_btree.h       | 14 +-------------
>  fs/xfs/libxfs/xfs_da_format.c      | 14 +-------------
>  fs/xfs/libxfs/xfs_da_format.h      | 14 +-------------
>  fs/xfs/libxfs/xfs_defer.c          | 16 +---------------
>  fs/xfs/libxfs/xfs_defer.h          | 16 +---------------
>  fs/xfs/libxfs/xfs_dir2.c           | 14 +-------------
>  fs/xfs/libxfs/xfs_dir2.h           | 14 +-------------
>  fs/xfs/libxfs/xfs_dir2_block.c     | 14 +-------------
>  fs/xfs/libxfs/xfs_dir2_data.c      | 14 +-------------
>  fs/xfs/libxfs/xfs_dir2_leaf.c      | 14 +-------------
>  fs/xfs/libxfs/xfs_dir2_node.c      | 14 +-------------
>  fs/xfs/libxfs/xfs_dir2_priv.h      | 14 +-------------
>  fs/xfs/libxfs/xfs_dir2_sf.c        | 14 +-------------
>  fs/xfs/libxfs/xfs_dquot_buf.c      | 14 +-------------
>  fs/xfs/libxfs/xfs_errortag.h       | 15 +--------------
>  fs/xfs/libxfs/xfs_format.h         | 14 +-------------
>  fs/xfs/libxfs/xfs_fs.h             | 14 +-------------
>  fs/xfs/libxfs/xfs_ialloc.c         | 14 +-------------
>  fs/xfs/libxfs/xfs_ialloc.h         | 14 +-------------
>  fs/xfs/libxfs/xfs_ialloc_btree.c   | 14 +-------------
>  fs/xfs/libxfs/xfs_ialloc_btree.h   | 14 +-------------
>  fs/xfs/libxfs/xfs_iext_tree.c      | 10 +---------
>  fs/xfs/libxfs/xfs_inode_buf.c      | 14 +-------------
>  fs/xfs/libxfs/xfs_inode_buf.h      | 14 +-------------
>  fs/xfs/libxfs/xfs_inode_fork.c     | 14 +-------------
>  fs/xfs/libxfs/xfs_inode_fork.h     | 14 +-------------
>  fs/xfs/libxfs/xfs_log_format.h     | 14 +-------------
>  fs/xfs/libxfs/xfs_log_recover.h    | 14 +-------------
>  fs/xfs/libxfs/xfs_log_rlimit.c     | 14 +-------------
>  fs/xfs/libxfs/xfs_quota_defs.h     | 14 +-------------
>  fs/xfs/libxfs/xfs_refcount.c       | 16 +---------------
>  fs/xfs/libxfs/xfs_refcount.h       | 16 +---------------
>  fs/xfs/libxfs/xfs_refcount_btree.c | 16 +---------------
>  fs/xfs/libxfs/xfs_refcount_btree.h | 16 +---------------
>  fs/xfs/libxfs/xfs_rmap.c           | 14 +-------------
>  fs/xfs/libxfs/xfs_rmap.h           | 16 +---------------
>  fs/xfs/libxfs/xfs_rmap_btree.c     | 14 +-------------
>  fs/xfs/libxfs/xfs_rmap_btree.h     | 14 +-------------
>  fs/xfs/libxfs/xfs_rtbitmap.c       | 14 +-------------
>  fs/xfs/libxfs/xfs_sb.c             | 14 +-------------
>  fs/xfs/libxfs/xfs_sb.h             | 14 +-------------
>  fs/xfs/libxfs/xfs_shared.h         | 14 +-------------
>  fs/xfs/libxfs/xfs_symlink_remote.c | 14 +-------------
>  fs/xfs/libxfs/xfs_trans_resv.c     | 14 +-------------
>  fs/xfs/libxfs/xfs_trans_resv.h     | 14 +-------------
>  fs/xfs/libxfs/xfs_trans_space.h    | 14 +-------------
>  fs/xfs/libxfs/xfs_types.h          | 14 +-------------
>  fs/xfs/mrlock.h                    | 14 +-------------
>  fs/xfs/scrub/agheader.c            | 16 +---------------
>  fs/xfs/scrub/agheader_repair.c     | 16 +---------------
>  fs/xfs/scrub/alloc.c               | 16 +---------------
>  fs/xfs/scrub/attr.c                | 16 +---------------
>  fs/xfs/scrub/bmap.c                | 16 +---------------
>  fs/xfs/scrub/btree.c               | 16 +---------------
>  fs/xfs/scrub/btree.h               | 16 +---------------
>  fs/xfs/scrub/common.c              | 16 +---------------
>  fs/xfs/scrub/common.h              | 16 +---------------
>  fs/xfs/scrub/dabtree.c             | 16 +---------------
>  fs/xfs/scrub/dabtree.h             | 16 +---------------
>  fs/xfs/scrub/dir.c                 | 16 +---------------
>  fs/xfs/scrub/ialloc.c              | 16 +---------------
>  fs/xfs/scrub/inode.c               | 16 +---------------
>  fs/xfs/scrub/parent.c              | 16 +---------------
>  fs/xfs/scrub/quota.c               | 16 +---------------
>  fs/xfs/scrub/refcount.c            | 16 +---------------
>  fs/xfs/scrub/repair.c              | 16 +---------------
>  fs/xfs/scrub/repair.h              | 16 +---------------
>  fs/xfs/scrub/rmap.c                | 16 +---------------
>  fs/xfs/scrub/rtbitmap.c            | 16 +---------------
>  fs/xfs/scrub/scrub.c               | 16 +---------------
>  fs/xfs/scrub/scrub.h               | 16 +---------------
>  fs/xfs/scrub/symlink.c             | 16 +---------------
>  fs/xfs/scrub/trace.c               | 16 +---------------
>  fs/xfs/scrub/trace.h               | 16 +---------------
>  fs/xfs/scrub/xfs_scrub.h           | 16 +---------------
>  fs/xfs/xfs.h                       | 14 +-------------
>  fs/xfs/xfs_acl.c                   | 14 +-------------
>  fs/xfs/xfs_acl.h                   | 14 +-------------
>  fs/xfs/xfs_aops.c                  | 14 +-------------
>  fs/xfs/xfs_aops.h                  | 14 +-------------
>  fs/xfs/xfs_attr.h                  | 14 +-------------
>  fs/xfs/xfs_attr_inactive.c         | 14 +-------------
>  fs/xfs/xfs_attr_list.c             | 14 +-------------
>  fs/xfs/xfs_bmap_item.c             | 16 +---------------
>  fs/xfs/xfs_bmap_item.h             | 16 +---------------
>  fs/xfs/xfs_bmap_util.c             | 14 +-------------
>  fs/xfs/xfs_bmap_util.h             | 14 +-------------
>  fs/xfs/xfs_buf.c                   | 14 +-------------
>  fs/xfs/xfs_buf.h                   | 14 +-------------
>  fs/xfs/xfs_buf_item.c              | 14 +-------------
>  fs/xfs/xfs_buf_item.h              | 14 +-------------
>  fs/xfs/xfs_dir2_readdir.c          | 14 +-------------
>  fs/xfs/xfs_discard.c               | 14 +-------------
>  fs/xfs/xfs_dquot.c                 | 14 +-------------
>  fs/xfs/xfs_dquot.h                 | 14 +-------------
>  fs/xfs/xfs_dquot_item.c            | 14 +-------------
>  fs/xfs/xfs_dquot_item.h            | 14 +-------------
>  fs/xfs/xfs_error.c                 | 14 +-------------
>  fs/xfs/xfs_error.h                 | 14 +-------------
>  fs/xfs/xfs_export.c                | 14 +-------------
>  fs/xfs/xfs_export.h                | 14 +-------------
>  fs/xfs/xfs_extent_busy.c           | 14 +-------------
>  fs/xfs/xfs_extent_busy.h           | 14 +-------------
>  fs/xfs/xfs_extfree_item.c          | 14 +-------------
>  fs/xfs/xfs_extfree_item.h          | 14 +-------------
>  fs/xfs/xfs_file.c                  | 14 +-------------
>  fs/xfs/xfs_filestream.c            | 14 +-------------
>  fs/xfs/xfs_filestream.h            | 14 +-------------
>  fs/xfs/xfs_fsmap.c                 | 16 +---------------
>  fs/xfs/xfs_fsmap.h                 | 16 +---------------
>  fs/xfs/xfs_fsops.c                 | 14 +-------------
>  fs/xfs/xfs_fsops.h                 | 14 +-------------
>  fs/xfs/xfs_globals.c               | 14 +-------------
>  fs/xfs/xfs_icache.c                | 14 +-------------
>  fs/xfs/xfs_icache.h                | 14 +-------------
>  fs/xfs/xfs_icreate_item.c          | 14 +-------------
>  fs/xfs/xfs_icreate_item.h          | 14 +-------------
>  fs/xfs/xfs_inode.c                 | 14 +-------------
>  fs/xfs/xfs_inode.h                 | 14 +-------------
>  fs/xfs/xfs_inode_item.c            | 14 +-------------
>  fs/xfs/xfs_inode_item.h            | 14 +-------------
>  fs/xfs/xfs_ioctl.c                 | 14 +-------------
>  fs/xfs/xfs_ioctl.h                 | 14 +-------------
>  fs/xfs/xfs_ioctl32.c               | 14 +-------------
>  fs/xfs/xfs_ioctl32.h               | 14 +-------------
>  fs/xfs/xfs_iomap.c                 | 14 +-------------
>  fs/xfs/xfs_iomap.h                 | 14 +-------------
>  fs/xfs/xfs_iops.c                  | 14 +-------------
>  fs/xfs/xfs_iops.h                  | 14 +-------------
>  fs/xfs/xfs_itable.c                | 14 +-------------
>  fs/xfs/xfs_itable.h                | 14 +-------------
>  fs/xfs/xfs_linux.h                 | 14 +-------------
>  fs/xfs/xfs_log.c                   | 14 +-------------
>  fs/xfs/xfs_log.h                   | 14 +-------------
>  fs/xfs/xfs_log_cil.c               | 14 +-------------
>  fs/xfs/xfs_log_priv.h              | 14 +-------------
>  fs/xfs/xfs_log_recover.c           | 14 +-------------
>  fs/xfs/xfs_message.c               | 14 +-------------
>  fs/xfs/xfs_mount.c                 | 14 +-------------
>  fs/xfs/xfs_mount.h                 | 14 +-------------
>  fs/xfs/xfs_mru_cache.c             | 14 +-------------
>  fs/xfs/xfs_mru_cache.h             | 14 +-------------
>  fs/xfs/xfs_ondisk.h                | 14 +-------------
>  fs/xfs/xfs_qm.c                    | 14 +-------------
>  fs/xfs/xfs_qm.h                    | 14 +-------------
>  fs/xfs/xfs_qm_bhv.c                | 14 +-------------
>  fs/xfs/xfs_qm_syscalls.c           | 14 +-------------
>  fs/xfs/xfs_quota.h                 | 14 +-------------
>  fs/xfs/xfs_quotaops.c              | 14 +-------------
>  fs/xfs/xfs_refcount_item.c         | 16 +---------------
>  fs/xfs/xfs_refcount_item.h         | 16 +---------------
>  fs/xfs/xfs_reflink.c               | 16 +---------------
>  fs/xfs/xfs_reflink.h               | 16 +---------------
>  fs/xfs/xfs_rmap_item.c             | 16 +---------------
>  fs/xfs/xfs_rmap_item.h             | 16 +---------------
>  fs/xfs/xfs_rtalloc.c               | 14 +-------------
>  fs/xfs/xfs_rtalloc.h               | 14 +-------------
>  fs/xfs/xfs_stats.c                 | 14 +-------------
>  fs/xfs/xfs_stats.h                 | 14 +-------------
>  fs/xfs/xfs_super.c                 | 14 +-------------
>  fs/xfs/xfs_super.h                 | 14 +-------------
>  fs/xfs/xfs_symlink.c               | 14 +-------------
>  fs/xfs/xfs_symlink.h               | 14 +-------------
>  fs/xfs/xfs_sysctl.c                | 14 +-------------
>  fs/xfs/xfs_sysctl.h                | 14 +-------------
>  fs/xfs/xfs_sysfs.c                 | 14 +-------------
>  fs/xfs/xfs_sysfs.h                 | 14 +-------------
>  fs/xfs/xfs_trace.c                 | 14 +-------------
>  fs/xfs/xfs_trace.h                 | 14 +-------------
>  fs/xfs/xfs_trans.c                 | 14 +-------------
>  fs/xfs/xfs_trans.h                 | 14 +-------------
>  fs/xfs/xfs_trans_ail.c             | 14 +-------------
>  fs/xfs/xfs_trans_bmap.c            | 16 +---------------
>  fs/xfs/xfs_trans_buf.c             | 14 +-------------
>  fs/xfs/xfs_trans_dquot.c           | 14 +-------------
>  fs/xfs/xfs_trans_extfree.c         | 14 +-------------
>  fs/xfs/xfs_trans_inode.c           | 14 +-------------
>  fs/xfs/xfs_trans_priv.h            | 14 +-------------
>  fs/xfs/xfs_trans_refcount.c        | 16 +---------------
>  fs/xfs/xfs_trans_rmap.c            | 16 +---------------
>  fs/xfs/xfs_xattr.c                 | 14 +-------------
>  205 files changed, 205 insertions(+), 2760 deletions(-)
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index e8d67a443bd7..6ccc10b6d77a 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -1,20 +1,8 @@
> +# SPDX-License-Identifier: GPL-2.0
>  #
>  # Copyright (c) 2000-2005 Silicon Graphics, Inc.
>  # All Rights Reserved.
>  #
> -# This program is free software; you can redistribute it and/or
> -# modify it under the terms of the GNU General Public License as
> -# published by the Free Software Foundation.
> -#
> -# This program is distributed in the hope that it would be useful,
> -# but WITHOUT ANY WARRANTY; without even the implied warranty of
> -# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> -# GNU General Public License for more details.
> -#
> -# You should have received a copy of the GNU General Public License
> -# along with this program; if not, write the Free Software Foundation,
> -# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> -#
>  
>  ccflags-y += -I$(src)			# needed for trace events
>  ccflags-y += -I$(src)/libxfs
> diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> index 7bace03dc9dc..fdd9d6ede25c 100644
> --- a/fs/xfs/kmem.c
> +++ b/fs/xfs/kmem.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include <linux/mm.h>
>  #include <linux/sched/mm.h>
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> index 6023b594ead7..8e6b3ba81c03 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_SUPPORT_KMEM_H__
>  #define __XFS_SUPPORT_KMEM_H__
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index 03885a968de8..84db76e0e3e3 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2016 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.h b/fs/xfs/libxfs/xfs_ag_resv.h
> index 938f2f96c5e8..4619b554ee90 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.h
> +++ b/fs/xfs/libxfs/xfs_ag_resv.h
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2016 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #ifndef __XFS_AG_RESV_H__
>  #define	__XFS_AG_RESV_H__
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 0214a77808d0..a52ffb835b16 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 0747adcd57d6..1651d924aaf1 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_ALLOC_H__
>  #define	__XFS_ALLOC_H__
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index a4a001f2e130..4e59cc8a2802 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.h b/fs/xfs/libxfs/xfs_alloc_btree.h
> index 2fd54728871c..c9305ebb69f6 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.h
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_ALLOC_BTREE_H__
>  #define	__XFS_ALLOC_BTREE_H__
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index c3d02a66d39d..99590f61d624 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 2135b8e67dcc..cf1504208811 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -1,20 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * Copyright (c) 2013 Red Hat, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index 4da08af5b134..7b74e18becff 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -1,20 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000,2002-2003,2005 Silicon Graphics, Inc.
>   * Copyright (c) 2013 Red Hat, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_ATTR_LEAF_H__
>  #define	__XFS_ATTR_LEAF_H__
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 83a6d3c7f872..bf2e0371149b 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -1,20 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * Copyright (c) 2013 Red Hat, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> index 5a9acfa156d7..9d20b66ad379 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.h
> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2013 Red Hat, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_ATTR_REMOTE_H__
>  #define	__XFS_ATTR_REMOTE_H__
> diff --git a/fs/xfs/libxfs/xfs_attr_sf.h b/fs/xfs/libxfs/xfs_attr_sf.h
> index afd684ae3136..aafa4fe70624 100644
> --- a/fs/xfs/libxfs/xfs_attr_sf.h
> +++ b/fs/xfs/libxfs/xfs_attr_sf.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000,2002,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_ATTR_SF_H__
>  #define	__XFS_ATTR_SF_H__
> diff --git a/fs/xfs/libxfs/xfs_bit.c b/fs/xfs/libxfs/xfs_bit.c
> index 0a94cce5ea35..40ce5f3094d1 100644
> --- a/fs/xfs/libxfs/xfs_bit.c
> +++ b/fs/xfs/libxfs/xfs_bit.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_log_format.h"
> diff --git a/fs/xfs/libxfs/xfs_bit.h b/fs/xfs/libxfs/xfs_bit.h
> index 61c6b2025d0c..99017b8df292 100644
> --- a/fs/xfs/libxfs/xfs_bit.h
> +++ b/fs/xfs/libxfs/xfs_bit.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000,2002,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_BIT_H__
>  #define	__XFS_BIT_H__
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 368a1179f0ff..3de047eb8209 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2006 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 2c233f9f1a26..99dddbd0fcc6 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2006 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_BMAP_H__
>  #define	__XFS_BMAP_H__
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index ac9d4aeedb09..e1a2d9ceb615 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
> index fb3cd2d9e0f8..29b407d053b4 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.h
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000,2002-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_BMAP_BTREE_H__
>  #define __XFS_BMAP_BTREE_H__
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 6b589e4f703e..34c6d7bd4d18 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index d7911efee6dc..0a4fdf7f11a7 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_BTREE_H__
>  #define	__XFS_BTREE_H__
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 1427887a1974..5d5955d1f775 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -1,20 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * Copyright (c) 2013 Red Hat, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index ae6de17467f2..28260073ae71 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -1,20 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000,2002,2005 Silicon Graphics, Inc.
>   * Copyright (c) 2013 Red Hat, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_DA_BTREE_H__
>  #define	__XFS_DA_BTREE_H__
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index 6d77d1a8498a..b39053dcb643 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -1,20 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000,2002,2005 Silicon Graphics, Inc.
>   * Copyright (c) 2013 Red Hat, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> index 7e77299b7789..5d5bf3bffc78 100644
> --- a/fs/xfs/libxfs/xfs_da_format.h
> +++ b/fs/xfs/libxfs/xfs_da_format.h
> @@ -1,20 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
>   * Copyright (c) 2013 Red Hat, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_DA_FORMAT_H__
>  #define __XFS_DA_FORMAT_H__
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 3daf175e2535..c3e5bffda4f5 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2016 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index e70725ba1f5f..a02b2b748b6d 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2016 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #ifndef __XFS_DEFER_H__
>  #define	__XFS_DEFER_H__
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 92f94e190f04..59169aff30fe 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index 989e95a53db2..ed385316c7dc 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_DIR2_H__
>  #define __XFS_DIR2_H__
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 875893ded514..bac4c93e6381 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -1,20 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
>   * Copyright (c) 2013 Red Hat, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index c672846a0303..01162c62ec8f 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -1,20 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
>   * Copyright (c) 2013 Red Hat, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index 77240f4de0e0..728c3428abe3 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -1,20 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
>   * Copyright (c) 2013 Red Hat, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index a5e7d9bd7552..2daf874969ab 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -1,20 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * Copyright (c) 2013 Red Hat, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index 753aeeeffc18..59f9fb2241a5 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_DIR2_PRIV_H__
>  #define __XFS_DIR2_PRIV_H__
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 0c75a7f00883..585dfdb7b6b6 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index cce520becee4..d293f371dd54 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -1,20 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2006 Silicon Graphics, Inc.
>   * Copyright (c) 2013 Red Hat, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index d47b91625945..b9974e7a8e6e 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -1,21 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
>   * Copyright (C) 2017 Oracle.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #ifndef __XFS_ERRORTAG_H_
>  #define __XFS_ERRORTAG_H_
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index c1cb29a5f4f6..1c5a8aaf2bfc 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_FORMAT_H__
>  #define __XFS_FORMAT_H__
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index dddc75e4f1f6..f3aa59302fef 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: LGPL-2.1
>  /*
>   * Copyright (c) 1995-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU Lesser General Public License
> - * as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU Lesser General Public License for more details.
> - *
> - * You should have received a copy of the GNU Lesser General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_FS_H__
>  #define __XFS_FS_H__
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 48296adbb0fb..ec5ea02b5553 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> index 77fffced8bac..144f3eac9b93 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.h
> +++ b/fs/xfs/libxfs/xfs_ialloc.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_IALLOC_H__
>  #define	__XFS_IALLOC_H__
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index b04c55512159..a5237afec5ab 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
> index 4acdd5458d59..bf8f0c405e7d 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.h
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_IALLOC_BTREE_H__
>  #define	__XFS_IALLOC_BTREE_H__
> diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
> index b0f31791c7e6..b80c63faace2 100644
> --- a/fs/xfs/libxfs/xfs_iext_tree.c
> +++ b/fs/xfs/libxfs/xfs_iext_tree.c
> @@ -1,14 +1,6 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2017 Christoph Hellwig.
> - *
> - * This program is free software; you can redistribute it and/or modify it
> - * under the terms and conditions of the GNU General Public License,
> - * version 2, as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope it will be useful, but WITHOUT
> - * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> - * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> - * more details.
>   */
>  
>  #include <linux/cache.h>
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 1201107eabc6..f5fff1ccb61d 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2006 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index d9a376a78ee2..ab0f84165317 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef	__XFS_INODE_BUF_H__
>  #define	__XFS_INODE_BUF_H__
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 701c42a28d05..183ec0cb8921 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2006 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include <linux/log2.h>
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index dd8aba0dd119..781b1603df5e 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef	__XFS_INODE_FORK_H__
>  #define	__XFS_INODE_FORK_H__
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index 349d9f8edb89..79bb79853c9f 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef	__XFS_LOG_FORMAT_H__
>  #define __XFS_LOG_FORMAT_H__
> diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
> index 66948a9fd486..f3d18eaecebb 100644
> --- a/fs/xfs/libxfs/xfs_log_recover.h
> +++ b/fs/xfs/libxfs/xfs_log_recover.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef	__XFS_LOG_RECOVER_H__
>  #define __XFS_LOG_RECOVER_H__
> diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
> index cc4cbe290939..1b542ec11d5d 100644
> --- a/fs/xfs/libxfs/xfs_log_rlimit.c
> +++ b/fs/xfs/libxfs/xfs_log_rlimit.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2013 Jie Liu.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
> index d4af2804b178..4bfdd5f4c6af 100644
> --- a/fs/xfs/libxfs/xfs_quota_defs.h
> +++ b/fs/xfs/libxfs/xfs_quota_defs.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_QUOTA_DEFS_H__
>  #define __XFS_QUOTA_DEFS_H__
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 418d53295893..ed5704c7dcf5 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2016 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
> index a92ad9078bc1..5fef74412727 100644
> --- a/fs/xfs/libxfs/xfs_refcount.h
> +++ b/fs/xfs/libxfs/xfs_refcount.h
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2016 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #ifndef __XFS_REFCOUNT_H__
>  #define __XFS_REFCOUNT_H__
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index f652b48128c3..b71937982c5b 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2016 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
> index 2bc4694ef146..d2852b6e1fa8 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.h
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.h
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2016 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #ifndef __XFS_REFCOUNT_BTREE_H__
>  #define	__XFS_REFCOUNT_BTREE_H__
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index c0644f1be8a8..87711f9af625 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2014 Red Hat, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
> index 43e506f67680..9f19454768b2 100644
> --- a/fs/xfs/libxfs/xfs_rmap.h
> +++ b/fs/xfs/libxfs/xfs_rmap.h
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2016 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #ifndef __XFS_RMAP_H__
>  #define __XFS_RMAP_H__
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index 78ab00beee93..221a88ea60bb 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2014 Red Hat, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
> index d68d96eed7ea..50198b6c3bb2 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.h
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2014 Red Hat, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_RMAP_BTREE_H__
>  #define __XFS_RMAP_BTREE_H__
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index 369eeb7a52ec..ffc72075a44e 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index b5dca3c8c84d..5e14bbfd233e 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
> index 244e0162c49e..13564d69800a 100644
> --- a/fs/xfs/libxfs/xfs_sb.h
> +++ b/fs/xfs/libxfs/xfs_sb.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_SB_H__
>  #define	__XFS_SB_H__
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index ae99c260adb1..22089f1c880a 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -1,20 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * Copyright (c) 2013 Red Hat, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_SHARED_H__
>  #define __XFS_SHARED_H__
> diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
> index 5ef5f354587e..95374ab2dee7 100644
> --- a/fs/xfs/libxfs/xfs_symlink_remote.c
> +++ b/fs/xfs/libxfs/xfs_symlink_remote.c
> @@ -1,20 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2006 Silicon Graphics, Inc.
>   * Copyright (c) 2012-2013 Red Hat, Inc.
>   * All rights reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 3bccdf73e141..50c44e3c0bc5 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -1,20 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
>   * Copyright (C) 2010 Red Hat, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
> index b7e5357d060a..7241ab28cf84 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.h
> +++ b/fs/xfs/libxfs/xfs_trans_resv.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef	__XFS_TRANS_RESV_H__
>  #define	__XFS_TRANS_RESV_H__
> diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
> index d787c677d2a3..a62fb950bef1 100644
> --- a/fs/xfs/libxfs/xfs_trans_space.h
> +++ b/fs/xfs/libxfs/xfs_trans_space.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_TRANS_SPACE_H__
>  #define __XFS_TRANS_SPACE_H__
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index ea18449bd732..b72ae343140e 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_TYPES_H__
>  #define	__XFS_TYPES_H__
> diff --git a/fs/xfs/mrlock.h b/fs/xfs/mrlock.h
> index e3c92d19e540..79155eec341b 100644
> --- a/fs/xfs/mrlock.h
> +++ b/fs/xfs/mrlock.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2006 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_SUPPORT_MRLOCK_H__
>  #define __XFS_SUPPORT_MRLOCK_H__
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index 1f71793f7db4..fb9637ff4bde 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2017 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 8b91e9ebe1e7..117eedac53df 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2018 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
> index 941a0a55224e..50e4f7fa06f0 100644
> --- a/fs/xfs/scrub/alloc.c
> +++ b/fs/xfs/scrub/alloc.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2017 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index 84b6d6b66578..de51cf8a8516 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2017 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index eeadb33a701c..3d08589f5c60 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2017 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> index 2d29dceaa00e..5b472045f036 100644
> --- a/fs/xfs/scrub/btree.c
> +++ b/fs/xfs/scrub/btree.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2017 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/scrub/btree.h b/fs/xfs/scrub/btree.h
> index e2b868ede70b..956627500f2c 100644
> --- a/fs/xfs/scrub/btree.h
> +++ b/fs/xfs/scrub/btree.h
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2017 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #ifndef __XFS_SCRUB_BTREE_H__
>  #define __XFS_SCRUB_BTREE_H__
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 41198a5f872c..70e70c69f83f 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2017 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
> index 76bb2d1d808c..2172bd5361e2 100644
> --- a/fs/xfs/scrub/common.h
> +++ b/fs/xfs/scrub/common.h
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2017 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #ifndef __XFS_SCRUB_COMMON_H__
>  #define __XFS_SCRUB_COMMON_H__
> diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
> index bffdb7dc09bf..d700c4d4d4ef 100644
> --- a/fs/xfs/scrub/dabtree.c
> +++ b/fs/xfs/scrub/dabtree.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2017 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/scrub/dabtree.h b/fs/xfs/scrub/dabtree.h
> index d31468d68cef..365f9f0019e6 100644
> --- a/fs/xfs/scrub/dabtree.h
> +++ b/fs/xfs/scrub/dabtree.h
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2017 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #ifndef __XFS_SCRUB_DABTREE_H__
>  #define __XFS_SCRUB_DABTREE_H__
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index 1a4309b3e786..86324775fc9b 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2017 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> index 00a834d3b56d..13d43d108574 100644
> --- a/fs/xfs/scrub/ialloc.c
> +++ b/fs/xfs/scrub/ialloc.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2017 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index 0c696f7018de..7a6208505980 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2017 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
> index 77c6b22c6bfd..e2bda58c32f0 100644
> --- a/fs/xfs/scrub/parent.c
> +++ b/fs/xfs/scrub/parent.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2017 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
> index 15ae4d23d6ac..6ff906aa0a3b 100644
> --- a/fs/xfs/scrub/quota.c
> +++ b/fs/xfs/scrub/quota.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2017 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
> index 324a5f159145..607a9faa8ecc 100644
> --- a/fs/xfs/scrub/refcount.c
> +++ b/fs/xfs/scrub/refcount.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2017 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index e3e8fba1c99c..326be4e8b71e 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2018 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> index f2b0895294db..ef47826b6725 100644
> --- a/fs/xfs/scrub/repair.h
> +++ b/fs/xfs/scrub/repair.h
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2018 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #ifndef __XFS_SCRUB_REPAIR_H__
>  #define __XFS_SCRUB_REPAIR_H__
> diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
> index b376a9a77c04..c6d763236ba7 100644
> --- a/fs/xfs/scrub/rmap.c
> +++ b/fs/xfs/scrub/rmap.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2017 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
> index 40f462a11ea5..1f86e02a07ca 100644
> --- a/fs/xfs/scrub/rtbitmap.c
> +++ b/fs/xfs/scrub/rtbitmap.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2017 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index 36db098ba583..58ae76b3a421 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2017 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
> index 636424d5e2ee..b295edd5fc0e 100644
> --- a/fs/xfs/scrub/scrub.h
> +++ b/fs/xfs/scrub/scrub.h
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2017 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #ifndef __XFS_SCRUB_SCRUB_H__
>  #define __XFS_SCRUB_SCRUB_H__
> diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
> index 3aa3d60f7c16..570a89812116 100644
> --- a/fs/xfs/scrub/symlink.c
> +++ b/fs/xfs/scrub/symlink.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2017 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
> index 86daed0e3a45..7c76d8b5cb05 100644
> --- a/fs/xfs/scrub/trace.c
> +++ b/fs/xfs/scrub/trace.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2017 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index 794d56bb1af8..cec3e5ece5a1 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2017 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #undef TRACE_SYSTEM
>  #define TRACE_SYSTEM xfs_scrub
> diff --git a/fs/xfs/scrub/xfs_scrub.h b/fs/xfs/scrub/xfs_scrub.h
> index e00e0eadac6a..2897ba3a17e6 100644
> --- a/fs/xfs/scrub/xfs_scrub.h
> +++ b/fs/xfs/scrub/xfs_scrub.h
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2017 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #ifndef __XFS_SCRUB_H__
>  #define __XFS_SCRUB_H__
> diff --git a/fs/xfs/xfs.h b/fs/xfs/xfs.h
> index 5ff7f228d616..583a9f539bf1 100644
> --- a/fs/xfs/xfs.h
> +++ b/fs/xfs/xfs.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_H__
>  #define __XFS_H__
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index 3354140de07e..8039e35147dd 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2008, Christoph Hellwig
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_format.h"
> diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
> index 04327318ef67..94615e34bc86 100644
> --- a/fs/xfs/xfs_acl.h
> +++ b/fs/xfs/xfs_acl.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2001-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_ACL_H__
>  #define __XFS_ACL_H__
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 56e405572909..767d53222f31 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_shared.h"
> diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
> index 69346d460dfa..1c29aaa68fb2 100644
> --- a/fs/xfs/xfs_aops.h
> +++ b/fs/xfs/xfs_aops.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2005-2006 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_AOPS_H__
>  #define __XFS_AOPS_H__
> diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
> index d07bf27451c9..033ff8c478e2 100644
> --- a/fs/xfs/xfs_attr.h
> +++ b/fs/xfs/xfs_attr.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000,2002-2003,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_ATTR_H__
>  #define	__XFS_ATTR_H__
> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index 52818ea2eb50..7ce10055f275 100644
> --- a/fs/xfs/xfs_attr_inactive.c
> +++ b/fs/xfs/xfs_attr_inactive.c
> @@ -1,20 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * Copyright (c) 2013 Red Hat, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 276465ed276e..f9ca80154c9c 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -1,20 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * Copyright (c) 2013 Red Hat, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 618bb71535c8..956ebd583e27 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2016 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_bmap_item.h b/fs/xfs/xfs_bmap_item.h
> index 24b354a2c836..fd1a1b13df51 100644
> --- a/fs/xfs/xfs_bmap_item.h
> +++ b/fs/xfs/xfs_bmap_item.h
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2016 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #ifndef	__XFS_BMAP_ITEM_H__
>  #define	__XFS_BMAP_ITEM_H__
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 06badcbadeb4..7d26933a542f 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1,20 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2006 Silicon Graphics, Inc.
>   * Copyright (c) 2012 Red Hat, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
> index 4d4ae48bd4f6..87363d136bb6 100644
> --- a/fs/xfs/xfs_bmap_util.h
> +++ b/fs/xfs/xfs_bmap_util.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2006 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_BMAP_UTIL_H__
>  #define	__XFS_BMAP_UTIL_H__
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 5179ab9e3d6a..980bc48979e9 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2006 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include <linux/stddef.h>
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index f5f2b71c2fde..d24dbd4dac39 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_BUF_H__
>  #define __XFS_BUF_H__
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index c2311379d1c3..5d18c8089499 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> index 643f53dcfe51..3f7d7b72e7e6 100644
> --- a/fs/xfs/xfs_buf_item.h
> +++ b/fs/xfs/xfs_buf_item.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef	__XFS_BUF_ITEM_H__
>  #define	__XFS_BUF_ITEM_H__
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index b6ae3597bfb0..5142e64e2345 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -1,20 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * Copyright (c) 2013 Red Hat, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index 7b68e6c9a474..678a5fcd7576 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (C) 2010 Red Hat, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_format.h"
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 2567391489bd..0973a0423bed 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2003 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index bdd6bd921528..64bd8640f6e8 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_DQUOT_H__
>  #define __XFS_DQUOT_H__
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index 8eb7415474d6..7dedd17c4813 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2003 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_dquot_item.h b/fs/xfs/xfs_dquot_item.h
> index 502e9464634a..db9df710a308 100644
> --- a/fs/xfs/xfs_dquot_item.h
> +++ b/fs/xfs/xfs_dquot_item.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2003 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_DQUOT_ITEM_H__
>  #define __XFS_DQUOT_ITEM_H__
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index fedb2730ea9b..0470114a8d80 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_format.h"
> diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> index f8c3667790de..246d3e989c6c 100644
> --- a/fs/xfs/xfs_error.h
> +++ b/fs/xfs/xfs_error.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef	__XFS_ERROR_H__
>  #define	__XFS_ERROR_H__
> diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
> index eed698aa9f16..7af7d6faa709 100644
> --- a/fs/xfs/xfs_export.c
> +++ b/fs/xfs/xfs_export.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2004-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_format.h"
> diff --git a/fs/xfs/xfs_export.h b/fs/xfs/xfs_export.h
> index 3272b6ae7a35..64471a3ddb04 100644
> --- a/fs/xfs/xfs_export.h
> +++ b/fs/xfs/xfs_export.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_EXPORT_H__
>  #define __XFS_EXPORT_H__
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index 13e3d1a69e76..0ed68379e551 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -1,21 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
>   * Copyright (c) 2010 David Chinner.
>   * Copyright (c) 2011 Christoph Hellwig.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
> index 60195ea1b84a..990ab3891971 100644
> --- a/fs/xfs/xfs_extent_busy.h
> +++ b/fs/xfs/xfs_extent_busy.h
> @@ -1,21 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
>   * Copyright (c) 2010 David Chinner.
>   * Copyright (c) 2011 Christoph Hellwig.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_EXTENT_BUSY_H__
>  #define	__XFS_EXTENT_BUSY_H__
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index a889b550979a..d9da66c718bb 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
> index a32c794a86b7..2a6a895ca73e 100644
> --- a/fs/xfs/xfs_extfree_item.h
> +++ b/fs/xfs/xfs_extfree_item.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef	__XFS_EXTFREE_ITEM_H__
>  #define	__XFS_EXTFREE_ITEM_H__
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 0e3fb8978344..ddb5e618ab01 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index 3f8722e51dbe..2d2c5ab9143c 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -1,20 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2006-2007 Silicon Graphics, Inc.
>   * Copyright (c) 2014 Christoph Hellwig.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_format.h"
> diff --git a/fs/xfs/xfs_filestream.h b/fs/xfs/xfs_filestream.h
> index 2ef43406e53b..5cc7665e93c9 100644
> --- a/fs/xfs/xfs_filestream.h
> +++ b/fs/xfs/xfs_filestream.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2006-2007 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_FILESTREAM_H__
>  #define __XFS_FILESTREAM_H__
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 0299febece9c..c34fa9c342f2 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2017 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_fsmap.h b/fs/xfs/xfs_fsmap.h
> index 0b9bf822595c..c6c57739b862 100644
> --- a/fs/xfs/xfs_fsmap.h
> +++ b/fs/xfs/xfs_fsmap.h
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2017 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #ifndef __XFS_FSMAP_H__
>  #define __XFS_FSMAP_H__
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index bc7ef18da243..a7afcad6b711 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
> index 20484ed5e919..d023db0862c2 100644
> --- a/fs/xfs/xfs_fsops.h
> +++ b/fs/xfs/xfs_fsops.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_FSOPS_H__
>  #define	__XFS_FSOPS_H__
> diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
> index fdde17a2333c..5169e84ae382 100644
> --- a/fs/xfs/xfs_globals.c
> +++ b/fs/xfs/xfs_globals.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_sysctl.h"
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 164350d91efc..47f417d20a30 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> index d69a0f5a6a73..26c0626f1f75 100644
> --- a/fs/xfs/xfs_icache.h
> +++ b/fs/xfs/xfs_icache.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2006 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef XFS_SYNC_H
>  #define XFS_SYNC_H 1
> diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
> index 5da9599156ed..8381d34cb102 100644
> --- a/fs/xfs/xfs_icreate_item.c
> +++ b/fs/xfs/xfs_icreate_item.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2008-2010, 2013 Dave Chinner
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_icreate_item.h b/fs/xfs/xfs_icreate_item.h
> index 59e89f87c09b..a50d0b01e15a 100644
> --- a/fs/xfs/xfs_icreate_item.h
> +++ b/fs/xfs/xfs_icreate_item.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2008-2010, Dave Chinner
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef XFS_ICREATE_ITEM_H
>  #define XFS_ICREATE_ITEM_H	1
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c85ae83e007f..6cda0f08b045 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2006 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include <linux/log2.h>
>  #include <linux/iversion.h>
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 00fee6824745..5e5217c4011c 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef	__XFS_INODE_H__
>  #define	__XFS_INODE_H__
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 3e5b8574818e..2389c34c172d 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
> index b72373a33cd9..27081eba220c 100644
> --- a/fs/xfs/xfs_inode_item.h
> +++ b/fs/xfs/xfs_inode_item.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef	__XFS_INODE_ITEM_H__
>  #define	__XFS_INODE_ITEM_H__
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 82f7c83c1dad..78b2e29ffae3 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
> index 8de879f0c7d5..4b17f67c888a 100644
> --- a/fs/xfs/xfs_ioctl.h
> +++ b/fs/xfs/xfs_ioctl.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2008 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_IOCTL_H__
>  #define __XFS_IOCTL_H__
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 10fbde359649..fba115f4103a 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2004-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include <linux/compat.h>
>  #include <linux/ioctl.h>
> diff --git a/fs/xfs/xfs_ioctl32.h b/fs/xfs/xfs_ioctl32.h
> index 5492bcf6f442..d28fa824284a 100644
> --- a/fs/xfs/xfs_ioctl32.h
> +++ b/fs/xfs/xfs_ioctl32.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2004-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_IOCTL32_H__
>  #define __XFS_IOCTL32_H__
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index c6ce6f9335b6..99a1a1052885 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1,20 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2006 Silicon Graphics, Inc.
>   * Copyright (c) 2016 Christoph Hellwig.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include <linux/iomap.h>
>  #include "xfs.h"
> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> index ee535065c5d0..b0c98d4faa5b 100644
> --- a/fs/xfs/xfs_iomap.h
> +++ b/fs/xfs/xfs_iomap.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2003-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_IOMAP_H__
>  #define __XFS_IOMAP_H__
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 9925d75411bb..29484091c0d2 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_iops.h b/fs/xfs/xfs_iops.h
> index 0259a383721a..4d24ff309f59 100644
> --- a/fs/xfs/xfs_iops.h
> +++ b/fs/xfs/xfs_iops.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_IOPS_H__
>  #define __XFS_IOPS_H__
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index d58310514423..fa405f3a00dc 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
> index 6ea8b3912fa4..8a822285b671 100644
> --- a/fs/xfs/xfs_itable.h
> +++ b/fs/xfs/xfs_itable.h
> @@ -1,18 +1,6 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2001 Silicon Graphics, Inc.  All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_ITABLE_H__
>  #define	__XFS_ITABLE_H__
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index bee51a14a906..ae1e66fa3f61 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_LINUX__
>  #define __XFS_LINUX__
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index c21039f27e39..e630778c08b6 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index fa8ad31d587f..3c1f6a8b4b70 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef	__XFS_LOG_H__
>  #define __XFS_LOG_H__
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index c15687724728..d3884e08b43c 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -1,18 +1,6 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2010 Red Hat, Inc. All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  
>  #include "xfs.h"
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 129975970d99..b5f82cb36202 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef	__XFS_LOG_PRIV_H__
>  #define __XFS_LOG_PRIV_H__
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 750124b170e5..7d897c58b0c8 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2006 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
> index e68bd1050eab..576c375ce12a 100644
> --- a/fs/xfs/xfs_message.c
> +++ b/fs/xfs/xfs_message.c
> @@ -1,18 +1,6 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2011 Red Hat, Inc.  All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  
>  #include "xfs.h"
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 73ed8fec0328..189fa7b615d3 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 10b90bbc5162..7f3d5e012ba3 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_MOUNT_H__
>  #define	__XFS_MOUNT_H__
> diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
> index 70eea7ae2876..74738813f60d 100644
> --- a/fs/xfs/xfs_mru_cache.c
> +++ b/fs/xfs/xfs_mru_cache.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2006-2007 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_mru_cache.h"
> diff --git a/fs/xfs/xfs_mru_cache.h b/fs/xfs/xfs_mru_cache.h
> index b3f3fbdfcc47..f1fde1ecf730 100644
> --- a/fs/xfs/xfs_mru_cache.h
> +++ b/fs/xfs/xfs_mru_cache.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2006-2007 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_MRU_CACHE_H__
>  #define __XFS_MRU_CACHE_H__
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index 0492436a053f..d3e04d20d8d4 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2016 Oracle.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_ONDISK_H
>  #define __XFS_ONDISK_H
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index c3e014bfc848..9ceb85cce33a 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index e3129b280423..3ccf0fbc9071 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_QM_H__
>  #define __XFS_QM_H__
> diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
> index 36b89e2c5eb9..73a1d77ec187 100644
> --- a/fs/xfs/xfs_qm_bhv.c
> +++ b/fs/xfs/xfs_qm_bhv.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2006 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 3e05d300b14e..abc8a21e3a82 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  
>  #include <linux/capability.h>
> diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> index 3edf52b14919..55b798265ef7 100644
> --- a/fs/xfs/xfs_quota.h
> +++ b/fs/xfs/xfs_quota.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_QUOTA_H__
>  #define __XFS_QUOTA_H__
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index c93fc913dffb..205fbb2a77e4 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2008, Christoph Hellwig
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_format.h"
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index e5866b714d5f..472a73e9d331 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2016 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
> index 0e5327349a13..dd830b69cd1e 100644
> --- a/fs/xfs/xfs_refcount_item.h
> +++ b/fs/xfs/xfs_refcount_item.h
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2016 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #ifndef	__XFS_REFCOUNT_ITEM_H__
>  #define	__XFS_REFCOUNT_ITEM_H__
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 713e857d9ffa..592fb2071a03 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2016 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> index 701487bab468..1532827ba911 100644
> --- a/fs/xfs/xfs_reflink.h
> +++ b/fs/xfs/xfs_reflink.h
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2016 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #ifndef __XFS_REFLINK_H
>  #define __XFS_REFLINK_H 1
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index e5b5b3e7ef82..127dc9c32a54 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2016 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
> index 340c968e1f9c..7e482baa27f5 100644
> --- a/fs/xfs/xfs_rmap_item.h
> +++ b/fs/xfs/xfs_rmap_item.h
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2016 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #ifndef	__XFS_RMAP_ITEM_H__
>  #define	__XFS_RMAP_ITEM_H__
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 488719d43ca8..80bbfe604ce0 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
> index 52632ab727f7..93e77b221355 100644
> --- a/fs/xfs/xfs_rtalloc.h
> +++ b/fs/xfs/xfs_rtalloc.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_RTALLOC_H__
>  #define	__XFS_RTALLOC_H__
> diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> index 056e12b421eb..f8991d21601c 100644
> --- a/fs/xfs/xfs_stats.c
> +++ b/fs/xfs/xfs_stats.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include <linux/proc_fs.h>
> diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
> index f64d0ae345c4..130db070e4d8 100644
> --- a/fs/xfs/xfs_stats.h
> +++ b/fs/xfs/xfs_stats.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_STATS_H__
>  #define __XFS_STATS_H__
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 4e66e61865fb..d55435e94ea3 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2006 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  
>  #include "xfs.h"
> diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
> index 8cee8e8050e3..21cb49a43d7c 100644
> --- a/fs/xfs/xfs_super.h
> +++ b/fs/xfs/xfs_super.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_SUPER_H__
>  #define __XFS_SUPER_H__
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index aed03da637d4..3783afcb68d2 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -1,20 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2006 Silicon Graphics, Inc.
>   * Copyright (c) 2012-2013 Red Hat, Inc.
>   * All rights reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_shared.h"
> diff --git a/fs/xfs/xfs_symlink.h b/fs/xfs/xfs_symlink.h
> index aeaee8923617..9743d8c9394b 100644
> --- a/fs/xfs/xfs_symlink.h
> +++ b/fs/xfs/xfs_symlink.h
> @@ -1,18 +1,6 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2012 Red Hat, Inc. All rights reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_SYMLINK_H
>  #define __XFS_SYMLINK_H 1
> diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
> index afe1f66aaa69..0cc034dfb786 100644
> --- a/fs/xfs/xfs_sysctl.c
> +++ b/fs/xfs/xfs_sysctl.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2001-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include <linux/sysctl.h>
> diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
> index b53a33e69932..168488130a19 100644
> --- a/fs/xfs/xfs_sysctl.h
> +++ b/fs/xfs/xfs_sysctl.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2001-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_SYSCTL_H__
>  #define __XFS_SYSCTL_H__
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index 2d5cd2529f8e..cd6a994a7250 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2014 Red Hat, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  
>  #include "xfs.h"
> diff --git a/fs/xfs/xfs_sysfs.h b/fs/xfs/xfs_sysfs.h
> index d04637181ef2..e9f810fc6731 100644
> --- a/fs/xfs/xfs_sysfs.h
> +++ b/fs/xfs/xfs_sysfs.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2014 Red Hat, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  
>  #ifndef __XFS_SYSFS_H__
> diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
> index 35f3546b6af5..cb6489c22cad 100644
> --- a/fs/xfs/xfs_trace.c
> +++ b/fs/xfs/xfs_trace.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2009, Christoph Hellwig
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 9d4c4ca24fe6..972d45d28097 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2009, Christoph Hellwig
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #undef TRACE_SYSTEM
>  #define TRACE_SYSTEM xfs
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index fc7ba75b8b69..e040af120b69 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -1,20 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
>   * Copyright (C) 2010 Red Hat, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 29706b8b3bd4..6526314f0b8f 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef	__XFS_TRANS_H__
>  #define	__XFS_TRANS_H__
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 41e280ef1483..55326f971cb3 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -1,20 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
>   * Copyright (c) 2008 Dave Chinner
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_trans_bmap.c b/fs/xfs/xfs_trans_bmap.c
> index 230a21df4b12..a15a5cd867f9 100644
> --- a/fs/xfs/xfs_trans_bmap.c
> +++ b/fs/xfs/xfs_trans_bmap.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2016 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index a8ddb4eed279..15919f67a88f 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index c381c02cca45..c23257a26c2b 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000-2002 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
> index 2f44a08bdf65..bd66c76f55e6 100644
> --- a/fs/xfs/xfs_trans_extfree.c
> +++ b/fs/xfs/xfs_trans_extfree.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
> index f7bd7960a90f..e2963a6033b2 100644
> --- a/fs/xfs/xfs_trans_inode.c
> +++ b/fs/xfs/xfs_trans_inode.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> index 9717ae74b36d..091eae9f4e74 100644
> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (c) 2000,2002,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #ifndef __XFS_TRANS_PRIV_H__
>  #define	__XFS_TRANS_PRIV_H__
> diff --git a/fs/xfs/xfs_trans_refcount.c b/fs/xfs/xfs_trans_refcount.c
> index c7f8e82f5bda..46dd4fca8aa7 100644
> --- a/fs/xfs/xfs_trans_refcount.c
> +++ b/fs/xfs/xfs_trans_refcount.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2016 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_trans_rmap.c b/fs/xfs/xfs_trans_rmap.c
> index 5831ca0c270b..726d8e2c0558 100644
> --- a/fs/xfs/xfs_trans_rmap.c
> +++ b/fs/xfs/xfs_trans_rmap.c
> @@ -1,21 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * Copyright (C) 2016 Oracle.  All Rights Reserved.
> - *
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 0594db435972..63ee1d5bf1d7 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -1,19 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Copyright (C) 2008 Christoph Hellwig.
>   * Portions Copyright (C) 2000-2008 Silicon Graphics, Inc.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  
>  #include "xfs.h"
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
