Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B891EC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 23 May 2022 20:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiEWU2u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 May 2022 16:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbiEWU2t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 May 2022 16:28:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72C05D5DF
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 13:28:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 587F4614C5
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 20:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA68DC385A9;
        Mon, 23 May 2022 20:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653337727;
        bh=03WeGHwtyBtbDo0knX34mzSKwUMo+QA/NyuePnbIJtA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tmNdEhgB91AK6fG1EGmNQHYpc26JYLxLHehvTkjxbFnovZEztMutOE0ZmQM9pSL9F
         1B4RP7h/9ACOAFpMLR4RWzggq8b3VaJ00WPu3k0w4VchW1b1emgM9RPVmL1/lRTBkr
         3EWeugGtLbAoWOGWqnjocpCKWms090TwCBvJKLZBuovKJEcXTcjfAszVseqTvRFPsT
         TeCiHYA8cUY3MB2cKprggZ8O/6IzfgnPRRl4gnU/UvHaf6aOJrJAytBb/cPf9/13bU
         91LqFBJPuhov+JAaC0PTx5mWdn5l0f6bY27/mnMRShD5hse8qhz2vk9jsNP0xP6ieN
         xVDocyzYg852g==
Date:   Mon, 23 May 2022 13:28:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, sandeen@sandeen.net
Subject: Re: [PATCH V1.1] xfs_repair: Search for conflicts in
 inode_tree_ptrs[] when processing uncertain inodes
Message-ID: <Yovuf/JZiMkJzot6@magnolia>
References: <20220523043441.394700-1-chandan.babu@oracle.com>
 <20220523083410.1159518-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523083410.1159518-1-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 23, 2022 at 02:04:10PM +0530, Chandan Babu R wrote:
> When processing an uncertain inode chunk record, if we lose 2 blocks worth of
> inodes or 25% of the chunk, xfs_repair decides to ignore the chunk. Otherwise,
> xfs_repair adds a new chunk record to inode_tree_ptrs[agno], marking each
> inode as either free or used. However, before adding the new chunk record,
> xfs_repair has to check for the existance of a conflicting record.
> 
> The existing code incorrectly checks for the conflicting record in
> inode_uncertain_tree_ptrs[agno]. This check will succeed since the inode chunk
> record being processed was originally obtained from
> inode_uncertain_tree_ptrs[agno].
> 
> This commit fixes the bug by changing xfs_repair to search
> inode_tree_ptrs[agno] for conflicts.

Just out of curiosity -- how did you come across this bug?  I /think/ it
looks reasonable, but want to know more context...

> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
> Changelog:
> V1 -> V1.1:
>    1. Fix commit message.
>    
>  repair/dino_chunks.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
> index 11b0eb5f..80c52a43 100644
> --- a/repair/dino_chunks.c
> +++ b/repair/dino_chunks.c
> @@ -229,8 +229,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
>  		/*
>  		 * ok, put the record into the tree, if no conflict.
>  		 */
> -		if (find_uncertain_inode_rec(agno,
> -				XFS_AGB_TO_AGINO(mp, start_agbno)))
> +		if (find_inode_rec(mp, agno, XFS_AGB_TO_AGINO(mp, start_agbno)))

...because the big question I have is: why not check both the certain
and the uncertain records for confliects?

--D

>  			return(0);
>  
>  		start_agino = XFS_AGB_TO_AGINO(mp, start_agbno);
> -- 
> 2.35.1
> 
