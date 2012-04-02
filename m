Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q32ETG6B186743 for <xfs@oss.sgi.com>; Mon, 2 Apr 2012 09:29:17 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zGQCWbvba0FsHM7O for
	<xfs@oss.sgi.com>; Mon, 02 Apr 2012 07:29:15 -0700 (PDT)
Subject: Re: [PATCH 3/7] gfs2: Use generic handlers of O_SYNC AIO DIO
From: Steven Whitehouse <swhiteho@redhat.com>
In-Reply-To: <1333058705-31512-4-git-send-email-jmoyer@redhat.com>
References: <1333058705-31512-1-git-send-email-jmoyer@redhat.com>
	<1333058705-31512-4-git-send-email-jmoyer@redhat.com>
Date: Mon, 02 Apr 2012 15:29:31 +0100
Message-ID: <1333376971.2701.26.camel@menhir>
Mime-Version: 1.0
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, linux-ext4@vger.kernel.org, jack@suse.cz, xfs@oss.sgi.com

Hi,

On Thu, 2012-03-29 at 18:05 -0400, Jeff Moyer wrote:
> From: Jan Kara <jack@suse.cz>
> 
> Use generic handlers to queue fsync() when AIO DIO is completed for O_SYNC
> file.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Acked-by: Steven Whitehouse <swhiteho@redhat.com>

Steve.

> ---
>  fs/gfs2/aops.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
> index 38b7a74..2589781 100644
> --- a/fs/gfs2/aops.c
> +++ b/fs/gfs2/aops.c
> @@ -1034,7 +1034,7 @@ static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
>  
>  	rv = __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
>  				  offset, nr_segs, gfs2_get_block_direct,
> -				  NULL, NULL, 0);
> +				  NULL, NULL, DIO_SYNC_WRITES);
>  out:
>  	gfs2_glock_dq_m(1, &gh);
>  	gfs2_holder_uninit(&gh);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
