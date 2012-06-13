Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5D2GEMM063277 for <xfs@oss.sgi.com>; Tue, 12 Jun 2012 21:16:15 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	nqeVGMQg76cUyMiq for <xfs@oss.sgi.com>;
	Tue, 12 Jun 2012 19:16:13 -0700 (PDT)
Date: Wed, 13 Jun 2012 12:16:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: add FALLOC_FL_ZERO_RANGE to fallocate
Message-ID: <20120613021610.GQ22848@dastard>
References: <1339515364-17374-1-git-send-email-pbonzini@redhat.com>
	<1339515364-17374-3-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1339515364-17374-3-git-send-email-pbonzini@redhat.com>
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
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Tue, Jun 12, 2012 at 05:36:04PM +0200, Paolo Bonzini wrote:
> This is implemented in the same way as the other fallocate modes.  All of
> them map to XFS ioctls that are implemented by xfs_change_file_space.
> 
> However, we need to cap the length to the inode size if the user requested
> FALLOC_FL_KEEP_SIZE.

That's done on purpose.  fallocate() explicitly allows preallocation
beyond EOF and that's what the FALLOC_FL_KEEP_SIZE flag is for - to
allow both offset and offset+len to lie beyond the current inode
size and have the preallocation succeed without changing the file
size.

This is so that we can prevent fragmentation of slow growing
append-only files like log files - we can preallocate way beyond EOF
without changing EOF so as the file grows over days and weeks it
does not fragment.

Similarly, hole punch needs to be able to punch out such
preallocated extents beyond EOF if requested, and it definitely must
not change EOF. So capping/erroring out when offset/offset+len is
definitely the wrong thing to do when FALLOC_FL_KEEP_SIZE is set.

> Cc: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  fs/xfs/xfs_file.c |   36 ++++++++++++++++++++++++------------
>  1 files changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 9f7ec15..c811cf9 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -818,33 +818,45 @@ xfs_file_fallocate(
>  	loff_t		new_size = 0;
>  	xfs_flock64_t	bf;
>  	xfs_inode_t	*ip = XFS_I(inode);
> -	int		cmd = XFS_IOC_RESVSP;
> +	int		cmd;
>  	int		attr_flags = XFS_ATTR_NOLOCK;
>  
> -	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> +	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
> +		     FALLOC_FL_ZERO_RANGE))
>  		return -EOPNOTSUPP;
>  
> +	BUG_ON((mode & FALLOC_FL_PUNCH_HOLE) && (mode & FALLOC_FL_ZERO_RANGE));

Never put BUG_ON() or BUG() in XFS code that can return an error.
Return EINVAL if we chose not to support it, and if it's really
something we consider bad, emit a warning to syslog (i.e.
xfs_warn()) and potentially add a ASSERT() case so that debug
kernels will trip over it. Nobody should be panicing a production
system just because a user supplied a set of incorrect syscall
paramters....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
