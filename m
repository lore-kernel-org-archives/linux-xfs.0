Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 25 Oct 2006 01:48:42 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9P8mYaG032413
	for <xfs@oss.sgi.com>; Wed, 25 Oct 2006 01:48:35 -0700
Received: from amd.ucw.cz (gprs189-60.eurotel.cz [160.218.189.60])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BE4A94D7B83
	for <xfs@oss.sgi.com>; Wed, 25 Oct 2006 01:47:45 -0700 (PDT)
Date: Wed, 25 Oct 2006 10:47:14 +0200
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Freeze bdevs when freezing processes.
Message-ID: <20061025084714.GA7266@elf.ucw.cz>
References: <1161576735.3466.7.camel@nigel.suspend2.net> <200610231236.54317.rjw@sisk.pl> <20061024144446.GD11034@melbourne.sgi.com> <200610241730.00488.rjw@sisk.pl> <20061024163345.GG11034@melbourne.sgi.com> <20061024213737.GD5662@elf.ucw.cz> <20061025001331.GP8394166@melbourne.sgi.com> <20061025081001.GL5851@elf.ucw.cz> <20061025083830.GI11034@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061025083830.GI11034@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Nigel Cunningham <ncunningham@linuxmail.org>, Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Wed 2006-10-25 18:38:30, David Chinner wrote:
> On Wed, Oct 25, 2006 at 10:10:01AM +0200, Pavel Machek wrote:
> > > Hence the only way to correctly rebuild the XFS state on resume is
> > > to quiesce the filesystem on suspend and thaw it on resume so as to
> > > trigger log recovery.
> > 
> > No, during suspend/resume, memory image is saved, and no state is
> > lost. We would not even have to do sys_sync(), and suspend/resume
> > would still work properly.
> 
> It seems to me that you ensure the filesystem is synced to disk and
> then at some point later you record the memory state of the
> filesystem, but these happen at different times. That leaves a
> window for things to get out of sync again, right?

I DO NOT HAVE TO ENSURE FILESYSTEM IS SYNCED. That sys_sync() is
optional.

Recording of memory state is atomic, and as long as noone writes to
the disk after atomic snapshot, memory image matches what is on disk.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
