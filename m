Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 537E17F57
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 06:39:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3928A8F8039
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 04:39:02 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Oc8iWBPUbCHbB0Nv for <xfs@oss.sgi.com>;
	Mon, 24 Feb 2014 04:39:00 -0800 (PST)
Date: Mon, 24 Feb 2014 23:06:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] XFS: fix the description of 'allocsize=' mount option
Message-ID: <20140224120629.GN4317@dastard>
References: <530AE0E5.1090707@jp.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <530AE0E5.1090707@jp.fujitsu.com>
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
To: sat <takeuchi_satoru@jp.fujitsu.com>
Cc: Rob Landley <rob@landley.net>, xfs@oss.sgi.com

On Mon, Feb 24, 2014 at 03:04:21PM +0900, sat wrote:
> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> 
> The end-of-file preallocation size is dynamic by default.
> So the description about the default size of preallocation
> should be removed.
> 
> Instead, adding the description about the initial size of
> dynamic preallocation is useful for users.
> 
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Rob Landley <rob@landley.net>
> ---
>  Documentation/filesystems/xfs.txt |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
> index 5be51fd..30e57b0 100644
> --- a/Documentation/filesystems/xfs.txt
> +++ b/Documentation/filesystems/xfs.txt
> @@ -23,16 +23,16 @@ default behaviour.
>  
>    allocsize=size
>  	Sets the buffered I/O end-of-file preallocation size when
> -	doing delayed allocation writeout (default size is 64KiB).
> -	Valid values for this option are page size (typically 4KiB)
> -	through to 1GiB, inclusive, in power-of-2 increments.
> +	doing delayed allocation writeout. Valid values for this
> +	option are page size (typically 4KiB) through to 1GiB,
> +	inclusive, in power-of-2 increments.
>  
>  	The default behaviour is for dynamic end-of-file
> -	preallocation size, which uses a set of heuristics to
> -	optimise the preallocation size based on the current
> -	allocation patterns within the file and the access patterns
> -	to the file. Specifying a fixed allocsize value turns off
> -	the dynamic behaviour.
> +	preallocation size (initial size is 64KiB), which uses a

Actually, it isn't. The initial size of dynamic prealloc is
determined by a set of heuristics based on file size, filesystem
geometry and the existing extents on the file. It uses a default
of 64k if no optimisation heuristics trigger.

Therefore, it may actually be zero - we don't do any speculative
preallocation for small files until they grow past a specific
threshold. i.e. there is a small file optimisation heuristic that
takes precendence over the default, and so the comment about the
initial prealloc size being 64k is wrong. The initial prealloc size
is zero....

An example at the other end of the spectrumL we preallocate a chunk
of a file, then write past the end of the preallocated region. The
initial speculative preallocation is triggered once we pass the
preallocated region, and the heuristics can result in an initial
size anywhere in the range of zero (small file) to 2^21 blocks
(large, multi-GB file).

Hence I think that the generalised text saying "default is 64k and
is optimised based on heuristics" reflects the behaviour of the
algorithm much better than saying "<algorithmic heuristic>
and is optimised by algorithmic heuristics"....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
