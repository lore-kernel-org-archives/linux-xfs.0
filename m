Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2FD5E29DF6
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 19:02:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 218EA8F8040
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 17:02:25 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id cSW4mmSZC766MUFF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Feb 2016 17:02:21 -0800 (PST)
Date: Tue, 9 Feb 2016 17:02:13 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 13/23] xfs: test fragmentation characteristics of
	copy-on-write
Message-ID: <20160210010213.GE6350@birch.djwong.org>
References: <20160209011145.23099.95354.stgit@birch.djwong.org>
	<20160209011309.23099.60912.stgit@birch.djwong.org>
	<20160209080144.GL19486@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160209080144.GL19486@dastard>
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

On Tue, Feb 09, 2016 at 07:01:44PM +1100, Dave Chinner wrote:
> On Mon, Feb 08, 2016 at 05:13:09PM -0800, Darrick J. Wong wrote:
> > Perform copy-on-writes at random offsets to stress the CoW allocation
> > system.  Assess the effectiveness of the extent size hint at
> > combatting fragmentation via unshare, a rewrite, and no-op after the
> > random writes.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ....
> > +seq=`basename "$0"`
> > +seqres="$RESULT_DIR/$seq"
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1    # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +    cd /
> > +    #rm -rf "$tmp".* "$testdir"
> 
> Now that I've noticed it, a few tests have this line commented out.
> Probably should remove the tmp files, at least.

Done.

> > +rm -f "$seqres.full"
> > +
> > +echo "Format and mount"
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount >> "$seqres.full" 2>&1
> > +
> > +testdir="$SCRATCH_MNT/test-$seq"
> > +rm -rf $testdir
> > +mkdir $testdir
> 
> Again, somthing that is repeated - we just mkfs'd the scratch
> device, so the $testdir is guaranteed not to exist...

I've done that to the new tests, will do to the existing ones.

> > +echo "Check for damage"
> > +umount "$SCRATCH_MNT"
> 
> I've also noticed this in a lot of tests - the scratch device will
> be unmounted by the harness, so I don't think this is necessary....

Done.

> > +free_blocks=$(stat -f -c '%a' "$testdir")
> > +real_blksz=$(stat -f -c '%S' "$testdir")
> > +space_needed=$(((blksz * nr * 3) * 5 / 4))
> > +space_avail=$((free_blocks * real_blksz))
> > +internal_blks=$((blksz * nr / real_blksz))
> > +test $space_needed -gt $space_avail && _notrun "Not enough space. $space_avail < $space_needed"
> 
> Why not:
> 
> _require_fs_space $space_needed
> 
> At minimum, it seems to be a repeated hunk of code, so it shoul dbe
> factored.

Ok, done.

> > +testdir="$SCRATCH_MNT/test-$seq"
> > +rm -rf $testdir
> > +mkdir $testdir
> > +
> > +echo "Create the original files"
> > +"$XFS_IO_PROG" -f -c "pwrite -S 0x61 0 0" "$testdir/file1" >> "$seqres.full"
> > +"$XFS_IO_PROG" -f -c "pwrite -S 0x61 0 1048576" "$testdir/file2" >> "$seqres.full"
> > +_scratch_remount
> > +
> > +echo "Set extsz and cowextsz on zero byte file"
> > +"$XFS_IO_PROG" -f -c "extsize 1048576" "$testdir/file1" | _filter_scratch
> > +"$XFS_IO_PROG" -f -c "cowextsize 1048576" "$testdir/file1" | _filter_scratch
> > +
> > +echo "Set extsz and cowextsz on 1Mbyte file"
> > +"$XFS_IO_PROG" -f -c "extsize 1048576" "$testdir/file2" | _filter_scratch
> > +"$XFS_IO_PROG" -f -c "cowextsize 1048576" "$testdir/file2" | _filter_scratch
> > +_scratch_remount
> > +
> > +fn() {
> > +	"$XFS_IO_PROG" -c "$1" "$2" | sed -e 's/.\([0-9]*\).*$/\1/g'
> > +}
> > +echo "Check extsz and cowextsz settings on zero byte file"
> > +test $(fn extsize "$testdir/file1") -eq 1048576 || echo "file1 extsize not set"
> > +test $(fn cowextsize "$testdir/file1") -eq 1048576 || echo "file1 cowextsize not set" 
> 
> For this sort of thing, just dump the extent size value to the
> golden output. i.e.
> 
> echo "Check extsz and cowextsz settings on zero byte file"
> $XFS_IO_PROG -c extsize $testdir/file1
> $XFS_IO_PROG -c cowextsize $testdir/file1
> 
> is all that is needed. that way if it fails, we see what value it
> had instead of the expected 1MB. This also makes the test much less
> verbose and easier to read

Done.

> > +
> > +echo "Check extsz and cowextsz settings on 1Mbyte file"
> > +test $(fn extsize "$testdir/file2") -eq 0 || echo "file2 extsize not set"
> > +test $(fn cowextsize "$testdir/file2") -eq 1048576 || echo "file2 cowextsize not set" 
> > +
> > +echo "Set cowextsize and check flag"
> > +"$XFS_IO_PROG" -f -c "cowextsize 1048576" "$testdir/file3" | _filter_scratch
> > +_scratch_remount
> > +test $("$XFS_IO_PROG" -c "stat" "$testdir/file3" | grep 'fsxattr.xflags' | awk '{print $4}' | grep -c 'C') -eq 1 || echo "file3 cowextsz flag not set"
> > +test $(fn cowextsize "$testdir/file3") -eq 1048576 || echo "file3 cowextsize not set"
> > +"$XFS_IO_PROG" -f -c "cowextsize 0" "$testdir/file3" | _filter_scratch
> > +_scratch_remount
> > +test $(fn cowextsize "$testdir/file3") -eq 0 || echo "file3 cowextsize not set"
> > +test $("$XFS_IO_PROG" -c "stat" "$testdir/file3" | grep 'fsxattr.xflags' | awk '{print $4}' | grep -c 'C') -eq 0 || echo "file3 cowextsz flag not set"
> 
> Same with all these - just grep the output for the line you want,
> and the golden output matching does everything else. e.g. the flag
> check simply becomes:
> 
> $XFS_IO_PROG -c "stat" $testdir/file3 | grep 'fsxattr.xflags'
> 
> Again, this tells us what the wrong flags are if it fails...

Done.  It'll probably break whenever we add new flags, but that can be fixed.

--D

> 
> There are quite a few bits of these tests where the same thing
> applies....
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
