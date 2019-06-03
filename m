Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45892 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbfFCMcU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Jun 2019 08:32:20 -0400
Date: Mon, 3 Jun 2019 08:32:17 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: inode btree scrubber should calculate im_boffset
 correctly
Message-ID: <20190603123216.GA38223@bfoster>
References: <20190529002545.GB5231@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529002545.GB5231@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, May 28, 2019 at 05:25:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The im_boffset field is in units of bytes, whereas XFS_INO_OFFSET
> returns a value in units of inodes.  Convert the units so that scrub on
> a 64k-block filesystem works correctly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/ialloc.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> index 693eb51f5efb..9b47117180cb 100644
> --- a/fs/xfs/scrub/ialloc.c
> +++ b/fs/xfs/scrub/ialloc.c
> @@ -252,7 +252,8 @@ xchk_iallocbt_check_cluster(
>  	ir_holemask = (irec->ir_holemask & cluster_mask);
>  	imap.im_blkno = XFS_AGB_TO_DADDR(mp, agno, agbno);
>  	imap.im_len = XFS_FSB_TO_BB(mp, mp->m_blocks_per_cluster);
> -	imap.im_boffset = XFS_INO_TO_OFFSET(mp, irec->ir_startino);
> +	imap.im_boffset = XFS_INO_TO_OFFSET(mp, irec->ir_startino) <<
> +			mp->m_sb.sb_inodelog;
>  
>  	if (imap.im_boffset != 0 && cluster_base != 0) {
>  		ASSERT(imap.im_boffset == 0 || cluster_base == 0);
