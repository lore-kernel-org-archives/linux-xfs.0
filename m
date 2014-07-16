Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6B6967FA4
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 12:10:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 42A2E8F8066
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 10:10:47 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id YAbLNPGiICrWVTvt for <xfs@oss.sgi.com>;
	Wed, 16 Jul 2014 10:10:45 -0700 (PDT)
Message-ID: <53C6B212.9030704@sandeen.net>
Date: Wed, 16 Jul 2014 12:10:42 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix uflags detection at xfs_fs_rm_xquota
References: <53C4F5DB.2060108@oracle.com>
In-Reply-To: <53C4F5DB.2060108@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 7/15/14, 4:35 AM, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> We are intended to check up uflags against FS_PROJ_QUOTA rather than 
> FS_USER_UQUOTA once more, it looks to me like a typo, but might cause
> the project quota metadata space can not be removed.

Ugh, mea culpa.  Thanks for spotting.  :(

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thankfully I don't think anyone uses this interface ;)

> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  fs/xfs/xfs_quotaops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index 4f7aecb..b238027 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -123,7 +123,7 @@ xfs_fs_rm_xquota(
>  		flags |= XFS_DQ_USER;
>  	if (uflags & FS_GROUP_QUOTA)
>  		flags |= XFS_DQ_GROUP;
> -	if (uflags & FS_USER_QUOTA)
> +	if (uflags & FS_PROJ_QUOTA)
>  		flags |= XFS_DQ_PROJ;
>  
>  	return xfs_qm_scall_trunc_qfiles(mp, flags);
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
