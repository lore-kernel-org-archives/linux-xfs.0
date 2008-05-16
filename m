Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 May 2008 06:50:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4GDnwji032367
	for <xfs@oss.sgi.com>; Fri, 16 May 2008 06:49:59 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ADD3D17D7B2
	for <xfs@oss.sgi.com>; Fri, 16 May 2008 06:50:45 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id xJlJuLCesUGHPLz0 for <xfs@oss.sgi.com>; Fri, 16 May 2008 06:50:45 -0700 (PDT)
Message-ID: <482D9133.8030403@sandeen.net>
Date: Fri, 16 May 2008 08:50:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] update check on valid sb fields being modified on mount
References: <20080516131548.GX103491721@sgi.com>
In-Reply-To: <20080516131548.GX103491721@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:
> Recent changes to update the version number during mount
> (attr2 stuff) failed to change the assert that checked for
> calid flags being changed on mount. Clearly this path hasn't
> been exercised by the test code....
> 
> Signed-off-by: Dave Chinner <dgc@sgi.com>
> ---
>  fs/xfs/xfs_mount.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.c	2008-05-16 23:08:18.000000000 +1000
> +++ 2.6.x-xfs-new/fs/xfs/xfs_mount.c	2008-05-16 23:10:00.224848630 +1000
> @@ -1887,7 +1887,8 @@ xfs_mount_log_sb(
>  	int		error;
>  
>  	ASSERT(fields & (XFS_SB_UNIT | XFS_SB_WIDTH | XFS_SB_UUID |
> -			 XFS_SB_FEATURES2 | XFS_SB_BAD_FEATURES2));
> +			 XFS_SB_FEATURES2 | XFS_SB_BAD_FEATURES2 |
> +			 XFS_SB_VERSIONNUM));
>  
>  	tp = xfs_trans_alloc(mp, XFS_TRANS_SB_UNIT);
>  	error = xfs_trans_reserve(tp, 0, mp->m_sb.sb_sectsize + 128, 0, 0,
> 
> 

Ah, looks like this is from:

                /* update sb_versionnum for the clearing of the morebits */
                if (!sbp->sb_features2)
                        update_flags |= XFS_SB_VERSIONNUM;

when attr2 gets turned back off?

Anyway, looks fine.

-Eric
