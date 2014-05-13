Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 84CB47F3F
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 07:48:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 04781AC003
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 05:48:25 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id yPTDSxKSwyYvDlH1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 May 2014 05:48:24 -0700 (PDT)
Message-ID: <5372148A.4080407@oracle.com>
Date: Tue, 13 May 2014 20:48:10 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/9] xfs: xfs_commit_metadata returns wrong errno
References: <1399971373-6242-1-git-send-email-david@fromorbit.com>
	<1399971373-6242-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1399971373-6242-4-git-send-email-david@fromorbit.com>
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
> Invert it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_export.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
> index 1399e18..753e467 100644
> --- a/fs/xfs/xfs_export.c
> +++ b/fs/xfs/xfs_export.c
> @@ -237,7 +237,7 @@ xfs_fs_nfs_commit_metadata(
>  
>  	if (!lsn)
>  		return 0;
> -	return _xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, NULL);
> +	return -_xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, NULL);
>  }
>  
>  const struct export_operations xfs_export_operations = {
> 

Reviewed-by: Jie Liu <jeff.liu@oracle.com>


Cheers,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
