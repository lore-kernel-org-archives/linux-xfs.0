Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1969QAr142962 for <xfs@oss.sgi.com>; Thu, 9 Feb 2012 00:09:26 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Y584OxcsSloDGBEo for <xfs@oss.sgi.com>;
	Wed, 08 Feb 2012 22:09:23 -0800 (PST)
Date: Thu, 9 Feb 2012 17:09:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: concurrent direct IO write in xfs
Message-ID: <20120209060920.GF7479@dastard>
References: <CAFLer83FBZG9ZCrT2jUZBcTC2a2tx_CDmykyPF4cTP0dbHGw7Q@mail.gmail.com>
	<20120116232549.GC6922@dastard>
	<CAFLer81XkMTh_gxd95pzxCEs1yGRsTrZijX3c7ewgRzeA7DCSQ@mail.gmail.com>
	<20120123051155.GI15102@dastard>
	<CAFLer82QxfgXEx7ofzOHOK2YKiA+ab+_Aizd10SWHvnC-mVUHg@mail.gmail.com>
	<CAFLer81GWSCCCMppU=2dE+5KKqD-hYVKAA0hz9n-CBbxAs_xfw@mail.gmail.com>
	<20120124035431.GD6922@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120124035431.GD6922@dastard>
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
To: Zheng Da <zhengda1936@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 24, 2012 at 02:54:31PM +1100, Dave Chinner wrote:
> On Mon, Jan 23, 2012 at 03:51:43PM -0500, Zheng Da wrote:
> > Hello
> > 
> > On Mon, Jan 23, 2012 at 2:34 PM, Zheng Da <zhengda1936@gmail.com> wrote:
> > >> > So the test case is pretty simple and I think it's easy to reproduce it.
> > >> > It'll be great if you can try the test case.
> > >>
> > >> Can you post your test code so I know what I test is exactly what
> > >> you are running?
> > >>
> > > I can do that. My test code gets very complicated now. I need to simplify
> > > it.
> > >
> > Here is the code. It's still a bit long. I hope it's OK.
> > You can run the code like "rand-read file option=direct pages=1048576
> > threads=8 access=write/read".
> 
> With 262144 pages on a 2Gb ramdisk, the results I get on 3.2.0 are
> 
> Threads		Read	Write
>     1		0.92s	1.49s
>     2		0.51s	1.20s
>     4		0.31s	1.34s
>     8		0.22s	1.59s
>    16		0.23s	2.24s
> 
> the contention is on the ip->i_ilock, and the newsize update is one
> of the offenders It probably needs this change to
> xfs_aio_write_newsize_update():
> 
> -        if (new_size == ip->i_new_size) {
> +        if (new_size && new_size == ip->i_new_size) {
> 
> to avoid the lock being taken here.
> 
> But all that newsize crap is gone in the current git Linus tree,
> so how much would that gains us:
> 
> Threads		Read	Write
>     1		0.88s	0.85s
>     2		0.54s	1.20s
>     4		0.31s	1.23s
>     8		0.27s	1.40s
>    16		0.25s	2.36s
> 
> Pretty much nothing. IOWs, it's just like I suspected - you are
> doing so many write IOs that you are serialising on the extent
> lookup and write checks which use exclusive locking..
> 
> Given that it is 2 lock traversals per write IO, we're limiting at
> about 4-500,000 exclusive lock grabs per second and decreasing as
> contention goes up.
> 
> For reads, we are doing 2 shared (nested) lookups per read IO, we
> appear to be limiting at around 2,000,000 shared lock grabs per
> second. Ahmdals law is kicking in here, but it means if we could
> make the writes to use a shared lock, it would at least scale like
> the reads for this "no metadata modification except for mtime"
> overwrite case.
> 
> I don't think that the generic write checks absolutely need
> exclusive locking - we probably could get away with a shared lock
> and only fall back to exclusive when we need to do EOF zeroing.
> Similarly, for the block mapping code if we don't need to do
> allocation, a shared lock is all we need. So maybe in that case for
> direct IO when create == 1, we can do a read lookup first and only
> grab the lock exclusively if that falls in a hole and requires
> allocation.....

So, I have a proof of concept patch that gets rid of the exclusive
locking for the overwrite case.

Results are:

			Writes
Threads		vanilla		patched		read
    1		0.85s		0.93s		0.88s
    2		1.20s		0.58s		0.54s
    4		1.23s		0.32s		0.31s
    8		1.40s		0.27s		0.27s
   16		2.36s		0.23s		0.25s

So overwrites scale pretty much like reads now: ~1,000,000 overwrite
IOs per second to that one file with 8-16 threads. Given these tests
are running on an 8p VM, it's not surprising it doesn't go any
faster than that as the thread count goes up.

The patch hacks in some stuff that Christoph's transactional size
and timestamp update patches do correctly, so these changes would
need to wait for that series to be finalised. As it is, this patch
doesn't appear to cause any new xfstests regressions, so it's good
for discussion and testing....

Anyway, for people to comment on, the patch is below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


xfs: use shared ilock mode for direct IO writes by default

From: Dave Chinner <dchinner@redhat.com>

For the direct IO write path, we only really need the ilock to be
taken in exclusive mode during IO submission if we need to do extent
allocation. We currently take it in exclusive mode for both the
write sanity checks and for block mapping and allocation.

In the case of the write sanity checks, we only need to protect the
inode from change while this is occurring, and hence we can use a
shared lock for this. We still need to provide exclusion for EOF
zeroing, so we need to detect that case and upgrade the locking to
exclusive in that case. This is a simple extension of the existing
iolock upgrade case.

We also have the case of timestamp updates occurring inside the
ilock. however, we don't really care if timestamp update races occur
as they are going to end up with the same timestamp anyway. Further,
as we move to transactional timestamp updates, we can't do the
update from within the ilock at all. Hence move the timestamp
update outside the ilock altogether as we don't need or want it to
be protected there.

For block mapping, the direct IO case has to drop the ilock after
the initial read mapping for transaction reservation before the
allocation can be done. This means that the mapping to determine if
allocation is needed simply requires a "don't change" locking
semantic. i.e. a shared lock.

Hence we can safely change the xfs_get_blocks() code to use a shared
lock for the initial mapping lookup because that provides the same
guarantees but doesn't introduce new race conditions due to the
allocation having to upgrade the lock - it already has those race
conditions and has to handle them. This means that overwrite and
write into preallocated space direct IO will be mapped with just a
shared lock.

Finally, we only take the ilock during IO completion if the current
ioend is beyond the file size. This is a quick hack that will be
fixed properly by transactional size updates.

In combination, these three changes remove all exclusive
serialisation points in the direct IO write path for single file
overwrite workloads.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c  |   22 ++++++++++++++++++++--
 fs/xfs/xfs_file.c  |   35 +++++++++++++++++++++--------------
 fs/xfs/xfs_iomap.c |   10 +++++++---
 fs/xfs/xfs_iomap.h |    2 +-
 4 files changed, 49 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 74b9baf..4c84508 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -138,6 +138,9 @@ xfs_setfilesize(
 	xfs_inode_t		*ip = XFS_I(ioend->io_inode);
 	xfs_fsize_t		isize;
 
+	if (!xfs_ioend_new_eof(ioend))
+		return 0;
+
 	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
 		return EAGAIN;
 
@@ -1121,7 +1124,22 @@ __xfs_get_blocks(
 		return 0;
 
 	if (create) {
-		lockmode = XFS_ILOCK_EXCL;
+		/*
+		 * For direct IO, we lock in shared mode so that write
+		 * operations that don't require allocation can occur
+		 * concurrently. The ilock has to be dropped over the allocation
+		 * transaction reservation, so the only thing the ilock is
+		 * providing here is modification exclusion. i.e. there is no
+		 * need to hold the lock exclusive.
+		 *
+		 * For buffered IO, if we need to do delayed allocation then
+		 * hold the ilock exclusive so that the lookup and delalloc
+		 * reservation is atomic.
+		 */
+		if (direct)
+			lockmode = XFS_ILOCK_SHARED;
+		else
+			lockmode = XFS_ILOCK_EXCL;
 		xfs_ilock(ip, lockmode);
 	} else {
 		lockmode = xfs_ilock_map_shared(ip);
@@ -1144,7 +1162,7 @@ __xfs_get_blocks(
 	      imap.br_startblock == DELAYSTARTBLOCK))) {
 		if (direct) {
 			error = xfs_iomap_write_direct(ip, offset, size,
-						       &imap, nimaps);
+						       &imap, nimaps, &lockmode);
 		} else {
 			error = xfs_iomap_write_delay(ip, offset, size, &imap);
 		}
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 10ec272..c74e28c 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -650,41 +650,48 @@ xfs_file_aio_write_checks(
 	struct inode		*inode = file->f_mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
 	int			error = 0;
+	int			ilock = XFS_ILOCK_SHARED;
 
-	xfs_rw_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_rw_ilock(ip, ilock);
 restart:
 	error = generic_write_checks(file, pos, count, S_ISBLK(inode->i_mode));
 	if (error) {
-		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
+		xfs_rw_iunlock(ip, ilock);
 		return error;
 	}
 
-	if (likely(!(file->f_mode & FMODE_NOCMTIME)))
-		file_update_time(file);
-
 	/*
 	 * If the offset is beyond the size of the file, we need to zero any
 	 * blocks that fall between the existing EOF and the start of this
-	 * write.  If zeroing is needed and we are currently holding the
-	 * iolock shared, we need to update it to exclusive which involves
-	 * dropping all locks and relocking to maintain correct locking order.
-	 * If we do this, restart the function to ensure all checks and values
-	 * are still valid.
+	 * write.  If zeroing is needed and we are currently holding shared
+	 * locks, we need to update it to exclusive which involves dropping all
+	 * locks and relocking to maintain correct locking order.  If we do
+	 * this, restart the function to ensure all checks and values are still
+	 * valid.
 	 */
 	if (*pos > i_size_read(inode)) {
-		if (*iolock == XFS_IOLOCK_SHARED) {
-			xfs_rw_iunlock(ip, XFS_ILOCK_EXCL | *iolock);
+		if (*iolock == XFS_IOLOCK_SHARED || ilock == XFS_ILOCK_SHARED) {
+			xfs_rw_iunlock(ip, ilock | *iolock);
 			*iolock = XFS_IOLOCK_EXCL;
-			xfs_rw_ilock(ip, XFS_ILOCK_EXCL | *iolock);
+			ilock = XFS_ILOCK_EXCL;
+			xfs_rw_ilock(ip, ilock | *iolock);
 			goto restart;
 		}
 		error = -xfs_zero_eof(ip, *pos, i_size_read(inode));
 	}
-	xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_rw_iunlock(ip, ilock);
 	if (error)
 		return error;
 
 	/*
+	 * we can't do any operation that might call .dirty_inode under the
+	 * ilock when we move to completely transactional updates. Hence this
+	 * timestamp must sit outside the ilock.
+	 */
+	if (likely(!(file->f_mode & FMODE_NOCMTIME)))
+		file_update_time(file);
+
+	/*
 	 * If we're writing the file then make sure to clear the setuid and
 	 * setgid bits if the process is not being run by root.  This keeps
 	 * people from modifying setuid and setgid binaries.
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 246c7d5..792c81d 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -123,7 +123,8 @@ xfs_iomap_write_direct(
 	xfs_off_t	offset,
 	size_t		count,
 	xfs_bmbt_irec_t *imap,
-	int		nmaps)
+	int		nmaps,
+	int		*lockmode)
 {
 	xfs_mount_t	*mp = ip->i_mount;
 	xfs_fileoff_t	offset_fsb;
@@ -189,7 +190,8 @@ xfs_iomap_write_direct(
 	/*
 	 * Allocate and setup the transaction
 	 */
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(ip, *lockmode);
+
 	tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
 	error = xfs_trans_reserve(tp, resblks,
 			XFS_WRITE_LOG_RES(mp), resrtextents,
@@ -200,7 +202,9 @@ xfs_iomap_write_direct(
 	 */
 	if (error)
 		xfs_trans_cancel(tp, 0);
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+	*lockmode = XFS_ILOCK_EXCL;
+	xfs_ilock(ip, *lockmode);
 	if (error)
 		goto error_out;
 
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index 8061576..21e3398 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -22,7 +22,7 @@ struct xfs_inode;
 struct xfs_bmbt_irec;
 
 extern int xfs_iomap_write_direct(struct xfs_inode *, xfs_off_t, size_t,
-			struct xfs_bmbt_irec *, int);
+			struct xfs_bmbt_irec *, int, int *);
 extern int xfs_iomap_write_delay(struct xfs_inode *, xfs_off_t, size_t,
 			struct xfs_bmbt_irec *);
 extern int xfs_iomap_write_allocate(struct xfs_inode *, xfs_off_t, size_t,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
