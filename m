Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58936 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726277AbeJWXeR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Oct 2018 19:34:17 -0400
Subject: Re: [PATCH 1/2] xfs_metadump: Extend zapping to multi fsb dir blocks
References: <20181011194424.20306-1-stefanrin@gmail.com>
 <20181011194424.20306-2-stefanrin@gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c07f1405-0ff0-71e1-56bb-d327d1acd564@sandeen.net>
Date: Tue, 23 Oct 2018 10:10:22 -0500
MIME-Version: 1.0
In-Reply-To: <20181011194424.20306-2-stefanrin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>, linux-xfs@vger.kernel.org

On 10/11/18 2:44 PM, Stefan Ring wrote:
> The processing for data zeroing was never added to process_multi_fsb_objects.
> It is now the same thing that process_single_fsb_objects does.

First, thanks for doing this, seems about right.

But I could use more changelog words here.  ;)

AFAICT, the intent was for process_multi_fsb_objects to call
process_dir_data_block() in order to handle the zeroing for multi-fsb
objects, so at least some of the cases /were/ handled, right?

Your patch seems to be splitting that 3 ways, so we go to 
process_dir_free_block or process_dir_leaf_block or process_dir_data_block,
the first two are new cases that are now handled?  (I do see that this is
the same as the process_single_fsb_objects code.)

Given the old case:

                        if ((!obfuscate && !zero_stale_data) ||
                             o >= mp->m_dir_geo->leafblk) {
                                ret = write_buf(iocur_top);

it looks like we were just directly writing the leaf blocks and
never obfuscating them, is that correct?  I guess I need to go make
some test filesystems... do you know from your testing if this is true?

This seems quite reasonable, I just think it might be doing more
than the changelog says it is...?

-Eric

> ---
>  db/metadump.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index cc2ae9af..ff96860d 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -1862,6 +1862,7 @@ process_multi_fsb_objects(
>  	typnm_t		btype,
>  	xfs_fileoff_t	last)
>  {
> +	char		*dp;
>  	int		ret = 0;
>  
>  	switch (btype) {
> @@ -1902,14 +1903,16 @@ process_multi_fsb_objects(
>  
>  			}
>  
> -			if ((!obfuscate && !zero_stale_data) ||
> -			     o >= mp->m_dir_geo->leafblk) {
> -				ret = write_buf(iocur_top);
> -				goto out_pop;
> +			dp = iocur_top->data;
> +			if (o >= mp->m_dir_geo->freeblk) {
> +				process_dir_free_block(dp);
> +			} else if (o >= mp->m_dir_geo->leafblk) {
> +				process_dir_leaf_block(dp);
> +			} else {
> +				process_dir_data_block(
> +					dp, o, last == mp->m_dir_geo->fsbcount);
>  			}
>  
> -			process_dir_data_block(iocur_top->data, o,
> -					       last == mp->m_dir_geo->fsbcount);
>  			iocur_top->need_crc = 1;
>  			ret = write_buf(iocur_top);
>  out_pop:
> 
