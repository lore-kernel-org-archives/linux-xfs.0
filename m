Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53462 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfFZPUb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 11:20:31 -0400
Date: Wed, 26 Jun 2019 08:19:40 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH V2] xfs: remove unused header files
Message-ID: <20190626151940.GC5171@magnolia>
References: <22d173bc-2d33-384c-7d79-f6dc0133c282@redhat.com>
 <b1d7947f-3022-261a-eb3c-43e9990e5152@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1d7947f-3022-261a-eb3c-43e9990e5152@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Jun 25, 2019 at 09:41:02PM -0500, Eric Sandeen wrote:
> There are many, many xfs header files which are included but
> unneeded (or included twice) in the xfs code, so remove them.
> 
> nb: xfs_linux.h includes about 9 headers for everyone, so those
> explicit includes get removed by this.  I'm not sure what the
> preference is, but if we wanted explicit includes everywhere,
> a followup patch could remove those xfs_*.h includes from
> xfs_linux.h and move them into the files that need them.
> Or it could be left as-is.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

I like the idea that we'd pick a few of the xfs header files (e.g.
xfs_mount.h and xfs_inode.h) that are included in many many places and
modify them to include their prerequisites, which would enable most of
the C files to lose a lot of their explicit #includes (I mean c'mon, gcc
-MM will sort out build deps).

