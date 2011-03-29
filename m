Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2TJ1Oln243776 for <xfs@oss.sgi.com>; Tue, 29 Mar 2011 14:01:25 -0500
Subject: Re: [PATCH 4/5] xfs: allow reusing busy extents where safe
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110328210915.214513168@bombadil.infradead.org>
References: <20110328210614.832613417@bombadil.infradead.org>
	<20110328210915.214513168@bombadil.infradead.org>
Date: Tue, 29 Mar 2011 14:04:28 -0500
Message-ID: <1301425468.3026.249.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Mon, 2011-03-28 at 17:06 -0400, Christoph Hellwig wrote:
> Allow reusing any busy extent for metadata allocations, and reusing busy
> userdata extents for userdata allocations.  Most of the complexity is
> propagating the userdata information from the XFS_BMAPI_METADATA flag
> to xfs_bunmapi into the low-level extent freeing routines.  After that
> we can just track what type of busy extent we have and treat it accordingly.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

The use of an enum value returned from
xfs_alloc_busy_update_extent() is a good improvement.

I'll issue the caveat here that I did not look through
it this time as carefully as the first time.  My main
concern was about the validity of reusing busy user data
extents for user data, and as before I'll say I accept
that it's OK, but I haven't worked through in my own
mind that it is indeed safe.  If I find the time to do
it I'll look this one over again to for reassurance...

But aside from that, it looks good to me.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
