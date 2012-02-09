Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q196iaUh144994 for <xfs@oss.sgi.com>; Thu, 9 Feb 2012 00:44:36 -0600
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id tCDDFwrROZ91C9q9
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 08 Feb 2012 22:44:33 -0800 (PST)
Received: by yhjj72 with SMTP id j72so991295yhj.26
	for <xfs@oss.sgi.com>; Wed, 08 Feb 2012 22:44:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120209060920.GF7479@dastard>
References: <CAFLer83FBZG9ZCrT2jUZBcTC2a2tx_CDmykyPF4cTP0dbHGw7Q@mail.gmail.com>
	<20120116232549.GC6922@dastard>
	<CAFLer81XkMTh_gxd95pzxCEs1yGRsTrZijX3c7ewgRzeA7DCSQ@mail.gmail.com>
	<20120123051155.GI15102@dastard>
	<CAFLer82QxfgXEx7ofzOHOK2YKiA+ab+_Aizd10SWHvnC-mVUHg@mail.gmail.com>
	<CAFLer81GWSCCCMppU=2dE+5KKqD-hYVKAA0hz9n-CBbxAs_xfw@mail.gmail.com>
	<20120124035431.GD6922@dastard> <20120209060920.GF7479@dastard>
Date: Thu, 9 Feb 2012 01:44:33 -0500
Message-ID: <CAFLer805hELCKqiHM+-VC6q6iXFNL8Li9obZO6irRFFNeJzOEw@mail.gmail.com>
Subject: Re: concurrent direct IO write in xfs
From: Zheng Da <zhengda1936@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4386499291077819905=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============4386499291077819905==
Content-Type: multipart/alternative; boundary=20cf30426db846516b04b8825831

--20cf30426db846516b04b8825831
Content-Type: text/plain; charset=ISO-8859-1

Thanks, Dave. I'll also try this patch.

Da

