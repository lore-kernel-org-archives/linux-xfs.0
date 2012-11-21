Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAL6EbcC254316 for <xfs@oss.sgi.com>; Wed, 21 Nov 2012 00:14:37 -0600
Received: from mail-pa0-f53.google.com (mail-pa0-f53.google.com
	[209.85.220.53]) by cuda.sgi.com with ESMTP id INEWfTOPA08IDllN
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 20 Nov 2012 22:16:44 -0800 (PST)
Received: by mail-pa0-f53.google.com with SMTP id hz1so1472049pad.26
	for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 22:16:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <mailman.316.1353461777.59926.xfs@oss.sgi.com>
References: <mailman.316.1353461777.59926.xfs@oss.sgi.com>
Date: Wed, 21 Nov 2012 07:16:43 +0100
Message-ID: <CAN-s6kuYoWB1PLyHOBnODMBmDiSVBcQy2v05-UbRwF5oZs4LFg@mail.gmail.com>
Subject: Re: xfs Digest, Vol 53, Issue 111
From: Sotirios Torentsis <torentsis@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0588943578620401956=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0588943578620401956==
Content-Type: multipart/alternative; boundary=f46d042f925266731a04cefb4b2e

--f46d042f925266731a04cefb4b2e
Content-Type: text/plain; charset=ISO-8859-1

Am 21.11.2012 02:38 schrieb <xfs-request@oss.sgi.com>:

