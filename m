Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Jun 2007 02:01:44 -0700 (PDT)
Received: from smtp110.sbc.mail.re2.yahoo.com (smtp110.sbc.mail.re2.yahoo.com [68.142.229.95])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5B91eWt024622
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2007 02:01:41 -0700
Date: Mon, 11 Jun 2007 02:01:38 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: xfs_fsr allocation group optimization
Message-ID: <20070611090138.GA28907@tuatara.stupidest.org>
References: <1181544692.19145.44.camel@gentoo-johan.transmode.se> <20070611073559.GA26257@tuatara.stupidest.org> <1181551409.19145.57.camel@gentoo-johan.transmode.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181551409.19145.57.camel@gentoo-johan.transmode.se>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Johan Andersson <johan@e-626.net>
Cc: xfs@oss.sgi.com

On Mon, Jun 11, 2007 at 10:43:29AM +0200, Johan Andersson wrote:

> But xfs_fsr sorts inodes by number of extents in order to optimise
> free space.

yeah, and the 'window' it uses is fairly small, iirc it does a
bulkstat of 64-inodes at a time and then sorts from the worst to the
best

i have a tree somewhere[1] that has this as a command line option as
well as a few other things

> If you run the "find ..." on a badly fragmented file system, it
> won't optimise much at all, since there won't be free chunks large
> enough for big files.

yes, that's always going to be the case though with the current simple
but somewhat arguably myopic algorithm

> I tried to just copy one file and remove the original in the file
> system mentioned, but it only got worse.

long-term we need to teach things like cp and rsync about
preallocation, but the generic APIs for this haven't bene fully
fleshed out

without that you're almost certainly going to get some level of
fragmentation for files over a certain size (smaller files end up
being contiguous usually becaue of delayed allocation)

> Running running xfs_fsr on the whole file system got it down to 0%
> file frag, 1 extent/file.

using "find .... xfs_fsr" you get temporary files in the same AG as
the file your are defragmenting, avoiding the spreading out effect,
but this might not be the least-defragmented file you can get

what's really needed is an attempt to find space near the original
file if possible and if not then an option to try harder looking in
other AGs

> So xfs_fsr on a whole file system is much more effective than
> xfs_fsr on each file in the file system. Especially if the file
> system is near full.

well, xfs_fsr doesn't work very well if the filesystem is near full
for the most part

it works very well if you have a reasonable amount of free-space (say
5%) but what's really needed is a smarter way to defragment, perhaps
by tweaking the allocator to avoid some AGs or parts of the device so
we cab bubble things about.  if people are serious about shrink work
maybe those APIs could assist here.





[1] sorry, i'm not sure where, there are also options not to touch
    recently created files as that's often they are in use and to also
    not bother doing the defragment unless the improvement is fairly
    significant, so it tends to spend it's time doing work that makes
    the biggest most useful impact

    i think the tree that has all these changes ended up being ugly
    and the changes weren't cleanly separated and thus were never
    posted

    if i find the tree i'll just publish it as-is
