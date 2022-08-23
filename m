Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B29AC32796
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Aug 2022 16:47:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245505AbiHWQre (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Aug 2022 12:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344218AbiHWQq5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Aug 2022 12:46:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C745A82E;
        Tue, 23 Aug 2022 07:25:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1362B81E07;
        Tue, 23 Aug 2022 14:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711D8C433D7;
        Tue, 23 Aug 2022 14:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661264756;
        bh=jLDPk63tM8tt9Cbz3SJ1sEtT0hjfJlQmmYtyOmVsfBs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NtLrl9IRVIeCu4mLKr4IPRotsqVc19mTU9iXZyXDxkswdwqVvajuTqUxPEj0DQM/G
         07eGOJImwFcYP1YzNwbfdW/To0M0fOfUThrjeiqRasHpLOT/JWY6rTML1vssSEuL41
         UFwENJHTkodnOPp4e+0wZiiK7u82qEgypsC9qO7ywK2PiDWep1JzUG2TUC7XB44eEO
         FIBHb8mcr3Jq+2x31O/tmh2E09+aHz64NA/UDnAbr3k0HLfTYItfJbxI0KGV/8L7qC
         xQOxtjXDpA0gKOo8s3S/jTs49RGuQA1zcnzIClzEI03u5vvuC5vc3O2t86HHdqCwgy
         /B5E4FTa4tAcA==
Date:   Tue, 23 Aug 2022 07:25:56 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zeng Heng <zengheng4@huawei.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] xfs: remove the redundant word in comment
Message-ID: <YwTjdAINonsEdif7@magnolia>
References: <20220823014720.4156722-1-zengheng4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823014720.4156722-1-zengheng4@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 23, 2022 at 09:47:20AM +0800, Zeng Heng wrote:
> Just remove the redundant word "being" in comment.
> 
> Signed-off-by: Zeng Heng <zengheng4@huawei.com>
> ---
>  fs/xfs/xfs_inode_item.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 6e19ece916bf..ca2941ab6cbc 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -550,7 +550,7 @@ xfs_inode_item_push(
>  
>  	if (!bp || (ip->i_flags & XFS_ISTALE)) {
>  		/*
> -		 * Inode item/buffer is being being aborted due to cluster
> +		 * Inode item/buffer is being aborted due to cluster

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  		 * buffer deletion. Trigger a log force to have that operation
>  		 * completed and items removed from the AIL before the next push
>  		 * attempt.
> -- 
> 2.25.1
> 
