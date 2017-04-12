Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47023 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752010AbdDLGHj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 02:07:39 -0400
Date: Tue, 11 Apr 2017 23:07:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_db: set buf flag for inode or dqblk with "type"
Message-ID: <20170412060730.GJ8502@birch.djwong.org>
References: <20170411225334.GE8502@birch.djwong.org>
 <d7c0fbec-5229-3d69-a435-a68e76ada593@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7c0fbec-5229-3d69-a435-a68e76ada593@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Tue, Apr 11, 2017 at 10:54:15PM -0500, Eric Sandeen wrote:
> Currently, setting "type" to inode or dqblk does not
> appropriately set the buffer type flags for these
> types.  i.e.:
> 
> xfs_db> inode 128
> 
> sets ino_buf, but
> 
> xfs_db> convert inode 128 fsblock
> 0x10 (16)
> xfs_db> fsblock 16
> xfs_db> type inode
> 
> does not.  This is apparent if we try to use "type" to
> switch to an inode or dqblk, then try to use "write -d"
> which tests these flags.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/db/io.c b/db/io.c
> index 9918a51..d78fc66 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -617,6 +617,13 @@ set_iocur_type(
>  	struct xfs_buf	*bp = iocur_top->bp;
>  
>  	iocur_top->typ = t;
> +	iocur_top->ino_buf = 0;
> +	iocur_top->dquot_buf  = 0;

Extra spaces.

> +
> +	if (t->typnm == TYP_INODE)
> +		iocur_top->ino_buf = 1;
> +	else if (t->typnm == TYP_DQBLK)
> +		iocur_top->dquot_buf = 1;

iocur_top->dquot_buf = (t->typnm == TYP_DQBLK); ?

--D

>  
>  	/* verify the buffer if the type has one. */
>  	if (!bp)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
