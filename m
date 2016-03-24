Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BD9757CA0
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 11:52:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 654D2304053
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 09:52:49 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ChtSRyO7iFylbpGD (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 24 Mar 2016 09:52:47 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 3E6B5804EC
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 16:52:47 +0000 (UTC)
Received: from redhat.com (dhcp-26-103.brq.redhat.com [10.34.26.103])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u2OGqior011720
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 12:52:46 -0400
Date: Thu, 24 Mar 2016 17:52:44 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: XFS hung task in xfs_ail_push_all_sync() when unmounting FS
	after disk failure/recovery
Message-ID: <20160324165244.GA17555@redhat.com>
References: <f049419a2ab10f8e3c4fef0e4f4ca1ba@mail.gmail.com>
	<20160322121922.GA53693@bfoster.bfoster>
	<6457b1d9de271ec6cca6bc2626aac161@mail.gmail.com>
	<20160322140345.GA54245@bfoster.bfoster>
	<0f3832c45509f444f55fda2aaf9c9deb@mail.gmail.com>
	<20160323123010.GA43073@bfoster.bfoster>
	<20160323153221.GA19456@redhat.com>
	<20160323223747.GX30721@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160323223747.GX30721@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

I can now reproduce it, or at least part of the problem.

Regarding your question Dave, yes, it can be unmounted after I issue xfs_io=
 shutdown
command. But, if a umount is issued before that, then we can't find the
mountpoint anymore.

I'm not sure if I'm correct, but, what it looks like to me, as you already
mentioned, is that we keep getting IO errors but we never actually shutdown
the filesystem while doing async metadata writes.

I believe I've found the problem. So, I will try to explain it, so you guys
can review and let me know if I'm right or not

I was looking the code, and for me, looks like async retries are designed to
keep retrying forever, and rely on some other part of the filesystem to act=
ually
shutdown it.

I tested this hypothesis trying to issue some other IO after the messages b=
elow
starts to be logged with trace_xfs_buf_ioerror turned on, And before actual=
ly
umount the filesystem.

And yes, the filesystem has been shutdown after some extra IO (IO errors
returned of course).

But, if we try to unmount, we can't issue any other IO, since we loose the
mountpoint.

I apologize if my description is confusing, I'm not the best person organiz=
ing
ideas, but, feel free to ask me any question.




When I reproduce the problem, I can see these two messages being written to
kernel:

[   59.914938] XFS (dm-0): metadata I/O error: block 0x0
("xfs_buf_iodone_callbacks") error 5 numblks 1

[   59.964831] XFS (dm-0): Failing async write on buffer block
0xffffffffffffffff. Retrying async write.


Looking through the code, looks like inside xfs_buf_iodone_callbacks(), we
expect the filesystem to be put down somewhere else, and then stop retrying:

        /*
        =A6* If we've already decided to shutdown the filesystem because of
        =A6* I/O errors, there's no point in giving this a retry.
        =A6*/
        if (XFS_FORCED_SHUTDOWN(mp)) {


And so, since we are in ASYNC writes here, we fall in:

if (bp->b_flags & XBF_ASYNC) {

Where, we will clear bp->b_error and set XBF_WRITE_FAIL flag in the buffer,
and submit the buffer for IO.


xfs_buf_ioerror(bp, 0); /* errno of 0 unsets the flag */

if (!(bp->b_flags & (XBF_STALE|XBF_WRITE_FAIL))) {
                        bp->b_flags |=3D XBF_WRITE | XBF_ASYNC |
                                =A6      XBF_DONE | XBF_WRITE_FAIL;
                        xfs_buf_submit(bp);


So the buffer flag is set with XBF_WRITE_FAIL and IO submitted.

In xfs_buf_submit():

We clear the io_error, if any:

bp->b_io_error =3D 0;

Then, we send buffer for IO via _xfs_buf_ioapply():

atomic_set(&bp->b_io_remaining, 1);
_xfs_buf_ioapply(bp);

At _xfs_buf_ioapply, we clear buffer errors:

bp->b_error =3D 0;

Then call:  xfs_buf_ioapply_map()

Where we actually setup the bio and send it to block layer, where
such status is captured by xfs_buf_bio_end_io()

--- done, buffer has been sent for IO ---


Now, inside xfs_buf_bio_end_io():

Since we receive an IO error here, we set bp->b_io_error:

bp->b_io_error =3D bio->bi_error

I did no reads here, so we skip until:

if (atomic_dec_and_test(&bp->b_io_remaining) =3D=3D 1)
        xfs_buf_ioend_async(bp);


Workqueue starts to handle the IO completion where we call xfS_buf_ioend():


At xfs_buf_ioend(), we catch the I/O error here, and set bp->berror accordi=
ngly:

If (!bp->b_error && bp->b_io_error)
        xfs_buf_ioerror(bp, bp->b_io_error);

and we have one of the traces being logged:

kworker/1:2-1294  [001] .... 11814.953710: xfs_buf_ioerror: dev 253:0 bno
0xffffffffffffffff len 0x200 hold 3 pincount 0 lock 0 error -5 flags
ASYNC|DONE|PAGES caller xfs_buf_ioend_work

Since it's an inode, we have iodone set to xfs_buf_iodone_callbacks() and c=
all
it here:

  if (bp->b_iodone)
                (*(bp->b_iodone))(bp);


At xfs_buf_iodone_callbacks:


bp->berror is set, so we do not skip until do_callbacks label.

        if (likely(!bp->b_error))
                goto do_callbacks;


we call xfs_buf_ioerror_alert() here, and then we have logged:

[15063.857999] XFS (dm-0): metadata I/O error: block 0x0
("xfs_buf_iodone_callbacks") error 5 numblks 1



So, we reach again:

if (bp->b_flags & XBF_ASYNC) {

and again, we clear the error here:

xfs_buf_ioerror(bp, 0); =


Issuing this trace:

     kworker/1:2-1294  [001] .... 11814.953711: xfs_buf_ioerror: dev 253:0 =
bno
0xffffffffffffffff len 0x200 hold 3 pincount 0 lock 0 error 0 flags
ASYNC|DONE|PAGES caller xfs_buf_iodone_callbacks

and submit the buffer again, restarting the process.




Looks like, somebody already noticed it:

        /*
        =A6* If the write was asynchronous then no one will be looking for =
the
        =A6* error.  Clear the error state and write the buffer out again.
        =A6*
        =A6* XXX: This helps against transient write errors, but we need to=
 find
        =A6* a way to shut the filesystem down if the writes keep failing.
        =A6*
        =A6* In practice we'll shut the filesystem down soon as non-transie=
nt
        =A6* errors tend to affect the whole device and a failing log write
        =A6* will make us give up.  But we really ought to do better here.
        =A6*/




So, if I'm write in how we hit this problem, and IIRC, Dave's patchset for
setting limits to IO errors can be slightly modified to fix this issue too,=
 but,
the problem is that the user must set it BEFORE he tries to unmount the
filesystem, otherwise it will get stuck here.

IMHO, we maybe need to fix it during the umount process, so, despite how the
error handler is set (using Dave's patchset), or in the current situation (=
try
forever), unmount process does not lockup because of this.

I wrote a "hacky" patch to notify buf_iodone_callback that the filesystem w=
as
being unmounted, and stop retrying. I'm not sure if it's a good solution, b=
ut,
I'll send the patch to at least log it in the mailing list and keep the
discussion.


Sorry for the long e-mail, hope it was at least useful :)

Cheers


On Thu, Mar 24, 2016 at 09:37:47AM +1100, Dave Chinner wrote:
> On Wed, Mar 23, 2016 at 04:32:21PM +0100, Carlos Maiolino wrote:
> > I'm still trying to get a reliable reproducer, at least exactly with wh=
at I have
> > seen a few days ago.
> > =

> > Shyam, could you try to reproduce it with a recent/upstream kernel? Tha=
t would
> > be great to make sure we have been seen the same issue.
> > =

> > AFAICT, it happens in the following situation:
> > =

> > 1 - Something is written to the filesystem
> > 2 - log checkpoint is done for the previous write
> > 3 - Disk failure
> > 4 - XFS tries to writeback metadata logged in [2]
> > =

> > When [4] happens, I can't trigger xfs_log_force messages all the time, =
most of
> > time I just get an infinite loop in these messages:
> > =

> > [12694.318109] XFS (dm-0): Failing async write on buffer block
> > 0xffffffffffffffff. Retrying async write.
> >
> > Sometimes I can trigger the xfs_log_force() loop.
> =

> This all smells like the filesystem is getting IO errors but it not
> in a shutdown state. What happens when you run 'xfs_io -x -c
> "shutdown" /mnt/pt' on a filesystem in this state? Can you then
> unmount it?
> =

> Cheers,
> =

> Dave.
> -- =

> Dave Chinner
> david@fromorbit.com
> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- =

Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
