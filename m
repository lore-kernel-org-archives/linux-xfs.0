Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q184Dvi4032723 for <xfs@oss.sgi.com>; Tue, 7 Feb 2012 22:13:58 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	vLJW1kojOhaX471F for <xfs@oss.sgi.com>;
	Tue, 07 Feb 2012 20:13:55 -0800 (PST)
Date: Wed, 8 Feb 2012 15:13:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] repair: fix incorrect use of thread local data in dir
	and attr code
Message-ID: <20120208041353.GC20305@dastard>
References: <20120207175400.GA24301@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120207175400.GA24301@infradead.org>
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

On Tue, Feb 07, 2012 at 12:54:00PM -0500, Christoph Hellwig wrote:
> The attribute and dirv1 code use pthread thread local data incorrectly in
> a few places, which will make them fail in horrible ways when using the
> ag_stride options.
> 
> Replace the use of thread local data with simple local allocations given
> that there is no needed to micro-optimize these allocations as much
> as e.g. the extent map.  The added benefit is that we have to allocate
> less memory, and can free it quickly.
> 
> Reported-by: Tom Crane <T.Crane@rhul.ac.uk>
> Tested-by: Tom Crane <T.Crane@rhul.ac.uk>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks pretty sane to me. Especially as the comments suggest it never
even worked correctly in the first place.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
