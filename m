Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87317C77B75
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 16:31:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235384AbjEWQbi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 12:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237497AbjEWQbh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 12:31:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27ABE9
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 09:31:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 776DE628DB
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 16:31:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED21C433EF;
        Tue, 23 May 2023 16:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684859493;
        bh=ZJj/9pV3pgaEzF3cV30YnEdl4R/Jh/7Em8IoGdCpuxY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jZwIk9Z4wgAw8+FC99lHF+S+XHgZ7EzV5k1xor4b9ge3fUqK5hHrm5Ymyot1GeTik
         1eUXECoKSC61tJF0bcgCg8vT6SWXjUAL1Kw5KKfItOTyaWQxcBzTD7jVgMJhqqgSn3
         kARw1DYPZE1e5AZdoj5XTBRc0U+Aj3ecryuhWmSBxzSS72MroFWuXvx/Gq1FVV4V4J
         eamT1xOBDTBo2BLearOVrjwyGH86FdLO+DDX9a8fXHfx/z4b82hbWXK3kTTaTRwtU+
         ch7MX/xBB9+B5Qk00VHjGpIn239gnnIBR2j5TV1Qi9xmVTEzdxegqVihwTp+QEKYNe
         x92Hu3RLcp2Xw==
Date:   Tue, 23 May 2023 09:31:33 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/24] metadump: Use boolean values true/false instead of
 1/0
Message-ID: <20230523163133.GH11620@frogsfrogsfrogs>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-2-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523090050.373545-2-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 02:30:27PM +0530, Chandan Babu R wrote:
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  db/metadump.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 27d1df432..6bcfd5bba 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -2421,12 +2421,12 @@ process_inode(
>  		case S_IFDIR:
>  			rval = process_inode_data(dip, TYP_DIR2);
>  			if (dip->di_format == XFS_DINODE_FMT_LOCAL)
> -				need_new_crc = 1;
> +				need_new_crc = true;
>  			break;
>  		case S_IFLNK:
>  			rval = process_inode_data(dip, TYP_SYMLINK);
>  			if (dip->di_format == XFS_DINODE_FMT_LOCAL)
> -				need_new_crc = 1;
> +				need_new_crc = true;
>  			break;
>  		case S_IFREG:
>  			rval = process_inode_data(dip, TYP_DATA);
> @@ -2436,7 +2436,7 @@ process_inode(
>  		case S_IFBLK:
>  		case S_IFSOCK:
>  			process_dev_inode(dip);
> -			need_new_crc = 1;
> +			need_new_crc = true;
>  			break;
>  		default:
>  			break;
> @@ -2450,7 +2450,7 @@ process_inode(
>  		attr_data.remote_val_count = 0;
>  		switch (dip->di_aformat) {
>  			case XFS_DINODE_FMT_LOCAL:
> -				need_new_crc = 1;
> +				need_new_crc = true;
>  				if (obfuscate || zero_stale_data)
>  					process_sf_attr(dip);
>  				break;
> @@ -2469,7 +2469,7 @@ process_inode(
>  done:
>  	/* Heavy handed but low cost; just do it as a catch-all. */
>  	if (zero_stale_data)
> -		need_new_crc = 1;
> +		need_new_crc = true;
>  
>  	if (crc_was_ok && need_new_crc)
>  		libxfs_dinode_calc_crc(mp, dip);
> -- 
> 2.39.1
> 
