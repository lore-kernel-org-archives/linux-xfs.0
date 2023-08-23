Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F16C3DA66
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Aug 2023 22:18:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238609AbjHWWS2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Aug 2023 18:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238641AbjHWWSP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Aug 2023 18:18:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BB8170B
        for <linux-xfs@vger.kernel.org>; Wed, 23 Aug 2023 15:18:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7652E636CB
        for <linux-xfs@vger.kernel.org>; Wed, 23 Aug 2023 22:18:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920F4C433C7;
        Wed, 23 Aug 2023 22:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692829089;
        bh=isn0XZukkdCt9SvGfOovef2FVsCyMJ+NVIWbFkQ0PHM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HBUBuUQwyQPjGUBcDHeXufUuofiFPiwVw/kPFMYp5/18VzRX9PPfsDDTm3J0mcZfN
         0Hq2h2MIgd19ZWYWS3H0zVp6aFc8SjPNiGXjMmQF3cxE/ab4MJ5LlJgjm2FdnsxVhl
         zJpwMbkD3RcuBlxXgeDw3E2qEu886LK3QTW24KvHyXxaa1fiOnkFtY/Z0JfFM32pBh
         XjDymtpG+cjnvKCRCYJaK/F2c8T3/fXnB1U5U4rirFR6qpKZX9R3Pa/MJU3Xl+HS9m
         hpymS2eHwSkDlt8yZMvSuxCOSB1fdmQrmLFgksm/Qpayjs9iHN2qaX7ehZoG7tLTYz
         PM4YXkSsjqpug==
Date:   Wed, 23 Aug 2023 15:18:08 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: read only mounts with fsopen mount API are busted
Message-ID: <20230823221808.GF11263@frogsfrogsfrogs>
References: <20230823220225.3591135-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230823220225.3591135-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 24, 2023 at 08:02:25AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Recently xfs/513 started failing on my test machines testing "-o
> ro,norecovery" mount options. This was being emitted in dmesg:
> 
> [ 9906.932724] XFS (pmem0): no-recovery mounts must be read-only.
> 
> Turns out, readonly mounts with the fsopen()/fsconfig() mount API
> have been busted since day zero. It's only taken 5 years for debian
> unstable to start using this "new" mount API, and shortly after this
> I noticed xfs/513 had started to fail as per above.
> 
> The syscall trace is:
> 
> fsopen("xfs", FSOPEN_CLOEXEC)           = 3
> mount_setattr(-1, NULL, 0, NULL, 0)     = -1 EINVAL (Invalid argument)
> .....
> fsconfig(3, FSCONFIG_SET_STRING, "source", "/dev/pmem0", 0) = 0
> fsconfig(3, FSCONFIG_SET_FLAG, "ro", NULL, 0) = 0
> fsconfig(3, FSCONFIG_SET_FLAG, "norecovery", NULL, 0) = 0
> fsconfig(3, FSCONFIG_CMD_CREATE, NULL, NULL, 0) = -1 EINVAL (Invalid argument)
> close(3)                                = 0
> 
> Showing that the actual mount instantiation (FSCONFIG_CMD_CREATE) is
> what threw out the error.
> 
> During mount instantiation, we call xfs_fs_validate_params() which
> does:
> 
>         /* No recovery flag requires a read-only mount */
>         if (xfs_has_norecovery(mp) && !xfs_is_readonly(mp)) {
>                 xfs_warn(mp, "no-recovery mounts must be read-only.");
>                 return -EINVAL;
>         }
> 
> and xfs_is_readonly() checks internal mount flags for read only
> state. This state is set in xfs_init_fs_context() from the
> context superblock flag state:
> 
>         /*
>          * Copy binary VFS mount flags we are interested in.
>          */
>         if (fc->sb_flags & SB_RDONLY)
>                 set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
> 
> With the old mount API, all of the VFS specific superblock flags
> had already been parsed and set before xfs_init_fs_context() is
> called, so this all works fine.
> 
> However, in the brave new fsopen/fsconfig world,
> xfs_init_fs_context() is called from fsopen() context, before any
> VFS superblock have been set or parsed. Hence if we use fsopen(),
> the internal XFS readonly state is *never set*. Hence anything that
> depends on xfs_is_readonly() actually returning true for read only
> mounts is broken if fsopen() has been used to mount the filesystem.
> 
> Fix this by moving this internal state initialisation to
> xfs_fs_fill_super() before we attempt to validate the parameters
> that have been set prior to the FSCONFIG_CMD_CREATE call being made.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Huh.  Wow.  I would have expected to find /anything/ in fstests that
exercises the new mount api, but:

lax:~/cdev/work/fstests(0)> git grep -E '(fsconfig|fspick|fsopen)'
lax:~/cdev/work/fstests(1)>

What other weird things are lurking here?

Anyhow, I guess that's a side effect of xfs_mount mirroring some of the
vfs state flags, so....

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_super.c | 27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 09638e8fb4ee..8ca01510628b 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1509,6 +1509,18 @@ xfs_fs_fill_super(
>  
>  	mp->m_super = sb;
>  
> +	/*
> +	 * Copy VFS mount flags from the context now that all parameter parsing
> +	 * is guaranteed to have been completed by either the old mount API or
> +	 * the newer fsopen/fsconfig API.
> +	 */
> +	if (fc->sb_flags & SB_RDONLY)
> +		set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
> +	if (fc->sb_flags & SB_DIRSYNC)
> +		mp->m_features |= XFS_FEAT_DIRSYNC;
> +	if (fc->sb_flags & SB_SYNCHRONOUS)
> +		mp->m_features |= XFS_FEAT_WSYNC;
> +
>  	error = xfs_fs_validate_params(mp);
>  	if (error)
>  		goto out_free_names;
> @@ -1988,6 +2000,11 @@ static const struct fs_context_operations xfs_context_ops = {
>  	.free        = xfs_fs_free,
>  };
>  
> +/*
> + * WARNING: do not initialise any parameters in this function that depend on
> + * mount option parsing having already been performed as this can be called from
> + * fsopen() before any parameters have been set.
> + */
>  static int xfs_init_fs_context(
>  	struct fs_context	*fc)
>  {
> @@ -2019,16 +2036,6 @@ static int xfs_init_fs_context(
>  	mp->m_logbsize = -1;
>  	mp->m_allocsize_log = 16; /* 64k */
>  
> -	/*
> -	 * Copy binary VFS mount flags we are interested in.
> -	 */
> -	if (fc->sb_flags & SB_RDONLY)
> -		set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
> -	if (fc->sb_flags & SB_DIRSYNC)
> -		mp->m_features |= XFS_FEAT_DIRSYNC;
> -	if (fc->sb_flags & SB_SYNCHRONOUS)
> -		mp->m_features |= XFS_FEAT_WSYNC;
> -
>  	fc->s_fs_info = mp;
>  	fc->ops = &xfs_context_ops;
>  
> -- 
> 2.40.1
> 
