Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q65M8air102996 for <xfs@oss.sgi.com>; Thu, 5 Jul 2012 17:08:36 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	C2Ds8yKocNQFEFHL for <xfs@oss.sgi.com>;
	Thu, 05 Jul 2012 15:08:34 -0700 (PDT)
Date: Fri, 6 Jul 2012 08:08:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/1] ACL: increase the #define XFS_ACL_MAX_ENTRIES to 128
	The xfsprogs xfs_repair will have to be increased also if this is
	okay.
Message-ID: <20120705220832.GQ19223@dastard>
References: <1341520391-9704-1-git-send-email-bradla8@yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1341520391-9704-1-git-send-email-bradla8@yahoo.com>
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
To: Brad Arrington <bradla8@yahoo.com>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Jul 05, 2012 at 01:33:11PM -0700, Brad Arrington wrote:
> 
> Signed-off-by: Brad Arrington <bradla8@yahoo.com>
> ---
>  fs/xfs/xfs_acl.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
> index 39632d9..716d4d2 100644
> --- a/fs/xfs/xfs_acl.h
> +++ b/fs/xfs/xfs_acl.h
> @@ -22,7 +22,7 @@ struct inode;
>  struct posix_acl;
>  struct xfs_inode;
>  
> -#define XFS_ACL_MAX_ENTRIES 25
> +#define XFS_ACL_MAX_ENTRIES 128

That's an on disk format change - you can't just increase it like
that without some kind of superblock feature bit to indicate that
the limit is 128 rather than 25 on that filesystem.

As it is, if we are going to change it, it will get changed to allow
the maximum number of ACLs an attribute can hold, not another
arbitrary number like 128....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
