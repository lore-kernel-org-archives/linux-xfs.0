Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56492 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbfAKRbF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Jan 2019 12:31:05 -0500
Subject: Re: [PATCH 2/5] xfs_metadump: Zap multi fsb blocks
References: <20190107201355.18996-1-stefanrin@gmail.com>
 <20190107201355.18996-3-stefanrin@gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2b4718eb-bf55-600e-2a42-1b3128bf21bf@sandeen.net>
Date: Fri, 11 Jan 2019 11:31:03 -0600
MIME-Version: 1.0
In-Reply-To: <20190107201355.18996-3-stefanrin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>, linux-xfs@vger.kernel.org

On 1/7/19 2:13 PM, Stefan Ring wrote:
> Using basically the same code as in process_single_fsb_objects.
> 
> Signed-off-by: Stefan Ring <stefanrin@gmail.com>

thanks, the change here to goto write: looks good to me.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  db/metadump.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 97d2a490..45705685 100644
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
> @@ -1921,15 +1922,21 @@ process_multi_fsb_objects(
>  
>  			}
>  
> -			if ((!obfuscate && !zero_stale_data) ||
> -			     o >= mp->m_dir_geo->leafblk) {
> -				ret = write_buf(iocur_top);
> -				goto out_pop;
> -			}
> +			if (!obfuscate && !zero_stale_data)
> +				goto write;
>  
> -			process_dir_data_block(iocur_top->data, o,
> -					       last == mp->m_dir_geo->fsbcount);
> +			dp = iocur_top->data;
> +			if (o >= mp->m_dir_geo->freeblk) {
> +				/* TODO, zap any stale data */
> +				goto write;
> +			} else if (o >= mp->m_dir_geo->leafblk) {
> +				process_dir_leaf_block(dp);
> +			} else {
> +				process_dir_data_block(dp, o,
> +					 last == mp->m_dir_geo->fsbcount);
> +			}
>  			iocur_top->need_crc = 1;
> +write:
>  			ret = write_buf(iocur_top);
>  out_pop:
>  			pop_cur();
> 
