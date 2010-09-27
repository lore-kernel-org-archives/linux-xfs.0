Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8RHo6cU197783 for <xfs@oss.sgi.com>; Mon, 27 Sep 2010 12:50:06 -0500
Subject: Re: [PATCH 14/18] xfs: implement batched inode lookups for AG walking
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1285552073-14663-15-git-send-email-david@fromorbit.com>
References: <1285552073-14663-1-git-send-email-david@fromorbit.com>
	<1285552073-14663-15-git-send-email-david@fromorbit.com>
Date: Mon, 27 Sep 2010 12:50:38 -0500
Message-ID: <1285609838.2380.69.camel@doink>
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
> With the reclaim code separated from the generic walking code, it is
> simple to implement batched lookups for the generic walk code.
> Separate out the inode validation from the execute operations and
> modify the tree lookups to get a batch of inodes at a time.
> 
> Reclaim operations will be optimised separately.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good.  (I sent some comments about this
function in a separate message, but this looks
OK to me anyway.)

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
