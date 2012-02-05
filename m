Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q15NCTNd083916 for <xfs@oss.sgi.com>; Sun, 5 Feb 2012 17:12:29 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	4HcSmEXGBBBbGeQb for <xfs@oss.sgi.com>;
	Sun, 05 Feb 2012 15:12:28 -0800 (PST)
Date: Mon, 6 Feb 2012 10:12:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: fsstress - make sync a write op
Message-ID: <20120205231226.GI6922@dastard>
References: <4F2D67B3.4050800@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F2D67B3.4050800@sandeen.net>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Sat, Feb 04, 2012 at 11:15:31AM -0600, Eric Sandeen wrote:
> I was running 068 to test freeze changes, and realized that
> "sync" is not in the op list when "-w" (write ops) is specified,
> although fsync & fdatasync are.  It seems to me that sync should
> be a default write op as well.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Definitely seems to be an oversight.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
