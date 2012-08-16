Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7GKrUB5187123 for <xfs@oss.sgi.com>; Thu, 16 Aug 2012 15:53:30 -0500
Date: Thu, 16 Aug 2012 15:53:26 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: unlock the AGI buffer when looping in xfs_dialloc
Message-ID: <20120816205326.GA29979@sgi.com>
References: <20120807060202.GA4005@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120807060202.GA4005@infradead.org>
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

Hey Christoph,

On Tue, Aug 07, 2012 at 02:02:02AM -0400, Christoph Hellwig wrote:
> Also update some commens in the area to make the code easier to read.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This seems to fix a regression that was introduced in

commit 55d6af64, 'xfs: refactor xfs_ialloc_ag_select'

Christoph, could you comment on why this has not caused problems in testing?  I
am sort of suprised we haven't had any ill effects.

I'll add this patch into our next pull request.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
