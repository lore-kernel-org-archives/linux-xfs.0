Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 480007F3F
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 07:51:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 189DF8F8033
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 05:51:15 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 0UpbqZhVLNTDqOA0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 May 2014 05:51:13 -0700 (PDT)
Message-ID: <53721538.6020702@oracle.com>
Date: Tue, 13 May 2014 20:51:04 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 5/9] xfs: fix wrong errno from xfs_initxattrs
References: <1399971373-6242-1-git-send-email-david@fromorbit.com>
	<1399971373-6242-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1399971373-6242-6-git-send-email-david@fromorbit.com>
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
>  fs/xfs/xfs_iops.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 301ecbf..adfb18e 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -72,8 +72,8 @@ xfs_initxattrs(
>  	int			error = 0;
>  
>  	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
> -		error = xfs_attr_set(ip, xattr->name, xattr->value,
> -				     xattr->value_len, ATTR_SECURE);
> +		error = -xfs_attr_set(ip, xattr->name, xattr->value,
> +				      xattr->value_len, ATTR_SECURE);
>  		if (error < 0)
>  			break;
>  	}
> @@ -93,8 +93,8 @@ xfs_init_security(
>  	struct inode	*dir,
>  	const struct qstr *qstr)
>  {
> -	return security_inode_init_security(inode, dir, qstr,
> -					    &xfs_initxattrs, NULL);
> +	return -security_inode_init_security(inode, dir, qstr,
> +					     &xfs_initxattrs, NULL);
>  }
>  
>  static void
> 

Reviewed-by: Jie Liu <jeff.liu@oracle.com>

Cheers,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
