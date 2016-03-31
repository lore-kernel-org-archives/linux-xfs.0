Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 27B7B7CA3
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 20:20:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E855F304082
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 18:20:42 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	25p85I1pglEUl7LQ for <xfs@oss.sgi.com>;
	Wed, 30 Mar 2016 18:20:36 -0700 (PDT)
Date: Thu, 31 Mar 2016 12:18:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: fallocate mode flag for "unshare blocks"?
Message-ID: <20160331011813.GJ30721@dastard>
References: <20160302155007.GB7125@infradead.org>
	<20160330182755.GC2236@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160330182755.GC2236@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-api@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Mar 30, 2016 at 11:27:55AM -0700, Darrick J. Wong wrote:
> Or is it ok that fallocate could block, potentially for a long time as
> we stream cows through the page cache (or however unshare works
> internally)?  Those same programs might not be expecting fallocate to
> take a long time.

Yes, it's perfectly fine for fallocate to block for long periods of
time. See what gfs2 does during preallocation of blocks - it ends up
calling sb_issue_zerout() because it doesn't have unwritten
extents, and hence can block for long periods of time....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
