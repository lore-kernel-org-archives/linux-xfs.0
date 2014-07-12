Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4ABB07F60
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 20:39:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 26FBD8F8059
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 18:39:47 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id FGrfyFXYVFGBZnuG for <xfs@oss.sgi.com>;
	Fri, 11 Jul 2014 18:39:45 -0700 (PDT)
Message-ID: <53C091E1.1010907@sandeen.net>
Date: Fri, 11 Jul 2014 20:39:45 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs/quota: fix NULL pointer dereference in report_f
References: <52849CC5.10109@oracle.com>
In-Reply-To: <52849CC5.10109@oracle.com>
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

On 11/14/13, 3:49 AM, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Run xfs_quota report against an invalid XFS path without desired quota
> limitation is enabled will hit SEGSEGV as fs_path is uninitialized, e.g.
> 
> # xfs_quota -xc 'report -up' /invalid_path
> xfs_quota: cannot setup path for mount /invalid_path: No such file or directory
> Segmentation fault (core dumped)
> 
> (gdb) r -xc 'report -up' /invalid_path
> xfs_quota: cannot setup path for mount /invalid_path: No such file or directory
> 
> Program received signal SIGSEGV, Segmentation fault.
> 0x0000000000408b4d in report_f (argc=2, argv=0x105ea70) at report.c:627
> 627			else if (fs_path->fs_flags & FS_MOUNT_POINT)
> 
> This patch fix report_f() to only do report if the fs_path is initialized.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

I know hch had grand plans to make this all nicer, but based on Jeff's
followup emails, it looks like this is the only spot needed to simply
resolve the problems w/ nonexistent paths in quota, and is a small,
contained change we can easily make before the next point release.

Thanks,
-Eric

> ---
>  quota/report.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/quota/report.c b/quota/report.c
> index 70894a2..8e3316e 100644
> --- a/quota/report.c
> +++ b/quota/report.c
> @@ -624,7 +624,7 @@ report_f(
>  		if (flags & ALL_MOUNTS_FLAG)
>  			report_any_type(fp, form, type, NULL,
>  					lower, upper, flags);
> -		else if (fs_path->fs_flags & FS_MOUNT_POINT)
> +		else if (fs_path && (fs_path->fs_flags & FS_MOUNT_POINT))
>  			report_any_type(fp, form, type, fs_path->fs_dir,
>  					lower, upper, flags);
>  	} else while (argc > optind) {
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
