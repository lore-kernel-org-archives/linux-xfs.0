Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qALJUnjP086492 for <xfs@oss.sgi.com>; Wed, 21 Nov 2012 13:30:49 -0600
Date: Wed, 21 Nov 2012 11:32:41 -0800
From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [PATCH 7/9] ocfs2: Use generic handlers of O_SYNC AIO DIO
Message-ID: <20121121193240.GL2822@localhost>
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
	<20121120075114.25270.83181.stgit@blackbox.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121120075114.25270.83181.stgit@blackbox.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: axboe@kernel.dk, xfs@oss.sgi.com, tytso@mit.edu, bpm@sgi.com, linux-kernel@vger.kernel.org, hch@infradead.org, jmoyer@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, jack@suse.cz, linux-ext4@vger.kernel.org

On Mon, Nov 19, 2012 at 11:51:14PM -0800, Darrick J. Wong wrote:
> Use generic handlers to queue fsync() when AIO DIO is completed for O_SYNC
> file.
> 
> From: Jan Kara <jack@suse.cz>
> Signed-off-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Acked-by: Joel Becker <jlbec@evilplan.org>

> ---
>  fs/ocfs2/aops.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 6577432..60457cc 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -593,9 +593,7 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
>  	level = ocfs2_iocb_rw_locked_level(iocb);
>  	ocfs2_rw_unlock(inode, level);
>  
> -	if (is_async)
> -		aio_complete(iocb, ret, 0);
> -	inode_dio_done(inode);
> +	generic_dio_end_io(iocb, offset, bytes, private, ret, is_async);
>  }
>  
>  /*
> @@ -642,7 +640,7 @@ static ssize_t ocfs2_direct_IO(int rw,
>  	return __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev,
>  				    iov, offset, nr_segs,
>  				    ocfs2_direct_IO_get_blocks,
> -				    ocfs2_dio_end_io, NULL, 0);
> +				    ocfs2_dio_end_io, NULL, DIO_SYNC_WRITES);
>  }
>  
>  static void ocfs2_figure_cluster_boundaries(struct ocfs2_super *osb,
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

"Hell is oneself, hell is alone, the other figures in it, merely projections."
        - T. S. Eliot

			http://www.jlbec.org/
			jlbec@evilplan.org

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
