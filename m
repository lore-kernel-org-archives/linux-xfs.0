Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4HNDF3T204898 for <xfs@oss.sgi.com>; Tue, 17 May 2011 18:13:15 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E7ECF45B4E5
	for <xfs@oss.sgi.com>; Tue, 17 May 2011 16:13:10 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	AQKMB5egb7huR62K for <xfs@oss.sgi.com>;
	Tue, 17 May 2011 16:13:10 -0700 (PDT)
Date: Wed, 18 May 2011 09:13:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: Improve test 219 to work with all filesystems
Message-ID: <20110517231301.GX19446@dastard>
References: <1305644104-612-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1305644104-612-1-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

On Tue, May 17, 2011 at 04:55:04PM +0200, Jan Kara wrote:
> Different filesystems account different amount of metadata in quota. Thus it is
> impractical to check for a particular amount of space occupied by a file
> because there is no right value. Change the test to verify whether the amount
> of space before quotacheck and after quotacheck is the same as other quota
> tests do.

Except that the purpose of the test the accounting correctly matches
the blocks allocated via direct IO, buffered IO and mmap, not that
quota is consistent over a remount.

IOWs, The numbers do actually matter - for example the recent
changes to speculative delayed allocation beyond EOF for buffered IO
in XFS could be causing large numbers of blocks to be left after EOF
incorrectly, but the exact block number check used in the test would
catch that. The method you propose would not catch it at all, and
we'd be oblivous to an undesirable change in behaviour.

IMO, a better filter function would be the way to go - one
that takes into account that there might be some metadata blocks
allocated but not less than 3x48k should have be allocated to the
quotas...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
