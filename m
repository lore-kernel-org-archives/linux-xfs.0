Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A6F327F3F
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 07:39:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 476C28F8064
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 05:39:06 -0700 (PDT)
Received: from mail-wi0-f176.google.com (mail-wi0-f176.google.com
	[209.85.212.176]) by cuda.sgi.com with ESMTP id
	NGbryybMz9D3K9my (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 12 Aug 2014 05:39:04 -0700 (PDT)
Received: by mail-wi0-f176.google.com with SMTP id bs8so5781754wib.3
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 05:39:02 -0700 (PDT)
Message-ID: <DC407F6E8F8C4EE1AF7117D7D6ABF282@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
References: <CAOcd+r0R6KxmgEJNPUZ0Q5cQhsStGb=cehYE0+wKgDNU1negsA@mail.gmail.com>
	<20140119231745.GF18112@dastard>
	<4B2A412C75324EE9880358513C069476@alyakaslap>
	<9D3CBECB663B4A77B7EF74B67973310A@alyakaslap>
	<20140804230721.GA20518@dastard>
	<AC10852F403846A182491ED8071135ED@alyakaslap>
	<20140806152042.GB39990@bfoster.bfoster>
	<CAOcd+r3bC59m7Rh-3tmjrnWnF5XoPQfE=U+=hz78NcAGu+Ou1g@mail.gmail.com>
	<20140811132057.GA1186@bfoster.bfoster>
	<20140811215207.GS20518@dastard>
	<20140812120341.GA46654@bfoster.bfoster>
In-Reply-To: <20140812120341.GA46654@bfoster.bfoster>
Subject: Re: use-after-free on log replay failure
Date: Tue, 12 Aug 2014 15:39:02 +0300
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0039_01CFB643.8B14BD50"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.

------=_NextPart_000_0039_01CFB643.8B14BD50
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit

Hello Dave, Brian,
I will describe a generic reproduction that you ask for.

It was performed on pristine XFS code from 3.8.13, taken from here:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git

top commit being:
commit dbf932a9b316d5b29b3e220e5a30e7a165ad2992
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Sat May 11 13:57:46 2013 -0700

    Linux 3.8.13


I made a single (I swear!) code change in XFS:

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 96fcbb8..d756bf6 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3736,6 +3736,9 @@ xlog_recover(
        if ((error = xlog_find_tail(log, &head_blk, &tail_blk)))
                return error;

+       xfs_notice(log->l_mp, "Sleep 10s before xlog_do_recover");
+       msleep(10000);
+
        if (tail_blk != head_blk) {
                /* There used to be a comment here:
                 *

Fresh XFS was formatted on a 20 GB block device within a VM, using:
mkfs.xfs -f -K /dev/vde -p /etc/zadara/xfs.protofile
and:
root@vc-00-00-1383-dev:~# cat /etc/zadara/xfs.protofile
dummy                   : bootfilename, not used, backward compatibility
0 0                             : numbers of blocks and inodes, not used, 
backward compatibility
d--777 0 0              : set 777 perms for the root dir
$
$

I mounted XFS with the following options:
rw,sync,noatime,wsync,attr2,inode64,noquota 0 0

I started a couple of processes writing files sequentially onto this mount 
point, and after few seconds crashed the VM.
When the VM came up, I took the metadump file and placed it in:
https://drive.google.com/file/d/0ByBy89zr3kJNa0ZpdmZFS242RVU/edit?usp=sharing

Then I set up the following Device Mapper target onto /dev/vde:
dmsetup create VDE --table "0 41943040 linear-custom /dev/vde 0"
I am attaching the code (and Makefile) of dm-linear-custom target. It is 
exact copy of dm-linear, except that it has a module parameter. With the 
parameter set to 0, this is an identity mapping onto /dev/vde. If the 
parameter is set to non-0, all WRITE bios are failed with ENOSPC. There is a 
workqueue to fail them in a different context (not sure if really needed, 
but that's what our "real" custom
block device does).

Now I did:
mount -o noatime,sync /dev/mapper/VDE /mnt/xfs

The log recovery flow went into the sleep that I added, and then I did:
echo 1 > /sys/module/dm_linear_custom/parameters/fail_writes

Problem reproduced:
Aug 12 14:23:04 vc-00-00-1383-dev kernel: [  175.000657] XFS (dm-0): 
Mounting Filesystem
Aug 12 14:23:04 vc-00-00-1383-dev kernel: [  175.026991] XFS (dm-0): Sleep 
10s before xlog_do_recover
Aug 12 14:23:14 vc-00-00-1383-dev kernel: [  185.028113] XFS (dm-0): 
Starting recovery (logdev: internal)
Aug 12 14:23:18 vc-00-00-1383-dev kernel: [  188.556622] XFS (dm-0): 
metadata I/O error: block 0x2 ("xlog_recover_iodone") error 28 numblks 1
Aug 12 14:23:18 vc-00-00-1383-dev kernel: [  188.556675] XFS (dm-0): 
metadata I/O error: block 0x40 ("xlog_recover_iodone") error 28 numblks 16
Aug 12 14:23:18 vc-00-00-1383-dev kernel: [  188.556680] XFS (dm-0): 
xfs_do_force_shutdown(0x1) called from line 377 of file 
/mnt/work/alex/linux-stable/source/fs/xfs/xfs_log_recover.c.  Return address 
= 0xffffffffa0349f68
Aug 12 14:23:18 vc-00-00-1383-dev kernel: [  188.556683] XFS (dm-0): I/O 
Error Detected. Shutting down filesystem
Aug 12 14:23:18 vc-00-00-1383-dev kernel: [  188.556684] XFS (dm-0): Please 
umount the filesystem and rectify the problem(s)
Aug 12 14:23:18 vc-00-00-1383-dev kernel: [  188.556766] XFS (dm-0): 
metadata I/O error: block 0xa00002 ("xlog_recover_iodone") error 5 numblks 1
Aug 12 14:23:18 vc-00-00-1383-dev kernel: [  188.556769] XFS (dm-0): 
xfs_do_force_shutdown(0x1) called from line 377 of file 
/mnt/work/alex/linux-stable/source/fs/xfs/xfs_log_recover.c.  Return address 
= 0xffffffffa0349f68
Aug 12 14:23:18 vc-00-00-1383-dev kernel: [  188.556771] XFS (dm-0): 
metadata I/O error: block 0xa00008 ("xlog_recover_iodone") error 5 numblks 8
Aug 12 14:23:18 vc-00-00-1383-dev kernel: [  188.556774] XFS (dm-0): 
xfs_do_force_shutdown(0x1) called from line 377 of file 
/mnt/work/alex/linux-stable/source/fs/xfs/xfs_log_recover.c.  Return address 
= 0xffffffffa0349f68
Aug 12 14:23:18 vc-00-00-1383-dev kernel: [  188.556776] XFS (dm-0): 
metadata I/O error: block 0xa00010 ("xlog_recover_iodone") error 5 numblks 8
Aug 12 14:23:18 vc-00-00-1383-dev kernel: [  188.556779] XFS (dm-0): 
xfs_do_force_shutdown(0x1) called from line 377 of file 
/mnt/work/alex/linux-stable/source/fs/xfs/xfs_log_recover.c.  Return address 
= 0xffffffffa0349f68
Aug 12 14:23:18 vc-00-00-1383-dev kernel: [  188.556781] XFS (dm-0): 
metadata I/O error: block 0xa00018 ("xlog_recover_iodone") error 5 numblks 8
Aug 12 14:23:18 vc-00-00-1383-dev kernel: [  188.556783] XFS (dm-0): 
xfs_do_force_shutdown(0x1) called from line 377 of file 
/mnt/work/alex/linux-stable/source/fs/xfs/xfs_log_recover.c.  Return address 
= 0xffffffffa0349f68
Aug 12 14:23:18 vc-00-00-1383-dev kernel: [  188.556785] XFS (dm-0): 
metadata I/O error: block 0xa00040 ("xlog_recover_iodone") error 5 numblks 
16
Aug 12 14:23:18 vc-00-00-1383-dev kernel: [  188.556788] XFS (dm-0): 
xfs_do_force_shutdown(0x1) called from line 377 of file 
/mnt/work/alex/linux-stable/source/fs/xfs/xfs_log_recover.c.  Return address 
= 0xffffffffa0349f68
Aug 12 14:23:18 vc-00-00-1383-dev kernel: [  188.556790] XFS (dm-0): 
metadata I/O error: block 0xa00050 ("xlog_recover_iodone") error 5 numblks 
16
Aug 12 14:23:18 vc-00-00-1383-dev kernel: [  188.556793] XFS (dm-0): 
xfs_do_force_shutdown(0x1) called from line 377 of file 
/mnt/work/alex/linux-stable/source/fs/xfs/xfs_log_recover.c.  Return address 
= 0xffffffffa0349f68
Aug 12 14:23:18 vc-00-00-1383-dev kernel: [  188.556880] XFS (dm-0): 
metadata I/O error: block 0xa00001 ("xlog_recover_iodone") error 28 numblks 
1
Aug 12 14:23:18 vc-00-00-1383-dev kernel: [  188.556884] XFS (dm-0): 
xfs_do_force_shutdown(0x1) called from line 377 of file 
/mnt/work/alex/linux-stable/source/fs/xfs/xfs_log_recover.c.  Return address 
= 0xffffffffa0349f68
Aug 12 14:23:18 vc-00-00-1383-dev kernel: [  188.556977] XFS (dm-0): log 
mount/recovery failed: error 28
Aug 12 14:23:18 vc-00-00-1383-dev kernel: [  188.557215] XFS (dm-0): log 
mount failed
Aug 12 14:23:18 vc-00-00-1383-dev kernel: [  188.573194] XFS (): 
xfs_do_force_shutdown(0x1) called from line 377 of file 
/mnt/work/alex/linux-stable/source/fs/xfs/xfs_log_recover.c.  Return address 
= 0xffffffffa0349f68
Aug 12 14:23:18 vc-00-00-1383-dev kernel: [  188.573214] XFS (): metadata 
I/O error: block 0x18 ("xlog_recover_iodone") error 28 numblks 8
Aug 12 14:23:18 vc-00-00-1383-dev kernel: [  188.574685] XFS (): 
xfs_do_force_shutdown(0x1) called from line 377 of file 
/mnt/work/alex/linux-stable/source/fs/xfs/xfs_log_recover.c.  Return address 
= 0xffffffffa0349f68

As you see, after mount completes, IO callbacks are still arriving and 
printing junk (empty string in this case). Immediately after that kernel 
dies.

Is this description generic enough?

Thanks,
Alex.




-----Original Message----- 
From: Brian Foster
Sent: 12 August, 2014 3:03 PM
To: Dave Chinner
Cc: Alex Lyakas ; xfs@oss.sgi.com
Subject: Re: use-after-free on log replay failure

On Tue, Aug 12, 2014 at 07:52:07AM +1000, Dave Chinner wrote:
> On Mon, Aug 11, 2014 at 09:20:57AM -0400, Brian Foster wrote:
> > On Sun, Aug 10, 2014 at 03:20:50PM +0300, Alex Lyakas wrote:
> > > On Wed, Aug 6, 2014 at 6:20 PM, Brian Foster <bfoster@redhat.com> 
> > > wrote:
> > > > On Wed, Aug 06, 2014 at 03:52:03PM +0300, Alex Lyakas wrote:
> .....
> > > >> But I believe, my analysis shows that during the mount sequence XFS 
> > > >> does not
> > > >> wait properly for all the bios to complete, before failing the 
> > > >> mount
> > > >> sequence back to the caller.
> > > >>
> > > >
> > > > As an experiment, what about the following? Compile tested only and 
> > > > not
> > > > safe for general use.
> ...
> > > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > > index cd7b8ca..fbcf524 100644
> > > > --- a/fs/xfs/xfs_buf.c
> > > > +++ b/fs/xfs/xfs_buf.c
> > > > @@ -1409,19 +1409,27 @@ xfs_buf_iorequest(
> > > >   * case nothing will ever complete.  It returns the I/O error code, 
> > > > if any, or
> > > >   * 0 if there was no error.
> > > >   */
> > > > -int
> > > > -xfs_buf_iowait(
> > > > -       xfs_buf_t               *bp)
> > > > +static int
> > > > +__xfs_buf_iowait(
> > > > +       struct xfs_buf          *bp,
> > > > +       bool                    skip_error)
> > > >  {
> > > >         trace_xfs_buf_iowait(bp, _RET_IP_);
> > > >
> > > > -       if (!bp->b_error)
> > > > +       if (skip_error || !bp->b_error)
> > > >                 wait_for_completion(&bp->b_iowait);
> > > >
> > > >         trace_xfs_buf_iowait_done(bp, _RET_IP_);
> > > >         return bp->b_error;
> > > >  }
> > > >
> > > > +int
> > > > +xfs_buf_iowait(
> > > > +       struct xfs_buf          *bp)
> > > > +{
> > > > +       return __xfs_buf_iowait(bp, false);
> > > > +}
> > > > +
> > > >  xfs_caddr_t
> > > >  xfs_buf_offset(
> > > >         xfs_buf_t               *bp,
> > > > @@ -1866,7 +1874,7 @@ xfs_buf_delwri_submit(
> > > >                 bp = list_first_entry(&io_list, struct xfs_buf, 
> > > > b_list);
> > > >
> > > >                 list_del_init(&bp->b_list);
> > > > -               error2 = xfs_buf_iowait(bp);
> > > > +               error2 = __xfs_buf_iowait(bp, true);
> > > >                 xfs_buf_relse(bp);
> > > >                 if (!error)
> > > >                         error = error2;
>
> Not waiting here on buffer error should not matter. Any buffer that
> is under IO and requires completion should be referenced, and that
> means it should be caught and waited on by xfs_wait_buftarg() in the
> mount failure path after log recovery fails.
>

I think that assumes the I/O is successful. Looking through
xlog_recover_buffer_pass2() as an example, we read the buffer which
should return with b_hold == 1. The delwri queue increments the hold and
we xfs_buf_relse() in the return path (i.e., buffer is now held by the
delwri queue awaiting submission).

Sometime later we delwri_submit()... xfs_buf_iorequest() does an
xfs_buf_hold() and xfs_buf_rele() within that single function. The
delwri_submit() releases its hold after xfs_buf_iowait(), which I guess
at that point bp should go onto the lru (b_hold back to 1 in
xfs_buf_rele(). Indeed, the caller has lost scope of the buffer at this
point.

So unless I miss something or got the lifecycle wrong here, which is
easily possible ;), this all hinges on xfs_buf_iowait(). That's where
the last hold forcing the buffer to stay around goes away.
xfs_buftarg_wait_rele() will dispose the buffer if b_hold == 1. If
xfs_buf_iowait() is racy in the event of I/O errors via the bio
callback, I think this path is susceptible just the same.

> > > > ---
> > > I think that this patch fixes the problem. I tried reproducing it like
> > > 30 times, and it doesn't happen with this patch. Dropping this patch
> > > reproduces the problem within 1 or 2 tries. Thanks!
> > > What are next steps? How to make it "safe for general use"?
> > >
> >
> > Ok, thanks for testing. I think that implicates the caller bypassing the
> > expected blocking with the right sequence of log recovery I/Os and
> > device failure. TBH, I'd still like to see the specifics, if possible.
> > Could you come up with a generic reproducer for this? I think a metadump
> > of the fs with the dirty log plus whatever device failure simulation
> > hack you're using would suffice.
>
> The real issue is we don't know exactly what code is being tested
> (it's 3.8 + random bug fix backports + custom code). Even if we have
> a reproducer there's no guarantee it will reproduce on a current
> kernel. IOWs, we are stumbling around in the dark bashing our heads
> against everything in the room, and that just wastes everyone's
> time.
>
> We need a reproducer that triggers on a current, unmodified
> kernel release. You can use dm-faulty to error out all writes just
> like you are doing with your custom code. See
> xfstests::tests/generic/321 and common/dmflakey for to do this.
> Ideally the reproducer is in a form that xfstests can use....
>
> If you can't reproduce it on an upstream kernel, then git bisect is
> your friend. It will find the commit that fixed the problem you are
> seeing....
>

Ugh, yeah. The fact that this was customized as such apparently went
over my head. I agree completely. This needs to be genericized to a
pristine, preferably current kernel. The experiment patch could be
papering over something completely different.

> > The ideal fix is not yet clear to me.
>
> We are not even that far along - the root cause of the bug is not at
> all clear to me. :/
>

Yeah.. the above was just the theory that motivated the experiment in
the previously posted patch. It of course remains a theory until we can
see the race in action. I was referring to the potential fix for the
raciness of xfs_buf_iowait() with regard to bio errors and the wq iodone
handling, while still asking for a reproducer to confirm the actual
problem. FWIW, I'm not too high on changes in the buf management code,
even a smallish behavior change, without a real trace of some sort that
documents the problem and justifies the change.

Brian

> Cheers,
>
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com 

------=_NextPart_000_0039_01CFB643.8B14BD50
Content-Type: application/octet-stream;
	name="dm-linear-custom.c"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dm-linear-custom.c"

/*=0A=
 * Copyright (C) 2001-2003 Sistina Software (UK) Limited.=0A=
 *=0A=
 * This file is released under the GPL.=0A=
 */=0A=
=0A=
#include <linux/module.h>=0A=
#include <linux/init.h>=0A=
#include <linux/blkdev.h>=0A=
#include <linux/bio.h>=0A=
#include <linux/slab.h>=0A=
#include <linux/device-mapper.h>=0A=
=0A=
#define DM_MSG_PREFIX "linear-custom"=0A=
=0A=
/*=0A=
 * Linear: maps a linear range of a device.=0A=
 */=0A=
struct linear_c {=0A=
	struct dm_dev *dev;=0A=
	sector_t start;=0A=
};=0A=
=0A=
unsigned int fail_writes =3D 0;=0A=
module_param_named(fail_writes, fail_writes, uint, S_IWUSR|S_IRUSR | =
S_IRGRP | S_IROTH);=0A=
MODULE_PARM_DESC(fail_writes, "When set to non-0, all writes will be =
failed with ENOSPC");=0A=
=0A=
static struct workqueue_struct *fail_writes_wq;=0A=
=0A=
struct fail_writes_work {=0A=
	struct work_struct work;=0A=
	struct bio *bio;=0A=
};=0A=
=0A=
/*=0A=
 * Construct a linear mapping: <dev_path> <offset>=0A=
 */=0A=
static int linear_ctr(struct dm_target *ti, unsigned int argc, char =
**argv)=0A=
{=0A=
	struct linear_c *lc;=0A=
	unsigned long long tmp;=0A=
	char dummy;=0A=
=0A=
	if (argc !=3D 2) {=0A=
		ti->error =3D "Invalid argument count";=0A=
		return -EINVAL;=0A=
	}=0A=
=0A=
	lc =3D kmalloc(sizeof(*lc), GFP_KERNEL);=0A=
	if (lc =3D=3D NULL) {=0A=
		ti->error =3D "dm-linear: Cannot allocate linear context";=0A=
		return -ENOMEM;=0A=
	}=0A=
=0A=
	if (sscanf(argv[1], "%llu%c", &tmp, &dummy) !=3D 1) {=0A=
		ti->error =3D "dm-linear: Invalid device sector";=0A=
		goto bad;=0A=
	}=0A=
	lc->start =3D tmp;=0A=
=0A=
	if (dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &lc->dev)) =
{=0A=
		ti->error =3D "dm-linear: Device lookup failed";=0A=
		goto bad;=0A=
	}=0A=
=0A=
	ti->num_flush_requests =3D 1;=0A=
	ti->num_discard_requests =3D 1;=0A=
	ti->num_write_same_requests =3D 1;=0A=
	ti->private =3D lc;=0A=
	return 0;=0A=
=0A=
      bad:=0A=
	kfree(lc);=0A=
	return -EINVAL;=0A=
}=0A=
=0A=
static void linear_dtr(struct dm_target *ti)=0A=
{=0A=
	struct linear_c *lc =3D (struct linear_c *) ti->private;=0A=
=0A=
	dm_put_device(ti, lc->dev);=0A=
	kfree(lc);=0A=
}=0A=
=0A=
static sector_t linear_map_sector(struct dm_target *ti, sector_t =
bi_sector)=0A=
{=0A=
	struct linear_c *lc =3D ti->private;=0A=
=0A=
	return lc->start + dm_target_offset(ti, bi_sector);=0A=
}=0A=
=0A=
static void linear_map_bio(struct dm_target *ti, struct bio *bio)=0A=
{=0A=
	struct linear_c *lc =3D ti->private;=0A=
=0A=
	bio->bi_bdev =3D lc->dev->bdev;=0A=
	if (bio_sectors(bio))=0A=
		bio->bi_sector =3D linear_map_sector(ti, bio->bi_sector);=0A=
}=0A=
=0A=
void linear_fail_write(struct work_struct *work)=0A=
{=0A=
	struct fail_writes_work *w =3D container_of(work, struct =
fail_writes_work, work);=0A=
=0A=
	bio_endio(w->bio, -ENOSPC);=0A=
	kfree(w);=0A=
}=0A=
=0A=
static int linear_map(struct dm_target *ti, struct bio *bio)=0A=
{=0A=
	if (bio_rw(bio)=3D=3D WRITE && fail_writes) {=0A=
		struct fail_writes_work *w =3D kmalloc(sizeof(struct =
fail_writes_work), GFP_NOIO);=0A=
		if (w) {=0A=
			bool queued =3D false;=0A=
=0A=
			INIT_WORK(&w->work, linear_fail_write);=0A=
			w->bio =3D bio;=0A=
			queued =3D queue_work(fail_writes_wq, &w->work);=0A=
			if (queued)=0A=
				return DM_MAPIO_SUBMITTED;=0A=
=0A=
			kfree(w);=0A=
		}=0A=
	}=0A=
=0A=
	linear_map_bio(ti, bio);=0A=
=0A=
	return DM_MAPIO_REMAPPED;=0A=
}=0A=
=0A=
static void linear_status(struct dm_target *ti, status_type_t type,=0A=
			  unsigned status_flags, char *result, unsigned maxlen)=0A=
{=0A=
	struct linear_c *lc =3D (struct linear_c *) ti->private;=0A=
=0A=
	switch (type) {=0A=
	case STATUSTYPE_INFO:=0A=
		result[0] =3D '\0';=0A=
		break;=0A=
=0A=
	case STATUSTYPE_TABLE:=0A=
		snprintf(result, maxlen, "%s %llu", lc->dev->name,=0A=
				(unsigned long long)lc->start);=0A=
		break;=0A=
	}=0A=
}=0A=
=0A=
static int linear_ioctl(struct dm_target *ti, unsigned int cmd,=0A=
			unsigned long arg)=0A=
{=0A=
	struct linear_c *lc =3D (struct linear_c *) ti->private;=0A=
	struct dm_dev *dev =3D lc->dev;=0A=
	int r =3D 0;=0A=
=0A=
	/*=0A=
	 * Only pass ioctls through if the device sizes match exactly.=0A=
	 */=0A=
	if (lc->start ||=0A=
	    ti->len !=3D i_size_read(dev->bdev->bd_inode) >> SECTOR_SHIFT)=0A=
		r =3D scsi_verify_blk_ioctl(NULL, cmd);=0A=
=0A=
	return r ? : __blkdev_driver_ioctl(dev->bdev, dev->mode, cmd, arg);=0A=
}=0A=
=0A=
static int linear_merge(struct dm_target *ti, struct bvec_merge_data =
*bvm,=0A=
			struct bio_vec *biovec, int max_size)=0A=
{=0A=
	struct linear_c *lc =3D ti->private;=0A=
	struct request_queue *q =3D bdev_get_queue(lc->dev->bdev);=0A=
=0A=
	if (!q->merge_bvec_fn)=0A=
		return max_size;=0A=
=0A=
	bvm->bi_bdev =3D lc->dev->bdev;=0A=
	bvm->bi_sector =3D linear_map_sector(ti, bvm->bi_sector);=0A=
=0A=
	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));=0A=
}=0A=
=0A=
static int linear_iterate_devices(struct dm_target *ti,=0A=
				  iterate_devices_callout_fn fn, void *data)=0A=
{=0A=
	struct linear_c *lc =3D ti->private;=0A=
=0A=
	return fn(ti, lc->dev, lc->start, ti->len, data);=0A=
}=0A=
=0A=
static struct target_type linearc_target =3D {=0A=
	.name   =3D "linear-custom",=0A=
	.version =3D {1, 2, 1},=0A=
	.module =3D THIS_MODULE,=0A=
	.ctr    =3D linear_ctr,=0A=
	.dtr    =3D linear_dtr,=0A=
	.map    =3D linear_map,=0A=
	.status =3D linear_status,=0A=
	.ioctl  =3D linear_ioctl,=0A=
	.merge  =3D linear_merge,=0A=
	.iterate_devices =3D linear_iterate_devices,=0A=
};=0A=
=0A=
int dm_linear_custom_init(void)=0A=
{=0A=
	int r =3D 0;=0A=
=0A=
	DMINFO("Going to register target: %s", linearc_target.name);=0A=
	r =3D dm_register_target(&linearc_target);=0A=
	if (r < 0) {=0A=
		DMERR("register failed %d", r);=0A=
		goto out;=0A=
	}=0A=
=0A=
	fail_writes_wq =3D alloc_workqueue("dm_linear_custom_fail_writes_WQ",=0A=
		WQ_NON_REENTRANT | WQ_UNBOUND | WQ_MEM_RECLAIM, =0A=
		0/*max_active*/);=0A=
	if (fail_writes_wq =3D=3D NULL) {=0A=
		r =3D -ENOMEM;=0A=
		goto out_unreg_target;=0A=
	}=0A=
=0A=
	return 0;=0A=
=0A=
out_unreg_target:=0A=
	dm_unregister_target(&linearc_target);=0A=
out:=0A=
	return r;=0A=
}=0A=
=0A=
void dm_linear_custom_exit(void)=0A=
{=0A=
	if (fail_writes_wq) {=0A=
		/* actually destroy_workqueue() also does drain_workqueue */=0A=
		flush_workqueue(fail_writes_wq);=0A=
		destroy_workqueue(fail_writes_wq);=0A=
		fail_writes_wq =3D NULL;=0A=
	}=0A=
=0A=
	dm_unregister_target(&linearc_target);=0A=
}=0A=
=0A=
module_init(dm_linear_custom_init);=0A=
module_exit(dm_linear_custom_exit);=0A=
=0A=
MODULE_AUTHOR("Zadara Storage <team@zadarastorage.com>");=0A=
MODULE_DESCRIPTION("A modified dm-linear for BrianF");=0A=
MODULE_LICENSE("GPL");=0A=
=0A=

------=_NextPart_000_0039_01CFB643.8B14BD50
Content-Type: application/octet-stream;
	name="Makefile"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="Makefile"

obj-m +=3D dm-linear-custom.o=0A=
=0A=
ccflags-y +=3D -Wall 			# Enable most warning messages=0A=
ccflags-y +=3D -Werror		# Error out the compiler on warnings=0A=
=0A=
KVERSION =3D $(shell uname -r)=0A=
DM_LC_DIR=3D$(shell pwd)=0A=
DM_LC_KO=3Ddm-linear-custom.ko=0A=
=0A=
default:=0A=
	$(MAKE) -C /lib/modules/$(KVERSION)/build M=3D$(DM_LC_DIR) =
EXTRA_CFLAGS=3D-g modules=0A=
=0A=
clean:=0A=
	$(MAKE) -C /lib/modules/$(KVERSION)/build M=3D$(DM_LC_DIR) clean=0A=
=0A=
=0A=

------=_NextPart_000_0039_01CFB643.8B14BD50
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

------=_NextPart_000_0039_01CFB643.8B14BD50--
