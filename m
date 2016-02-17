Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EB6C87CA6
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 14:57:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D73738F8040
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 12:57:47 -0800 (PST)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
	cuda.sgi.com with ESMTP id TA4gfMPgNDmdtOmW for
	<xfs@oss.sgi.com>; Wed, 17 Feb 2016 12:57:39 -0800 (PST)
Date: Wed, 17 Feb 2016 13:57:27 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 3/4 v2] xfs: dynamically switch modes when
	XFS_DIFLAG2_DAX is set/cleared
Message-ID: <20160217205727.GA30126@linux.intel.com>
References: <1455513734-15192-1-git-send-email-david@fromorbit.com>
	<1455513734-15192-4-git-send-email-david@fromorbit.com>
	<20160217073121.GC19486@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160217073121.GC19486@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: ross.zwisler@linux.intel.com, jack@suse.cz, xfs@oss.sgi.com

On Wed, Feb 17, 2016 at 06:31:21PM +1100, Dave Chinner wrote:
> xfs: dynamically switch modes when XFS_DIFLAG2_DAX is set/cleared
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we set or clear the XFS_DIFLAG2_DAX flag, we should also
> set/clear the S_DAX flag in the VFS inode. To do this, we need to
> ensure that we first flush and remove any cached entries in the
> radix tree to ensure the correct data access method is used when we
> next try to read or write data. We ahve to be especially careful
> here to lock out page faults so they don't race with the flush and
> invalidation before we change the access mode.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
> Version 2:
> - fix lock leak in xfs_ioctl_setattr where dquot allocation could
>   fail after we'd locked the inode iolock and mmaplock but we didn't
>   unlock them on error.
> 
>  fs/xfs/xfs_ioctl.c | 105 ++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 92 insertions(+), 13 deletions(-)
<>
> @@ -1072,19 +1115,27 @@ xfs_ioctl_setattr_xflags(
>   * have permission to do so. On success, return a clean transaction and the
>   * inode locked exclusively ready for further operation specific checks. On
>   * failure, return an error without modifying or locking the inode.
> + *
> + * The inode might already be IO locked on call. If this is the case, it is
> + * indicated in @join_flags and we take full responsibility for ensuring they
> + * are unlocked from now on. Hence if we have an error here, we still have to
> + * unlock them. Otherwise, once they are joined to the transaction, they will
> + * be unlocked on commit/cancel.
>   */
>  static struct xfs_trans *
>  xfs_ioctl_setattr_get_trans(
> -	struct xs_inode	*ip)
> +	struct xfs_inode	*ip,

Interesting - it looks like 'xfs_inode' got corrupted to 'xs_inode'?

After fixing this the series passed all my testing.
Tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
