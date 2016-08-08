Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ED9EA7CA1
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2016 12:59:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 65CA4AC002
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2016 10:59:48 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id zecFLhpAH9MfVUPo (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Aug 2016 10:59:45 -0700 (PDT)
Date: Mon, 8 Aug 2016 10:59:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 14/17] xfs: more rmapbt tests
Message-ID: <20160808175928.GD11291@birch.djwong.org>
References: <146914477514.11762.3144320628851923350.stgit@birch.djwong.org>
	<146914486527.11762.1173224384905616811.stgit@birch.djwong.org>
	<20160808084814.GC27776@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160808084814.GC27776@eguan.usersys.redhat.com>
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
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Aug 08, 2016 at 04:48:14PM +0800, Eryu Guan wrote:
> On Thu, Jul 21, 2016 at 04:47:45PM -0700, Darrick J. Wong wrote:
> > More tests for the reverse mapping functionality.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tests/xfs/876     |   76 +++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/876.out |    4 ++
> >  tests/xfs/877     |   85 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/877.out |   10 ++++++
> >  tests/xfs/group   |    4 ++
> >  5 files changed, 178 insertions(+), 1 deletion(-)
> >  create mode 100755 tests/xfs/876
> >  create mode 100644 tests/xfs/876.out
> >  create mode 100755 tests/xfs/877
> >  create mode 100644 tests/xfs/877.out
> > 
> > 
> > diff --git a/tests/xfs/876 b/tests/xfs/876
> > new file mode 100755
> > index 0000000..cf73d40
> > --- /dev/null
> > +++ b/tests/xfs/876
> > @@ -0,0 +1,76 @@
> > +#! /bin/bash
> > +# FS QA Test No. 876
> > +#
> > +# Create a big enough rmapbt that we tickle a fdblocks accounting bug.
> 
> This test failed post-test fs check as well
> 
> "sb_fdblocks 3912360, counted 3912522"
> 
> Seems like it's a known bug?

(Yes, it should be fixed in the -wtf branch, as noted in a previous reply.)

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
> > +. ./common/attr
> 
> Seems this is not needed.
> 
> > +. ./common/reflink
> > +
> > +# real QA test starts here
> > +_supported_os Linux
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
> > +isize=$(xfs_info $SCRATCH_MNT | grep isize | sed -e 's/^.*isize=\([0-9]*\).*$/\1/g')
> 
> We usually get isize from the output of _filter_mkfs, e.g.
> 
> _scratch_mkfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
> . $tmp.mkfs
> 
> Then all mkfs info is set accordingly, including $isize
> 
> But in this test, isize is got but not used. Remove the line?

Ok.

> > +
> > +bt_ptrs=$(( (blksz - 56) / 44 ))
> > +bt_recs=$(( (blksz - 56) / 24 ))
> > +
> > +blocks=$((bt_ptrs * bt_recs + 1))
> > +_require_fs_space $SCRATCH_MNT $(( (2 * blocks * blksz) * 5 / 4096 ))
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
> > index 0000000..9700263
> > --- /dev/null
> > +++ b/tests/xfs/877
> > @@ -0,0 +1,85 @@
> > +#! /bin/bash
> > +# FS QA Test No. 877
> > +#
> > +# Make sure query_range returns -EINVAL if lowkey > highkey.
> 
> This test failed too, is this expected (again, tested with your
> djwong-experimental branck kernel and xfsprogs)?
> 
> [root@dhcp-66-86-11 xfstests]# diff -u tests/xfs/877.out /root/workspace/xfstests/results//xfs_reflink/xfs/877.out.bad
> --- tests/xfs/877.out   2016-08-08 16:22:35.151000000 +0800
> +++ /root/workspace/xfstests/results//xfs_reflink/xfs/877.out.bad       2016-08-08 16:23:12.405000000 +0800
> @@ -7,4 +7,3 @@
>  Unmount
>  Try a regular fsmap
>  Try a bad fsmap
> -Error 22 while querying fsmap btree.

During the code review of the XFS function that underlies GETFSMAP
(query_range), someone suggested that it should return -EINVAL if someone
queries start > end rather than simply returning no results, so this is
the xfstest to ensure that happens.

(It's in the -wtf branch.)

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
> 
> > +
> > +# real QA test starts here
> > +_supported_os Linux
> 
> _supported_fs xfs
> 
> > +_require_xfs_scratch_rmapbt
> 
> _require_xfs_io_command commands used in this test? e.g. falloc, fpunch, fcollapse and finsert

Ok.

> And '_require_command "$XFS_DB_PROG" "xfs_db"'

I'm assuming this is a new requirement to declare explicitly that we're
going to use xfs_db?  All of the existing tests/xfs/ tests assume
that XFS_DB_PROG is always set.

> 
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
> > +od -tx1 -Ad -c $SCRATCH_MNT/f1 >> $seqres.full
> > +
> > +echo "Unmount"
> > +_scratch_unmount
> > +
> > +echo "Try a regular fsmap"
> > +$XFS_DB_PROG -c 'fsmap' $SCRATCH_DEV >> $seqres.full
> > +$XFS_DB_PROG -c 'fsmap 0 5' $SCRATCH_DEV >> $seqres.full
> > +
> > +echo "Try a bad fsmap"
> > +$XFS_DB_PROG -c 'fsmap 5 4' $SCRATCH_DEV
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
> > index 16f7947..f81f899 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -3,8 +3,8 @@
> >  003 db auto quick
> >  004 db auto quick
> >  005 auto quick
> > -007 auto quota quick
> >  006 auto quick mount
> > +007 auto quota quick
> 
> This is already fixed in upstream, not needed.

Ok.  It'll probably fix itself when I rebase.

--D
> 
> Thanks,
> Eryu
> 
> >  008 rw ioctl auto quick
> >  009 rw ioctl auto prealloc quick
> >  010 auto quick repair
> > @@ -309,3 +309,5 @@
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
