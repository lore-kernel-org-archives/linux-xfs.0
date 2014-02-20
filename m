Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1560C7FB7
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 13:09:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C58738F8035
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 11:09:19 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id jJyE5y2Ih0VWFzNG for <xfs@oss.sgi.com>;
	Thu, 20 Feb 2014 11:09:15 -0800 (PST)
Message-ID: <530652DA.7010706@sandeen.net>
Date: Thu, 20 Feb 2014 13:09:14 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] libxfs: clear stale buffer errors on write
References: <1392875722-4390-1-git-send-email-david@fromorbit.com>
	<1392875722-4390-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1392875722-4390-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 2/19/14, 11:55 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If we've read a buffer and it's had an error (e.g a bad CRC) and the
> caller corrects the problem with the buffer and writes it via
> libxfs_writebuf() without clearing the error on the buffer,
> subsequent reads of the buffer while it is still in cache can see
> that error and fail inappropriately.
> 
> xfs/033 demonstrates this error, where phase 3 detects the corrupted
> root inode and clears, but doesn't clear the b_error field. Later in
> phase 6, the code that rebuilds the root directory tries to read the
> root inode and sees a buffer with an error on it, thereby triggering
> a fatal repair failure:
> 
> Phase 3 - for each AG...
>         - scan and clear agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
> xfs_inode_buf_verify: XFS_CORRUPTION_ERROR
> bad magic number 0x0 on inode 64
> ....
> cleared root inode 64
> ....
> Phase 6 - check inode connectivity...
> reinitializing root directory
> xfs_imap_to_bp: xfs_trans_read_buf() returned error 117.
> 
> fatal error -- could not iget root inode -- error - 117
> #
> 
> Fix this by assuming buffers that are written are clean and correct
> and hence we can zero the b_error field before retiring the buffer
> to the cache.

Thanks; 

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Reported-by: Eric Sandeen <esandeen@redhat.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  libxfs/rdwr.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 78a9b37..d0ff15b 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -890,6 +890,11 @@ libxfs_writebufr(xfs_buf_t *bp)
>  int
>  libxfs_writebuf_int(xfs_buf_t *bp, int flags)
>  {
> +	/*
> +	 * Clear any error hanging over from reading the buffer. This prevents
> +	 * subsequent reads after this write from seeing stale errors.
> +	 */
> +	bp->b_error = 0;
>  	bp->b_flags |= (LIBXFS_B_DIRTY | flags);
>  	return 0;
>  }
> @@ -903,6 +908,11 @@ libxfs_writebuf(xfs_buf_t *bp, int flags)
>  			(long long)LIBXFS_BBTOOFF64(bp->b_bn),
>  			(long long)bp->b_bn);
>  #endif
> +	/*
> +	 * Clear any error hanging over from reading the buffer. This prevents
> +	 * subsequent reads after this write from seeing stale errors.
> +	 */
> +	bp->b_error = 0;
>  	bp->b_flags |= (LIBXFS_B_DIRTY | flags);
>  	libxfs_putbuf(bp);
>  	return 0;
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
