Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA7MQbvH187846 for <xfs@oss.sgi.com>; Wed, 7 Nov 2012 16:26:37 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	9jK9WjYcFRDStxtq for <xfs@oss.sgi.com>;
	Wed, 07 Nov 2012 14:28:34 -0800 (PST)
Date: Thu, 8 Nov 2012 09:28:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: add CRC infrastructure
Message-ID: <20121107222831.GI6434@dastard>
References: <1352295452-4726-1-git-send-email-david@fromorbit.com>
	<1352295452-4726-2-git-send-email-david@fromorbit.com>
	<m2ehk5qt88.fsf@firstfloor.org> <20121107203105.GE6434@dastard>
	<20121107213946.GB16230@one.firstfloor.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121107213946.GB16230@one.firstfloor.org>
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
To: Andi Kleen <andi@firstfloor.org>
Cc: xfs@oss.sgi.com

On Wed, Nov 07, 2012 at 10:39:46PM +0100, Andi Kleen wrote:
> > Why would that be necessary? We never include the checksum field in
> > the calculation when setting it or verifiying it, and the
> > verification uses exactly the same method as the original
> > calculation to check the CRC, so it doesn't matter if the CRC value
> > is zero or not - if it matches (zero or otherwise), the validation
> > passes....
> 
> I thought zero meant the checksum is not there? You stated that
> somewhere else.

That's only to avoid spurious warnings when moving from an existing
kernel to a new kernel that issues advisory warnings on mismatches.
For enforcement, though, when the on-disk format changes so that all
metadata is CRC protected, determination of whether zero is a valid
CRC value is determined by a superblock feature bit, not a magic CRC
mapping value...

Hence mapping the zero value just for advisory warnings really
doesn't buy us that much other than complexity for this single case.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
