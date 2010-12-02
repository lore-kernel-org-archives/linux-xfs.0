Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB222utm245616 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 20:02:57 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B138E1C851FC
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 18:04:39 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	25HjJPQGDmzktmBs for <xfs@oss.sgi.com>;
	Wed, 01 Dec 2010 18:04:39 -0800 (PST)
Date: Thu, 2 Dec 2010 13:04:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/14] xfs: make AIL tail pushing independent of the
	grant lock
Message-ID: <20101202020409.GR16922@dastard>
References: <1290994712-21376-1-git-send-email-david@fromorbit.com>
	<1290994712-21376-6-git-send-email-david@fromorbit.com>
	<20101201124540.GC612@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101201124540.GC612@infradead.org>
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

On Wed, Dec 01, 2010 at 07:45:40AM -0500, Christoph Hellwig wrote:
> Once l_tail_lsn and l_last_sync_lsn are converted to atomic64_ts later
> in the series passing them in separately becomes pointless again.  Maybe
> scale the patch back a bit and require the caller to hold l_grant_lock
> for now, until the atomic64_t conversion happens. 

Same reasoning as for the change to xlog_space_left - the values
should only be sampled once for correctness, which is why I pass
them into the function. more "const" annotations, I guess.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
