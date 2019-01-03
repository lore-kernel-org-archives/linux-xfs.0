Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50740 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732002AbfACRzO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jan 2019 12:55:14 -0500
Date: Thu, 3 Jan 2019 09:55:04 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/5] xfs_metadump: Zap multi fsb blocks
Message-ID: <20190103175504.GD20475@magnolia>
References: <20181105213145.7560-1-stefanrin@gmail.com>
 <20181105213145.7560-3-stefanrin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181105213145.7560-3-stefanrin@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 05, 2018 at 10:31:42PM +0100, Stefan Ring wrote:
> Using basically the same code as in process_single_fsb_objects.
> 
> Signed-off-by: Stefan Ring <stefanrin@gmail.com>
> ---
>  db/metadump.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 97d2a490..be7cf360 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -1881,6 +1881,7 @@ process_multi_fsb_objects(
>  	typnm_t		btype,
>  	xfs_fileoff_t	last)
>  {
> +	char		*dp;
>  	int		ret = 0;
>  
>  	switch (btype) {
> @@ -1921,15 +1922,19 @@ process_multi_fsb_objects(
>  
>  			}
>  
> -			if ((!obfuscate && !zero_stale_data) ||

Hmmm, if we're not obfuscating or zeroing data, can we still jump to
write_buf()?

--D

> -			     o >= mp->m_dir_geo->leafblk) {
> -				ret = write_buf(iocur_top);
> -				goto out_pop;
> +			dp = iocur_top->data;
> +			if (o >= mp->m_dir_geo->freeblk) {
> +				/* TODO, zap any stale data */
> +				goto write;
> +			} else if (o >= mp->m_dir_geo->leafblk) {
> +				process_dir_leaf_block(dp);
> +			} else {
> +				process_dir_data_block(dp, o,
> +					 last == mp->m_dir_geo->fsbcount);
>  			}
>  
> -			process_dir_data_block(iocur_top->data, o,
> -					       last == mp->m_dir_geo->fsbcount);
> -			iocur_top->need_crc = 1;
> +			iocur_top->need_crc = obfuscate || zero_stale_data;
> +write:
>  			ret = write_buf(iocur_top);
>  out_pop:
>  			pop_cur();
> -- 
> 2.14.5
> 
