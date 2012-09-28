Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8SNaj4l086574 for <xfs@oss.sgi.com>; Fri, 28 Sep 2012 18:36:45 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	wRzGmBaZA1iVK6dn for <xfs@oss.sgi.com>;
	Fri, 28 Sep 2012 16:38:04 -0700 (PDT)
Date: Sat, 29 Sep 2012 09:37:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: only update the last_sync_lsn when a transaction
	completes
Message-ID: <20120928233752.GE23520@dastard>
References: <1348807035-20087-1-git-send-email-david@fromorbit.com>
	<20120928124038.GA25262@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120928124038.GA25262@infradead.org>
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

On Fri, Sep 28, 2012 at 08:40:38AM -0400, Christoph Hellwig wrote:
> 
> Looks good.
> 
> Do you have any testcase for this?  It doesn't look like an issue found
> by code inspection.

Yeah, test 182 with my xfssyncd-die-die-die patchset triggers it
100% reliably.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
