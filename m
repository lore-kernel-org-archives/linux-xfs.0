Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A15FC0015E
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Aug 2023 23:44:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjHAXoq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Aug 2023 19:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjHAXoo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Aug 2023 19:44:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3621CE48
        for <linux-xfs@vger.kernel.org>; Tue,  1 Aug 2023 16:44:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC17F6177A
        for <linux-xfs@vger.kernel.org>; Tue,  1 Aug 2023 23:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3EEC433C8;
        Tue,  1 Aug 2023 23:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690933482;
        bh=OhJaVqVv/tm1M9uRb4J1asoHq5lWR21DgByGkd1U8i8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jTMirHpgcQ4hr+tCY5n+PEe36mEUl/n8hJVBSgbPbHlFA/6Y5K+4pi6IA7AQLjwDc
         vhYKWfPanXHXqXlh6k89ZlHpHcThAFbF5YvamL8C4Eh/vFF7SP9wxn597kiyni3R2D
         Dl+Zj3TiU8nxTUGm66oM1uFyi+IQx79Q1Gp8GYREGQS4w8jHXz4FhEmxRbBz6KNY89
         TOz+CYyOQZKV4ugeDRXaXQgJYSea6abQyP9RESLt00ONpvuWUl0d6FsQjKHgdf0+ox
         SQycSuR81r5vi7j7JR02pZuk4gxxYNqMOnBGIb0HQggIu/6/xsVatLXazjFehjMsPA
         R0Oyuoip8nGDA==
Date:   Tue, 1 Aug 2023 16:44:41 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V3 08/23] metadump: Introduce metadump v1 operations
Message-ID: <20230801234441.GP11352@frogsfrogsfrogs>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
 <20230724043527.238600-9-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230724043527.238600-9-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 24, 2023 at 10:05:12AM +0530, Chandan Babu R wrote:
