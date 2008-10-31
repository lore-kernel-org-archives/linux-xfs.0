Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 31 Oct 2008 15:18:34 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9VMIK2C026111
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 15:18:21 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 023A414C4038
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 15:18:21 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id UWvRryyTG1cCTTf2 for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 15:18:21 -0700 (PDT)
Date: Sat, 1 Nov 2008 09:18:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Which FileSystem do you use on your postfix server?
Message-ID: <20081031221817.GD19509@disturbed>
References: <490B1C8B.7010607@sandeen.net> <20081031153758.EF0521F3E9E@spike.porcupine.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031153758.EF0521F3E9E@spike.porcupine.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Wietse Venema <wietse@porcupine.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Justin Piszcz <jpiszcz@lucidpixels.com>, Postfix users <postfix-users@postfix.org>, xfs@oss.sgi.com

On Fri, Oct 31, 2008 at 11:37:58AM -0400, Wietse Venema wrote:
> Eric Sandeen:
> > > This
> > > would violate a basic requirement of Postfix (don't lose data after
> > > fsync).  Postfix updates existing files all the time: it updates
> > > queue files as it marks recipients as done, and it updates mailbox
> > > files as it appends mail.
> > 
> > As long as postfix is looking after data properly with fsyncs etc, xfs
> > should be perfectly safe w.r.t. data integrity on a crash.  If you see
> > any other behavior, it's a *bug* which should be reported, and I'm sure
> > it would be fixed.  As far as I know, though, there is no issue here.
> 
> The specific question is, will unclean shutdown cause loss of data
> that was already fsynced,

No.

> when the file was updated after the fsync.

and no.

XFS guarantees that you won't lose anything you fsync()d. You might
lose what you wrote after the fsync()), though, because you haven't
fsync()d it. Obvious, yes?

> For example, if the on-disk file metadata is updated after the file
> data is appended, then there is no need to have a zero-fill problem
> after crash during append.

In case you didn't read Eric's response - that's exactly how we
fixed XFS to prevent this problem. And please stop propagating
this erroneous "zero-fill" meme - Eric addressed how wrong that
FUD is as well.

> What if the crash happens after Postfix requests a 1-byte write in
> the middle of a file, i.e. without changing the size?  A
> reasonable implementation would not corrupt the file, but would
> either update the file data or not change it. I can deal with
> that.

That is exactly how XFS has always behaved for non-extending data
overwrite. i.e. Exactly the same pretty much every filesystem that
has ever existed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
