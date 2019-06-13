Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55696 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390780AbfFMQ1U (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Jun 2019 12:27:20 -0400
Date: Thu, 13 Jun 2019 12:27:18 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 05/14] xfs: remove unnecessary includes of xfs_itable.h
Message-ID: <20190613162715.GC21773@bfoster>
References: <156032205136.3774243.15725828509940520561.stgit@magnolia>
 <156032208315.3774243.12030637267920512012.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156032208315.3774243.12030637267920512012.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 11, 2019 at 11:48:03PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't include xfs_itable.h in files that don't need it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/common.c |    1 -
>  fs/xfs/scrub/dir.c    |    1 -
>  fs/xfs/scrub/scrub.c  |    1 -
>  fs/xfs/xfs_trace.c    |    1 -
>  4 files changed, 4 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 973aa59975e3..561d7e818e8b 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -17,7 +17,6 @@
>  #include "xfs_sb.h"
>  #include "xfs_inode.h"
>  #include "xfs_icache.h"
> -#include "xfs_itable.h"
>  #include "xfs_alloc.h"
>  #include "xfs_alloc_btree.h"
>  #include "xfs_bmap.h"
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index a38a22785a1a..9018ca4aba64 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -17,7 +17,6 @@
>  #include "xfs_sb.h"
>  #include "xfs_inode.h"
>  #include "xfs_icache.h"
> -#include "xfs_itable.h"
>  #include "xfs_da_format.h"
>  #include "xfs_da_btree.h"
>  #include "xfs_dir2.h"
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index f630389ee176..5689a33e999c 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -17,7 +17,6 @@
>  #include "xfs_sb.h"
>  #include "xfs_inode.h"
>  #include "xfs_icache.h"
> -#include "xfs_itable.h"
>  #include "xfs_alloc.h"
>  #include "xfs_alloc_btree.h"
>  #include "xfs_bmap.h"
> diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
> index cb6489c22cad..f555a3c560b9 100644
> --- a/fs/xfs/xfs_trace.c
> +++ b/fs/xfs/xfs_trace.c
> @@ -16,7 +16,6 @@
>  #include "xfs_btree.h"
>  #include "xfs_da_btree.h"
>  #include "xfs_ialloc.h"
> -#include "xfs_itable.h"
>  #include "xfs_alloc.h"
>  #include "xfs_bmap.h"
>  #include "xfs_attr.h"
> 
