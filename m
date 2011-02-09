Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p19I3JSr018250 for <xfs@oss.sgi.com>; Wed, 9 Feb 2011 12:03:20 -0600
Subject: Re: [PATCH 1/3] libxfs: reintroduce old xfs_repair radix-tree code
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1294649091-27174-2-git-send-email-david@fromorbit.com>
References: <1294649091-27174-1-git-send-email-david@fromorbit.com>
	<1294649091-27174-2-git-send-email-david@fromorbit.com>
Date: Wed, 09 Feb 2011 12:05:13 -0600
Message-ID: <1297274713.2513.27.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, 2011-01-10 at 19:44 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The current kernel code uses radix trees more widely than the
> previous code, so for the next sync we need radix tree support in
> libxfs. Pull the old radix tree code out the xfs_repair git history
> and move it into libxfs to simplify the kernel code sync.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

OK, I actually reviewed this code, even though it had
already been present in the source tree prior to commit:
379397bf9... ("repair: use a btree instead of a radix tree
for the prefetch queue").

And I have some suggestions, and I have at least one
thing that I think is a bug.

I also notice that this code apparently formed the
basis of the kernel's implementation.  That's good.
It's probably worth reviewing the kernel version's
history to see if there are any bug fixes that ought
to be brought back into this code (and vice-versa).


All that being said, I think the right thing to do
is to include this change as-is as a commit.  It
includes both "radix-tree.c" and "radix-tree.h" as
identical copies of what was removed (though each
now resides in a different directory from before),
thereby preserving the provenance of the code.

Then, after it's committed, I can offer my suggested
changes, or even just implement and propose them
myself.

So unless you disagree with this approach I think
it's fine to commit it as you originally posted it.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
