Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B9DF67F3F
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 07:56:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8A0E68F8039
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 05:56:20 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 4i0A9U2av7a9TdmI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 May 2014 05:56:19 -0700 (PDT)
Message-ID: <53721660.70007@oracle.com>
Date: Tue, 13 May 2014 20:56:00 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 7/9] xfs: negate mount workqueue init error value
References: <1399971373-6242-1-git-send-email-david@fromorbit.com>
	<1399971373-6242-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1399971373-6242-8-git-send-email-david@fromorbit.com>
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
>  fs/xfs/xfs_super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 2053767..e1597f2 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1433,7 +1433,7 @@ xfs_fs_fill_super(
>  	if (error)
>  		goto out_free_fsname;
>  
> -	error = xfs_init_mount_workqueues(mp);
> +	error = -xfs_init_mount_workqueues(mp);
>  	if (error)
>  		goto out_close_devices;
>  
> 

Reviewed-by: Jie Liu <jeff.liu@oracle.com>

Cheers,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
