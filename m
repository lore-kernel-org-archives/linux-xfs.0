Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p41GqH8b184612 for <xfs@oss.sgi.com>; Sun, 1 May 2011 11:52:18 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 51D234247FD
	for <xfs@oss.sgi.com>; Sun,  1 May 2011 09:55:53 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id FEUNIBUbqccnB2jE for
	<xfs@oss.sgi.com>; Sun, 01 May 2011 09:55:53 -0700 (PDT)
Date: Sun, 1 May 2011 12:55:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs performance problem
Message-ID: <20110501165546.GB5391@infradead.org>
References: <4DB72084.8020205@inf.ethz.ch> <20110427023534.GF12436@dastard>
	<201104291827.35801.Martin@lichtvoll.de>
	<20110501085246.GF13542@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110501085246.GF13542@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sun, May 01, 2011 at 06:52:46PM +1000, Dave Chinner wrote:
> > > more than likely your problem is that barriers have been enabled for
> > > MD/DM devices on the new kernel, and they aren't on the old kernel.
> > > XFS uses barriers by default, ext3 does not. Hence XFS performance
> > > will change while ext3 will not. Check dmesg output when mounting
> > > the filesystems on the different kernels.
> > 
> > But didn't 2.6.38 replace barriers by explicit flushes the filesystem has to 
> > wait for - mitigating most of the performance problems with barriers?
> 
> IIRC, it depends on whether the hardware supports FUA or not. If it
> doesn't then device cache flushes are used to emulate FUA and so
> performance can still suck. Christoph will no doubt correct me if I
> got that wrong ;)

Mitigating most of the barrier performance issues is a bit of a strong
word.  Yes, it remove useless ordering requirements, but fundamentally
you still have to flush the disk cache to the physical medium, which
is always going to be slower than just filling up a DRAM cache like
ext3's default behaviour in mainline does (interestingly both SLES
and RHEL have patched it to provide safe behaviour by default).

Both the old barrier and new flush code will use the FUA bit if
available, and those optimize the post-flush for a log write out.
Note that currently libata by default always disables FUA support,
even if the disk supports it, so you'll need a SAS/FC/iSCSI/etc
device to actually see FUA requests, which is quite sad as it
should provide a nice speedup epecially for SATA where the cache
flush command is not queueable and thus requires us to still
drain any outstanding I/O at least for a short duration.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
