Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8363CKX153389 for <xfs@oss.sgi.com>; Mon, 3 Sep 2012 01:03:13 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	yCXGEil5G5p7YoJC for <xfs@oss.sgi.com>;
	Sun, 02 Sep 2012 23:04:08 -0700 (PDT)
Date: Mon, 3 Sep 2012 16:04:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC, PATCH 0/102]: xfs: 3.0.x stable kernel update
Message-ID: <20120903060406.GA15292@dastard>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
	<20120901231019.GC6896@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120901231019.GC6896@infradead.org>
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

On Sat, Sep 01, 2012 at 07:10:19PM -0400, Christoph Hellwig wrote:
> I've done a brief look over the patches this week and while I can't spot
> anything wrong I'm defintively a bit concerned about the amount of churn
> for a long term stable series.  A lot of this does not seem to fit the
> strict -stable criteria, and given that I've not really seen any major
> issues with the current 3.0-stable codebase I'm wondering what the
> guranteed gain vs the status quo is.

You didn't troll the RH bugzilla ;)

The XFS code base in RHEL6 is sitting at 3.0, and several of the
problems that have workarounds in 3.0.x don't fix the problems
reported (e.g. the log space hangs), while the fixes in the more
recent mainline kernel do.

I simply figured that I've got to do this much work to fix all the
bugs reported in RHEL6 and given the code bases are almost identical
I'd do a community service and push it to 3.0.x first. I'm quite
happy not to push it to 3.0.x if the consensus is that it is too
much churn.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
