Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:40513 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbeGYFKP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jul 2018 01:10:15 -0400
Received: by mail-wm0-f66.google.com with SMTP id y9-v6so3667648wma.5
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jul 2018 21:00:32 -0700 (PDT)
Date: Wed, 25 Jul 2018 06:00:28 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/2] xfs: clean up IRELE/iput callsites
Message-ID: <20180725040028.6tvtb3pfe4bbqf5i@odin.usersys.redhat.com>
References: <153248128617.28208.11803349732053454018.stgit@magnolia>
 <153248129832.28208.4218463670080722161.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153248129832.28208.4218463670080722161.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 24, 2018 at 06:14:58PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Replace the IRELE macro with a proper function so that we can do proper
> typechecking and so that we can stop open-coding iput in scrub, which
> means that we'll be able to ftrace inode lifetimes going through scrub
> correctly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>  }
> +
> +/* Release an inode. */
> +void
> +xfs_irele(
> +	struct xfs_inode	*ip)
> +{
> +	trace_xfs_irele(ip, _RET_IP_);
> +	iput(VFS_I(ip));
> +}

I think this still shows the callers of xfs_irele() in the trace right? Assuming
I'm right here:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 8e18bc0fedd0..fa05f8126b00 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -484,11 +484,7 @@ static inline void xfs_setup_existing_inode(struct xfs_inode *ip)
>  	xfs_finish_inode_setup(ip);
>  }
>  
> -#define IRELE(ip) \
> -do { \
> -	trace_xfs_irele(ip, _THIS_IP_); \
> -	iput(VFS_I(ip)); \
> -} while (0)
> +void xfs_irele(struct xfs_inode *ip);
>  
>  

-- 
Carlos
