Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 37BD57F4E
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 17:11:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 04C058F80B7
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 15:11:01 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Zs5aieD6BUiPSQfn for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2015 15:10:59 -0800 (PST)
Date: Tue, 24 Feb 2015 10:10:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: ensure truncate forces zeroed blocks to disk
Message-ID: <20150223231015.GX4251@dastard>
References: <1424299725-26067-1-git-send-email-david@fromorbit.com>
	<20150223205109.GE13522@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150223205109.GE13522@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Feb 23, 2015 at 12:51:09PM -0800, Christoph Hellwig wrote:
> This looks correct, but is there a good (performance) reason against
> simply unconditionally flushing and waiting?

No idea. All I am concerned about is correctness - getting the
partial block flushed in the case that the on-disk size is the same
as the in-memory size is the fix needed here, otherwise the
behaviour should be unchanged.

Given that I'm not sure what the effect of an unconditional flush is
going to be, I'm not going to mix such a change with an otherwise
obvious data corruption fix that we need to backport to other
kernels.  If you have the time to determine there is no performance
impact from an unconditional flush, then I'll happily take the
change. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
