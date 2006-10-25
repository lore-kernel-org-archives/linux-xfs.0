Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 25 Oct 2006 01:11:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9P8B1aG024184
	for <xfs@oss.sgi.com>; Wed, 25 Oct 2006 01:11:03 -0700
Received: from amd.ucw.cz (gprs189-60.eurotel.cz [160.218.189.60])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2BBEDD1ABF55
	for <xfs@oss.sgi.com>; Wed, 25 Oct 2006 01:10:14 -0700 (PDT)
Date: Wed, 25 Oct 2006 10:10:01 +0200
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Freeze bdevs when freezing processes.
Message-ID: <20061025081001.GL5851@elf.ucw.cz>
References: <1161576735.3466.7.camel@nigel.suspend2.net> <200610231236.54317.rjw@sisk.pl> <20061024144446.GD11034@melbourne.sgi.com> <200610241730.00488.rjw@sisk.pl> <20061024163345.GG11034@melbourne.sgi.com> <20061024213737.GD5662@elf.ucw.cz> <20061025001331.GP8394166@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061025001331.GP8394166@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Nigel Cunningham <ncunningham@linuxmail.org>, Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Hi!

> > > > Do you mean calling sys_sync() after the userspace has been frozen
> > > > may not be sufficient?
> > > 
> > > In most cases it probably is, but sys_sync() doesn't provide any
> > > guarantees that the filesystem is not being used or written to after
> > > it completes. Given that every so often I hear about an XFS filesystem
> > > that was corrupted by suspend, I don't think this is sufficient...
> > 
> > Userspace is frozen. There's noone that can write to the XFS
> > filesystem.
> 
> Sure, no new userspace processes can write data, but what about the
> internal state of the filesystem?
> 
> All a sync guarantees is that the filesystem is consistent when the
> sync returns and XFS provides this guarantee by writing all data and
> ensuring all metadata changes are logged so if a crash occurs it can
> be recovered (which provides the sync guarantee). hence after a
> sys_sync(), XFS will still have lots of dirty metadata that needs to
> be written to disk at some time in the future so the transactions
> can be removed from the log.
> 
> This dirty metadata can be flushed at any time, and the dirty state
> is kept in XFS structures and not always in page structures (think
> multipage metadata buffers). Hence I cannot see how suspend can
> guarantee that it has saved all the dirty data in XFS, nor
> restore it correctly on resume. Once you toss dirty metadata that
> is currently in the log, further operations will result in that log
> transaction being overwritten without it ever being written to disk.
> That then means any subsequent operations after resume will corrupt
> the filesystem....
> 
> Hence the only way to correctly rebuild the XFS state on resume is
> to quiesce the filesystem on suspend and thaw it on resume so as to
> trigger log recovery.

No, during suspend/resume, memory image is saved, and no state is
lost. We would not even have to do sys_sync(), and suspend/resume
would still work properly.

sys_sync() is there only to limit damage in case of suspend/resume
failure.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
