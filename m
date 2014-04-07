Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C452A7F77
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 14:08:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A5450304039
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 12:08:33 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id BUISesnz4qzL6xcO for <xfs@oss.sgi.com>;
	Mon, 07 Apr 2014 12:08:32 -0700 (PDT)
Message-ID: <5342F7AF.9040507@sandeen.net>
Date: Mon, 07 Apr 2014 14:08:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [FAQ v2] XFS speculative preallocation
References: <20140407153906.GC48184@bfoster.bfoster>
In-Reply-To: <20140407153906.GC48184@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On 4/7/14, 10:39 AM, Brian Foster wrote:
> Hi all,
> 
> This is v2 of the speculative preallocation FAQ bits. The initial
> proposal was here:
> 
> http://oss.sgi.com/archives/xfs/2014-03/msg00316.html
> 
> This version includes some updates based on review from arekm and
> dchinner. Most notably, the content has been broken down into a few more
> questions. Unless there are further major changes required, I'll plan to
> post something along these lines to the wiki when my account is
> approved. Thanks for the feedback!
> 
> Brian
> 
> ---
> 
> Q: Why do files on XFS use more data blocks than expected?
> 
> A:
> 
> The XFS speculative preallocation algorithm allocates extra blocks
> beyond end of file (EOF) to minimise file fragmentation during buffered

s/minimise/minimize/

> write workloads. Workloads that benefit from this behaviour include
> slowly growing files, concurrent writers and mixed reader/writer
> workloads. It also provides fragmentation resistence in situations where

s/resistence/resistance/

> memory pressure prevents adequate buffering of dirty data to allow
> formation of large contiguous regions of data in memory.
> 
> This post-EOF block allocation is accounted identically to blocks within
> EOF. It is visible in 'st_blocks' counts via stat() system calls,
> accounted as globally allocated space and against quotas that apply to
> the associated file. The space is reported by various userspace
> utilities (stat, du, df, ls) and thus provides a common source of
> confusion for administrators. Post-EOF blocks are temporary in most
> situations and are usually reclaimed via several possible mechanisms in
> XFS.

"usually reclaimed" - is it ever "never" reclaimed, then?

> See the FAQ entry on speculative preallocation for details.
> 
> Q: What is speculative preallocation?
> 
> A:
> 
> XFS speculatively preallocates post-EOF blocks on file extending writes
> in anticipation of future extending writes. The size of a preallocation
> is dynamic and depends on the runtime state of the file and fs.
> Generally speaking, preallocation is disabled for very small files and
> preallocation sizes grow as files grow larger.
> 
> Preallocations are capped to the maximum extent size supported by the
> filesystem. Preallocation size is throttled automatically as the
> filesystem approaches low free space conditions or other allocation
> limits on a file (such as a quota).
>  
> In most cases, speculative preallocation is automatically reclaimed when
> a file is closed. Preallocation may also persist beyond the lifecycle of
> the file descriptor. Certain application behaviors that are known to
> cause fragmentation, such as file server workloads, slowly growing
> files, etc., benefit from this and delay the removal of preallocated
> blocks beyond fd close.

this is a little handwavy.  "It's reclaimed when it's closed, except
when it's not?"  Can we say something more informative here?

> Q: How can I speed up or avoid delayed removal of speculative
> preallocation?
> 
> A:
> 
> Remove the inode from the VFS cache or unmount the filesystem to remove
> speculative preallocations associated with an inode.

How does a user remove an inode from the VFS cache?  ;)

So far the answer to this question sounds like "no."

We can't remove a single inode; drop_caches is way too heavy weight,
and unmount isn't really viable in most cases.

> Linux 3.8 (and later) includes a scanner to perform background trimming
> of files with lingering post-EOF preallocations. The scanner bypasses
> dirty files to avoid interference with ongoing writes. A 5 minute scan
> interval is used by default and can be adjusted via the following file
> (value in seconds):
> 
> 	/proc/sys/fs/xfs/speculative_prealloc_lifetime
>
> Q: Is speculative preallocation permanent?
> 
> A:
> 
> Although speculative preallocation can lead to reports of excess space
> usage, the preallocated space is not permanent unless explicitly made so
> via fallocate or a similar interface. Preallocated space can also be
> encoded permanently in situations where file size is extended beyond a
> range of post-EOF blocks (i.e., via truncate). Otherwise, preallocated

(maybe "an extending truncate")

> blocks are reclaimed on file close, inode reclaim, unmount or in the
> background once file write activity subsides.
> 
> Q: My workload has known characteristics - can I tune speculative
> preallocation to an optimal fixed size?
> 
> A:
> 
> The 'allocsize=' mount option configures the XFS block allocation
> algorithm to use a fixed allocation size. Speculative preallocation is
> not dynamically resized when the allocsize mount option is set and thus
> the potential for fragmentation is increased. XFS historically set
> allocsize to 64k by default.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
