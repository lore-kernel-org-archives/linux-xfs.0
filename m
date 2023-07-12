Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBEFAEB64DD
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 17:38:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjGLRiK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 13:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjGLRiJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 13:38:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646551991
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 10:38:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 028B461886
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 17:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53FE2C433C7;
        Wed, 12 Jul 2023 17:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689183487;
        bh=Z/slre679vCCeWZkEB8GFAEAbBogI98DfnLHkoW/A0s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o8LRsBAN4lgp+s7vrjoPltjLr25txQNFrInqncwKQ6LfMoN7xDB/KSlzPK8vf5Nf7
         g8uu0GwPBssvlNtfL/iBqbs4HqelP+GpaB23C4S3XLXHta605xkps4ocupsWAz4qiK
         aEVdBTdRCctizOYrMqPbfxGiyFAfIYbXAOcTvaRZ/9T12TWyVE6UGK+7CxQqd8feAS
         UolRd2X30thSZXtl3W9e+jtP1PFlgjyAHD+viQX5dvbOV8t628thx9OR3bKJnOy46S
         73bYS/CniSDxAlSN0bI7GUXLakVm5l3p8Yn7ZSqRnNtIC76TUcS4Lh5RLbNMdBHLPB
         KxW/+tT3p/Aow==
Date:   Wed, 12 Jul 2023 10:38:06 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V2 16/23] mdrestore: Detect metadump v1 magic before
 reading the header
Message-ID: <20230712173806.GM108251@frogsfrogsfrogs>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
 <20230606092806.1604491-17-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606092806.1604491-17-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2023 at 02:57:59PM +0530, Chandan Babu R wrote:
> In order to support both v1 and v2 versions of metadump, mdrestore will have
> to detect the format in which the metadump file has been stored on the disk
> and then read the ondisk structures accordingly. In a step in that direction,
> this commit splits the work of reading the metadump header from disk into two
> parts
> 1. Read the first 4 bytes containing the metadump magic code.
> 2. Read the remaining part of the header.
> 
> A future commit will take appropriate action based on the value of the magic
> code.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Seems reasonable to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  mdrestore/xfs_mdrestore.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index 564630f7..2a9527b9 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -198,6 +198,7 @@ main(
>  	int		open_flags;
>  	struct stat	statbuf;
>  	int		is_target_file;
> +	uint32_t	magic;
>  	struct xfs_metablock	mb;
>  
>  	mdrestore.show_progress = false;
> @@ -245,10 +246,20 @@ main(
>  			fatal("cannot open source dump file\n");
>  	}
>  
> -	if (fread(&mb, sizeof(mb), 1, src_f) != 1)
> -		fatal("error reading from metadump file\n");
> -	if (mb.mb_magic != cpu_to_be32(XFS_MD_MAGIC_V1))
> +	if (fread(&magic, sizeof(magic), 1, src_f) != 1)
> +		fatal("Unable to read metadump magic from metadump file\n");
> +
> +	switch (be32_to_cpu(magic)) {
> +	case XFS_MD_MAGIC_V1:
> +		mb.mb_magic = cpu_to_be32(XFS_MD_MAGIC_V1);
> +		if (fread((uint8_t *)&mb + sizeof(mb.mb_magic),
> +			sizeof(mb) - sizeof(mb.mb_magic), 1, src_f) != 1)
> +			fatal("error reading from metadump file\n");
> +		break;
> +	default:
>  		fatal("specified file is not a metadata dump\n");
> +		break;
> +	}
>  
>  	if (mdrestore.show_info) {
>  		if (mb.mb_info & XFS_METADUMP_INFO_FLAGS) {
> -- 
> 2.39.1
> 
