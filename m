Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5618FC77B75
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 17:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238193AbjEWRiA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 13:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234240AbjEWRiA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 13:38:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF45C5
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 10:37:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13B8F63548
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 17:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E2EC433D2;
        Tue, 23 May 2023 17:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684863477;
        bh=EDScr7hghm6YvKvEFzsVVbn58c5Z09OHUbWd8qMq43E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X+QJz3550zEnzsmUTMHcqjF9pozYwtoanflZ2FKFU8ZiGme56KHQ1naqNaLYkYnjt
         tgU4QHOgQuRLkfa5TOqeFz6YsIpwbT71rvKxo8StO1mpH69PkkO8rqDSTiTOy3mw/X
         DI9uK0+Km8i9C+j+cGkSy+8ZN83Tp+OZf1nn0wJsWEJfdrtI317gL1jcv/w0R/ZbCk
         IyjcddNEyR4XEiKhBP9wF+u93ls1m0OP2aZtAF4F4QUwDud+9M1aWYwKko9qfiqtO3
         XSt5k+Wu8HKqM2i2zNw0nuloRGvGxUV33HSpFfofmRAG57SOTb8/tePgER5202fpQK
         ee/XYCkN32Cbg==
Date:   Tue, 23 May 2023 10:37:56 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/24] metadump: Define metadump ops for v2 format
Message-ID: <20230523173756.GS11620@frogsfrogsfrogs>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-13-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523090050.373545-13-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 02:30:38PM +0530, Chandan Babu R wrote:
> This commit adds functionality to dump metadata from an XFS filesystem in
> newly introduced v2 format.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  db/metadump.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 70 insertions(+), 3 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 9d7ad76ae..627436e68 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -3037,6 +3037,69 @@ static struct metadump_ops metadump1_ops = {
>  	.release_metadump = release_metadump_v1,
>  };
>  
> +static int
> +init_metadump_v2(void)
> +{
> +	struct xfs_metadump_header xmh = {0};
> +	uint32_t compat_flags = 0;
> +
> +	xmh.xmh_magic = cpu_to_be32(XFS_MD_MAGIC_V2);
> +	xmh.xmh_version = 2;
> +
> +	if (metadump.obfuscate)
> +		compat_flags |= XFS_MD2_INCOMPAT_OBFUSCATED;
> +	if (!metadump.zero_stale_data)
> +		compat_flags |= XFS_MD2_INCOMPAT_FULLBLOCKS;
> +	if (metadump.dirty_log)
> +		compat_flags |= XFS_MD2_INCOMPAT_DIRTYLOG;
> +
> +	xmh.xmh_compat_flags = cpu_to_be32(compat_flags);
> +
> +	if (fwrite(&xmh, sizeof(xmh), 1, metadump.outf) != 1) {
> +		print_warning("error writing to target file");
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int
> +write_metadump_v2(
> +	enum typnm	type,
> +	char		*data,
> +	int64_t		off,
> +	int		len)
> +{
> +	struct xfs_meta_extent	xme;
> +	uint64_t		addr;
> +
> +	addr = off;
> +	if (type == TYP_ELOG)
> +		addr |= XME_ADDR_LOG_DEVICE;
> +	else
> +		addr |= XME_ADDR_DATA_DEVICE;
> +
> +	xme.xme_addr = cpu_to_be64(addr);
> +	xme.xme_len = cpu_to_be32(len);
> +
> +	if (fwrite(&xme, sizeof(xme), 1, metadump.outf) != 1) {
> +		print_warning("error writing to target file");
> +		return -EIO;
> +	}
> +
> +	if (fwrite(data, len << BBSHIFT, 1, metadump.outf) != 1) {
> +		print_warning("error writing to target file");
> +		return -EIO;
> +	}

Oh, I see, the v2 format is a straight stream -- first the v2 header,
then a xfs_meta_extent, then the buffer; and repeat #2 and #3 until
finished.  That ought to be documented in the previous patch.

--D

> +
> +	return 0;
> +}
> +
> +static struct metadump_ops metadump2_ops = {
> +	.init_metadump = init_metadump_v2,
> +	.write_metadump = write_metadump_v2,
> +};
> +
>  static int
>  metadump_f(
>  	int 		argc,
> @@ -3178,7 +3241,10 @@ metadump_f(
>  		}
>  	}
>  
> -	metadump.mdops = &metadump1_ops;
> +	if (metadump.version == 1)
> +		metadump.mdops = &metadump1_ops;
> +	else
> +		metadump.mdops = &metadump2_ops;
>  
>  	ret = metadump.mdops->init_metadump();
>  	if (ret)
> @@ -3203,7 +3269,7 @@ metadump_f(
>  		exitcode = !copy_log(log_type);
>  
>  	/* write the remaining index */
> -	if (!exitcode)
> +	if (!exitcode && metadump.mdops->end_write_metadump)
>  		exitcode = metadump.mdops->end_write_metadump() < 0;
>  
>  	if (metadump.progress_since_warning)
> @@ -3223,7 +3289,8 @@ metadump_f(
>  	while (iocur_sp > start_iocur_sp)
>  		pop_cur();
>  
> -	metadump.mdops->release_metadump();
> +	if (metadump.mdops->release_metadump)
> +		metadump.mdops->release_metadump();
>  
>  out:
>  	return 0;
> -- 
> 2.39.1
> 
