Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 25 Oct 2006 01:07:08 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9P86taG023203
	for <xfs@oss.sgi.com>; Wed, 25 Oct 2006 01:06:56 -0700
Received: from amd.ucw.cz (gprs189-60.eurotel.cz [160.218.189.60])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2D6104D6F73
	for <xfs@oss.sgi.com>; Wed, 25 Oct 2006 01:06:09 -0700 (PDT)
Date: Wed, 25 Oct 2006 10:05:58 +0200
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Freeze bdevs when freezing processes.
Message-ID: <20061025080558.GK5851@elf.ucw.cz>
References: <1161576735.3466.7.camel@nigel.suspend2.net> <200610231236.54317.rjw@sisk.pl> <20061024144446.GD11034@melbourne.sgi.com> <200610241730.00488.rjw@sisk.pl> <slrnejsfms.93p.olecom@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <slrnejsfms.93p.olecom@flower.upol.cz>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Oleg Verych <olecom@flower.upol.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, David Chinner <dgc@sgi.com>, Nigel Cunningham <ncunningham@linuxmail.org>, Andrew Morton <akpm@osdl.org>, xfs@oss.sgi.com

Hi!

> >> However, I have to say that I agree with freezing the filesystems
> >> before suspend - at least XFS will be in a consistent state that can
> >> be recovered from without corruption if your machine fails to
> >> resume....
> >
> > Do you mean calling sys_sync() after the userspace has been frozen
> > may not be sufficient?
> 
> Please see
> <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=317479;msg=105;att=0>
> 
> it's bottom of
> <http://bugs.debian.org/317479>
> 
> IMHO it's may be helpful.

Heh, ouch.

Okay, so what happens is that Debian's scripts attempt to change
/boot/../grub.conf.something (xfs mounted). Changes are properly
propagated to the journal, but grub can't parse the journal, and
fails.

Ouch.

Either

1) fix grub to parse the journal (not practical, I guess)

2) do not modify grub configuration from hibernate scripts

or

3) fix hibernate scripts to sync down to disk, properly.

swsusp does not guarantee any particular state of filesystems when
system is suspended. Sorry.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
