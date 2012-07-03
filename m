Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q630QFaw030144 for <xfs@oss.sgi.com>; Mon, 2 Jul 2012 19:26:15 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	F6cYFz6hVgA0cyT9 for <xfs@oss.sgi.com>;
	Mon, 02 Jul 2012 17:26:14 -0700 (PDT)
Date: Tue, 3 Jul 2012 10:26:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_btree_cur leak with 3.5-rc4
Message-ID: <20120703002611.GW19223@dastard>
References: <20120702191412.GA3617@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120702191412.GA3617@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, xfs@oss.sgi.com

On Mon, Jul 02, 2012 at 03:14:12PM -0400, Mike Snitzer wrote:
> I get kmemleak reports against XFS when I run the thinp-test-suite
> against 3.5-rc4.  I didn't see any XFS leaks with 3.4.

Already fixed in 3.5-rc5:

76d0953 xfs: fix allocbt cursor leak in xfs_alloc_ag_vextent_near

Thanks for reporting it, though, Mike.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
