Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B0C927FBD
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 02:48:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A3DD58F8039
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 00:48:53 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id H8pdCvv69VJvWBwH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 00:48:52 -0700 (PDT)
Message-ID: <536893DB.7050705@oracle.com>
Date: Tue, 06 May 2014 15:48:43 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 5/5] xfs: remove shared supberlock feature checking
References: <1399348559-19889-1-git-send-email-david@fromorbit.com>
	<1399348559-19889-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1399348559-19889-6-git-send-email-david@fromorbit.com>
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


On 05/06 2014 11:55 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We reject any filesystem that is mounted with this feature bit set,
> so we don't need to check for it anywhere else. Remove the function
> for checking if the feature bit is set and any code that uses it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_fsops.c |  2 --
>  fs/xfs/xfs_sb.c    |  3 ++-
>  fs/xfs/xfs_sb.h    | 17 ++++-------------
>  3 files changed, 6 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index b099799..97886a7 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -84,8 +84,6 @@ xfs_fs_geometry(
>  				XFS_FSOP_GEOM_FLAGS_IALIGN : 0) |
>  			(xfs_sb_version_hasdalign(&mp->m_sb) ?
>  				XFS_FSOP_GEOM_FLAGS_DALIGN : 0) |
> -			(xfs_sb_version_hasshared(&mp->m_sb) ?
> -				XFS_FSOP_GEOM_FLAGS_SHARED : 0) |

Just a trivial comments, now the XFS_FSOP_GEOM_FLAGS_SHARED is useless, so
we can remove it from fs/xfs/xfs.h.

Otherwise, looks good to me.

Reviewed-by: Jie Liu <jeff.liu@oracle.com>


Cheers,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
