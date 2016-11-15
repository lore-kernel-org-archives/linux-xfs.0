Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53919 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941318AbcKOKPG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2016 05:15:06 -0500
Date: Tue, 15 Nov 2016 02:15:05 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/16] xfs_repair: fix bogus rmapbt record owner check
Message-ID: <20161115101505.GB1607@infradead.org>
References: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
 <147830449083.26713.15599439011374416048.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147830449083.26713.15599439011374416048.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Fri, Nov 04, 2016 at 05:08:10PM -0700, Darrick J. Wong wrote:
> Make the reverse mapping owner check actually validate inode numbers.
> 
> Coverity-id: 1371628
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/scan.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/repair/scan.c b/repair/scan.c
> index 0e13581..b9ef4dc 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -1052,8 +1052,12 @@ _("%s rmap btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
>  			}
>  
>  			/* Look for impossible owners. */
> -			if (!(owner > 0 || (owner > XFS_RMAP_OWN_MIN &&
> -					    owner <= XFS_RMAP_OWN_FS)))
> +			if (!((owner > XFS_RMAP_OWN_MIN &&
> +			       owner <= XFS_RMAP_OWN_FS) ||
> +			      (XFS_INO_TO_AGNO(mp, owner) < mp->m_sb.sb_agcount &&
> +			       XFS_AGINO_TO_AGBNO(mp,
> +					XFS_INO_TO_AGINO(mp, owner)) <
> +					mp->m_sb.sb_agblocks)))

This condition looks complex enough to break it out into a helper.


Except for that this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
