Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6K0M1xF060015 for <xfs@oss.sgi.com>; Thu, 19 Jul 2012 19:22:01 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ifThboDkaxrqa8VN for <xfs@oss.sgi.com>;
	Thu, 19 Jul 2012 17:21:48 -0700 (PDT)
Date: Fri, 20 Jul 2012 10:21:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Superblock restore takes too long
Message-ID: <20120720002143.GG23387@dastard>
References: <5C7FE4A5ADF52D46989166B4083DFF8F21ECE1C6@ilmbx02.IL.NDS.com>
	<50082F28.8090905@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50082F28.8090905@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Zak, Semion" <SZak@nds.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Jul 19, 2012 at 11:00:40AM -0500, Eric Sandeen wrote:
> On 7/19/12 4:30 AM, Zak, Semion wrote:
> > Hi,
> > 
> > Corrupted Superblock restore takes too long because xfs_restore searches the disc for reserved Superblock.
> > 
> > Is it possible accelerate the search, for example by giving to xfs_restore some hint (reserved Superblock LBA)?
> > 
> 
> Often when I've seen this it's because the block device wasn't really even an xfs filesystem, and the search went on forever.

Right, it has to read the entire disk to find it. it's slow to do
this. It could be sped up by using readahead rather than the current
"read 1MB, process buffer 512 bytes at a time, read 1MB, ...." so
that it runs at disk speed rather than processing latency speed, but
that's still pretty slow. i.e. it is slow because it is stupid.

Ideally, searching for a secondary superblock should check a
few places before resorting to a full disk search. e.g.:

	- at 1TB offset for large filesystems
	- for small devices at (size / 4) and (size / 16) to catch
	  the two common default mkfs settings

and then if that fails search at the places where the first AG would
be located for a filesystem with 2, 3, 5, 6, 7..... AGs. That woul
dcut down on the search time immensely, and only if that fails would
it be necessary to do a full disk search.

Any takers?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