On Thu, Feb 9, 2012 at 1:09 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Jan 24, 2012 at 02:54:31PM +1100, Dave Chinner wrote:
> > On Mon, Jan 23, 2012 at 03:51:43PM -0500, Zheng Da wrote:
> > > Hello
> > >
> > > On Mon, Jan 23, 2012 at 2:34 PM, Zheng Da <zhengda1936@gmail.com>
> wrote:
> > > >> > So the test case is pretty simple and I think it's easy to
> reproduce it.
> > > >> > It'll be great if you can try the test case.
> > > >>
> > > >> Can you post your test code so I know what I test is exactly what
> > > >> you are running?
> > > >>
> > > > I can do that. My test code gets very complicated now. I need to
> simplify
> > > > it.
> > > >
> > > Here is the code. It's still a bit long. I hope it's OK.
> > > You can run the code like "rand-read file option=direct pages=1048576
> > > threads=8 access=write/read".
> >
> > With 262144 pages on a 2Gb ramdisk, the results I get on 3.2.0 are
> >
> > Threads               Read    Write
> >     1         0.92s   1.49s
> >     2         0.51s   1.20s
> >     4         0.31s   1.34s
> >     8         0.22s   1.59s
> >    16         0.23s   2.24s
> >
> > the contention is on the ip->i_ilock, and the newsize update is one
> > of the offenders It probably needs this change to
> > xfs_aio_write_newsize_update():
> >
> > -        if (new_size == ip->i_new_size) {
> > +        if (new_size && new_size == ip->i_new_size) {
> >
> > to avoid the lock being taken here.
> >
> > But all that newsize crap is gone in the current git Linus tree,
> > so how much would that gains us:
> >
> > Threads               Read    Write
> >     1         0.88s   0.85s
> >     2         0.54s   1.20s
> >     4         0.31s   1.23s
> >     8         0.27s   1.40s
> >    16         0.25s   2.36s
> >
> > Pretty much nothing. IOWs, it's just like I suspected - you are
> > doing so many write IOs that you are serialising on the extent
> > lookup and write checks which use exclusive locking..
> >
> > Given that it is 2 lock traversals per write IO, we're limiting at
> > about 4-500,000 exclusive lock grabs per second and decreasing as
> > contention goes up.
> >
> > For reads, we are doing 2 shared (nested) lookups per read IO, we
> > appear to be limiting at around 2,000,000 shared lock grabs per
> > second. Ahmdals law is kicking in here, but it means if we could
> > make the writes to use a shared lock, it would at least scale like
> > the reads for this "no metadata modification except for mtime"
> > overwrite case.
> >
> > I don't think that the generic write checks absolutely need
> > exclusive locking - we probably could get away with a shared lock
> > and only fall back to exclusive when we need to do EOF zeroing.
> > Similarly, for the block mapping code if we don't need to do
> > allocation, a shared lock is all we need. So maybe in that case for
> > direct IO when create == 1, we can do a read lookup first and only
> > grab the lock exclusively if that falls in a hole and requires
> > allocation.....
>
> So, I have a proof of concept patch that gets rid of the exclusive
> locking for the overwrite case.
>
> Results are:
>
>                        Writes
> Threads         vanilla         patched         read
>    1           0.85s           0.93s           0.88s
>    2           1.20s           0.58s           0.54s
>    4           1.23s           0.32s           0.31s
>    8           1.40s           0.27s           0.27s
>   16           2.36s           0.23s           0.25s
>
> So overwrites scale pretty much like reads now: ~1,000,000 overwrite
> IOs per second to that one file with 8-16 threads. Given these tests
> are running on an 8p VM, it's not surprising it doesn't go any
> faster than that as the thread count goes up.
>
> The patch hacks in some stuff that Christoph's transactional size
> and timestamp update patches do correctly, so these changes would
> need to wait for that series to be finalised. As it is, this patch
> doesn't appear to cause any new xfstests regressions, so it's good
> for discussion and testing....
>
> Anyway, for people to comment on, the patch is below.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
>
> xfs: use shared ilock mode for direct IO writes by default
>
> From: Dave Chinner <dchinner@redhat.com>
>
> For the direct IO write path, we only really need the ilock to be
> taken in exclusive mode during IO submission if we need to do extent
> allocation. We currently take it in exclusive mode for both the
> write sanity checks and for block mapping and allocation.
>
> In the case of the write sanity checks, we only need to protect the
> inode from change while this is occurring, and hence we can use a
> shared lock for this. We still need to provide exclusion for EOF
> zeroing, so we need to detect that case and upgrade the locking to
> exclusive in that case. This is a simple extension of the existing
> iolock upgrade case.
>
> We also have the case of timestamp updates occurring inside the
> ilock. however, we don't really care if timestamp update races occur
> as they are going to end up with the same timestamp anyway. Further,
> as we move to transactional timestamp updates, we can't do the
> update from within the ilock at all. Hence move the timestamp
> update outside the ilock altogether as we don't need or want it to
> be protected there.
>
> For block mapping, the direct IO case has to drop the ilock after
> the initial read mapping for transaction reservation before the
> allocation can be done. This means that the mapping to determine if
> allocation is needed simply requires a "don't change" locking
> semantic. i.e. a shared lock.
>
> Hence we can safely change the xfs_get_blocks() code to use a shared
> lock for the initial mapping lookup because that provides the same
> guarantees but doesn't introduce new race conditions due to the
> allocation having to upgrade the lock - it already has those race
> conditions and has to handle them. This means that overwrite and
> write into preallocated space direct IO will be mapped with just a
> shared lock.
>
> Finally, we only take the ilock during IO completion if the current
> ioend is beyond the file size. This is a quick hack that will be
> fixed properly by transactional size updates.
>
> In combination, these three changes remove all exclusive
> serialisation points in the direct IO write path for single file
> overwrite workloads.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_aops.c  |   22 ++++++++++++++++++++--
>  fs/xfs/xfs_file.c  |   35 +++++++++++++++++++++--------------
>  fs/xfs/xfs_iomap.c |   10 +++++++---
>  fs/xfs/xfs_iomap.h |    2 +-
>  4 files changed, 49 insertions(+), 20 deletions(-)
>
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 74b9baf..4c84508 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -138,6 +138,9 @@ xfs_setfilesize(
>        xfs_inode_t             *ip = XFS_I(ioend->io_inode);
>        xfs_fsize_t             isize;
>
> +       if (!xfs_ioend_new_eof(ioend))
> +               return 0;
> +
>        if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
>                return EAGAIN;
>
> @@ -1121,7 +1124,22 @@ __xfs_get_blocks(
>                return 0;
>
>        if (create) {
> -               lockmode = XFS_ILOCK_EXCL;
> +               /*
> +                * For direct IO, we lock in shared mode so that write
> +                * operations that don't require allocation can occur
> +                * concurrently. The ilock has to be dropped over the
> allocation
> +                * transaction reservation, so the only thing the ilock is
> +                * providing here is modification exclusion. i.e. there is
> no
> +                * need to hold the lock exclusive.
> +                *
> +                * For buffered IO, if we need to do delayed allocation
> then
> +                * hold the ilock exclusive so that the lookup and delalloc
> +                * reservation is atomic.
> +                */
> +               if (direct)
> +                       lockmode = XFS_ILOCK_SHARED;
> +               else
> +                       lockmode = XFS_ILOCK_EXCL;
>                xfs_ilock(ip, lockmode);
>        } else {
>                lockmode = xfs_ilock_map_shared(ip);
> @@ -1144,7 +1162,7 @@ __xfs_get_blocks(
>              imap.br_startblock == DELAYSTARTBLOCK))) {
>                if (direct) {
>                        error = xfs_iomap_write_direct(ip, offset, size,
> -                                                      &imap, nimaps);
> +                                                      &imap, nimaps,
> &lockmode);
>                } else {
>                        error = xfs_iomap_write_delay(ip, offset, size,
> &imap);
>                }
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 10ec272..c74e28c 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -650,41 +650,48 @@ xfs_file_aio_write_checks(
>        struct inode            *inode = file->f_mapping->host;
>        struct xfs_inode        *ip = XFS_I(inode);
>        int                     error = 0;
> +       int                     ilock = XFS_ILOCK_SHARED;
>
> -       xfs_rw_ilock(ip, XFS_ILOCK_EXCL);
> +       xfs_rw_ilock(ip, ilock);
>  restart:
>        error = generic_write_checks(file, pos, count,
> S_ISBLK(inode->i_mode));
>        if (error) {
> -               xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
> +               xfs_rw_iunlock(ip, ilock);
>                return error;
>        }
>
> -       if (likely(!(file->f_mode & FMODE_NOCMTIME)))
> -               file_update_time(file);
> -
>        /*
>         * If the offset is beyond the size of the file, we need to zero any
>         * blocks that fall between the existing EOF and the start of this
> -        * write.  If zeroing is needed and we are currently holding the
> -        * iolock shared, we need to update it to exclusive which involves
> -        * dropping all locks and relocking to maintain correct locking
> order.
> -        * If we do this, restart the function to ensure all checks and
> values
> -        * are still valid.
> +        * write.  If zeroing is needed and we are currently holding shared
> +        * locks, we need to update it to exclusive which involves
> dropping all
> +        * locks and relocking to maintain correct locking order.  If we do
> +        * this, restart the function to ensure all checks and values are
> still
> +        * valid.
>         */
>        if (*pos > i_size_read(inode)) {
> -               if (*iolock == XFS_IOLOCK_SHARED) {
> -                       xfs_rw_iunlock(ip, XFS_ILOCK_EXCL | *iolock);
> +               if (*iolock == XFS_IOLOCK_SHARED || ilock ==
> XFS_ILOCK_SHARED) {
> +                       xfs_rw_iunlock(ip, ilock | *iolock);
>                        *iolock = XFS_IOLOCK_EXCL;
> -                       xfs_rw_ilock(ip, XFS_ILOCK_EXCL | *iolock);
> +                       ilock = XFS_ILOCK_EXCL;
> +                       xfs_rw_ilock(ip, ilock | *iolock);
>                        goto restart;
>                }
>                error = -xfs_zero_eof(ip, *pos, i_size_read(inode));
>        }
> -       xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
> +       xfs_rw_iunlock(ip, ilock);
>        if (error)
>                return error;
>
>        /*
> +        * we can't do any operation that might call .dirty_inode under the
> +        * ilock when we move to completely transactional updates. Hence
> this
> +        * timestamp must sit outside the ilock.
> +        */
> +       if (likely(!(file->f_mode & FMODE_NOCMTIME)))
> +               file_update_time(file);
> +
> +       /*
>         * If we're writing the file then make sure to clear the setuid and
>         * setgid bits if the process is not being run by root.  This keeps
>         * people from modifying setuid and setgid binaries.
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 246c7d5..792c81d 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -123,7 +123,8 @@ xfs_iomap_write_direct(
>        xfs_off_t       offset,
>        size_t          count,
>        xfs_bmbt_irec_t *imap,
> -       int             nmaps)
> +       int             nmaps,
> +       int             *lockmode)
>  {
>        xfs_mount_t     *mp = ip->i_mount;
>        xfs_fileoff_t   offset_fsb;
> @@ -189,7 +190,8 @@ xfs_iomap_write_direct(
>        /*
>         * Allocate and setup the transaction
>         */
> -       xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +       xfs_iunlock(ip, *lockmode);
> +
>        tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
>        error = xfs_trans_reserve(tp, resblks,
>                        XFS_WRITE_LOG_RES(mp), resrtextents,
> @@ -200,7 +202,9 @@ xfs_iomap_write_direct(
>         */
>        if (error)
>                xfs_trans_cancel(tp, 0);
> -       xfs_ilock(ip, XFS_ILOCK_EXCL);
> +
> +       *lockmode = XFS_ILOCK_EXCL;
> +       xfs_ilock(ip, *lockmode);
>        if (error)
>                goto error_out;
>
> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> index 8061576..21e3398 100644
> --- a/fs/xfs/xfs_iomap.h
> +++ b/fs/xfs/xfs_iomap.h
> @@ -22,7 +22,7 @@ struct xfs_inode;
>  struct xfs_bmbt_irec;
>
>  extern int xfs_iomap_write_direct(struct xfs_inode *, xfs_off_t, size_t,
> -                       struct xfs_bmbt_irec *, int);
> +                       struct xfs_bmbt_irec *, int, int *);
>  extern int xfs_iomap_write_delay(struct xfs_inode *, xfs_off_t, size_t,
>                        struct xfs_bmbt_irec *);
>  extern int xfs_iomap_write_allocate(struct xfs_inode *, xfs_off_t, size_t,
>

--20cf30426db846516b04b8825831
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Thanks, Dave. I&#39;ll also try this patch.<div><br></div><div>Da<br><div><=
br><div class=3D"gmail_quote">On Thu, Feb 9, 2012 at 1:09 AM, Dave Chinner =
<span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com">david@fromorbi=
t.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On Tue, Jan 24, 2012 at 02=
:54:31PM +1100, Dave Chinner wrote:<br>
&gt; On Mon, Jan 23, 2012 at 03:51:43PM -0500, Zheng Da wrote:<br>
&gt; &gt; Hello<br>
&gt; &gt;<br>
&gt; &gt; On Mon, Jan 23, 2012 at 2:34 PM, Zheng Da &lt;<a href=3D"mailto:z=
hengda1936@gmail.com">zhengda1936@gmail.com</a>&gt; wrote:<br>
</div><div><div class=3D"h5">&gt; &gt; &gt;&gt; &gt; So the test case is pr=
etty simple and I think it&#39;s easy to reproduce it.<br>
&gt; &gt; &gt;&gt; &gt; It&#39;ll be great if you can try the test case.<br=
>
&gt; &gt; &gt;&gt;<br>
&gt; &gt; &gt;&gt; Can you post your test code so I know what I test is exa=
ctly what<br>
&gt; &gt; &gt;&gt; you are running?<br>
&gt; &gt; &gt;&gt;<br>
&gt; &gt; &gt; I can do that. My test code gets very complicated now. I nee=
d to simplify<br>
&gt; &gt; &gt; it.<br>
&gt; &gt; &gt;<br>
&gt; &gt; Here is the code. It&#39;s still a bit long. I hope it&#39;s OK.<=
br>
&gt; &gt; You can run the code like &quot;rand-read file option=3Ddirect pa=
ges=3D1048576<br>
&gt; &gt; threads=3D8 access=3Dwrite/read&quot;.<br>
&gt;<br>
&gt; With 262144 pages on a 2Gb ramdisk, the results I get on 3.2.0 are<br>
&gt;<br>
&gt; Threads =A0 =A0 =A0 =A0 =A0 =A0 =A0 Read =A0 =A0Write<br>
&gt; =A0 =A0 1 =A0 =A0 =A0 =A0 0.92s =A0 1.49s<br>
&gt; =A0 =A0 2 =A0 =A0 =A0 =A0 0.51s =A0 1.20s<br>
&gt; =A0 =A0 4 =A0 =A0 =A0 =A0 0.31s =A0 1.34s<br>
&gt; =A0 =A0 8 =A0 =A0 =A0 =A0 0.22s =A0 1.59s<br>
&gt; =A0 =A016 =A0 =A0 =A0 =A0 0.23s =A0 2.24s<br>
&gt;<br>
&gt; the contention is on the ip-&gt;i_ilock, and the newsize update is one=
<br>
&gt; of the offenders It probably needs this change to<br>
&gt; xfs_aio_write_newsize_update():<br>
&gt;<br>
&gt; - =A0 =A0 =A0 =A0if (new_size =3D=3D ip-&gt;i_new_size) {<br>
&gt; + =A0 =A0 =A0 =A0if (new_size &amp;&amp; new_size =3D=3D ip-&gt;i_new_=
size) {<br>
&gt;<br>
&gt; to avoid the lock being taken here.<br>
&gt;<br>
&gt; But all that newsize crap is gone in the current git Linus tree,<br>
&gt; so how much would that gains us:<br>
&gt;<br>
&gt; Threads =A0 =A0 =A0 =A0 =A0 =A0 =A0 Read =A0 =A0Write<br>
&gt; =A0 =A0 1 =A0 =A0 =A0 =A0 0.88s =A0 0.85s<br>
&gt; =A0 =A0 2 =A0 =A0 =A0 =A0 0.54s =A0 1.20s<br>
&gt; =A0 =A0 4 =A0 =A0 =A0 =A0 0.31s =A0 1.23s<br>
&gt; =A0 =A0 8 =A0 =A0 =A0 =A0 0.27s =A0 1.40s<br>
&gt; =A0 =A016 =A0 =A0 =A0 =A0 0.25s =A0 2.36s<br>
&gt;<br>
&gt; Pretty much nothing. IOWs, it&#39;s just like I suspected - you are<br=
>
&gt; doing so many write IOs that you are serialising on the extent<br>
&gt; lookup and write checks which use exclusive locking..<br>
&gt;<br>
&gt; Given that it is 2 lock traversals per write IO, we&#39;re limiting at=
<br>
&gt; about 4-500,000 exclusive lock grabs per second and decreasing as<br>
&gt; contention goes up.<br>
&gt;<br>
&gt; For reads, we are doing 2 shared (nested) lookups per read IO, we<br>
&gt; appear to be limiting at around 2,000,000 shared lock grabs per<br>
&gt; second. Ahmdals law is kicking in here, but it means if we could<br>
&gt; make the writes to use a shared lock, it would at least scale like<br>
&gt; the reads for this &quot;no metadata modification except for mtime&quo=
t;<br>
&gt; overwrite case.<br>
&gt;<br>
&gt; I don&#39;t think that the generic write checks absolutely need<br>
&gt; exclusive locking - we probably could get away with a shared lock<br>
&gt; and only fall back to exclusive when we need to do EOF zeroing.<br>
&gt; Similarly, for the block mapping code if we don&#39;t need to do<br>
&gt; allocation, a shared lock is all we need. So maybe in that case for<br=
>
&gt; direct IO when create =3D=3D 1, we can do a read lookup first and only=
<br>
&gt; grab the lock exclusively if that falls in a hole and requires<br>
&gt; allocation.....<br>
<br>
</div></div>So, I have a proof of concept patch that gets rid of the exclus=
ive<br>
locking for the overwrite case.<br>
<br>
Results are:<br>
<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Writes<br>
Threads =A0 =A0 =A0 =A0 vanilla =A0 =A0 =A0 =A0 patched =A0 =A0 =A0 =A0 rea=
d<br>
 =A0 =A01 =A0 =A0 =A0 =A0 =A0 0.85s =A0 =A0 =A0 =A0 =A0 0.93s =A0 =A0 =A0 =
=A0 =A0 0.88s<br>
 =A0 =A02 =A0 =A0 =A0 =A0 =A0 1.20s =A0 =A0 =A0 =A0 =A0 0.58s =A0 =A0 =A0 =
=A0 =A0 0.54s<br>
 =A0 =A04 =A0 =A0 =A0 =A0 =A0 1.23s =A0 =A0 =A0 =A0 =A0 0.32s =A0 =A0 =A0 =
=A0 =A0 0.31s<br>
 =A0 =A08 =A0 =A0 =A0 =A0 =A0 1.40s =A0 =A0 =A0 =A0 =A0 0.27s =A0 =A0 =A0 =
=A0 =A0 0.27s<br>
 =A0 16 =A0 =A0 =A0 =A0 =A0 2.36s =A0 =A0 =A0 =A0 =A0 0.23s =A0 =A0 =A0 =A0=
 =A0 0.25s<br>
<br>
So overwrites scale pretty much like reads now: ~1,000,000 overwrite<br>
IOs per second to that one file with 8-16 threads. Given these tests<br>
are running on an 8p VM, it&#39;s not surprising it doesn&#39;t go any<br>
faster than that as the thread count goes up.<br>
<br>
The patch hacks in some stuff that Christoph&#39;s transactional size<br>
and timestamp update patches do correctly, so these changes would<br>
need to wait for that series to be finalised. As it is, this patch<br>
doesn&#39;t appear to cause any new xfstests regressions, so it&#39;s good<=
br>
for discussion and testing....<br>
<br>
Anyway, for people to comment on, the patch is below.<br>
<div class=3D"im"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
<br>
<br>
</div>xfs: use shared ilock mode for direct IO writes by default<br>
<br>
From: Dave Chinner &lt;<a href=3D"mailto:dchinner@redhat.com">dchinner@redh=
at.com</a>&gt;<br>
<br>
For the direct IO write path, we only really need the ilock to be<br>
taken in exclusive mode during IO submission if we need to do extent<br>
allocation. We currently take it in exclusive mode for both the<br>
write sanity checks and for block mapping and allocation.<br>
<br>
In the case of the write sanity checks, we only need to protect the<br>
inode from change while this is occurring, and hence we can use a<br>
shared lock for this. We still need to provide exclusion for EOF<br>
zeroing, so we need to detect that case and upgrade the locking to<br>
exclusive in that case. This is a simple extension of the existing<br>
iolock upgrade case.<br>
<br>
We also have the case of timestamp updates occurring inside the<br>
ilock. however, we don&#39;t really care if timestamp update races occur<br=
>
as they are going to end up with the same timestamp anyway. Further,<br>
as we move to transactional timestamp updates, we can&#39;t do the<br>
update from within the ilock at all. Hence move the timestamp<br>
update outside the ilock altogether as we don&#39;t need or want it to<br>
be protected there.<br>
<br>
For block mapping, the direct IO case has to drop the ilock after<br>
the initial read mapping for transaction reservation before the<br>
allocation can be done. This means that the mapping to determine if<br>
allocation is needed simply requires a &quot;don&#39;t change&quot; locking=
<br>
semantic. i.e. a shared lock.<br>
<br>
Hence we can safely change the xfs_get_blocks() code to use a shared<br>
lock for the initial mapping lookup because that provides the same<br>
guarantees but doesn&#39;t introduce new race conditions due to the<br>
allocation having to upgrade the lock - it already has those race<br>
conditions and has to handle them. This means that overwrite and<br>
write into preallocated space direct IO will be mapped with just a<br>
shared lock.<br>
<br>
Finally, we only take the ilock during IO completion if the current<br>
ioend is beyond the file size. This is a quick hack that will be<br>
fixed properly by transactional size updates.<br>
<br>
In combination, these three changes remove all exclusive<br>
serialisation points in the direct IO write path for single file<br>
overwrite workloads.<br>
<br>
Signed-off-by: Dave Chinner &lt;<a href=3D"mailto:dchinner@redhat.com">dchi=
nner@redhat.com</a>&gt;<br>
---<br>
=A0fs/xfs/xfs_aops.c =A0| =A0 22 ++++++++++++++++++++--<br>
=A0fs/xfs/xfs_file.c =A0| =A0 35 +++++++++++++++++++++--------------<br>
=A0fs/xfs/xfs_iomap.c | =A0 10 +++++++---<br>
=A0fs/xfs/xfs_iomap.h | =A0 =A02 +-<br>
=A04 files changed, 49 insertions(+), 20 deletions(-)<br>
<br>
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c<br>
index 74b9baf..4c84508 100644<br>
--- a/fs/xfs/xfs_aops.c<br>
+++ b/fs/xfs/xfs_aops.c<br>
@@ -138,6 +138,9 @@ xfs_setfilesize(<br>
 =A0 =A0 =A0 =A0xfs_inode_t =A0 =A0 =A0 =A0 =A0 =A0 *ip =3D XFS_I(ioend-&gt=
;io_inode);<br>
 =A0 =A0 =A0 =A0xfs_fsize_t =A0 =A0 =A0 =A0 =A0 =A0 isize;<br>
<br>
+ =A0 =A0 =A0 if (!xfs_ioend_new_eof(ioend))<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;<br>
+<br>
 =A0 =A0 =A0 =A0if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return EAGAIN;<br>
<br>
@@ -1121,7 +1124,22 @@ __xfs_get_blocks(<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;<br>
<br>
 =A0 =A0 =A0 =A0if (create) {<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 lockmode =3D XFS_ILOCK_EXCL;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* For direct IO, we lock in shared mode so=
 that write<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* operations that don&#39;t require alloca=
tion can occur<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* concurrently. The ilock has to be droppe=
d over the allocation<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* transaction reservation, so the only thi=
ng the ilock is<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* providing here is modification exclusion=
. i.e. there is no<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* need to hold the lock exclusive.<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* For buffered IO, if we need to do delaye=
d allocation then<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* hold the ilock exclusive so that the loo=
kup and delalloc<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* reservation is atomic.<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (direct)<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 lockmode =3D XFS_ILOCK_SHARED=
;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 else<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 lockmode =3D XFS_ILOCK_EXCL;<=
br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0xfs_ilock(ip, lockmode);<br>
 =A0 =A0 =A0 =A0} else {<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0lockmode =3D xfs_ilock_map_shared(ip);<br>
@@ -1144,7 +1162,7 @@ __xfs_get_blocks(<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0imap.br_startblock =3D=3D DELAYSTARTBLOCK))) {<=
br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (direct) {<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0error =3D xfs_iomap_write_d=
irect(ip, offset, size,<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&amp;imap, nimaps);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&amp;imap, nimaps, &amp;lockmode);<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0error =3D xfs_iomap_write_d=
elay(ip, offset, size, &amp;imap);<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}<br>
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c<br>
index 10ec272..c74e28c 100644<br>
--- a/fs/xfs/xfs_file.c<br>
+++ b/fs/xfs/xfs_file.c<br>
@@ -650,41 +650,48 @@ xfs_file_aio_write_checks(<br>
 =A0 =A0 =A0 =A0struct inode =A0 =A0 =A0 =A0 =A0 =A0*inode =3D file-&gt;f_m=
apping-&gt;host;<br>
 =A0 =A0 =A0 =A0struct xfs_inode =A0 =A0 =A0 =A0*ip =3D XFS_I(inode);<br>
 =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D 0;<br=
>
+ =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ilock =3D XFS_ILO=
CK_SHARED;<br>
<br>
- =A0 =A0 =A0 xfs_rw_ilock(ip, XFS_ILOCK_EXCL);<br>
+ =A0 =A0 =A0 xfs_rw_ilock(ip, ilock);<br>
=A0restart:<br>
 =A0 =A0 =A0 =A0error =3D generic_write_checks(file, pos, count, S_ISBLK(in=
ode-&gt;i_mode));<br>
 =A0 =A0 =A0 =A0if (error) {<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_rw_iunlock(ip, ilock);<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return error;<br>
 =A0 =A0 =A0 =A0}<br>
<br>
- =A0 =A0 =A0 if (likely(!(file-&gt;f_mode &amp; FMODE_NOCMTIME)))<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 file_update_time(file);<br>
-<br>
 =A0 =A0 =A0 =A0/*<br>
 =A0 =A0 =A0 =A0 * If the offset is beyond the size of the file, we need to=
 zero any<br>
 =A0 =A0 =A0 =A0 * blocks that fall between the existing EOF and the start =
of this<br>
- =A0 =A0 =A0 =A0* write. =A0If zeroing is needed and we are currently hold=
ing the<br>
- =A0 =A0 =A0 =A0* iolock shared, we need to update it to exclusive which i=
nvolves<br>
- =A0 =A0 =A0 =A0* dropping all locks and relocking to maintain correct loc=
king order.<br>
- =A0 =A0 =A0 =A0* If we do this, restart the function to ensure all checks=
 and values<br>
- =A0 =A0 =A0 =A0* are still valid.<br>
+ =A0 =A0 =A0 =A0* write. =A0If zeroing is needed and we are currently hold=
ing shared<br>
+ =A0 =A0 =A0 =A0* locks, we need to update it to exclusive which involves =
dropping all<br>
+ =A0 =A0 =A0 =A0* locks and relocking to maintain correct locking order. =
=A0If we do<br>
+ =A0 =A0 =A0 =A0* this, restart the function to ensure all checks and valu=
es are still<br>
+ =A0 =A0 =A0 =A0* valid.<br>
 =A0 =A0 =A0 =A0 */<br>
 =A0 =A0 =A0 =A0if (*pos &gt; i_size_read(inode)) {<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (*iolock =3D=3D XFS_IOLOCK_SHARED) {<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_rw_iunlock(ip, XFS_ILOCK_=
EXCL | *iolock);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (*iolock =3D=3D XFS_IOLOCK_SHARED || ilock=
 =3D=3D XFS_ILOCK_SHARED) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_rw_iunlock(ip, ilock | *i=
olock);<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*iolock =3D XFS_IOLOCK_EXCL=
;<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_rw_ilock(ip, XFS_ILOCK_EX=
CL | *iolock);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ilock =3D XFS_ILOCK_EXCL;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_rw_ilock(ip, ilock | *iol=
ock);<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto restart;<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0error =3D -xfs_zero_eof(ip, *pos, i_size_re=
ad(inode));<br>
 =A0 =A0 =A0 =A0}<br>
- =A0 =A0 =A0 xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);<br>
+ =A0 =A0 =A0 xfs_rw_iunlock(ip, ilock);<br>
 =A0 =A0 =A0 =A0if (error)<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return error;<br>
<br>
 =A0 =A0 =A0 =A0/*<br>
+ =A0 =A0 =A0 =A0* we can&#39;t do any operation that might call .dirty_ino=
de under the<br>
+ =A0 =A0 =A0 =A0* ilock when we move to completely transactional updates. =
Hence this<br>
+ =A0 =A0 =A0 =A0* timestamp must sit outside the ilock.<br>
+ =A0 =A0 =A0 =A0*/<br>
+ =A0 =A0 =A0 if (likely(!(file-&gt;f_mode &amp; FMODE_NOCMTIME)))<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 file_update_time(file);<br>
+<br>
+ =A0 =A0 =A0 /*<br>
 =A0 =A0 =A0 =A0 * If we&#39;re writing the file then make sure to clear th=
e setuid and<br>
 =A0 =A0 =A0 =A0 * setgid bits if the process is not being run by root. =A0=
This keeps<br>
 =A0 =A0 =A0 =A0 * people from modifying setuid and setgid binaries.<br>
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c<br>
index 246c7d5..792c81d 100644<br>
--- a/fs/xfs/xfs_iomap.c<br>
+++ b/fs/xfs/xfs_iomap.c<br>
@@ -123,7 +123,8 @@ xfs_iomap_write_direct(<br>
 =A0 =A0 =A0 =A0xfs_off_t =A0 =A0 =A0 offset,<br>
 =A0 =A0 =A0 =A0size_t =A0 =A0 =A0 =A0 =A0count,<br>
 =A0 =A0 =A0 =A0xfs_bmbt_irec_t *imap,<br>
- =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 nmaps)<br>
+ =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 nmaps,<br>
+ =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 *lockmode)<br>
=A0{<br>
 =A0 =A0 =A0 =A0xfs_mount_t =A0 =A0 *mp =3D ip-&gt;i_mount;<br>
 =A0 =A0 =A0 =A0xfs_fileoff_t =A0 offset_fsb;<br>
@@ -189,7 +190,8 @@ xfs_iomap_write_direct(<br>
 =A0 =A0 =A0 =A0/*<br>
 =A0 =A0 =A0 =A0 * Allocate and setup the transaction<br>
 =A0 =A0 =A0 =A0 */<br>
- =A0 =A0 =A0 xfs_iunlock(ip, XFS_ILOCK_EXCL);<br>
+ =A0 =A0 =A0 xfs_iunlock(ip, *lockmode);<br>
+<br>
 =A0 =A0 =A0 =A0tp =3D xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);<br>
 =A0 =A0 =A0 =A0error =3D xfs_trans_reserve(tp, resblks,<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0XFS_WRITE_LOG_RES(mp), resr=
textents,<br>
@@ -200,7 +202,9 @@ xfs_iomap_write_direct(<br>
 =A0 =A0 =A0 =A0 */<br>
 =A0 =A0 =A0 =A0if (error)<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0xfs_trans_cancel(tp, 0);<br>
- =A0 =A0 =A0 xfs_ilock(ip, XFS_ILOCK_EXCL);<br>
+<br>
+ =A0 =A0 =A0 *lockmode =3D XFS_ILOCK_EXCL;<br>
+ =A0 =A0 =A0 xfs_ilock(ip, *lockmode);<br>
 =A0 =A0 =A0 =A0if (error)<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto error_out;<br>
<br>
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h<br>
index 8061576..21e3398 100644<br>
--- a/fs/xfs/xfs_iomap.h<br>
+++ b/fs/xfs/xfs_iomap.h<br>
@@ -22,7 +22,7 @@ struct xfs_inode;<br>
=A0struct xfs_bmbt_irec;<br>
<br>
=A0extern int xfs_iomap_write_direct(struct xfs_inode *, xfs_off_t, size_t,=
<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct xfs_bmbt_irec *, int);=
<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct xfs_bmbt_irec *, int, =
int *);<br>
=A0extern int xfs_iomap_write_delay(struct xfs_inode *, xfs_off_t, size_t,<=
br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xfs_bmbt_irec *);<br=
>
=A0extern int xfs_iomap_write_allocate(struct xfs_inode *, xfs_off_t, size_=
t,<br>
</blockquote></div><br></div></div>

--20cf30426db846516b04b8825831--


--===============4386499291077819905==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4386499291077819905==--
