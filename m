Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C2D7C7EE26
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 17:27:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238152AbjEWR1Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 13:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234160AbjEWR1X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 13:27:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6B7FA
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 10:27:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AAFB62CE0
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 17:27:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E31C433EF;
        Tue, 23 May 2023 17:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684862825;
        bh=bzfQxlTdMRgURQMt3ybZjI4ThqCqwo97UjxTThR2Xtk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tq3UiRURW+eN8nl1sMfL6clbch5RB6LJ5167/6W0AIY47DVjCH5E9tav37ySY3YGU
         3h3RaY/Aai/WeUdzysG7fGUgueH80PWQOnCdNP9jXo60+yXJdulsPuplj8a5rmkQD9
         D6CSUQQFGFXKtGuyTA2KrWYdzZc1h5QJakJYtuzzgbIUU+E0uZmrJO6DvfT+1ial0d
         Cowb9+gwn/WqzA0zipJnyzE665aIsspYBKKHIrSLNHGTzlQsuY54zUYfaHJxis/9Cu
         ZEoYD30J1oSqmji7YfMsWJePsRem+802DNiix4wPxk/YqY3b5r+QpV7WR6JrpN9eC/
         J76/Cncxw41ag==
Date:   Tue, 23 May 2023 10:27:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/24] metadump: Rename XFS_MD_MAGIC to XFS_MD_MAGIC_V1
Message-ID: <20230523172705.GQ11620@frogsfrogsfrogs>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-11-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523090050.373545-11-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 02:30:36PM +0530, Chandan Babu R wrote:
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Good thing we didn't publish XFS_MD_MAGIC in xfslibs-dev...

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  db/metadump.c             | 2 +-
>  include/xfs_metadump.h    | 2 +-
>  mdrestore/xfs_mdrestore.c | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 7265f73ec..9d7ad76ae 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -2950,7 +2950,7 @@ init_metadump_v1(void)
>  		return -1;
>  	}
>  	metadump.metablock->mb_blocklog = BBSHIFT;
> -	metadump.metablock->mb_magic = cpu_to_be32(XFS_MD_MAGIC);
> +	metadump.metablock->mb_magic = cpu_to_be32(XFS_MD_MAGIC_V1);
>  
>  	/* Set flags about state of metadump */
>  	metadump.metablock->mb_info = XFS_METADUMP_INFO_FLAGS;
> diff --git a/include/xfs_metadump.h b/include/xfs_metadump.h
> index fbd990232..a4dca25cb 100644
> --- a/include/xfs_metadump.h
> +++ b/include/xfs_metadump.h
> @@ -7,7 +7,7 @@
>  #ifndef _XFS_METADUMP_H_
>  #define _XFS_METADUMP_H_
>  
> -#define	XFS_MD_MAGIC		0x5846534d	/* 'XFSM' */
> +#define	XFS_MD_MAGIC_V1		0x5846534d	/* 'XFSM' */
>  
>  typedef struct xfs_metablock {
>  	__be32		mb_magic;
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index 333282ed2..481dd00c2 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -240,7 +240,7 @@ main(
>  
>  	if (fread(&mb, sizeof(mb), 1, src_f) != 1)
>  		fatal("error reading from metadump file\n");
> -	if (mb.mb_magic != cpu_to_be32(XFS_MD_MAGIC))
> +	if (mb.mb_magic != cpu_to_be32(XFS_MD_MAGIC_V1))
>  		fatal("specified file is not a metadata dump\n");
>  
>  	if (show_info) {
> -- 
> 2.39.1
> 
