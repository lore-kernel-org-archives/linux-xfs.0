Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5E0P0Kw011098 for <xfs@oss.sgi.com>; Sun, 13 Jun 2010 19:25:00 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4F0841BDA109
	for <xfs@oss.sgi.com>; Sun, 13 Jun 2010 17:27:33 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	WCxHSlAM2KWIRDRo for <xfs@oss.sgi.com>;
	Sun, 13 Jun 2010 17:27:33 -0700 (PDT)
Date: Mon, 14 Jun 2010 10:27:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: Make fiemap works with sparse file.
Message-ID: <20100614002705.GA6590@dastard>
References: <1276308495-14267-1-git-send-email-tao.ma@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1276308495-14267-1-git-send-email-tao.ma@oracle.com>
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
To: Tao Ma <tao.ma@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Alex Elder <aelder@sgi.com>, sandeen@sandeen.net, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Sat, Jun 12, 2010 at 10:08:15AM +0800, Tao Ma wrote:
> In xfs_vn_fiemap, we set bvm_count to fi_extent_max + 1 and want
> to return fi_extent_max extents, but actually it won't work for
> a sparse file.

Define "won't work". i.e. what's the test case?  I just created a
sparse file and checked it, and it reported all the extents in it:

# xfs_bmap -vp testfile 
testfile:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..7]:          hole                                     8
   1: [8..15]:         96..103           0 (96..103)            8 00000
   2: [16..23]:        hole                                     8
   3: [24..31]:        112..119          0 (112..119)           8 00000
   4: [32..39]:        hole                                     8
   5: [40..47]:        128..135          0 (128..135)           8 00000
   6: [48..55]:        hole                                     8
   7: [56..63]:        144..151          0 (144..151)           8 00000
   8: [64..71]:        hole                                     8
   9: [72..79]:        160..167          0 (160..167)           8 00000
  10: [80..87]:        hole                                     8
  11: [88..95]:        176..183          0 (176..183)           8 00000
  12: [96..103]:       hole                                     8
  13: [104..111]:      192..199          0 (192..199)           8 00000
  14: [112..119]:      hole                                     8
  15: [120..127]:      208..215          0 (208..215)           8 00000
# filefrag -v testfile 
Filesystem type is: 58465342
File size of testfile is 65536 (16 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       1       12               1 
   1       3       14       12      1 
   2       5       16       14      1 
   3       7       18       16      1 
   4       9       20       18      1 
   5      11       22       20      1 
   6      13       24       22      1 
   7      15       26       24      1 eof
testfile: 9 extents found
#

FWIW, filefrag seems busted - the file has 8 extents, not 9.

For a more fragmented sparse file (25,000 extents):

# for i in `seq 1 2 50000`; do dd if=/dev/zero of=testfile bs=4k count=1 seek=$i; done
....
# xfs_bmap -vp testfile | grep -v hole | wc -l
25002
# filefrag -v testfile |tail -1
testfile: 25001 extents found

So taking away the 2 header lines from xfs_bmap output we have 25000
extents, and filefrag has over-counted by one again. However, we are
we are definitely finding all the extents through fiemap...

> The reason is that in xfs_getbmap we will
> calculate holes and set it in 'out', while out is malloced by
> bmv_count(fi_extent_max+1) which didn't consider holes. So in the
> worst case, if 'out' vector looks like
> [hole, extent, hole, extent, hole, ... hole, extent, hole],
> we will only return half of fi_extent_max extents.

Right, it's not broken, we simply return less than fi_extent_mex
extents when there are holes. I don't see that as a problem as
applications have to handle that case anyway, and....

> So in xfs_vn_fiemap, we should consider this worst case. If the
> user wants fi_extent_max extents, we need a 'out' with size of
> 2 *fi_extent_max + 2(one more the header).

That's rather dangerous, I think. It relies on other code to catch
the buffer overrun that this sets up for fragmented, non-sparse
files. Personally I'd much prefer to return fewer extents for sparse
files than to add a landmine like this into the kernel code....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
