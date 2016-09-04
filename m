Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 597AF7CA1
	for <xfs@oss.sgi.com>; Sun,  4 Sep 2016 12:40:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D2A05AC001
	for <xfs@oss.sgi.com>; Sun,  4 Sep 2016 10:40:25 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 4V9GTD7bgkKrBbE2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 04 Sep 2016 10:40:23 -0700 (PDT)
Date: Sun, 4 Sep 2016 10:40:15 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/13] xfs: more rmapbt tests
Message-ID: <20160904174015.GB15309@birch.djwong.org>
References: <147216769914.32641.55434969009554013.stgit@birch.djwong.org>
	<147216775128.32641.13355812513622220212.stgit@birch.djwong.org>
	<20160901083332.GB27776@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160901083332.GB27776@eguan.usersys.redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com

On Thu, Sep 01, 2016 at 04:33:32PM +0800, Eryu Guan wrote:
> On Thu, Aug 25, 2016 at 04:29:11PM -0700, Darrick J. Wong wrote:
> > More tests for the reverse mapping functionality.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tests/xfs/876     |   75 +++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/876.out |    4 ++
> >  tests/xfs/877     |   92 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/877.out |   10 ++++++
> >  tests/xfs/group   |    2 +
> >  5 files changed, 183 insertions(+)
> >  create mode 100755 tests/xfs/876
> >  create mode 100644 tests/xfs/876.out
> >  create mode 100755 tests/xfs/877
> >  create mode 100644 tests/xfs/877.out
> > 
> > 
> > diff --git a/tests/xfs/876 b/tests/xfs/876
> > new file mode 100755
> > index 0000000..7f447c9
> > --- /dev/null
> > +++ b/tests/xfs/876
> > @@ -0,0 +1,75 @@
> > +#! /bin/bash
> > +# FS QA Test No. 876
> > +#
> > +# Create a big enough rmapbt that we tickle a fdblocks accounting bug.
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
> > +#
> > +# This program is free software; you can redistribute it and/or
> > +# modify it under the terms of the GNU General Public License as
> > +# published by the Free Software Foundation.
> > +#
> > +# This program is distributed in the hope that it would be useful,
> > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +# GNU General Public License for more details.
> > +#
> > +# You should have received a copy of the GNU General Public License
> > +# along with this program; if not, write the Free Software Foundation,
> > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > +#-----------------------------------------------------------------------
> > +
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
> > +	cd /
> > +	rm -rf "$tmp".*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +. ./common/reflink
> > +
> > +# real QA test starts here
> > +_supported_os Linux
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_xfs_scratch_rmapbt
> > +_require_scratch_reflink
> > +_require_test_program "punch-alternating"
> > +
> > +rm -f "$seqres.full"
> > +
> > +echo "+ create scratch fs"
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +
> > +echo "+ mount fs image"
> > +_scratch_mount
> > +blksz="$(stat -f $SCRATCH_MNT -c '%S')"
> 
> There's "get_block_size" helper to do this.

D'oh.  Ok, noted.

> > +
> > +bt_ptrs=$(( (blksz - 56) / 44 ))
> > +bt_recs=$(( (blksz - 56) / 24 ))
> 
> It's unclear to me where do these magic numbers come from. Add some
> comments?

56 bytes is the size of the rmap btree block header.  44 bytes is the size of
rmapbt key+pointer size, and rmapbt records are 24 bytes each.

> > +
> > +blocks=$((bt_ptrs * bt_recs + 1))
> > +_require_fs_space $SCRATCH_MNT $(( (2 * blocks * blksz) * 5 / 4096 ))
> 
> _require_fs_space requires the last argument is represented in 1k block
> size, so it should be " / 1024" here?

4096 is fine, because we're baking a (4 * 1024) into it:

I need a big enough FS to store two (blocks * blksz) files, and then
an extra 25% (5 / 4) space to cover (hopefully) the log and metadata.
So the size calculation is really:

fs_sz_in_kb = 2 * (blocks * blksz) * (5/4) / 1024

