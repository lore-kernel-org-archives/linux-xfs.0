Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8C73B7F83
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2014 18:06:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2AFACAC001
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2014 16:06:29 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Ukf4tDX7YHGH70sj for <xfs@oss.sgi.com>;
	Fri, 21 Mar 2014 16:06:27 -0700 (PDT)
Date: Sat, 22 Mar 2014 10:05:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [FAQ] XFS speculative preallocation
Message-ID: <20140321230553.GB1389@dastard>
References: <20140321162920.GA3087@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140321162920.GA3087@laptop.bfoster>
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
Cc: xfs@oss.sgi.com

On Fri, Mar 21, 2014 at 12:29:20PM -0400, Brian Foster wrote:
> Hi all,
> 
> Eric had suggested we add an FAQ entry for speculative preallocation
> since it seems to be a common question, so I offered to write something
> up. I started with a single entry but split it into a couple Q's when it
> turned into TL;DR fodder. ;)
> 
> The text is embedded below for review. Thoughts on the questions or
> content is appreciated. Also, once folks are Ok with this... how does
> one gain edit access to the wiki?

Request an account and wait for one of us admins to ack it.

FWIW, what I'd really like is for the FAQ to be converted to a
asciidoc document in the xfs-documentation tree. The current FAQ has
lots of stuff that could do with updating, but editing a wiki
document that long in a browser is, well, painful. We can then
publish the build html version of the FAQ on the wiki...

> Brian
> 
> ---
> 
> Q: Why do files on XFS use more data blocks than expected?
> 
> A:
> 
> The XFS speculative preallocation algorithm allocates extra blocks
> beyond end of file (EOF) to combat fragmentation under parallel
> sequential write workloads.

"minimise file fragmentation during buffered write workloads.
Workloads that benefit from this behaviour include slowly growing
files, concurrent writers and mixed reader/writers workloads. It
also provides fragmentation resistence in situations where memory
pressure prevents adequate buffering of dirty data to allow large
contiguous regions of dirty data to be formed in memory."

> This post-EOF block allocation is included

"is accounted identically to blocks withing EOF. It is visible..."

> in 'st_blocks' counts via stat() system calls and is accounted as
> globally allocated space by the filesystem. This is reported by various
> userspace utilities (stat, du, df, ls) and thus provides a common source
> of confusion for administrators. Post-EOF blocks are temporary in most
> situations and are usually reclaimed via several possible mechanisms in
> XFS.

Also accounted for in quotas.

> See the FAQ entry on speculative preallocation for details.
> 
> Q: What is speculative preallocation? How can I manage it?
> 
> A:
> 
> XFS speculatively preallocates post-EOF blocks on file extending writes
> in anticipation of future extending writes. The size of a preallocation
> is dynamic and depends on the size of the previous extent in the file
> (starting from 0 again if the write extends past a hole).

I'd keep specific heuristics out of the description. Heuristics
change....

> As files grow
> larger, so do the size of preallocations. Speculative preallocation is
> not enabled for files smaller than a minimum size (64k by default, but
> can vary depending on filesystem geometry and/or mount options).

Again, actual numbers should probably be avoided, because we can
change that at will...

> Preallocations are capped at a maximum of 8GB on 4k block filesystems.

"capped at a single extent of the maximum supported size of the filesystem"

> Preallocation is throttled automatically as the filesystem approaches
> low free space conditions or other allocation limits on a file (such as
> a quota).

"Preallocation size is throttled..."

> In most cases, speculative preallocation is automatically reclaimed when
> a file is closed. The preallocation may persist after file close if an
> open, write, close pattern is repeated on a file. In this scenario,
> post-EOF preallocation is trimmed once the inode is reclaimed from cache
> or the filesystem unmounted.

I'd rewrite this slightly differently, saying that preallocation "may
persist beyond the lifecycle of any given file descriptor." And then
describe the reason for this - that certain application behaviours
(like slowly growing files, or file servers) can cause fragmentation
if we remove the preallocation on fd close. These behaviours are
automatically detected, and result in "delayed removal" of the
preallocation.

Q: How can I speed up or avoid delayed removal of speculative preallocation?

A. Removing the inode from the VFS cache or unmounting the
filesystem will remove speculative preallocations associated with an
inode.

> Linux 3.8 (and later) includes a scanner to perform background trimming
> of files with lingering post-EOF preallocations. The scanner bypasses
> files that have been recently modified to not interfere with ongoing
> writes. A 5 minute scan interval is used by default and can be adjusted
> via the following file (value in seconds):
> 
> 	/proc/sys/fs/xfs/speculative_prealloc_lifetime
> 

Q: Is speculative preallocation permanent?

A:
> Although speculative preallocation can lead to reports of excess space
> usage, the preallocated space is not permanent unless explicitly made so
> via fallocate or a similar interface. Preallocated space can also be
> encoded permanently in situations where file size is extended beyond a
> range of post-EOF blocks (i.e., via truncate). Otherwise, preallocated
> blocks are reclaimed on file close, inode reclaim, unmount or in the
> background once file write activity subsides.
> 

Q: My workload has known characteristics - can I tune speculative
preallocation to be an optimal fixed size?

A.
> Finally, the XFS block allocation algorithm can be configured to use a
> fixed allocation size with the 'allocsize=' mount option. Note that
> speculative preallocation does not occur when a fixed allocation size is
> set and thus increases the potential for fragmentation via parallel
> writes.

This should say "dynamic resizing of speculative preallocation does
not occur" rather than "speculative preallocation does not occur",
because allocsize only determines the size of the speculative
preallocation beyond EOF that is done - it doesn't turn it off...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
