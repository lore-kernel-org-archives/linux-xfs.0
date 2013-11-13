Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ADA127F6F
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 10:10:34 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 303BBAC004
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 08:10:31 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id jmJOfLyNTvcv9STy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 13 Nov 2013 08:10:30 -0800 (PST)
Date: Wed, 13 Nov 2013 08:10:29 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 35/36] repair: Increase default repair parallelism on
	large filesystems
Message-ID: <20131113161029.GD32627@infradead.org>
References: <1384324860-25677-1-git-send-email-david@fromorbit.com>
	<1384324860-25677-36-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1384324860-25677-36-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Wed, Nov 13, 2013 at 05:40:59PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Large filesystems or high AG count filesystems generally have more
> inherent parallelism in the backing storage. We shoul dmake use of
> this by default to speed up repair times. Make xfs_repair use an
> "auto-stride" configuration on filesystems with enough AGs to be
> considered "multidisk" configurations.
> 
> This difference in elaspsed time to repair a 100TB filesystem with
> 50 million inodes in it with all metadata in flash is:
> 
> 		Time	IOPS	BW	CPU	RAM
> vanilla:	2719s	 2900	 55MB/s	 25%	0.95GB
> patched:	 908s	varied	varied	varied	2.33GB
> 
> With the patched kernel, there were IO peaks of over 1.3GB/s during
> AG scanning. Some phases now run at noticably different speeds
> 	- phase 3 ran at ~180% CPU, 18,000 IOPS and 130MB/s,
> 	- phase 4 ran at ~280% CPU, 12,000 IOPS and 100MB/s
> 	- the other phases were similar to the vanilla repair.
> 
> Memory usage is increased because of the increased buffer cache
> size as a result of concurrent AG scanning using it.

Looks good as long as you stick your promise to clean up the magic
numbers later.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
