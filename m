Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q99JkvgD094617 for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 14:46:57 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	jEp37GJdknNp8u1p for <xfs@oss.sgi.com>;
	Tue, 09 Oct 2012 12:48:26 -0700 (PDT)
Date: Wed, 10 Oct 2012 06:48:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfsprogs: add PROJID32 geom feature flag
Message-ID: <20121009194825.GN23644@dastard>
References: <50747753.6040105@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50747753.6040105@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Oct 09, 2012 at 02:13:23PM -0500, Eric Sandeen wrote:
> Matches new flag added to kernel.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/include/xfs_fs.h b/include/xfs_fs.h
> index faac5af..0dd3afd 100644
> --- a/include/xfs_fs.h
> +++ b/include/xfs_fs.h
> @@ -233,7 +233,8 @@ typedef struct xfs_fsop_resblks {
>  #define XFS_FSOP_GEOM_FLAGS_LOGV2	0x0100	/* log format version 2	*/
>  #define XFS_FSOP_GEOM_FLAGS_SECTOR	0x0200	/* sector sizes >1BB	*/
>  #define XFS_FSOP_GEOM_FLAGS_ATTR2	0x0400	/* inline attributes rework */
> -#define XFS_FSOP_GEOM_FLAGS_DIRV2CI	0x1000	/* ASCII only CI names */
> +#define XFS_FSOP_GEOM_FLAGS_PROJID32	0x0800  /* 32-bit project IDs	*/
> +#define XFS_FSOP_GEOM_FLAGS_DIRV2CI	0x1000	/* ASCII only CI names	*/
>  #define XFS_FSOP_GEOM_FLAGS_LAZYSB	0x4000	/* lazy superblock counters */

That's an easy one ;)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
