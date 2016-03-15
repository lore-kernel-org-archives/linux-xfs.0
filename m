Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 039937CA0
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2016 22:42:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A98098F8033
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2016 20:42:04 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	r7SAyb5MOFtdmEdD for <xfs@oss.sgi.com>;
	Mon, 14 Mar 2016 20:42:02 -0700 (PDT)
Date: Tue, 15 Mar 2016 14:41:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/12] block: test fallocate for block devices
Message-ID: <20160315034148.GF30721@dastard>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
	<20160305003837.28738.49794.stgit@birch.djwong.org>
	<20160305182508.GA25528@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160305182508.GA25528@infradead.org>
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
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

On Sat, Mar 05, 2016 at 10:25:08AM -0800, Christoph Hellwig wrote:
> I'm not sure xfstests is the right fit, as it does not test a file
> system, but rather block devices.
> 
> If people think it should go into xfstests we should at least not
> add it to the default group, but just to a new bdev group.

I think it's the right place to test it - we have all the
infrastructure available to do it (i.e. xfs_io and various block
devices) and we really need to make sure this stuff works,
especially if we start to write filesystem code that depends on
correct behaviour...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
