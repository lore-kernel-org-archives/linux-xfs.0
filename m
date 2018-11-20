Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47954 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbeKUCx3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Nov 2018 21:53:29 -0500
Date: Tue, 20 Nov 2018 11:23:30 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/5] xfs: precalculate cluster alignment in inodes and
 blocks
Message-ID: <20181120162330.GE48509@bfoster>
References: <154171920164.30818.2178553842722589349.stgit@magnolia>
 <154171923920.30818.16202775253577895387.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154171923920.30818.16202775253577895387.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Nov 08, 2018 at 03:20:39PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Store the inode cluster alignment information in units of inodes and
> blocks in the mount data so that we don't have to keep recalculating
> them.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_ialloc.c |    8 ++++----
>  fs/xfs/libxfs/xfs_types.c  |    5 ++---
>  fs/xfs/scrub/ialloc.c      |    2 +-
>  fs/xfs/xfs_mount.c         |    2 ++
>  fs/xfs/xfs_mount.h         |    2 ++
>  5 files changed, 11 insertions(+), 8 deletions(-)
> 
> 
...
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 58a037bfac22..0ad025e7f3cf 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -103,6 +103,8 @@ typedef struct xfs_mount {
>  	uint			m_inode_cluster_size;/* min inode buf size */
>  	unsigned int		m_inodes_per_cluster;
>  	unsigned int		m_blocks_per_cluster;
> +	unsigned int		m_cluster_align;
> +	unsigned int		m_cluster_align_inodes;

The m_cluster_align change looks fine:

Reviewed-by: Brian Foster <bfoster@redhat.com>

... but no users of m_cluster_align_inodes?

>  	uint			m_blockmask;	/* sb_blocksize-1 */
>  	uint			m_blockwsize;	/* sb_blocksize in words */
>  	uint			m_blockwmask;	/* blockwsize-1 */
> 
