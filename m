Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 12 Jun 2007 11:43:52 -0700 (PDT)
Received: from smtp2.linux-foundation.org (smtp2.linux-foundation.org [207.189.120.14])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5CIhlWt031475
	for <xfs@oss.sgi.com>; Tue, 12 Jun 2007 11:43:48 -0700
Date: Tue, 12 Jun 2007 11:43:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression (xfs on
 raid6)
In-Reply-To: <4669A965.20403@dgreaves.com>
Message-ID: <alpine.LFD.0.98.0706121123550.14121@woody.linux-foundation.org>
References: <200706020122.49989.rjw@sisk.pl> <4661EFBB.5010406@dgreaves.com>
 <alpine.LFD.0.98.0706021538360.23741@woody.linux-foundation.org>
 <4662D852.4000005@dgreaves.com> <46667160.80905@gmail.com>
 <46668EE0.2030509@dgreaves.com> <46679D56.7040001@gmail.com>
 <4667DE2D.6050903@dgreaves.com> <20070607110708.GS86004887@sgi.com>
 <46680F5E.6070806@dgreaves.com> <20070607222813.GG85884050@sgi.com>
 <4669A965.20403@dgreaves.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Greaves <david@dgreaves.com>
Cc: David Chinner <dgc@sgi.com>, Tejun Heo <htejun@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>, Jeff Garzik <jgarzik@pobox.com>



On Fri, 8 Jun 2007, David Greaves wrote:
> 
> positive: I can now get sysrq-t :)

Ok, so color me confused, and maybe I have missed some of the emails or 
skimmed over them too fast (there's been too many of them ;), but

 - I haven't actually seen any traces for this (netconsole apparently 
   doesn't work for you, and I'm not surprised: it never really worked 
   well for me over suspend/resume either, but I think I saw a mention of 
   serial console?)

 - You apparently bisected it down to the range

	0a3fd051c7036ef71b58863f8e5da7c3dabd9d3f <- works
	1d30c33d8d07868199560b24f10ed6280e78a89c <- breaks

   but some of the intermediates in that range didn't compile. Correct?

Can you try to bisect down a bit more, despite the compile error? Just do

	git bisect start
	git bisect good 0a3fd051c7036ef71b58863f8e5da7c3dabd9d3f
	git bisect bad 1d30c33d8d07868199560b24f10ed6280e78a89c

and it should pick 

	f4d6d004: libata: ignore EH scheduling during initialization

for you to test. It will apparently break on the fact that "sata_via.c" 
wants "ata_scsi_device_resume/suspend" for the initialization of the
resume/suspend things in the scsi_host_template, but you should just 
remove those lines, and the compile hopefully completes cleanly after 
that.

IOW, it *should* be easy enough to pinpoint this from 9 changes down to 
just one.

Jeff added to the Cc, since he may not have noticed that one of the most 
long-running issues is apparently sata-related.

(Jeff: David Greaves _also_ had issues with -rc4 due to the SETFXSR 
change, but that should hopefully be resolved and is presumably an 
independent bug. Apart from the fact that "sata_via.c" seems problematic)

		Linus
