Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4I8P7KZ227861 for <xfs@oss.sgi.com>; Wed, 18 May 2011 03:25:07 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BA9C74DBB2D
	for <xfs@oss.sgi.com>; Wed, 18 May 2011 01:24:49 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id tWEPQuhdvN1pnFbQ for <xfs@oss.sgi.com>;
	Wed, 18 May 2011 01:24:49 -0700 (PDT)
Date: Wed, 18 May 2011 10:24:22 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] xfstests: Improve test 219 to work with all filesystems
Message-ID: <20110518082422.GD25632@quack.suse.cz>
References: <1305644104-612-1-git-send-email-jack@suse.cz>
	<20110517231301.GX19446@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110517231301.GX19446@dastard>
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
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Wed 18-05-11 09:13:01, Dave Chinner wrote:
> On Tue, May 17, 2011 at 04:55:04PM +0200, Jan Kara wrote:
> > Different filesystems account different amount of metadata in quota. Thus it is
> > impractical to check for a particular amount of space occupied by a file
> > because there is no right value. Change the test to verify whether the amount
> > of space before quotacheck and after quotacheck is the same as other quota
> > tests do.
> 
> Except that the purpose of the test the accounting correctly matches
> the blocks allocated via direct IO, buffered IO and mmap, not that
> quota is consistent over a remount.
> 
> IOWs, The numbers do actually matter - for example the recent
> changes to speculative delayed allocation beyond EOF for buffered IO
> in XFS could be causing large numbers of blocks to be left after EOF
> incorrectly, but the exact block number check used in the test would
> catch that. The method you propose would not catch it at all, and
> we'd be oblivous to an undesirable change in behaviour.
  Hmm, I guess we think of different errors to catch with the test. I was
more thinking that the test tries to catch errors where we forget to
account allocated blocks in quota or so. But you are right, there are other
tests to catch this although not testing e.g. direct IO I think.

> IMO, a better filter function would be the way to go - one
> that takes into account that there might be some metadata blocks
> allocated but not less than 3x48k should have be allocated to the
> quotas...
  OK, but if I just check that the amount of space is >= 3x48k, your
sample problem with xfs would pass anyway. What would be nice is to know
the right value but that depends on fs type and also fs parameters (fs
block size in ext3/ext4) so it would be a bit large chunk of code to
compute the right value - that's why I chose quotacheck to do the work for
me...  But I guess I can do that if you think it's worth it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
