Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UHu6We061164 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 12:56:23 -0500
Date: Mon, 29 Oct 2012 17:17:50 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 01/25] xfs: growfs: don't read garbage for new secondary
	superblocks
Message-ID: <20121030001750.GC30227@caliban.engr.sgi.com>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1351146854-19343-2-git-send-email-david@fromorbit.com>
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

On Thu, Oct 25, 2012 at 05:33:50PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When updating new secondary superblocks in a growfs operation, the
> sueprblock buffer is read from the newly grown region of the
> underlying device. This is not guaranteed to be zero, so violates
> the underlying assumption that the unused parts of superblocks are
> zero filled. Get a new buffer for these secondary superblocks to
> ensure that the unused regions are zero filled correctly.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
> [ snip ]

Looks good to me too. 

Reviewed-by: Phil White <pwhite@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
