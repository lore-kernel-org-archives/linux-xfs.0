Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Dec 2007 16:35:40 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBI0ZQDZ003651
	for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 16:35:29 -0800
Received: from snort.melbourne.sgi.com (snort.melbourne.sgi.com [134.14.54.149]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id LAA04295 for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 11:35:38 +1100
Received: from snort.melbourne.sgi.com (localhost [127.0.0.1])
	by snort.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id lBI0ZbIN12136908
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 11:35:38 +1100 (AEDT)
Received: (from dgc@localhost)
	by snort.melbourne.sgi.com (SGI-8.12.5/8.12.5/Submit) id lBI0Zawp12137607
	for xfs@oss.sgi.com; Tue, 18 Dec 2007 11:35:36 +1100 (AEDT)
Date: Tue, 18 Dec 2007 11:35:36 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Installing grub onto a system with XFS root fs
Message-ID: <20071218003536.GD4396912@sgi.com>
References: <20071217004945.GA13335@jdc.jasonjgw.net> <200712171428.51831.Martin@lichtvoll.de> <20071217230437.GA7169@jdc.jasonjgw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071217230437.GA7169@jdc.jasonjgw.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Tue, Dec 18, 2007 at 10:04:37AM +1100, Jason White wrote:
> On Mon, Dec 17, 2007 at 02:28:51PM +0100, Martin Steigerwald wrote:
>  
> > Using grub shell manually always worked for me:
> > 
> > - grub
> > - find /boot/grub/menu.lst
> > - root <result from above command>
> > - setup <place to install too> for example (hd0,0) for first harddisks MBR
> > 
> > Remember to copy over the contents of /usr/lib/grub/i386-pc to /boot 
> > before you do a manual installation.
> 
> Thanks.
> 
> Apparently there is XFS support in Grub 2 as well, which is where all
> development is now taking place. I hope it receives adequate testing and
> attention before distributions start using Grub 2.

I just looked at the XFS code in ithe grub 2 CVS repository and had a
read of the wiki (http://grub.enbug.org/).

>From the code and the wiki, I note that there is no indication of grub 2
fixing the worst design mistakes in grub and is persisting with stuffing
around with filesystem internals to find files and get block mappings for
file data. Hence grub 2 will break just like grub if we ever change things on disk
like the inode, directory or extent format. Lucky it doesn't support btree
formats yet, so that won't break if we change them....

And there's plans on doing *journal replay* for filesystems!
(#1 item on the todo list here: http://grub.enbug.org/TodoList). That's
an insane layering violation and completely unsupportable by anyone. I
certainly hope this part of the plan for grub 2 never gets implemented.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