> Send xfs mailing list submissions to
>         xfs@oss.sgi.com
>
> To subscribe or unsubscribe via the World Wide Web, visit
>         http://oss.sgi.com/mailman/listinfo/xfs
> or, via email, send a message with subject or body 'help' to
>         xfs-request@oss.sgi.com
>
> You can reach the person managing the list at
>         xfs-owner@oss.sgi.com
>
> When replying, please edit your Subject line so it is more specific
> than "Re: Contents of xfs digest..."
>
> Today's Topics:
>
>    1. [PATCH 0/2] discontiguous buffer patches (Mark Tinguely)
>    2. Re: [PATCH 0/2] xfsprogs: fixes for release candidate.
>       (Mark Tinguely)
>    3. Re: [PATCH] xfs: Don't flush inodes when project quota
>       exceeded (Jan Kara)
>    4. Re: [PATCH 2/9] ext4: honor the O_SYNC flag for aysnchronous
>       direct I/O requests (Jan Kara)
>    5. [PATCH] ext4: Reduce i_mutex usage in ext4_file_sync() (Jan Kara)
>    6. Re: [PATCH 9/9] blkdev: Fix up AIO+DIO+O_SYNC to do the sync
>       part      correctly (Jan Kara)
>    7. Re: [PATCH] xfs: Don't flush inodes when project quota
>       exceeded (Dave Chinner)
>
>
> ---------- Weitergeleitete Nachricht ----------
> From: Mark Tinguely <tinguely@sgi.com>
> To: xfs@oss.sgi.com
> Cc:
> Date: Tue, 20 Nov 2012 16:41:20 -0600
> Subject: [PATCH 0/2] discontiguous buffer patches
> Eric Sundeen's "userspace vs. fragmented multiblock dir2", xfstest 291
> commit 2a4ed, causes a xfs_buf lock hang:
>
> [<ffffffff81065d87>] down+0x47/0x50
> [<ffffffffa03a25c6>] xfs_buf_lock+0x66/0xe0 [xfs]
> [<ffffffffa03a33c9>] _xfs_buf_find+0x1f9/0x320 [xfs]
> [<ffffffffa03a393f>] xfs_buf_get_map+0x2f/0x170 [xfs]
> [<ffffffffa03a3f7a>] xfs_buf_read_map+0x2a/0x100 [xfs]
> [<ffffffffa0411630>] xfs_trans_read_buf_map+0x3b0/0x590 [xfs]
> [<ffffffffa03e1c5e>] xfs_da_read_buf+0xbe/0x230 [xfs]
> [<ffffffffa03e78dc>] xfs_dir2_block_addname+0x7c/0x980 [xfs]
> [<ffffffffa03f1468>] xfs_dir2_sf_addname+0x3e8/0x450 [xfs]
> [<ffffffffa03e634c>] xfs_dir_createname+0x17c/0x1e0 [xfs]
> [<ffffffffa03b9fe2>] xfs_create+0x4c2/0x5f0 [xfs]
> [<ffffffffa03b0c8a>] xfs_vn_mknod+0x8a/0x1a0 [xfs]
> [<ffffffffa03b0dce>] xfs_vn_create+0xe/0x10 [xfs]
> [<ffffffff8115695c>] vfs_create+0xac/0xd0
> [<ffffffff811587de>] do_last+0x8be/0x960
> [<ffffffff8115940c>] path_openat+0xdc/0x410
> [<ffffffff81159853>] do_filp_open+0x43/0xa0
> [<ffffffff8114a502>] do_sys_open+0x152/0x1e0
> [<ffffffff8114a5cc>] sys_open+0x1c/0x20
> [<ffffffff81423df9>] system_call_fastpath+0x16/0x1b
> [<ffffffffffffffff>] 0xffffffffffffffff
>
> That bisect a problem to:
>
>     commit 3605431fb9739a30ccd0c6380ae8e3c6f8e670a5
>     Author: Dave Chinner <dchinner@redhat.com>
>     Date:   Fri Jun 22 18:50:13 2012 +1000
>     xfs: use discontiguous xfs_buf support in dabuf wrappers
>
> xfs_trans_buf_item_match() is looking for the block number of the
> buffer in the single segment map area.
>
> Futhermore, there are a couple issue with multi-segment buffer log
> format.
>
> Patch 1 cleans up the buffer map so that XFS always uses b_maps[].
>
> Patch 2 fixes the buffer log format issues.
>
> --Mark.
>
>
>
>
>
> ---------- Weitergeleitete Nachricht ----------
> From: Mark Tinguely <tinguely@sgi.com>
> To: Dave Chinner <david@fromorbit.com>
> Cc: xfs@oss.sgi.com
> Date: Tue, 20 Nov 2012 17:17:36 -0600
> Subject: Re: [PATCH 0/2] xfsprogs: fixes for release candidate.
> On 11/09/12 01:02, Dave Chinner wrote:
>
>> Hi Ben,
>>
>> These are two fixes for bugs that have shown up during the -rc
>> phase of the release. Please consider them for inclusion.
>>
>> Cheers,
>>
>> Dave.
>>
>> ______________________________**_________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/**listinfo/xfs<http://oss.sgi.com/mailman/listinfo/xfs>
>>
>
> This series has been committed to git://oss.sgi.com/xfs/cmds/**xfsprogs<http://oss.sgi.com/xfs/cmds/xfsprogs>master branch, commit 1adfff, 19473a and 36298.
>
> --Mark.
>
>
>
>
> ---------- Weitergeleitete Nachricht ----------
> From: Jan Kara <jack@suse.cz>
> To: Dave Chinner <david@fromorbit.com>
> Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com
> Date: Wed, 21 Nov 2012 01:24:59 +0100
> Subject: Re: [PATCH] xfs: Don't flush inodes when project quota exceeded
> On Tue 20-11-12 11:04:28, Dave Chinner wrote:
> > On Mon, Nov 19, 2012 at 10:39:13PM +0100, Jan Kara wrote:
> > > On Tue 13-11-12 01:36:13, Jan Kara wrote:
> > > > When project quota gets exceeded xfs_iomap_write_delay() ends up
> flushing
> > > > inodes because ENOSPC gets returned from xfs_bmapi_delay() instead
> of EDQUOT.
> > > > This makes handling of writes over project quota rather slow as a
> simple test
> > > > program shows:
> > > >   fd = open(argv[1], O_WRONLY | O_CREAT | O_TRUNC, 0644);
> > > >   for (i = 0; i < 50000; i++)
> > > >           pwrite(fd, buf, 4096, i*4096);
> > > >
> > > > Writing 200 MB like this into a directory with 100 MB project quota
> takes
> > > > around 6 minutes while it takes about 2 seconds with this patch
> applied. This
> > > > actually happens in a real world load when nfs pushes data into a
> directory
> > > > which is over project quota.
> > > >
> > > > Fix the problem by replacing XFS_QMOPT_ENOSPC flag with
> XFS_QMOPT_EPDQUOT.
> > > > That makes xfs_trans_reserve_quota_bydquots() return new error
> EPDQUOT when
> > > > project quota is exceeded. xfs_bmapi_delay() then uses this flag so
> that
> > > > xfs_iomap_write_delay() can distinguish real ENOSPC (requiring
> flushing)
> > > > from exceeded project quota (not requiring flushing).
> > > >
> > > > As a side effect this patch fixes inconsistency where e.g.
> xfs_create()
> > > > returned EDQUOT even when project quota was exceeded.
> > >   Ping? Any opinions?
> >
> > FWIW, it doesn't look like it'll apply to a current XFs tree:
> >
> > > > @@ -441,8 +442,11 @@ retry:
> > > >    */
> > > >   if (nimaps == 0) {
> > > >           trace_xfs_delalloc_enospc(ip, offset, count);
> > > > -         if (flushed)
> > > > -                 return XFS_ERROR(error ? error : ENOSPC);
> > > > +         if (flushed) {
> > > > +                 if (error == 0 || error == EPDQUOT)
> > > > +                         error = ENOSPC;
> > > > +                 return XFS_ERROR(error);
> > > > +         }
> > > >
> > > >           if (error == ENOSPC) {
> > > >                   xfs_iunlock(ip, XFS_ILOCK_EXCL);
> >
> > This xfs_iomap_write_delay() looks like this now:
> >
> >         /*
> >          * If bmapi returned us nothing, we got either ENOSPC or EDQUOT.
> Retry
> >          * without EOF preallocation.
> >          */
> >         if (nimaps == 0) {
> >                 trace_xfs_delalloc_enospc(ip, offset, count);
> >                 if (prealloc) {
> >                         prealloc = 0;
> >                         error = 0;
> >                         goto retry;
> >                 }
> >                 return XFS_ERROR(error ? error : ENOSPC);
> >         }
> >
> > The flushing is now way up in xfs_file_buffered_aio_write(), and the
> > implementation of xfs_flush_inodes() has changed as well. Hence it
> > may or may not behave differently not....
>   OK, so I tested latest XFS tree and changes by commit 9aa05000 (changing
> xfs_flush_inodes()) indeed improve the performace from those ~6 minutes to
> ~6 seconds which is good enough I believe. Thanks for the pointer! I was
> thinking for a while why sync_inodes_sb() is so much faster than the
> original XFS implementation and I believe it's because we don't force the
> log on each sync now.
>
>                                                                 Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
>
>
>
> ---------- Weitergeleitete Nachricht ----------
> From: Jan Kara <jack@suse.cz>
> To: Jeff Moyer <jmoyer@redhat.com>
> Cc: axboe@kernel.dk, tytso@mit.edu, "Darrick J. Wong" <
> darrick.wong@oracle.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
> hch@infradead.org, bpm@sgi.com, viro@zeniv.linux.org.uk,
> linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
> linux-ext4@vger.kernel.org
> Date: Wed, 21 Nov 2012 01:56:26 +0100
> Subject: Re: [PATCH 2/9] ext4: honor the O_SYNC flag for aysnchronous
> direct I/O requests
> On Tue 20-11-12 15:02:15, Jeff Moyer wrote:
> > Jan Kara <jack@suse.cz> writes:
> >
> > >> @@ -1279,6 +1280,9 @@ struct ext4_sb_info {
> > >>    /* workqueue for dio unwritten */
> > >>    struct workqueue_struct *dio_unwritten_wq;
> > >>
> > >> +  /* workqueue for aio+dio+o_sync disk cache flushing */
> > >> +  struct workqueue_struct *aio_dio_flush_wq;
> > >> +
> > >   Umm, I'm not completely decided whether we really need a separate
> > > workqueue. But it doesn't cost too much so I guess it makes some sense
> -
> > > fsync() is rather heavy so syncing won't starve extent conversion...
> >
> > I'm assuming you'd like me to convert the names from flush to fsync,
> > yes?
>   Would be nicer, yes.
>
> > >> +
> > >> +  /*
> > >> +   * If we are running in nojournal mode, just flush the disk
> > >> +   * cache and return.
> > >> +   */
> > >> +  if (!journal)
> > >> +          return blkdev_issue_flush(inode->i_sb->s_bdev, GFP_NOIO,
> NULL);
> > >   And this is wrong as well - you need to do work similar to what
> > > ext4_sync_file() does. Actually it would be *much* better if these two
> > > sites used the same helper function. Which also poses an interesting
> > > question about locking - do we need i_mutex or not? Forcing a
> transaction
> > > commit is definitely OK without it, similarly as grabbing transaction
> ids
> > > from inode or ext4_should_journal_data() test. __sync_inode() call
> seems
> > > to be OK without i_mutex as well so I believe we can just get rid of it
> > > (getting i_mutex from the workqueue is a locking nightmare we don't
> want to
> > > return to).
> >
> > Just to be clear, are you saying you would like me to remove the
> > mutex_lock/unlock pair from ext4_sync_file?  (I had already factored out
> > the common code between this new code path and the fsync path in my
> tree.)
>   Yes, after some thinking I came to that conclusion. We actually need to
> keep i_mutex around ext4_flush_unwritten_io() to avoid livelocks but the
> rest doesn't need it. The change should be definitely a separate patch just
> in case there's something subtle I missed and we need to bisect in
> future... I've attached a patch for that so that blame for bugs goes my way
> ;) Compile tested only so far. I'll give it some more testing overnight.
>
>                                                                 Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
>
> ---------- Weitergeleitete Nachricht ----------
> From: Jan Kara <jack@suse.cz>
> To:
> Cc:
> Date: Wed, 21 Nov 2012 01:46:51 +0100
> Subject: [PATCH] ext4: Reduce i_mutex usage in ext4_file_sync()
> ext4_file_sync() needs i_mutex only to avoid livelocks of
> ext4_flush_unwritten_io() all other code doesn't need it. In particular
> syncing of inode & metadata in non-journal case is safe (writeback doesn't
> hold i_mutex either) and forcing of transaction commits doesn't need
> i_mutex
> either (there's nothing inode specific in that code apart from grabbing
> transaction ids from the inode). So shorten the span where i_mutex is held.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/fsync.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index be1d89f..2268114 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -113,8 +113,6 @@ static int __sync_inode(struct inode *inode, int
> datasync)
>   *
>   * What we do is just kick off a commit and wait on it.  This will
> snapshot the
>   * inode to disk.
> - *
> - * i_mutex lock is held when entering and exiting this function
>   */
>
>  int ext4_sync_file(struct file *file, loff_t start, loff_t end, int
> datasync)
> @@ -133,12 +131,13 @@ int ext4_sync_file(struct file *file, loff_t start,
> loff_t end, int datasync)
>         ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
>         if (ret)
>                 return ret;
> -       mutex_lock(&inode->i_mutex);
>
>         if (inode->i_sb->s_flags & MS_RDONLY)
>                 goto out;
>
> +       mutex_lock(&inode->i_mutex);
>         ret = ext4_flush_unwritten_io(inode);
> +       mutex_unlock(&inode->i_mutex);
>         if (ret < 0)
>                 goto out;
>
> @@ -180,7 +179,6 @@ int ext4_sync_file(struct file *file, loff_t start,
> loff_t end, int datasync)
>                         ret = err;
>         }
>   out:
> -       mutex_unlock(&inode->i_mutex);
>         trace_ext4_sync_file_exit(inode, ret);
>         return ret;
>  }
> --
> 1.7.1
>
>
> --k+w/mQv8wyuph6w0--
>
>
>
>
> ---------- Weitergeleitete Nachricht ----------
> From: Jan Kara <jack@suse.cz>
> To: Jeff Moyer <jmoyer@redhat.com>
> Cc: axboe@kernel.dk, tytso@mit.edu, "Darrick J. Wong" <
> darrick.wong@oracle.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
> hch@infradead.org, bpm@sgi.com, viro@zeniv.linux.org.uk,
> linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
> linux-ext4@vger.kernel.org
> Date: Wed, 21 Nov 2012 01:57:39 +0100
> Subject: Re: [PATCH 9/9] blkdev: Fix up AIO+DIO+O_SYNC to do the sync part
> correctly
> On Tue 20-11-12 15:47:54, Jeff Moyer wrote:
> > Jan Kara <jack@suse.cz> writes:
> >
> > > On Mon 19-11-12 23:51:15, Darrick J. Wong wrote:
> > >> When performing O_SYNC+AIO+DIO writes to block devices, use the
> DIO_SYNC_WRITES
> > >> flag so that flushes are issued /after/ the write completes, not
> before.
> > >>
> > >> Note, however, that for block devices, the DIO setup code ensures
> that a flush
> > >> wq is attached to the superblock of the bdevfs filesystem, not the
> filesystem
> > >> that the device node happens to reside in.  This means that unlike
> regular
> > >> files, iocb->ki_filp->f_mapping->host->i_sb != inode->i_sb.
>  Therefore, adjust
> > >> Jeff's earlier patch to keep the pointer use consistent and avoid a
> NULL deref.
> > >>
> > >> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > >> ---
> > >>  fs/block_dev.c |    5 +++--
> > >>  fs/direct-io.c |    3 ++-
> > >>  2 files changed, 5 insertions(+), 3 deletions(-)
> > >>
> > >>
> > >> diff --git a/fs/block_dev.c b/fs/block_dev.c
> > >> index 1a1e5e3..05ff33a 100644
> > >> --- a/fs/block_dev.c
> > >> +++ b/fs/block_dev.c
> > >> @@ -235,7 +235,8 @@ blkdev_direct_IO(int rw, struct kiocb *iocb,
> const struct iovec *iov,
> > >>    struct inode *inode = file->f_mapping->host;
> > >>
> > >>    return __blockdev_direct_IO(rw, iocb, inode, I_BDEV(inode), iov,
> offset,
> > >> -                              nr_segs, blkdev_get_blocks, NULL,
> NULL, 0);
> > >> +                              nr_segs, blkdev_get_blocks, NULL, NULL,
> > >> +                              DIO_SYNC_WRITES);
> > >>  }
> > >>
> > >>  int __sync_blockdev(struct block_device *bdev, int wait)
> > >> @@ -1631,7 +1632,7 @@ ssize_t blkdev_aio_write(struct kiocb *iocb,
> const struct iovec *iov,
> > >>    percpu_down_read(&bdev->bd_block_size_semaphore);
> > >>
> > >>    ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
> > >> -  if (ret > 0 || ret == -EIOCBQUEUED) {
> > >> +  if (ret > 0) {
> > >>            ssize_t err;
> > >>
> > >>            err = generic_write_sync(file, pos, ret);
> > >> diff --git a/fs/direct-io.c b/fs/direct-io.c
> > >> index b7391d4..c626c43 100644
> > >> --- a/fs/direct-io.c
> > >> +++ b/fs/direct-io.c
> > >> @@ -258,7 +258,8 @@ void generic_dio_end_io(struct kiocb *iocb,
> loff_t offset, ssize_t bytes,
> > >>            work->ret = ret;
> > >>            work->offset = offset;
> > >>            work->len = bytes;
> > >> -          queue_work(inode->i_sb->s_dio_flush_wq, &work->work);
> > >> +
>  queue_work(iocb->ki_filp->f_mapping->host->i_sb->s_dio_flush_wq,
> > >> +                     &work->work);
> > >   This should be folded into the original patch introducing the
> > > s_dio_flush_wq. And please add a comment before this line saying that
> block
> > > devices need a dereference exactly like this... Otherwise the patch
> looks
> > > good so you can add:
> > >   Reviewed-by: Jan Kara <jack@suse.cz>
> >
> > When you say, "This," do you mean that one change, or the whole patch?
>   I meant the whole patch after that hung is folded ;)
>
>                                                                 Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
>
>
>
> ---------- Weitergeleitete Nachricht ----------
> From: Dave Chinner <david@fromorbit.com>
> To: Jan Kara <jack@suse.cz>
> Cc: xfs@oss.sgi.com
> Date: Wed, 21 Nov 2012 12:38:21 +1100
> Subject: Re: [PATCH] xfs: Don't flush inodes when project quota exceeded
> On Wed, Nov 21, 2012 at 01:24:59AM +0100, Jan Kara wrote:
> > On Tue 20-11-12 11:04:28, Dave Chinner wrote:
> > > On Mon, Nov 19, 2012 at 10:39:13PM +0100, Jan Kara wrote:
> > > > On Tue 13-11-12 01:36:13, Jan Kara wrote:
> > > > > When project quota gets exceeded xfs_iomap_write_delay() ends up
> flushing
> > > > > inodes because ENOSPC gets returned from xfs_bmapi_delay() instead
> of EDQUOT.
> > > > > This makes handling of writes over project quota rather slow as a
> simple test
> > > > > program shows:
> > > > >         fd = open(argv[1], O_WRONLY | O_CREAT | O_TRUNC, 0644);
> > > > >         for (i = 0; i < 50000; i++)
> > > > >                 pwrite(fd, buf, 4096, i*4096);
> > > > >
> > > > > Writing 200 MB like this into a directory with 100 MB project
> quota takes
> > > > > around 6 minutes while it takes about 2 seconds with this patch
> applied. This
> > > > > actually happens in a real world load when nfs pushes data into a
> directory
> > > > > which is over project quota.
> > > > >
> > > > > Fix the problem by replacing XFS_QMOPT_ENOSPC flag with
> XFS_QMOPT_EPDQUOT.
> > > > > That makes xfs_trans_reserve_quota_bydquots() return new error
> EPDQUOT when
> > > > > project quota is exceeded. xfs_bmapi_delay() then uses this flag
> so that
> > > > > xfs_iomap_write_delay() can distinguish real ENOSPC (requiring
> flushing)
> > > > > from exceeded project quota (not requiring flushing).
> > > > >
> > > > > As a side effect this patch fixes inconsistency where e.g.
> xfs_create()
> > > > > returned EDQUOT even when project quota was exceeded.
> > > >   Ping? Any opinions?
> > >
> > > FWIW, it doesn't look like it'll apply to a current XFs tree:
> > >
> > > > > @@ -441,8 +442,11 @@ retry:
> > > > >          */
> > > > >         if (nimaps == 0) {
> > > > >                 trace_xfs_delalloc_enospc(ip, offset, count);
> > > > > -               if (flushed)
> > > > > -                       return XFS_ERROR(error ? error : ENOSPC);
> > > > > +               if (flushed) {
> > > > > +                       if (error == 0 || error == EPDQUOT)
> > > > > +                               error = ENOSPC;
> > > > > +                       return XFS_ERROR(error);
> > > > > +               }
> > > > >
> > > > >                 if (error == ENOSPC) {
> > > > >                         xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > >
> > > This xfs_iomap_write_delay() looks like this now:
> > >
> > >         /*
> > >          * If bmapi returned us nothing, we got either ENOSPC or
> EDQUOT. Retry
> > >          * without EOF preallocation.
> > >          */
> > >         if (nimaps == 0) {
> > >                 trace_xfs_delalloc_enospc(ip, offset, count);
> > >                 if (prealloc) {
> > >                         prealloc = 0;
> > >                         error = 0;
> > >                         goto retry;
> > >                 }
> > >                 return XFS_ERROR(error ? error : ENOSPC);
> > >         }
> > >
> > > The flushing is now way up in xfs_file_buffered_aio_write(), and the
> > > implementation of xfs_flush_inodes() has changed as well. Hence it
> > > may or may not behave differently not....
> >   OK, so I tested latest XFS tree and changes by commit 9aa05000
> (changing
> > xfs_flush_inodes()) indeed improve the performace from those ~6 minutes
> to
> > ~6 seconds which is good enough I believe. Thanks for the pointer! I was
> > thinking for a while why sync_inodes_sb() is so much faster than the
> > original XFS implementation and I believe it's because we don't force the
> > log on each sync now.
>
> I think it's detter because we now don't scan every inode in the
> inode cache doing a mapping_tagged(PAGECACHE_TAG_DIRTY) check to see
> if they are dirty or not to decide whether it needs writeback. The
> overhead of doing that adds up very quickly when you have lots of
> cached inodes and you are scanning them for every page that is
> written to....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>
>

--f46d042f925266731a04cefb4b2e
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote">Am 21.11.2012 02:38 schrieb  &lt;<a href=3D"mail=
to:xfs-request@oss.sgi.com">xfs-request@oss.sgi.com</a>&gt;:<br type=3D"att=
ribution"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bord=
er-left:1px #ccc solid;padding-left:1ex">
Send xfs mailing list submissions to<br>
=A0 =A0 =A0 =A0 <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
<br>
To subscribe or unsubscribe via the World Wide Web, visit<br>
=A0 =A0 =A0 =A0 <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=
=3D"_blank">http://oss.sgi.com/mailman/listinfo/xfs</a><br>
or, via email, send a message with subject or body &#39;help&#39; to<br>
=A0 =A0 =A0 =A0 <a href=3D"mailto:xfs-request@oss.sgi.com">xfs-request@oss.=
sgi.com</a><br>
<br>
You can reach the person managing the list at<br>
=A0 =A0 =A0 =A0 <a href=3D"mailto:xfs-owner@oss.sgi.com">xfs-owner@oss.sgi.=
com</a><br>
<br>
When replying, please edit your Subject line so it is more specific<br>
than &quot;Re: Contents of xfs digest...&quot;<br>
<br>Today&#39;s Topics:<br>
<br>
=A0 =A01. [PATCH 0/2] discontiguous buffer patches (Mark Tinguely)<br>
=A0 =A02. Re: [PATCH 0/2] xfsprogs: fixes for release candidate.<br>
=A0 =A0 =A0 (Mark Tinguely)<br>
=A0 =A03. Re: [PATCH] xfs: Don&#39;t flush inodes when project quota<br>
=A0 =A0 =A0 exceeded (Jan Kara)<br>
=A0 =A04. Re: [PATCH 2/9] ext4: honor the O_SYNC flag for aysnchronous<br>
=A0 =A0 =A0 direct I/O requests (Jan Kara)<br>
=A0 =A05. [PATCH] ext4: Reduce i_mutex usage in ext4_file_sync() (Jan Kara)=
<br>
=A0 =A06. Re: [PATCH 9/9] blkdev: Fix up AIO+DIO+O_SYNC to do the sync<br>
=A0 =A0 =A0 part =A0 =A0 =A0correctly (Jan Kara)<br>
=A0 =A07. Re: [PATCH] xfs: Don&#39;t flush inodes when project quota<br>
=A0 =A0 =A0 exceeded (Dave Chinner)<br>
<br><br>---------- Weitergeleitete Nachricht ----------<br>From:=A0Mark Tin=
guely &lt;<a href=3D"mailto:tinguely@sgi.com">tinguely@sgi.com</a>&gt;<br>T=
o:=A0<a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>Cc:=A0<br>Da=
te:=A0Tue, 20 Nov 2012 16:41:20 -0600<br>
Subject:=A0[PATCH 0/2] discontiguous buffer patches<br>Eric Sundeen&#39;s &=
quot;userspace vs. fragmented multiblock dir2&quot;, xfstest 291<br>
commit 2a4ed, causes a xfs_buf lock hang:<br>
<br>
[&lt;ffffffff81065d87&gt;] down+0x47/0x50<br>
[&lt;ffffffffa03a25c6&gt;] xfs_buf_lock+0x66/0xe0 [xfs]<br>
[&lt;ffffffffa03a33c9&gt;] _xfs_buf_find+0x1f9/0x320 [xfs]<br>
[&lt;ffffffffa03a393f&gt;] xfs_buf_get_map+0x2f/0x170 [xfs]<br>
[&lt;ffffffffa03a3f7a&gt;] xfs_buf_read_map+0x2a/0x100 [xfs]<br>
[&lt;ffffffffa0411630&gt;] xfs_trans_read_buf_map+0x3b0/0x590 [xfs]<br>
[&lt;ffffffffa03e1c5e&gt;] xfs_da_read_buf+0xbe/0x230 [xfs]<br>
[&lt;ffffffffa03e78dc&gt;] xfs_dir2_block_addname+0x7c/0x980 [xfs]<br>
[&lt;ffffffffa03f1468&gt;] xfs_dir2_sf_addname+0x3e8/0x450 [xfs]<br>
[&lt;ffffffffa03e634c&gt;] xfs_dir_createname+0x17c/0x1e0 [xfs]<br>
[&lt;ffffffffa03b9fe2&gt;] xfs_create+0x4c2/0x5f0 [xfs]<br>
[&lt;ffffffffa03b0c8a&gt;] xfs_vn_mknod+0x8a/0x1a0 [xfs]<br>
[&lt;ffffffffa03b0dce&gt;] xfs_vn_create+0xe/0x10 [xfs]<br>
[&lt;ffffffff8115695c&gt;] vfs_create+0xac/0xd0<br>
[&lt;ffffffff811587de&gt;] do_last+0x8be/0x960<br>
[&lt;ffffffff8115940c&gt;] path_openat+0xdc/0x410<br>
[&lt;ffffffff81159853&gt;] do_filp_open+0x43/0xa0<br>
[&lt;ffffffff8114a502&gt;] do_sys_open+0x152/0x1e0<br>
[&lt;ffffffff8114a5cc&gt;] sys_open+0x1c/0x20<br>
[&lt;ffffffff81423df9&gt;] system_call_fastpath+0x16/0x1b<br>
[&lt;ffffffffffffffff&gt;] 0xffffffffffffffff<br>
<br>
That bisect a problem to:<br>
<br>
=A0 =A0 commit 3605431fb9739a30ccd0c6380ae8e3c6f8e670a5<br>
=A0 =A0 Author: Dave Chinner &lt;<a href=3D"mailto:dchinner@redhat.com">dch=
inner@redhat.com</a>&gt;<br>
=A0 =A0 Date: =A0 Fri Jun 22 18:50:13 2012 +1000<br>
=A0 =A0 xfs: use discontiguous xfs_buf support in dabuf wrappers<br>
<br>
xfs_trans_buf_item_match() is looking for the block number of the<br>
buffer in the single segment map area.<br>
<br>
Futhermore, there are a couple issue with multi-segment buffer log<br>
format.<br>
<br>
Patch 1 cleans up the buffer map so that XFS always uses b_maps[].<br>
<br>
Patch 2 fixes the buffer log format issues.<br>
<br>
--Mark.<br>
<br>
<br>
<br>
<br><br>---------- Weitergeleitete Nachricht ----------<br>From:=A0Mark Tin=
guely &lt;<a href=3D"mailto:tinguely@sgi.com">tinguely@sgi.com</a>&gt;<br>T=
o:=A0Dave Chinner &lt;<a href=3D"mailto:david@fromorbit.com">david@fromorbi=
t.com</a>&gt;<br>
Cc:=A0<a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>Date:=A0Tue=
, 20 Nov 2012 17:17:36 -0600<br>Subject:=A0Re: [PATCH 0/2] xfsprogs: fixes =
for release candidate.<br>On 11/09/12 01:02, Dave Chinner wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Hi Ben,<br>
<br>
These are two fixes for bugs that have shown up during the -rc<br>
phase of the release. Please consider them for inclusion.<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<br>
______________________________<u></u>_________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com" target=3D"_blank">xfs@oss.sgi.com</a><br=
>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">http:=
//oss.sgi.com/mailman/<u></u>listinfo/xfs</a><br>
</blockquote>
<br>
This series has been committed to git://<a href=3D"http://oss.sgi.com/xfs/c=
mds/xfsprogs" target=3D"_blank">oss.sgi.com/xfs/cmds/<u></u>xfsprogs</a> ma=
ster branch, commit 1adfff, 19473a and 36298.<br>
<br>
--Mark.<br>
<br>
<br>
<br><br>---------- Weitergeleitete Nachricht ----------<br>From:=A0Jan Kara=
 &lt;<a href=3D"mailto:jack@suse.cz">jack@suse.cz</a>&gt;<br>To:=A0Dave Chi=
nner &lt;<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a>&gt;=
<br>
Cc:=A0Jan Kara &lt;<a href=3D"mailto:jack@suse.cz">jack@suse.cz</a>&gt;, <a=
 href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>Date:=A0Wed, 21 Nov=
 2012 01:24:59 +0100<br>Subject:=A0Re: [PATCH] xfs: Don&#39;t flush inodes =
when project quota exceeded<br>
On Tue 20-11-12 11:04:28, Dave Chinner wrote:<br>
&gt; On Mon, Nov 19, 2012 at 10:39:13PM +0100, Jan Kara wrote:<br>
&gt; &gt; On Tue 13-11-12 01:36:13, Jan Kara wrote:<br>
&gt; &gt; &gt; When project quota gets exceeded xfs_iomap_write_delay() end=
s up flushing<br>
&gt; &gt; &gt; inodes because ENOSPC gets returned from xfs_bmapi_delay() i=
nstead of EDQUOT.<br>
&gt; &gt; &gt; This makes handling of writes over project quota rather slow=
 as a simple test<br>
&gt; &gt; &gt; program shows:<br>
&gt; &gt; &gt; =A0 fd =3D open(argv[1], O_WRONLY | O_CREAT | O_TRUNC, 0644)=
;<br>
&gt; &gt; &gt; =A0 for (i =3D 0; i &lt; 50000; i++)<br>
&gt; &gt; &gt; =A0 =A0 =A0 =A0 =A0 pwrite(fd, buf, 4096, i*4096);<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Writing 200 MB like this into a directory with 100 MB projec=
t quota takes<br>
&gt; &gt; &gt; around 6 minutes while it takes about 2 seconds with this pa=
tch applied. This<br>
&gt; &gt; &gt; actually happens in a real world load when nfs pushes data i=
nto a directory<br>
&gt; &gt; &gt; which is over project quota.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Fix the problem by replacing XFS_QMOPT_ENOSPC flag with XFS_=
QMOPT_EPDQUOT.<br>
&gt; &gt; &gt; That makes xfs_trans_reserve_quota_bydquots() return new err=
or EPDQUOT when<br>
&gt; &gt; &gt; project quota is exceeded. xfs_bmapi_delay() then uses this =
flag so that<br>
&gt; &gt; &gt; xfs_iomap_write_delay() can distinguish real ENOSPC (requiri=
ng flushing)<br>
&gt; &gt; &gt; from exceeded project quota (not requiring flushing).<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; As a side effect this patch fixes inconsistency where e.g. x=
fs_create()<br>
&gt; &gt; &gt; returned EDQUOT even when project quota was exceeded.<br>
&gt; &gt; =A0 Ping? Any opinions?<br>
&gt;<br>
&gt; FWIW, it doesn&#39;t look like it&#39;ll apply to a current XFs tree:<=
br>
&gt;<br>
&gt; &gt; &gt; @@ -441,8 +442,11 @@ retry:<br>
&gt; &gt; &gt; =A0 =A0*/<br>
&gt; &gt; &gt; =A0 if (nimaps =3D=3D 0) {<br>
&gt; &gt; &gt; =A0 =A0 =A0 =A0 =A0 trace_xfs_delalloc_enospc(ip, offset, co=
unt);<br>
&gt; &gt; &gt; - =A0 =A0 =A0 =A0 if (flushed)<br>
&gt; &gt; &gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return XFS_ERROR(error ? e=
rror : ENOSPC);<br>
&gt; &gt; &gt; + =A0 =A0 =A0 =A0 if (flushed) {<br>
&gt; &gt; &gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (error =3D=3D 0 || erro=
r =3D=3D EPDQUOT)<br>
&gt; &gt; &gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D =
ENOSPC;<br>
&gt; &gt; &gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return XFS_ERROR(error);<b=
r>
&gt; &gt; &gt; + =A0 =A0 =A0 =A0 }<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; =A0 =A0 =A0 =A0 =A0 if (error =3D=3D ENOSPC) {<br>
&gt; &gt; &gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_iunlock(ip, XFS_ILOC=
K_EXCL);<br>
&gt;<br>
&gt; This xfs_iomap_write_delay() looks like this now:<br>
&gt;<br>
&gt; =A0 =A0 =A0 =A0 /*<br>
&gt; =A0 =A0 =A0 =A0 =A0* If bmapi returned us nothing, we got either ENOSP=
C or EDQUOT. Retry<br>
&gt; =A0 =A0 =A0 =A0 =A0* without EOF preallocation.<br>
&gt; =A0 =A0 =A0 =A0 =A0*/<br>
&gt; =A0 =A0 =A0 =A0 if (nimaps =3D=3D 0) {<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 trace_xfs_delalloc_enospc(ip, offset, =
count);<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (prealloc) {<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 prealloc =3D 0;<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D 0;<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto retry;<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return XFS_ERROR(error ? error : ENOSP=
C);<br>
&gt; =A0 =A0 =A0 =A0 }<br>
&gt;<br>
&gt; The flushing is now way up in xfs_file_buffered_aio_write(), and the<b=
r>
&gt; implementation of xfs_flush_inodes() has changed as well. Hence it<br>
&gt; may or may not behave differently not....<br>
=A0 OK, so I tested latest XFS tree and changes by commit 9aa05000 (changin=
g<br>
xfs_flush_inodes()) indeed improve the performace from those ~6 minutes to<=
br>
~6 seconds which is good enough I believe. Thanks for the pointer! I was<br=
>
thinking for a while why sync_inodes_sb() is so much faster than the<br>
original XFS implementation and I believe it&#39;s because we don&#39;t for=
ce the<br>
log on each sync now.<br>
<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Honza<br>
--<br>
Jan Kara &lt;<a href=3D"mailto:jack@suse.cz">jack@suse.cz</a>&gt;<br>
SUSE Labs, CR<br>
<br>
<br>
<br><br>---------- Weitergeleitete Nachricht ----------<br>From:=A0Jan Kara=
 &lt;<a href=3D"mailto:jack@suse.cz">jack@suse.cz</a>&gt;<br>To:=A0Jeff Moy=
er &lt;<a href=3D"mailto:jmoyer@redhat.com">jmoyer@redhat.com</a>&gt;<br>Cc=
:=A0<a href=3D"mailto:axboe@kernel.dk">axboe@kernel.dk</a>, <a href=3D"mail=
to:tytso@mit.edu">tytso@mit.edu</a>, &quot;Darrick J. Wong&quot; &lt;<a hre=
f=3D"mailto:darrick.wong@oracle.com">darrick.wong@oracle.com</a>&gt;, <a hr=
ef=3D"mailto:linux-kernel@vger.kernel.org">linux-kernel@vger.kernel.org</a>=
, <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a>, <a href=3D"mailto=
:hch@infradead.org">hch@infradead.org</a>, <a href=3D"mailto:bpm@sgi.com">b=
pm@sgi.com</a>, <a href=3D"mailto:viro@zeniv.linux.org.uk">viro@zeniv.linux=
.org.uk</a>, <a href=3D"mailto:linux-fsdevel@vger.kernel.org">linux-fsdevel=
@vger.kernel.org</a>, Jan Kara &lt;<a href=3D"mailto:jack@suse.cz">jack@sus=
e.cz</a>&gt;, <a href=3D"mailto:linux-ext4@vger.kernel.org">linux-ext4@vger=
.kernel.org</a><br>
Date:=A0Wed, 21 Nov 2012 01:56:26 +0100<br>Subject:=A0Re: [PATCH 2/9] ext4:=
 honor the O_SYNC flag for aysnchronous direct I/O requests<br>On Tue 20-11=
-12 15:02:15, Jeff Moyer wrote:<br>
&gt; Jan Kara &lt;<a href=3D"mailto:jack@suse.cz">jack@suse.cz</a>&gt; writ=
es:<br>
&gt;<br>
&gt; &gt;&gt; @@ -1279,6 +1280,9 @@ struct ext4_sb_info {<br>
&gt; &gt;&gt; =A0 =A0/* workqueue for dio unwritten */<br>
&gt; &gt;&gt; =A0 =A0struct workqueue_struct *dio_unwritten_wq;<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; + =A0/* workqueue for aio+dio+o_sync disk cache flushing */<b=
r>
&gt; &gt;&gt; + =A0struct workqueue_struct *aio_dio_flush_wq;<br>
&gt; &gt;&gt; +<br>
&gt; &gt; =A0 Umm, I&#39;m not completely decided whether we really need a =
separate<br>
&gt; &gt; workqueue. But it doesn&#39;t cost too much so I guess it makes s=
ome sense -<br>
&gt; &gt; fsync() is rather heavy so syncing won&#39;t starve extent conver=
sion...<br>
&gt;<br>
&gt; I&#39;m assuming you&#39;d like me to convert the names from flush to =
fsync,<br>
&gt; yes?<br>
=A0 Would be nicer, yes.<br>
<br>
&gt; &gt;&gt; +<br>
&gt; &gt;&gt; + =A0/*<br>
&gt; &gt;&gt; + =A0 * If we are running in nojournal mode, just flush the d=
isk<br>
&gt; &gt;&gt; + =A0 * cache and return.<br>
&gt; &gt;&gt; + =A0 */<br>
&gt; &gt;&gt; + =A0if (!journal)<br>
&gt; &gt;&gt; + =A0 =A0 =A0 =A0 =A0return blkdev_issue_flush(inode-&gt;i_sb=
-&gt;s_bdev, GFP_NOIO, NULL);<br>
&gt; &gt; =A0 And this is wrong as well - you need to do work similar to wh=
at<br>
&gt; &gt; ext4_sync_file() does. Actually it would be *much* better if thes=
e two<br>
&gt; &gt; sites used the same helper function. Which also poses an interest=
ing<br>
&gt; &gt; question about locking - do we need i_mutex or not? Forcing a tra=
nsaction<br>
&gt; &gt; commit is definitely OK without it, similarly as grabbing transac=
tion ids<br>
&gt; &gt; from inode or ext4_should_journal_data() test. __sync_inode() cal=
l seems<br>
&gt; &gt; to be OK without i_mutex as well so I believe we can just get rid=
 of it<br>
&gt; &gt; (getting i_mutex from the workqueue is a locking nightmare we don=
&#39;t want to<br>
&gt; &gt; return to).<br>
&gt;<br>
&gt; Just to be clear, are you saying you would like me to remove the<br>
&gt; mutex_lock/unlock pair from ext4_sync_file? =A0(I had already factored=
 out<br>
&gt; the common code between this new code path and the fsync path in my tr=
ee.)<br>
=A0 Yes, after some thinking I came to that conclusion. We actually need to=
<br>
keep i_mutex around ext4_flush_unwritten_io() to avoid livelocks but the<br=
>
rest doesn&#39;t need it. The change should be definitely a separate patch =
just<br>
in case there&#39;s something subtle I missed and we need to bisect in<br>
future... I&#39;ve attached a patch for that so that blame for bugs goes my=
 way<br>
;) Compile tested only so far. I&#39;ll give it some more testing overnight=
.<br>
<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Honza<br>
--<br>
Jan Kara &lt;<a href=3D"mailto:jack@suse.cz">jack@suse.cz</a>&gt;<br>
SUSE Labs, CR<br>
<br><br>---------- Weitergeleitete Nachricht ----------<br>From:=A0Jan Kara=
 &lt;<a href=3D"mailto:jack@suse.cz">jack@suse.cz</a>&gt;<br>To:=A0<br>Cc:=
=A0<br>Date:=A0Wed, 21 Nov 2012 01:46:51 +0100<br>Subject:=A0[PATCH] ext4: =
Reduce i_mutex usage in ext4_file_sync()<br>
ext4_file_sync() needs i_mutex only to avoid livelocks of<br>
ext4_flush_unwritten_io() all other code doesn&#39;t need it. In particular=
<br>
syncing of inode &amp; metadata in non-journal case is safe (writeback does=
n&#39;t<br>
hold i_mutex either) and forcing of transaction commits doesn&#39;t need i_=
mutex<br>
either (there&#39;s nothing inode specific in that code apart from grabbing=
<br>
transaction ids from the inode). So shorten the span where i_mutex is held.=
<br>
<br>
Signed-off-by: Jan Kara &lt;<a href=3D"mailto:jack@suse.cz">jack@suse.cz</a=
>&gt;<br>
---<br>
=A0fs/ext4/fsync.c | =A0 =A06 ++----<br>
=A01 files changed, 2 insertions(+), 4 deletions(-)<br>
<br>
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c<br>
index be1d89f..2268114 100644<br>
--- a/fs/ext4/fsync.c<br>
+++ b/fs/ext4/fsync.c<br>
@@ -113,8 +113,6 @@ static int __sync_inode(struct inode *inode, int datasy=
nc)<br>
=A0 *<br>
=A0 * What we do is just kick off a commit and wait on it. =A0This will sna=
pshot the<br>
=A0 * inode to disk.<br>
- *<br>
- * i_mutex lock is held when entering and exiting this function<br>
=A0 */<br>
<br>
=A0int ext4_sync_file(struct file *file, loff_t start, loff_t end, int data=
sync)<br>
@@ -133,12 +131,13 @@ int ext4_sync_file(struct file *file, loff_t start, l=
off_t end, int datasync)<br>
=A0 =A0 =A0 =A0 ret =3D filemap_write_and_wait_range(inode-&gt;i_mapping, s=
tart, end);<br>
=A0 =A0 =A0 =A0 if (ret)<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;<br>
- =A0 =A0 =A0 mutex_lock(&amp;inode-&gt;i_mutex);<br>
<br>
=A0 =A0 =A0 =A0 if (inode-&gt;i_sb-&gt;s_flags &amp; MS_RDONLY)<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;<br>
<br>
+ =A0 =A0 =A0 mutex_lock(&amp;inode-&gt;i_mutex);<br>
=A0 =A0 =A0 =A0 ret =3D ext4_flush_unwritten_io(inode);<br>
+ =A0 =A0 =A0 mutex_unlock(&amp;inode-&gt;i_mutex);<br>
=A0 =A0 =A0 =A0 if (ret &lt; 0)<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;<br>
<br>
@@ -180,7 +179,6 @@ int ext4_sync_file(struct file *file, loff_t start, lof=
f_t end, int datasync)<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D err;<br>
=A0 =A0 =A0 =A0 }<br>
=A0 out:<br>
- =A0 =A0 =A0 mutex_unlock(&amp;inode-&gt;i_mutex);<br>
=A0 =A0 =A0 =A0 trace_ext4_sync_file_exit(inode, ret);<br>
=A0 =A0 =A0 =A0 return ret;<br>
=A0}<br>
--<br>
1.7.1<br>
<br>
<br>
--k+w/mQv8wyuph6w0--<br>
<br>
<br>
<br><br>---------- Weitergeleitete Nachricht ----------<br>From:=A0Jan Kara=
 &lt;<a href=3D"mailto:jack@suse.cz">jack@suse.cz</a>&gt;<br>To:=A0Jeff Moy=
er &lt;<a href=3D"mailto:jmoyer@redhat.com">jmoyer@redhat.com</a>&gt;<br>Cc=
:=A0<a href=3D"mailto:axboe@kernel.dk">axboe@kernel.dk</a>, <a href=3D"mail=
to:tytso@mit.edu">tytso@mit.edu</a>, &quot;Darrick J. Wong&quot; &lt;<a hre=
f=3D"mailto:darrick.wong@oracle.com">darrick.wong@oracle.com</a>&gt;, <a hr=
ef=3D"mailto:linux-kernel@vger.kernel.org">linux-kernel@vger.kernel.org</a>=
, <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a>, <a href=3D"mailto=
:hch@infradead.org">hch@infradead.org</a>, <a href=3D"mailto:bpm@sgi.com">b=
pm@sgi.com</a>, <a href=3D"mailto:viro@zeniv.linux.org.uk">viro@zeniv.linux=
.org.uk</a>, <a href=3D"mailto:linux-fsdevel@vger.kernel.org">linux-fsdevel=
@vger.kernel.org</a>, Jan Kara &lt;<a href=3D"mailto:jack@suse.cz">jack@sus=
e.cz</a>&gt;, <a href=3D"mailto:linux-ext4@vger.kernel.org">linux-ext4@vger=
.kernel.org</a><br>
Date:=A0Wed, 21 Nov 2012 01:57:39 +0100<br>Subject:=A0Re: [PATCH 9/9] blkde=
v: Fix up AIO+DIO+O_SYNC to do the sync part correctly<br>On Tue 20-11-12 1=
5:47:54, Jeff Moyer wrote:<br>
&gt; Jan Kara &lt;<a href=3D"mailto:jack@suse.cz">jack@suse.cz</a>&gt; writ=
es:<br>
&gt;<br>
&gt; &gt; On Mon 19-11-12 23:51:15, Darrick J. Wong wrote:<br>
&gt; &gt;&gt; When performing O_SYNC+AIO+DIO writes to block devices, use t=
he DIO_SYNC_WRITES<br>
&gt; &gt;&gt; flag so that flushes are issued /after/ the write completes, =
not before.<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; Note, however, that for block devices, the DIO setup code ens=
ures that a flush<br>
&gt; &gt;&gt; wq is attached to the superblock of the bdevfs filesystem, no=
t the filesystem<br>
&gt; &gt;&gt; that the device node happens to reside in. =A0This means that=
 unlike regular<br>
&gt; &gt;&gt; files, iocb-&gt;ki_filp-&gt;f_mapping-&gt;host-&gt;i_sb !=3D =
inode-&gt;i_sb. =A0Therefore, adjust<br>
&gt; &gt;&gt; Jeff&#39;s earlier patch to keep the pointer use consistent a=
nd avoid a NULL deref.<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; Signed-off-by: Darrick J. Wong &lt;<a href=3D"mailto:darrick.=
wong@oracle.com">darrick.wong@oracle.com</a>&gt;<br>
&gt; &gt;&gt; ---<br>
&gt; &gt;&gt; =A0fs/block_dev.c | =A0 =A05 +++--<br>
&gt; &gt;&gt; =A0fs/direct-io.c | =A0 =A03 ++-<br>
&gt; &gt;&gt; =A02 files changed, 5 insertions(+), 3 deletions(-)<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; diff --git a/fs/block_dev.c b/fs/block_dev.c<br>
&gt; &gt;&gt; index 1a1e5e3..05ff33a 100644<br>
&gt; &gt;&gt; --- a/fs/block_dev.c<br>
&gt; &gt;&gt; +++ b/fs/block_dev.c<br>
&gt; &gt;&gt; @@ -235,7 +235,8 @@ blkdev_direct_IO(int rw, struct kiocb *io=
cb, const struct iovec *iov,<br>
&gt; &gt;&gt; =A0 =A0struct inode *inode =3D file-&gt;f_mapping-&gt;host;<b=
r>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; =A0 =A0return __blockdev_direct_IO(rw, iocb, inode, I_BDEV(in=
ode), iov, offset,<br>
&gt; &gt;&gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
nr_segs, blkdev_get_blocks, NULL, NULL, 0);<br>
&gt; &gt;&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
nr_segs, blkdev_get_blocks, NULL, NULL,<br>
&gt; &gt;&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
DIO_SYNC_WRITES);<br>
&gt; &gt;&gt; =A0}<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; =A0int __sync_blockdev(struct block_device *bdev, int wait)<b=
r>
&gt; &gt;&gt; @@ -1631,7 +1632,7 @@ ssize_t blkdev_aio_write(struct kiocb *=
iocb, const struct iovec *iov,<br>
&gt; &gt;&gt; =A0 =A0percpu_down_read(&amp;bdev-&gt;bd_block_size_semaphore=
);<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; =A0 =A0ret =3D __generic_file_aio_write(iocb, iov, nr_segs, &=
amp;iocb-&gt;ki_pos);<br>
&gt; &gt;&gt; - =A0if (ret &gt; 0 || ret =3D=3D -EIOCBQUEUED) {<br>
&gt; &gt;&gt; + =A0if (ret &gt; 0) {<br>
&gt; &gt;&gt; =A0 =A0 =A0 =A0 =A0 =A0ssize_t err;<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; =A0 =A0 =A0 =A0 =A0 =A0err =3D generic_write_sync(file, pos, =
ret);<br>
&gt; &gt;&gt; diff --git a/fs/direct-io.c b/fs/direct-io.c<br>
&gt; &gt;&gt; index b7391d4..c626c43 100644<br>
&gt; &gt;&gt; --- a/fs/direct-io.c<br>
&gt; &gt;&gt; +++ b/fs/direct-io.c<br>
&gt; &gt;&gt; @@ -258,7 +258,8 @@ void generic_dio_end_io(struct kiocb *ioc=
b, loff_t offset, ssize_t bytes,<br>
&gt; &gt;&gt; =A0 =A0 =A0 =A0 =A0 =A0work-&gt;ret =3D ret;<br>
&gt; &gt;&gt; =A0 =A0 =A0 =A0 =A0 =A0work-&gt;offset =3D offset;<br>
&gt; &gt;&gt; =A0 =A0 =A0 =A0 =A0 =A0work-&gt;len =3D bytes;<br>
&gt; &gt;&gt; - =A0 =A0 =A0 =A0 =A0queue_work(inode-&gt;i_sb-&gt;s_dio_flus=
h_wq, &amp;work-&gt;work);<br>
&gt; &gt;&gt; + =A0 =A0 =A0 =A0 =A0queue_work(iocb-&gt;ki_filp-&gt;f_mappin=
g-&gt;host-&gt;i_sb-&gt;s_dio_flush_wq,<br>
&gt; &gt;&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &amp;work-&gt;work)=
;<br>
&gt; &gt; =A0 This should be folded into the original patch introducing the=
<br>
&gt; &gt; s_dio_flush_wq. And please add a comment before this line saying =
that block<br>
&gt; &gt; devices need a dereference exactly like this... Otherwise the pat=
ch looks<br>
&gt; &gt; good so you can add:<br>
&gt; &gt; =A0 Reviewed-by: Jan Kara &lt;<a href=3D"mailto:jack@suse.cz">jac=
k@suse.cz</a>&gt;<br>
&gt;<br>
&gt; When you say, &quot;This,&quot; do you mean that one change, or the wh=
ole patch?<br>
=A0 I meant the whole patch after that hung is folded ;)<br>
<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Honza<br>
--<br>
Jan Kara &lt;<a href=3D"mailto:jack@suse.cz">jack@suse.cz</a>&gt;<br>
SUSE Labs, CR<br>
<br>
<br>
<br><br>---------- Weitergeleitete Nachricht ----------<br>From:=A0Dave Chi=
nner &lt;<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a>&gt;=
<br>To:=A0Jan Kara &lt;<a href=3D"mailto:jack@suse.cz">jack@suse.cz</a>&gt;=
<br>
Cc:=A0<a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>Date:=A0Wed=
, 21 Nov 2012 12:38:21 +1100<br>Subject:=A0Re: [PATCH] xfs: Don&#39;t flush=
 inodes when project quota exceeded<br>On Wed, Nov 21, 2012 at 01:24:59AM +=
0100, Jan Kara wrote:<br>

&gt; On Tue 20-11-12 11:04:28, Dave Chinner wrote:<br>
&gt; &gt; On Mon, Nov 19, 2012 at 10:39:13PM +0100, Jan Kara wrote:<br>
&gt; &gt; &gt; On Tue 13-11-12 01:36:13, Jan Kara wrote:<br>
&gt; &gt; &gt; &gt; When project quota gets exceeded xfs_iomap_write_delay(=
) ends up flushing<br>
&gt; &gt; &gt; &gt; inodes because ENOSPC gets returned from xfs_bmapi_dela=
y() instead of EDQUOT.<br>
&gt; &gt; &gt; &gt; This makes handling of writes over project quota rather=
 slow as a simple test<br>
&gt; &gt; &gt; &gt; program shows:<br>
&gt; &gt; &gt; &gt; =A0 =A0 =A0 =A0 fd =3D open(argv[1], O_WRONLY | O_CREAT=
 | O_TRUNC, 0644);<br>
&gt; &gt; &gt; &gt; =A0 =A0 =A0 =A0 for (i =3D 0; i &lt; 50000; i++)<br>
&gt; &gt; &gt; &gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pwrite(fd, buf, 4096, i=
*4096);<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; Writing 200 MB like this into a directory with 100 MB p=
roject quota takes<br>
&gt; &gt; &gt; &gt; around 6 minutes while it takes about 2 seconds with th=
is patch applied. This<br>
&gt; &gt; &gt; &gt; actually happens in a real world load when nfs pushes d=
ata into a directory<br>
&gt; &gt; &gt; &gt; which is over project quota.<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; Fix the problem by replacing XFS_QMOPT_ENOSPC flag with=
 XFS_QMOPT_EPDQUOT.<br>
&gt; &gt; &gt; &gt; That makes xfs_trans_reserve_quota_bydquots() return ne=
w error EPDQUOT when<br>
&gt; &gt; &gt; &gt; project quota is exceeded. xfs_bmapi_delay() then uses =
this flag so that<br>
&gt; &gt; &gt; &gt; xfs_iomap_write_delay() can distinguish real ENOSPC (re=
quiring flushing)<br>
&gt; &gt; &gt; &gt; from exceeded project quota (not requiring flushing).<b=
r>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; As a side effect this patch fixes inconsistency where e=
.g. xfs_create()<br>
&gt; &gt; &gt; &gt; returned EDQUOT even when project quota was exceeded.<b=
r>
&gt; &gt; &gt; =A0 Ping? Any opinions?<br>
&gt; &gt;<br>
&gt; &gt; FWIW, it doesn&#39;t look like it&#39;ll apply to a current XFs t=
ree:<br>
&gt; &gt;<br>
&gt; &gt; &gt; &gt; @@ -441,8 +442,11 @@ retry:<br>
&gt; &gt; &gt; &gt; =A0 =A0 =A0 =A0 =A0*/<br>
&gt; &gt; &gt; &gt; =A0 =A0 =A0 =A0 if (nimaps =3D=3D 0) {<br>
&gt; &gt; &gt; &gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 trace_xfs_delalloc_enos=
pc(ip, offset, count);<br>
&gt; &gt; &gt; &gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (flushed)<br>
&gt; &gt; &gt; &gt; - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return XF=
S_ERROR(error ? error : ENOSPC);<br>
&gt; &gt; &gt; &gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (flushed) {<br>
&gt; &gt; &gt; &gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (error=
 =3D=3D 0 || error =3D=3D EPDQUOT)<br>
&gt; &gt; &gt; &gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 error =3D ENOSPC;<br>
&gt; &gt; &gt; &gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return XF=
S_ERROR(error);<br>
&gt; &gt; &gt; &gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (error =3D=3D ENOSPC=
) {<br>
&gt; &gt; &gt; &gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_iun=
lock(ip, XFS_ILOCK_EXCL);<br>
&gt; &gt;<br>
&gt; &gt; This xfs_iomap_write_delay() looks like this now:<br>
&gt; &gt;<br>
&gt; &gt; =A0 =A0 =A0 =A0 /*<br>
&gt; &gt; =A0 =A0 =A0 =A0 =A0* If bmapi returned us nothing, we got either =
ENOSPC or EDQUOT. Retry<br>
&gt; &gt; =A0 =A0 =A0 =A0 =A0* without EOF preallocation.<br>
&gt; &gt; =A0 =A0 =A0 =A0 =A0*/<br>
&gt; &gt; =A0 =A0 =A0 =A0 if (nimaps =3D=3D 0) {<br>
&gt; &gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 trace_xfs_delalloc_enospc(ip, off=
set, count);<br>
&gt; &gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (prealloc) {<br>
&gt; &gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 prealloc =3D 0;<b=
r>
&gt; &gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D 0;<br>
&gt; &gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto retry;<br>
&gt; &gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>
&gt; &gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return XFS_ERROR(error ? error : =
ENOSPC);<br>
&gt; &gt; =A0 =A0 =A0 =A0 }<br>
&gt; &gt;<br>
&gt; &gt; The flushing is now way up in xfs_file_buffered_aio_write(), and =
the<br>
&gt; &gt; implementation of xfs_flush_inodes() has changed as well. Hence i=
t<br>
&gt; &gt; may or may not behave differently not....<br>
&gt; =A0 OK, so I tested latest XFS tree and changes by commit 9aa05000 (ch=
anging<br>
&gt; xfs_flush_inodes()) indeed improve the performace from those ~6 minute=
s to<br>
&gt; ~6 seconds which is good enough I believe. Thanks for the pointer! I w=
as<br>
&gt; thinking for a while why sync_inodes_sb() is so much faster than the<b=
r>
&gt; original XFS implementation and I believe it&#39;s because we don&#39;=
t force the<br>
&gt; log on each sync now.<br>
<br>
I think it&#39;s detter because we now don&#39;t scan every inode in the<br=
>
inode cache doing a mapping_tagged(PAGECACHE_TAG_DIRTY) check to see<br>
if they are dirty or not to decide whether it needs writeback. The<br>
overhead of doing that adds up very quickly when you have lots of<br>
cached inodes and you are scanning them for every page that is<br>
written to....<br>
<br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
<br>
<br>
<br>_______________________________________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">http:=
//oss.sgi.com/mailman/listinfo/xfs</a><br>
<br></blockquote></div>

--f46d042f925266731a04cefb4b2e--


--===============0588943578620401956==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0588943578620401956==--
