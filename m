Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q22A4UA3038082 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 04:04:30 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	lOXDhyd9bM7RpJnr for <xfs@oss.sgi.com>;
	Fri, 02 Mar 2012 02:04:28 -0800 (PST)
Date: Fri, 2 Mar 2012 21:04:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 8/8] xfs: add a shrinker for quotacheck
Message-ID: <20120302100426.GI5091@dastard>
References: <1330661507-1121-1-git-send-email-david@fromorbit.com>
	<1330661507-1121-9-git-send-email-david@fromorbit.com>
	<20120302075104.GG4117@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120302075104.GG4117@infradead.org>
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

On Fri, Mar 02, 2012 at 02:51:04AM -0500, Christoph Hellwig wrote:
> Hmm, I don't like this complication all that much.

Though it is a simple, self contained fix for the problem...

> Why would we even bother caching inodes during quotacheck?  The bulkstat
> is a 100% sequential read only workload going through all inodes in the
> filesystem.  I think we should simply not cache any inodes while in
> quotacheck.

I have tried that approach previously with inodes read through
bulkstat, but I couldn't find a clean workable solution. It kept
getting rather complex because all our caching and recycling is tied
into VFS level triggers. That was a while back, so maybe there is a
simpler solution that I missed in attempting to do this.

I suspect for a quotacheck only solution we can hack a check into
.drop_inode, but a generic coherent non-cached bulkstat lookup is
somewhat more troublesome.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
