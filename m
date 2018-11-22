Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49106 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395487AbeKWEjb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Nov 2018 23:39:31 -0500
Date: Thu, 22 Nov 2018 09:58:01 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] fs/xfs: fix f_ffree value for statfs when project quota
 is set
Message-ID: <20181122175801.GV6792@magnolia>
References: <6EC51EE77FA0264BB8DAD779E0C341C9014BD77C91@EXMBX-SZMAIL003.tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6EC51EE77FA0264BB8DAD779E0C341C9014BD77C91@EXMBX-SZMAIL003.tencent.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: =?utf-8?B?ZGJ5aW4o5bC554OoKQ==?= <dbyin@tencent.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Thu, Nov 22, 2018 at 01:28:04PM +0000, dbyin(尹烨) wrote:
> When project is set, we should use inode limit minus the used count
> 
> Signed-off-by: Ye Yin <dbyin@tencent.com>

This makes sense to me, but ... it's been broken like this since 2006.
Is there a reason why (someone named Glen) wrote it this way?

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_qm_bhv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
> index 73a1d77ec187..3091e4bc04ef 100644
> --- a/fs/xfs/xfs_qm_bhv.c
> +++ b/fs/xfs/xfs_qm_bhv.c
> @@ -40,7 +40,7 @@ xfs_fill_statvfs_from_dquot(
>                 statp->f_files = limit;
>                 statp->f_ffree =
>                         (statp->f_files > dqp->q_res_icount) ?
> -                        (statp->f_ffree - dqp->q_res_icount) : 0;
> +                        (statp->f_files - dqp->q_res_icount) : 0;
>         }
>  }
>  
> -- 
> 2.16.2
