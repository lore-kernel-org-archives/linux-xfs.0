Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAKK0H36207716 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 14:00:17 -0600
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 2/9] ext4: honor the O_SYNC flag for aysnchronous direct
	I/O requests
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
	<20121120074131.24645.38489.stgit@blackbox.djwong.org>
	<20121120100751.GB1408@quack.suse.cz>
Date: Tue, 20 Nov 2012 15:02:15 -0500
In-Reply-To: <20121120100751.GB1408@quack.suse.cz> (Jan Kara's message of
	"Tue, 20 Nov 2012 11:07:51 +0100")
Message-ID: <x49sj84hwl4.fsf@segfault.boston.devel.redhat.com>
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
Cc: axboe@kernel.dk, tytso@mit.edu, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, bpm@sgi.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>> @@ -1279,6 +1280,9 @@ struct ext4_sb_info {
>>  	/* workqueue for dio unwritten */
>>  	struct workqueue_struct *dio_unwritten_wq;
>>  
>> +	/* workqueue for aio+dio+o_sync disk cache flushing */
>> +	struct workqueue_struct *aio_dio_flush_wq;
>> +
>   Umm, I'm not completely decided whether we really need a separate
> workqueue. But it doesn't cost too much so I guess it makes some sense -
> fsync() is rather heavy so syncing won't starve extent conversion...

I'm assuming you'd like me to convert the names from flush to fsync,
yes?

>> +
>> +	/*
>> +	 * If we are running in nojournal mode, just flush the disk
>> +	 * cache and return.
>> +	 */
>> +	if (!journal)
>> +		return blkdev_issue_flush(inode->i_sb->s_bdev, GFP_NOIO, NULL);
>   And this is wrong as well - you need to do work similar to what
> ext4_sync_file() does. Actually it would be *much* better if these two
> sites used the same helper function. Which also poses an interesting
> question about locking - do we need i_mutex or not? Forcing a transaction
> commit is definitely OK without it, similarly as grabbing transaction ids
> from inode or ext4_should_journal_data() test. __sync_inode() call seems
> to be OK without i_mutex as well so I believe we can just get rid of it
> (getting i_mutex from the workqueue is a locking nightmare we don't want to
> return to).

Just to be clear, are you saying you would like me to remove the
mutex_lock/unlock pair from ext4_sync_file?  (I had already factored out
the common code between this new code path and the fsync path in my tree.)

>> @@ -149,8 +209,11 @@ void ext4_add_complete_io(ext4_io_end_t *io_end)
>>  	struct workqueue_struct *wq;
>>  	unsigned long flags;
>>  
>> -	BUG_ON(!(io_end->flag & EXT4_IO_END_UNWRITTEN));
>> -	wq = EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
>> +	BUG_ON(!ext4_io_end_deferred(io_end));
>> +	if (io_end->flag & EXT4_IO_END_UNWRITTEN)
>> +		wq = EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
>> +	else
>> +		wq = EXT4_SB(io_end->inode->i_sb)->aio_dio_flush_wq;
>   Umm, I'd prefer if we used aio_dio_flush_wq when EXT4_IO_END_NEEDS_SYNC
> is set. That way slow syncing works will be always offloaded to a separate
> workqueue.

OK.

Thanks!
Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
