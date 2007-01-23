Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Jan 2007 08:51:57 -0800 (PST)
Received: from smtp112.sbc.mail.mud.yahoo.com (smtp112.sbc.mail.mud.yahoo.com [68.142.198.211])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0NGpkqw009136
	for <xfs@oss.sgi.com>; Tue, 23 Jan 2007 08:51:49 -0800
Date: Tue, 23 Jan 2007 08:50:50 -0800
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: how to sync / commit data to disk?
Message-ID: <20070123165050.GA28720@tuatara.stupidest.org>
References: <d55656c10701230716x1ae7cf49kd8a854fd73429c4f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d55656c10701230716x1ae7cf49kd8a854fd73429c4f@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Gervai <grinapo@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 23, 2007 at 04:16:59PM +0100, Peter Gervai wrote:

> This problem seem to have arisen in grub bootloader under Debian
> linux (and most probably everywhere else): it must be sure that the
> copied files are there, and can be addressed by C/H/S and modified
> there, at the given sector address.

grub is broken

this comes up all the time, there are various work-arounds but it
doesn't change the fact that GRUB IS BROKEN

it would be nice if someone would just address it from that end

> xfs_freeze -f
> sync
> xfs_freeze -u

sync before freeze (actually, I'm not sure a sync there is necessary
but it can't hurt)

wrt to grub, i thought it did this for xfs anyhow?

i suggested doing this a couple of years back and i thought that was
what it was doing now in some versions of grub (afaik vendors like red
hat never took that change, the last conversation i had about this
ended up being an argument about whether fsync should place the data
in it's final location on disk or not (nothing in the specs says it
should) so i gave up and dropped the issue)
