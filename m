Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4JBoPDL032937 for <xfs@oss.sgi.com>; Thu, 19 May 2011 06:50:25 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 019C71653851
	for <xfs@oss.sgi.com>; Thu, 19 May 2011 04:50:23 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id B2OxOplF8pb4SzMd for <xfs@oss.sgi.com>;
	Thu, 19 May 2011 04:50:23 -0700 (PDT)
Date: Thu, 19 May 2011 13:50:01 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] xfstests: Improve test 219 to work with all filesystems
Message-ID: <20110519115001.GF8417@quack.suse.cz>
References: <1305644104-612-1-git-send-email-jack@suse.cz>
	<20110517231301.GX19446@dastard>
	<20110518082422.GD25632@quack.suse.cz>
	<20110518234318.GA32466@dastard>
	<20110519104908.GB8417@quack.suse.cz>
	<20110519111521.GJ32466@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110519111521.GJ32466@dastard>
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

On Thu 19-05-11 21:15:21, Dave Chinner wrote:
> On Thu, May 19, 2011 at 12:49:08PM +0200, Jan Kara wrote:
> > On Thu 19-05-11 09:43:18, Dave Chinner wrote:
> > > On Wed, May 18, 2011 at 10:24:22AM +0200, Jan Kara wrote:
> > > > On Wed 18-05-11 09:13:01, Dave Chinner wrote:
> > > > > On Tue, May 17, 2011 at 04:55:04PM +0200, Jan Kara wrote:
> > > > > > Different filesystems account different amount of metadata in quota. Thus it is
> > > > > > impractical to check for a particular amount of space occupied by a file
> > > > > > because there is no right value. Change the test to verify whether the amount
> > > > > > of space before quotacheck and after quotacheck is the same as other quota
> > > > > > tests do.
> > > > > 
> > > > > Except that the purpose of the test the accounting correctly matches
> > > > > the blocks allocated via direct IO, buffered IO and mmap, not that
> > > > > quota is consistent over a remount.
> > > > > 
> > > > > IOWs, The numbers do actually matter - for example the recent
> > > > > changes to speculative delayed allocation beyond EOF for buffered IO
> > > > > in XFS could be causing large numbers of blocks to be left after EOF
> > > > > incorrectly, but the exact block number check used in the test would
> > > > > catch that. The method you propose would not catch it at all, and
> > > > > we'd be oblivous to an undesirable change in behaviour.
> > > >   Hmm, I guess we think of different errors to catch with the test. I was
> > > > more thinking that the test tries to catch errors where we forget to
> > > > account allocated blocks in quota or so. But you are right, there are other
> > > > tests to catch this although not testing e.g. direct IO I think.
> > > > 
> > > > > IMO, a better filter function would be the way to go - one
> > > > > that takes into account that there might be some metadata blocks
> > > > > allocated but not less than 3x48k should have be allocated to the
> > > > > quotas...
> > > >   OK, but if I just check that the amount of space is >= 3x48k, your
> > > > sample problem with xfs would pass anyway.
> > > 
> > > Not if it was done like we do with the randholes tests (008), where we use
> > > the _within_tolerance function to determine if the number of holes is
> > > accceptible.
> > > 
> > > >
> > > > What would be nice is to know
> > > > the right value but that depends on fs type and also fs parameters (fs
> > > > block size in ext3/ext4) so it would be a bit large chunk of code to
> > > > compute the right value - that's why I chose quotacheck to do the work for
> > > > me...  But I guess I can do that if you think it's worth it.
> > > 
> > > Yes, block size will alter the number of blocks, but remember that
> > > requota is reporting it in kilobytes, so the number should always be
> > > around 144. Hence checking the result is 144 +/- 5% would probably
> > > cover all filesystems and all configurations without an issue, and
> > > it would still catch gross increasing in disk usage...
> >   Ah, OK, that makes sense and works for the common cases I'm aware of (it
> > won't work for example for ext4 with 64k block size, or ocfs2 with large
> > cluster size where allocation unit can be upto 1M). Anyway, it has probably
> > the best effort/result ratio so I'll do this. Thanks for ideas.
> 
> The write size of 48k is completely arbitrary, so if we need to
> change it to work better with larger block sizes, then that is
> easy to do...
> 
> Anyway, there are lots of other tests that will break with 64k block
> sizes, so this is the least of our worries at this point...
  Yes, I think that as well. So when we come across a case we want to test
which will fail, we can change the amount written. So far I just changed
the test so that it works for my ext3 & ext4 tests...

								Honza

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
