Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o02EDejc117892 for <xfs@oss.sgi.com>; Sat, 2 Jan 2010 08:13:40 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DE7671DABB03
	for <xfs@oss.sgi.com>; Sat,  2 Jan 2010 06:14:28 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	15G5mpVCEFj0hmVJ for <xfs@oss.sgi.com>;
	Sat, 02 Jan 2010 06:14:28 -0800 (PST)
Date: Sun, 3 Jan 2010 01:14:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] XFS: Sort delayed write buffers before dispatch
Message-ID: <20100102141414.GK13802@discord.disaster>
References: <1262401416-19546-1-git-send-email-david@fromorbit.com>
	<1262401416-19546-4-git-send-email-david@fromorbit.com>
	<87fx6o7iy3.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87fx6o7iy3.fsf@basil.nowhere.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Andi Kleen <andi@firstfloor.org>
Cc: axboe@kernel.dk, xfs@oss.sgi.com

On Sat, Jan 02, 2010 at 02:08:36PM +0100, Andi Kleen wrote:
> Dave Chinner <david@fromorbit.com> writes:
> =

> > Currently when the xfsbufd writes delayed write buffers, it pushes
> > them to disk in the order they come off the delayed write list. If
> > there are lots of buffers =D1=95pread widely over the disk, this results
> > in overwhelming the elevator sort queues in the block layer and we
> > end up losing the posibility of merging adjacent buffers to minimise
> > the number of IOs.
> >
> > Add a sort array to the buftarg so that we can do high level sorting
> > of the buffers once they are pulled off the delwri queue for
> > writeback. Currently this array can hold 4096 buffers at a time
> > which gives us a window 32 times larger than the default elevator
> > maximums for ordering buffers.
> =

> At first look it seems a bit wasteful because the elevator
> sorts again. Is your window that much bigger than the elevators?

Easily - at currently limits we can log about 8000 inodes a megabyte
of log space and we can write over 150MB/s to the log. That adds up
to about 1.2million inodes dirtied a second, or 40,000 inode buffers
a second needing to be written back.....

We have much more of a clue about what is happening at the
filesytem level, and can optimise far more efficiently at higher
levels. The elevator can only merge IOs if the higher layer sends
it adjacent blocks.

I don't want to do buffer merging in XFS, but I want adjacent IOs
merged and the elevator does that well. Rather than sending buffers
down in random order and only getting a few merges, sorting all the
buffers first guarantees that all possible merges are made by the
elevator across the entire dispatch without needing to tweak the
elevator at all.

IOWs, being smart at the higher layers where you have the context to
do a good job means we don't need to add heuristics or tweaks to try
to guess the best thing to do at the lower layers.

> Perhaps the sort queue in the elevator should be just enlarged?

Which we used to do and that caused all sorts of latency and OOM
issues by pinning huge amounts of dirty memory in the elevators.

> > Ideally this should use a list sort rather than requiring an
> > external buffer to sort the buffers in, but for simplicity
> > just do it via sort function.
> =

> Doing merge sort on lists is relatively simple There are
> plenty examples in a google search. An alternative is also
> to construct a rbtree on the fly and then walk it.

Already got it handled - there's a couple of copies of list_sort()
already in the tree - I'll post an updated patch set in the next
couple of days after I've had a chance to QA it.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
