Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F37C1C636CC
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 01:43:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjBIBnQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Feb 2023 20:43:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjBIBnQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Feb 2023 20:43:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9736322013
        for <linux-xfs@vger.kernel.org>; Wed,  8 Feb 2023 17:43:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21BFD6181D
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 01:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DBFC433EF;
        Thu,  9 Feb 2023 01:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675906994;
        bh=oj+3wA5soUWJgIk+Z3f34tGXU9c5gHNEhTS9q1fNEog=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ulgkr9yUrtwM5nDCnSf9B7jFaXlHlvDlRw10Lfhh7URWcNf5uX5nFx9bAM6RExrzt
         CFPK34oj2H5uiM717/FFe5ffQlKKTqSQ95ISs+cYBVDQeO4n7y46Q7nBLXXEnR+Ehd
         E7fz+kDxKx+DnZ8pzlLZzyBK0mWrVn3aTtT4Of86oRQhOCuKjefLy5u4lTc5Ob2i40
         aQnltppjmFb3hq+O3Op6jev+s60gKbhvHFFF8m6D//Y5qkTkIPXmUC+0E4AYb1LcTY
         749fptMWv2/3YYPUfy0Is+/JDlITc8Jiyvok6MIkYoIlyVqiO0VkL0KmVqtUPXEGBR
         8lYh+R+hN0JGg==
Date:   Wed, 8 Feb 2023 17:43:13 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Xiaole He <hexiaole1994@126.com>
Cc:     linux-xfs@vger.kernel.org, dchinner@redhat.com,
        chandan.babu@oracle.com, zhangshida@kylinos.cn,
        Xiaole He <hexiaole@kylinos.cn>
Subject: Re: [PATCH v1] libxfs: fix reservation space for removing transaction
Message-ID: <Y+RPsT3kKwB7HaVR@magnolia>
References: <20230206130949.12947-1-hexiaole1994@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206130949.12947-1-hexiaole1994@126.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 06, 2023 at 09:09:49PM +0800, Xiaole He wrote:
> In libxfs/xfs_trans_resv.c:
> 
> /* libxfs/xfs_trans_resv.c begin */
>  1 /*
>  2  * For removing a directory entry we can modify:
>  3  *    the parent directory inode: inode size
>  4  *    the removed inode: inode size
>  5  *    the directory btree could join: (max depth + v2) * dir block size
>  6  *    the directory bmap btree could join or split: (max depth + v2) * blocksize
>  7  * And the bmap_finish transaction can free the dir and bmap blocks giving:
>  8  *    the agf for the ag in which the blocks live: 2 * sector size
>  9  *    the agfl for the ag in which the blocks live: 2 * sector size
> 10  *    the superblock for the free block count: sector size
> 11  ...
> 12  */
> 13 STATIC uint
> 14 xfs_calc_remove_reservation(
> 15      struct xfs_mount        *mp)
> 16 {
> 17      return XFS_DQUOT_LOGRES(mp) +
> 18              xfs_calc_iunlink_add_reservation(mp) +
> 19              max((xfs_calc_inode_res(mp, 1) +

1?  It's 2 currently.  Are you using an old version of xfsprogs?

> 20                   xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
> 21                                    XFS_FSB_TO_B(mp, 1))),
> 22                  (xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
> 23      ...
> 24 }
> /* libxfs/xfs_trans_resv.c end */
> 
> Above lines 8-10 indicates there has 5 sector size of space to be
> reserved, but the above line 22 only reserve 4 sector size of space,
> this patch fix the problem and sorry for not notice this problem at
> Commit d3e53ab7cdc7fabb8c94137e335634e0ed4691e8 ("xfs: fix inode
> reservation space for removing transaction").
> 
> Signed-off-by: Xiaole He <hexiaole@kylinos.cn>
> ---
>  libxfs/xfs_trans_resv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
> index 04c44480..3d106c77 100644
> --- a/libxfs/xfs_trans_resv.c
> +++ b/libxfs/xfs_trans_resv.c
> @@ -517,7 +517,7 @@ xfs_calc_remove_reservation(
>  		max((xfs_calc_inode_res(mp, 2) +

Looks fine, but why the discrepancy between here and the commit message?

>  		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
>  				      XFS_FSB_TO_B(mp, 1))),
> -		    (xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
> +		    (xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +

Also: please send patches against the kernel, not xfsprogs.

--D

>  		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 2),
>  				      XFS_FSB_TO_B(mp, 1))));
>  }
> -- 
> 2.27.0
> 
