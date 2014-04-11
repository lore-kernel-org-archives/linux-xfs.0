Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 811EE29DF7
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 14:21:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 04E38AC003
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 12:21:26 -0700 (PDT)
Received: from mail-ve0-f176.google.com (mail-ve0-f176.google.com
	[209.85.128.176]) by cuda.sgi.com with ESMTP id
	YQV02TC4Yu51459i (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 11 Apr 2014 12:21:24 -0700 (PDT)
Received: by mail-ve0-f176.google.com with SMTP id db11so5093616veb.7
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 12:21:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1397104955-7247-1-git-send-email-david@fromorbit.com>
References: <1397104955-7247-1-git-send-email-david@fromorbit.com>
Date: Fri, 11 Apr 2014 13:21:24 -0600
Message-ID: <CALjwKZBY2sjtQyN_FrVcBojAhkmChe+4UZmbv8=57XertGo2mA@mail.gmail.com>
Subject: Re: [PATCH] xfs: unmount does not wait for shutdown during unmount
From: Bob Mastors <bob.mastors@solidfire.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8139137913978265035=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: snitzer@redhat.com, xfs@oss.sgi.com

--===============8139137913978265035==
Content-Type: multipart/alternative; boundary=20cf3071cab04eceb904f6c93de9

--20cf3071cab04eceb904f6c93de9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Thanks Dave.
This fixed the umount problem I was seeing.
Tried it a few thousand times. Works great.
Bob


On Wed, Apr 9, 2014 at 10:42 PM, Dave Chinner <david@fromorbit.com> wrote:

> From: Dave Chinner <dchinner@redhat.com>
>
> And interesting situation can occur if a log IO error occurs during
> the unmount of a filesystem. The cases reported have the same
> signature - the update of the superblock counters fails due to a log
> write IO error:
>
> XFS (dm-16): xfs_do_force_shutdown(0x2) called from line 1170 of file
> fs/xfs/xfs_log.c.  Return address =3D 0xffffffffa08a44a1
> XFS (dm-16): Log I/O Error Detected.  Shutting down filesystem
> XFS (dm-16): Unable to update superblock counters. Freespace may not be
> correct on next mount.
> XFS (dm-16): xfs_log_force: error 5 returned.
> XFS (=BF-=BF=BF=BF): Please umount the filesystem and rectify the problem=
(s)
>
> It can be seen that the last line of output contains a corrupt
> device name - this is because the log and xfs_mount structures have
> already been freed by the time this message is printed. A kernel
> oops closely follows.
>
> The issue is that the shutdown is occurring in a separate IO
> completion thread to the unmount. Once the shutdown processing has
> started and all the iclogs are marked with XLOG_STATE_IOERROR, the
> log shutdown code wakes anyone waiting on a log force so they can
> process the shutdown error. This wakes up the unmount code that
> is doing a synchronous transaction to update the superblock
> counters.
>
> The unmount path now sees all the iclogs are marked with
> XLOG_STATE_IOERROR and so never waits on them again, knowing that if
> it does, there will not be a wakeup trigger for it and we will hang
> the unmount if we do. Hence the unmount runs through all the
> remaining code and frees all the filesystem structures while the
> xlog_iodone() is still processing the shutdown. When the log
> shutdown processing completes, xfs_do_force_shutdown() emits the
> "Please umount the filesystem and rectify the problem(s)" message,
> and xlog_iodone() then aborts all the objects attached to the iclog.
> An iclog that has already been freed....
>
> The real issue here is that there is no serialisation point between
> the log IO and the unmount. We have serialisations points for log
> writes, log forces, reservations, etc, but we don't actually have
> any code that wakes for log IO to fully complete. We do that for all
> other types of object, so why not iclogbufs?
>
> Well, it turns out that we can easily do this. We've got xfs_buf
> handles, and that's what everyone else uses for IO serialisation.
> i.e. bp->b_sema. So, lets hold iclogbufs locked over IO, and only
> release the lock in xlog_iodone() when we are finished with the
> buffer. That way before we tear down the iclog, we can lock and
> unlock the buffer to ensure IO completion has finished completely
> before we tear it down.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c | 53
> ++++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 44 insertions(+), 9 deletions(-)
>
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 8497a00..08624dc 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1181,11 +1181,14 @@ xlog_iodone(xfs_buf_t *bp)
>         /* log I/O is always issued ASYNC */
>         ASSERT(XFS_BUF_ISASYNC(bp));
>         xlog_state_done_syncing(iclog, aborted);
> +
>         /*
> -        * do not reference the buffer (bp) here as we could race
> -        * with it being freed after writing the unmount record to the
> -        * log.
> +        * drop the buffer lock now that we are done. Nothing references
> +        * the buffer after this, so an unmount waiting on this lock can
> now
> +        * tear it down safely. As such, it is unsafe to reference the
> buffer
> +        * (bp) after the unlock as we could race with it being freed.
>          */
> +       xfs_buf_unlock(bp);
>  }
>
>  /*
> @@ -1368,8 +1371,16 @@ xlog_alloc_log(
>         bp =3D xfs_buf_alloc(mp->m_logdev_targp, 0,
> BTOBB(log->l_iclog_size), 0);
>         if (!bp)
>                 goto out_free_log;
> -       bp->b_iodone =3D xlog_iodone;
> +
> +       /*
> +        * The iclogbuf buffer locks are held over IO but we are not goin=
g
> to do
> +        * IO yet.  Hence unlock the buffer so that the log IO path can
> grab it
> +        * when appropriately.
> +        */
>         ASSERT(xfs_buf_islocked(bp));
> +       xfs_buf_unlock(bp);
> +
> +       bp->b_iodone =3D xlog_iodone;
>         log->l_xbuf =3D bp;
>
>         spin_lock_init(&log->l_icloglock);
> @@ -1398,6 +1409,9 @@ xlog_alloc_log(
>                 if (!bp)
>                         goto out_free_iclog;
>
> +               ASSERT(xfs_buf_islocked(bp));
> +               xfs_buf_unlock(bp);
> +
>                 bp->b_iodone =3D xlog_iodone;
>                 iclog->ic_bp =3D bp;
>                 iclog->ic_data =3D bp->b_addr;
> @@ -1422,7 +1436,6 @@ xlog_alloc_log(
>                 iclog->ic_callback_tail =3D &(iclog->ic_callback);
>                 iclog->ic_datap =3D (char *)iclog->ic_data +
> log->l_iclog_hsize;
>
> -               ASSERT(xfs_buf_islocked(iclog->ic_bp));
>                 init_waitqueue_head(&iclog->ic_force_wait);
>                 init_waitqueue_head(&iclog->ic_write_wait);
>
> @@ -1631,6 +1644,12 @@ xlog_cksum(
>   * we transition the iclogs to IOERROR state *after* flushing all existi=
ng
>   * iclogs to disk. This is because we don't want anymore new transaction=
s
> to be
>   * started or completed afterwards.
> + *
> + * We lock the iclogbufs here so that we can serialise against IO
> completion
> + * during unmount. We might be processing a shutdown triggered during
> unmount,
> + * and that can occur asynchronously to the unmount thread, and hence we
> need to
> + * ensure that completes before tearing down the iclogbufs. Hence we nee=
d
> to
> + * hold the buffer lock across the log IO to acheive that.
>   */
>  STATIC int
>  xlog_bdstrat(
> @@ -1638,6 +1657,7 @@ xlog_bdstrat(
>  {
>         struct xlog_in_core     *iclog =3D bp->b_fspriv;
>
> +       xfs_buf_lock(bp);
>         if (iclog->ic_state & XLOG_STATE_IOERROR) {
>                 xfs_buf_ioerror(bp, EIO);
>                 xfs_buf_stale(bp);
> @@ -1645,7 +1665,8 @@ xlog_bdstrat(
>                 /*
>                  * It would seem logical to return EIO here, but we rely =
on
>                  * the log state machine to propagate I/O errors instead =
of
> -                * doing it here.
> +                * doing it here. Similarly, IO completion will unlock th=
e
> +                * buffer, so we don't do it here.
>                  */
>                 return 0;
>         }
> @@ -1847,14 +1868,28 @@ xlog_dealloc_log(
>         xlog_cil_destroy(log);
>
>         /*
> -        * always need to ensure that the extra buffer does not point to
> memory
> -        * owned by another log buffer before we free it.
> +        * Cycle all the iclogbuf locks to make sure all log IO completio=
n
> +        * is done before we tear down these buffers.
>          */
> +       iclog =3D log->l_iclog;
> +       for (i =3D 0; i < log->l_iclog_bufs; i++) {
> +               xfs_buf_lock(iclog->ic_bp);
> +               xfs_buf_unlock(iclog->ic_bp);
> +               iclog =3D iclog->ic_next;
> +       }
> +
> +       /*
> +        * Always need to ensure that the extra buffer does not point to
> memory
> +        * owned by another log buffer before we free it. Also, cycle the
> lock
> +        * first to ensure we've completed IO on it.
> +        */
> +       xfs_buf_lock(log->l_xbuf);
> +       xfs_buf_unlock(log->l_xbuf);
>         xfs_buf_set_empty(log->l_xbuf, BTOBB(log->l_iclog_size));
>         xfs_buf_free(log->l_xbuf);
>
>         iclog =3D log->l_iclog;
> -       for (i=3D0; i<log->l_iclog_bufs; i++) {
> +       for (i =3D 0; i < log->l_iclog_bufs; i++) {
>                 xfs_buf_free(iclog->ic_bp);
>                 next_iclog =3D iclog->ic_next;
>                 kmem_free(iclog);
> --
> 1.9.0
>
>

--20cf3071cab04eceb904f6c93de9
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks Dave.<div>This fixed the umount problem I was seein=
g.</div><div>Tried it a few thousand times. Works great.</div><div>Bob</div=
></div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Wed=
, Apr 9, 2014 at 10:42 PM, Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"ma=
ilto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&gt;</sp=
an> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">From: Dave Chinner &lt;<a href=3D"mailto:dch=
inner@redhat.com">dchinner@redhat.com</a>&gt;<br>
<br>
And interesting situation can occur if a log IO error occurs during<br>
the unmount of a filesystem. The cases reported have the same<br>
signature - the update of the superblock counters fails due to a log<br>
write IO error:<br>
<br>
XFS (dm-16): xfs_do_force_shutdown(0x2) called from line 1170 of file fs/xf=
s/xfs_log.c. =A0Return address =3D 0xffffffffa08a44a1<br>
XFS (dm-16): Log I/O Error Detected. =A0Shutting down filesystem<br>
XFS (dm-16): Unable to update superblock counters. Freespace may not be cor=
rect on next mount.<br>
XFS (dm-16): xfs_log_force: error 5 returned.<br>
XFS (=BF-=BF=BF=BF): Please umount the filesystem and rectify the problem(s=
)<br>
<br>
It can be seen that the last line of output contains a corrupt<br>
device name - this is because the log and xfs_mount structures have<br>
already been freed by the time this message is printed. A kernel<br>
oops closely follows.<br>
<br>
The issue is that the shutdown is occurring in a separate IO<br>
completion thread to the unmount. Once the shutdown processing has<br>
started and all the iclogs are marked with XLOG_STATE_IOERROR, the<br>
log shutdown code wakes anyone waiting on a log force so they can<br>
process the shutdown error. This wakes up the unmount code that<br>
is doing a synchronous transaction to update the superblock<br>
counters.<br>
<br>
The unmount path now sees all the iclogs are marked with<br>
XLOG_STATE_IOERROR and so never waits on them again, knowing that if<br>
it does, there will not be a wakeup trigger for it and we will hang<br>
the unmount if we do. Hence the unmount runs through all the<br>
remaining code and frees all the filesystem structures while the<br>
xlog_iodone() is still processing the shutdown. When the log<br>
shutdown processing completes, xfs_do_force_shutdown() emits the<br>
&quot;Please umount the filesystem and rectify the problem(s)&quot; message=
,<br>
and xlog_iodone() then aborts all the objects attached to the iclog.<br>
An iclog that has already been freed....<br>
<br>
The real issue here is that there is no serialisation point between<br>
the log IO and the unmount. We have serialisations points for log<br>
writes, log forces, reservations, etc, but we don&#39;t actually have<br>
any code that wakes for log IO to fully complete. We do that for all<br>
other types of object, so why not iclogbufs?<br>
<br>
Well, it turns out that we can easily do this. We&#39;ve got xfs_buf<br>
handles, and that&#39;s what everyone else uses for IO serialisation.<br>
i.e. bp-&gt;b_sema. So, lets hold iclogbufs locked over IO, and only<br>
release the lock in xlog_iodone() when we are finished with the<br>
buffer. That way before we tear down the iclog, we can lock and<br>
unlock the buffer to ensure IO completion has finished completely<br>
before we tear it down.<br>
<br>
Signed-off-by: Dave Chinner &lt;<a href=3D"mailto:dchinner@redhat.com">dchi=
nner@redhat.com</a>&gt;<br>
---<br>
=A0fs/xfs/xfs_log.c | 53 ++++++++++++++++++++++++++++++++++++++++++++------=
---<br>
=A01 file changed, 44 insertions(+), 9 deletions(-)<br>
<br>
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c<br>
index 8497a00..08624dc 100644<br>
--- a/fs/xfs/xfs_log.c<br>
+++ b/fs/xfs/xfs_log.c<br>
@@ -1181,11 +1181,14 @@ xlog_iodone(xfs_buf_t *bp)<br>
=A0 =A0 =A0 =A0 /* log I/O is always issued ASYNC */<br>
=A0 =A0 =A0 =A0 ASSERT(XFS_BUF_ISASYNC(bp));<br>
=A0 =A0 =A0 =A0 xlog_state_done_syncing(iclog, aborted);<br>
+<br>
=A0 =A0 =A0 =A0 /*<br>
- =A0 =A0 =A0 =A0* do not reference the buffer (bp) here as we could race<b=
r>
- =A0 =A0 =A0 =A0* with it being freed after writing the unmount record to =
the<br>
- =A0 =A0 =A0 =A0* log.<br>
+ =A0 =A0 =A0 =A0* drop the buffer lock now that we are done. Nothing refer=
ences<br>
+ =A0 =A0 =A0 =A0* the buffer after this, so an unmount waiting on this loc=
k can now<br>
+ =A0 =A0 =A0 =A0* tear it down safely. As such, it is unsafe to reference =
the buffer<br>
+ =A0 =A0 =A0 =A0* (bp) after the unlock as we could race with it being fre=
ed.<br>
=A0 =A0 =A0 =A0 =A0*/<br>
+ =A0 =A0 =A0 xfs_buf_unlock(bp);<br>
=A0}<br>
<br>
=A0/*<br>
@@ -1368,8 +1371,16 @@ xlog_alloc_log(<br>
=A0 =A0 =A0 =A0 bp =3D xfs_buf_alloc(mp-&gt;m_logdev_targp, 0, BTOBB(log-&g=
t;l_iclog_size), 0);<br>
=A0 =A0 =A0 =A0 if (!bp)<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_free_log;<br>
- =A0 =A0 =A0 bp-&gt;b_iodone =3D xlog_iodone;<br>
+<br>
+ =A0 =A0 =A0 /*<br>
+ =A0 =A0 =A0 =A0* The iclogbuf buffer locks are held over IO but we are no=
t going to do<br>
+ =A0 =A0 =A0 =A0* IO yet. =A0Hence unlock the buffer so that the log IO pa=
th can grab it<br>
+ =A0 =A0 =A0 =A0* when appropriately.<br>
+ =A0 =A0 =A0 =A0*/<br>
=A0 =A0 =A0 =A0 ASSERT(xfs_buf_islocked(bp));<br>
+ =A0 =A0 =A0 xfs_buf_unlock(bp);<br>
+<br>
+ =A0 =A0 =A0 bp-&gt;b_iodone =3D xlog_iodone;<br>
=A0 =A0 =A0 =A0 log-&gt;l_xbuf =3D bp;<br>
<br>
=A0 =A0 =A0 =A0 spin_lock_init(&amp;log-&gt;l_icloglock);<br>
@@ -1398,6 +1409,9 @@ xlog_alloc_log(<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!bp)<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_free_iclog;<br>
<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 ASSERT(xfs_buf_islocked(bp));<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_buf_unlock(bp);<br>
+<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bp-&gt;b_iodone =3D xlog_iodone;<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iclog-&gt;ic_bp =3D bp;<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iclog-&gt;ic_data =3D bp-&gt;b_addr;<br>
@@ -1422,7 +1436,6 @@ xlog_alloc_log(<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iclog-&gt;ic_callback_tail =3D &amp;(iclog-=
&gt;ic_callback);<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iclog-&gt;ic_datap =3D (char *)iclog-&gt;ic=
_data + log-&gt;l_iclog_hsize;<br>
<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 ASSERT(xfs_buf_islocked(iclog-&gt;ic_bp));<br=
>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 init_waitqueue_head(&amp;iclog-&gt;ic_force=
_wait);<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 init_waitqueue_head(&amp;iclog-&gt;ic_write=
_wait);<br>
<br>
@@ -1631,6 +1644,12 @@ xlog_cksum(<br>
=A0 * we transition the iclogs to IOERROR state *after* flushing all existi=
ng<br>
=A0 * iclogs to disk. This is because we don&#39;t want anymore new transac=
tions to be<br>
=A0 * started or completed afterwards.<br>
+ *<br>
+ * We lock the iclogbufs here so that we can serialise against IO completi=
on<br>
+ * during unmount. We might be processing a shutdown triggered during unmo=
unt,<br>
+ * and that can occur asynchronously to the unmount thread, and hence we n=
eed to<br>
+ * ensure that completes before tearing down the iclogbufs. Hence we need =
to<br>
+ * hold the buffer lock across the log IO to acheive that.<br>
=A0 */<br>
=A0STATIC int<br>
=A0xlog_bdstrat(<br>
@@ -1638,6 +1657,7 @@ xlog_bdstrat(<br>
=A0{<br>
=A0 =A0 =A0 =A0 struct xlog_in_core =A0 =A0 *iclog =3D bp-&gt;b_fspriv;<br>
<br>
+ =A0 =A0 =A0 xfs_buf_lock(bp);<br>
=A0 =A0 =A0 =A0 if (iclog-&gt;ic_state &amp; XLOG_STATE_IOERROR) {<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_buf_ioerror(bp, EIO);<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_buf_stale(bp);<br>
@@ -1645,7 +1665,8 @@ xlog_bdstrat(<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* It would seem logical to return EIO he=
re, but we rely on<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* the log state machine to propagate I/O=
 errors instead of<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* doing it here.<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* doing it here. Similarly, IO completion =
will unlock the<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* buffer, so we don&#39;t do it here.<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;<br>
=A0 =A0 =A0 =A0 }<br>
@@ -1847,14 +1868,28 @@ xlog_dealloc_log(<br>
=A0 =A0 =A0 =A0 xlog_cil_destroy(log);<br>
<br>
=A0 =A0 =A0 =A0 /*<br>
- =A0 =A0 =A0 =A0* always need to ensure that the extra buffer does not poi=
nt to memory<br>
- =A0 =A0 =A0 =A0* owned by another log buffer before we free it.<br>
+ =A0 =A0 =A0 =A0* Cycle all the iclogbuf locks to make sure all log IO com=
pletion<br>
+ =A0 =A0 =A0 =A0* is done before we tear down these buffers.<br>
=A0 =A0 =A0 =A0 =A0*/<br>
+ =A0 =A0 =A0 iclog =3D log-&gt;l_iclog;<br>
+ =A0 =A0 =A0 for (i =3D 0; i &lt; log-&gt;l_iclog_bufs; i++) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_buf_lock(iclog-&gt;ic_bp);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_buf_unlock(iclog-&gt;ic_bp);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 iclog =3D iclog-&gt;ic_next;<br>
+ =A0 =A0 =A0 }<br>
+<br>
+ =A0 =A0 =A0 /*<br>
+ =A0 =A0 =A0 =A0* Always need to ensure that the extra buffer does not poi=
nt to memory<br>
+ =A0 =A0 =A0 =A0* owned by another log buffer before we free it. Also, cyc=
le the lock<br>
+ =A0 =A0 =A0 =A0* first to ensure we&#39;ve completed IO on it.<br>
+ =A0 =A0 =A0 =A0*/<br>
+ =A0 =A0 =A0 xfs_buf_lock(log-&gt;l_xbuf);<br>
+ =A0 =A0 =A0 xfs_buf_unlock(log-&gt;l_xbuf);<br>
=A0 =A0 =A0 =A0 xfs_buf_set_empty(log-&gt;l_xbuf, BTOBB(log-&gt;l_iclog_siz=
e));<br>
=A0 =A0 =A0 =A0 xfs_buf_free(log-&gt;l_xbuf);<br>
<br>
=A0 =A0 =A0 =A0 iclog =3D log-&gt;l_iclog;<br>
- =A0 =A0 =A0 for (i=3D0; i&lt;log-&gt;l_iclog_bufs; i++) {<br>
+ =A0 =A0 =A0 for (i =3D 0; i &lt; log-&gt;l_iclog_bufs; i++) {<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_buf_free(iclog-&gt;ic_bp);<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 next_iclog =3D iclog-&gt;ic_next;<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kmem_free(iclog);<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
1.9.0<br>
<br>
</font></span></blockquote></div><br></div>

--20cf3071cab04eceb904f6c93de9--


--===============8139137913978265035==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8139137913978265035==--
