Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A02C001DC
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 17:22:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbjGLRWF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 13:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbjGLRWE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 13:22:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3EA1BD
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 10:22:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80C8461873
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 17:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E4AC433CA;
        Wed, 12 Jul 2023 17:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689182522;
        bh=8cI7mfgGxGmigKGCPK54T16i52QlBDfaidofJaJyj0k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jtLEtABUildONZYGPwZHx6ksuuSpI+Zj3x8NPU/EWQy7xQ6akaHaP3RwnqiPZM029
         1jLc+WBS2ZP/7KTvax5WhjztPvI+OTEt67gkMvmsOZJWdqNnhmgtjIHgfcuOWArMmp
         uVUWxrZaHVo9BQOmf4plSfyMQQ7Fc/HFl6CfeqRwxp1mHtpoRvebGvp8ajwSbNZP8p
         IFg8c/rYnGTpUvkisOEpVlyJACMDJ22SVMf9wFlZKWPZ76v6cT7eo47XzydBihCldj
         0lpliPS/h7OKdTLxTEhBsDFG09l9OiqCNU4M9M6OHmGk0sftQ8I/7eJz1YkWGo9Hsi
         6NSP+NavWdCFA==
Date:   Wed, 12 Jul 2023 10:22:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V2 11/23] metadump: Define metadump ops for v2 format
Message-ID: <20230712172202.GJ108251@frogsfrogsfrogs>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
 <20230606092806.1604491-12-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606092806.1604491-12-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2023 at 02:57:54PM +0530, Chandan Babu R wrote:
> This commit adds functionality to dump metadata from an XFS filesystem in
> newly introduced v2 format.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  db/metadump.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 71 insertions(+), 3 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index b74993c0..537c37f7 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -3054,6 +3054,70 @@ static struct metadump_ops metadump1_ops = {
>  	.release	= release_metadump_v1,
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

Shouldn't this be cpu_to_be32 as well?

--D

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
> +	xfs_daddr_t	off,
> +	int		len)
> +{
> +	struct xfs_meta_extent	xme;
> +	uint64_t		addr;
> +
> +	addr = off;
> +	if (type == TYP_LOG &&
> +		mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev)
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
> @@ -3190,7 +3254,10 @@ metadump_f(
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
> @@ -3214,7 +3281,7 @@ metadump_f(
>  		exitcode = !copy_log();
>  
>  	/* write the remaining index */
> -	if (!exitcode)
> +	if (!exitcode && metadump.mdops->end_write)
>  		exitcode = metadump.mdops->end_write() < 0;
>  
>  	if (metadump.progress_since_warning)
> @@ -3234,7 +3301,8 @@ metadump_f(
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
