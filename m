Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2T0thAS257394 for <xfs@oss.sgi.com>; Wed, 28 Mar 2012 19:55:43 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	k23Eb70bMxz18G7n for <xfs@oss.sgi.com>;
	Wed, 28 Mar 2012 17:55:42 -0700 (PDT)
Date: Thu, 29 Mar 2012 11:55:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/1] xfs: use XFS_BMAP_BMDR_SPACE vs. XFS_BROOT_SIZE_ADJ
Message-ID: <20120329005540.GK5091@dastard>
References: <4F7225BA.40200@redhat.com>
 <4F734887.7000508@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F734887.7000508@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Mar 28, 2012 at 12:21:11PM -0500, Eric Sandeen wrote:
> XFS_BROOT_SIZE_ADJ is an undocumented macro which accounts for
> the difference in size between the on-disk and in-core btree
> root.  It's much clearer to just use the newly-added 
> XFS_BMAP_BMDR_SPACE macro which gives us the on-disk size
> directly.
> 
> In one case, we must test that the if_broot exists before
> applying the macro, however.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
