Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Mar 2008 06:48:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2BDlr3G025328
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 06:47:55 -0700
Received: from mail.flatline.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6D542F62702
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 06:48:23 -0700 (PDT)
Received: from mail.flatline.de (flatline.de [80.190.243.144]) by cuda.sgi.com with ESMTP id UdinNapWZR8HTXZn for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 06:48:23 -0700 (PDT)
Date: Tue, 11 Mar 2008 14:47:46 +0100
From: Andreas Kotes <count-linux@flatline.de>
Subject: Re: XFS internal error
Message-ID: <20080311134746.GQ14256@slop.flatline.de>
References: <470831E6.4030704@fastmail.co.uk> <20071008001452.GX995458@sgi.com> <20080310122216.GG14256@slop.flatline.de> <20080310223018.GA155407@sgi.com> <20080310225927.GP14256@slop.flatline.de> <20080310234539.GC155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080310234539.GC155407@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hello,

* David Chinner <dgc@sgi.com> [20080311 00:45]:
> On Mon, Mar 10, 2008 at 11:59:27PM +0100, Andreas Kotes wrote:
> > * David Chinner <dgc@sgi.com> [20080310 23:30]:
> > > On Mon, Mar 10, 2008 at 01:22:16PM +0100, Andreas Kotes wrote:
> > > > * David Chinner <dgc@sgi.com> [20080310 13:18]:
> > > > > Yes, but those previous corruptions get left on disk as a landmine
> > > > > for you to trip over some time later, even on a kernel that has the
> > > > > bug fixed.
> > > > > 
> > > > > I suggest that you run xfs_check on the filesystem and if that
> > > > > shows up errors, run xfs_repair onteh filesystem to correct them.
> > > > 
> > > > I seem to be having similiar problems, and xfs_repair is not helping :(
> > > 
> > > xfs_repair is ensuring that the problem is not being caused by on-disk
> > > corruption. In this case, it does not appear to be caused by on-disk
> > > corruption, so xfs_repair won't help.
> > 
> > ok, too bad - btw, is it a problem that I'm doing the xfs_repair on a
> > mounted filesystem with xfs_repair -f -L after a remount rw?
> 
> If it was read only, and you rebooted immediately afterwards, you'd
> probably be ok. Doing this to a mounted, rw filesystem is asking
> for trouble. If the shutdown is occurring after you've run xfs_repair,
> then it is almost certainly the cause....

whoops, that should have read 'remount ro' .. xfs_repair on a live and
writable filesystem is of course inviting desaster. I was trying read
only - btw, the system as such is booted via PXE and running complete
out of an initrd, using the HDD just for local data storage - not much
happening on shutdown/reboot either way.

> I'd suggest getting a knoppix (or similar) rescue disk and repairing
> from that, rebooting and seeing if the problem persists. If it
> does, then we'll have to look further into it.

I basically build a PXE image which does an xfs_repair -L /dev/sda2 from
initrd - and the problem persists. Sigh. Exactly no change.

> FWIW, you've got plenty of free inodes so this does not look
> to be the same problem I've just found. 

okay ... it happens on several of the dozens of machines I'm running
this way, but not on others - I have yet to find the difference.

what can I do to help find the problem?

   Andreas

-- 
flatline IT services - Andreas Kotes - Tailored solutions for your IT needs
