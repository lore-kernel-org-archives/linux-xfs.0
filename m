Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA38MomO249750 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 03:22:50 -0500
Date: Thu, 3 Nov 2011 04:22:48 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/8] xfsdump: remove multi-stream synchronous dir dump
Message-ID: <20111103082248.GB11854@infradead.org>
References: <1320268254-20583-1-git-send-email-wkendall@sgi.com>
	<1320268254-20583-3-git-send-email-wkendall@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1320268254-20583-3-git-send-email-wkendall@sgi.com>
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Nov 02, 2011 at 04:10:48PM -0500, Bill Kendall wrote:
> When doing multi-stream dumps, the directories are dumped by each
> stream in lock-step fashion. A stream backs up a given directory,
> then waits for all others to finish that directory, then they all
> move on to the next one. During restore a single stream is chosen to
> apply the directory dump.
> 
> This patch changes xfsdump so that only one stream dumps the
> directories. The other streams begin dumping files immediately.
> This results in a faster backup, which is presumably why multiple
> streams are being used in the first place.
> 
> It also removes the barrier routines in qlock.c as they were only
> used by the "SYNCDIR" code.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
