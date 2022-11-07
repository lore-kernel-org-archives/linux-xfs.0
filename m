Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D57EC4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 16:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbiKGQix (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 11:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbiKGQir (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 11:38:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37852C4C
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 08:38:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7BEA611C9
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 16:38:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296B8C433D7;
        Mon,  7 Nov 2022 16:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667839126;
        bh=3QdpJTZnsGX5DR7iCvoqsnymYrRYscC8QENWGooIbhE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nFmfGtTsFxmE2rAnPP5J+Z5n49GqfBgGPIMSpC0C+fU/c6vhdKNl12IAFaglia9sQ
         O89ernkDWfn5RVmnragpTO6HwrNVrD5IeScD3wxVAo7A7amAmrJ4t3plFMSAkfcpAR
         w/iF43wIIzKGPVQo9c4OZdIIGKb1eOI/v5riFdkUvQCRoTTz9PO8mDu8h1viirigGu
         ME5LNz0yF00XIgTGfKUoETRRMardTshZiQTt+EpjZAzWv4eWmSxt3jBAAXrJb4YC2k
         Apps83aityOP6Yvuu6emtmrkR3qG+azxQtRAwWfgfIq+XCB00VIfXNRlljqByJD++H
         R8f6fIlGJkyQA==
Date:   Mon, 7 Nov 2022 08:38:45 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Long Li <leo.lilong@huawei.com>
Cc:     houtao1@huawei.com, yi.zhang@huawei.com, guoxuenan@huawei.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix incorrect i_nlink caused by inode racing
Message-ID: <Y2k0lSx4aBYHoJs6@magnolia>
References: <20221107143648.GA2013250@ceph-admin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107143648.GA2013250@ceph-admin>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 07, 2022 at 10:36:48PM +0800, Long Li wrote:
> The following error occurred during the fsstress test:

> XFS: Assertion failed: VFS_I(ip)->i_nlink >= 2, file: fs/xfs/xfs_inode.c, line: 2925

What kernel is this?  xfs_inode.c line 2925 is in the middle of
xfs_rename and doesn't have any assertions on nlink.

The only assertion on nlink in the entire xfs codebase is in xfs_remove,
and that's not what's going on here.

<confused>

--D

> The problem was that inode race condition causes incorrect i_nlink to be
> written to disk, and then it is read into memory. Consider the following
> call graph, inodes that are marked as both XFS_IFLUSHING and
> XFS_IRECLAIMABLE, i_nlink will be reset to 1 and then restored to original
> value in xfs_reinit_inode(). Therefore, the i_nlink of directory on disk
> may be set to 1.
> 
>   xfsaild
>       xfs_inode_item_push
>           xfs_iflush_cluster
>               xfs_iflush
>                   xfs_inode_to_disk
> 
>   xfs_iget
>       xfs_iget_cache_hit
>           xfs_iget_recycle
>               xfs_reinit_inode
>   	          inode_init_always
> 
> So skip inodes that being flushed and markded as XFS_IRECLAIMABLE, prevent
> concurrent read and write to inodes.
> 
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/xfs_icache.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index eae7427062cf..cc68b0ff50ce 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -514,6 +514,11 @@ xfs_iget_cache_hit(
>  	    (ip->i_flags & XFS_IRECLAIMABLE))
>  		goto out_skip;
>  
> +	/* Skip inodes that being flushed */
> +	if ((ip->i_flags & XFS_IFLUSHING) &&
> +	    (ip->i_flags & XFS_IRECLAIMABLE))
> +		goto out_skip;
> +
>  	/* The inode fits the selection criteria; process it. */
>  	if (ip->i_flags & XFS_IRECLAIMABLE) {
>  		/* Drops i_flags_lock and RCU read lock. */
> -- 
> 2.31.1
> 
