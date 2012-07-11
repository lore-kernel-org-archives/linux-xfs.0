Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6BMhDH8244885 for <xfs@oss.sgi.com>; Wed, 11 Jul 2012 17:43:14 -0500
Date: Wed, 11 Jul 2012 17:48:22 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/2] xfs: regression fixes for 3.5-rc7
Message-ID: <20120711224822.GQ10196@sgi.com>
References: <1342042843-1773-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1342042843-1773-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hey Dave,

On Thu, Jul 12, 2012 at 07:40:41AM +1000, Dave Chinner wrote:
> These two patches need to go to Linus before 3.5 is released. The
> first fixes the btree cursor leak properly, and the second fixes a
> significant performance regression reported by Mel Gorman. Can you
> review them and send them onwards to Linus?

I have some test exposure on the first one, but not on the second.  I'd rather
have a known performance regression in 3.5 than start popping stacks again this
late toward the end of the rc cycle.  I suggest that #2 go in for the 3.6 merge
window and back to 3.5 via -stable.  Any other opinions?

I'll feel better about if after some testing, so I'll get tests running asap.
What testing have you and Mel done?

IMO we should also consider "xfs: prevent recursion in xfs_buf_iorequest", from
Christoph.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