> > +len=$((blocks * blksz))
> > +
> > +echo "+ make some files"
> > +$XFS_IO_PROG -f -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCRATCH_MNT/f1 >> $seqres.full
> > +$XFS_IO_PROG -f -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCRATCH_MNT/f2 >> $seqres.full
> > +./src/punch-alternating $SCRATCH_MNT/f1 >> "$seqres.full"
> > +./src/punch-alternating $SCRATCH_MNT/f2 >> "$seqres.full"
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/876.out b/tests/xfs/876.out
> > new file mode 100644
> > index 0000000..96c1970
> > --- /dev/null
> > +++ b/tests/xfs/876.out
> > @@ -0,0 +1,4 @@
> > +QA output created by 876
> > ++ create scratch fs
> > ++ mount fs image
> > ++ make some files
> > diff --git a/tests/xfs/877 b/tests/xfs/877
> > new file mode 100755
> > index 0000000..2ad7d30
> > --- /dev/null
> > +++ b/tests/xfs/877
> > @@ -0,0 +1,92 @@
> > +#! /bin/bash
> > +# FS QA Test No. 877
> > +#
> > +# Make sure query_range returns -EINVAL if lowkey > highkey.
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
> > +#
> > +# This program is free software; you can redistribute it and/or
> > +# modify it under the terms of the GNU General Public License as
> > +# published by the Free Software Foundation.
> > +#
> > +# This program is distributed in the hope that it would be useful,
> > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +# GNU General Public License for more details.
> > +#
> > +# You should have received a copy of the GNU General Public License
> > +# along with this program; if not, write the Free Software Foundation,
> > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > +#-----------------------------------------------------------------------
> > +
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
> > +	cd /
> > +	rm -rf "$tmp".* $metadump_file
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +. ./common/attr
> 
> Seems this is not needed.

Right.

> > +
> > +# real QA test starts here
> > +_supported_os Linux
> > +_supported_fs xfs
> > +_require_xfs_scratch_rmapbt
> > +_require_command "$XFS_DB_PROG" "xfs_db"
> > +_require_xfs_io_command "falloc"
> > +_require_xfs_io_command "fpunch"
> > +_require_xfs_io_command "fzero"
> > +_require_xfs_io_command "fcollapse"
> > +_require_xfs_io_command "finsert"
> > +
> > +rm -f "$seqres.full"
> > +
> > +echo "Format and mount"
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount
> > +blksz=65536
> > +blocks=16
> > +len=$((blocks * blksz))
> > +
> > +echo "Create some files"
> > +$XFS_IO_PROG -f -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCRATCH_MNT/f1 >> $seqres.full
> > +
> > +echo "Manipulate file"
> > +$XFS_IO_PROG -c "fpunch $blksz $blksz" \
> > +	-c "fzero $((3 * blksz)) $blksz" \
> > +	-c "pwrite -S 0x69 $((5 * blksz)) $blksz" \
> > +	-c "fpunch $((7 * blksz)) $blksz" \
> > +	-c "fsync" \
> > +	-c "pwrite -S 0x70 $((7 * blksz)) $blksz" \
> > +	-c "fcollapse $((9 * blksz)) $blksz" \
> > +	-c "finsert $((10 * blksz)) $blksz" $SCRATCH_MNT/f1 >> $seqres.full
> > +
> > +echo "Check file"
> > +md5sum $SCRATCH_MNT/f1 | _filter_scratch
> 
> I'm a bit confused by the md5sum, f1 is not checked again for
> comparison, what's the purpose of this checksum?

This test checks that xfs_io can send properly formatted GETFSMAP ioctls to the
kernel to query the filesystem mappings.  Hence we spit out the md5 to make
sure that the file contents match what we just wrote to the file, so that we
actually /have/ some mappings to report.

--D

> 
> Thanks,
> Eryu
> 
> > +od -tx1 -Ad -c $SCRATCH_MNT/f1 >> $seqres.full
> > +
> > +echo "Unmount"
> > +_scratch_unmount
> > +
> > +echo "Try a regular fsmap"
> > +$XFS_DB_PROG -c 'fsmap' `_scratch_xfs_db_options` >> $seqres.full
> > +$XFS_DB_PROG -c 'fsmap 0 5' `_scratch_xfs_db_options` >> $seqres.full
> > +
> > +echo "Try a bad fsmap"
> > +$XFS_DB_PROG -c 'fsmap 5 4' `_scratch_xfs_db_options`
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/877.out b/tests/xfs/877.out
> > new file mode 100644
> > index 0000000..4a2242f
> > --- /dev/null
> > +++ b/tests/xfs/877.out
> > @@ -0,0 +1,10 @@
> > +QA output created by 877
> > +Format and mount
> > +Create some files
> > +Manipulate file
> > +Check file
> > +e45c5707fcf6817e914ffb6ce37a0ac7  SCRATCH_MNT/f1
> > +Unmount
> > +Try a regular fsmap
> > +Try a bad fsmap
> > +Error 22 while querying fsmap btree.
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index 8565204..72580e9 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -311,3 +311,5 @@
> >  873 auto quick clone fsr
> >  874 auto quick clone fsr
> >  875 auto quick clone fsr quota
> > +876 auto quick rmap clone
> > +877 auto quick rmap clone
> > 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
