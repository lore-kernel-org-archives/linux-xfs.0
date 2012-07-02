Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q626QS8F173508 for <xfs@oss.sgi.com>; Mon, 2 Jul 2012 01:26:28 -0500
Date: Mon, 2 Jul 2012 02:26:25 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2 V2] xfs: cleanup the mount options
Message-ID: <20120702062625.GB20804@infradead.org>
References: <1340816243-6177-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<1340993202-5560-1-git-send-email-gaowanlong@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1340993202-5560-1-git-send-email-gaowanlong@cn.fujitsu.com>
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
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Zach Brown <zab@zabbo.net>, XFS <xfs@oss.sgi.com>

On Sat, Jun 30, 2012 at 02:06:41AM +0800, Wanlong Gao wrote:
> remove the mount options macro, use tokens instead.
> 
> CC: Ben Myers <bpm@sgi.com>
> CC: Christoph Hellwig <hch@infradead.org>
> CC: Dave Chinner <david@fromorbit.com>
> CC: Zach Brown <zab@zabbo.net>
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> ---
>  fs/xfs/xfs_super.c |  523 ++++++++++++++++++++++++++++------------------------
>  1 file changed, 287 insertions(+), 236 deletions(-)

This looks pretty good, some minor comments below:

>  /*
>   * Table driven mount option parser.
>   */

This comment can go now that there is only a single mount option parser.

> +free_string:
> +	kfree(string);
> +	string = NULL;
> +free_orig:
> +	kfree(orig);
> +	return ret;
> +}

no need to set string to NULL just before returning.

> -	static struct proc_xfs_info xfs_info_set[] = {
> -		/* the few simple ones we can get from the mount struct */
> -		{ XFS_MOUNT_IKEEP,		"," MNTOPT_IKEEP },
> -		{ XFS_MOUNT_WSYNC,		"," MNTOPT_WSYNC },
> -		{ XFS_MOUNT_NOALIGN,		"," MNTOPT_NOALIGN },
> -		{ XFS_MOUNT_SWALLOC,		"," MNTOPT_SWALLOC },
> -		{ XFS_MOUNT_NOUUID,		"," MNTOPT_NOUUID },
> -		{ XFS_MOUNT_NORECOVERY,		"," MNTOPT_NORECOVERY },
> -		{ XFS_MOUNT_ATTR2,		"," MNTOPT_ATTR2 },
> -		{ XFS_MOUNT_FILESTREAMS,	"," MNTOPT_FILESTREAM },
> -		{ XFS_MOUNT_GRPID,		"," MNTOPT_GRPID },
> -		{ XFS_MOUNT_DISCARD,		"," MNTOPT_DISCARD },
> -		{ 0, NULL }
> -	};
> -	static struct proc_xfs_info xfs_info_unset[] = {
> -		/* the few simple ones we can get from the mount struct */
> -		{ XFS_MOUNT_COMPAT_IOSIZE,	"," MNTOPT_LARGEIO },
> -		{ XFS_MOUNT_BARRIER,		"," MNTOPT_NOBARRIER },
> -		{ XFS_MOUNT_SMALL_INUMS,	"," MNTOPT_64BITINODE },
> -		{ 0, NULL }
> -	};

I can't find any good reason to remove these tables, just replace the
MNTOPT_ constants with the plain strings.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
