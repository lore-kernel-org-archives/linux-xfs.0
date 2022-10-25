Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64BEEFA3741
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 19:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbiJYTQw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 15:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232954AbiJYTQe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 15:16:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12871DED2D
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 12:15:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A042D61B09
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 19:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03800C433C1;
        Tue, 25 Oct 2022 19:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666725356;
        bh=FzrKBqVsDzJ/25AO1RbQ8/gOckGTkq6KquDMVcZKsbY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T9ZPgI1QuCQD0CjmHVaILQanjS2LheaMEgijLzW+xURRtsE4fOz9OUkd1wu+y1ebC
         zZD6KWTQjJdsXNWG8laPGJzwELYpCkgxTan0q5pe5LI15aVhPj7EKfs7xabLPAdnKk
         aQUbMFyCQ+imk9TdfSqdiGz1ntUDkXdw+YRoiZ1rFiXvAZZmmLcgxWhebIxCKY0OTE
         NwRamWxt/ng7JgOvc2h2OEFKpgkRygKSJSdQBxdWqSytYi5uH/Z2xOgHi6PYm+7sPD
         xTqAuvq4e27/3ynT0dQvD8aiwSdL2jBrW4vcC1ISsgijGQTs3N5bDk1Z73GH7MKmA+
         4yeLffmdm0zkA==
Date:   Tue, 25 Oct 2022 12:15:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 13/27] xfs: Increase rename inode reservation
Message-ID: <Y1g16xthTPijq/D8@magnolia>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
 <20221021222936.934426-14-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021222936.934426-14-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 21, 2022 at 03:29:22PM -0700, allison.henderson@oracle.com wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> xfs_rename can lock up to 5 inodes: src_dp, target_dp, src_ip, target_ip
> and wip.  So we need to increase the inode reservation to match.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

Looks good, I'll add this to the 6.1 fixes.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_trans_resv.c | 4 ++--
>  fs/xfs/xfs_inode.c             | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 2c4ad6e4bb14..5b2f27cbdb80 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -422,7 +422,7 @@ xfs_calc_itruncate_reservation_minlogsize(
>  
>  /*
>   * In renaming a files we can modify:
> - *    the four inodes involved: 4 * inode size
> + *    the five inodes involved: 5 * inode size
>   *    the two directory btrees: 2 * (max depth + v2) * dir block size
>   *    the two directory bmap btrees: 2 * max depth * block size
>   * And the bmap_finish transaction can free dir and bmap blocks (two sets
> @@ -437,7 +437,7 @@ xfs_calc_rename_reservation(
>  	struct xfs_mount	*mp)
>  {
>  	return XFS_DQUOT_LOGRES(mp) +
> -		max((xfs_calc_inode_res(mp, 4) +
> +		max((xfs_calc_inode_res(mp, 5) +
>  		     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
>  				      XFS_FSB_TO_B(mp, 1))),
>  		    (xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 71d60885000e..ea7aeab839c2 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2848,7 +2848,7 @@ xfs_rename(
>  	 * Lock all the participating inodes. Depending upon whether
>  	 * the target_name exists in the target directory, and
>  	 * whether the target directory is the same as the source
> -	 * directory, we can lock from 2 to 4 inodes.
> +	 * directory, we can lock from 2 to 5 inodes.
>  	 */
>  	xfs_lock_inodes(inodes, num_inodes, XFS_ILOCK_EXCL);
>  
> -- 
> 2.25.1
> 
