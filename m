Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4H8cBUY174259 for <xfs@oss.sgi.com>; Tue, 17 May 2011 03:38:12 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B6A6245AC5B
	for <xfs@oss.sgi.com>; Tue, 17 May 2011 01:38:09 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	gbPKYSxoJIWBuq2b for <xfs@oss.sgi.com>;
	Tue, 17 May 2011 01:38:09 -0700 (PDT)
Date: Tue, 17 May 2011 18:38:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Files appear too big in `du`
Message-ID: <20110517083804.GU19446@dastard>
References: <20110510105700.GA20307@citd.de> <20110510131705.GE19446@dastard>
	<20110510153300.GA5764@citd.de> <20110512100153.GA19381@citd.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110512100153.GA19381@citd.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Matthias Schniedermeyer <ms@citd.de>
Cc: xfs@oss.sgi.com

On Thu, May 12, 2011 at 12:01:53PM +0200, Matthias Schniedermeyer wrote:
> On 10.05.2011 17:33, Matthias Schniedermeyer wrote:
> > 
> > > > Any idea how to debug this, or is this a known bug and waiting a few 
> > > > days for 2.6.39 should fix this?
> > > 
> > > It doesn't appear to be doing anything wrong from your description.
> > > Remember that XFS is optimised for high end storage and server
> > > configurations and workloads, not typical desktop usage...
> > 
> > I would call it a regression.
> > I reguarly follow copying/downloading with `du`, the speculative
> > preallocation makes that more or less useless.

There's no guarantee that what du reports is in any way relevant to
the size of the file that is being written. e.g. the filesystem
might be compressing the file, doing inline deduplication,
speculative preallocation, filling holes with preallocated space,
etc. Indeed, XFS reports delayed allocation reservations in du -
blocks that haven't even been allocated yet - but it's always done
that and the behaviour you describe is what you always seen when
using the allocsize mount option....

In essence, a filesystem is free to allocate blocks in any way it
desires - you cannot rely on different filesystems to behave the
same way, and even different releases of the same filesystem to
behave the same way. It's just a bad assumption to make.

> > Especially downloading 
> > someting big from the internet which @ 231kb/s isn't exactly fast and 
> > shows identical `du`s for increasingly longer periods of time.
> > (Or "--apparent-size" should be made default, but that falls short with 
> > sparse-files)

Use an application that shows download progress?

> > IMHO `du`/`ls -l` should not be able to 'see' the speculative 
> > preallocation.

ls -l cannot see speculative preallocation beyond EOF of any kind.
Never has, never will - it only reports the file size, not the
number of blocks allocated.  du _should_ report it because it is
supposed to report the number of blocks allocated to the inode.
IOWs, they report two different things, so they should have
different behaviour....

> After digging into the log of v2.6.37..v2.6.38 i stumbled upon:
> 
> - snip -
>     The allocsize mount option turns off the dynamic behaviour and fixes
>     the prealloc size to whatever the mount option specifies. i.e. the
>     behaviour is unchanged.
> - snip -
> 
> I think Documentation/filesystems/xfs.txt is in need of an update. All 
> that information in the commit-log is a little "out-of-reach" for most 
> people.

Patches welcome.

> -- 
> Real Programmers consider "what you see is what you get" to be just as 
> bad a concept in Text Editors as it is in women. No, the Real Programmer
> wants a "you asked for it, you got it" text editor -- complicated, 
> cryptic, powerful, unforgiving, dangerous.

s/text editor/file system/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
