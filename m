Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q94MmR5a234131 for <xfs@oss.sgi.com>; Thu, 4 Oct 2012 17:48:27 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	iY2TgCbPTumdqFPe for <xfs@oss.sgi.com>;
	Thu, 04 Oct 2012 15:49:52 -0700 (PDT)
Date: Fri, 5 Oct 2012 08:49:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: get filename->inode mappings in bulk for a live fs?
Message-ID: <20121004224949.GA23644@dastard>
References: <506DAB8C.9000601@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <506DAB8C.9000601@tlinx.org>
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
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Oct 04, 2012 at 08:30:20AM -0700, Linda Walsh wrote:
> I notice that attempts to use utils to get name->inode mappings
> (xfs_ncheck) seem to have no option to operate on a mounted filesystem.

If you need xfs_ncheck to get name->inode number mappings, then you
are doing something wrong.

$ find . -printf  "%h/%f: %i\n" | head -10
./.: 1010542779
./.git: 612759677
./.git/branches: 1013256262
./.git/hooks: 33523782
./.git/hooks/guilt: 406321163
./.git/hooks/guilt/delete: 402681911

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
