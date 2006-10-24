Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Oct 2006 15:41:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9OMf3aG017622
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 15:41:04 -0700
Received: from amd.ucw.cz (gprs189-60.eurotel.cz [160.218.189.60])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4D94AD1AA4E4
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 14:38:29 -0700 (PDT)
Date: Tue, 24 Oct 2006 23:37:37 +0200
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Freeze bdevs when freezing processes.
Message-ID: <20061024213737.GD5662@elf.ucw.cz>
References: <1161576735.3466.7.camel@nigel.suspend2.net> <200610231236.54317.rjw@sisk.pl> <20061024144446.GD11034@melbourne.sgi.com> <200610241730.00488.rjw@sisk.pl> <20061024163345.GG11034@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061024163345.GG11034@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Nigel Cunningham <ncunningham@linuxmail.org>, Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Hi!

> > Do you mean calling sys_sync() after the userspace has been frozen
> > may not be sufficient?
> 
> In most cases it probably is, but sys_sync() doesn't provide any
> guarantees that the filesystem is not being used or written to after
> it completes. Given that every so often I hear about an XFS filesystem
> that was corrupted by suspend, I don't think this is sufficient...

Userspace is frozen. There's noone that can write to the XFS
filesystem.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
