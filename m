Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Oct 2006 15:36:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9OMaAaG016234
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 15:36:11 -0700
Received: from amd.ucw.cz (gprs189-60.eurotel.cz [160.218.189.60])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D5804D078A
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 14:44:06 -0700 (PDT)
Date: Tue, 24 Oct 2006 23:43:22 +0200
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Freeze bdevs when freezing processes.
Message-ID: <20061024214322.GA5652@elf.ucw.cz>
References: <1161576735.3466.7.camel@nigel.suspend2.net> <200610231236.54317.rjw@sisk.pl> <20061024144446.GD11034@melbourne.sgi.com> <200610241730.00488.rjw@sisk.pl> <20061024170633.GA17956@infradead.org> <20061024212648.GB5662@elf.ucw.cz> <20061024213342.GA22552@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061024213342.GA22552@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, David Chinner <dgc@sgi.com>, Nigel Cunningham <ncunningham@linuxmail.org>, Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Hi!

On Tue 2006-10-24 22:33:42, Christoph Hellwig wrote:
> On Tue, Oct 24, 2006 at 11:26:48PM +0200, Pavel Machek wrote:
> > > No, that's definitly not enough.  You need to freeze_bdev to make sure
> > > data is on disk in the place it's expected by the filesystem without
> > > starting a log recovery.
> > 
> > I believe log recovery is okay in this case.
> > 
> > It can only happen when kernel dies during suspend or during
> > resume... And log recovery seems okay in that case. We even guarantee
> > that user did not loose any data -- by using sys_sync() after userland
> > is stopped -- but let's not overdo over protections.
> 
> You're still entirely missing the problem.
> 
> Take a look at http://www.opengroup.org/onlinepubs/007908799/xsh/sync.html
> and the linux sync(2) manpage.  The only thing sync guarantees is writing
> out all in-memory data to disk.  It doesn't even gurantee completion,
> although we've been synchronous in Linux for a while.

Ok, I assume sys_sync is synchronous, but that's okay.

> What it does not gurantee is where on disk the data is located.  Now for
> a journaling filesystem pushing everything to the log is the easiest way
> to complete sync, and it's perfectly valid - if the system crashes after
> the sync and before data is written back to it's normal place on disk
> the system notices it's not been unmounted cleanly and will do a log
> recovery.  In the suspend case however the system neither crashes nor
> is unmounted - thus the filesystem doesn't know it has to recover the
> log.  We have to choices to fix this:
> 
>  (1) force a log recovery of an already mounted and in use filesystem
>  (2) make sure data is in the right place before suspending
> 
> (1) is pretty nasty, and hard to do across filesystems.  (2) is already
> implemented and easily useable by the suspend code.

No, there's no need to do either (1) or (2) in "machine suspended and
resumed successfully". In that case, machine just continues as if no
suspend has happened.

In fact I could remove sys_sync() from freezer. suspend code would
still be correct.

That sys_sync() only matters in case of suspend but machine died
during resume... and in that case we know we crashed, and journal
recovery is okay.

I do know how journaling works (from 10000feet, anyway), and it is
okay in this case.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
