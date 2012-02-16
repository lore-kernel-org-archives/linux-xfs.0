Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1G6GqAj233483 for <xfs@oss.sgi.com>; Thu, 16 Feb 2012 00:16:52 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	55mXImpQ1KOYyuPX for <xfs@oss.sgi.com>;
	Wed, 15 Feb 2012 22:16:50 -0800 (PST)
Date: Thu, 16 Feb 2012 17:16:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 00/12] log grant code cleanups
Message-ID: <20120216061637.GY14132@dastard>
References: <20111212141346.986825692@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111212141346.986825692@bombadil.infradead.org>
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

On Mon, Dec 12, 2011 at 09:13:47AM -0500, Christoph Hellwig wrote:
> This series removes the opportunistic log space wakeups which had no
> use but hiding real races for far too long, and applies various bits
> of refactoring to the log grant code to make it smaller and more readable.

Christoph, I was just going over this series again so I could add a
reviewed-by tag to it to get it moving for 3.3. Everything looks
just fine except for one thing - the issue raised and potential
solution described here:

http://oss.sgi.com/archives/xfs/2011-12/msg00056.html

You said you were going to look at adding this fix to the series,
but I don't see it in this patch set.

I agree that the patch set as it stands does not introduce a new
race condition (i.e. this is a pre-existing condition), but I was
wondering if you'd updated more recently to add a fix for this
problem before I gave a reviewed-by on it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
