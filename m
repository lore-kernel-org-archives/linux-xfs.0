Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAKA5le8137604 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 04:05:47 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id FFTI2Y6jd09pIhFX (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 20 Nov 2012 02:07:55 -0800 (PST)
Date: Tue, 20 Nov 2012 11:07:51 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/9] ext4: honor the O_SYNC flag for aysnchronous
	direct I/O requests
Message-ID: <20121120100751.GB1408@quack.suse.cz>
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
	<20121120074131.24645.38489.stgit@blackbox.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121120074131.24645.38489.stgit@blackbox.djwong.org>
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

On Mon 19-11-12 23:41:31, Darrick J. Wong wrote:
> If a file is opened with O_SYNC|O_DIRECT, the drive cache does not get
> flushed after the write completion.  Instead, it's flushed *before* the
> I/O is sent to the disk (in __generic_file_aio_write).  This patch
> attempts to fix that problem by marking an I/O as requiring a cache
> flush in endio processing.  I'll send a follow-on patch to the
> generic write code to get rid of the bogus generic_write_sync call
> when EIOCBQUEUED is returned.
> 
> From: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> [darrick.wong@oracle.com: Rework original patch to reflect a subsequent
> 			  ext4 reorganization]
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/ext4/ext4.h    |    9 +++++
>  fs/ext4/file.c    |    2 +
>  fs/ext4/inode.c   |    6 +++
>  fs/ext4/page-io.c |   92 +++++++++++++++++++++++++++++++++++++++++++++--------
>  fs/ext4/super.c   |   13 +++++++
>  5 files changed, 106 insertions(+), 16 deletions(-)
> 
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 3c20de1..f5a0b89 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -186,6 +186,7 @@ struct mpage_da_data {
>  #define EXT4_IO_END_ERROR	0x0002
>  #define EXT4_IO_END_QUEUED	0x0004
>  #define EXT4_IO_END_DIRECT	0x0008
> +#define EXT4_IO_END_NEEDS_SYNC	0x0010
>  
>  struct ext4_io_page {
>  	struct page	*p_page;
> @@ -1279,6 +1280,9 @@ struct ext4_sb_info {
>  	/* workqueue for dio unwritten */
>  	struct workqueue_struct *dio_unwritten_wq;
>  
> +	/* workqueue for aio+dio+o_sync disk cache flushing */
> +	struct workqueue_struct *aio_dio_flush_wq;
> +
  Umm, I'm not completely decided whether we really need a separate
workqueue. But it doesn't cost too much so I guess it makes some sense -
fsync() is rather heavy so syncing won't starve extent conversion...

> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 68e896e..cda013a 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -84,6 +84,50 @@ void ext4_free_io_end(ext4_io_end_t *io)
>  	kmem_cache_free(io_end_cachep, io);
>  }
>  
> +/*
> + * This function is called in the completion path for AIO O_SYNC|O_DIRECT
> + * writes, and also in the fsync path.  The purpose is to ensure that the
> + * disk caches for the journal and data devices are flushed.
> + */
> +static int ext4_end_io_do_flush(ext4_io_end_t *io)
> +{
> +	struct inode *inode = io->inode;
> +	tid_t commit_tid;
> +	bool needs_barrier = false;
> +	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
> +	int barriers_enabled = test_opt(inode->i_sb, BARRIER);
> +	int ret = 0;
> +
> +	if (!barriers_enabled)
> +		return 0;
  This is definitely wrong. Even if barriers are disabled, we may need to
push out some buffers or commit a transaction.

> +
> +	/*
> +	 * If we are running in nojournal mode, just flush the disk
> +	 * cache and return.
> +	 */
> +	if (!journal)
> +		return blkdev_issue_flush(inode->i_sb->s_bdev, GFP_NOIO, NULL);
  And this is wrong as well - you need to do work similar to what
ext4_sync_file() does. Actually it would be *much* better if these two
sites used the same helper function. Which also poses an interesting
question about locking - do we need i_mutex or not? Forcing a transaction
commit is definitely OK without it, similarly as grabbing transaction ids
from inode or ext4_should_journal_data() test. __sync_inode() call seems
to be OK without i_mutex as well so I believe we can just get rid of it
(getting i_mutex from the workqueue is a locking nightmare we don't want to
return to).

> +
> +	if (ext4_should_journal_data(inode)) {
> +		ret = ext4_force_commit(inode->i_sb);
> +		goto out;
> +	}
> +
> +	commit_tid = io->iocb->ki_filp->f_flags & __O_SYNC ?
> +		EXT4_I(inode)->i_sync_tid : EXT4_I(inode)->i_datasync_tid;
> +	if (!jbd2_trans_will_send_data_barrier(journal, commit_tid))
> +		needs_barrier = true;
> +
> +	jbd2_log_start_commit(journal, commit_tid);
> +	ret = jbd2_log_wait_commit(journal, commit_tid);
> +
> +	if (!ret && needs_barrier)
> +		ret = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_NOIO, NULL);
> +
> +out:
> +	return ret;
> +}
> +
>  /* check a range of space and convert unwritten extents to written. */
>  static int ext4_end_io(ext4_io_end_t *io)
>  {
...
> @@ -149,8 +209,11 @@ void ext4_add_complete_io(ext4_io_end_t *io_end)
>  	struct workqueue_struct *wq;
>  	unsigned long flags;
>  
> -	BUG_ON(!(io_end->flag & EXT4_IO_END_UNWRITTEN));
> -	wq = EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
> +	BUG_ON(!ext4_io_end_deferred(io_end));
> +	if (io_end->flag & EXT4_IO_END_UNWRITTEN)
> +		wq = EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
> +	else
> +		wq = EXT4_SB(io_end->inode->i_sb)->aio_dio_flush_wq;
  Umm, I'd prefer if we used aio_dio_flush_wq when EXT4_IO_END_NEEDS_SYNC
is set. That way slow syncing works will be always offloaded to a separate
workqueue.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
