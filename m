Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Jul 2006 12:24:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6IJNSDW021820
	for <linux-xfs@oss.sgi.com>; Tue, 18 Jul 2006 12:23:40 -0700
Date: Wed, 19 Jul 2006 05:21:35 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS and write barrier
Message-ID: <20060718192135.GV15160733@melbourne.sgi.com>
References: <200607151248.56603.Martin@lichtvoll.de> <17596.41680.124148.595601@cse.unsw.edu.au> <20060718170406.GT15160733@melbourne.sgi.com> <200607182027.49648.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200607182027.49648.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-xfs@oss.sgi.com

On Tue, Jul 18, 2006 at 08:27:48PM +0200, Martin Steigerwald wrote:
> Am Dienstag 18 Juli 2006 19:04 schrieb David Chinner:
> 
> > > "Journalling filesystems need write barrier" isn't really accurate.
> > > They can make good use of write barrier if it is supported, and where
> > > it isn't supported, they should use blkdev_issue_flush in combination
> > > with regular submit/wait.
> >
> > blkdev_issue_flush() causes a write cache flush - just like a
> > barrier typically causes a write cache flush up to the I/O with the
> > barrier in it.  Both of these mechanisms provide the same thing - an
> > I/O barrier that enforces ordering of I/Os to disk.
> 
> Hello David,
> 
> well now it gets interesting. If both provide the same thing, whats the 
> difference?

A WRITE_BARRIER I/O can be optimised by smart drivers, protocols and hardware
to minimise the adverse effects of the barrier, whereas a cache flush
is a brute force cache cleaning mechanism that cannot be optimised....

> > Given that filesystems already indicate to the block layer when they
> > want a barrier, wouldn't it be better to get the block layer to issue
> > this cache flush if the underlying device doesn't support barriers
> > and it receives a barrier request?
> 
> Does a device need to support more than this cache flush in order to 
> support barriers? Up to know I thought that when a device supports cache 
> flushes the kernel can provide barrier functinality for it.

Not necessarily as different device/protocol commands are used.

> I see in boot output that my notebook harddisk supports cache flushes. But 
> not in dmesg nor in syslog. I don't know yet how to actually determine 
> whether barrier functionality is really usable on a certain system. 

My test is to mount an XFS filesystem using barriers on the device and
look at the syslog message. ;)

> > FWIW, Only XFS and Reiser3 use this function, and only then when
> > issuing a fsync when barriers are disabled to make sure a common
> > test (fsync then power cycle) doesn't result in data loss...
> 
> So will XFS be safe even without write barriers?

XFS is only safe when you have:

	a) no write caching on the drive (barrier or nobarrier)
	b) non-volatile write caching on the drive (barrier or nobarrier)
	c) volatile write caching and barriers supported and enabled

The same conditions hold true for any filesystem that requires I/O ordering
guarantees to maintain filesystem consistency...

> What will it do when it 
> cannot do write barriers but write barriers are requested by the user or 
> the inbuilt default setting of the filesystem?  Will it work unsafely or 
> will mount readonly or disable write caches in that case?

XFS will log a warning to the syslog and dmesg saying write barriers are
disabled and continue onwards without barriers.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
