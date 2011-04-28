Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3S25Oo8241711 for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 21:05:24 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F0E7141AC0F
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 19:08:55 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	y59TbHocVgDP32yw for <xfs@oss.sgi.com>;
	Wed, 27 Apr 2011 19:08:55 -0700 (PDT)
Date: Thu, 28 Apr 2011 12:08:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: coalesce contiguous extents in extent map output
Message-ID: <20110428020846.GM12436@dastard>
References: <dd1c0747731332fed9637bc01d6c6de369a7fe6f.1303412098.git.aelder@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <dd1c0747731332fed9637bc01d6c6de369a7fe6f.1303412098.git.aelder@sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 21, 2011 at 01:55:03PM -0500, Alex Elder wrote:
> The specific set of extent sizes allocated to a file is not always
> deterministic.  In particular, sometimes a range of unwritten blocks
> is covered by a single extent, while in other cases it might be
> represented by multiple consecutive unwritten extents.  This can
> result in spurious errors being reported in tests that check file
> extent maps.
> 
> Add a filter that finds adjacent extents in what gets produced for
> fiemap and bmap output and coalesces them as if all consective
> extents of the same time were really just one extent.  (Note that
> as implemented here this applies to all extent types, not just
> unwritten extents.)
> 
> Update the golden output for test 242 to reflect the change.

Looks sane. Does Josef's new test need the same golden output
treatment?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
