Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F0AC433C1
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 02:42:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAF8E619B6
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 02:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbhCZCmZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 22:42:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230222AbhCZCmX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 22:42:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3EE9619B6;
        Fri, 26 Mar 2021 02:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616726542;
        bh=hP5zCpj24OBodWW6qlbP//7OFXT+60fQiV4lYTprKZ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dOPzjRrNQNr9bRrdXD/XgXvMHAxOfNgJDDD0Fq1/hosj1RdWnlrPC4RGQ+4dTAH3B
         9Ji2a5yQRg3+1O1TJarkp0UgdAKNrn/lZsbqTYh7SYXbUVAHyz/uR1VVoBAYg36Cmz
         XU4NVDq02+C7m86OTjL/XgZ9mH0yUGDNyhLBCujq807CQ187zyzXd+JjQGu20eoH4o
         xo08eE/ixtvF2YHn34p41n7LvGmuePeE/WYepNK0XrFAAjKKm3WEFZq0g8Q9LcurJz
         ddAe3rh4urtxnzi0NKiBPxCCSBgK7feslzTxP//Ua1JX4Tmak7Te6T95lUo/BXL3CR
         B2ATJ9ViFUq/A==
Date:   Thu, 25 Mar 2021 19:42:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     lukas@herbolt.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsdocs: Small fix to correct first free inode to be
 5847 not 5856.
Message-ID: <20210326024221.GQ4090233@magnolia>
References: <20210324184835.GU22100@magnolia>
 <20210325081416.3190060-1-lukas@herbolt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325081416.3190060-1-lukas@herbolt.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 25, 2021 at 09:14:16AM +0100, lukas@herbolt.com wrote:
> From: Lukas Herbolt <lukas@herbolt.com>
> 
> Thanks for confirmation, I was not sure about it.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>

I'll massage the commit message a bit, but otherwise this looks fine.
Thank you for the correction!

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  design/XFS_Filesystem_Structure/allocation_groups.asciidoc | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> index 992615d..cdc8545 100644
> --- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> +++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> @@ -1099,7 +1099,7 @@ recs[1-85] = [startino,freecount,free]
>  Most of the inode chunks on this filesystem are totally full, since the +free+
>  value is zero.  This means that we ought to expect inode 160 to be linked
>  somewhere in the directory structure.  However, notice that 0xff80000000000000
> -in record 85 -- this means that we would expect inode 5856 to be free.  Moving
> +in record 85 -- this means that we would expect inode 5847 to be free.  Moving
>  on to the free inode B+tree, we see that this is indeed the case:
>  
>  ----
> -- 
> 2.26.2
> 
