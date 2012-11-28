Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qASLSsjC214966 for <xfs@oss.sgi.com>; Wed, 28 Nov 2012 15:28:54 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	PHyyqQz0wXdfODxv for <xfs@oss.sgi.com>;
	Wed, 28 Nov 2012 13:31:11 -0800 (PST)
Date: Thu, 29 Nov 2012 08:31:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] xfs: fix sparse reported log CRC endian issue
Message-ID: <20121128213110.GV6434@dastard>
References: <1354068063-1692-1-git-send-email-david@fromorbit.com>
	<1354068063-1692-5-git-send-email-david@fromorbit.com>
	<20121128133059.GC2765@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121128133059.GC2765@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Nov 28, 2012 at 08:30:59AM -0500, Christoph Hellwig wrote:
> On Wed, Nov 28, 2012 at 01:01:03PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Not a bug as such, just warning noise from the xlog_cksum()
> > returning a __be32 type when it shoul dbe returning a __le32 type.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> The patch look okay.
> 
> But why are we storing the crc field little endian while all other on
> disk formats are big endian? (And yes I realize it might as well have
> been me who did that back in the idea, but I still have no idea why)

Because the CRC always returns the calcuation LE format, even on BE
systems. So rather than always having to byte swap it everywhere and
have all the force casts and anootations for sparse, it seems
simpler to just make it a __le32 everywhere....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
