Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D826D7FC1
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 17:55:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6A455AC012
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 15:55:02 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ejjRDPovXYsV9DUS for <xfs@oss.sgi.com>;
	Mon, 07 Apr 2014 15:55:00 -0700 (PDT)
Date: Tue, 8 Apr 2014 08:54:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [FAQ v2] XFS speculative preallocation
Message-ID: <20140407225454.GB27017@dastard>
References: <20140407153906.GC48184@bfoster.bfoster> <53430375.3060203@sgi.com>
	<20140407214527.GA43531@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140407214527.GA43531@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Mon, Apr 07, 2014 at 05:45:27PM -0400, Brian Foster wrote:
> On Mon, Apr 07, 2014 at 02:58:45PM -0500, Mark Tinguely wrote:
> > On 04/07/14 10:39, Brian Foster wrote:
> > >See the FAQ entry on speculative preallocation for details.
> > >
> > >Q: What is speculative preallocation?
> > >
> > >A:
> > >
> > >XFS speculatively preallocates post-EOF blocks on file extending writes
> > >in anticipation of future extending writes. The size of a preallocation
> > >is dynamic and depends on the runtime state of the file and fs.
> > >Generally speaking, preallocation is disabled for very small files and
> > 			    vague what is very small?   ^^^
> > ...
> 
> I originally pointed out 64k, but that and other heuristic details that
> are subject to change were purged in v2. I'm personally not against
> including something that indicates the default and the notion that it's
> subject to change. I don't feel too strongly about it either way.
> Thoughts appreciated.

As i said in the original - if we put specific values in
here or describe the exact heuristics, then it will be wrong the
moment we change the code. If someone wants to know the exact
details on how it works, then they can look at the code for the
kernel they are running, because the behaviour can (and does) change
from kernel to kernel.

> > >Q: Is speculative preallocation permanent?
> > >
> > >A:
> > >
> > >Although speculative preallocation can lead to reports of excess space
> > >usage, the preallocated space is not permanent unless explicitly made so
> > >via fallocate or a similar interface. Preallocated space can also be
> > >encoded permanently in situations where file size is extended beyond a
> > >range of post-EOF blocks (i.e., via truncate). Otherwise, preallocated
> > >blocks are reclaimed on file close, inode reclaim, unmount or in the
> > >background once file write activity subsides.
> > 
> > Switch order?
> > 
> > Normally, preallocated
> > blocks are reclaimed on file close, inode reclaim, unmount or in the
> > background once file write activity subsides. They can be explictly
> > made permanent .
> > 
> 
> Thoughts on the following?
> 
> "Preallocated blocks are normally reclaimed on file close, inode
> reclaim, unmount or in the background once file write activity subsides.
> They can be explicitly made permanent via fallocate or a similar
> interface. They can be implicitly made permanent in situations where
> file size is extended beyond a range of post-EOF blocks (i.e., via an
> extending truncate)."

Speculative prealloc may end up permanent on a crash, because the
in-memory state used to track and reclaim the speculative
preallocation is lost.

> > >Q: My workload has known characteristics - can I tune speculative
> > >preallocation to an optimal fixed size?
> > >
> > >A:
> > >
> > >The 'allocsize=' mount option configures the XFS block allocation
> > >algorithm to use a fixed allocation size. Speculative preallocation is
> > >not dynamically resized when the allocsize mount option is set and thus
> > >the potential for fragmentation is increased. XFS historically set
> > 
> > sets the
> > 
> > >allocsize to 64k by default.
> > >
> > 
> > 
> > Q: Can I disable S-P-A ?
> > 
> 
> A: No..? ;)

That's the correct answer ;)

> Are you proposing this with the similar intent to the previous Q (i.e.,
> "what's the alternative to the default behavior?"), or with the notion
> that Dave pointed out how technically preallocation is not really "off?"
> Or something else? If the former, we could modify the question:
> 
> "My workload has known characteristics - can I disable speculative
> preallocation or tune it to an optimal fixed size?"

Yup, I'd change the questions like that.

> Or something along those lines. Would anybody object to also pointing
> out that 'allocsize=4k' (or allocsize=<blocksize>?) could be considered
> "speculative preallocation == off" from the user's perspective?

>From a users perspective, fixed size preallocation with anything
less than allocsize=64k would be "off". That was the old default,
and no user ever noticed that speculative prealloc was occurring
except on large files when it failed to prevent fragmentation....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
