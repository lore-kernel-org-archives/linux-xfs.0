Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1037F7CA0
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 01:29:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 79E3FAC002
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2016 23:29:49 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	8Zye8THLQlfU8RnE for <xfs@oss.sgi.com>;
	Mon, 08 Aug 2016 23:29:46 -0700 (PDT)
Date: Tue, 9 Aug 2016 16:29:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 13/17] xfs: test swapext with reflink
Message-ID: <20160809062943.GF19025@dastard>
References: <146914477514.11762.3144320628851923350.stgit@birch.djwong.org>
	<146914485888.11762.1688573359701830686.stgit@birch.djwong.org>
	<20160808081359.GB27776@eguan.usersys.redhat.com>
	<20160808174132.GC11291@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160808174132.GC11291@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, Eryu Guan <eguan@redhat.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Aug 08, 2016 at 10:41:32AM -0700, Darrick J. Wong wrote:
> On Mon, Aug 08, 2016 at 04:13:59PM +0800, Eryu Guan wrote:
> > On Thu, Jul 21, 2016 at 04:47:38PM -0700, Darrick J. Wong wrote:
> > > Add a few tests to stress the new swapext code for reflink and rmap.
> > > +_reflink_range "$testdir/file1" 0 "$testdir/file2" 0 $bytes >> "$seqres.full"
> > > +
> > > +echo "Defrag the big file"
> > > +old_nextents=$(xfs_io -c 'stat -v' $testdir/file1 | grep 'nextents' | cut -d ' ' -f 3)
> > 
> > There's a "_count_extents" helper, does that work for this case?
> 
> It can, though stat -v reports GETFSXATTR results, which should be faster than
> _count_extents because the latter FIEMAPs the entire file and counts lines.
> Seeing as XFS records the extent count in the inode, we might as well use it.

perhaps put a special xfs case in _count_extents() that does this
rather than FIEMAP?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
