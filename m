Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 076737F3F
	for <xfs@oss.sgi.com>; Wed, 17 Jul 2013 18:40:54 -0500 (CDT)
Date: Wed, 17 Jul 2013 18:40:49 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: splice vs execve lockdep trace.
Message-ID: <20130717234049.GC3572@sgi.com>
References: <CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
	<20130716060351.GE11674@dastard> <20130716193332.GB3572@sgi.com>
	<CA+55aFzTBUKStdZu1GhKoiYc2knybhiaUFr2By98QYew_STE=A@mail.gmail.com>
	<20130716204335.GH11674@dastard>
	<CA+55aFwHMQd-VDeTDh-gm3jyj+5+FSoAHOeU47mwU-mKtEj9RQ@mail.gmail.com>
	<20130717040616.GI11674@dastard>
	<CA+55aFz5xw9Qi9Q6mwoCSud5eQh5u-QZ-xrY+TqgZPoKOgn6ew@mail.gmail.com>
	<20130717055103.GK11674@dastard>
	<CA+55aFxdqzMY5VJoYaLmL=+=f2s1cbHHV-TjC3=taXpF-xov1w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFxdqzMY5VJoYaLmL=+=f2s1cbHHV-TjC3=taXpF-xov1w@mail.gmail.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Dave Jones <davej@redhat.com>, xfs@oss.sgi.com

Linus,

On Wed, Jul 17, 2013 at 09:03:11AM -0700, Linus Torvalds wrote:
> On Tue, Jul 16, 2013 at 10:51 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > But When i say "stale data" I mean that the data being returned
> > might not have originally belonged to the underlying file you are
> > reading.
> 
> We're still talking at cross purposes then.
> 
> How the hell do you handle mmap() and page faulting?

__xfs_get_blocks serializes access to the block map with the i_lock on the
xfs_inode.  This appears to be racy with respect to hole punching.

> Because if you return *that* kind of stale data, than you're horribly
> horribly buggy. And you cannot *possibly* blame
> generic_file_splice_read() on that.

Seems to me we'd need to hold the page lock on every page in the hole to
provide exclusion with splice read and mmap faults, then remove the extents,
and finally truncate the pages away.  I think at that point the reads could be
done without the iolock.  Or, is there a different lock that could do the trick?

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
