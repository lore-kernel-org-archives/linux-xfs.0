Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D06157F51
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 15:01:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B76E18F8033
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 13:01:34 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	MLA657cWAhGttjIi for <xfs@oss.sgi.com>;
	Wed, 13 Nov 2013 13:01:31 -0800 (PST)
Date: Thu, 14 Nov 2013 08:01:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 35/36] repair: Increase default repair parallelism on
	large filesystems
Message-ID: <20131113210128.GH6188@dastard>
References: <1384324860-25677-1-git-send-email-david@fromorbit.com>
	<1384324860-25677-36-git-send-email-david@fromorbit.com>
	<20131113161029.GD32627@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131113161029.GD32627@infradead.org>
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
Cc: xfs@oss.sgi.com

On Wed, Nov 13, 2013 at 08:10:29AM -0800, Christoph Hellwig wrote:
> On Wed, Nov 13, 2013 at 05:40:59PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Large filesystems or high AG count filesystems generally have more
> > inherent parallelism in the backing storage. We shoul dmake use of
> > this by default to speed up repair times. Make xfs_repair use an
> > "auto-stride" configuration on filesystems with enough AGs to be
> > considered "multidisk" configurations.
> > 
> > This difference in elaspsed time to repair a 100TB filesystem with
> > 50 million inodes in it with all metadata in flash is:
> > 
> > 		Time	IOPS	BW	CPU	RAM
> > vanilla:	2719s	 2900	 55MB/s	 25%	0.95GB
> > patched:	 908s	varied	varied	varied	2.33GB
> > 
> > With the patched kernel, there were IO peaks of over 1.3GB/s during
> > AG scanning. Some phases now run at noticably different speeds
> > 	- phase 3 ran at ~180% CPU, 18,000 IOPS and 130MB/s,
> > 	- phase 4 ran at ~280% CPU, 12,000 IOPS and 100MB/s
> > 	- the other phases were similar to the vanilla repair.
> > 
> > Memory usage is increased because of the increased buffer cache
> > size as a result of concurrent AG scanning using it.
> 
> Looks good as long as you stick your promise to clean up the magic
> numbers later.

Already got a prototype patch for it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
