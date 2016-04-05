Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 781AD7CA0
	for <xfs@oss.sgi.com>; Tue,  5 Apr 2016 08:19:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 524898F8037
	for <xfs@oss.sgi.com>; Tue,  5 Apr 2016 06:19:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wjCjXhjaoJCHX9YQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 05 Apr 2016 06:19:50 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 7D4168F50E
	for <xfs@oss.sgi.com>; Tue,  5 Apr 2016 13:19:49 +0000 (UTC)
Received: from redhat.com (gfs-i24c-02.mpc.lab.eng.bos.redhat.com
	[10.16.144.214])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u35DJlug004108
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>; Tue, 5 Apr 2016 09:19:49 -0400
Date: Tue, 5 Apr 2016 09:19:47 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 4/4] xfs: reduce lock hold times in buffer writeback
Message-ID: <20160405131947.GB56593@redhat.com>
References: <1459836310-12619-1-git-send-email-david@fromorbit.com>
	<1459836310-12619-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1459836310-12619-5-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

Looks good to me

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

On Tue, Apr 05, 2016 at 04:05:10PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we have a lot of metadata to flush from the AIL, the buffer
> list can get very long. The current submission code tries to batch
> submission to optimise IO order of the metadata (i.e. ascending
> block order) to maximise block layer merging or IO to adjacent
> metadata blocks.
> 
> Unfortunately, the method used can result in long lock times
> occurring as buffers locked early on in the buffer list might not be
> dispatched until the end of the IO licst processing. This is because
> sorting does not occur util after the buffer list has been processed
> and the buffers that are going to be submitted are locked. Hence
> when the buffer list is several thousand buffers long, the lock hold
> times before IO dispatch can be significant.
> 
> To fix this, sort the buffer list before we start trying to lock and
> submit buffers. This means we can now submit buffers immediately
> after they are locked, allowing merging to occur immediately on the
> plug and dispatch to occur as quickly as possible. This means there
> is minimal delay between locking the buffer and IO submission
> occuring, hence reducing the worst case lock hold times seen during
> delayed write buffer IO submission signficantly.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c | 60 +++++++++++++++++++++++++++++++++-----------------------
>  1 file changed, 35 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 467a636..0d49e81 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1780,18 +1780,33 @@ xfs_buf_cmp(
>  	return 0;
>  }
>  
> +/*
> + * submit buffers for write.
> + *
> + * When we have a large buffer list, we do not want to hold all the buffers
> + * locked while we block on the request queue waiting for IO dispatch. To avoid
> + * this problem, we lock and submit buffers in groups of 50, thereby minimising
> + * the lock hold times for lists which may contain thousands of objects.
> + *
> + * To do this, we sort the buffer list before we walk the list to lock and
> + * submit buffers, and we plug and unplug around each group of buffers we
> + * submit.
> + */
>  static int
> -__xfs_buf_delwri_submit(
> +xfs_buf_delwri_submit_buffers(
>  	struct list_head	*buffer_list,
> -	struct list_head	*io_list,
> -	bool			wait)
> +	struct list_head	*wait_list)
>  {
> -	struct blk_plug		plug;
>  	struct xfs_buf		*bp, *n;
> +	LIST_HEAD		(submit_list);
>  	int			pinned = 0;
> +	struct blk_plug		plug;
> +
> +	list_sort(NULL, buffer_list, xfs_buf_cmp);
>  
> +	blk_start_plug(&plug);
>  	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
> -		if (!wait) {
> +		if (!wait_list) {
>  			if (xfs_buf_ispinned(bp)) {
>  				pinned++;
>  				continue;
> @@ -1814,25 +1829,21 @@ __xfs_buf_delwri_submit(
>  			continue;
>  		}
>  
> -		list_move_tail(&bp->b_list, io_list);
>  		trace_xfs_buf_delwri_split(bp, _RET_IP_);
> -	}
> -
> -	list_sort(NULL, io_list, xfs_buf_cmp);
> -
> -	blk_start_plug(&plug);
> -	list_for_each_entry_safe(bp, n, io_list, b_list) {
> -		bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_ASYNC | XBF_WRITE_FAIL);
> -		bp->b_flags |= XBF_WRITE | XBF_ASYNC;
>  
>  		/*
> -		 * we do all Io submission async. This means if we need to wait
> -		 * for IO completion we need to take an extra reference so the
> -		 * buffer is still valid on the other side.
> +		 * We do all IO submission async. This means if we need
> +		 * to wait for IO completion we need to take an extra
> +		 * reference so the buffer is still valid on the other
> +		 * side. We need to move the buffer onto the io_list
> +		 * at this point so the caller can still access it.
>  		 */
> -		if (wait)
> +		bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_ASYNC | XBF_WRITE_FAIL);
> +		bp->b_flags |= XBF_WRITE | XBF_ASYNC;
> +		if (wait_list) {
>  			xfs_buf_hold(bp);
> -		else
> +			list_move_tail(&bp->b_list, wait_list);
> +		} else
>  			list_del_init(&bp->b_list);
>  
>  		xfs_buf_submit(bp);
> @@ -1855,8 +1866,7 @@ int
>  xfs_buf_delwri_submit_nowait(
>  	struct list_head	*buffer_list)
>  {
> -	LIST_HEAD		(io_list);
> -	return __xfs_buf_delwri_submit(buffer_list, &io_list, false);
> +	return xfs_buf_delwri_submit_buffers(buffer_list, NULL);
>  }
>  
>  /*
> @@ -1871,15 +1881,15 @@ int
>  xfs_buf_delwri_submit(
>  	struct list_head	*buffer_list)
>  {
> -	LIST_HEAD		(io_list);
> +	LIST_HEAD		(wait_list);
>  	int			error = 0, error2;
>  	struct xfs_buf		*bp;
>  
> -	__xfs_buf_delwri_submit(buffer_list, &io_list, true);
> +	xfs_buf_delwri_submit_buffers(buffer_list, &wait_list);
>  
>  	/* Wait for IO to complete. */
> -	while (!list_empty(&io_list)) {
> -		bp = list_first_entry(&io_list, struct xfs_buf, b_list);
> +	while (!list_empty(&wait_list)) {
> +		bp = list_first_entry(&wait_list, struct xfs_buf, b_list);
>  
>  		list_del_init(&bp->b_list);
>  
> -- 
> 2.7.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
