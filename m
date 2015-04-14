Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4157F7F5A
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2015 09:35:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2FC7B8F8052
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2015 07:35:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fzyOHoVKaXgGjNEJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 Apr 2015 07:35:28 -0700 (PDT)
Date: Tue, 14 Apr 2015 10:35:23 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 6/8] xfs: DIO write completion size updates race
Message-ID: <20150414143523.GG36198@bfoster.bfoster>
References: <1428996411-1507-1-git-send-email-david@fromorbit.com>
	<1428996411-1507-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1428996411-1507-7-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Tue, Apr 14, 2015 at 05:26:49PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_end_io_direct_write() can race with other IO completions when
> updating the in-core inode size. The IO completion processing is not
> serialised for direct IO - they are done either under the
> IOLOCK_SHARED for non-AIO DIO, and without any IOLOCK held at all
> during AIO DIO completion. Hence the non-atomic test-and-set update
> of the in-core inode size is racy and can result in the in-core
> inode size going backwards if the race if hit just right.
> 
> If the inode size goes backwards, this can trigger the EOF zeroing
> code to run incorrectly on the next IO, which then will zero data
> that has successfully been written to disk by a previous DIO.
> 
> To fix this bug, we need to serialise the test/set updates of the
> in-core inode size. This first patch introduces locking around the
> relevant updates and checks in the DIO path. Because we now have an
> ioend in xfs_end_io_direct_write(), we know exactly then we are
> doing an IO that requires an in-core EOF update, and we know that
> they are not running in interrupt context. As such, we do not need to
> use irqsave() spinlock variants to protect against interrupts while
> the lock is held.
> 
> Hence we can use an existing spinlock in the inode to do this
> serialisation and so not need to grow the struct xfs_inode just to
> work around this problem.
> 
> This patch does not address the test/set EOF update in
> generic_file_write_direct() for various reasons - that will be done
> as a followup with separate explanation.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_aops.c |  7 +++++++
>  fs/xfs/xfs_file.c | 13 ++++++++++++-
>  2 files changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 55356f6..cd6b2e0 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1577,9 +1577,16 @@ xfs_end_io_direct_write(
>  	 * with the on-disk inode size being outside the in-core inode size. We
>  	 * have no other method of updating EOF for AIO, so always do it here
>  	 * if necessary.
> +	 *
> +	 * We need to lock the test/set EOF update as we can be racing with
> +	 * other IO completions here to update the EOF. Failing to serialise
> +	 * here can result in EOF moving backwards and Bad Things Happen when
> +	 * that occurs.
>  	 */
> +	spin_lock(&ip->i_flags_lock);
>  	if (offset + size > i_size_read(inode))
>  		i_size_write(inode, offset + size);
> +	spin_unlock(&ip->i_flags_lock);
>  
>  	/*
>  	 * If we are doing an append IO that needs to update the EOF on disk,
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index c203839..5d5b4ba 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -569,10 +569,20 @@ restart:
>  	 * write.  If zeroing is needed and we are currently holding the
>  	 * iolock shared, we need to update it to exclusive which implies
>  	 * having to redo all checks before.
> +	 *
> +	 * We need to serialise against EOF updates that occur in IO
> +	 * completions here. We want to make sure that nobody is changing the
> +	 * size while we do this check until we have placed an IO barrier (i.e.
> +	 * hold the XFS_IOLOCK_EXCL) that prevents new IO from being dispatched.
> +	 * The spinlock effectively forms a memory barrier once we have the
> +	 * XFS_IOLOCK_EXCL so we are guaranteed to see the latest EOF value
> +	 * and hence be able to correctly determine if we need to run zeroing.
>  	 */
> +	spin_lock(&ip->i_flags_lock);
>  	if (*pos > i_size_read(inode)) {
>  		bool	zero = false;
>  
> +		spin_unlock(&ip->i_flags_lock);
>  		if (*iolock == XFS_IOLOCK_SHARED) {
>  			xfs_rw_iunlock(ip, *iolock);
>  			*iolock = XFS_IOLOCK_EXCL;
> @@ -582,7 +592,8 @@ restart:
>  		error = xfs_zero_eof(ip, *pos, i_size_read(inode), &zero);
>  		if (error)
>  			return error;
> -	}
> +	} else
> +		spin_unlock(&ip->i_flags_lock);
>  
>  	/*
>  	 * Updating the timestamps will grab the ilock again from
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
