Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q835HbFt145614 for <xfs@oss.sgi.com>; Mon, 3 Sep 2012 00:17:37 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	hGeYkgnQF8CdUsvi for <xfs@oss.sgi.com>;
	Sun, 02 Sep 2012 22:18:24 -0700 (PDT)
Date: Mon, 3 Sep 2012 15:17:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 3/4] xfs: add FREE_EOFBLOCKS ioctl
Message-ID: <20120903051742.GS15292@dastard>
References: <1346097111-4476-1-git-send-email-bfoster@redhat.com>
	<1346097111-4476-4-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1346097111-4476-4-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 27, 2012 at 03:51:50PM -0400, Brian Foster wrote:
> The XFS_IOC_FREE_EOFBLOCKS ioctl allows users to invoke an EOFBLOCKS
> scan. The xfs_eofblocks structure is defined to support the command
> parameters (quota type/id and minimum file size).
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_fs.h       |   10 ++++++++++
>  fs/xfs/xfs_ioctl.c    |   25 +++++++++++++++++++++++++
>  fs/xfs/xfs_quota.h    |    1 +
>  fs/xfs/xfs_quotaops.c |    2 +-
>  4 files changed, 37 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
> index c13fed8..6f93db9 100644
> --- a/fs/xfs/xfs_fs.h
> +++ b/fs/xfs/xfs_fs.h
> @@ -339,6 +339,15 @@ typedef struct xfs_error_injection {
>  
>  
>  /*
> + * Speculative preallocation trimming.
> + */
> +typedef struct xfs_eofblocks {
> +	__u32		id;		/* quota id */
> +	__u32		qtype;		/* quota type */
> +	__u64		min_file_size;	/* minimum file size */
> +} xfs_eofblocks_t;

No typedefs.

Additionally: this is a user facing API for functionality that has
wider potential use than quota. For example, xfs_fsr runs out of
space in an AG, but it really wants to put a file there, so it calls
XFS_IOC_FREE_EOFBLOCKS to specify the AG it wants all the prealloc
removed from.

So, the structure needs a version number so the kernel knows what
fields the application is aware of, a flags field to say what
operation is being done (i.e. flush by projid) rather than a "qtype"
and a bunch of padding so that we can add new elements to it as need
arises without breaking existing user binaries.

>   * ioctl commands that replace IRIX syssgi()'s
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 0e0232c..b91cbcd 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1602,6 +1602,31 @@ xfs_file_ioctl(
>  		error = xfs_errortag_clearall(mp, 1);
>  		return -error;
>  
> +	case XFS_IOC_FREE_EOFBLOCKS: {
> +		struct xfs_eofblocks eofb;
> +		int qtype;
> +
> +		if (copy_from_user(&eofb, arg, sizeof(eofb)))
> +			return -XFS_ERROR(EFAULT);
> +
> +		qtype = xfs_quota_type(eofb.qtype);
> +
> +		/*
> +		 * TODO: The filtering code currently uses the id in the inode.
> +		 * Therefore, I don't think it really matters whether the
> +		 * particular quota type is enabled (and the dquot is attached).
> +		 *
> +		 * Alternatively, we could filter by dquot type. This would
> +		 * mean we might have to make sure dquot's are attached during
> +		 * the scan and that the particular quota type is enabled. I'm
> +		 * not sure that this buys us anything.
> +		 */

If quota is not enabled, then a request to free blocks determined by
a quota ID is invalid and should be rejected. It's a user API - what
is and isn't supported needs to be written down in black and white
(i.e. in the xfsctl man page).

> +		/* TODO: might want to just use the eofb structure here */
> +		error = xfs_inodes_free_eofblocks(mp, qtype, eofb.id, eofb.min_file_size, EOFBLOCKS_WAIT);

Yes, just pass the structure - it means it can be passed all the way
down to the execute function, and only that code needs to handle
different versions of the structure.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
