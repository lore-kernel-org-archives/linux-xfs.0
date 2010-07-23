Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6NFSRno208179 for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 10:28:28 -0500
Subject: Re: [PATCH 1/3] fs: get_blocks needs an unaligned mapping flag
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1279881678-1660-2-git-send-email-david@fromorbit.com>
References: <1279881678-1660-1-git-send-email-david@fromorbit.com>
	<1279881678-1660-2-git-send-email-david@fromorbit.com>
Date: Fri, 23 Jul 2010 10:29:57 -0500
Message-ID: <1279898997.1983.86.camel@doink>
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

On Fri, 2010-07-23 at 20:41 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When issuing concurrent unaligned direct IO to the same filesystem block, the
> direct IO sub-block zeroing code will extend the length of the write being done
> when writing into a hole or unwritten extents. If we are writing into unwritten
> extents, then the two IOs will both see the extent as unwritten at IO issue
> time and attempt to zero the part of the block that they are not writing to.
> 
> The result of this is that whichever IO completes last will win and part of the
> block will be zero instead of containing the correct data. Eric Sandeen has
> demonstrated the problem with xfstest #240. In the case of XFS, we allow
> concurrent direct IO writes to occur, but we cannot allow block zeroing to
> occur concurrently with other IO.
> 
> To allow serialisation of block zeroing across multiple independent IOs, we
> need to know if the region being mapped by the IO is fsb-aligned or not. If it
> is not aligned, then we need to prevent further direct IO writes from being
> executed until the IO that is doing the zeroing completes (i.e. converts the
> extent back to written). Passing the fact that the mapping is for an unaligned
> IO into the get_blocks calback is sufficient to allow us to implement the
> necessary serialisation.
> 
> Change the "create" parameter of the get_blocks callback to a flags field,
> and define the flags to be backwards compatible as such:
> 
> #define GET_BLOCKS_READ		0x00	/* map, no allocation */
> #define GET_BLOCKS_CREATE	0x01	/* map, allocate if hole */
> #define GET_BLOCKS_UNALIGNED	0x02	/* mapping for unaligned IO */

This looks good to me.

Two nits.  You could change the name of the "create" variable
in get_more_blocks() to be consistent with your change.

And I guess I like that the GET_BLOCKS_UNALIGNED is a flag
OR'd rather than a distinct value (i.e., CREATE_UNALIGNED).
You could make the comment at the definition of these
flag values to indicate they're "flag bits" rather than
just "flags" because it could conceivably be misconstrued
as-is.

In any case:

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
