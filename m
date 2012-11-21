Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAL0sKdJ229431 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 18:54:20 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id OffAsPGn1fF5xTR3 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 20 Nov 2012 16:56:30 -0800 (PST)
Date: Wed, 21 Nov 2012 01:56:26 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/9] ext4: honor the O_SYNC flag for aysnchronous
	direct I/O requests
Message-ID: <20121121005626.GC10507@quack.suse.cz>
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
	<20121120074131.24645.38489.stgit@blackbox.djwong.org>
	<20121120100751.GB1408@quack.suse.cz>
	<x49sj84hwl4.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <x49sj84hwl4.fsf@segfault.boston.devel.redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jeff Moyer <jmoyer@redhat.com>
Cc: axboe@kernel.dk, tytso@mit.edu, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, bpm@sgi.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 20-11-12 15:02:15, Jeff Moyer wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> >> @@ -1279,6 +1280,9 @@ struct ext4_sb_info {
> >>  	/* workqueue for dio unwritten */
> >>  	struct workqueue_struct *dio_unwritten_wq;
> >>  
> >> +	/* workqueue for aio+dio+o_sync disk cache flushing */
> >> +	struct workqueue_struct *aio_dio_flush_wq;
> >> +
> >   Umm, I'm not completely decided whether we really need a separate
> > workqueue. But it doesn't cost too much so I guess it makes some sense -
> > fsync() is rather heavy so syncing won't starve extent conversion...
> 
> I'm assuming you'd like me to convert the names from flush to fsync,
> yes?
  Would be nicer, yes.

> >> +
> >> +	/*
> >> +	 * If we are running in nojournal mode, just flush the disk
> >> +	 * cache and return.
> >> +	 */
> >> +	if (!journal)
> >> +		return blkdev_issue_flush(inode->i_sb->s_bdev, GFP_NOIO, NULL);
> >   And this is wrong as well - you need to do work similar to what
> > ext4_sync_file() does. Actually it would be *much* better if these two
> > sites used the same helper function. Which also poses an interesting
> > question about locking - do we need i_mutex or not? Forcing a transaction
> > commit is definitely OK without it, similarly as grabbing transaction ids
> > from inode or ext4_should_journal_data() test. __sync_inode() call seems
> > to be OK without i_mutex as well so I believe we can just get rid of it
> > (getting i_mutex from the workqueue is a locking nightmare we don't want to
> > return to).
> 
> Just to be clear, are you saying you would like me to remove the
> mutex_lock/unlock pair from ext4_sync_file?  (I had already factored out
> the common code between this new code path and the fsync path in my tree.)
  Yes, after some thinking I came to that conclusion. We actually need to
keep i_mutex around ext4_flush_unwritten_io() to avoid livelocks but the
rest doesn't need it. The change should be definitely a separate patch just
in case there's something subtle I missed and we need to bisect in
future... I've attached a patch for that so that blame for bugs goes my way
;) Compile tested only so far. I'll give it some more testing overnight.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--k+w/mQv8wyuph6w0
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-Reduce-i_mutex-usage-in-ext4_file_sync.patch"

>From 98f02e76b90e278e9688b4311a8889cec7095601 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 21 Nov 2012 01:46:51 +0100
Subject: [PATCH] ext4: Reduce i_mutex usage in ext4_file_sync()

ext4_file_sync() needs i_mutex only to avoid livelocks of
ext4_flush_unwritten_io() all other code doesn't need it. In particular
syncing of inode & metadata in non-journal case is safe (writeback doesn't
hold i_mutex either) and forcing of transaction commits doesn't need i_mutex
either (there's nothing inode specific in that code apart from grabbing
transaction ids from the inode). So shorten the span where i_mutex is held.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/fsync.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index be1d89f..2268114 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -113,8 +113,6 @@ static int __sync_inode(struct inode *inode, int datasync)
  *
  * What we do is just kick off a commit and wait on it.  This will snapshot the
  * inode to disk.
- *
- * i_mutex lock is held when entering and exiting this function
  */
 
 int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
@@ -133,12 +131,13 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
 	if (ret)
 		return ret;
-	mutex_lock(&inode->i_mutex);
 
 	if (inode->i_sb->s_flags & MS_RDONLY)
 		goto out;
 
+	mutex_lock(&inode->i_mutex);
 	ret = ext4_flush_unwritten_io(inode);
+	mutex_unlock(&inode->i_mutex);
 	if (ret < 0)
 		goto out;
 
@@ -180,7 +179,6 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 			ret = err;
 	}
  out:
-	mutex_unlock(&inode->i_mutex);
 	trace_ext4_sync_file_exit(inode, ret);
 	return ret;
 }
-- 
1.7.1


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--k+w/mQv8wyuph6w0--
