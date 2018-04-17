Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:45504 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751211AbeDQJAj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 05:00:39 -0400
Received: by mail-wr0-f196.google.com with SMTP id u11so33244813wri.12
        for <linux-xfs@vger.kernel.org>; Tue, 17 Apr 2018 02:00:39 -0700 (PDT)
Date: Tue, 17 Apr 2018 11:00:30 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/2] xfs: validate cached inodes are free when allocated
Message-ID: <20180417090030.xyt53fr5aztxftfg@odin.usersys.redhat.com>
References: <20180417063916.13069-1-david@fromorbit.com>
 <20180417063916.13069-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180417063916.13069-2-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

>  fs/xfs/xfs_icache.c | 73 +++++++++++++++++++++++++++++++++++------------------
>  1 file changed, 48 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 98b7a4ae15e4..fb37ada55710 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -309,6 +309,46 @@ xfs_reinit_inode(
>  	return error;
>  }
>  
> +/*
> + * If we are allocating a new inode, then check what was returned is
> + * actually a free, empty inode. If we are not allocating an inode,
> + * the check we didn't find a free inode.

I know it's been like that for a while, but maybe it's a good time to fix this
typo? "then check we didn't find..." ?

Fixing the old typo or not, the patch looks good:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

-- 
Carlos
