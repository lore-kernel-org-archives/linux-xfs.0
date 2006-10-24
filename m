Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Oct 2006 15:41:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9OMf2aG017600
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 15:41:03 -0700
Received: from amd.ucw.cz (gprs189-60.eurotel.cz [160.218.189.60])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 58131D1AA4ED
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 14:27:17 -0700 (PDT)
Date: Tue, 24 Oct 2006 23:26:48 +0200
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Freeze bdevs when freezing processes.
Message-ID: <20061024212648.GB5662@elf.ucw.cz>
References: <1161576735.3466.7.camel@nigel.suspend2.net> <200610231236.54317.rjw@sisk.pl> <20061024144446.GD11034@melbourne.sgi.com> <200610241730.00488.rjw@sisk.pl> <20061024170633.GA17956@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061024170633.GA17956@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, David Chinner <dgc@sgi.com>, Nigel Cunningham <ncunningham@linuxmail.org>, Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Hi!

On Tue 2006-10-24 18:06:33, Christoph Hellwig wrote:
> On Tue, Oct 24, 2006 at 05:29:59PM +0200, Rafael J. Wysocki wrote:
> > Do you mean calling sys_sync() after the userspace has been frozen
> > may not be sufficient?
> 
> No, that's definitly not enough.  You need to freeze_bdev to make sure
> data is on disk in the place it's expected by the filesystem without
> starting a log recovery.

I believe log recovery is okay in this case.

It can only happen when kernel dies during suspend or during
resume... And log recovery seems okay in that case. We even guarantee
that user did not loose any data -- by using sys_sync() after userland
is stopped -- but let's not overdo over protections.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
