Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6NFSSZL208182 for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 10:28:28 -0500
Subject: Re: [PATCH 2/3] xfs: serialise unaligned direct IO into unwritten
	extents
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1279881678-1660-3-git-send-email-david@fromorbit.com>
References: <1279881678-1660-1-git-send-email-david@fromorbit.com>
	<1279881678-1660-3-git-send-email-david@fromorbit.com>
Date: Fri, 23 Jul 2010 10:30:04 -0500
Message-ID: <1279899004.1983.87.camel@doink>
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
> If we do unaligned direct IO to a unwritten extent, the direct Io
> code does sub-block zeroing for us. However, we need to serialise
> the sub-block zeroing as we canot have another outstanding IO to the
> same block that is being zeroed at the same time. Ifw e do so, then
> we'll have two direct IOs to the same block that zero different
> portions of the block and we'll end up with zeros where we should
> have data.
> 
> Serialise such IOs in the get_blocks callback when we know that we
> are mapping an unaligned direct IO. This initial implementation is
> the sledge-hammer approach - we can probably be finer grained than
> this to avoid excessive serialisation when all IO is unaligned to a
> file.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
