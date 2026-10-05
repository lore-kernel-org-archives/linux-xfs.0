Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FD231F998
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 21:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791236938; cv=none; b=dN4JbaXyf9htQ/sseq9abvzDcAFvejUMbMK9oAXLXiizJt3Xf5tBRg7oFEn9SI+vdD89DYw5Y7T5EUYmAgfoPjuCY0EyPIiXILzaDnO357aHhPWCGabyegH4UFxVmI0IQ1wRDDo2DAvK/njkHqZPqAdAgwJBilkSMV88++YSkLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791236938; c=relaxed/simple;
	bh=4/sJOvU/yZTqKL9PF/kJHMW8fm9hI47VJ5XXfz41eeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JpZE0cVRWd5SPP+zxQVYINYKndz5NUaxcjK1hhGbev6VuPAJo+B8g3I0ouSniKl2jxMridm1XbhRwPuK7kT5ZEpLr1cbrCpDhJMKkLH/5u6i3XX63bXsFhPF2o8GDvgGtnAebR8c7w4/6lsmek8yWGhVijr2MR2i11WozO2uin8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eVzW0BZ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eVzW0BZ9"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 99FA21F000FF;
	Mon,  5 Oct 2026 21:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791236936;
	bh=fIu/fKZko4O16xKOloU97xHGDFr9BNZ56aQ+pF7veWY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eVzW0BZ9rZKkR7DdsxN0Lo0UwgeEaJV75F128YgK9Y1KHwhMrM8kopluu7dEODScN
	 jZYm4OUu7L19d/ZFtbvfJXEebRw/z2JEz21RD+umkcnp2AtJGPfC0Qqg5DqjsHcSGU
	 B+UPC2Rc4KlfxDWGwXXc/UoiSZ8lcN4Ng5ZpVOWHf7/d1S8wVAlQaDafTZ3WkkQhBn
	 +9/kcNHGG5T6kkPsfk8Xghj5Vwz5Lw0FqB2Pm83Z9QF2TItImVl0LjSwVrqvhoqExK
	 GfXnNP3zjF876gjCUkgFgUjEv7OBOTERTvfebjpiLGbccWc62XSxDuKJh7YrKnY4qI
	 ijFrxkPfk+JoQ==
Date: Mon, 5 Oct 2026 14:48:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/13] libxfs: cleanup xfs_trans.h
Message-ID: <20261005214856.GQ2705364@frogsfrogsfrogs>
References: <20261005125637.1340355-1-hch@lst.de>
 <20261005125637.1340355-12-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005125637.1340355-12-hch@lst.de>

