Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 57BC97F3F
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 16:40:45 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D89EEAC001
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 14:40:44 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	0hjuToJTlszGAjQd for <xfs@oss.sgi.com>;
	Fri, 22 Nov 2013 14:40:43 -0800 (PST)
Date: Sat, 23 Nov 2013 09:40:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Filesystem writes on RAID5 too slow
Message-ID: <20131122224038.GH6502@dastard>
References: <CACtJ3HZxp6xEjY_wOucCcqX4scNzEGuiAsovQYObJS9whtYJsQ@mail.gmail.com>
	<528A5C45.4080906@redhat.com> <20131119005740.GY6188@dastard>
	<CACtJ3Ha3C7JNi5VZRnNMn+-okNheygmbj=j9AnUMvfzfZjNwug@mail.gmail.com>
	<20131121092606.GU11434@dastard>
	<CACtJ3HZAsOtmLArMWraygfQxpGymtZjr+a_reXv8o6LJzoMbvw@mail.gmail.com>
	<CACtJ3Ha5P2Heu4qiEEk6c4g+tKyR=RrD-4E-Cqj+bP8YDjKQ6w@mail.gmail.com>
	<20131121234116.GD6502@dastard>
	<20131122092136.GD32568@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131122092136.GD32568@infradead.org>
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
Cc: Martin Boutin <martboutin@gmail.com>, "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>, "Kernel.org-Linux-EXT4" <linux-ext4@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Fri, Nov 22, 2013 at 01:21:36AM -0800, Christoph Hellwig wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The function xfs_bmap_isaeof() is used to indicate that an
> > allocation is occurring at or past the end of file, and as such
> > should be aligned to the underlying storage geometry if possible.
> > 
> > Commit 27a3f8f ("xfs: introduce xfs_bmap_last_extent") changed the
> > behaviour of this function for empty files - it turned off
> > allocation alignment for this case accidentally. Hence large initial
> > allocations from direct IO are not getting correctly aligned to the
> > underlying geometry, and that is cause write performance to drop in
> > alignment sensitive configurations.
> > 
> > Fix it by considering allocation into empty files as requiring
> > aligned allocation again.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Ooops.  The fix looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> 
> Might be worth cooking up a test for this, scsi_debug can expose
> geometry, and we already have it wired to to large sector size
> testing in xfstests.

We don't need to screw around with the sector size - that is
irrelevant to the problem, and we have an allocation alignment
test that is supposed to catch these issues: generic/223.

As I said, I have seen occasional failures of that test (once a
month, on average) as a result of this bug. It was simply not often
enough - running in a hard loop didn't increase the frequency of
failures - to be able debug it or to reach my "there's a regression
I need to look at" threshold. Perhaps we need to revisit that test
and see if we can make it more likely to trigger failures...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
