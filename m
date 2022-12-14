Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 080DFC4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Dec 2022 01:35:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236839AbiLNBf3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 20:35:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236851AbiLNBf2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 20:35:28 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF88275C3
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 17:35:27 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id 3-20020a17090a098300b00219041dcbe9so5459721pjo.3
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 17:35:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LTHFKEiyCyDjyn+fmvMkZ3QGGzOIZVWACg6V9ksy+hA=;
        b=KEhBwYElA8QxuBnHM8Owodd6OBOWm+bhXzdBHwANr9QLhHwGHE61EqHr/J0ofXDY4U
         mFOU0d7x9KyNZUaYoHfibCrEg/xABa8DwON3FwXlPgz8QFtXFkm7E0SKFLESz5mpufsK
         ddkaKcIZVqgIF2p+xBKNKjDEdiHKaxSBilAgtVIcszhHsxjKX4xiqpvugWVyimPpT/4v
         AeuIUJeQ5iKEsxvn1EYYsmpxuaZVA9RQa90P7BN6QiqC9xNBOjNewd5lnS+lWA56hWc/
         5FgYa5li/vNqOXRBQn6RkOlKk/D6UrM8Y1Lbx5OIJNtnAbud/RR8geAwdI2u0GIyNdHH
         Hq+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LTHFKEiyCyDjyn+fmvMkZ3QGGzOIZVWACg6V9ksy+hA=;
        b=oy/9/iD+u8lRQy+yT8IFvk6/+//3NaFZ11dVt5sisWyIyxX5u37WC/+ewqQT7aNsHh
         EcZ4lymazX7oo3iw7N9iT7Su8rE8PW2c6CT9MLF02NFBEzs9aLRpYHYv4JJRHeYuSVOE
         KGQpwrDmgwpXL6wM6UlaUPthc0n9M3ekuodKHNt+RQTKTHHdjgrMAQ0tFm7jFmDzx5JL
         9w0n35VceZG8xFGHoJlwk++0ku7rr7W3vLwleaTm3WNryR+TC56w7hBXqIGDLWXFYfIP
         +Q5y3wmYdjR2tvEw8MFUyznJeuPRekdC3OeBepZ/aMAVsV4zdwCLjbl1E60KqlO8SY2P
         jwbA==
X-Gm-Message-State: ANoB5pno9PEVhQEWxnl6fCBBFsriHCbjYH42LGgUlAZdxwLj/978bqX0
        cCTW1KwU9sMY1SOTXtCLtq7O0uze2N+VBNPS
X-Google-Smtp-Source: AA0mqf47yirrdZxr3UVmGdSrsIJARYJgit1eaupiJXW/6zt28/fqcQyf2yi/vcDWhLnJchyLHY4oMg==
X-Received: by 2002:a17:903:28f:b0:190:bf01:3a45 with SMTP id j15-20020a170903028f00b00190bf013a45mr7040311plr.25.1670981727126;
        Tue, 13 Dec 2022 17:35:27 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id u18-20020a170903125200b001897916be2bsm486238plh.268.2022.12.13.17.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 17:35:26 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p5Gg8-008A8N-3E; Wed, 14 Dec 2022 12:35:24 +1100
Date:   Wed, 14 Dec 2022 12:35:24 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 06/11] xfs: initialize fs-verity on file open and
 cleanup on inode destruction
Message-ID: <20221214013524.GF3600936@dread.disaster.area>
References: <20221213172935.680971-1-aalbersh@redhat.com>
 <20221213172935.680971-7-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213172935.680971-7-aalbersh@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 13, 2022 at 06:29:30PM +0100, Andrey Albershteyn wrote:
> fs-verity will read and attach metadata (not the tree itself) from
> a disk for those inodes which already have fs-verity enabled.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  fs/xfs/xfs_file.c  | 8 ++++++++
>  fs/xfs/xfs_super.c | 2 ++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 242165580e682..5eadd9a37c50e 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -32,6 +32,7 @@
>  #include <linux/mman.h>
>  #include <linux/fadvise.h>
>  #include <linux/mount.h>
> +#include <linux/fsverity.h>
>  
>  static const struct vm_operations_struct xfs_file_vm_ops;
>  
> @@ -1170,9 +1171,16 @@ xfs_file_open(
>  	struct inode	*inode,
>  	struct file	*file)
>  {
> +	int		error = 0;
> +
>  	if (xfs_is_shutdown(XFS_M(inode->i_sb)))
>  		return -EIO;
>  	file->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC;
> +
> +	error = fsverity_file_open(inode, file);
> +	if (error)
> +		return error;

This is a hot path, so shouldn't we elide the function call
altogether if verity is not enabled on the inode? i.e:

	if (IS_VERITY(inode)) {
		error = fsverity_file_open(inode, file);
		if (error)
			return error;
	}

It doesn't really matter for a single file open, but when you're
opening a few million inodes every second the function call overhead
only to immediately return because IS_VERITY() is false adds up...

>  	return generic_file_open(inode, file);
>  }
>  
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 8f1e9b9ed35d9..50c2c819ba940 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -45,6 +45,7 @@
>  #include <linux/magic.h>
>  #include <linux/fs_context.h>
>  #include <linux/fs_parser.h>
> +#include <linux/fsverity.h>
>  
>  static const struct super_operations xfs_super_operations;
>  
> @@ -647,6 +648,7 @@ xfs_fs_destroy_inode(
>  	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
>  	XFS_STATS_INC(ip->i_mount, vn_rele);
>  	XFS_STATS_INC(ip->i_mount, vn_remove);
> +	fsverity_cleanup_inode(inode);

Similarly, shouldn't this be:

	if (fsverity_active(inode))
		fsverity_cleanup_inode(inode);

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
