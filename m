Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 21 Mar 2008 16:21:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2LNLBBT011608
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 16:21:12 -0700
Received: from node1.t-mail.cz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 497A76D22D1
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 16:21:42 -0700 (PDT)
Received: from node1.t-mail.cz (node1.t-mail.cz [62.141.0.166]) by cuda.sgi.com with ESMTP id NT5GIdFOgOVBWXz7 for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 16:21:42 -0700 (PDT)
Subject: Re: serious problem with XFS on nvidia IDE controller
From: Massimiliano Adamo <maxadamo@gmail.com>
In-Reply-To: <20080321230609.GA31222@puku.stupidest.org>
References: <1206125778.6867.14.camel@dasa-laptop>
	 <20080321230609.GA31222@puku.stupidest.org>
Content-Type: text/plain
Date: Sat, 22 Mar 2008 00:21:05 +0100
Message-Id: <1206141665.6636.23.camel@dasa-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: xfs@oss.sgi.com


Il giorno ven, 21/03/2008 alle 16.06 -0700, Chris Wedgwood ha scritto:
> On Fri, Mar 21, 2008 at 07:56:18PM +0100, Massimiliano Adamo wrote:
> 
> > I have a notebook, Acer Aspire 5520 using the following controller:
> > 0:06.0 IDE interface: nVidia Corporation Unknown device 0560 (rev a1)
> 
> MCP67 IDE
> 
> drivers/ata/pata_amd.c got support for that with 05e2867a, so after
> 2.6.19-rc4

You're right, now I know it. I updated pci ids with "update-piciids"
command and I found the name of the controller. After that I booted from
a live-cd and I got pata_amd running, but this module doesn't belong to
Ubuntu kernel (I don't have it)... I'll search how to add this module,
if possible. But I would never recompile a kernel on ubuntu (don't have
time for this). I left gentoo to avoid recompiling.


> 
> drivers/ide/pci/amd74xx.c, 9cbcc5e3, after v2.6.23
> 
> > My kernel is the one provided with Ubuntu 7.10: 2.6.22-14
> 
> For the sata driver that should work then i would think.  You might
> want to see what the Ubuntu people have to say about that.

let's say the problem is: "ubuntu people" are neither hacker or guru,
and majority of people just use the default filesystem. 


> > I have installed the system at least 3 times in one day, before
> > understanding that the problem was XFS filesystem.
> 
> I doubt it.
> 

What is your doubt? System is now running fine.
I have been reinstalling the system the whole day, and after each reboot
I was missing files from the filesystem.
I didn't have messages in dmes, or in logs.
The last attempt was to change filesystem. I just reinstalled the same
version of the operating system, just changing to reiser and everything
is now ok.
Is there anything else to understand?
The syWith XFS the system was broken after 20 minutes.

> > I also noticed that "sync" command was always taking a long time to
> > complete.
> 
> Lots of dirty pages and slow writeout (PIO) might explain that.
> 

Agree, but why no problems like this with reiser?

-- 
Massimiliano
