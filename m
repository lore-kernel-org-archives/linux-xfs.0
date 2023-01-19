Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA478C38142
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Jan 2023 05:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbjASFPP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Jan 2023 00:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbjASFOQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jan 2023 00:14:16 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18DDC172A
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 21:14:15 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so3890438pjq.0
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 21:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kx/0/eM5Aq1g63wRRP7qndmkF3eZriN905Vl4L2Ntj0=;
        b=K/zsRpcY8ajM/mTU/O+dTqXI+XR2tsFiTzvL3bYWpWzWQVzkiNfbdygXT2ouzbkie/
         5B6k8UNhRG1GidOF/+UJxEihcy3wGgQG9ThQ9bdnJqndYIYnuGTtcyR5IsOd8NgUSlJ8
         SqXSQvWMlHgPtLxWwsl20EtUvIqSEvo2q1rZiRvkKRp2NpfKiCAjYom1oe7YJJjurcav
         s/hxVRCjsx/owyUfBWO4x7MD7a+7MY4uCb1C48XPULQ45zTYvBzx6kAui1/p/nyzB9RT
         iglL1fkfziIcNC9ukNOlteL6aPvm2tUWigWA68pIWEGAbNX7rCvx6bzUQonUSjlmHlh9
         oqZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kx/0/eM5Aq1g63wRRP7qndmkF3eZriN905Vl4L2Ntj0=;
        b=KrU8jLhFh2i3HmbCniWJZWq7Bqaw9S8iYoTkt+aoglRKy17UYt7tSwB8UEXPTrfeIq
         eDfdL9sjGwlrotoVDDZwmCAg8jyXRvPueoK4XodVaey81Hlml8k2yvADF3JzBAOPA2+t
         GWI4agMB405PMP5kUbFpwIf6tznjcAo3pGkJ47ZnwCC/lSjX2SQOBguR3fibDDLnEL6P
         HUNDwZJaZv6uPnMrj+o0wkRnj/oNwRRl25zdiXmOE0WO+WzIfYn+kJ1QUt10iyfXkLr2
         rmhkDxx7JpeutiPkk5CKy5n9Lxm0snMxUf6UK37+Ak5v83I2RanzNPE45e2ItF5V5IB5
         iE2A==
X-Gm-Message-State: AFqh2kqgoM23d0RbOiiHeMky3UAMlxKdLJ8f73aOHaio/Z6kLwAviEHs
        KBlKYRaj5RziPHB7+qEC6Foo9hP7iJEM8Ehu
X-Google-Smtp-Source: AMrXdXvRrSlGNmocFMhYEOREOnBz9fxk2tIgJ/kp18dqr/+QxxSj1BQyZxZ0hZw5aC/yY5Qf19n58w==
X-Received: by 2002:a17:902:7597:b0:194:afe4:3011 with SMTP id j23-20020a170902759700b00194afe43011mr7348554pll.52.1674105254552;
        Wed, 18 Jan 2023 21:14:14 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id n7-20020a170902e54700b00194ab9a4febsm4111758plf.74.2023.01.18.21.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 21:14:14 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pINFb-004pAp-9o; Thu, 19 Jan 2023 16:14:11 +1100
Date:   Thu, 19 Jan 2023 16:14:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: recheck appropriateness of map_shared lock
Message-ID: <20230119051411.GJ360264@dread.disaster.area>
References: <Y8ib6ls32e/pJezE@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8ib6ls32e/pJezE@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 18, 2023 at 05:24:58PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While fuzzing the data fork extent count on a btree-format directory
> with xfs/375, I observed the following (excerpted) splat:
> 
> XFS: Assertion failed: xfs_isilocked(ip, XFS_ILOCK_EXCL), file: fs/xfs/libxfs/xfs_bmap.c, line: 1208
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 43192 at fs/xfs/xfs_message.c:104 assfail+0x46/0x4a [xfs]
> Call Trace:
>  <TASK>
>  xfs_iread_extents+0x1af/0x210 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xchk_dir_walk+0xb8/0x190 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xchk_parent_count_parent_dentries+0x41/0x80 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xchk_parent_validate+0x199/0x2e0 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xchk_parent+0xdf/0x130 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xfs_scrub_metadata+0x2b8/0x730 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xfs_scrubv_metadata+0x38b/0x4d0 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xfs_ioc_scrubv_metadata+0x111/0x160 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xfs_file_ioctl+0x367/0xf50 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  __x64_sys_ioctl+0x82/0xa0
>  do_syscall_64+0x2b/0x80
>  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> 
> The cause of this is a race condition in xfs_ilock_data_map_shared,
> which performs an unlocked access to the data fork to guess which lock
> mode it needs:
> 
> Thread 0                          Thread 1
> 
> xfs_need_iread_extents
> <observe no iext tree>
> xfs_ilock(..., ILOCK_EXCL)
> xfs_iread_extents
> <observe no iext tree>
> <check ILOCK_EXCL>
> <load bmbt extents into iext>
> <notice iext size doesn't
>  match nextents>
>                                   xfs_need_iread_extents
>                                   <observe iext tree>
>                                   xfs_ilock(..., ILOCK_SHARED)
> <tear down iext tree>
> xfs_iunlock(..., ILOCK_EXCL)
>                                   xfs_iread_extents
>                                   <observe no iext tree>
>                                   <check ILOCK_EXCL>
>                                   *BOOM*
> 
> mitigate this race by having thread 1 to recheck xfs_need_iread_extents
> after taking the shared ILOCK.  If the iext tree isn't present, then we
> need to upgrade to the exclusive ILOCK to try to load the bmbt.

