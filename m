Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10248C4167D
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 19:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjKGTJy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 14:09:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjKGTJx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 14:09:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA1A13D
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 11:09:51 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13613C433CB;
        Tue,  7 Nov 2023 19:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699384191;
        bh=vGlzuLOQGFlDXR2vQnLLcPsxbAYtztbkDC+Z4sQ9OBE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LQszagzD1szD1VwNZTWVYCH/QLr2QNrUjRdNN6ZRUQw+/nydPOcSb9Nrk/NgB4+I9
         FLmTQZrl2EhJcURUZK3LbnWQvCwhtCpogSaX45L0BMgBZ7AUo3zkeB/NuQ+TJj2UTB
         Vbm0/6yf2RxedCQwNUQE4NHtOvEhWc7/VaH7CK+yum4ideOcsSUCsjc92rNEzf4vnE
         F4b3R/VVE/vhXjvJgGf5moV2rIuE3kFUgBORGgOfKUbd3JpGQaYpyX+Gc4ZMDHchG6
         ISKokDVkfsVnjNZrBtwMN2eA8/IEahh945AeqGbWgufpGK4M1ynFLpz/H+fZFjG0T0
         GSj8//OzZfG2Q==
Date:   Tue, 7 Nov 2023 11:09:50 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V1 1/2] metadump.asciidoc: Add description for version
 v1's mb_info field
Message-ID: <20231107190950.GO1205143@frogsfrogsfrogs>
References: <20231106132158.183376-1-chandan.babu@oracle.com>
 <20231106132158.183376-2-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231106132158.183376-2-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 06, 2023 at 06:51:57PM +0530, Chandan Babu R wrote:
> mb_reserved has been replaced with mb_info in upstream xfsprogs. This commit
> adds description for valid bits of mb_info field.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  .../metadump.asciidoc                         | 23 ++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/design/XFS_Filesystem_Structure/metadump.asciidoc b/design/XFS_Filesystem_Structure/metadump.asciidoc
> index 2bddb77..2f35b7e 100644
> --- a/design/XFS_Filesystem_Structure/metadump.asciidoc
> +++ b/design/XFS_Filesystem_Structure/metadump.asciidoc
> @@ -21,7 +21,7 @@ struct xfs_metablock {
>  	__be32		mb_magic;
>  	__be16		mb_count;
>  	uint8_t		mb_blocklog;
> -	uint8_t		mb_reserved;
> +	uint8_t		mb_info;
>  	__be64		mb_daddr[];
>  };
>  ----
> @@ -37,8 +37,25 @@ Number of blocks indexed by this record.  This value must not exceed +(1
>  The log size of a metadump block.  This size of a metadump block 512
>  bytes, so this value should be 9.
>  
> -*mb_reserved*::
> -Reserved.  Should be zero.
> +*mb_info*::
> +Flags describing a metadata dump.
> +
> +[options="header"]
> +|=====
> +| Flag				| Description
> +| +XFS_METADUMP_INFO_FLAGS+ |
> +The remaining bits in this field are valid.
> +
> +| +XFS_METADUMP_OBFUSCATED+ |
> +File names and extended attributes have been obfuscated.
> +
> +| +XFS_METADUMP_FULLBLOCKS+ |
> +Metadata blocks have been copied in full i.e. stale bytes have not
> +been zeroed out.
> +
> +| +XFS_METADUMP_DIRTYLOG+ |
> +Log was dirty.
> +|=====
>  
>  *mb_daddr*::
>  An array of disk addresses.  Each of the +mb_count+ blocks (of size +(1
> -- 
> 2.39.1
> 
