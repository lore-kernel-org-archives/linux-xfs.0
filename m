Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o02D7qmC111488 for <xfs@oss.sgi.com>; Sat, 2 Jan 2010 07:07:53 -0600
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5D3211DAB926
	for <xfs@oss.sgi.com>; Sat,  2 Jan 2010 05:08:39 -0800 (PST)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id KOadd3aBettPZ41n for
	<xfs@oss.sgi.com>; Sat, 02 Jan 2010 05:08:39 -0800 (PST)
Subject: Re: [PATCH 3/3] XFS: Sort delayed write buffers before dispatch
From: Andi Kleen <andi@firstfloor.org>
References: <1262401416-19546-1-git-send-email-david@fromorbit.com>
	<1262401416-19546-4-git-send-email-david@fromorbit.com>
Date: Sat, 02 Jan 2010 14:08:36 +0100
In-Reply-To: <1262401416-19546-4-git-send-email-david@fromorbit.com> (Dave
	Chinner's message of "Sat, 2 Jan 2010 14:03:36 +1100")
Message-ID: <87fx6o7iy3.fsf@basil.nowhere.org>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: axboe@kernel.dk, xfs@oss.sgi.com

Dave Chinner <david@fromorbit.com> writes:

> Currently when the xfsbufd writes delayed write buffers, it pushes
> them to disk in the order they come off the delayed write list. If
> there are lots of buffers =D1=95pread widely over the disk, this results
> in overwhelming the elevator sort queues in the block layer and we
> end up losing the posibility of merging adjacent buffers to minimise
> the number of IOs.
>
> Add a sort array to the buftarg so that we can do high level sorting
> of the buffers once they are pulled off the delwri queue for
> writeback. Currently this array can hold 4096 buffers at a time
> which gives us a window 32 times larger than the default elevator
> maximums for ordering buffers.

At first look it seems a bit wasteful because the elevator
sorts again. Is your window that much bigger than the elevators?
Perhaps the sort queue in the elevator should be just enlarged?

>
> Ideally this should use a list sort rather than requiring an
> external buffer to sort the buffers in, but for simplicity
> just do it via sort function.

Doing merge sort on lists is relatively simple There are
plenty examples in a google search. An alternative is also
to construct a rbtree on the fly and then walk it.

But if you use sort() this way you probably should at least
add a u64 swap function to lib/sort.c, otherwise
all the pointers will be exchanged byte-by-byte on 64bit
systems which is rather slow.

-andi


-- =

ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
