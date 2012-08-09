Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q79NcMj7239771 for <xfs@oss.sgi.com>; Thu, 9 Aug 2012 18:38:22 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ARFapU4raEq5DamB for <xfs@oss.sgi.com>;
	Thu, 09 Aug 2012 16:38:20 -0700 (PDT)
Date: Fri, 10 Aug 2012 09:38:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v6 4/4] xfs: xfs_seek_hole() refinement with lookup hole
	offset from page cache
Message-ID: <20120809233819.GD2877@dastard>
References: <501B6B82.10405@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <501B6B82.10405@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 03, 2012 at 02:11:14PM +0800, Jeff Liu wrote:
> xfs_seek_hole() refinement with hole searching from page cache for unwritten extent.

Same comment about duplicate code and loops...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
