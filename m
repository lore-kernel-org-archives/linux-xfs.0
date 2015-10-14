Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B12107F37
	for <xfs@oss.sgi.com>; Wed, 14 Oct 2015 16:26:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5E1CDAC002
	for <xfs@oss.sgi.com>; Wed, 14 Oct 2015 14:26:52 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	fzbIJRZ4BmkMjRCa for <xfs@oss.sgi.com>;
	Wed, 14 Oct 2015 14:26:51 -0700 (PDT)
Date: Thu, 15 Oct 2015 08:26:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/51] xfs_db: enable blockget for v5 filesystems
Message-ID: <20151014212630.GO31326@dastard>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
	<20151007050558.1504.97525.stgit@birch.djwong.org>
	<20151014170818.GA10559@infradead.org>
	<20151014182013.GK10397@birch.djwong.org>
	<20151014182344.GA28670@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151014182344.GA28670@infradead.org>
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
Cc: xfs@oss.sgi.com, "Darrick J. Wong" <darrick.wong@oracle.com>

On Wed, Oct 14, 2015 at 11:23:44AM -0700, Christoph Hellwig wrote:
> On Wed, Oct 14, 2015 at 11:20:13AM -0700, Darrick J. Wong wrote:
> > > As is this makes xfstests rather unhappy by failing tests.  I'm not
> > > sure if that's issues in the blockget / xfs_check functionality or
> > > because it actually finds bugs in the kernel code.
> > 
> > Which tests, specifically?  I ran all the tests in the 'quick' group and of
> > the relatively few errors I saw, I couldn't trace any of them back to blockget.
> > 
> > Earlier patch editions caused such problems, but afaict I've fixed them all. :)
> 
> shared/006 xfs/076 xfs/206 xfs/250
> 
> although xfs/206 also fails just due to reflink output from mkfs, but
> I'll send a patch for that soon.

Current failures here with v4.3-rcX on both sides and a current
xfstests:

Failures: generic/042 xfs/076 xfs/078 xfs/079

042 is expected to fail, xfs/076 is testing sparse inodes (check
doesn't understand them), xfs/078 is failing because I'm testing on
4k sector devices and it wants to use a 2k block size.

xfs/079 is failing because repair is reporting:

found illegal null character in symlink inode 16811448
problem with symbolic link in inode 16811448
would have cleared inode 16811448

but the check is clean. So that may be a new regression. I haven't
looked into it more deeply than that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
