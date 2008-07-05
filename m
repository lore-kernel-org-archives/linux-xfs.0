Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 05 Jul 2008 13:10:39 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m65KAbYa001482
	for <xfs@oss.sgi.com>; Sat, 5 Jul 2008 13:10:37 -0700
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D480D18810F0
	for <xfs@oss.sgi.com>; Sat,  5 Jul 2008 13:11:41 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by cuda.sgi.com with ESMTP id MuoX3IJL39rLaxkK for <xfs@oss.sgi.com>; Sat, 05 Jul 2008 13:11:41 -0700 (PDT)
Received: from localhost (DSL01.83.171.151.103.ip-pool.NEFkom.net [83.171.151.103])
	by mail.lichtvoll.de (Postfix) with ESMTP id EF3045AE2C
	for <xfs@oss.sgi.com>; Sat,  5 Jul 2008 22:11:40 +0200 (CEST)
Subject: Re: grub fails boot after update
From: Martin Steigerwald <Martin@lichtvoll.de>
Date: Sat, 5 Jul 2008 22:11:34 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807052211.34884.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Hi!

Am Donnerstag 03 Juli 2008 schrieb Jason White:
> On Wed, Jul 02, 2008 at 10:54:38PM -0500, Eric Sandeen wrote:
> > This really is grub that is busted, but I'd still just suggest using
> > ext3 to (mostly) work around the breakage for the foreseeable future.
> >
> > The other option is to teach grub to always do its io via the
> > filesystem not the block device while the fs is mounted (IIRC there
> > are various & sundry non-intuitive commands which actually nudge grub
> > towards or away from this desired behavior... --with-stage2=/path is
> > one I think, skipping the "verification" phase (i.e. trying to read
> > the block dev while mounted) is another)
>
> Does grub 2 (still in development when last I checked) improve on this
> situation?
>
> I managed to get Grub 1 installed on machines with XFS root file
> systems by running the install from within the grub "shell" environment
> rather than using grub-install. Maybe this skips the checks that
> attempt to read the block device directly. I also recall that
> grub-install failed.

I use GRUB 1 on XFS ever since. But I also used the GRUB shell directly to 
write it. grub-install doesn't work reliable.

I even use the functionality to save the last booted menu entry 
into /boot/grub/default without a problem.

I agree, reading or writing a mounted filesystem directly is not a good 
idea.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
