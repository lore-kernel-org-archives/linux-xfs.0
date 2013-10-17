Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2ECFF7F3F
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 15:01:13 -0500 (CDT)
Date: Thu, 17 Oct 2013 15:01:09 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/5] xfs: remove the unused XFS_ATTR_NONBLOCK flag
Message-ID: <20131017200109.GI1935@sgi.com>
References: <20131012075503.370510641@bombadil.infradead.org>
	<20131012075640.115410017@bombadil.infradead.org>
	<20131014045152.GG4446@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131014045152.GG4446@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Gents,

On Mon, Oct 14, 2013 at 03:51:52PM +1100, Dave Chinner wrote:
> On Sat, Oct 12, 2013 at 12:55:05AM -0700, Christoph Hellwig wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Still unused after all this time, so removing it is fine by me.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

An xfs ioctl user who requests nonblocking behavior will no longer get it.
This seems to constitute API breakage.  How can we verify that this is unused
since anyone can open with O_NONBLOCK?

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
