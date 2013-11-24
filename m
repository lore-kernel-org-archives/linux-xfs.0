Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A1E397F3F
	for <xfs@oss.sgi.com>; Sun, 24 Nov 2013 17:21:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 93B23304032
	for <xfs@oss.sgi.com>; Sun, 24 Nov 2013 15:21:43 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	U5SlZqshb4ZEW30x for <xfs@oss.sgi.com>;
	Sun, 24 Nov 2013 15:21:41 -0800 (PST)
Date: Mon, 25 Nov 2013 10:21:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Filesystem writes on RAID5 too slow
Message-ID: <20131124232137.GA8803@dastard>
References: <528A5C45.4080906@redhat.com> <20131119005740.GY6188@dastard>
	<CACtJ3Ha3C7JNi5VZRnNMn+-okNheygmbj=j9AnUMvfzfZjNwug@mail.gmail.com>
	<20131121092606.GU11434@dastard>
	<CACtJ3HZAsOtmLArMWraygfQxpGymtZjr+a_reXv8o6LJzoMbvw@mail.gmail.com>
	<CACtJ3Ha5P2Heu4qiEEk6c4g+tKyR=RrD-4E-Cqj+bP8YDjKQ6w@mail.gmail.com>
	<20131121234116.GD6502@dastard>
	<20131122092136.GD32568@infradead.org>
	<20131122224038.GH6502@dastard>
	<20131123084106.GA19088@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131123084106.GA19088@infradead.org>
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

On Sat, Nov 23, 2013 at 12:41:06AM -0800, Christoph Hellwig wrote:
> On Sat, Nov 23, 2013 at 09:40:38AM +1100, Dave Chinner wrote:
> > > geometry, and we already have it wired to to large sector size
> > > testing in xfstests.
> > 
> > We don't need to screw around with the sector size - that is
> > irrelevant to the problem, and we have an allocation alignment
> > test that is supposed to catch these issues: generic/223.
> 
> It didn't imply we need large sector sizes, but the same mechanism
> to expodse a large sector size can also be used to present large
> stripe units/width.
> 
> > As I said, I have seen occasional failures of that test (once a
> > month, on average) as a result of this bug. It was simply not often
> > enough - running in a hard loop didn't increase the frequency of
> > failures - to be able debug it or to reach my "there's a regression
> > I need to look at" threshold. Perhaps we need to revisit that test
> > and see if we can make it more likely to trigger failures...
> 
> Seems like 233 should have cought it regularly with the explicit
> alignment options on mkfs time.  Maybe we also need a test mirroring
> the plain dd more closely?

Preallocation showed the problem, too, so we probably don't even
need dd to check whether allocation alignment is working properly.
We should probably write a test that spefically checks all the
different anlignment/extent size combinations we can use.

Preallocation should behave very similarly to direct IO, but I'm
pretty sure that it won't do things like round up allocations to
stripe unit/widths like direct IO does. The fact that we do
allocation sunit/swidth size alignment for direct Io outside the
allocator and sunit/swidth offset alignment inside the allocation is
kinda funky....

> I've not seen 233 fail for a long time..

Not surprising, it is a one in several hundred test runs occurrence
here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
