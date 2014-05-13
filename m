Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8A0127F3F
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 07:52:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 482A7304136
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 05:52:29 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id EUo9HxQBxLFxfP1B (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 May 2014 05:52:28 -0700 (PDT)
Message-ID: <53721565.1030104@oracle.com>
Date: Tue, 13 May 2014 20:51:49 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 6/9] xfs: fix wrong err sign on xfs_set_acl()
References: <1399971373-6242-1-git-send-email-david@fromorbit.com>
	<1399971373-6242-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1399971373-6242-7-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com


On 05/13 2014 16:56 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_iops.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index adfb18e..36d6303 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -173,12 +173,12 @@ xfs_generic_create(
>  
>  #ifdef CONFIG_XFS_POSIX_ACL
>  	if (default_acl) {
> -		error = xfs_set_acl(inode, default_acl, ACL_TYPE_DEFAULT);
> +		error = -xfs_set_acl(inode, default_acl, ACL_TYPE_DEFAULT);
>  		if (error)
>  			goto out_cleanup_inode;
>  	}
>  	if (acl) {
> -		error = xfs_set_acl(inode, acl, ACL_TYPE_ACCESS);
> +		error = -xfs_set_acl(inode, acl, ACL_TYPE_ACCESS);
>  		if (error)
>  			goto out_cleanup_inode;
>  	}
> 

Reviewed-by: Jie Liu <jeff.liu@oracle.com>

Cheers,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
