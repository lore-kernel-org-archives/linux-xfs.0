Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 May 2007 22:25:32 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l485PQfB014571
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 22:25:28 -0700
Date: Tue, 8 May 2007 15:25:21 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: RESVSP problems
Message-ID: <20070508052521.GH32602149@melbourne.sgi.com>
References: <200705072004.22848.lucke@o2.pl> <463F7368.8090101@sandeen.net> <200705072058.32679.lucke@o2.pl> <20070508005923.GS77450368@melbourne.sgi.com> <4640048B.6070803@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4640048B.6070803@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Chinner <dgc@sgi.com>, =?iso-8859-1?Q?=C5=81ukasz?= Fibinger <lucke@o2.pl>, xfs@oss.sgi.com

On Tue, May 08, 2007 at 12:03:07AM -0500, Eric Sandeen wrote:
> David Chinner wrote:
> 
> >>>yeah... ISTR that the arguments are funky.  I can't remember if it's a
> >>>bug or not.  :)  FWIW, allocsp just writes zeros to the file, so you
> >>>could do it just as well from userspace w/ no fancy ioctls...  ALLOCSP
> >>>is a bit pointless if you ask me... though maybe someone knows why it's
> >>>there :)
> >>Let me say that I have noticed that using ALLOCSP seems to create less 
> >>extents than posix_fallocate/manual zeroing.
> >
> >Yes, that's likely ;)
> >
> >There's work currently active to make posix_fallocate() do the same thing
> >as ALLOCSP (i.e. call into the filesystem and let it do smart stuff), but
> >that's a ways off yet...
> 
> Dave, doesn't ALLOCSP actually create actual zeroed space though? 

Ah, yes it does - I was sort of lumping allocsp/resvsp together as one
there.

> Pretty much as posix_fallocate from userspace does today, maybe with 
> better allocation...

Better allocations and with no ENOSPC-after-partial-zeroing problems,
either.

> And "smart stuff" would be *not* needing to write 
> zeros.... i.e. what RESVSP does.

Yup. I've implemented fallocate() with the equivalent of RESVSP.
xfs_zero_eof() is smart enough to not try to zero unwritten extents
so changing the filesize after preallocation is effectively a no-op ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
