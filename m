Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5C088xD153935 for <xfs@oss.sgi.com>; Mon, 11 Jun 2012 19:08:08 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	5qkbIvuP3bMu847b for <xfs@oss.sgi.com>;
	Mon, 11 Jun 2012 17:08:06 -0700 (PDT)
Date: Tue, 12 Jun 2012 10:08:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: block sizes > 4K ??  possible w/large page support?
Message-ID: <20120612000803.GG22848@dastard>
References: <4FD5643F.5070801@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FD5643F.5070801@tlinx.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Linda A. Walsh" <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sun, Jun 10, 2012 at 08:21:35PM -0700, Linda A. Walsh wrote:
> Is this something being thought about??
> 
> More than one of my hard disks:
> 
> /boot:                 130 files in     103112 4K blocks:    793.6 blks/file
> /tmp:                 1401 files in     746715 4K blocks:    533.4 blks/file
> /var/cache:           1438 files in      87858 4K blocks:     61.5 blks/file
> /backups:              713 files in 2523985177 4K blocks: 3539951.6 blks/file
> /var:                 9038 files in     746715 4K blocks:     83.1 blks/file
> /var/cache/squid:      570 files in      90031 4K blocks:    158.4 blks/file
> /Media:              51893 files in 1691400956 4K blocks:  32594.5 blks/file
> /:                   37312 files in     506778 4K blocks:     14.0 blks/file
> /usr/share:         320805 files in  195425485 4K blocks:    609.6 blks/file
> /backups/Media:      50544 files in 1642550112 4K blocks:  32497.9 blks/file
> /usr:               116650 files in    1389380 4K blocks:     12.4 blks/file
> /Share:            1617995 files in  305269701 4K blocks:    189.1 blks/file
> /home:             5822174 files in  195412389 4K blocks:     34.0 blks/file
> 
> All but 2 could benefit from a 16K block size, and 3 of them could benefit
> from a 128K block size. 

Block size has nothing to do with how efficiently space is indexed
on disk. Remember - XFS uses extents to track used and free space,
and all of the above average blocks per file fit within a couple of
extents on a 4k block size filesystem.

e.g. with 4k block sizes the maximum extent size is 8GB, so an
inode with inline extents (up to 8, I think) can be up to 64GB. a
single extent form block can reference roughly 4096/16 = 256
extents, so file sizes of up to 2TB can be referenced with a single
IO to read the extent list. If we go to 2 IOs, then it's roughly
65000 extents that can be referenced, so once again for most people
this is more than sufficient.

Freespace and other metadata btrees will become shallower with
larger block sizes. However, the one that really matters is the
directory trees and they can already be made with block sizes up to
64k in size even on a 4k block size filesystem....

> Wouldn't that benefit in  in freeing up some space
> both on disk and in memory?  Just a thought.

No, it won't make much difference at all unless you regularly create
sparse files with hundreds of thousands of extents or multi-terabyte
sized files...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
