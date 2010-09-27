Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8RFxcMS193925 for <xfs@oss.sgi.com>; Mon, 27 Sep 2010 10:59:39 -0500
Subject: Re: [PATCH 13/18] xfs: split out inode walk inode grabbing
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1285552073-14663-14-git-send-email-david@fromorbit.com>
References: <1285552073-14663-1-git-send-email-david@fromorbit.com>
	<1285552073-14663-14-git-send-email-david@fromorbit.com>
Date: Mon, 27 Sep 2010 10:58:56 -0500
Message-ID: <1285603136.2380.12.camel@doink>
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

On Mon, 2010-09-27 at 11:47 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When doing read side inode cache walks, the code to validate and
> grab an inode is common to all callers. Split it out of the execute
> callbacks in preparation for batching lookups. Similarly, split out
> the inode reference dropping from the execute callbacks into the
> main lookup look to be symmetric with the grab.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
