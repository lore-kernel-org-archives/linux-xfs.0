Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 520D67F87
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 14:58:44 -0500 (CDT)
Message-ID: <53430375.3060203@sgi.com>
Date: Mon, 07 Apr 2014 14:58:45 -0500
From: Mark Tinguely <tinguely@sgi.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 04/07/14 10:39, Brian Foster wrote:
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
   ^^^ beyond here and then later adopt post-EOF phrasing.

...

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
			    vague what is very small?   ^^^
...


> Q: Is speculative preallocation permanent?
>
> A:
>
> Although speculative preallocation can lead to reports of excess space
> usage, the preallocated space is not permanent unless explicitly made so
> via fallocate or a similar interface. Preallocated space can also be
> encoded permanently in situations where file size is extended beyond a
> range of post-EOF blocks (i.e., via truncate). Otherwise, preallocated
> blocks are reclaimed on file close, inode reclaim, unmount or in the
> background once file write activity subsides.

Switch order?

Normally, preallocated
blocks are reclaimed on file close, inode reclaim, unmount or in the
background once file write activity subsides. They can be explictly made 
permanent .

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

sets the

> allocsize to 64k by default.
>


Q: Can I disable S-P-A ?

-Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
