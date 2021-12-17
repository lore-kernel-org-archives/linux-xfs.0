Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B85AC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Dec 2021 16:54:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236005AbhLQQyq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Dec 2021 11:54:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42750 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233478AbhLQQyo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Dec 2021 11:54:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9229F62305
        for <linux-xfs@vger.kernel.org>; Fri, 17 Dec 2021 16:54:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8178C36AE1;
        Fri, 17 Dec 2021 16:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639760084;
        bh=JleQCrGOsuL7infiOXSHgz/FpBPBJmGlfbDPkxgDHRA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f/vAq83MU1gEakdvkzOUIpwyaCCGogF7ICprzQgJYihV/RyHEIAPwdca9slVZx+ux
         dcuCnss87rmwoME5H6Mqtwpg1POHVBPHEN/IV8NBznymSaCwArD/bCP2PoY9NgjUIg
         VudmRxpPVAcwjoMeUPOQKleHHzQLMz2kSH5Zh0syczF/yvZBe36iSvm5Ir5xByBnlr
         1rMwTD5nSGWnDnzQ4C7FLnuKBARdH5NkCgAmCbwfcxCs45R03YSaOq7DcJsB7yA31i
         ewa8SZhqBarapsr8mNDK81IwgtFYLhg2nqOAm5egdTrkmbetgjQja1CAQFrEEAc7aA
         200Ghu0HBYgNA==
Date:   Fri, 17 Dec 2021 08:54:43 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Yang Xu <xuyang2018.jy@fujitsu.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Fix comments mentioning xfs_ialloc
Message-ID: <20211217165443.GF27664@magnolia>
References: <1639706519-2239-1-git-send-email-xuyang2018.jy@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1639706519-2239-1-git-send-email-xuyang2018.jy@fujitsu.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 17, 2021 at 10:01:59AM +0800, Yang Xu wrote:
> Since kernel commit 1abcf261016e ("xfs: move on-disk inode allocation out of xfs_ialloc()"),
> xfs_ialloc has been renamed to xfs_init_new_inode. So update this in comments.
> 
> Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_icache.c | 3 ++-
>  fs/xfs/xfs_iops.c   | 6 +++---
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index e1472004170e..39758015f302 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -770,7 +770,8 @@ xfs_iget(
>  
>  	/*
>  	 * If we have a real type for an on-disk inode, we can setup the inode
> -	 * now.	 If it's a new inode being created, xfs_ialloc will handle it.
> +	 * now.	 If it's a new inode being created, xfs_init_new_inode will
> +	 * handle it.
>  	 */
>  	if (xfs_iflags_test(ip, XFS_INEW) && VFS_I(ip)->i_mode != 0)
>  		xfs_setup_existing_inode(ip);
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index a607d6aca5c4..f2ceb6c3fc50 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1332,9 +1332,9 @@ xfs_diflags_to_iflags(
>   * Initialize the Linux inode.
>   *
>   * When reading existing inodes from disk this is called directly from xfs_iget,
> - * when creating a new inode it is called from xfs_ialloc after setting up the
> - * inode. These callers have different criteria for clearing XFS_INEW, so leave
> - * it up to the caller to deal with unlocking the inode appropriately.
> + * when creating a new inode it is called from xfs_init_new_inode after setting
> + * up the inode. These callers have different criteria for clearing XFS_INEW, so
> + * leave it up to the caller to deal with unlocking the inode appropriately.
>   */
>  void
>  xfs_setup_inode(
> -- 
> 2.23.0
> 