On Mon, Oct 05, 2026 at 02:56:21PM +0200, Christoph Hellwig wrote:
> Add new xfs_trans_priv.h and xfs_log.h stubs for definitions that aren't
> in xfs_trans.h in the kernel.  This prepares for pulling in the kernel
> version of xfs_trans.h.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libxfs/Makefile               |  4 +++-
>  libxfs/stubs/xfs_log.h        |  7 +++++++
>  libxfs/stubs/xfs_trans.h      |  7 -------
>  libxfs/stubs/xfs_trans_priv.h | 16 ++++++++++++++++
>  libxfs/xfs_alloc.c            |  1 +
>  libxfs/xfs_attr_leaf.c        |  1 +
>  libxfs/xfs_btree.c            |  1 +
>  libxfs/xfs_da_btree.c         |  1 +
>  libxfs/xfs_defer.c            |  2 ++
>  libxfs/xfs_dir2_block.c       |  1 +
>  libxfs/xfs_dir2_data.c        |  1 +
>  libxfs/xfs_dir2_node.c        |  1 +
>  libxfs/xfs_ialloc.c           |  1 +
>  libxfs/xfs_rtbitmap.c         |  1 +
>  libxfs/xfs_sb.c               |  1 +
>  libxfs/xfs_symlink_remote.c   |  1 +
>  libxfs/xfs_trans_inode.c      |  1 +
>  libxfs/xfs_trans_resv.c       |  1 +
>  repair/phase2.c               |  1 +
>  19 files changed, 42 insertions(+), 8 deletions(-)
>  create mode 100644 libxfs/stubs/xfs_log.h
>  create mode 100644 libxfs/stubs/xfs_trans_priv.h
> 
> diff --git a/libxfs/Makefile b/libxfs/Makefile
> index 722e99168f63..f64dd596b645 100644
> --- a/libxfs/Makefile
> +++ b/libxfs/Makefile
> @@ -79,10 +79,12 @@ HFILES = \
>  	stubs/xfs_error.h \
>  	stubs/xfs_extent_busy.h \
>  	stubs/xfs_inode.h \
> +	stubs/xfs_log.h \
>  	stubs/xfs_mount.h \
>  	stubs/xfs_quota.h \
>  	stubs/xfs_trace.h \
> -	stubs/xfs_trans.h
> +	stubs/xfs_trans.h \
> +	stubs/xfs_trans_priv.h
>  
>  CFILES = buf_mem.c \
>  	cache.c \
> diff --git a/libxfs/stubs/xfs_log.h b/libxfs/stubs/xfs_log.h
> new file mode 100644
> index 000000000000..98251ee06688
> --- /dev/null
> +++ b/libxfs/stubs/xfs_log.h
> @@ -0,0 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#ifndef __XFS_LOG_H__
> +#define __XFS_LOG_H__
> +
> +#define xfs_log_item_in_current_chkpt(lip)	(false)
> +
> +#endif /* __XFS_LOG_H__ */
> diff --git a/libxfs/stubs/xfs_trans.h b/libxfs/stubs/xfs_trans.h
> index aa4de91b43a9..2619347df923 100644
> --- a/libxfs/stubs/xfs_trans.h
> +++ b/libxfs/stubs/xfs_trans.h
> @@ -52,7 +52,6 @@ typedef struct xfs_trans {
>  	struct list_head	t_dfops;	/* deferred operations */
>  } xfs_trans_t;
>  
> -void	xfs_trans_init(struct xfs_mount *);
>  int	xfs_trans_roll(struct xfs_trans **);
>  
>  int	libxfs_trans_alloc(struct xfs_mount *mp, struct xfs_trans_res *resp,
> @@ -130,10 +129,4 @@ libxfs_trans_read_buf(
>  	return libxfs_trans_read_buf_map(mp, tp, btp, &map, 1, flags, bpp, ops);
>  }
>  
> -#define xfs_log_item_in_current_chkpt(lip)	(false)
> -
> -/* Contorted mess to make gcc shut up about unused vars. */
> -#define xfs_ail_get_push_target(ail)    \
> -		((log) == (log) ? NULLCOMMITLSN : NULLCOMMITLSN)
> -
>  #endif	/* __XFS_TRANS_H__ */
> diff --git a/libxfs/stubs/xfs_trans_priv.h b/libxfs/stubs/xfs_trans_priv.h
> new file mode 100644
> index 000000000000..bab4e6c2b6c2
> --- /dev/null
> +++ b/libxfs/stubs/xfs_trans_priv.h
> @@ -0,0 +1,16 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2000-2005 Silicon Graphics, Inc.
> + * All Rights Reserved.
> + */
> +
> +#ifndef __XFS_TRANS_PRIV_H__
> +#define __XFS_TRANS_PRIV_H__
> +
> +void	xfs_trans_init(struct xfs_mount *);
> +
> +/* Contorted mess to make gcc shut up about unused vars. */
> +#define xfs_ail_get_push_target(ail)    \
> +	((log) == (log) ? NULLCOMMITLSN : NULLCOMMITLSN)
> +
> +#endif /* __XFS_TRANS_PRIV_H__ */
> diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
> index 13ec03c3b45a..8feaa0edace1 100644
> --- a/libxfs/xfs_alloc.c
> +++ b/libxfs/xfs_alloc.c
> @@ -22,6 +22,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
> +#include "xfs_log.h"
>  #include "xfs_ag.h"
>  #include "xfs_ag_resv.h"
>  #include "xfs_bmap.h"
> diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
> index 240864676aec..86c5c09a5db4 100644
> --- a/libxfs/xfs_attr_leaf.c
> +++ b/libxfs/xfs_attr_leaf.c
> @@ -26,6 +26,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_dir2.h"
> +#include "xfs_log.h"
>  #include "xfs_ag.h"
>  #include "xfs_errortag.h"
>  #include "xfs_health.h"
> diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
> index 9fcb6c349523..60ef7f08b1d3 100644
> --- a/libxfs/xfs_btree.c
> +++ b/libxfs/xfs_btree.c
> @@ -19,6 +19,7 @@
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
>  #include "xfs_alloc.h"
> +#include "xfs_log.h"
>  #include "xfs_btree_staging.h"
>  #include "xfs_ag.h"
>  #include "xfs_alloc_btree.h"
> diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
> index a3a3a1aa4c57..9debb95d86fa 100644
> --- a/libxfs/xfs_da_btree.c
> +++ b/libxfs/xfs_da_btree.c
> @@ -21,6 +21,7 @@
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
>  #include "xfs_buf_item.h"
> +#include "xfs_log.h"
>  #include "xfs_errortag.h"
>  #include "xfs_health.h"
>  
> diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
> index 28e8dcf14475..ab1f81d8bcd2 100644
> --- a/libxfs/xfs_defer.c
> +++ b/libxfs/xfs_defer.c
> @@ -12,10 +12,12 @@
>  #include "xfs_mount.h"
>  #include "xfs_defer.h"
>  #include "xfs_trans.h"
> +#include "xfs_trans_priv.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_inode.h"
>  #include "xfs_inode_item.h"
>  #include "xfs_trace.h"
> +#include "xfs_log.h"
>  #include "xfs_rmap.h"
>  #include "xfs_refcount.h"
>  #include "xfs_bmap.h"
> diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
> index 54cb8b645c9c..6d70e6b429e7 100644
> --- a/libxfs/xfs_dir2_block.c
> +++ b/libxfs/xfs_dir2_block.c
> @@ -19,6 +19,7 @@
>  #include "xfs_dir2_priv.h"
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
> +#include "xfs_log.h"
>  #include "xfs_health.h"
>  
>  /*
> diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
> index 23625d647da4..aecbab61014c 100644
> --- a/libxfs/xfs_dir2_data.c
> +++ b/libxfs/xfs_dir2_data.c
> @@ -17,6 +17,7 @@
>  #include "xfs_error.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
> +#include "xfs_log.h"
>  #include "xfs_health.h"
>  
>  static xfs_failaddr_t xfs_dir2_data_freefind_verify(
> diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
> index 7641cbdb8e10..19cb536e53ef 100644
> --- a/libxfs/xfs_dir2_node.c
> +++ b/libxfs/xfs_dir2_node.c
> @@ -19,6 +19,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
> +#include "xfs_log.h"
>  #include "xfs_health.h"
>  
>  /*
> diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
> index 07f6c0094281..91f4cdf2e4f3 100644
> --- a/libxfs/xfs_ialloc.c
> +++ b/libxfs/xfs_ialloc.c
> @@ -22,6 +22,7 @@
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_trace.h"
> +#include "xfs_log.h"
>  #include "xfs_rmap.h"
>  #include "xfs_ag.h"
>  #include "xfs_health.h"
> diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
> index d4b90548718c..590e0641ff0d 100644
> --- a/libxfs/xfs_rtbitmap.c
> +++ b/libxfs/xfs_rtbitmap.c
> @@ -21,6 +21,7 @@
>  #include "xfs_health.h"
>  #include "xfs_sb.h"
>  #include "xfs_errortag.h"
> +#include "xfs_log.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_extent_busy.h"
>  
> diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
> index 696bafd2cc3e..aae63ccdb6b5 100644
> --- a/libxfs/xfs_sb.c
> +++ b/libxfs/xfs_sb.c
> @@ -19,6 +19,7 @@
>  #include "xfs_buf_item.h"
>  #include "xfs_bmap_btree.h"
>  #include "xfs_alloc_btree.h"
> +#include "xfs_log.h"
>  #include "xfs_rmap_btree.h"
>  #include "xfs_refcount_btree.h"
>  #include "xfs_da_format.h"
> diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
> index 008953d402f6..b0dc3888bf1b 100644
> --- a/libxfs/xfs_symlink_remote.c
> +++ b/libxfs/xfs_symlink_remote.c
> @@ -15,6 +15,7 @@
>  #include "xfs_error.h"
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
> +#include "xfs_log.h"
>  #include "xfs_symlink_remote.h"
>  #include "xfs_bit.h"
>  #include "xfs_bmap.h"
> diff --git a/libxfs/xfs_trans_inode.c b/libxfs/xfs_trans_inode.c
> index 697671007561..e3dca0652d26 100644
> --- a/libxfs/xfs_trans_inode.c
> +++ b/libxfs/xfs_trans_inode.c
> @@ -12,6 +12,7 @@
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
> +#include "xfs_trans_priv.h"
>  #include "xfs_inode_item.h"
>  
>  /*
> diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
> index 5b7660b1cd8a..d15ca0427584 100644
> --- a/libxfs/xfs_trans_resv.c
> +++ b/libxfs/xfs_trans_resv.c
> @@ -19,6 +19,7 @@
>  #include "xfs_trans.h"
>  #include "xfs_trans_space.h"
>  #include "xfs_rtbitmap.h"
> +#include "xfs_log.h"
>  #include "xfs_trace.h"
>  #include "defer_item.h"
>  
> diff --git a/repair/phase2.c b/repair/phase2.c
> index fc96f9c4223c..ee166e62a002 100644
> --- a/repair/phase2.c
> +++ b/repair/phase2.c
> @@ -16,6 +16,7 @@
>  #include "scan.h"
>  #include "rt.h"
>  #include "quotacheck.h"
> +#include "xfs_trans_priv.h"
>  
>  /* workaround craziness in the xlog routines */
>  int xlog_recover_do_trans(struct xlog *log, struct xlog_recover *t, int p)
> -- 
> 2.53.0
> 
> 
