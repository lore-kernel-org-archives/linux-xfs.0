Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p532tMxZ242157 for <xfs@oss.sgi.com>; Thu, 2 Jun 2011 21:55:23 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E8221D70514
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2011 19:55:19 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	jXD1mPyzlW9i3NRw for <xfs@oss.sgi.com>;
	Thu, 02 Jun 2011 19:55:19 -0700 (PDT)
Date: Fri, 3 Jun 2011 12:54:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: I/O hang, possibly XFS, possibly general
Message-ID: <20110603025459.GB561@dastard>
References: <BANLkTim_BCiKeqi5gY_gXAcmg7JgrgJCxQ@mail.gmail.com>
	<19943.56524.969126.59978@tree.ty.sabi.co.UK>
	<BANLkTim978GhfamN=TEFULP5GdfMu02-7w@mail.gmail.com>
	<4DE823DD.7060600@philkarn.net> <20110603003907.GW561@dastard>
	<BANLkTikg33_Q89XVuXZgaAAMbhDHnPR+fg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTikg33_Q89XVuXZgaAAMbhDHnPR+fg@mail.gmail.com>
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
To: karn@ka9q.net
Cc: Paul Anderson <pha@umich.edu>, Linux fs XFS <xfs@oss.sgi.com>

On Thu, Jun 02, 2011 at 07:11:15PM -0700, Phil Karn wrote:
> On Thu, Jun 2, 2011 at 5:39 PM, Dave Chinner <david@fromorbit.com> wrote:
> 
> >
> > You're ignoring the fact that delayed allocation effectively does
> > this for you without needing to physically allocate the blocks.
> > So when you have files that are short lived, you don't actually do
> > any allocation at all, Further delayed allocation results in
> > allocation order according to writeback order rather than write()
> > order, so I/O patterns are much nicer when using delayed allocation.
> >
> 
> Oh, I'm well aware of delayed allocation. I've just noticed that, in my
> experience, it doesn't seem to work nearly as well as fallocate(). And why
> should it? If you know in advance how big a file you're writing, how can it
> hurt to inform your file system? I suppose the FS implementer could always
> ignore that information if he felt he could somehow do a better job, but
> it's hard to see how. Isn't it always better to know than to guess?

There are definitely cases where it helps for preventing
fragmenting, but as a sweeping generalisation it is very, very
wrong.

> I'm talking here about the genuine fallocate() system call, not the POSIX
> hack that falls back to first conventionally writing zeroes over the file.
> The true fallocate() call seems very fast, and if your file system doesn't
> support it then it will simply fail without harm. I still can't see any
> reason not to use it.
> 
> I did know that xfs can avoid the disk allocation and writes entirely when
> the files are short-lived, but Paul was talking about writing large,
> long-lived files so that's what I had in mind. And when I use fallocate(),
> my files are not likely to be short-lived either. Like most people I write
> the vast majority of my short-lived files to /tmp, which is tmpfs, not xfs.

Do you do that for temporary object files when you build <program X>
from source?

> But you do raise an interesting point -- is there any serious performance
> degradation from using fallocate() on a short-lived file?

Allocation and freeing has CPU overhead, transaction overhead, log
space overhead, can cause free space fragmentation when you have a
mix of short- and long-lived files being preallocated at the same
time, IO for long lived data does not get packed together closely so
requires more seeks to issue which leads to significantly worse IO
performance on RAID5/6 storage sub-systems, etc.

I could go one for quite some time, but the overal effect of such
behaviour is that it speeds up filesystem aging degradation
significantly. You might not notice that for 6 months or a year, but
when you do....

> The written data
> still lives in the buffer cache for a while, so if you delete the file
> before it gets flushed the disk writes will still be avoided. The file
> system may have a little extra work to undo the unnecessary allocation but
> that doesn't seem to be a big deal.
> 
> Basicaly you are removing one of the major IO optimisation
> > capabilities of XFS by preallocating everything like this.
> >
> 
> "Remove" it? How is giving it the correct answer worse than letting it guess
> -- even if it usually guesses correctly?

See above.

> I still rely on preallocation to keep log files and mailboxes from getting
> too badly fragmented.
> 
> >So you don't have any idea of how well XFS minimises fragmentation
> 
> > without needing to use preallocation? Sounds like you have a classic
> > case of premature optimisation. ;)
> >
> >
> As I said, I've tried it both ways. I found that the simple act of adding
> fallocate() to rsync (which I use for practically all copying) vastly
> reduces xfs fragmentation. Just as I expected it would.
> 
> Maybe I'm a little more sensitive to fragmentation than most because I've
> been experimenting with storing SHA1 hashes of all my files in external
> attributes. This grew out of a data deduplication tool; at first I simply
> cached the hashes so I wouldn't have to recompute them on another run, but
> then I just added them to every file. This lets me get a warm and fuzzy
> feeling by periodically verifying that my files haven't been corrupted,
> especially when I began to use SSDs with trim tools.
> 
> XFS stores both attributes and extent lists directly in the inode when
> there's room, and it turns out that a default-sized xfs inode can store my
> hashes provided that the extent list is small. So I now when I walk through
> my file system statting everything I can read the hashes too at absolutely
> no extra cost. This makes deduplication really fast.

/me slaps his forehead.

You do realise that your "attr out of line" problem would have gone
away by simply increasing the XFS inode size at mkfs time? And that
there is almost no performance penalty for doing this?  Instead, it
seems you found a hammer named fallocate() and proceeded to treat
every tool you have like a nail. :)

Changing a single mkfs parameter is far less work than maintaining
your own forks of multiple tools....

> I haven't experimented to see how many extents a file can have
> before the attributes get pushed out of the inode, but by keeping
> most everything contiguous I simply avoid the problem.

Until aging has degraded your filesystem til free space is
sufficiently fragmented that you can't allocate large extents any
more. Then you are completely screwed. :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
