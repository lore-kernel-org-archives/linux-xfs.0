Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A240EB64DD
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Aug 2023 23:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjHAXtW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Aug 2023 19:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjHAXtV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Aug 2023 19:49:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31221B1
        for <linux-xfs@vger.kernel.org>; Tue,  1 Aug 2023 16:49:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F26461775
        for <linux-xfs@vger.kernel.org>; Tue,  1 Aug 2023 23:49:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C820FC433C8;
        Tue,  1 Aug 2023 23:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690933759;
        bh=tR/7Y81UXoRKwaMVib90wKSVejII9AWKOg23rj8fxuY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ma3TvxZdfB2GlVRK9PKSCie1I4p96O61J6uiyo8Y3bb7MaZLH7KE70uZcGUVSMFtR
         Gf1s3F7WKUBj9r71B4F5yxSMQLGQKLkTyR5UWbpbZWwXyHI/Gl7foknOZpOjzlaxk8
         BCnzR0kALJL6cJXnHi6fYxcOZZqO+1bcFxf10OweYLm6Blwt6/mM0o6LQXNTkZp/mq
         +qjrZ6hbF/Ju6KC7cXi8rvt6dyIXRZU1kN9iLDv8PZLhWUoo6wO/bbckyxUWTJ3Wlc
         TYmDxXkUqsGYn3rBRYFiX7/aA+3m8cSas+WxA/yL1qCCnfNeXZ+OVEbyLr+zasgfGy
         DMfvhRVKInFJw==
Date:   Tue, 1 Aug 2023 16:49:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V3 11/23] metadump: Define metadump ops for v2 format
Message-ID: <20230801234919.GS11352@frogsfrogsfrogs>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
 <20230724043527.238600-12-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230724043527.238600-12-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 24, 2023 at 10:05:15AM +0530, Chandan Babu R wrote:
> This commit adds functionality to dump metadata from an XFS filesystem in
> newly introduced v2 format.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  db/metadump.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 71 insertions(+), 3 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 7f4f0f07..9b4ed70d 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -3056,6 +3056,70 @@ static struct metadump_ops metadump1_ops = {
>  	.release	= release_metadump_v1,
>  };
>  
> +static int
> +init_metadump_v2(void)
> +{
> +	struct xfs_metadump_header xmh = {0};
> +	uint32_t compat_flags = 0;

Indentation     ^ of the local variables should be tabs, not a space.

> +
> +	xmh.xmh_magic = cpu_to_be32(XFS_MD_MAGIC_V2);
> +	xmh.xmh_version = cpu_to_be32(2);
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
> +	const char	*data,
> +	xfs_daddr_t	off,
> +	int		len)
> +{
> +	struct xfs_meta_extent	xme;
> +	uint64_t		addr;

Please line up the      ^       ^ columns.

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +
> +	addr = off;
> +	if (type == TYP_LOG &&
> +	    mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev)
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
> +
> +	return 0;
> +}
> +
> +static struct metadump_ops metadump2_ops = {
> +	.init	= init_metadump_v2,
> +	.write	= write_metadump_v2,
> +};
> +
>  static int
>  metadump_f(
>  	int 		argc,
> @@ -3192,7 +3256,10 @@ metadump_f(
>  		}
>  	}
>  
> -	metadump.mdops = &metadump1_ops;
> +	if (metadump.version == 1)
> +		metadump.mdops = &metadump1_ops;
> +	else
> +		metadump.mdops = &metadump2_ops;
>  
>  	ret = metadump.mdops->init();
>  	if (ret)
> @@ -3216,7 +3283,7 @@ metadump_f(
>  		exitcode = !copy_log();
>  
>  	/* write the remaining index */
> -	if (!exitcode)
> +	if (!exitcode && metadump.mdops->finish_dump)
>  		exitcode = metadump.mdops->finish_dump() < 0;
>  
>  	if (metadump.progress_since_warning)
> @@ -3236,7 +3303,8 @@ metadump_f(
>  	while (iocur_sp > start_iocur_sp)
>  		pop_cur();
>  
> -	metadump.mdops->release();
> +	if (metadump.mdops->release)
> +		metadump.mdops->release();
>  
>  out:
>  	return 0;
> -- 
> 2.39.1
> 
