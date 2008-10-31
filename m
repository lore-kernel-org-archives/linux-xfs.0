Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 31 Oct 2008 15:56:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9VMuFJP028508
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 15:56:16 -0700
Received: from spike.porcupine.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3AC9FB2D812
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 15:56:16 -0700 (PDT)
Received: from spike.porcupine.org (spike.porcupine.org [168.100.189.2]) by cuda.sgi.com with ESMTP id pG6MWAgT135Tv8Kv for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 15:56:16 -0700 (PDT)
Subject: Re: Which FileSystem do you use on your postfix server?
In-Reply-To: <20081031221817.GD19509@disturbed> "from Dave Chinner at Nov 1,
 2008 09:18:17 am"
Date: Fri, 31 Oct 2008 18:56:15 -0400 (EDT)
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20081031225615.5E66B1F3EA0@spike.porcupine.org>
From: wietse@porcupine.org (Wietse Venema)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Wietse Venema <wietse@porcupine.org>, Eric Sandeen <sandeen@sandeen.net>, Justin Piszcz <jpiszcz@lucidpixels.com>, Postfix users <postfix-users@postfix.org>, xfs@oss.sgi.com

Dave Chinner:
> On Fri, Oct 31, 2008 at 11:37:58AM -0400, Wietse Venema wrote:
> > Eric Sandeen:
> > > > This
> > > > would violate a basic requirement of Postfix (don't lose data after
> > > > fsync).  Postfix updates existing files all the time: it updates
> > > > queue files as it marks recipients as done, and it updates mailbox
> > > > files as it appends mail.
> > > 
> > > As long as postfix is looking after data properly with fsyncs etc, xfs
> > > should be perfectly safe w.r.t. data integrity on a crash.  If you see
> > > any other behavior, it's a *bug* which should be reported, and I'm sure
> > > it would be fixed.  As far as I know, though, there is no issue here.
> > 
> > The specific question is, will unclean shutdown cause loss of data
> > that was already fsynced,
> 
> No.
> 
> > when the file was updated after the fsync.
> 
> and no.
> 
> XFS guarantees that you won't lose anything you fsync()d. You might
> lose what you wrote after the fsync()), though, because you haven't
> fsync()d it. Obvious, yes?

This is how I hoped any reasonable implementation would work. The
stories about null files made me wonder if there was something
unusual about XFS that I should be aware of.

> > For example, if the on-disk file metadata is updated after the file
> > data is appended, then there is no need to have a zero-fill problem
> > after crash during append.
> 
> In case you didn't read Eric's response - that's exactly how we
> fixed XFS to prevent this problem. And please stop propagating
> this erroneous "zero-fill" meme - Eric addressed how wrong that
> FUD is as well.

Just confirming a specific case that I care about.

Here's something I would like to know regarding the order of
directory updates:

- Does fsync(file) guarantee the file's directory entry is safe?
Some file systems complete directory updates before the open/link/rename
system call returns, so fsync() doesn't have to worry about it.

- Does rename() guarantee that at least one directory entry will
exist even when the system crashes in the middle of the operation?

Postfix assumes both answers are "yes"; old ext2fs violated both
assumptions.

> > What if the crash happens after Postfix requests a 1-byte write in
> > the middle of a file, i.e. without changing the size?  A
> > reasonable implementation would not corrupt the file, but would
> > either update the file data or not change it. I can deal with
> > that.
> 
> That is exactly how XFS has always behaved for non-extending data
> overwrite. i.e. Exactly the same pretty much every filesystem that
> has ever existed.

Good. Thanks for confirming that XFS is not unusual.

	Wietse
