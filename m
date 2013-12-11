Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 408587F50
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 16:50:19 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CC16EAC00B
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 14:50:18 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	bm3dENRytA5AjCPB for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 14:50:16 -0800 (PST)
Date: Thu, 12 Dec 2013 09:50:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/12] run more generic tests on TEST_DIR
Message-ID: <20131211225012.GL10988@dastard>
References: <20131211073445.353655850@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131211073445.353655850@bombadil.infradead.org>
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

On Tue, Dec 10, 2013 at 11:34:45PM -0800, Christoph Hellwig wrote:
> As Stanislav pointed out previously various tests worked fine on NFS
> when it still defined a scratch dir that we abused for the test dir.
> 
> This series makes various tests that don't require specific file system
> sizes or parameters run on TEST_DIR instead of using the scratch devices.
> 
> This also allow to remove various bits of boilerplat code as the TEST_DIR
> is always available, and checked after each test.

I'm not sure this is such a good idea. The test_dir is a fixed
filesystem designed to persiste between test harness runs to allow
testing on an aged filesystem.

The scratch dev, OTOH, is used to give tests a known state before the test
begins, and to enable different filesystem configurations to be
tested easily. That is:

$ ./check -g auto

and

$ MKFS_OPTIONS="-b size=512" ./check -g auto

run the tests on a differently configured scratch device. I use this
all the time to change the filesystem config I'm testing against. By
moving all these tests to the TEST_DEV, these tests are no longer
run on the device that is configured specifically the way I want it
configured for the given test run.

So, I think this is a step backwards in terms of being able to
quickly iterate and cover different filesystem configurations, and
as such I don't really like it as a solution. What other options do
we have?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
