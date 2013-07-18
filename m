Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F223C7F3F
	for <xfs@oss.sgi.com>; Wed, 17 Jul 2013 22:18:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8DEF8AC005
	for <xfs@oss.sgi.com>; Wed, 17 Jul 2013 20:18:02 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	CqRnPJVIVLha8ySH for <xfs@oss.sgi.com>;
	Wed, 17 Jul 2013 20:18:01 -0700 (PDT)
Date: Thu, 18 Jul 2013 13:17:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: splice vs execve lockdep trace.
Message-ID: <20130718031759.GN11674@dastard>
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
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Ben Myers <bpm@sgi.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Dave Jones <davej@redhat.com>, xfs@oss.sgi.com

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

We cross our fingers and hope. Always have. Races are rare as
historically there have been only a handful of applications that do
the necessary operations to trigger them. However, with holepunch
now a generic fallocate() operation....

> Because if you return *that* kind of stale data, than you're horribly
> horribly buggy. And you cannot *possibly* blame
> generic_file_splice_read() on that.

Right, it's horribly buggy and I'm not blaming
generic_file_splice_read().

I'm saying that the page cache architecture does not providing
mechanisms to avoid the problem. i.e. that we can't synchronise
multi-page operations against a single page operation that only uses
the page lock for serialisation without some form of filesystem
specific locking. And that the i_mutex/i_iolock/mmap_sem inversion
problems essentially prevent us from beign able to fix it in a
filesystem specific manner.

We've hacked around this read vs invalidation race condition for
truncate() by putting ordered operations in place to avoid
refaulting after invalidation by read operations. i.e. truncate was
optimised to avoid extra locking, but now the realisation is that
truncate is just a degenerate case of hole punching and that hole
punching cannot make use of the same "beyond EOF" optimisations to
avoid race conditions with other IO.

We (XFS developers) have known about this for years, but we've
always been told when it's been raised that it's "just a wacky XFS
problem".  Now that other filesystems are actually implementing the
same functionality that XFS has had since day zero, they are also
seeing the same architectural deficiencies in the generic code. i.e.
they are not actually "whacky XFS problems".  That's why we were
talking about a range-locking solution to this problem at LSF/MM
this year - to find a generic solution to the issue...

FWIW, this problem is not just associated with splice reads - it's a
problem for the direct IO code, too. The direct IO layer has lots of
hacky invalidation code that tries to work around the fact that
mmap() page faults cannot be synchronised against direct IO in
progress. Hence it invalidates caches before and after direct IO is
done in the hope that we don't have a page fault that races and
leaves us with out-of-date data being exposed to userspace via mmap.
Indeed, we have a regression test that demonstrates how this often
fails - xfstests:generic/263 uses fsx with direct IO and mmap on the
same file and will fail with data corruption on XFS.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
