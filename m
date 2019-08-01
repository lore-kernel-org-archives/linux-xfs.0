Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51524 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727956AbfHAKsC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Aug 2019 06:48:02 -0400
Date: Thu, 1 Aug 2019 06:47:59 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/5] xfs/122: add the new v5 bulkstat/inumbers ioctl
 structures
Message-ID: <20190801104758.GA59093@bfoster>
References: <156462375516.2945299.16564635037236083118.stgit@magnolia>
 <156462377790.2945299.5915136628365061851.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156462377790.2945299.5915136628365061851.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: guaneryu@gmail.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Jul 31, 2019 at 06:42:57PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The new v5 bulkstat and inumbers structures are correctly padded so that
> no format changes are necessary across platforms, so add them to the
> output.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  tests/xfs/122.out |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> 
> diff --git a/tests/xfs/122.out b/tests/xfs/122.out
> index cf9ac9e2..d2d5a184 100644
> --- a/tests/xfs/122.out
> +++ b/tests/xfs/122.out
> @@ -66,6 +66,9 @@ sizeof(struct xfs_btree_block_lhdr) = 64
>  sizeof(struct xfs_btree_block_shdr) = 48
>  sizeof(struct xfs_bud_log_format) = 16
>  sizeof(struct xfs_bui_log_format) = 16
> +sizeof(struct xfs_bulk_ireq) = 64
> +sizeof(struct xfs_bulkstat) = 192
> +sizeof(struct xfs_bulkstat_req) = 64
>  sizeof(struct xfs_clone_args) = 32
>  sizeof(struct xfs_cud_log_format) = 16
>  sizeof(struct xfs_cui_log_format) = 16
> @@ -89,6 +92,8 @@ sizeof(struct xfs_fsop_geom_v4) = 112
>  sizeof(struct xfs_icreate_log) = 28
>  sizeof(struct xfs_inode_log_format) = 56
>  sizeof(struct xfs_inode_log_format_32) = 52
> +sizeof(struct xfs_inumbers) = 24
> +sizeof(struct xfs_inumbers_req) = 64
>  sizeof(struct xfs_log_dinode) = 176
>  sizeof(struct xfs_map_extent) = 32
>  sizeof(struct xfs_phys_extent) = 16
> 
