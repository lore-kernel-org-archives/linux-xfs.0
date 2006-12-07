Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Dec 2006 15:28:13 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kB7NS0aG013540
	for <xfs@oss.sgi.com>; Thu, 7 Dec 2006 15:28:03 -0800
Date: Fri, 8 Dec 2006 10:26:41 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: New CentOS4/RHEL4-compatible xfs module rpms
Message-ID: <20061207232641.GP33919298@melbourne.sgi.com>
References: <4560AB84.9060200@sandeen.net> <45784E71.4080605@falconstor.com> <457854CB.5030507@sandeen.net> <45785ABC.20208@falconstor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45785ABC.20208@falconstor.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Geir A. Myrestrand" <geir.myrestrand@falconstor.com>
Cc: xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>

On Thu, Dec 07, 2006 at 01:17:32PM -0500, Geir A. Myrestrand wrote:
> Eric Sandeen wrote:
> >Geir A. Myrestrand wrote:
> >
> >>However, I run into issues with xfs_freeze as it often locks up when I 
> >>try to freeze a file system where there is I/O activity. Sometimes it 
> >>happen on the first xfs_freeze invocation to freeze the file system, 
> >>other times I have to unfreeze and then it happens on the second time I 
> >>freeze. xfs_freeze never returns when this happens.
> >>
> >>Looks like xfs_io get stuck --see partial output from `ps auxf`:
> >>
> >>strace -ff -o freeze.txt xfs_freeze -f /mnt/xfs
> >>  \_ /bin/sh -f /usr/sbin/xfs_freeze -f /mnt/xfs
> >>      \_ /usr/sbin/xfs_io -r -p xfs_freeze -x -c freeze /mnt/xfs
> >>
> >>Anyone else encountering this issue?

Yes, and I fixed it about a 2 weeks ago. It's an ABBA deadlock between
lookup of multiple, already dirty, metadata buffers and synchronous buftarg
flushing (that occurs when trying to freeze a filesystem)

<sigh>

I just went looking for the Take message in the archive, and it is not
there. I cc all my takes to xfs@oss.sgi.com, so I'm not sure why it
isn't in the archive....

http://oss.sgi.com/archives/xfs/2006-11/msg00291.html

Was a followup cleanup of a problem found during review of the
fix for the freeze problem.

The text of the take message fo rthe fix is:

Fix a synchronous buftarg flush deadlock when freezing.

At the last stage of a freeze, we flush the buftarg synchronously
over and over again until it succeeds twice without skipping
any buffers.

The delwri list flush skips pinned buffers, but tries to flush
all others. It removes the buffers from the delwri list, then tries
to lock them one at a time as it traverses the list to issue
the I/O. It holds them locked until we issue all of the I/O
and then unlocks them once we've waited for it to complete.

The problem is that during a freeze, the filesystem may
still be doing stuff - like flushing delalloc data buffers -
in the background and hence we can be trying to lock buffers
that were on the delwri list at the same time.  Hence we can
get ABBA deadlocks between threads doing allocation and the
buftarg flush (freeze) thread.

Fix it by skipping locked (and pinned) buffers as we traverse the
delwri buffer list.

----

And the diff was:

http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.c.diff?r1=1.229;r2=1.230

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
