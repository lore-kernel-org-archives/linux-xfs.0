Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q16GKXfo147735 for <xfs@oss.sgi.com>; Mon, 6 Feb 2012 10:20:33 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mJ3zONaHRwvBdqkR for
	<xfs@oss.sgi.com>; Mon, 06 Feb 2012 08:20:31 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 2/3] ext4: honor the O_SYNC flag for aysnchronous direct
	I/O requests
References: <1327698949-12616-1-git-send-email-jmoyer@redhat.com>
	<1327698949-12616-3-git-send-email-jmoyer@redhat.com>
	<20120202173120.GA6640@quack.suse.cz>
Date: Mon, 06 Feb 2012 11:20:29 -0500
In-Reply-To: <20120202173120.GA6640@quack.suse.cz> (Jan Kara's message of
	"Thu, 2 Feb 2012 18:31:20 +0100")
Message-ID: <x49bopcq6gi.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

Jan Kara <jack@suse.cz> writes:

>> +	/* workqueue for aio+dio+o_sync disk cache flushing */
>> +	struct workqueue_struct *aio_dio_flush_wq;
>> +
>   Hmm, looking at the patch I'm wondering why did you introduce the new
> workqueue? It seems dio_unwritten_wq would be enough? You just need to
> rename it to something more appropriate ;)

I used a new workqueue as the operations are blocking, and I didn't want
to hold up other progress.  If you think re-using the unwritten_wq is
the right thing to do, I'm happy to comply.

>> +	/*
>> +	 * This function has two callers.  The first is the end_io_work
>> +	 * routine just below.  This is an asynchronous completion context.
>> +	 * The second is in the fsync path.  For the latter path, we can't
>> +	 * return from here until the job is done.  Hence, we issue a
>> +	 * blocking blkdev_issue_flush call.
>> +	 */
>> +	if (io->flag & EXT4_IO_END_NEEDS_SYNC) {
>> +		/*
>> +		 * Ideally, we'd like to know if the force_commit routine
>> +		 * actually did send something to disk.  If it didn't,
>> +		 * then we need to issue the cache flush by hand.  For now,
>> +		 * play it safe and do both.
>> +		 */
>> +		ret = ext4_force_commit(inode->i_sb);
>> +		if (ret)
>> +			goto endio;
>> +		ret = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_NOIO, NULL);
>   Look at what ext4_sync_file() does. It's more efficient than this.
> You need something like:
> 	commit_tid = file->f_flags & __O_SYNC ? EXT4_I(inode)->i_sync_tid :
> 						EXT4_I(inode)->i_datasync_tid;
> 	if (journal->j_flags & JBD2_BARRIER &&
> 	    !jbd2_trans_will_send_data_barrier(journal, commit_tid))
> 		needs_barrier = true;
> 	jbd2_log_start_commit(journal, commit_tid);
> 	jbd2_log_wait_commit(journal, commit_tid);
> 	if (needs_barrier)
> 		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_NOIO, NULL);

Great, thanks for the pointer!

Cheers,
Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
