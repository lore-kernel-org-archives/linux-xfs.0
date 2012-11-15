Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAF37Rwp203827 for <xfs@oss.sgi.com>; Wed, 14 Nov 2012 21:07:27 -0600
Date: Wed, 14 Nov 2012 21:09:28 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 19/32] xfs: factor dir2 block read operations
Message-ID: <20121115030928.GA27055@sgi.com>
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-20-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1352721264-3700-20-git-send-email-david@fromorbit.com>
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

On Mon, Nov 12, 2012 at 10:54:11PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> In preparation for verifying dir2 block format buffers, factor
> the read operations out of the block operations (lookup, addname,
> getdents) and some of the additional logic to make it easier to
> understand an dmodify the code.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

This was a difficult review.  I think you have at least three ideas in here
which could be split up.  Please keep the reviewer in mind.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
