Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 42FBE7F54
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 19:27:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 30E48304048
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 17:27:43 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	wgD9XP4tjfZnbEed for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 17:09:43 -0800 (PST)
Date: Fri, 13 Dec 2013 12:09:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/12] run more generic tests on TEST_DIR
Message-ID: <20131213010934.GN10988@dastard>
References: <20131211073445.353655850@bombadil.infradead.org>
	<20131211225012.GL10988@dastard>
	<20131212180312.GC19422@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131212180312.GC19422@infradead.org>
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
Cc: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>, xfs@oss.sgi.com

On Thu, Dec 12, 2013 at 10:03:12AM -0800, Christoph Hellwig wrote:
> On Thu, Dec 12, 2013 at 09:50:12AM +1100, Dave Chinner wrote:
> > I'm not sure this is such a good idea. The test_dir is a fixed
> > filesystem designed to persiste between test harness runs to allow
> > testing on an aged filesystem.
> 
> Yes, and that's exactly what we want for the tests converted.

Well, that assertion is exactly what I'm disagreeing with. It
doesn't help me at all.

> > run the tests on a differently configured scratch device. I use this
> > all the time to change the filesystem config I'm testing against. By
> > moving all these tests to the TEST_DEV, these tests are no longer
> > run on the device that is configured specifically the way I want it
> > configured for the given test run.
> > 
> > So, I think this is a step backwards in terms of being able to
> > quickly iterate and cover different filesystem configurations, and
> > as such I don't really like it as a solution. What other options do
> > we have?
> 
> You can have different test devices, or simply not bother with aging
> it for every run.  You're missing the coverage of all the test dir
> using tests, which are a lot with the above version anyway.

IOWs, you're saying that you don't consider MKFS_OPTIONS as a first
class citizen. I've been using it for 7 or 8 years for exactly this
purpose - iterating testing of a change quickly across multiple
configurations without perturbing the long term aging of the test
device.

IOWs, taking 12 tests away from the scratch device significantly
reduces the coverage of my testing during development. It will
force me to have to change a fairly important part of my workflow -
a part that I haven't needed to change for several years.

I'll now need more VM image storage for the extra test devices I
need, I'll need multiple config files to handle the different test
filesystems, I'll need to write new scripts to mkfs the test devices
as well as setting the MKFS_OPTIONS for the scratch devices and
switch config files, etc.

I'm not opposed to making the change, just pointing out that
reducing the usage of the scratch device has a fairly significant
impact on test coverage for anyone who uses MKFS_OPTIONS in their
workflow...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
