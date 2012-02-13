Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1D9fPpl255545 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 03:41:25 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id f1qyEDyoNYwLskQZ for
	<xfs@oss.sgi.com>; Mon, 13 Feb 2012 01:41:24 -0800 (PST)
Subject: Re: [Cluster-devel] [PATCH 3/4] gfs2: Use generic handlers of
	O_SYNC AIO DIO
From: Steven Whitehouse <swhiteho@redhat.com>
In-Reply-To: <1328889842-23231-4-git-send-email-jack@suse.cz>
References: <1328889842-23231-1-git-send-email-jack@suse.cz>
	<1328889842-23231-4-git-send-email-jack@suse.cz>
Date: Mon, 13 Feb 2012 09:42:18 +0000
Message-ID: <1329126138.2702.4.camel@menhir>
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
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, cluster-devel@redhat.com, Jeff Moyer <jmoyer@redhat.com>, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

Hi,

Acked-by: Steven Whitehouse <swhiteho@redhat.com>

That looks ok to me,

Steve.

On Fri, 2012-02-10 at 17:04 +0100, Jan Kara wrote:
> Use generic handlers to queue fsync() when AIO DIO is completed for O_SYNC
> file.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/gfs2/aops.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
> index 501e5cb..9c381ff 100644
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
