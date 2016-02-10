Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2744A29DF5
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 19:06:41 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 15C0E8F8040
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 17:06:41 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id cdSdbHvsfZXDApp4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Feb 2016 17:06:39 -0800 (PST)
Date: Tue, 9 Feb 2016 17:06:31 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 18/23] xfs: test the automatic cowextsize extent garbage
	collector
Message-ID: <20160210010631.GG6350@birch.djwong.org>
References: <20160209011145.23099.95354.stgit@birch.djwong.org>
	<20160209011342.23099.23019.stgit@birch.djwong.org>
	<20160209081547.GN19486@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160209081547.GN19486@dastard>
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
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com

On Tue, Feb 09, 2016 at 07:15:47PM +1100, Dave Chinner wrote:
> On Mon, Feb 08, 2016 at 05:13:42PM -0800, Darrick J. Wong wrote:
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > +
> > +_cleanup()
> > +{
> > +    cd /
> > +    echo $old_cow_lifetime > /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime
> > +    #rm -rf "$tmp".* "$testdir"
> 
> uncomment.
> 
> > +echo "CoW and leave leftovers"
> > +echo $old_cow_lifetime > /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime
> > +seq 2 2 $((nr - 1)) | while read f; do
> > +	"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz * f)) 1" "$testdir/file2" >> "$seqres.full"
> > +	"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz * f)) 1" "$testdir/file2.chk" >> "$seqres.full"
> > +done
> 
> Ok, I just realised what was bugging me about these loops: "f" is
> not a typical loop iterator for a count. Normally we'd use "i" for
> these....
> 
> > +echo "old extents: $old_extents" >> "$seqres.full"
> > +echo "new extents: $new_extents" >> "$seqres.full"
> > +echo "maximum extents: $internal_blks" >> "$seqres.full"
> > +test $new_extents -lt $((internal_blks / 7)) || _fail "file2 badly fragmented"
> 
> I wouldn't use _fail like this, echo is sufficient to cause the test
> to fail.

Ok, fixed.

--D

> > +echo "Check for damage"
> > +umount "$SCRATCH_MNT"
> > +
> > +# success, all done
> > +status=0
> > +exit
> 
> As would getting rid of the unmount and just setting status
> appropriately...
> 
> /repeat
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
