Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A28CD29DF8
	for <xfs@oss.sgi.com>; Sun,  1 Jun 2014 21:22:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5136A8F8040
	for <xfs@oss.sgi.com>; Sun,  1 Jun 2014 19:22:40 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	tsOSQWjMy33gLc0e for <xfs@oss.sgi.com>;
	Sun, 01 Jun 2014 19:22:34 -0700 (PDT)
Date: Mon, 2 Jun 2014 12:22:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Message-ID: <20140602022211.GN6677@dastard>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<538995D4.9050702@zytor.com>
	<alpine.LFD.2.11.1405311055410.17310@knanqh.ubzr>
	<8618458.1EVJCoVbkH@wuerfel>
	<alpine.LFD.2.11.1406012121430.17310@knanqh.ubzr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1406012121430.17310@knanqh.ubzr>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, lftan@altera.com, hch@infradead.org, john.stultz@linaro.org, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, geert@linux-m68k.org, tglx@linutronix.de, xfs@oss.sgi.com, joseph@codesourcery.com

On Sun, Jun 01, 2014 at 09:36:26PM -0400, Nicolas Pitre wrote:
> On Sun, 1 Jun 2014, Arnd Bergmann wrote:
> > On Saturday 31 May 2014 11:46:16 Nicolas Pitre wrote:
> > For actually running kernels beyond 2038, the best idea I've seen so
> > far is to disallow all broken code at compile time. I don't see
> > a choice but to audit the entire kernel for invalid uses on both
> > 32 and 64 bit in the next few years. A lot of code will get changed
> > in the process so we can actually keep running 32-bit kernels and
> > file systems, but other code will likely go away:
> > 
> > * any system calls that pass a time_t, timeval or timespec on
> >   32-bit systems return -ENOSYS, to ensure all user land uses
> >   the replacements we will put into place
> > * The definition of 'time_t', 'timval' and 'timespec' can be hidden
> >   from the kernel, and all code using it left out.
> > * ext2 and ext3 file system code will have to be disabled, but that's
> >   file since ext4 can mount old file systems.
> 
> Syscalls and libs can be "fixed".  Existing filesystem content might 
> not.  So if you need to mount some old media in read-write mode after 
> 2038 and that happens to content an ext2 or similarly limited filesystem 
> then it'd better just "work".  Having the kernel refuse to modify the 
> filesystem would be unacceptable.

We can already tell the VFS/filesystems not to update timestamps:

	inode->i_flags |= S_NOATIME | S_NOCMTIME;

Just enforce that everywhere (i.e. notify_change()) rather than just
on the IO path and the "legacy filesystem timestamp" problem is
"solved".

New interfaces need to return errors when an out-of-range parameter
is set. And right now, >epoch dates are out of range for most
filesystems, and so we need to handle that condition appropriately.
Silent date overflow == filesystem corruption, and as such I'm going
to error out such conditions in the filesystem regardless of what
the userspace API says.

Filesystems place all sorts of userspace visible limits on storage -
ever tried to create a file >16TB on ext4? The on-disk format
doesn't support it, so it returns an out of range error (E2BIG, I
think) if you try. XFS, OTOH, handles this just fine and so it
continues to work. It's exactly the same with timestamps - there's a
physical limit to what can sanely be stored in any given filesystem
and it's an *error condition* to go beyond that limit....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
