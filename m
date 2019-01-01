Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:45678 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725941AbfAAXwD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Jan 2019 18:52:03 -0500
Date: Wed, 2 Jan 2019 10:52:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_db: fix finobt record decoding when sparse inodes
 enabled
Message-ID: <20190101235200.GK4205@dastard>
References: <20181231191848.GB20475@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181231191848.GB20475@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Mon, Dec 31, 2018 at 11:18:48AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the sparse inobt record field decoder (inobt_spcrc_hfld) to decode
> finobt records when sparse inodes are enabled.  Otherwise, xfs_db
> prints out bogus things like:
> 
> recs[1] = [startino,freecount,free]
> 1:[214720,16429,0xfffffffffff80000]
> 
> There can never be 16429 records in an inode btree record; instead it
> should print:
> 
> recs[1] = [startino,holemask,count,freecount,free]
> 1:[214720,0,64,45,0xfffffffffff80000]
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  db/type.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/db/type.c b/db/type.c
> index d0234c57..f5f65042 100644
> --- a/db/type.c
> +++ b/db/type.c
> @@ -151,7 +151,7 @@ static const typ_t	__typtab_spcrc[] = {
>  	{ TYP_SYMLINK, "symlink", handle_struct, symlink_crc_hfld,
>  		&xfs_symlink_buf_ops, XFS_SYMLINK_CRC_OFF },
>  	{ TYP_TEXT, "text", handle_text, NULL, NULL, TYP_F_NO_CRC_OFF },
> -	{ TYP_FINOBT, "finobt", handle_struct, inobt_crc_hfld,
> +	{ TYP_FINOBT, "finobt", handle_struct, inobt_spcrc_hfld,
>  		&xfs_inobt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
>  	{ TYP_NONE, NULL }
>  };

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