> This commit moves functionality associated with writing metadump to disk into
> a new function. It also renames metadump initialization, write and release
> functions to reflect the fact that they work with v1 metadump files.
> 
> The metadump initialization, write and release functions are now invoked via
> metadump_ops->init(), metadump_ops->write() and metadump_ops->release()
> respectively.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  db/metadump.c | 124 +++++++++++++++++++++++++-------------------------
>  1 file changed, 62 insertions(+), 62 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index a138453f..c26a49ad 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -152,59 +152,6 @@ print_progress(const char *fmt, ...)
>  	metadump.progress_since_warning = true;
>  }
>  
> -/*
> - * A complete dump file will have a "zero" entry in the last index block,
> - * even if the dump is exactly aligned, the last index will be full of
> - * zeros. If the last index entry is non-zero, the dump is incomplete.
> - * Correspondingly, the last chunk will have a count < num_indices.
> - *
> - * Return 0 for success, -1 for failure.
> - */
> -
> -static int
> -write_index(void)
> -{
> -	struct xfs_metablock *metablock = metadump.metablock;
> -	/*
> -	 * write index block and following data blocks (streaming)
> -	 */
> -	metablock->mb_count = cpu_to_be16(metadump.cur_index);
> -	if (fwrite(metablock, (metadump.cur_index + 1) << BBSHIFT, 1,
> -			metadump.outf) != 1) {
> -		print_warning("error writing to target file");
> -		return -1;
> -	}
> -
> -	memset(metadump.block_index, 0, metadump.num_indices * sizeof(__be64));
> -	metadump.cur_index = 0;
> -	return 0;
> -}
> -
> -/*
> - * Return 0 for success, -errno for failure.
> - */
> -static int
> -write_buf_segment(
> -	char		*data,
> -	int64_t		off,
> -	int		len)
> -{
> -	int		i;
> -	int		ret;
> -
> -	for (i = 0; i < len; i++, off++, data += BBSIZE) {
> -		metadump.block_index[metadump.cur_index] = cpu_to_be64(off);
> -		memcpy(&metadump.block_buffer[metadump.cur_index << BBSHIFT],
> -				data, BBSIZE);
> -		if (++metadump.cur_index == metadump.num_indices) {
> -			ret = write_index();
> -			if (ret)
> -				return -EIO;
> -		}
> -	}
> -	return 0;
> -}
> -
>  /*
>   * we want to preserve the state of the metadata in the dump - whether it is
>   * intact or corrupt, so even if the buffer has a verifier attached to it we
> @@ -241,15 +188,17 @@ write_buf(
>  
>  	/* handle discontiguous buffers */
>  	if (!buf->bbmap) {
> -		ret = write_buf_segment(buf->data, buf->bb, buf->blen);
> +		ret = metadump.mdops->write(buf->typ->typnm, buf->data, buf->bb,
> +				buf->blen);
>  		if (ret)
>  			return ret;
>  	} else {
>  		int	len = 0;
>  		for (i = 0; i < buf->bbmap->nmaps; i++) {
> -			ret = write_buf_segment(buf->data + BBTOB(len),
> -						buf->bbmap->b[i].bm_bn,
> -						buf->bbmap->b[i].bm_len);
> +			ret = metadump.mdops->write(buf->typ->typnm,
> +					buf->data + BBTOB(len),
> +					buf->bbmap->b[i].bm_bn,
> +					buf->bbmap->b[i].bm_len);
>  			if (ret)
>  				return ret;
>  			len += buf->bbmap->b[i].bm_len;
> @@ -3011,7 +2960,7 @@ done:
>  }
>  
>  static int
> -init_metadump(void)
> +init_metadump_v1(void)
>  {
>  	metadump.metablock = (xfs_metablock_t *)calloc(BBSIZE + 1, BBSIZE);
>  	if (metadump.metablock == NULL) {
> @@ -3052,12 +3001,61 @@ init_metadump(void)
>  	return 0;
>  }
>  
> +static int
> +finish_dump_metadump_v1(void)
> +{
> +	/*
> +	 * write index block and following data blocks (streaming)
> +	 */
> +	metadump.metablock->mb_count = cpu_to_be16(metadump.cur_index);
> +	if (fwrite(metadump.metablock, (metadump.cur_index + 1) << BBSHIFT, 1,
> +			metadump.outf) != 1) {
> +		print_warning("error writing to target file");
> +		return -1;
> +	}
> +
> +	memset(metadump.block_index, 0, metadump.num_indices * sizeof(__be64));
> +	metadump.cur_index = 0;
> +	return 0;
> +}
> +
> +static int
> +write_metadump_v1(
> +	enum typnm	type,
> +	const char	*data,
> +	xfs_daddr_t	off,
> +	int		len)
> +{
> +	int		i;
> +	int		ret;
> +
> +	for (i = 0; i < len; i++, off++, data += BBSIZE) {
> +		metadump.block_index[metadump.cur_index] = cpu_to_be64(off);
> +		memcpy(&metadump.block_buffer[metadump.cur_index << BBSHIFT],
> +				data, BBSIZE);
> +		if (++metadump.cur_index == metadump.num_indices) {
> +			ret = finish_dump_metadump_v1();
> +			if (ret)
> +				return -EIO;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  static void
> -release_metadump(void)
> +release_metadump_v1(void)
>  {
>  	free(metadump.metablock);
>  }
>  
> +static struct metadump_ops metadump1_ops = {
> +	.init		= init_metadump_v1,
> +	.write		= write_metadump_v1,
> +	.finish_dump	= finish_dump_metadump_v1,
> +	.release	= release_metadump_v1,
> +};
> +
>  static int
>  metadump_f(
>  	int 		argc,
> @@ -3194,7 +3192,9 @@ metadump_f(
>  		}
>  	}
>  
> -	ret = init_metadump();
> +	metadump.mdops = &metadump1_ops;
> +
> +	ret = metadump.mdops->init();
>  	if (ret)
>  		goto out;
>  
> @@ -3217,7 +3217,7 @@ metadump_f(
>  
>  	/* write the remaining index */
>  	if (!exitcode)
> -		exitcode = write_index() < 0;
> +		exitcode = metadump.mdops->finish_dump() < 0;
>  
>  	if (metadump.progress_since_warning)
>  		fputc('\n', metadump.stdout_metadump ? stderr : stdout);
> @@ -3236,7 +3236,7 @@ metadump_f(
>  	while (iocur_sp > start_iocur_sp)
>  		pop_cur();
>  
> -	release_metadump();
> +	metadump.mdops->release();
>  
>  out:
>  	return 0;
> -- 
> 2.39.1
> 
