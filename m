Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA898C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 00:18:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236695AbiAEASK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jan 2022 19:18:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34002 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235499AbiAEASJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jan 2022 19:18:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3F57B81899
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jan 2022 00:18:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F57C36AEF;
        Wed,  5 Jan 2022 00:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641341887;
        bh=Pbu9q9HDCBvQpxMjmgPS5f2hQbuXiazPFRc2DSnn81Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lj41p6FKNeF+0jNrnFWtjmHKcoWEVTw80e5UZw+UcBK+ekTfRuSR2AjrdIvF2ZyLA
         DnKbrzS+Ghd4uV3jeVkCW4M82HQ6mq9dZ5/jhXbs+fI4+gXu6ljt3X6D0Hl2Zv0iu2
         mJKt9La/S7nLX/k9OLMthCabaqUfiXysfs5fgdoY2Kk8gw/1wzDJ8sekM0xCUfF425
         3xdgx5XawSb9kydvARopBNNZK3GSvDPt0GFYkgecMg5PE6mZQim9zDE40mCi9gCqIm
         e5sUHsmFBqYTKeJDY1cT9BQP6LjcoGCZH5/gIzZF5e1S/hFWafT07m/psbRiMTGsYp
         p/6/YxubkpWow==
Date:   Tue, 4 Jan 2022 16:18:06 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 13/16] xfs: Conditionally upgrade existing inodes to
 use 64-bit extent counters
Message-ID: <20220105001806.GP31583@magnolia>
References: <20211214084519.759272-1-chandan.babu@oracle.com>
 <20211214084519.759272-14-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214084519.759272-14-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 14, 2021 at 02:15:16PM +0530, Chandan Babu R wrote:
> This commit upgrades inodes to use 64-bit extent counters when they are read
> from disk. Inodes are upgraded only when the filesystem instance has
> XFS_SB_FEAT_INCOMPAT_NREXT64 incompat flag set.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index fe21e9808f80..b8e4e1f69989 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -253,6 +253,12 @@ xfs_inode_from_disk(
>  	}
>  	if (xfs_is_reflink_inode(ip))
>  		xfs_ifork_init_cow(ip);
> +
> +	if ((from->di_version == 3) &&
> +		xfs_has_nrext64(ip->i_mount) &&
> +		!xfs_dinode_has_nrext64(from))
> +		ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;

The indentation levels of the if test should not be aligned with the if
body, and this should be in xfs_trans_log_inode so that the metadata
update is staged properly with a transaction.  V3 did it this way, so
I'm a little surprised to see V4 regressing that...?

--D

> +
>  	return 0;
>  
>  out_destroy_data_fork:
> -- 
> 2.30.2
> 
