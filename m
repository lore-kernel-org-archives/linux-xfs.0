Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C8D9B7CA1
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 02:57:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8D5E88F8037
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 00:57:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nVnr8DknXsb4GqHG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 19 Jul 2016 00:57:10 -0700 (PDT)
Date: Tue, 19 Jul 2016 09:57:05 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/1 V2] xfs: remove extraneous buffer flag changes
Message-ID: <20160719075705.GC8134@redhat.com>
References: <9810c6bf-9fd7-bf41-13ab-a96bec861457@redhat.com>
	<929bf9d2-968d-6c4a-bca6-24ffc0c54702@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <929bf9d2-968d-6c4a-bca6-24ffc0c54702@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Fri, Jul 08, 2016 at 11:28:02PM -0500, Eric Sandeen wrote:
> Fix up a couple places where extra flag manipulation occurs.
> 
> In the first case we clear XBF_ASYNC and then immediately
> reset it - so don't bother clearing in the first place.
> 
> In the 2nd case we are at a point in the function where the
> buffer must already be async, so there is no need to reset it.
> 
> Add consistent spacing around the " | " while we're at it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

This makes sense too.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
> 
> V2: fix subject, sorry!
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index e71cfbd..5d52e44 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1816,7 +1816,7 @@ __xfs_buf_delwri_submit(
>  
>  	blk_start_plug(&plug);
>  	list_for_each_entry_safe(bp, n, io_list, b_list) {
> -		bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_ASYNC | XBF_WRITE_FAIL);
> +		bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_WRITE_FAIL);
>  		bp->b_flags |= XBF_WRITE | XBF_ASYNC;
>  
>  		/*
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 3425799..6a2f429 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -1080,10 +1080,9 @@ xfs_buf_iodone_callback_error(
>  	 * async write failure at least once, but we also need to set the buffer
>  	 * up to behave correctly now for repeated failures.
>  	 */
> -	if (!(bp->b_flags & (XBF_STALE|XBF_WRITE_FAIL)) ||
> +	if (!(bp->b_flags & (XBF_STALE | XBF_WRITE_FAIL)) ||
>  	     bp->b_last_error != bp->b_error) {
> -		bp->b_flags |= (XBF_WRITE | XBF_ASYNC |
> -			        XBF_DONE | XBF_WRITE_FAIL);
> +		bp->b_flags |= (XBF_WRITE | XBF_DONE | XBF_WRITE_FAIL);
>  		bp->b_last_error = bp->b_error;
>  		bp->b_retries = 0;
>  		bp->b_first_retry_time = jiffies;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
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
