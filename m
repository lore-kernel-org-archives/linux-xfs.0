Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:26344 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751038AbcI2G0U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 02:26:20 -0400
Date: Thu, 29 Sep 2016 16:26:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs/122: decrease the log update done item sizes
Message-ID: <20160929062616.GK9806@dastard>
References: <147511610789.12284.10323409415801065382.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147511610789.12284.10323409415801065382.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Sep 28, 2016 at 07:28:27PM -0700, Darrick J. Wong wrote:
> Redundant fields were removed from the rmap/refcount/bmap update done
> log items, so fix the size tests.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

works for me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> ---
>  tests/xfs/122.out |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/tests/xfs/122.out b/tests/xfs/122.out
> index ae84283..67f7698 100644
> --- a/tests/xfs/122.out
> +++ b/tests/xfs/122.out
> @@ -64,10 +64,10 @@ sizeof(struct xfs_btree_block) = 72
>  sizeof(struct xfs_btree_block_lhdr) = 64
>  sizeof(struct xfs_btree_block_shdr) = 48
>  sizeof(struct xfs_bud_log_format) = 16
> -sizeof(struct xfs_bui_log_format) = 48
> +sizeof(struct xfs_bui_log_format) = 16
>  sizeof(struct xfs_clone_args) = 32
>  sizeof(struct xfs_cud_log_format) = 16
> -sizeof(struct xfs_cui_log_format) = 32
> +sizeof(struct xfs_cui_log_format) = 16
>  sizeof(struct xfs_da3_blkinfo) = 56
>  sizeof(struct xfs_da3_intnode) = 64
>  sizeof(struct xfs_da3_node_hdr) = 64
> @@ -94,7 +94,7 @@ sizeof(struct xfs_rtrmap_key) = 24
>  sizeof(struct xfs_rtrmap_rec) = 32
>  sizeof(struct xfs_rtrmap_root) = 4
>  sizeof(struct xfs_rud_log_format) = 16
> -sizeof(struct xfs_rui_log_format) = 48
> +sizeof(struct xfs_rui_log_format) = 16
>  sizeof(struct xfs_scrub_metadata) = 64
>  sizeof(xfs_agf_t) = 224
>  sizeof(xfs_agfl_t) = 36
> 
> 

-- 
Dave Chinner
david@fromorbit.com
