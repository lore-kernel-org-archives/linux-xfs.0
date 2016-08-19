Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 04BAA7CA2
	for <xfs@oss.sgi.com>; Fri, 19 Aug 2016 16:54:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CB647304039
	for <xfs@oss.sgi.com>; Fri, 19 Aug 2016 14:54:03 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 9L8dj2uRXDnPxwgV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 19 Aug 2016 14:54:01 -0700 (PDT)
Date: Fri, 19 Aug 2016 14:53:54 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 13/17] xfs: test swapext with reflink
Message-ID: <20160819215354.GA15174@birch.djwong.org>
References: <146914477514.11762.3144320628851923350.stgit@birch.djwong.org>
	<146914485888.11762.1688573359701830686.stgit@birch.djwong.org>
	<20160808081359.GB27776@eguan.usersys.redhat.com>
	<20160808174132.GC11291@birch.djwong.org>
	<20160809062943.GF19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160809062943.GF19025@dastard>
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
Cc: fstests@vger.kernel.org, Eryu Guan <eguan@redhat.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Aug 09, 2016 at 04:29:43PM +1000, Dave Chinner wrote:
> On Mon, Aug 08, 2016 at 10:41:32AM -0700, Darrick J. Wong wrote:
> > On Mon, Aug 08, 2016 at 04:13:59PM +0800, Eryu Guan wrote:
> > > On Thu, Jul 21, 2016 at 04:47:38PM -0700, Darrick J. Wong wrote:
> > > > Add a few tests to stress the new swapext code for reflink and rmap.
> > > > +_reflink_range "$testdir/file1" 0 "$testdir/file2" 0 $bytes >> "$seqres.full"
> > > > +
> > > > +echo "Defrag the big file"
> > > > +old_nextents=$(xfs_io -c 'stat -v' $testdir/file1 | grep 'nextents' | cut -d ' ' -f 3)
> > > 
> > > There's a "_count_extents" helper, does that work for this case?
> > 
> > It can, though stat -v reports GETFSXATTR results, which should be faster than
> > _count_extents because the latter FIEMAPs the entire file and counts lines.
> > Seeing as XFS records the extent count in the inode, we might as well use it.
> 
> perhaps put a special xfs case in _count_extents() that does this
> rather than FIEMAP?

Ok.  Seems simple enough to do.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
