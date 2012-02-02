Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q12HVPkq066572 for <xfs@oss.sgi.com>; Thu, 2 Feb 2012 11:31:26 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id DaI6ckLyBUb0nyla (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Feb 2012 09:31:23 -0800 (PST)
Date: Thu, 2 Feb 2012 18:31:20 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] ext4: honor the O_SYNC flag for aysnchronous
	direct I/O requests
Message-ID: <20120202173120.GA6640@quack.suse.cz>
References: <1327698949-12616-1-git-send-email-jmoyer@redhat.com>
	<1327698949-12616-3-git-send-email-jmoyer@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1327698949-12616-3-git-send-email-jmoyer@redhat.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

  Hi,

On Fri 27-01-12 16:15:48, Jeff Moyer wrote:
> If a file is opened with O_SYNC|O_DIRECT, the drive cache does not get
> flushed after the write completion.  Instead, it's flushed *before* the
> I/O is sent to the disk (in __generic_file_aio_write).  This patch
> attempts to fix that problem by marking an I/O as requiring a cache
> flush in endio processing.  I'll send a follow-on patch to the
> generic write code to get rid of the bogus generic_write_sync call
> when EIOCBQUEUED is returned.
  Thanks for the patch!

> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> ---
>  fs/ext4/ext4.h    |    4 ++++
>  fs/ext4/inode.c   |   11 +++++++++--
>  fs/ext4/page-io.c |   39 ++++++++++++++++++++++++++++++++-------
>  fs/ext4/super.c   |   11 +++++++++++
>  4 files changed, 56 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 2d55d7c..4377ed3 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -185,6 +185,7 @@ struct mpage_da_data {
>  #define EXT4_IO_END_ERROR	0x0002
>  #define EXT4_IO_END_QUEUED	0x0004
>  #define EXT4_IO_END_DIRECT	0x0008
> +#define EXT4_IO_END_NEEDS_SYNC	0x0010
>  
>  struct ext4_io_page {
>  	struct page	*p_page;
> @@ -1247,6 +1248,9 @@ struct ext4_sb_info {
>  	/* workqueue for dio unwritten */
>  	struct workqueue_struct *dio_unwritten_wq;
>  
> +	/* workqueue for aio+dio+o_sync disk cache flushing */
> +	struct workqueue_struct *aio_dio_flush_wq;
> +
  Hmm, looking at the patch I'm wondering why did you introduce the new
workqueue? It seems dio_unwritten_wq would be enough? You just need to
rename it to something more appropriate ;)

> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 9e1b8eb..d07cd40 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -98,15 +98,40 @@ int ext4_end_io_nolock(ext4_io_end_t *io)
>  		   "list->prev 0x%p\n",
>  		   io, inode->i_ino, io->list.next, io->list.prev);
>  
> -	ret = ext4_convert_unwritten_extents(inode, offset, size);
> -	if (ret < 0) {
> -		ext4_msg(inode->i_sb, KERN_EMERG,
> -			 "failed to convert unwritten extents to written "
> -			 "extents -- potential data loss!  "
> -			 "(inode %lu, offset %llu, size %zd, error %d)",
> -			 inode->i_ino, offset, size, ret);
> +	if (io->flag & EXT4_IO_END_UNWRITTEN) {
> +
> +		ret = ext4_convert_unwritten_extents(inode, offset, size);
> +		if (ret < 0) {
> +			ext4_msg(inode->i_sb, KERN_EMERG,
> +				 "failed to convert unwritten extents to "
> +				 "written extents -- potential data loss!  "
> +				 "(inode %lu, offset %llu, size %zd, error %d)",
> +				 inode->i_ino, offset, size, ret);
> +			goto endio;
> +		}
> +	}
> +
> +	/*
> +	 * This function has two callers.  The first is the end_io_work
> +	 * routine just below.  This is an asynchronous completion context.
> +	 * The second is in the fsync path.  For the latter path, we can't
> +	 * return from here until the job is done.  Hence, we issue a
> +	 * blocking blkdev_issue_flush call.
> +	 */
> +	if (io->flag & EXT4_IO_END_NEEDS_SYNC) {
> +		/*
> +		 * Ideally, we'd like to know if the force_commit routine
> +		 * actually did send something to disk.  If it didn't,
> +		 * then we need to issue the cache flush by hand.  For now,
> +		 * play it safe and do both.
> +		 */
> +		ret = ext4_force_commit(inode->i_sb);
> +		if (ret)
> +			goto endio;
> +		ret = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_NOIO, NULL);
  Look at what ext4_sync_file() does. It's more efficient than this.
You need something like:
	commit_tid = file->f_flags & __O_SYNC ? EXT4_I(inode)->i_sync_tid :
						EXT4_I(inode)->i_datasync_tid;
	if (journal->j_flags & JBD2_BARRIER &&
	    !jbd2_trans_will_send_data_barrier(journal, commit_tid))
		needs_barrier = true;
	jbd2_log_start_commit(journal, commit_tid);
	jbd2_log_wait_commit(journal, commit_tid);
	if (needs_barrier)
		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_NOIO, NULL);

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
