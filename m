Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2OHFuAZ168421 for <xfs@oss.sgi.com>; Thu, 24 Mar 2011 12:15:56 -0500
From: <brian.foster@emc.com>
Date: Thu, 24 Mar 2011 13:18:06 -0400
Subject: RE: [PATCH 1/6] xfs: preallocation transactions do not need to be
	synchronous
Message-ID: <9EBB77E762A6744BACE68EDD6A4796990712DB92@MX31A.corp.emc.com>
References: <1300860870-15471-1-git-send-email-david@fromorbit.com>
	<1300860870-15471-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1300860870-15471-2-git-send-email-david@fromorbit.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: david@fromorbit.com, xfs@oss.sgi.com
Cc: aelder@sgi.com

> -----Original Message-----
> From: xfs-bounces@oss.sgi.com [mailto:xfs-bounces@oss.sgi.com] On
> Behalf Of Dave Chinner
> Sent: Wednesday, March 23, 2011 2:14 AM
> To: xfs@oss.sgi.com
> Cc: aelder@sgi.com
> Subject: [PATCH 1/6] xfs: preallocation transactions do not need to be
> synchronous

> diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c index
> ae59865..baa2cb3 100644
> --- a/fs/xfs/linux-2.6/xfs_file.c
> +++ b/fs/xfs/linux-2.6/xfs_file.c
> @@ -896,6 +896,7 @@ xfs_file_fallocate(
>  	xfs_flock64_t	bf;
>  	xfs_inode_t	*ip = XFS_I(inode);
>  	int		cmd = XFS_IOC_RESVSP;
> +	int		attr_flags = XFS_ATTR_NOLOCK;
> 
>  	if (mode & ~(FALLOC_FL_KEEP_SIZE |
>  		     FALLOC_FL_PUNCH_HOLE |
> @@ -922,6 +923,9 @@ xfs_file_fallocate(
>  			goto out_unlock;
>  	}
> 
> +	if (file->f_flags & O_DSYNC)
> +		attr_flags |= XFS_ATTR_SYNC;
> +
>  	error = -xfs_change_file_space(ip, cmd, &bf, 0, XFS_ATTR_NOLOCK);
>  	if (error)
>  		goto out_unlock;

Where are you passing attr_flags?

I was looking at this because I noticed a nice performance improvement in some Samba tests with the xfs_trans_set_sync() call removed, but I have a follow up question... I'd like to back port this patch to 2.6.34. The majority of this patch applies (manually), but the segment above is problematic in that I have an xfs_vn_fallocate() inode operations handler (xfs_iops.c) without the file pointer rather than the above file operations handler. 

Without really knowing any of this code, I assume I can IS_SYNC() the inode to check for the sync mount situation? Assuming that is correct, is there a straightforward way to cover the open(..., O_SYNC) situation? I suppose I'm open to hacking the VFS to one off this call if I have to, but would rather avoid the ugliness. Any comments are appreciated, thanks.

Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
