Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 00ECD7F4E
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 11:06:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E50EA304067
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 09:06:23 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Dx2XtS3Ty5EZa8uc for
	<xfs@oss.sgi.com>; Wed, 12 Jun 2013 09:06:23 -0700 (PDT)
Message-ID: <51B89D58.80108@redhat.com>
Date: Wed, 12 Jun 2013 12:10:00 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 04/27] xfs: don't use speculative prealloc for small files
References: <1371032567-21772-1-git-send-email-david@fromorbit.com>
	<1371032567-21772-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1371032567-21772-5-git-send-email-david@fromorbit.com>
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

On 06/12/2013 06:22 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
...
> ---
>  fs/xfs/xfs_iomap.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 8f8aaee..14be676 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -284,6 +284,15 @@ xfs_iomap_eof_want_preallocate(
>  		return 0;
>  
>  	/*
> +	 * If the file is smaller than the minimum prealloc and we are using
> +	 * dynamic preallocation, don't do any preallocation at all as it is
> +	 * likely this is the only write to the file that is going to be done.
> +	 */
> +	if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) &&
> +	    XFS_ISIZE(ip) < mp->m_writeio_blocks)
> +		return 0;
> +

I stuck this on a box, got a 64k prealloc on an 8k file and then noticed
this was comparing inode size against a block count. This should
probably be:

	XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_writeio_blocks)

Given that, we avoid preallocs entirely until the file size reaches the
minimum write size (assuming dynamic prealloc mode).

> +	/*
>  	 * If there are any real blocks past eof, then don't
>  	 * do any speculative allocation.
>  	 */
> @@ -345,6 +354,10 @@ xfs_iomap_eof_prealloc_initial_size(
>  	if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
>  		return 0;
>  
> +	/* If the file is small, then use the minimum prealloc */
> +	if (XFS_ISIZE(ip) < mp->m_dalign)
> +		return 0;
> +
...

... and the same fsb->b conversion applies here.

If the file is larger than the minimum write size but smaller than the
stripe unit, we prealloc by the minimum prealloc size (m_writeio_blocks)
until the file grows beyond the stripe unit. That means if the stripe
unit is smaller than m_writeio_blocks or not specified, we'd just start
right into the dynamic prealloc algorithm. Seems reasonable.

Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
