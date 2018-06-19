Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40416 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750961AbeFSEr4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jun 2018 00:47:56 -0400
Date: Mon, 18 Jun 2018 21:47:48 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 0/5] kbuild: build modules from code in multiple
 directories.
Message-ID: <20180619044748.GA18671@infradead.org>
References: <152929708853.17463.17302660556961083137.stgit@noble>
 <20180618082017.GA4752@infradead.org>
 <87po0ne7zw.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87po0ne7zw.fsf@notabene.neil.brown.name>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: NeilBrown <neilb@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-xfs@vger.kernel.org

On Tue, Jun 19, 2018 at 02:05:23PM +1000, NeilBrown wrote:
> From: NeilBrown <neilb@suse.com>
> Date: Tue, 19 Jun 2018 13:59:16 +1000
> Subject: [PATCH] kbuild/xfs: example modobj-m conversion
> 
> This is a demonstration patch to show how
> xfs can be changed to make use of the proposed modobj-m=
> functionality, should the xfs developers want that.

Well, IFF we go with this new functionality I think everyone should
be using it instead of the current hacks.

So text like the above should be in the series cover letter, and this
patch should have an actual description..

I see no argument against these changes, but I've also added the XFS
list.

> 
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  fs/xfs/Makefile        | 78 ++------------------------------------------------
>  fs/xfs/libxfs/Makefile | 43 ++++++++++++++++++++++++++++
>  fs/xfs/scrub/Makefile  | 29 +++++++++++++++++++
>  3 files changed, 74 insertions(+), 76 deletions(-)
>  create mode 100644 fs/xfs/libxfs/Makefile
>  create mode 100644 fs/xfs/scrub/Makefile
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 2f3f75a7f180..0ba854045fe9 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -15,47 +15,7 @@ obj-$(CONFIG_XFS_FS)		+= xfs.o
>  xfs-y				+= xfs_trace.o
>  
>  # build the libxfs code first
> -xfs-y				+= $(addprefix libxfs/, \
> -				   xfs_ag.o \
> -				   xfs_alloc.o \
> -				   xfs_alloc_btree.o \
> -				   xfs_attr.o \
> -				   xfs_attr_leaf.o \
> -				   xfs_attr_remote.o \
> -				   xfs_bit.o \
> -				   xfs_bmap.o \
> -				   xfs_bmap_btree.o \
> -				   xfs_btree.o \
> -				   xfs_da_btree.o \
> -				   xfs_da_format.o \
> -				   xfs_defer.o \
> -				   xfs_dir2.o \
> -				   xfs_dir2_block.o \
> -				   xfs_dir2_data.o \
> -				   xfs_dir2_leaf.o \
> -				   xfs_dir2_node.o \
> -				   xfs_dir2_sf.o \
> -				   xfs_dquot_buf.o \
> -				   xfs_ialloc.o \
> -				   xfs_ialloc_btree.o \
> -				   xfs_iext_tree.o \
> -				   xfs_inode_fork.o \
> -				   xfs_inode_buf.o \
> -				   xfs_log_rlimit.o \
> -				   xfs_ag_resv.o \
> -				   xfs_rmap.o \
> -				   xfs_rmap_btree.o \
> -				   xfs_refcount.o \
> -				   xfs_refcount_btree.o \
> -				   xfs_sb.o \
> -				   xfs_symlink_remote.o \
> -				   xfs_trans_resv.o \
> -				   xfs_types.o \
> -				   )
> -# xfs_rtbitmap is shared with libxfs
> -xfs-$(CONFIG_XFS_RT)		+= $(addprefix libxfs/, \
> -				   xfs_rtbitmap.o \
> -				   )
> +xfs-y				+= libxfs/
>  
>  # highlevel code
>  xfs-y				+= xfs_aops.o \
> @@ -127,38 +87,4 @@ xfs-$(CONFIG_SYSCTL)		+= xfs_sysctl.o
>  xfs-$(CONFIG_COMPAT)		+= xfs_ioctl32.o
>  xfs-$(CONFIG_EXPORTFS_BLOCK_OPS)	+= xfs_pnfs.o
>  
> -# online scrub/repair
> -ifeq ($(CONFIG_XFS_ONLINE_SCRUB),y)
> -
> -# Tracepoints like to blow up, so build that before everything else
> -
> -xfs-y				+= $(addprefix scrub/, \
> -				   trace.o \
> -				   agheader.o \
> -				   alloc.o \
> -				   attr.o \
> -				   bmap.o \
> -				   btree.o \
> -				   common.o \
> -				   dabtree.o \
> -				   dir.o \
> -				   ialloc.o \
> -				   inode.o \
> -				   parent.o \
> -				   refcount.o \
> -				   rmap.o \
> -				   scrub.o \
> -				   symlink.o \
> -				   )
> -
> -xfs-$(CONFIG_XFS_RT)		+= scrub/rtbitmap.o
> -xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
> -
> -# online repair
> -ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
> -xfs-y				+= $(addprefix scrub/, \
> -				   agheader_repair.o \
> -				   repair.o \
> -				   )
> -endif
> -endif
> +xfs-$(CONFIG_XFS_ONLINE_SCRUB)	+= scrub/
> diff --git a/fs/xfs/libxfs/Makefile b/fs/xfs/libxfs/Makefile
> new file mode 100644
> index 000000000000..9b90c289bdda
> --- /dev/null
> +++ b/fs/xfs/libxfs/Makefile
> @@ -0,0 +1,43 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +ccflags-y += -I$(src)/..
> +
> +# xfs_rtbitmap is shared with libxfs
> +xobj-$(CONFIG_XFS_RT)		+= xfs_rtbitmap.o
> +
> +modobj-$(CONFIG_XFS_FS) +=	   xfs_ag.o \
> +				   xfs_alloc.o \
> +				   xfs_alloc_btree.o \
> +				   xfs_attr.o \
> +				   xfs_attr_leaf.o \
> +				   xfs_attr_remote.o \
> +				   xfs_bit.o \
> +				   xfs_bmap.o \
> +				   xfs_bmap_btree.o \
> +				   xfs_btree.o \
> +				   xfs_da_btree.o \
> +				   xfs_da_format.o \
> +				   xfs_defer.o \
> +				   xfs_dir2.o \
> +				   xfs_dir2_block.o \
> +				   xfs_dir2_data.o \
> +				   xfs_dir2_leaf.o \
> +				   xfs_dir2_node.o \
> +				   xfs_dir2_sf.o \
> +				   xfs_dquot_buf.o \
> +				   xfs_ialloc.o \
> +				   xfs_ialloc_btree.o \
> +				   xfs_iext_tree.o \
> +				   xfs_inode_fork.o \
> +				   xfs_inode_buf.o \
> +				   xfs_log_rlimit.o \
> +				   xfs_ag_resv.o \
> +				   xfs_rmap.o \
> +				   xfs_rmap_btree.o \
> +				   xfs_refcount.o \
> +				   xfs_refcount_btree.o \
> +				   xfs_sb.o \
> +				   xfs_symlink_remote.o \
> +				   xfs_trans_resv.o \
> +				   xfs_types.o \
> +				   $(xobj-y)
> diff --git a/fs/xfs/scrub/Makefile b/fs/xfs/scrub/Makefile
> new file mode 100644
> index 000000000000..f91818a0e6ee
> --- /dev/null
> +++ b/fs/xfs/scrub/Makefile
> @@ -0,0 +1,29 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +# Tracepoints like to blow up, so build that before everything else
> +
> +ccflags-y += -I$(src)/..
> +ccflags-y += -I$(src)/../libxfs
> +
> +xobj-$(CONFIG_XFS_RT)		+= rtbitmap.o
> +xobj-$(CONFIG_XFS_QUOTA)	+= quota.o
> +xobj-$(CONFIG_XFS_ONLINE_REPAIR)+= agheader_repair.o \
> +				   repair.o
> +
> +modobj-$(CONFIG_XFS_FS) +=	   trace.o \
> +				   agheader.o \
> +				   alloc.o \
> +				   attr.o \
> +				   bmap.o \
> +				   btree.o \
> +				   common.o \
> +				   dabtree.o \
> +				   dir.o \
> +				   ialloc.o \
> +				   inode.o \
> +				   parent.o \
> +				   refcount.o \
> +				   rmap.o \
> +				   scrub.o \
> +				   symlink.o \
> +				   $(xobj-y)
> -- 
> 2.14.0.rc0.dirty
> 


---end quoted text---
