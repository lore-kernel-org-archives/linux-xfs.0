Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Jan 2007 14:26:37 -0800 (PST)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0NMQTqw023486
	for <xfs@oss.sgi.com>; Tue, 23 Jan 2007 14:26:33 -0800
Subject: Re: how to sync / commit data to disk?
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <20070123165050.GA28720@tuatara.stupidest.org>
References: <d55656c10701230716x1ae7cf49kd8a854fd73429c4f@mail.gmail.com>
	 <20070123165050.GA28720@tuatara.stupidest.org>
Content-Type: text/plain
Date: Wed, 24 Jan 2007 09:24:29 +1100
Message-Id: <1169591069.18017.143.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: Peter Gervai <grinapo@gmail.com>, xfs@oss.sgi.com

On Tue, 2007-01-23 at 08:50 -0800, Chris Wedgwood wrote:
> On Tue, Jan 23, 2007 at 04:16:59PM +0100, Peter Gervai wrote:
> 
> > This problem seem to have arisen in grub bootloader under Debian
> > linux (and most probably everywhere else): it must be sure that the
> > copied files are there, and can be addressed by C/H/S and modified
> > there, at the given sector address.
> 
> grub is broken
> 
> this comes up all the time, there are various work-arounds but it
> doesn't change the fact that GRUB IS BROKEN
> 
> it would be nice if someone would just address it from that end
> 
> > xfs_freeze -f
> > sync
> > xfs_freeze -u
> 
> sync before freeze (actually, I'm not sure a sync there is necessary
> but it can't hurt)

Its not necessary (would be a bug if so).

FWIW, this hack can be better achieved in a filesystem independent way
by doing a remount,ro ... remount,rw instead of freeze/thaw.

cheers.

-- 
Nathan
