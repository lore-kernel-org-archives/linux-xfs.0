Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2D00uGM169068 for <xfs@oss.sgi.com>; Mon, 12 Mar 2012 19:00:56 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	eSM6rQ9KcYsEHPZU for <xfs@oss.sgi.com>;
	Mon, 12 Mar 2012 17:00:54 -0700 (PDT)
Date: Tue, 13 Mar 2012 11:00:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.2.9 and locking problem
Message-ID: <20120313000052.GB5091@dastard>
References: <201203092028.47177.arekm@maven.pl> <20120312005325.GX5091@dastard>
	<201203121443.59217.arekm@maven.pl>
	<20120312161425.GA23815@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120312161425.GA23815@infradead.org>
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

On Mon, Mar 12, 2012 at 12:14:25PM -0400, Christoph Hellwig wrote:
> In the 3.2 version xfs_sync_flags does a double unlock of the ilock -
> change the last argument of xfs_trans_ijoin from XFS_ILOCK_EXCL to 0
> will fix this.  The 3.0 version doesn't have this bug.
> 
> And btw, the additions to the on-disk format are gross - this stuff
> broke before and will break again when we add new features.

Any idea why they aren't sending stuff like this upstream to us so
they can be implemented correctly, robustly and in a future-proof
manner? vserver users are going to be unhappy when their filesystems
get broken because they are using out-of-tree, incompatible on-disk
formats....

FWIW, are the vserver foilks distributing modified versions of
xfsprogs to support these changes?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
