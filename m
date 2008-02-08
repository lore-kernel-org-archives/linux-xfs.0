Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Feb 2008 19:27:28 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m183RLDZ025865
	for <xfs@oss.sgi.com>; Thu, 7 Feb 2008 19:27:22 -0800
Date: Fri, 8 Feb 2008 14:27:30 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: NFSD on XFS with RT subvolume
Message-ID: <20080208032730.GL155407@sgi.com>
References: <B9FFC3F97441D04093A504CEA31B7C41021A627E@MSILEXCH01.marvell.com> <1202076343.9463.465.camel@edge.scott.net.au> <B9FFC3F97441D04093A504CEA31B7C4102220ACE@MSILEXCH01.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B9FFC3F97441D04093A504CEA31B7C4102220ACE@MSILEXCH01.marvell.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Rabeeh Khoury <rabeeh@marvell.com>
Cc: nscott@aconex.com, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, Lennert Buijtenhek <buytenh@marvell.com>

On Wed, Feb 06, 2008 at 04:08:58PM +0200, Rabeeh Khoury wrote:
> > >
> > > Exporting an XFS volume with kernel NFSD when real-time subvolume is
> > > enabled hangs the kernel.
> > >
> > > I'm using vanilla LK 2.6.22.7; first I create the XFS volume with
> two
> > > partitions of 20GB each with extent size of 1MB; then I create a
> > > subdirectory in the volume and mark it (using xfs_io util) as it
> belongs
> > > to the rt subvolume with inheritance flag.
> > >
> > > After mounting that volume through NFSv3 / UDP; and trying a 'dd
> > > if=/dev/zero of=/mnt/rt/test bs=1M count=1000' the machine running
> NFSD
> > > hangs infinitely.
> > 
> > Did you manage to get a stack trace, OOC?  No reason why it shouldn't
> > work AFAIK.
> 
> I didn't mention that I'm using ARM EABI machine for that; but the same
> scenario happened on Ubuntu Gutsy 7.10.
> The serial console stops responding, but getting Sysrq with showPc
> function working I'v got some stack traces (Look for #stack-trace
> below).

Nothing indicating a hang in the stack traces, just lots of
truncates in progress. If you run the same test on the local machine,
does the system hang? Or does it only hang through NFS.

BTW, having multiple truncates in flight doesn't match up with you
supposed test case above.  If all you are doing is a dd, then there
should only be one truncate occurring (on open). Try running with
conv=notrunc and see if that hangs in a similar manner...

> I'm running Fedora-8 on the ARM machine using xfsprogs-2.9.4-4.f8 RPM.
> The output of formatting /dev/sda5 and /dev/sda6 as the rt-subvolume is
> the following, but this time /dev/sda5 is 2GByte and /dev/sda6 is
> 20GByte (look for #mkfs.xfs).
> 
> Another note is that sometimes I'm getting an error message that XFS is
> trying to access LBA beyond the volume.

Does xfs_check or xfs_repair -n indicate and corruption on disk?

> Maybe you can suggest few tests that I can perform to figure out what's
> the root cause?

If you don't use a rt device, does the same test hang?

FWIW, if you run the same test on x86 or x86_64, does it hang?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
