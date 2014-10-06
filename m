Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 462117F4E
	for <xfs@oss.sgi.com>; Mon,  6 Oct 2014 15:33:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2660830404E
	for <xfs@oss.sgi.com>; Mon,  6 Oct 2014 13:33:03 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	DaXDfbC52LJnMHVp for <xfs@oss.sgi.com>;
	Mon, 06 Oct 2014 13:33:01 -0700 (PDT)
Date: Tue, 7 Oct 2014 07:33:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 14/16] xfs: rename XFS_IOC_FSGEOM to XFS_IOC_FSGEOM_V2
Message-ID: <20141006203300.GC2301@dastard>
References: <20141003214758.GY1865@sgi.com>
 <20141003220435.GN1865@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141003220435.GN1865@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, olaf@sgi.com, xfs@oss.sgi.com

On Fri, Oct 03, 2014 at 05:04:35PM -0500, Ben Myers wrote:
> From: Ben Myers <bpm@sgi.com>
> 
> We'll be creating a new versioned XFS_IOC_FSGEOMETRY ioctl and structure
> so rename the current revision to _V2.

Urk, no.

This will result in older applications picking up the new ioctl when
they are rebuilt without having explicit support for the new ioctl.

Just create a new ioctl with a new name and modify applications to
use it. If the kernel does not support the new ioctl, then fall back
to the old one in userspace.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
