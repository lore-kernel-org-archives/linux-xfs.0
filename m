Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 May 2007 17:59:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l480xYfB027310
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 17:59:36 -0700
Date: Tue, 8 May 2007 10:59:23 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: RESVSP problems
Message-ID: <20070508005923.GS77450368@melbourne.sgi.com>
References: <200705072004.22848.lucke@o2.pl> <463F7368.8090101@sandeen.net> <200705072058.32679.lucke@o2.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200705072058.32679.lucke@o2.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?iso-8859-1?Q?=C5=81ukasz?= Fibinger <lucke@o2.pl>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Mon, May 07, 2007 at 08:58:32PM +0200, Å?ukasz Fibinger wrote:
> On Monday 07 of May 2007, you wrote:
> > You've probably hit:
> > http://oss.sgi.com/bugzilla/show_bug.cgi?id=418
> > unwritten extents remain unwritten after mmap() modifies them
> >
> > Bug dchinner about it... ;-)
> 
> Dave, consider it a bugging from my humble self :-)

Yeah, yeah ;)

I'm waiting to see what happens with Nick's patches in .22 before
going any further. If they are not merged into .22, then I think we
should push the XFS specific fix in....

> > yeah... ISTR that the arguments are funky.  I can't remember if it's a
> > bug or not.  :)  FWIW, allocsp just writes zeros to the file, so you
> > could do it just as well from userspace w/ no fancy ioctls...  ALLOCSP
> > is a bit pointless if you ask me... though maybe someone knows why it's
> > there :)
> 
> Let me say that I have noticed that using ALLOCSP seems to create less extents 
> than posix_fallocate/manual zeroing.

Yes, that's likely ;)

There's work currently active to make posix_fallocate() do the same thing
as ALLOCSP (i.e. call into the filesystem and let it do smart stuff), but
that's a ways off yet...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
