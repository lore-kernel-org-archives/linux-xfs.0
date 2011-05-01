Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p41IQUwV187585 for <xfs@oss.sgi.com>; Sun, 1 May 2011 13:26:30 -0500
Received: from mail.ud10.udmedia.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 22581424948
	for <xfs@oss.sgi.com>; Sun,  1 May 2011 11:30:02 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id latbYEaHzhi2X5gp for
	<xfs@oss.sgi.com>; Sun, 01 May 2011 11:30:02 -0700 (PDT)
Date: Sun, 1 May 2011 20:24:42 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: xfs performance problem
Message-ID: <20110501182442.GA1635@x4.trippels.de>
References: <4DB72084.8020205@inf.ethz.ch> <20110427023534.GF12436@dastard>
	<201104291827.35801.Martin@lichtvoll.de>
	<20110501085246.GF13542@dastard>
	<20110501165546.GB5391@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110501165546.GB5391@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 2011.05.01 at 12:55 -0400, Christoph Hellwig wrote:
> On Sun, May 01, 2011 at 06:52:46PM +1000, Dave Chinner wrote:
> > > > more than likely your problem is that barriers have been enabled for
> > > > MD/DM devices on the new kernel, and they aren't on the old kernel.
> > > > XFS uses barriers by default, ext3 does not. Hence XFS performance
> > > > will change while ext3 will not. Check dmesg output when mounting
> > > > the filesystems on the different kernels.
> > > =

> > > But didn't 2.6.38 replace barriers by explicit flushes the filesystem=
 has to =

> > > wait for - mitigating most of the performance problems with barriers?
> > =

> > IIRC, it depends on whether the hardware supports FUA or not. If it
> > doesn't then device cache flushes are used to emulate FUA and so
> > performance can still suck. Christoph will no doubt correct me if I
> > got that wrong ;)
> =

> Mitigating most of the barrier performance issues is a bit of a strong
> word.  Yes, it remove useless ordering requirements, but fundamentally
> you still have to flush the disk cache to the physical medium, which
> is always going to be slower than just filling up a DRAM cache like
> ext3's default behaviour in mainline does (interestingly both SLES
> and RHEL have patched it to provide safe behaviour by default).
> =

> Both the old barrier and new flush code will use the FUA bit if
> available, and those optimize the post-flush for a log write out.
> Note that currently libata by default always disables FUA support,
> even if the disk supports it, so you'll need a SAS/FC/iSCSI/etc
> device to actually see FUA requests, which is quite sad as it
> should provide a nice speedup epecially for SATA where the cache
> flush command is not queueable and thus requires us to still
> drain any outstanding I/O at least for a short duration.

I've recently asked on the IDE list why FUA is disabled by default in
libata and this is what Tejun Heo had to say (calling it a misfeature):

http://article.gmane.org/gmane.linux.ide/48954

Quote:
=BBThe way flushes are used by filesystems is that FUA is usually only
used right after another FLUSH.  ie. Using FUA replaces FLUSH + commit
block write + FLUSH sequence to FLUSH + FUA commit block write.  Due
to the preceding FLUSH, the cache is already empty, so the only
difference between WRITE + FLUSH and FUA WRITE becomes the extra
command issue overhead which is usually almost unnoticeable compared
to the actual IO.

Another thing is that with the recent updates to block FLUSH handling,
using FUA might even be less efficient.  The new implementation
aggressively merges those commit writes and flushes.  IOW, depending
on timing, multiple consecutive commit writes can be merged as,

 FLUSH + commit writes + FLUSH

or

 FLUSH + some commit writes + FLUSH + other commit writes + FLUSH

and so on,

These merges will happen with fsync heavy workloads where FLUSH
performance actually matters and, in these scenarios, FUA writes is
less effective because it puts extra ordering restrictions on each FUA
write.  ie. With surrounding FLUSHes, the drive is free to reorder
commit writes to maximize performance, with FUA, the disk has to jump
around all over the place to execute each command in the exact issue
order.

I personally think FUA is a misfeature.  It's a microoptimization with
shallow benefits even when used properly while putting much heavier
restriction on actual IO order, which usually is the slow part.

That said, if someone can show FUA actually brings noticeable
performance benefits, sure, let's do it, but till then, I think it
would be best to leave it up in the attic.=AB

-- =

Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
