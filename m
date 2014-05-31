Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9009C7F74
	for <xfs@oss.sgi.com>; Sat, 31 May 2014 00:55:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1A85EAC001
	for <xfs@oss.sgi.com>; Fri, 30 May 2014 22:55:04 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	RpTdzzZ6FvErnT7q for <xfs@oss.sgi.com>;
	Fri, 30 May 2014 22:55:02 -0700 (PDT)
Date: Sat, 31 May 2014 15:54:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Message-ID: <20140531055457.GK14410@dastard>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<1401480116-1973111-12-git-send-email-arnd@arndb.de>
	<20140531003712.GH14410@dastard> <5389252A.5050503@zytor.com>
	<20140531011450.GJ14410@dastard>
	<c7770275-61de-4e94-9586-5ee118f77ba5@email.android.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <c7770275-61de-4e94-9586-5ee118f77ba5@email.android.com>
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
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, john.stultz@linaro.org, lftan@altera.com, linux-fsdevel@vger.kernel.org, geert@linux-m68k.org, tglx@linutronix.de, joseph@codesourcery.com


[ Please don't top post. ]

On Fri, May 30, 2014 at 06:22:55PM -0700, H. Peter Anvin wrote:
> On May 30, 2014 6:14:50 PM PDT, Dave Chinner <david@fromorbit.com> wrote:
> >On Fri, May 30, 2014 at 05:41:14PM -0700, H. Peter Anvin wrote:
> >> On 05/30/2014 05:37 PM, Dave Chinner wrote:
> >> > 
> >> > IOWs, the filesystem has to be able to reject any attempt to
> >> > set a timestamp that is can't represent on disk otherwise Bad
> >> > Stuff will happen,
> >> 
> >> Actually it is questionable if it is worse to reject a
> >> timestamp or
> >just
> >> let it wrap.  Rejecting a valid timestamp is a bit like "You
> >> don't exist, go away."
> >
> >I think having the new systems calls being able to return EINVAL
> >if the value cannot be stored permanently on disk correctly is
> >the right thing to do. Having it silently mangled by the
> >filesystem and returning "everything is just fine, trust me" is
> >close to the worst solution I can think of. That's exactly what
> >leads to overflow bugs occurring....
> >
> >> > and filesystems have to be able to specify in their on disk
> >> > format what timestamp encoding is being used. The solution
> >will
> >> > be different for every filesystem that needs to support time
> >> > beyond 2038.
> >> 
> >> Actually the cutoff can be really different for each
> >> filesystem, not necessarily 2038.  However, I maintain the
> >> above still holds.
> >
> >Sure, but all filesystems are supposed to handle at least the
> >current unix epoch.
> >
> >> Consider a filesystem that kept timestamps in YYMMDDHHMMSS
> >> format. 
> >What
> >> would you have expected such a filesystem to do on Jan 1, 2000?
> >
> >Strawman.
> >
> >We don't need to cater for fundamentally broken designs that
> >can't even handle the current unix epoch correctly. If such
> >filesystems exist, then they can simple say "original unix epoch
> >support only" and do whatever crap they are doing right now.
>
> No, not a strawman.  Replace with Jan 26, 2038 and you have the
> same situation.

But that's not the problem I'm talking about.  The problem isn't the
roll-over date of the epoch - the problem is that we're changing the
in-memory meaning of time without changing what the filesystems
store on disk or how they translate them.

To use your example, what I'm actually talking about is the kernel
switching to CCYYMMDDHHMMSS while the filesystem has YYMMDDHHMMSS on
disk. The filesystem doesn't know the timestamp is now a different
format, so it could mangle it writing it to disk, or it could mangle
existing timestamps in the YY.. format reading them from disk and
putting them into CC.. format structures. IOWs, it will
incorrectly translate YY  format dates to CC format, or translate
something in the CC format as though it was in YY format. And it
wouldn't even know what was the correct format because there's
nothing telling it on disk whether the date is in CC or YY format.

Either way, you get mangled timestamps, the filesystem doesn't know
about it because it's just storing what the kernel gives it, the
kernel thinks they are fine because they are just opaque when read
back, but the user says "what the fuck did a reboot do to all these
timestamps?".

Hence your example of roll-over dates is a strawman - you've
constructed a problem that is irrelevant to the issue being pointed
out.

FWIW, we already have code in the superblock and VFS to avoid such
problems on filesystems with limited timestamp resolution (i.e
s_time_gran and current_fs_time()) so that what the VFS hands the
filesystem is exactly what the VFS expects to get back from disk
when comparing timestamps.

If we are changing the in-kernel timestamp to have a greater dynamic
range that anything we current support on disk, then we need support
for all filesystems for similar translation and constraint. The
filesystems need to be able to tell the kernel what they timestamp
range they support, and then the kernel needs to follow those
guidelines. And if the filesystem is mounted on a kernel that
doesn't support the current filesystem's timestamp format, then at
minimum that filesystem cannot do anything that writes a
timestamp....

Put simply: the filesystem defines the timestamp range that can be
used safely, not the userspace API. If the filesystem can't support
the date it is handed then that is an out-of-range error. Since
when have we accepted that it's OK to handle out-of-range data with
silent overflows or corruption of the data that we are attempting to
store? We're defining a new API to support a wider date range -
there is nothing that prevents us from saying ERANGE can be returned
to a timestamp that the file cannot store correctly....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
