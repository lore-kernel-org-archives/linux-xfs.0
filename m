Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36000 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbeGYEPp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jul 2018 00:15:45 -0400
Received: by mail-wr1-f68.google.com with SMTP id h9-v6so5922697wro.3
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jul 2018 20:06:11 -0700 (PDT)
Date: Wed, 25 Jul 2018 05:06:07 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/2] xfs: kill IHOLD
Message-ID: <20180725030607.ucgyal5ormcia5sd@odin.usersys.redhat.com>
References: <153248128617.28208.11803349732053454018.stgit@magnolia>
 <153248129226.28208.17839960103899087670.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153248129226.28208.17839960103899087670.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 24, 2018 at 06:14:52PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Nobody uses this macro, get rid of it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_inode.h |    7 -------
>  1 file changed, 7 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 2ed63a49e890..8e18bc0fedd0 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -484,13 +484,6 @@ static inline void xfs_setup_existing_inode(struct xfs_inode *ip)
>  	xfs_finish_inode_setup(ip);
>  }
>  
> -#define IHOLD(ip) \
> -do { \
> -	ASSERT(atomic_read(&VFS_I(ip)->i_count) > 0) ; \
> -	ihold(VFS_I(ip)); \
> -	trace_xfs_ihold(ip, _THIS_IP_); \
> -} while (0)
> -

And looks like trace_xfs_ihold is gone for almost two years...

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  #define IRELE(ip) \
>  do { \
>  	trace_xfs_irele(ip, _THIS_IP_); \
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
