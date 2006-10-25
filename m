Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 25 Oct 2006 01:39:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9P8dWaG030039
	for <xfs@oss.sgi.com>; Wed, 25 Oct 2006 01:39:34 -0700
Date: Wed, 25 Oct 2006 18:38:30 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Freeze bdevs when freezing processes.
Message-ID: <20061025083830.GI11034@melbourne.sgi.com>
References: <1161576735.3466.7.camel@nigel.suspend2.net> <200610231236.54317.rjw@sisk.pl> <20061024144446.GD11034@melbourne.sgi.com> <200610241730.00488.rjw@sisk.pl> <20061024163345.GG11034@melbourne.sgi.com> <20061024213737.GD5662@elf.ucw.cz> <20061025001331.GP8394166@melbourne.sgi.com> <20061025081001.GL5851@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061025081001.GL5851@elf.ucw.cz>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Pavel Machek <pavel@ucw.cz>
Cc: David Chinner <dgc@sgi.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Nigel Cunningham <ncunningham@linuxmail.org>, Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Oct 25, 2006 at 10:10:01AM +0200, Pavel Machek wrote:
> > Hence the only way to correctly rebuild the XFS state on resume is
> > to quiesce the filesystem on suspend and thaw it on resume so as to
> > trigger log recovery.
> 
> No, during suspend/resume, memory image is saved, and no state is
> lost. We would not even have to do sys_sync(), and suspend/resume
> would still work properly.

It seems to me that you ensure the filesystem is synced to disk and
then at some point later you record the memory state of the
filesystem, but these happen at different times. That leaves a
window for things to get out of sync again, right?

Cheers,

Dave.

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
