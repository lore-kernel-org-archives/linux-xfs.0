Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BA4337CA0
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 21:52:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8A0AE8F8033
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 19:52:16 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id prDrIo5nyN6CVwRH for <xfs@oss.sgi.com>;
	Thu, 21 Jul 2016 19:52:13 -0700 (PDT)
Received: from Liberator.local (204-195-32-108.wavecable.com [204.195.32.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128
	bits)) (No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id C93952B18
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 21:52:12 -0500 (CDT)
Subject: Re: [PATCH] xfs: remove EXPERIMENTAL tag from sparse inode feature
References: <1469148546-18369-1-git-send-email-david@fromorbit.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d6f4164a-60fa-9303-c126-dd519ce43b39@sandeen.net>
Date: Thu, 21 Jul 2016 19:52:10 -0700
MIME-Version: 1.0
In-Reply-To: <1469148546-18369-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

On 7/21/16 5:49 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Been around for long enough now, hasn't caused any regression test
> failures in the past 3 months, so it's time to make it a fully
> supported feature.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Seems reasonable to me.

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> ---
>  fs/xfs/xfs_super.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 258b594..0303f10 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1573,10 +1573,6 @@ xfs_fs_fill_super(
>  		}
>  	}
>  
> -	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
> -		xfs_alert(mp,
> -	"EXPERIMENTAL sparse inode feature enabled. Use at your own risk!");
> -
>  	error = xfs_mountfs(mp);
>  	if (error)
>  		goto out_filestream_unmount;
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
