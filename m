Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Jun 2007 08:26:57 -0700 (PDT)
Received: from spitz.ucw.cz (gprs189-60.eurotel.cz [160.218.189.60])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l58FQkWt028881
	for <xfs@oss.sgi.com>; Fri, 8 Jun 2007 08:26:50 -0700
Date: Thu, 7 Jun 2007 20:12:58 +0000
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression (xfs on raid6)
Message-ID: <20070607201258.GB10323@ucw.cz>
References: <200706012342.45657.rjw@sisk.pl> <46609FAD.7010203@dgreaves.com> <200706020122.49989.rjw@sisk.pl> <4661EFBB.5010406@dgreaves.com> <alpine.LFD.0.98.0706021538360.23741@woody.linux-foundation.org> <4662D852.4000005@dgreaves.com> <46667160.80905@gmail.com> <46668EE0.2030509@dgreaves.com> <46679D56.7040001@gmail.com> <4667DE2D.6050903@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4667DE2D.6050903@dgreaves.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Greaves <david@dgreaves.com>
Cc: Tejun Heo <htejun@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>

Hi!

> >How hard does the machine freeze?  Can you use sysrq?  
> >If so, please
> >dump sysrq-t.
> I suspect there is a problem writing to the consoles...
> 
> I recompiled (rc4+patch) with sysrq support, suspended, 
> resumed and tried sysrq-t but got no output.
> 
> I *can* change VTs and see the various login prompts, 
> bitmap messages and the console messages. Caps/Num lock 
> lights work.
> 
> Fearing incompetence I tried sysrq-s sysrq-u sysrq-b and 
> got a reboot so sysrq is OK.

Increase console loglevel by killing klogd/sysrq-9?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
