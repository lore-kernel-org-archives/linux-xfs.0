Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51968 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750881AbeEGPKo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 11:10:44 -0400
Date: Mon, 7 May 2018 08:10:42 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] xfs: add full xfs_dqblk verifier
Message-ID: <20180507151042.GE22414@infradead.org>
References: <f5d059e3-28de-e365-acd4-d82aa9d17db7@redhat.com>
 <e3e2b0af-c505-8164-5868-c9e05fc1edcc@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3e2b0af-c505-8164-5868-c9e05fc1edcc@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Fri, May 04, 2018 at 12:35:05PM -0500, Eric Sandeen wrote:
> Add an xfs_dqblk verifier so that it can check the uuid on V5 filesystems;
> it calls the existing xfs_dquot_verify verifier to validate the
> xfs_disk_dquot_t contained inside it.  This lets us move the uuid
> verification out of the crc verifier, which makes little sense.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_dquot_buf.c  | 27 ++++++++++++++++++++++-----
>  fs/xfs/libxfs/xfs_quota_defs.h |  2 ++
>  fs/xfs/xfs_dquot.c             | 10 +++++-----
>  fs/xfs/xfs_qm.c                |  2 +-
>  4 files changed, 30 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index 3b92427883fa..d71c0b53536b 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -41,7 +41,12 @@ xfs_calc_dquots_per_chunk(
>  
>  /*
>   * Do some primitive error checking on ondisk dquot data structures.
> + *
> + * The xfs_dqblk structure /contains/ the xfs_disk_dquot structure;
> + * we verify them separately because at some points we have only the
> + * smaller xfs_disk_dquot structure available.
>   */
> +
>  xfs_failaddr_t
>  xfs_dquot_verify(
>  	struct xfs_mount *mp,
> @@ -100,6 +105,20 @@ xfs_dquot_verify(
>  	return NULL;
>  }
>  
> +xfs_failaddr_t
> +xfs_dqblk_verify(
> +	struct xfs_mount	*mp,
> +	struct xfs_dqblk	*dqb,
> +	xfs_dqid_t	 	id,
> +	uint		 	type)	/* used only during quotacheck */
> +{
> +	if (xfs_sb_version_hascrc(&mp->m_sb) &&
> +	    !uuid_equal(&dqb->dd_uuid, &mp->m_sb.sb_meta_uuid))
> +			return __this_address;

Double indentation for the return statement.

>  	struct xfs_mount	*mp,
>  	struct xfs_buf		*bp)
>  {
> -	struct xfs_dqblk	*d = (struct xfs_dqblk *)bp->b_addr;
> +	struct xfs_dqblk	*dqb = (struct xfs_dqblk *)bp->b_addr;

No need for the cast, b_addr is a void pointer.

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
