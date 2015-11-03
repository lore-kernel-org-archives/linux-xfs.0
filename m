Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4F0807F59
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 03:16:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1D03D304032
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 01:16:14 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id 490BoDgX2pb8eJ1W (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 Nov 2015 01:16:10 -0800 (PST)
Date: Tue, 3 Nov 2015 10:16:05 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/6] xfs: Don't use unwritten extents for DAX
Message-ID: <20151103091605.GA4063@quack.suse.cz>
References: <1445225238-30413-1-git-send-email-david@fromorbit.com>
	<1445225238-30413-4-git-send-email-david@fromorbit.com>
	<20151029142950.GE11663@bfoster.bfoster>
	<20151029233756.GS19199@dastard>
	<20151030123657.GC54905@bfoster.bfoster>
	<20151102011433.GW19199@dastard>
	<20151102141509.GA29346@bfoster.bfoster>
	<20151102214424.GJ10656@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151102214424.GJ10656@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, ross.zwisler@linux.intel.com, dan.j.williams@intel.com

On Tue 03-11-15 08:44:24, Dave Chinner wrote:
> Realistically, dax_clear_blocks() should probably be implemented at
> the pmem driver layer through blkdev_issue_zeroout() because all it
> does is directly map the sector/len to pfn via bdev_direct_access()
> and then zero it - it's a sector based, block device operation. We
> don't actually need a special case path for DAX here. Optimisation
> of this operation has little to do with the filesystem.

Yep. This is actually what I did in ext4 - the block zeroing is using the
ext4 block zeroout path which ends up calling blkdev_issue_zeroout(). I
didn't want to special-case DAX and figured out that if we want
performance, we should implement blkdev_issue_zeroout() efficiently for
pmem. After all ext4 uses blkdev_issue_zeroout() in other extent conversion
cases where zeroing out is needed.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