Yup, I see the problem - this check is failing:

        if (XFS_IS_CORRUPT(mp, ir.loaded != ifp->if_nextents)) {
                error = -EFSCORRUPTED;
                goto out;
        }

and that results in calling xfs_iext_destroy() to tear down the
extent tree.

But we know the BMBT is corrupted and the extent list cannot be read
until the corruption is fixed. IOWs, we can't access any data in the
inode no matter how we lock it until the corruption is repaired.

> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_inode.c |   29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index d354ea2b74f9..6ce1e0e9f256 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -117,6 +117,20 @@ xfs_ilock_data_map_shared(
>  	if (xfs_need_iread_extents(&ip->i_df))
>  		lock_mode = XFS_ILOCK_EXCL;
>  	xfs_ilock(ip, lock_mode);
> +
> +	/*
> +	 * It's possible that the unlocked access of the data fork to determine
> +	 * the lock mode could have raced with another thread that was failing
> +	 * to load the bmbt but hadn't yet torn down the iext tree.  Recheck
> +	 * the lock mode and upgrade to an exclusive lock if we need to.
> +	 */
> +	if (lock_mode == XFS_ILOCK_SHARED &&
> +	    xfs_need_iread_extents(&ip->i_df)) {
> +		xfs_iunlock(ip, lock_mode);
> +		lock_mode = XFS_ILOCK_EXCL;
> +		xfs_ilock(ip, lock_mode);
> +	}

.... and this makes me cringe. :/

If we hit this race condition, re-reading the extent list from disk
isn't going to fix the corruption, so I don't see much point in
papering over the problem just by changing the locking and failing
to read in the extent list again and returning -EFSCORRUPTED to the
operation.

So.... shouldn't we mark the inode as sick when we detect the extent
list corruption issue? i.e. before destroying the iext tree, calling
xfs_inode_mark_sick(XFS_SICK_INO_BMBTD) (or BMBTA, depending on the
fork being read) so that there is a record of the BMBT being
corrupt?

That would mean that this path simply becomes:

	if (ip->i_sick & XFS_SICK_INO_BMBTD) {
		xfs_iunlock(ip, lock_mode);
		return -EFSCORRUPTED;
	}

Which is now pretty clear that we there's no point continuing
because we can't read in the extent list, and in doing so we've
removed the race condition caused by temporarily filling the in-core
extent list.

> +
>  	return lock_mode;
>  }
>  
> @@ -129,6 +143,21 @@ xfs_ilock_attr_map_shared(
>  	if (xfs_inode_has_attr_fork(ip) && xfs_need_iread_extents(&ip->i_af))
>  		lock_mode = XFS_ILOCK_EXCL;
>  	xfs_ilock(ip, lock_mode);
> +
> +	/*
> +	 * It's possible that the unlocked access of the attr fork to determine
> +	 * the lock mode could have raced with another thread that was failing
> +	 * to load the bmbt but hadn't yet torn down the iext tree.  Recheck
> +	 * the lock mode and upgrade to an exclusive lock if we need to.
> +	 */
> +	if (lock_mode == XFS_ILOCK_SHARED &&
> +	    xfs_inode_has_attr_fork(ip) &&
> +	    xfs_need_iread_extents(&ip->i_af)) {
> +		xfs_iunlock(ip, lock_mode);
> +		lock_mode = XFS_ILOCK_EXCL;
> +		xfs_ilock(ip, lock_mode);
> +	}

And this can just check for XFS_SICK_INO_BMBTA instead...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
