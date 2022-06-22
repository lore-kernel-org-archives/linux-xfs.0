Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED4D7C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jun 2022 16:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiFVQiM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 12:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiFVQiM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 12:38:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664C833E11;
        Wed, 22 Jun 2022 09:38:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12C4BB8204A;
        Wed, 22 Jun 2022 16:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B55C34114;
        Wed, 22 Jun 2022 16:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655915887;
        bh=89Ryslcmd/UmokPofteCvD+NA85Fh+wLE9l8qNYXtY4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uqcx67BwkUAdvt1XSPxqk10D/+O3M/vGSU5uLqH/3dTRiCPRUx53sP+bYvXKBpv1P
         8J2Y52ybTNr/Gt1WhJ54Vg8g6LU6BNkM1HqUsULmhZODjtLbKuqW+xuWBa5IcWk/fM
         NV/MvauxtFhdJ0LdkxR/t25o1Og7TSDJXoK0JOFKJZ/48b017GUMMvMvbmS2j1JMiH
         +XZkrMvz3vjwqWPm0omtVIBcMO51XQBr9DHS17iPkfx5MvYe6xhNlTEl5EfV+0EciG
         A3wrc30ggBJji1NHrA2St4X5SHDX7qJpHwcQ3Ls5jrNfXdhFNEJxufcNwdDGRp9U0c
         CTgbRcla3M2Mw==
Date:   Wed, 22 Jun 2022 09:38:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 5.10 CANDIDATE 09/11] xfs: only bother with
 sync_filesystem during readonly remount
Message-ID: <YrNFb9999OY/8JDZ@magnolia>
References: <20220617100641.1653164-1-amir73il@gmail.com>
 <20220617100641.1653164-10-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617100641.1653164-10-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 17, 2022 at 01:06:39PM +0300, Amir Goldstein wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> commit b97cca3ba9098522e5a1c3388764ead42640c1a5 upstream.
> 
> In commit 02b9984d6408, we pushed a sync_filesystem() call from the VFS
> into xfs_fs_remount.  The only time that we ever need to push dirty file
> data or metadata to disk for a remount is if we're remounting the
> filesystem read only, so this really could be moved to xfs_remount_ro.
> 
> Once we've moved the call site, actually check the return value from
> sync_filesystem.
> 
> Fixes: 02b9984d6408 ("fs: push sync_filesystem() down to the file system's remount_fs()")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/xfs/xfs_super.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 6323974d6b3e..dd0439ae6732 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1716,6 +1716,11 @@ xfs_remount_ro(
>  	};
>  	int			error;
>  
> +	/* Flush all the dirty data to disk. */
> +	error = sync_filesystem(mp->m_super);

Looking at 5.10.124's fsync.c and xfs_super.c:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/fs/sync.c?h=v5.10.124#n31
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/fs/xfs/xfs_super.c?h=v5.10.124#n755

I think this kernel needs the patch(es) that make __sync_filesystem return
the errors passed back by ->sync_fs, and I think also the patch that
makes xfs_fs_sync_fs return errors encountered by xfs_log_force, right?

--D

> +	if (error)
> +		return error;
> +
>  	/*
>  	 * Cancel background eofb scanning so it cannot race with the final
>  	 * log force+buftarg wait and deadlock the remount.
> @@ -1786,8 +1791,6 @@ xfs_fc_reconfigure(
>  	if (error)
>  		return error;
>  
> -	sync_filesystem(mp->m_super);
> -
>  	/* inode32 -> inode64 */
>  	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
>  	    !(new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
> -- 
> 2.25.1
> 
