Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47898 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbeK2LUD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Nov 2018 06:20:03 -0500
Subject: Re: [PATCH 4/6] xfs_scrub: handle totally empty inode chunks
References: <154181071499.3727.3910572718199592407.stgit@magnolia>
 <154181073901.3727.3960278646297663354.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8de9dcd7-4bcd-2f4b-0043-835611317bed@sandeen.net>
Date: Wed, 28 Nov 2018 18:16:37 -0600
MIME-Version: 1.0
In-Reply-To: <154181073901.3727.3960278646297663354.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 11/9/18 6:45 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We try to load a single inobt record with each FSINUMBERS call.  If the
> chunk is totally empty (which can happen when there are more than one
> inobt record per block) we should skip to the next INUMBERS call since
> there are no inodes to bulkstat.

It's not clear to me if this is a bugfix or an optimization, but meh,
seems like the right thing to do :)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  scrub/inodes.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> 
> diff --git a/scrub/inodes.c b/scrub/inodes.c
> index 693f21ec..442a5978 100644
> --- a/scrub/inodes.c
> +++ b/scrub/inodes.c
> @@ -139,6 +139,12 @@ xfs_iterate_inodes_range(
>  		/* Load the inodes. */
>  		ino = inogrp.xi_startino - 1;
>  		bulkreq.icount = inogrp.xi_alloccount;
> +		/*
> +		 * We can have totally empty inode chunks on filesystems where
> +		 * there are more than 64 inodes per block.  Skip these.
> +		 */
> +		if (inogrp.xi_alloccount == 0)
> +			goto igrp_retry;
>  		error = ioctl(ctx->mnt_fd, XFS_IOC_FSBULKSTAT, &bulkreq);
>  		if (error)
>  			str_info(ctx, descr, "%s", strerror_r(errno,
> 