However, we could at least get rid of the unneccessary includes that we
already have...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> V2: rebase to / regenerate for / latest for-next
> 
> diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> index fdd9d6ede25c..16bb9a328678 100644
> --- a/fs/xfs/kmem.c
> +++ b/fs/xfs/kmem.c
> @@ -3,12 +3,7 @@
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
>   */
> -#include <linux/mm.h>
>  #include <linux/sched/mm.h>
> -#include <linux/highmem.h>
> -#include <linux/slab.h>
> -#include <linux/swap.h>
> -#include <linux/blkdev.h>
>  #include <linux/backing-dev.h>
>  #include "kmem.h"
>  #include "xfs_message.h"
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index e2ba2a3b63b2..87a9747f1d36 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -9,20 +9,12 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
>  #include "xfs_alloc.h"
>  #include "xfs_errortag.h"
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
> -#include "xfs_cksum.h"
>  #include "xfs_trans.h"
> -#include "xfs_bit.h"
> -#include "xfs_bmap.h"
> -#include "xfs_bmap_btree.h"
> -#include "xfs_ag_resv.h"
> -#include "xfs_trans_space.h"
>  #include "xfs_rmap_btree.h"
>  #include "xfs_btree.h"
>  #include "xfs_refcount_btree.h"
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 6fc22b698230..ae2d91b0e9e9 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -13,7 +13,6 @@
>  #include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_defer.h"
> -#include "xfs_inode.h"
>  #include "xfs_btree.h"
>  #include "xfs_rmap.h"
>  #include "xfs_alloc_btree.h"
> @@ -21,7 +20,6 @@
>  #include "xfs_extent_busy.h"
>  #include "xfs_errortag.h"
>  #include "xfs_error.h"
> -#include "xfs_cksum.h"
>  #include "xfs_trace.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 9b2786ee4081..2a94543857a1 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -17,7 +17,6 @@
>  #include "xfs_extent_busy.h"
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
> -#include "xfs_cksum.h"
>  #include "xfs_trans.h"
>  
>  
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index c441f41f14e8..d48fcf11cc35 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -9,23 +9,18 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_bit.h"
>  #include "xfs_mount.h"
>  #include "xfs_defer.h"
>  #include "xfs_da_format.h"
>  #include "xfs_da_btree.h"
>  #include "xfs_attr_sf.h"
>  #include "xfs_inode.h"
> -#include "xfs_alloc.h"
>  #include "xfs_trans.h"
> -#include "xfs_inode_item.h"
>  #include "xfs_bmap.h"
> -#include "xfs_bmap_util.h"
>  #include "xfs_bmap_btree.h"
>  #include "xfs_attr.h"
>  #include "xfs_attr_leaf.h"
>  #include "xfs_attr_remote.h"
> -#include "xfs_error.h"
>  #include "xfs_quota.h"
>  #include "xfs_trans_space.h"
>  #include "xfs_trace.h"
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 654a599a3754..70eb941d02e4 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -10,14 +10,12 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_bit.h"
>  #include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_da_format.h"
>  #include "xfs_da_btree.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
> -#include "xfs_inode_item.h"
>  #include "xfs_bmap_btree.h"
>  #include "xfs_bmap.h"
>  #include "xfs_attr_sf.h"
> @@ -27,7 +25,6 @@
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
>  #include "xfs_buf_item.h"
> -#include "xfs_cksum.h"
>  #include "xfs_dir2.h"
>  #include "xfs_log.h"
>  
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 869bda380eb0..4eb30d357045 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -16,18 +16,10 @@
>  #include "xfs_da_format.h"
>  #include "xfs_da_btree.h"
>  #include "xfs_inode.h"
> -#include "xfs_alloc.h"
>  #include "xfs_trans.h"
> -#include "xfs_inode_item.h"
>  #include "xfs_bmap.h"
> -#include "xfs_bmap_util.h"
>  #include "xfs_attr.h"
> -#include "xfs_attr_leaf.h"
> -#include "xfs_attr_remote.h"
> -#include "xfs_trans_space.h"
>  #include "xfs_trace.h"
> -#include "xfs_cksum.h"
> -#include "xfs_buf_item.h"
>  #include "xfs_error.h"
>  
>  #define ATTR_RMTVALUE_MAPSIZE	1	/* # of map entries at once */
> diff --git a/fs/xfs/libxfs/xfs_bit.c b/fs/xfs/libxfs/xfs_bit.c
> index 40ce5f3094d1..7071ff98fdbc 100644
> --- a/fs/xfs/libxfs/xfs_bit.c
> +++ b/fs/xfs/libxfs/xfs_bit.c
> @@ -5,7 +5,6 @@
>   */
>  #include "xfs.h"
>  #include "xfs_log_format.h"
> -#include "xfs_bit.h"
>  
>  /*
>   * XFS bit manipulation routines, used in non-realtime code.
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 4133bc461e3e..baf0b72c0a37 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -13,14 +13,10 @@
>  #include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_defer.h"
> -#include "xfs_da_format.h"
> -#include "xfs_da_btree.h"
>  #include "xfs_dir2.h"
>  #include "xfs_inode.h"
>  #include "xfs_btree.h"
>  #include "xfs_trans.h"
> -#include "xfs_inode_item.h"
> -#include "xfs_extfree_item.h"
>  #include "xfs_alloc.h"
>  #include "xfs_bmap.h"
>  #include "xfs_bmap_util.h"
> @@ -32,7 +28,6 @@
>  #include "xfs_trans_space.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_trace.h"
> -#include "xfs_symlink.h"
>  #include "xfs_attr_leaf.h"
>  #include "xfs_filestream.h"
>  #include "xfs_rmap.h"
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index e6100bd3ec62..fbb18ba5d905 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -11,10 +11,8 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_bit.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
> -#include "xfs_inode_item.h"
>  #include "xfs_alloc.h"
>  #include "xfs_btree.h"
>  #include "xfs_bmap_btree.h"
> @@ -22,7 +20,6 @@
>  #include "xfs_error.h"
>  #include "xfs_quota.h"
>  #include "xfs_trace.h"
> -#include "xfs_cksum.h"
>  #include "xfs_rmap.h"
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 84c1c3dc54f6..f1048efa4268 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -11,16 +11,13 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_bit.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
> -#include "xfs_inode_item.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_btree.h"
>  #include "xfs_errortag.h"
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
> -#include "xfs_cksum.h"
>  #include "xfs_alloc.h"
>  #include "xfs_log.h"
>  
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 224631d66ade..d1c77fd0815d 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -12,20 +12,14 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_bit.h"
>  #include "xfs_mount.h"
> -#include "xfs_da_format.h"
> -#include "xfs_da_btree.h"
>  #include "xfs_dir2.h"
>  #include "xfs_dir2_priv.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
> -#include "xfs_inode_item.h"
> -#include "xfs_alloc.h"
>  #include "xfs_bmap.h"
> -#include "xfs_attr.h"
>  #include "xfs_attr_leaf.h"
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
> -#include "xfs_cksum.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_log.h"
>  
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index b39053dcb643..b1ae572496b6 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -11,11 +11,8 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_da_format.h"
> -#include "xfs_da_btree.h"
>  #include "xfs_inode.h"
>  #include "xfs_dir2.h"
> -#include "xfs_dir2_priv.h"
>  
>  /*
>   * Shortform directory ops
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 1c6bf2105939..eb2be2a6a25a 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -9,8 +9,6 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_bit.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_defer.h"
>  #include "xfs_trans.h"
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index b25f75032baa..67840723edbb 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -10,16 +10,11 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
> -#include "xfs_da_format.h"
> -#include "xfs_da_btree.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
> -#include "xfs_inode_item.h"
>  #include "xfs_bmap.h"
>  #include "xfs_dir2.h"
>  #include "xfs_dir2_priv.h"
> -#include "xfs_ialloc.h"
>  #include "xfs_errortag.h"
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 19e61509cf53..a6fb0cc2085e 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -11,18 +11,14 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_da_format.h"
> -#include "xfs_da_btree.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
> -#include "xfs_inode_item.h"
>  #include "xfs_bmap.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_dir2.h"
>  #include "xfs_dir2_priv.h"
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
> -#include "xfs_cksum.h"
>  #include "xfs_log.h"
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index 00ae0f0d97c4..2c79be4c3153 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -11,15 +11,11 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_da_format.h"
> -#include "xfs_da_btree.h"
>  #include "xfs_inode.h"
>  #include "xfs_dir2.h"
> -#include "xfs_dir2_priv.h"
>  #include "xfs_error.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
> -#include "xfs_cksum.h"
>  #include "xfs_log.h"
>  
>  static xfs_failaddr_t xfs_dir2_data_freefind_verify(
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index 73bc3ea89723..a53e4585a2f3 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -11,8 +11,6 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_da_format.h"
> -#include "xfs_da_btree.h"
>  #include "xfs_inode.h"
>  #include "xfs_bmap.h"
>  #include "xfs_dir2.h"
> @@ -21,8 +19,6 @@
>  #include "xfs_trace.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
> -#include "xfs_cksum.h"
> -#include "xfs_log.h"
>  
>  /*
>   * Local function declarations.
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 747d14df9785..afcc6642690a 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -11,8 +11,6 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_da_format.h"
> -#include "xfs_da_btree.h"
>  #include "xfs_inode.h"
>  #include "xfs_bmap.h"
>  #include "xfs_dir2.h"
> @@ -21,7 +19,6 @@
>  #include "xfs_trace.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
> -#include "xfs_cksum.h"
>  #include "xfs_log.h"
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 57911731c516..033589257f54 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -10,12 +10,8 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_da_format.h"
> -#include "xfs_da_btree.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
> -#include "xfs_inode_item.h"
> -#include "xfs_error.h"
>  #include "xfs_dir2.h"
>  #include "xfs_dir2_priv.h"
>  #include "xfs_trace.h"
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index 194d2f0194aa..e8bd688a4073 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -16,8 +16,6 @@
>  #include "xfs_trans.h"
>  #include "xfs_qm.h"
>  #include "xfs_error.h"
> -#include "xfs_cksum.h"
> -#include "xfs_trace.h"
>  
>  int
>  xfs_calc_dquots_per_chunk(
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index b6ca15584f5c..04377ab75863 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -12,17 +12,14 @@
>  #include "xfs_bit.h"
>  #include "xfs_sb.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
>  #include "xfs_inode.h"
>  #include "xfs_btree.h"
>  #include "xfs_ialloc.h"
>  #include "xfs_ialloc_btree.h"
>  #include "xfs_alloc.h"
> -#include "xfs_rtalloc.h"
>  #include "xfs_errortag.h"
>  #include "xfs_error.h"
>  #include "xfs_bmap.h"
> -#include "xfs_cksum.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_icreate_item.h"
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index ebb6fadbedb0..3f2772e51d18 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -11,14 +11,12 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_bit.h"
>  #include "xfs_mount.h"
> -#include "xfs_inode.h"
>  #include "xfs_btree.h"
>  #include "xfs_ialloc.h"
>  #include "xfs_ialloc_btree.h"
>  #include "xfs_alloc.h"
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
> -#include "xfs_cksum.h"
>  #include "xfs_trans.h"
>  #include "xfs_rmap.h"
>  
> diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
> index a2beca47eead..27aa3f2bc4bc 100644
> --- a/fs/xfs/libxfs/xfs_iext_tree.c
> +++ b/fs/xfs/libxfs/xfs_iext_tree.c
> @@ -3,19 +3,14 @@
>   * Copyright (c) 2017 Christoph Hellwig.
>   */
>  
> -#include <linux/cache.h>
> -#include <linux/kernel.h>
> -#include <linux/slab.h>
>  #include "xfs.h"
>  #include "xfs_shared.h"
>  #include "xfs_format.h"
>  #include "xfs_bit.h"
>  #include "xfs_log_format.h"
>  #include "xfs_inode.h"
> -#include "xfs_inode_fork.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_bmap.h"
>  #include "xfs_trace.h"
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 9bb9c73c1eb2..28ab3c5255e1 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -10,11 +10,9 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
>  #include "xfs_inode.h"
>  #include "xfs_errortag.h"
>  #include "xfs_error.h"
> -#include "xfs_cksum.h"
>  #include "xfs_icache.h"
>  #include "xfs_trans.h"
>  #include "xfs_ialloc.h"
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 642ef9ed5f57..bf3e04018246 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -3,7 +3,6 @@
>   * Copyright (c) 2000-2006 Silicon Graphics, Inc.
>   * All Rights Reserved.
>   */
> -#include <linux/log2.h>
>  
>  #include "xfs.h"
>  #include "xfs_fs.h"
> @@ -20,12 +19,10 @@
>  #include "xfs_bmap.h"
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
> -#include "xfs_attr_sf.h"
>  #include "xfs_da_format.h"
>  #include "xfs_da_btree.h"
>  #include "xfs_dir2_priv.h"
>  #include "xfs_attr_leaf.h"
> -#include "xfs_shared.h"
>  
>  kmem_zone_t *xfs_ifork_zone;
>  
> diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
> index 1b542ec11d5d..7f55eb3f3653 100644
> --- a/fs/xfs/libxfs/xfs_log_rlimit.c
> +++ b/fs/xfs/libxfs/xfs_log_rlimit.c
> @@ -12,9 +12,7 @@
>  #include "xfs_mount.h"
>  #include "xfs_da_format.h"
>  #include "xfs_trans_space.h"
> -#include "xfs_inode.h"
>  #include "xfs_da_btree.h"
> -#include "xfs_attr_leaf.h"
>  #include "xfs_bmap_btree.h"
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 542aa1475b5f..51bb9bdb0e84 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -9,7 +9,6 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_defer.h"
>  #include "xfs_btree.h"
> @@ -19,7 +18,6 @@
>  #include "xfs_errortag.h"
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
> -#include "xfs_cksum.h"
>  #include "xfs_trans.h"
>  #include "xfs_bit.h"
>  #include "xfs_refcount.h"
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index 5d1dfc49ac89..38529dbacd55 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -12,12 +12,10 @@
>  #include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_btree.h"
> -#include "xfs_bmap.h"
>  #include "xfs_refcount_btree.h"
>  #include "xfs_alloc.h"
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
> -#include "xfs_cksum.h"
>  #include "xfs_trans.h"
>  #include "xfs_bit.h"
>  #include "xfs_rmap.h"
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index 8ed885507dd8..e6aeb390b2fb 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -10,24 +10,17 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_bit.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_defer.h"
> -#include "xfs_da_format.h"
> -#include "xfs_da_btree.h"
>  #include "xfs_btree.h"
>  #include "xfs_trans.h"
>  #include "xfs_alloc.h"
>  #include "xfs_rmap.h"
>  #include "xfs_rmap_btree.h"
> -#include "xfs_trans_space.h"
>  #include "xfs_trace.h"
>  #include "xfs_errortag.h"
>  #include "xfs_error.h"
> -#include "xfs_extent_busy.h"
> -#include "xfs_bmap.h"
>  #include "xfs_inode.h"
> -#include "xfs_ialloc.h"
>  
>  /*
>   * Lookup the first record less than or equal to [bno, len, owner, offset]
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index e9fe53e0dcc8..fc78efa52c94 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -9,18 +9,14 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_bit.h"
>  #include "xfs_sb.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
> -#include "xfs_inode.h"
>  #include "xfs_trans.h"
>  #include "xfs_alloc.h"
>  #include "xfs_btree.h"
>  #include "xfs_rmap.h"
>  #include "xfs_rmap_btree.h"
>  #include "xfs_trace.h"
> -#include "xfs_cksum.h"
>  #include "xfs_error.h"
>  #include "xfs_extent_busy.h"
>  #include "xfs_ag_resv.h"
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index eaaff67e9626..8ea1efc97b41 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -13,15 +13,7 @@
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
>  #include "xfs_bmap.h"
> -#include "xfs_bmap_util.h"
> -#include "xfs_bmap_btree.h"
> -#include "xfs_alloc.h"
> -#include "xfs_error.h"
>  #include "xfs_trans.h"
> -#include "xfs_trans_space.h"
> -#include "xfs_trace.h"
> -#include "xfs_buf.h"
> -#include "xfs_icache.h"
>  #include "xfs_rtalloc.h"
>  
>  
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index aa21edf13d5a..a08dd8f40346 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -10,26 +10,19 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_bit.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
> -#include "xfs_inode.h"
>  #include "xfs_ialloc.h"
>  #include "xfs_alloc.h"
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
> -#include "xfs_cksum.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_bmap_btree.h"
>  #include "xfs_alloc_btree.h"
> -#include "xfs_ialloc_btree.h"
>  #include "xfs_log.h"
>  #include "xfs_rmap_btree.h"
> -#include "xfs_bmap.h"
>  #include "xfs_refcount_btree.h"
>  #include "xfs_da_format.h"
> -#include "xfs_da_btree.h"
>  #include "xfs_health.h"
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
> index 264b94bb2295..3b8260ca7d1b 100644
> --- a/fs/xfs/libxfs/xfs_symlink_remote.c
> +++ b/fs/xfs/libxfs/xfs_symlink_remote.c
> @@ -11,12 +11,8 @@
>  #include "xfs_shared.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_bmap_btree.h"
>  #include "xfs_inode.h"
>  #include "xfs_error.h"
> -#include "xfs_trace.h"
> -#include "xfs_symlink.h"
> -#include "xfs_cksum.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_log.h"
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 9d1326d14af9..d12bbd526e7c 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -15,12 +15,10 @@
>  #include "xfs_da_btree.h"
>  #include "xfs_inode.h"
>  #include "xfs_bmap_btree.h"
> -#include "xfs_ialloc.h"
>  #include "xfs_quota.h"
>  #include "xfs_trans.h"
>  #include "xfs_qm.h"
>  #include "xfs_trans_space.h"
> -#include "xfs_trace.h"
>  
>  #define _ALLOC	true
>  #define _FREE	false
> diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
> index a2bd9f5a5e30..4f595546a639 100644
> --- a/fs/xfs/libxfs/xfs_types.c
> +++ b/fs/xfs/libxfs/xfs_types.c
> @@ -7,19 +7,10 @@
>  #include "xfs.h"
>  #include "xfs_fs.h"
>  #include "xfs_format.h"
> -#include "xfs_log_format.h"
>  #include "xfs_shared.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_bit.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
> -#include "xfs_inode.h"
> -#include "xfs_btree.h"
> -#include "xfs_rmap.h"
> -#include "xfs_alloc_btree.h"
> -#include "xfs_alloc.h"
> -#include "xfs_ialloc.h"
>  
>  /* Find the size of the AG, in blocks. */
>  xfs_agblock_t
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index adaeabdefdd3..5e3fc9f3de13 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -9,20 +9,13 @@
>  #include "xfs_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
>  #include "xfs_btree.h"
> -#include "xfs_bit.h"
> -#include "xfs_log_format.h"
> -#include "xfs_trans.h"
>  #include "xfs_sb.h"
> -#include "xfs_inode.h"
>  #include "xfs_alloc.h"
>  #include "xfs_ialloc.h"
>  #include "xfs_rmap.h"
> -#include "scrub/xfs_scrub.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
> -#include "scrub/trace.h"
>  
>  /* Superblock */
>  
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 64e31f87d490..7a1a38b636a9 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -9,22 +9,17 @@
>  #include "xfs_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
>  #include "xfs_btree.h"
> -#include "xfs_bit.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans.h"
>  #include "xfs_sb.h"
> -#include "xfs_inode.h"
>  #include "xfs_alloc.h"
>  #include "xfs_alloc_btree.h"
>  #include "xfs_ialloc.h"
>  #include "xfs_ialloc_btree.h"
>  #include "xfs_rmap.h"
>  #include "xfs_rmap_btree.h"
> -#include "xfs_refcount.h"
>  #include "xfs_refcount_btree.h"
> -#include "scrub/xfs_scrub.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  #include "scrub/trace.h"
> diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
> index 44883e9112ad..a43d1813c4ff 100644
> --- a/fs/xfs/scrub/alloc.c
> +++ b/fs/xfs/scrub/alloc.c
> @@ -9,19 +9,12 @@
>  #include "xfs_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
>  #include "xfs_btree.h"
> -#include "xfs_bit.h"
> -#include "xfs_log_format.h"
> -#include "xfs_trans.h"
> -#include "xfs_sb.h"
>  #include "xfs_alloc.h"
>  #include "xfs_rmap.h"
> -#include "scrub/xfs_scrub.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  #include "scrub/btree.h"
> -#include "scrub/trace.h"
>  
>  /*
>   * Set us up to scrub free space btrees.
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index dce74ec57038..099a28308815 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -9,26 +9,16 @@
>  #include "xfs_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
> -#include "xfs_btree.h"
> -#include "xfs_bit.h"
>  #include "xfs_log_format.h"
> -#include "xfs_trans.h"
> -#include "xfs_sb.h"
>  #include "xfs_inode.h"
>  #include "xfs_da_format.h"
>  #include "xfs_da_btree.h"
> -#include "xfs_dir2.h"
>  #include "xfs_attr.h"
>  #include "xfs_attr_leaf.h"
> -#include "scrub/xfs_scrub.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  #include "scrub/dabtree.h"
> -#include "scrub/trace.h"
>  
> -#include <linux/posix_acl_xattr.h>
> -#include <linux/xattr.h>
>  
>  /* Set us up to scrub an inode's extended attributes. */
>  int
> diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
> index fdadc9e1dc49..3d47d111be5a 100644
> --- a/fs/xfs/scrub/bitmap.c
> +++ b/fs/xfs/scrub/bitmap.c
> @@ -10,11 +10,6 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
>  #include "xfs_btree.h"
> -#include "scrub/xfs_scrub.h"
> -#include "scrub/scrub.h"
> -#include "scrub/common.h"
> -#include "scrub/trace.h"
> -#include "scrub/repair.h"
>  #include "scrub/bitmap.h"
>  
>  /*
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index a703cd58a90e..1bd29fdc2ab5 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -9,27 +9,19 @@
>  #include "xfs_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
>  #include "xfs_btree.h"
>  #include "xfs_bit.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans.h"
> -#include "xfs_sb.h"
>  #include "xfs_inode.h"
> -#include "xfs_inode_fork.h"
>  #include "xfs_alloc.h"
> -#include "xfs_rtalloc.h"
>  #include "xfs_bmap.h"
> -#include "xfs_bmap_util.h"
>  #include "xfs_bmap_btree.h"
>  #include "xfs_rmap.h"
>  #include "xfs_rmap_btree.h"
> -#include "xfs_refcount.h"
> -#include "scrub/xfs_scrub.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  #include "scrub/btree.h"
> -#include "scrub/trace.h"
>  
>  /* Set us up with an inode's bmap. */
>  int
> diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> index 117910db51b8..f52a7b8256f9 100644
> --- a/fs/xfs/scrub/btree.c
> +++ b/fs/xfs/scrub/btree.c
> @@ -9,14 +9,7 @@
>  #include "xfs_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
>  #include "xfs_btree.h"
> -#include "xfs_bit.h"
> -#include "xfs_log_format.h"
> -#include "xfs_trans.h"
> -#include "xfs_sb.h"
> -#include "xfs_inode.h"
> -#include "xfs_alloc.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  #include "scrub/btree.h"
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 973aa59975e3..18876056e5e0 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -9,22 +9,16 @@
>  #include "xfs_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
>  #include "xfs_btree.h"
> -#include "xfs_bit.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans.h"
>  #include "xfs_sb.h"
>  #include "xfs_inode.h"
>  #include "xfs_icache.h"
> -#include "xfs_itable.h"
>  #include "xfs_alloc.h"
>  #include "xfs_alloc_btree.h"
> -#include "xfs_bmap.h"
> -#include "xfs_bmap_btree.h"
>  #include "xfs_ialloc.h"
>  #include "xfs_ialloc_btree.h"
> -#include "xfs_refcount.h"
>  #include "xfs_refcount_btree.h"
>  #include "xfs_rmap.h"
>  #include "xfs_rmap_btree.h"
> @@ -32,11 +26,9 @@
>  #include "xfs_trans_priv.h"
>  #include "xfs_attr.h"
>  #include "xfs_reflink.h"
> -#include "scrub/xfs_scrub.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  #include "scrub/trace.h"
> -#include "scrub/btree.h"
>  #include "scrub/repair.h"
>  #include "scrub/health.h"
>  
> diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
> index 90527b094878..94c4f1de1922 100644
> --- a/fs/xfs/scrub/dabtree.c
> +++ b/fs/xfs/scrub/dabtree.c
> @@ -9,20 +9,12 @@
>  #include "xfs_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
> -#include "xfs_btree.h"
> -#include "xfs_bit.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans.h"
> -#include "xfs_sb.h"
>  #include "xfs_inode.h"
> -#include "xfs_inode_fork.h"
> -#include "xfs_da_format.h"
> -#include "xfs_da_btree.h"
>  #include "xfs_dir2.h"
>  #include "xfs_dir2_priv.h"
>  #include "xfs_attr_leaf.h"
> -#include "scrub/xfs_scrub.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  #include "scrub/trace.h"
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index a38a22785a1a..1e2e11721eb9 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -9,24 +9,14 @@
>  #include "xfs_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
> -#include "xfs_btree.h"
> -#include "xfs_bit.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans.h"
> -#include "xfs_sb.h"
>  #include "xfs_inode.h"
>  #include "xfs_icache.h"
> -#include "xfs_itable.h"
> -#include "xfs_da_format.h"
> -#include "xfs_da_btree.h"
>  #include "xfs_dir2.h"
>  #include "xfs_dir2_priv.h"
> -#include "xfs_ialloc.h"
> -#include "scrub/xfs_scrub.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
> -#include "scrub/trace.h"
>  #include "scrub/dabtree.h"
>  
>  /* Set us up to scrub directories. */
> diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
> index 07c11e3e6437..fc3f510c9034 100644
> --- a/fs/xfs/scrub/fscounters.c
> +++ b/fs/xfs/scrub/fscounters.c
> @@ -9,22 +9,10 @@
>  #include "xfs_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
> -#include "xfs_btree.h"
> -#include "xfs_bit.h"
> -#include "xfs_log_format.h"
> -#include "xfs_trans.h"
>  #include "xfs_sb.h"
> -#include "xfs_inode.h"
>  #include "xfs_alloc.h"
>  #include "xfs_ialloc.h"
> -#include "xfs_rmap.h"
> -#include "xfs_error.h"
> -#include "xfs_errortag.h"
> -#include "xfs_icache.h"
>  #include "xfs_health.h"
> -#include "xfs_bmap.h"
> -#include "scrub/xfs_scrub.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  #include "scrub/trace.h"
> diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
> index 23cf8e2f25db..b2f602811e9d 100644
> --- a/fs/xfs/scrub/health.c
> +++ b/fs/xfs/scrub/health.c
> @@ -7,18 +7,10 @@
>  #include "xfs_fs.h"
>  #include "xfs_shared.h"
>  #include "xfs_format.h"
> -#include "xfs_trans_resv.h"
> -#include "xfs_mount.h"
> -#include "xfs_defer.h"
>  #include "xfs_btree.h"
> -#include "xfs_bit.h"
> -#include "xfs_log_format.h"
> -#include "xfs_trans.h"
>  #include "xfs_sb.h"
> -#include "xfs_inode.h"
>  #include "xfs_health.h"
>  #include "scrub/scrub.h"
> -#include "scrub/health.h"
>  
>  /*
>   * Scrub and In-Core Filesystem Health Assessments
> diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> index 3c3abd096143..681758704fda 100644
> --- a/fs/xfs/scrub/ialloc.c
> +++ b/fs/xfs/scrub/ialloc.c
> @@ -9,21 +9,14 @@
>  #include "xfs_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
>  #include "xfs_btree.h"
> -#include "xfs_bit.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans.h"
> -#include "xfs_sb.h"
>  #include "xfs_inode.h"
> -#include "xfs_alloc.h"
>  #include "xfs_ialloc.h"
>  #include "xfs_ialloc_btree.h"
>  #include "xfs_icache.h"
>  #include "xfs_rmap.h"
> -#include "xfs_log.h"
> -#include "xfs_trans_priv.h"
> -#include "scrub/xfs_scrub.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  #include "scrub/btree.h"
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index e213efc194a1..6d483ab29e63 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -9,27 +9,17 @@
>  #include "xfs_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
>  #include "xfs_btree.h"
> -#include "xfs_bit.h"
>  #include "xfs_log_format.h"
> -#include "xfs_trans.h"
> -#include "xfs_sb.h"
>  #include "xfs_inode.h"
> -#include "xfs_icache.h"
> -#include "xfs_inode_buf.h"
> -#include "xfs_inode_fork.h"
>  #include "xfs_ialloc.h"
>  #include "xfs_da_format.h"
>  #include "xfs_reflink.h"
>  #include "xfs_rmap.h"
> -#include "xfs_bmap.h"
>  #include "xfs_bmap_util.h"
> -#include "scrub/xfs_scrub.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  #include "scrub/btree.h"
> -#include "scrub/trace.h"
>  
>  /*
>   * Grab total control of the inode metadata.  It doesn't matter here if
> diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
> index d5d197f1b80f..c962bd534690 100644
> --- a/fs/xfs/scrub/parent.c
> +++ b/fs/xfs/scrub/parent.c
> @@ -9,21 +9,13 @@
>  #include "xfs_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
> -#include "xfs_btree.h"
> -#include "xfs_bit.h"
>  #include "xfs_log_format.h"
> -#include "xfs_trans.h"
> -#include "xfs_sb.h"
>  #include "xfs_inode.h"
>  #include "xfs_icache.h"
>  #include "xfs_dir2.h"
>  #include "xfs_dir2_priv.h"
> -#include "xfs_ialloc.h"
> -#include "scrub/xfs_scrub.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
> -#include "scrub/trace.h"
>  
>  /* Set us up to scrub parents. */
>  int
> diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
> index de75effddb0d..0a33b4421c32 100644
> --- a/fs/xfs/scrub/quota.c
> +++ b/fs/xfs/scrub/quota.c
> @@ -9,24 +9,13 @@
>  #include "xfs_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
> -#include "xfs_btree.h"
> -#include "xfs_bit.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans.h"
> -#include "xfs_sb.h"
>  #include "xfs_inode.h"
> -#include "xfs_inode_fork.h"
> -#include "xfs_alloc.h"
> -#include "xfs_bmap.h"
>  #include "xfs_quota.h"
>  #include "xfs_qm.h"
> -#include "xfs_dquot.h"
> -#include "xfs_dquot_item.h"
> -#include "scrub/xfs_scrub.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
> -#include "scrub/trace.h"
>  
>  /* Convert a scrub type code to a DQ flag, or return 0 if error. */
>  static inline uint
> diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
> index 708b4158eb90..93b3793bc5b3 100644
> --- a/fs/xfs/scrub/refcount.c
> +++ b/fs/xfs/scrub/refcount.c
> @@ -7,22 +7,12 @@
>  #include "xfs_fs.h"
>  #include "xfs_shared.h"
>  #include "xfs_format.h"
> -#include "xfs_trans_resv.h"
> -#include "xfs_mount.h"
> -#include "xfs_defer.h"
>  #include "xfs_btree.h"
> -#include "xfs_bit.h"
> -#include "xfs_log_format.h"
> -#include "xfs_trans.h"
> -#include "xfs_sb.h"
> -#include "xfs_alloc.h"
>  #include "xfs_rmap.h"
>  #include "xfs_refcount.h"
> -#include "scrub/xfs_scrub.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  #include "scrub/btree.h"
> -#include "scrub/trace.h"
>  
>  /*
>   * Set us up to scrub reference count btrees.
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index e710005a0c9e..4d3194a2327a 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -9,29 +9,21 @@
>  #include "xfs_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
>  #include "xfs_btree.h"
> -#include "xfs_bit.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans.h"
>  #include "xfs_sb.h"
>  #include "xfs_inode.h"
> -#include "xfs_icache.h"
>  #include "xfs_alloc.h"
>  #include "xfs_alloc_btree.h"
>  #include "xfs_ialloc.h"
>  #include "xfs_ialloc_btree.h"
>  #include "xfs_rmap.h"
>  #include "xfs_rmap_btree.h"
> -#include "xfs_refcount.h"
>  #include "xfs_refcount_btree.h"
>  #include "xfs_extent_busy.h"
>  #include "xfs_ag_resv.h"
> -#include "xfs_trans_space.h"
>  #include "xfs_quota.h"
> -#include "xfs_attr.h"
> -#include "xfs_reflink.h"
> -#include "scrub/xfs_scrub.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  #include "scrub/trace.h"
> diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
> index 92a140c5b55e..8d4cefd761c1 100644
> --- a/fs/xfs/scrub/rmap.c
> +++ b/fs/xfs/scrub/rmap.c
> @@ -9,21 +9,12 @@
>  #include "xfs_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
>  #include "xfs_btree.h"
> -#include "xfs_bit.h"
> -#include "xfs_log_format.h"
> -#include "xfs_trans.h"
> -#include "xfs_sb.h"
> -#include "xfs_alloc.h"
> -#include "xfs_ialloc.h"
>  #include "xfs_rmap.h"
>  #include "xfs_refcount.h"
> -#include "scrub/xfs_scrub.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  #include "scrub/btree.h"
> -#include "scrub/trace.h"
>  
>  /*
>   * Set us up to scrub reverse mapping btrees.
> diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
> index dbe115b075f7..c642bc206c41 100644
> --- a/fs/xfs/scrub/rtbitmap.c
> +++ b/fs/xfs/scrub/rtbitmap.c
> @@ -9,19 +9,12 @@
>  #include "xfs_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
> -#include "xfs_btree.h"
> -#include "xfs_bit.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans.h"
> -#include "xfs_sb.h"
> -#include "xfs_alloc.h"
>  #include "xfs_rtalloc.h"
>  #include "xfs_inode.h"
> -#include "scrub/xfs_scrub.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
> -#include "scrub/trace.h"
>  
>  /* Set us up with the realtime metadata locked. */
>  int
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index f630389ee176..15c8c5f3f688 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -9,36 +9,16 @@
>  #include "xfs_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
> -#include "xfs_btree.h"
> -#include "xfs_bit.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans.h"
> -#include "xfs_sb.h"
>  #include "xfs_inode.h"
> -#include "xfs_icache.h"
> -#include "xfs_itable.h"
> -#include "xfs_alloc.h"
> -#include "xfs_alloc_btree.h"
> -#include "xfs_bmap.h"
> -#include "xfs_bmap_btree.h"
> -#include "xfs_ialloc.h"
> -#include "xfs_ialloc_btree.h"
> -#include "xfs_refcount.h"
> -#include "xfs_refcount_btree.h"
> -#include "xfs_rmap.h"
> -#include "xfs_rmap_btree.h"
>  #include "xfs_quota.h"
>  #include "xfs_qm.h"
>  #include "xfs_errortag.h"
>  #include "xfs_error.h"
> -#include "xfs_log.h"
> -#include "xfs_trans_priv.h"
> -#include "scrub/xfs_scrub.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  #include "scrub/trace.h"
> -#include "scrub/btree.h"
>  #include "scrub/repair.h"
>  #include "scrub/health.h"
>  
> diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
> index f7ebaa946999..99c0b1234c3c 100644
> --- a/fs/xfs/scrub/symlink.c
> +++ b/fs/xfs/scrub/symlink.c
> @@ -9,19 +9,11 @@
>  #include "xfs_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
> -#include "xfs_btree.h"
> -#include "xfs_bit.h"
>  #include "xfs_log_format.h"
> -#include "xfs_trans.h"
> -#include "xfs_sb.h"
>  #include "xfs_inode.h"
> -#include "xfs_inode_fork.h"
>  #include "xfs_symlink.h"
> -#include "scrub/xfs_scrub.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
> -#include "scrub/trace.h"
>  
>  /* Set us up to scrub a symbolic link. */
>  int
> diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
> index 96feaf8dcdec..9eaab2eb5ed3 100644
> --- a/fs/xfs/scrub/trace.c
> +++ b/fs/xfs/scrub/trace.c
> @@ -10,15 +10,9 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
> -#include "xfs_da_format.h"
>  #include "xfs_inode.h"
>  #include "xfs_btree.h"
> -#include "xfs_trans.h"
> -#include "xfs_bit.h"
> -#include "scrub/xfs_scrub.h"
>  #include "scrub/scrub.h"
> -#include "scrub/common.h"
>  
>  /* Figure out which block the btree cursor was pointing to. */
>  static inline xfs_fsblock_t
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index f6af069d4270..cbda40d40326 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -10,11 +10,8 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
> -#include "xfs_acl.h"
>  #include "xfs_attr.h"
>  #include "xfs_trace.h"
> -#include <linux/slab.h>
> -#include <linux/xattr.h>
>  #include <linux/posix_acl_xattr.h>
>  
>  
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index a6f0f4761a37..a5e561707f44 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -12,16 +12,11 @@
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
> -#include "xfs_inode_item.h"
> -#include "xfs_alloc.h"
> -#include "xfs_error.h"
>  #include "xfs_iomap.h"
>  #include "xfs_trace.h"
>  #include "xfs_bmap.h"
>  #include "xfs_bmap_util.h"
> -#include "xfs_bmap_btree.h"
>  #include "xfs_reflink.h"
> -#include <linux/writeback.h>
>  
>  /*
>   * structure owned by writepages passed to individual writepage calls
> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index d4f4c96bcd4c..dc93c51c17de 100644
> --- a/fs/xfs/xfs_attr_inactive.c
> +++ b/fs/xfs/xfs_attr_inactive.c
> @@ -15,18 +15,13 @@
>  #include "xfs_da_format.h"
>  #include "xfs_da_btree.h"
>  #include "xfs_inode.h"
> -#include "xfs_alloc.h"
>  #include "xfs_attr_remote.h"
>  #include "xfs_trans.h"
> -#include "xfs_inode_item.h"
>  #include "xfs_bmap.h"
>  #include "xfs_attr.h"
>  #include "xfs_attr_leaf.h"
> -#include "xfs_error.h"
>  #include "xfs_quota.h"
> -#include "xfs_trace.h"
>  #include "xfs_dir2.h"
> -#include "xfs_defer.h"
>  
>  /*
>   * Look at all the extents for this logical region,
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 7ffee91a9fdb..58fc820a70c6 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -10,22 +10,16 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_bit.h"
>  #include "xfs_mount.h"
>  #include "xfs_da_format.h"
> -#include "xfs_da_btree.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
> -#include "xfs_inode_item.h"
>  #include "xfs_bmap.h"
>  #include "xfs_attr.h"
>  #include "xfs_attr_sf.h"
> -#include "xfs_attr_remote.h"
>  #include "xfs_attr_leaf.h"
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
> -#include "xfs_buf_item.h"
> -#include "xfs_cksum.h"
>  #include "xfs_dir2.h"
>  
>  STATIC int
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index c22afe288b21..4f923da71353 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -15,12 +15,10 @@
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
>  #include "xfs_trans_priv.h"
> -#include "xfs_buf_item.h"
>  #include "xfs_bmap_item.h"
>  #include "xfs_log.h"
>  #include "xfs_bmap.h"
>  #include "xfs_icache.h"
> -#include "xfs_trace.h"
>  #include "xfs_bmap_btree.h"
>  #include "xfs_trans_space.h"
>  
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index b8fa6d337413..98c6a7a71427 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -12,12 +12,10 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_bit.h"
>  #include "xfs_mount.h"
> -#include "xfs_da_format.h"
>  #include "xfs_defer.h"
>  #include "xfs_inode.h"
>  #include "xfs_btree.h"
>  #include "xfs_trans.h"
> -#include "xfs_extfree_item.h"
>  #include "xfs_alloc.h"
>  #include "xfs_bmap.h"
>  #include "xfs_bmap_util.h"
> @@ -28,11 +26,8 @@
>  #include "xfs_trans_space.h"
>  #include "xfs_trace.h"
>  #include "xfs_icache.h"
> -#include "xfs_log.h"
> -#include "xfs_rmap_btree.h"
>  #include "xfs_iomap.h"
>  #include "xfs_reflink.h"
> -#include "xfs_refcount.h"
>  
>  /* Kernel only BMAP related definitions and functions */
>  
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 28e1d16e09a8..ca0849043f54 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -4,23 +4,7 @@
>   * All Rights Reserved.
>   */
>  #include "xfs.h"
> -#include <linux/stddef.h>
> -#include <linux/errno.h>
> -#include <linux/gfp.h>
> -#include <linux/pagemap.h>
> -#include <linux/init.h>
> -#include <linux/vmalloc.h>
> -#include <linux/bio.h>
> -#include <linux/sysctl.h>
> -#include <linux/proc_fs.h>
> -#include <linux/workqueue.h>
> -#include <linux/percpu.h>
> -#include <linux/blkdev.h>
> -#include <linux/hash.h>
> -#include <linux/kthread.h>
> -#include <linux/migrate.h>
>  #include <linux/backing-dev.h>
> -#include <linux/freezer.h>
>  
>  #include "xfs_shared.h"
>  #include "xfs_format.h"
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index b06d92ee94ff..7dcaec54a20b 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -10,15 +10,12 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_bit.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_trans_priv.h"
> -#include "xfs_error.h"
>  #include "xfs_trace.h"
>  #include "xfs_log.h"
> -#include "xfs_inode.h"
>  
>  
>  kmem_zone_t	*xfs_buf_item_zone;
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index ea7b9d35d30b..283df898dd9f 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -10,14 +10,10 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_bit.h"
>  #include "xfs_mount.h"
> -#include "xfs_da_format.h"
> -#include "xfs_da_btree.h"
>  #include "xfs_inode.h"
>  #include "xfs_dir2.h"
>  #include "xfs_dir2_priv.h"
> -#include "xfs_error.h"
>  #include "xfs_trace.h"
>  #include "xfs_bmap.h"
>  #include "xfs_trans.h"
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index 4f5460be4357..8ec7aab89044 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -10,14 +10,11 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_sb.h"
>  #include "xfs_mount.h"
> -#include "xfs_quota.h"
> -#include "xfs_inode.h"
>  #include "xfs_btree.h"
>  #include "xfs_alloc_btree.h"
>  #include "xfs_alloc.h"
>  #include "xfs_error.h"
>  #include "xfs_extent_busy.h"
> -#include "xfs_discard.h"
>  #include "xfs_trace.h"
>  #include "xfs_log.h"
>  
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index a1af984e4913..2dfbfcdc16f4 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -14,16 +14,12 @@
>  #include "xfs_defer.h"
>  #include "xfs_inode.h"
>  #include "xfs_bmap.h"
> -#include "xfs_bmap_util.h"
> -#include "xfs_alloc.h"
>  #include "xfs_quota.h"
> -#include "xfs_error.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_trans_space.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_qm.h"
> -#include "xfs_cksum.h"
>  #include "xfs_trace.h"
>  #include "xfs_log.h"
>  #include "xfs_bmap_btree.h"
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index cda11cbe6192..282ec5af293e 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -12,7 +12,6 @@
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
>  #include "xfs_quota.h"
> -#include "xfs_error.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_trans_priv.h"
> diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
> index e179bea0474d..f1372f9046e3 100644
> --- a/fs/xfs/xfs_export.c
> +++ b/fs/xfs/xfs_export.c
> @@ -9,14 +9,11 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_da_format.h"
> -#include "xfs_da_btree.h"
>  #include "xfs_dir2.h"
>  #include "xfs_export.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
>  #include "xfs_inode_item.h"
> -#include "xfs_trace.h"
>  #include "xfs_icache.h"
>  #include "xfs_log.h"
>  #include "xfs_pnfs.h"
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 99fd40ebffef..ceb711dde472 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -13,12 +13,9 @@
>  #include "xfs_mount.h"
>  #include "xfs_defer.h"
>  #include "xfs_trans.h"
> -#include "xfs_trans.h"
>  #include "xfs_trans_priv.h"
> -#include "xfs_buf_item.h"
>  #include "xfs_extfree_item.h"
>  #include "xfs_log.h"
> -#include "xfs_btree.h"
>  #include "xfs_rmap.h"
>  #include "xfs_alloc.h"
>  #include "xfs_bmap.h"
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 916a35cae5e9..3041b44e38c6 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -10,14 +10,11 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_da_format.h"
> -#include "xfs_da_btree.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
>  #include "xfs_inode_item.h"
>  #include "xfs_bmap.h"
>  #include "xfs_bmap_util.h"
> -#include "xfs_error.h"
>  #include "xfs_dir2.h"
>  #include "xfs_dir2_priv.h"
>  #include "xfs_ioctl.h"
> @@ -28,9 +25,7 @@
>  #include "xfs_iomap.h"
>  #include "xfs_reflink.h"
>  
> -#include <linux/dcache.h>
>  #include <linux/falloc.h>
> -#include <linux/pagevec.h>
>  #include <linux/backing-dev.h>
>  #include <linux/mman.h>
>  
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index b1869aebb263..574a7a8b4736 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -11,17 +11,13 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_sb.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
>  #include "xfs_inode.h"
>  #include "xfs_bmap.h"
> -#include "xfs_bmap_util.h"
>  #include "xfs_alloc.h"
>  #include "xfs_mru_cache.h"
> -#include "xfs_filestream.h"
>  #include "xfs_trace.h"
>  #include "xfs_ag_resv.h"
>  #include "xfs_trans.h"
> -#include "xfs_shared.h"
>  
>  struct xfs_fstrm_item {
>  	struct xfs_mru_cache_elem	mru;
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 3d76a9e35870..5a8f9641562a 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -9,16 +9,12 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
> -#include "xfs_error.h"
>  #include "xfs_btree.h"
>  #include "xfs_rmap_btree.h"
>  #include "xfs_trace.h"
> -#include "xfs_log.h"
>  #include "xfs_rmap.h"
>  #include "xfs_alloc.h"
>  #include "xfs_bit.h"
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 773cb02e7312..3e61d0cc23f8 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -11,15 +11,11 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_sb.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_error.h"
> -#include "xfs_btree.h"
>  #include "xfs_alloc.h"
>  #include "xfs_fsops.h"
>  #include "xfs_trans_space.h"
> -#include "xfs_rtalloc.h"
> -#include "xfs_trace.h"
>  #include "xfs_log.h"
>  #include "xfs_ag.h"
>  #include "xfs_ag_resv.h"
> diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
> index d0d377384120..4e4a7a299ccb 100644
> --- a/fs/xfs/xfs_globals.c
> +++ b/fs/xfs/xfs_globals.c
> @@ -4,7 +4,6 @@
>   * All Rights Reserved.
>   */
>  #include "xfs.h"
> -#include "xfs_sysctl.h"
>  
>  /*
>   * Tunable XFS parameters.  xfs_params is required even when CONFIG_SYSCTL=n,
> diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> index 4c4929f9e7bf..ca66c314a928 100644
> --- a/fs/xfs/xfs_health.c
> +++ b/fs/xfs/xfs_health.c
> @@ -9,12 +9,8 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_bit.h"
>  #include "xfs_sb.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
> -#include "xfs_da_format.h"
> -#include "xfs_da_btree.h"
>  #include "xfs_inode.h"
>  #include "xfs_trace.h"
>  #include "xfs_health.h"
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 336501694443..0b0fd10a36d4 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -12,7 +12,6 @@
>  #include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
> -#include "xfs_error.h"
>  #include "xfs_trans.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_inode_item.h"
> @@ -24,8 +23,6 @@
>  #include "xfs_dquot.h"
>  #include "xfs_reflink.h"
>  
> -#include <linux/kthread.h>
> -#include <linux/freezer.h>
>  #include <linux/iversion.h>
>  
>  /*
> diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
> index c0376135889d..d99a0a3e5f40 100644
> --- a/fs/xfs/xfs_icreate_item.c
> +++ b/fs/xfs/xfs_icreate_item.c
> @@ -6,14 +6,9 @@
>  #include "xfs.h"
>  #include "xfs_fs.h"
>  #include "xfs_shared.h"
> -#include "xfs_format.h"
>  #include "xfs_log_format.h"
> -#include "xfs_trans_resv.h"
> -#include "xfs_bit.h"
> -#include "xfs_mount.h"
>  #include "xfs_trans.h"
>  #include "xfs_trans_priv.h"
> -#include "xfs_error.h"
>  #include "xfs_icreate_item.h"
>  #include "xfs_log.h"
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index f06e544c102e..6467d5e1df2d 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3,7 +3,6 @@
>   * Copyright (c) 2000-2006 Silicon Graphics, Inc.
>   * All Rights Reserved.
>   */
> -#include <linux/log2.h>
>  #include <linux/iversion.h>
>  
>  #include "xfs.h"
> @@ -16,10 +15,7 @@
>  #include "xfs_mount.h"
>  #include "xfs_defer.h"
>  #include "xfs_inode.h"
> -#include "xfs_da_format.h"
> -#include "xfs_da_btree.h"
>  #include "xfs_dir2.h"
> -#include "xfs_attr_sf.h"
>  #include "xfs_attr.h"
>  #include "xfs_trans_space.h"
>  #include "xfs_trans.h"
> @@ -32,7 +28,6 @@
>  #include "xfs_error.h"
>  #include "xfs_quota.h"
>  #include "xfs_filestream.h"
> -#include "xfs_cksum.h"
>  #include "xfs_trace.h"
>  #include "xfs_icache.h"
>  #include "xfs_symlink.h"
> @@ -40,7 +35,6 @@
>  #include "xfs_log.h"
>  #include "xfs_bmap_btree.h"
>  #include "xfs_reflink.h"
> -#include "xfs_dir2_priv.h"
>  
>  kmem_zone_t *xfs_inode_zone;
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 78c571ce8301..c9a502eed204 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -13,7 +13,6 @@
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
>  #include "xfs_inode_item.h"
> -#include "xfs_error.h"
>  #include "xfs_trace.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_buf_item.h"
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index d7dfc13f30f5..7f1732ad6c40 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -11,8 +11,6 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
> -#include "xfs_ioctl.h"
> -#include "xfs_alloc.h"
>  #include "xfs_rtalloc.h"
>  #include "xfs_itable.h"
>  #include "xfs_error.h"
> @@ -25,7 +23,6 @@
>  #include "xfs_export.h"
>  #include "xfs_trace.h"
>  #include "xfs_icache.h"
> -#include "xfs_symlink.h"
>  #include "xfs_trans.h"
>  #include "xfs_acl.h"
>  #include "xfs_btree.h"
> @@ -36,14 +33,8 @@
>  #include "xfs_ag.h"
>  #include "xfs_health.h"
>  
> -#include <linux/capability.h>
> -#include <linux/cred.h>
> -#include <linux/dcache.h>
>  #include <linux/mount.h>
>  #include <linux/namei.h>
> -#include <linux/pagemap.h>
> -#include <linux/slab.h>
> -#include <linux/exportfs.h>
>  
>  /*
>   * xfs_find_handle maps from userspace xfs_fsop_handlereq structure to
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 0f20385ec3c6..d1967fe67472 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -3,11 +3,7 @@
>   * Copyright (c) 2004-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
>   */
> -#include <linux/compat.h>
> -#include <linux/ioctl.h>
>  #include <linux/mount.h>
> -#include <linux/slab.h>
> -#include <linux/uaccess.h>
>  #include <linux/fsmap.h>
>  #include "xfs.h"
>  #include "xfs_fs.h"
> @@ -18,9 +14,7 @@
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
>  #include "xfs_itable.h"
> -#include "xfs_error.h"
>  #include "xfs_fsops.h"
> -#include "xfs_alloc.h"
>  #include "xfs_rtalloc.h"
>  #include "xfs_attr.h"
>  #include "xfs_ioctl.h"
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 63d323916bba..b1ef32822bb9 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -4,7 +4,6 @@
>   * Copyright (c) 2016-2018 Christoph Hellwig.
>   * All Rights Reserved.
>   */
> -#include <linux/iomap.h>
>  #include "xfs.h"
>  #include "xfs_fs.h"
>  #include "xfs_shared.h"
> @@ -12,7 +11,6 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
>  #include "xfs_inode.h"
>  #include "xfs_btree.h"
>  #include "xfs_bmap_btree.h"
> @@ -25,7 +23,6 @@
>  #include "xfs_inode_item.h"
>  #include "xfs_iomap.h"
>  #include "xfs_trace.h"
> -#include "xfs_icache.h"
>  #include "xfs_quota.h"
>  #include "xfs_dquot_item.h"
>  #include "xfs_dquot.h"
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 74047bd0c1ae..ff3c1fae5357 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -10,30 +10,20 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_da_format.h"
>  #include "xfs_inode.h"
> -#include "xfs_bmap.h"
> -#include "xfs_bmap_util.h"
>  #include "xfs_acl.h"
>  #include "xfs_quota.h"
> -#include "xfs_error.h"
>  #include "xfs_attr.h"
>  #include "xfs_trans.h"
>  #include "xfs_trace.h"
>  #include "xfs_icache.h"
>  #include "xfs_symlink.h"
> -#include "xfs_da_btree.h"
>  #include "xfs_dir2.h"
> -#include "xfs_trans_space.h"
>  #include "xfs_iomap.h"
> -#include "xfs_defer.h"
>  
> -#include <linux/capability.h>
>  #include <linux/xattr.h>
>  #include <linux/posix_acl.h>
>  #include <linux/security.h>
> -#include <linux/iomap.h>
> -#include <linux/slab.h>
>  #include <linux/iversion.h>
>  
>  /*
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index eef307cf90a7..31f5df636d8a 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -16,7 +16,6 @@
>  #include "xfs_ialloc_btree.h"
>  #include "xfs_itable.h"
>  #include "xfs_error.h"
> -#include "xfs_trace.h"
>  #include "xfs_icache.h"
>  #include "xfs_health.h"
>  
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 0f849b4095d6..92cd44ac4dd3 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -16,11 +16,7 @@
>  #include "xfs_trans_priv.h"
>  #include "xfs_log.h"
>  #include "xfs_log_priv.h"
> -#include "xfs_log_recover.h"
> -#include "xfs_inode.h"
>  #include "xfs_trace.h"
> -#include "xfs_fsops.h"
> -#include "xfs_cksum.h"
>  #include "xfs_sysfs.h"
>  #include "xfs_sb.h"
>  #include "xfs_health.h"
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index f1855d8ab1f1..fa5602d0fd7f 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -10,10 +10,7 @@
>  #include "xfs_shared.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_error.h"
> -#include "xfs_alloc.h"
>  #include "xfs_extent_busy.h"
> -#include "xfs_discard.h"
>  #include "xfs_trans.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_log.h"
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 06b84bc8100a..1fc70ac61c38 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -13,8 +13,6 @@
>  #include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_defer.h"
> -#include "xfs_da_format.h"
> -#include "xfs_da_btree.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
>  #include "xfs_log.h"
> @@ -26,7 +24,6 @@
>  #include "xfs_alloc.h"
>  #include "xfs_ialloc.h"
>  #include "xfs_quota.h"
> -#include "xfs_cksum.h"
>  #include "xfs_trace.h"
>  #include "xfs_icache.h"
>  #include "xfs_bmap_btree.h"
> diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
> index 6cb1f2468dd0..9804efe525a9 100644
> --- a/fs/xfs/xfs_message.c
> +++ b/fs/xfs/xfs_message.c
> @@ -8,7 +8,6 @@
>  #include "xfs_error.h"
>  #include "xfs_shared.h"
>  #include "xfs_format.h"
> -#include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
>  
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 4e2c63649cab..322da6909290 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -12,9 +12,6 @@
>  #include "xfs_bit.h"
>  #include "xfs_sb.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
> -#include "xfs_da_format.h"
> -#include "xfs_da_btree.h"
>  #include "xfs_inode.h"
>  #include "xfs_dir2.h"
>  #include "xfs_ialloc.h"
> @@ -27,7 +24,6 @@
>  #include "xfs_error.h"
>  #include "xfs_quota.h"
>  #include "xfs_fsops.h"
> -#include "xfs_trace.h"
>  #include "xfs_icache.h"
>  #include "xfs_sysfs.h"
>  #include "xfs_rmap_btree.h"
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index 2d95355a8a0a..0c954cad7449 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -2,24 +2,16 @@
>  /*
>   * Copyright (c) 2014 Christoph Hellwig.
>   */
> -#include <linux/iomap.h>
>  #include "xfs.h"
>  #include "xfs_shared.h"
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
> -#include "xfs_log.h"
>  #include "xfs_bmap.h"
> -#include "xfs_bmap_util.h"
> -#include "xfs_error.h"
>  #include "xfs_iomap.h"
> -#include "xfs_shared.h"
> -#include "xfs_bit.h"
> -#include "xfs_pnfs.h"
>  
>  /*
>   * Ensure that we do not have any outstanding pNFS layouts that can be used by
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index aa6b6db3db0e..71c5d7b98dd5 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -13,19 +13,15 @@
>  #include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
> -#include "xfs_ialloc.h"
>  #include "xfs_itable.h"
>  #include "xfs_quota.h"
> -#include "xfs_error.h"
>  #include "xfs_bmap.h"
> -#include "xfs_bmap_btree.h"
>  #include "xfs_bmap_util.h"
>  #include "xfs_trans.h"
>  #include "xfs_trans_space.h"
>  #include "xfs_qm.h"
>  #include "xfs_trace.h"
>  #include "xfs_icache.h"
> -#include "xfs_cksum.h"
>  
>  /*
>   * The global quota manager. There is only one of these for the entire
> diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
> index 8f03478dabea..5d72e88598b4 100644
> --- a/fs/xfs/xfs_qm_bhv.c
> +++ b/fs/xfs/xfs_qm_bhv.c
> @@ -12,7 +12,6 @@
>  #include "xfs_quota.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
> -#include "xfs_error.h"
>  #include "xfs_trans.h"
>  #include "xfs_qm.h"
>  
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index b3190890f096..da7ad0383037 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -4,7 +4,6 @@
>   * All Rights Reserved.
>   */
>  
> -#include <linux/capability.h>
>  
>  #include "xfs.h"
>  #include "xfs_fs.h"
> @@ -12,17 +11,13 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_bit.h"
>  #include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
> -#include "xfs_error.h"
>  #include "xfs_quota.h"
>  #include "xfs_qm.h"
> -#include "xfs_trace.h"
>  #include "xfs_icache.h"
> -#include "xfs_defer.h"
>  
>  STATIC int	xfs_qm_log_quotaoff(xfs_mount_t *, xfs_qoff_logitem_t **, uint);
>  STATIC int	xfs_qm_log_quotaoff_end(xfs_mount_t *, xfs_qoff_logitem_t *,
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index d453c2c32e04..cd6c7210a373 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -12,10 +12,8 @@
>  #include "xfs_inode.h"
>  #include "xfs_quota.h"
>  #include "xfs_trans.h"
> -#include "xfs_trace.h"
>  #include "xfs_icache.h"
>  #include "xfs_qm.h"
> -#include <linux/quota.h>
>  
>  
>  static void
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index e8a13872389f..d8288aa0670a 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -14,7 +14,6 @@
>  #include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_trans_priv.h"
> -#include "xfs_buf_item.h"
>  #include "xfs_refcount_item.h"
>  #include "xfs_log.h"
>  #include "xfs_refcount.h"
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 680ae7662a78..da0ef8483c13 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -11,21 +11,12 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
>  #include "xfs_defer.h"
> -#include "xfs_da_format.h"
> -#include "xfs_da_btree.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
> -#include "xfs_inode_item.h"
>  #include "xfs_bmap.h"
>  #include "xfs_bmap_util.h"
> -#include "xfs_error.h"
> -#include "xfs_dir2.h"
> -#include "xfs_dir2_priv.h"
> -#include "xfs_ioctl.h"
>  #include "xfs_trace.h"
> -#include "xfs_log.h"
>  #include "xfs_icache.h"
> -#include "xfs_pnfs.h"
>  #include "xfs_btree.h"
>  #include "xfs_refcount_btree.h"
>  #include "xfs_refcount.h"
> @@ -33,11 +24,9 @@
>  #include "xfs_trans_space.h"
>  #include "xfs_bit.h"
>  #include "xfs_alloc.h"
> -#include "xfs_quota_defs.h"
>  #include "xfs_quota.h"
>  #include "xfs_reflink.h"
>  #include "xfs_iomap.h"
> -#include "xfs_rmap_btree.h"
>  #include "xfs_sb.h"
>  #include "xfs_ag_resv.h"
>  
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 0d01a975605c..77ed557b6127 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -14,7 +14,6 @@
>  #include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_trans_priv.h"
> -#include "xfs_buf_item.h"
>  #include "xfs_rmap_item.h"
>  #include "xfs_log.h"
>  #include "xfs_rmap.h"
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index ac0fcdad0c4e..5fa4db3c3e32 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -11,17 +11,11 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_bit.h"
>  #include "xfs_mount.h"
> -#include "xfs_defer.h"
>  #include "xfs_inode.h"
>  #include "xfs_bmap.h"
> -#include "xfs_bmap_util.h"
>  #include "xfs_bmap_btree.h"
> -#include "xfs_alloc.h"
> -#include "xfs_error.h"
>  #include "xfs_trans.h"
>  #include "xfs_trans_space.h"
> -#include "xfs_trace.h"
> -#include "xfs_buf.h"
>  #include "xfs_icache.h"
>  #include "xfs_rtalloc.h"
>  
> diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> index cc509743facd..113883c4f202 100644
> --- a/fs/xfs/xfs_stats.c
> +++ b/fs/xfs/xfs_stats.c
> @@ -4,7 +4,6 @@
>   * All Rights Reserved.
>   */
>  #include "xfs.h"
> -#include <linux/proc_fs.h>
>  
>  struct xstats xfsstats;
>  
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 5c28fb22b44b..181a1d7663ee 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -11,18 +11,15 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_sb.h"
>  #include "xfs_mount.h"
> -#include "xfs_da_format.h"
>  #include "xfs_inode.h"
>  #include "xfs_btree.h"
>  #include "xfs_bmap.h"
>  #include "xfs_alloc.h"
> -#include "xfs_error.h"
>  #include "xfs_fsops.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_log.h"
>  #include "xfs_log_priv.h"
> -#include "xfs_da_btree.h"
>  #include "xfs_dir2.h"
>  #include "xfs_extfree_item.h"
>  #include "xfs_mru_cache.h"
> @@ -38,18 +35,8 @@
>  #include "xfs_refcount_item.h"
>  #include "xfs_bmap_item.h"
>  #include "xfs_reflink.h"
> -#include "xfs_defer.h"
>  
> -#include <linux/namei.h>
> -#include <linux/dax.h>
> -#include <linux/init.h>
> -#include <linux/slab.h>
>  #include <linux/magic.h>
> -#include <linux/mount.h>
> -#include <linux/mempool.h>
> -#include <linux/writeback.h>
> -#include <linux/kthread.h>
> -#include <linux/freezer.h>
>  #include <linux/parser.h>
>  
>  static const struct super_operations xfs_super_operations;
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index b2c1177c717f..ed66fd2de327 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -12,23 +12,14 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_bit.h"
>  #include "xfs_mount.h"
> -#include "xfs_da_format.h"
> -#include "xfs_da_btree.h"
> -#include "xfs_defer.h"
>  #include "xfs_dir2.h"
>  #include "xfs_inode.h"
> -#include "xfs_ialloc.h"
> -#include "xfs_alloc.h"
>  #include "xfs_bmap.h"
>  #include "xfs_bmap_btree.h"
> -#include "xfs_bmap_util.h"
> -#include "xfs_error.h"
>  #include "xfs_quota.h"
>  #include "xfs_trans_space.h"
>  #include "xfs_trace.h"
> -#include "xfs_symlink.h"
>  #include "xfs_trans.h"
> -#include "xfs_log.h"
>  
>  /* ----- Kernel only functions below ----- */
>  int
> diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
> index 0cc034dfb786..31b3bdbd2eba 100644
> --- a/fs/xfs/xfs_sysctl.c
> +++ b/fs/xfs/xfs_sysctl.c
> @@ -4,10 +4,7 @@
>   * All Rights Reserved.
>   */
>  #include "xfs.h"
> -#include <linux/sysctl.h>
> -#include <linux/proc_fs.h>
>  #include "xfs_error.h"
> -#include "xfs_stats.h"
>  
>  static struct ctl_table_header *xfs_table_header;
>  
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index cabda13f3c64..688366d42cd8 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -10,9 +10,7 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_sysfs.h"
> -#include "xfs_log.h"
>  #include "xfs_log_priv.h"
> -#include "xfs_stats.h"
>  #include "xfs_mount.h"
>  
>  struct xfs_sysfs_attr {
> diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
> index cb6489c22cad..bc85b89f88ca 100644
> --- a/fs/xfs/xfs_trace.c
> +++ b/fs/xfs/xfs_trace.c
> @@ -15,24 +15,16 @@
>  #include "xfs_inode.h"
>  #include "xfs_btree.h"
>  #include "xfs_da_btree.h"
> -#include "xfs_ialloc.h"
> -#include "xfs_itable.h"
>  #include "xfs_alloc.h"
>  #include "xfs_bmap.h"
>  #include "xfs_attr.h"
> -#include "xfs_attr_leaf.h"
>  #include "xfs_trans.h"
> -#include "xfs_log.h"
>  #include "xfs_log_priv.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_quota.h"
> -#include "xfs_iomap.h"
> -#include "xfs_aops.h"
>  #include "xfs_dquot_item.h"
>  #include "xfs_dquot.h"
>  #include "xfs_log_recover.h"
> -#include "xfs_inode_item.h"
> -#include "xfs_bmap_btree.h"
>  #include "xfs_filestream.h"
>  #include "xfs_fsmap.h"
>  
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index b026f87608ce..5b31e0b400f4 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -11,7 +11,6 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_inode.h"
>  #include "xfs_extent_busy.h"
>  #include "xfs_quota.h"
>  #include "xfs_trans.h"
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 0cdd8a314d85..b5b3a78ef31c 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -10,11 +10,9 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_inode.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_trans_priv.h"
> -#include "xfs_error.h"
>  #include "xfs_trace.h"
>  
>  /*
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index ba3de1f03b98..1027c9ca6eb8 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -11,7 +11,6 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
> -#include "xfs_error.h"
>  #include "xfs_trans.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_quota.h"
> diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
> index 542927321a61..93d14e47269d 100644
> --- a/fs/xfs/xfs_trans_inode.c
> +++ b/fs/xfs/xfs_trans_inode.c
> @@ -8,13 +8,10 @@
>  #include "xfs_shared.h"
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
> -#include "xfs_trans_resv.h"
> -#include "xfs_mount.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_inode_item.h"
> -#include "xfs_trace.h"
>  
>  #include <linux/iversion.h>
>  
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 3bf275fd7487..3123b5aaad2a 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -8,13 +8,9 @@
>  #include "xfs_shared.h"
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
> -#include "xfs_trans_resv.h"
> -#include "xfs_mount.h"
>  #include "xfs_da_format.h"
>  #include "xfs_inode.h"
>  #include "xfs_attr.h"
> -#include "xfs_attr_leaf.h"
> -#include "xfs_acl.h"
>  
>  #include <linux/posix_acl_xattr.h>
>  #include <linux/xattr.h>
> 
