Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 194BD7F3F
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 15:20:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A97FAAC002
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 13:19:56 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	EcUWTFaQSC2zEfR7 for <xfs@oss.sgi.com>;
	Tue, 17 Dec 2013 13:19:54 -0800 (PST)
Date: Wed, 18 Dec 2013 08:19:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/12] run more generic tests on TEST_DIR
Message-ID: <20131217211951.GG31386@dastard>
References: <20131211073445.353655850@bombadil.infradead.org>
	<20131211225012.GL10988@dastard>
	<20131212180312.GC19422@infradead.org>
	<20131213010934.GN10988@dastard>
	<20131213111039.GD14884@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131213111039.GD14884@infradead.org>
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

On Fri, Dec 13, 2013 at 03:10:39AM -0800, Christoph Hellwig wrote:
> On Fri, Dec 13, 2013 at 12:09:34PM +1100, Dave Chinner wrote:
> > > You can have different test devices, or simply not bother with aging
> > > it for every run.  You're missing the coverage of all the test dir
> > > using tests, which are a lot with the above version anyway.
> > 
> > IOWs, you're saying that you don't consider MKFS_OPTIONS as a first
> > class citizen. I've been using it for 7 or 8 years for exactly this
> > purpose - iterating testing of a change quickly across multiple
> > configurations without perturbing the long term aging of the test
> > device.
> 
> But you're limiting yourself to the tests only using the scratch
> device for that testing, leaving out all the ones using the TEST
> directory.
> 
> > I'm not opposed to making the change, just pointing out that
> > reducing the usage of the scratch device has a fairly significant
> > impact on test coverage for anyone who uses MKFS_OPTIONS in their
> > workflow...
> 
> It does have an impact for that particular workload, but I think that
> workload is broken as you only test your specific config for those
> tests using the scratch device, and do not get the coverage for the
> tests using the test device.
> 
> git-grep -l TEST_DIR tests/generic/ | grep -v out | wc -l
> 65
> git-grep -l TEST_DIR tests/xfs/ | grep -v out | wc -l 
> 23
> 
> 
> hch@brick:~/work/xfstests$ git-grep -l _require_scratch tests/generic/ | wc -l
> 58
> hch@brick:~/work/xfstests$ git-grep -l _require_scratch tests/xfs/ | wc -l
> 128
> 
> So you're missing close to 2/3s of the tests already.

I think you got that the wrong way around: that's 2/3rds of the
tests (186) use the scratch device rather than the test device.
There's also roughly 100 tests (of ~160) in the quick group that use
the scratch device.

Hence doing smoke tests by simply changing the MKFS_OPTIONS gets a
significant amount of coverage *quickly*, and that's usually more
than sufficient to flush out bugs during development.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
