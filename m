Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA91Luqd128629 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 19:21:57 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D557B1647A8
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 17:23:22 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	J675abAlzF4cwFZb for <xfs@oss.sgi.com>;
	Mon, 08 Nov 2010 17:23:22 -0800 (PST)
Date: Tue, 9 Nov 2010 12:22:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/6] XFS: handle hole punching via fallocate properly
Message-ID: <20101109012254.GE2715@dastard>
References: <1289248327-16308-1-git-send-email-josef@redhat.com>
	<1289248327-16308-2-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1289248327-16308-2-git-send-email-josef@redhat.com>
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
To: Josef Bacik <josef@redhat.com>
Cc: xfs@oss.sgi.com, joel.becker@oracle.com, linux-kernel@vger.kernel.org, cluster-devel@redhat.com, cmm@us.ibm.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Mon, Nov 08, 2010 at 03:32:03PM -0500, Josef Bacik wrote:
> This patch simply allows XFS to handle the hole punching flag in fallocate
> properly.  I've tested this with a little program that does a bunch of random
> hole punching with FL_KEEP_SIZE and without it to make sure it does the right
> thing.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_iops.c |   12 +++++++++---
>  1 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
> index 96107ef..99df347 100644
> --- a/fs/xfs/linux-2.6/xfs_iops.c
> +++ b/fs/xfs/linux-2.6/xfs_iops.c
> @@ -516,6 +516,7 @@ xfs_vn_fallocate(
>  	loff_t		new_size = 0;
>  	xfs_flock64_t	bf;
>  	xfs_inode_t	*ip = XFS_I(inode);
> +	int		cmd = XFS_IOC_RESVSP;
>  
>  	/* preallocation on directories not yet supported */
>  	error = -ENODEV;
> @@ -528,17 +529,22 @@ xfs_vn_fallocate(
>  
>  	xfs_ilock(ip, XFS_IOLOCK_EXCL);
>  
> +	if (mode & FALLOC_FL_PUNCH_HOLE)
> +		cmd = XFS_IOC_UNRESVSP;
> +
>  	/* check the new inode size is valid before allocating */
>  	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
>  	    offset + len > i_size_read(inode)) {
> -		new_size = offset + len;
> +		if (cmd == XFS_IOC_UNRESVSP)
> +			new_size = offset;
> +		else
> +			new_size = offset + len;

What semantic is FALLOC_FL_KEEP_SIZE supposed to convey during a
hole punch? Doesn't this just turn the hole punch operation into
a truncate? If so, what's the point of punching the hole when you
can just call ftruncate() to get the same result?

I'd suggest that FALLOC_FL_PUNCH_HOLE should, by definition, not
change the file size, and have no option to be able to change it.
This needs to be defined and documented - can you include a man
page update in this series that defines the expected behaviour
of FALLOC_FL_PUNCH_HOLE?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
