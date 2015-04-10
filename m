Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9D6E429E06
	for <xfs@oss.sgi.com>; Fri, 10 Apr 2015 15:22:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 76E8D304048
	for <xfs@oss.sgi.com>; Fri, 10 Apr 2015 13:22:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kgLVwQTeb6e3NFxQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Apr 2015 13:22:16 -0700 (PDT)
Date: Fri, 10 Apr 2015 16:22:12 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/5] xfs: direct IO EOF zeroing needs to drain AIO
Message-ID: <20150410202212.GD2846@laptop.bfoster>
References: <1428673080-23052-1-git-send-email-david@fromorbit.com>
	<1428673080-23052-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1428673080-23052-5-git-send-email-david@fromorbit.com>
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

On Fri, Apr 10, 2015 at 11:37:59PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we are doing AIO DIO writes, the IOLOCK only provides an IO
> submission barrier. When we need to do EOF zeroing, we need to ensure
> that no other IO is in progress and all pending in-core EOF updates
> have been completed. This requires us to wait for all outstanding
> AIO DIO writes to the inode to complete and, if necessary, run their
> EOF updates.
> 
> Once all the EOF updates are complete, we can then restart
> xfs_file_aio_write_checks() while holding the IOLOCK_EXCL, knowing
> that EOF is up to date and we have exclusive IO access to the file
> so we can run EOF block zeroing if we need to without interference.
> This gives EOF zeroing the same exclusivity against other IO as we
> provide truncate operations.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Looks good...

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_file.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 38ff356..7b872f4 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -587,6 +587,16 @@ restart:
>  			xfs_rw_iunlock(ip, *iolock);
>  			*iolock = XFS_IOLOCK_EXCL;
>  			xfs_rw_ilock(ip, *iolock);
> +
> +			/*
> +			 * We now have an IO submission barrier in place, but
> +			 * AIO can do EOF updates during IO completion and hence
> +			 * we now need to wait for all of them to drain. Non-AIO
> +			 * DIO will have drained before we are given the
> +			 * XFS_IOLOCK_EXCL, and so for most cases this wait is a
> +			 * no-op.
> +			 */
> +			inode_dio_wait(inode);
>  			goto restart;
>  		}
>  		error = xfs_zero_eof(ip, *pos, i_size_read(inode), &zero);
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
