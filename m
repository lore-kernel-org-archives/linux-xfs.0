Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2RKqD1q168563 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 15:52:13 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	JU960PhLpmcZRyeR for <xfs@oss.sgi.com>;
	Tue, 27 Mar 2012 13:52:11 -0700 (PDT)
Date: Wed, 28 Mar 2012 07:52:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/5] reduce exclusive ilock hold times V2
Message-ID: <20120327205201.GC5091@dastard>
References: <20120327143445.196524266@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120327143445.196524266@bombadil.infradead.org>
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

On Tue, Mar 27, 2012 at 10:34:45AM -0400, Christoph Hellwig wrote:
> This series tries to reduce the amount we hold the ilock exclusively,
> especially during direct I/O writes where they currently hurt us.
> 
> Dave showed that his earlier version which is less aggressive than this
> one can already provide magnitudes of better throughput and iops for
> parallel direct I/O workloads, and this one should be even better.
> 
> Changes from V1:
>  - do not mark xfs_qm_need_dqattach as inline
>  - various comment and commit message updates

Consider the whole series:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> I specificly did not add the delalloc assert in the direct I/O write path
> in this series, as it triggers with or without this patch.  I will look into
> that issue next.

I'm getting that assert (and other delalloc block asserts) when
fsstress is running quite often these days. I suspect that he lack
of IOLOCK synchronisation in .page_mkwrite is biting us here, but
I'm interested to know what you find...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
