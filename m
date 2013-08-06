Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3D4907F37
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 15:43:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2AB5A8F80A3
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 13:43:31 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id DP9wE5Rj2wt5ThwR (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Aug 2013 13:43:29 -0700 (PDT)
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 4D35B7C06A0
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 14:43:29 -0600 (MDT)
Date: Tue, 6 Aug 2013 16:43:25 -0400
From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH v2 2/2] xfstests btrfs/316: test send / receive
Message-ID: <20130806204325.GB2397@localhost.localdomain>
References: <1374678449-21780-1-git-send-email-list.xfs@jan-o-sch.net>
	<1374678449-21780-3-git-send-email-list.xfs@jan-o-sch.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1374678449-21780-3-git-send-email-list.xfs@jan-o-sch.net>
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
To: Jan Schmidt <list.xfs@jan-o-sch.net>
Cc: sbehrens@giantdisaster.de, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, Jul 24, 2013 at 05:07:29PM +0200, Jan Schmidt wrote:
> Basic send / receive functionality test for btrfs. Requires current
> version of fsstress built (-x support). Relies on fssum tool but can
> skip the test if it failed to build.
> 
> Signed-off-by: Jan Schmidt <list.xfs@jan-o-sch.net>
> ---
>  README              |    3 +
>  tests/btrfs/316     |  113 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/316.out |    4 ++
>  tests/btrfs/group   |    1 +
>  4 files changed, 121 insertions(+), 0 deletions(-)
>  create mode 100755 tests/btrfs/316
>  create mode 100644 tests/btrfs/316.out
> 
> diff --git a/README b/README
> index a49ca7c..d287f63 100644
> --- a/README
> +++ b/README
> @@ -26,6 +26,9 @@ Preparing system for tests (IRIX and Linux):
>        http://www.extra.research.philips.com/udf/, then copy the udf_test 
>        binary to xfstests/src/. If you wish to disable UDF verification test
>        set the environment variable DISABLE_UDF_TEST to 1.
> +    - If you wish to run the btrfs send / receive components of the suite
> +      install fssum from
> +        git://git.kernel.org/pub/scm/linux/kernel/git/arne/far-progs.git
>  	
>      
>      - create one or two partitions to use for testing
> diff --git a/tests/btrfs/316 b/tests/btrfs/316
> new file mode 100755
> index 0000000..2e86428
> --- /dev/null
> +++ b/tests/btrfs/316
> @@ -0,0 +1,113 @@
> +#! /bin/bash
> +# FSQA Test No. 314
> +#
> +# Run fsstress to create a reasonably strange file system, make a
> +# snapshot (base) and run more fsstress. Then take another snapshot
> +# (incr) and send both snapshots to a temp file. Remake the file
> +# system and receive from the files. Check both states with fssum.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (C) 2013 STRATO.  All rights reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#
> +#-----------------------------------------------------------------------
> +#
> +# creator
> +owner=list.btrfs@jan-o-sch.net
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=`mktemp -d`
> +status=1
> +
> +_cleanup()
> +{
> +	echo "*** unmount"
> +	umount $SCRATCH_MNT 2>/dev/null
> +	rm -f $tmp.*
> +}
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_need_to_be_root
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +_require_command $FSSUM_PROG fssum
> +
> +rm -f $seqres.full
> +
> +workout()
> +{
> +	fsz=$1
> +	ops=$2
> +
> +	umount $SCRATCH_DEV >/dev/null 2>&1
> +	echo "*** mkfs -dsize=$fsz"    >>$seqres.full
> +	echo ""                                     >>$seqres.full
> +	_scratch_mkfs_sized $fsz >>$seqres.full 2>&1 \
> +		|| _fail "size=$fsz mkfs failed"
> +	run_check _scratch_mount "-o noatime"
> +
> +	run_check $FSSTRESS_PROG -d $SCRATCH_MNT -n $ops $FSSTRESS_AVOID -x \
> +		"$BTRFS_UTIL_PROG subvol snap -r $SCRATCH_MNT $SCRATCH_MNT/base"
> +
> +	run_check $BTRFS_UTIL_PROG subvol snap -r $SCRATCH_MNT $SCRATCH_MNT/incr
> +
> +	echo "# $BTRFS_UTIL_PROG send $SCRATCH_MNT/base > $tmp/base.snap" \
> +		>> $seqres.full
> +	$BTRFS_UTIL_PROG send $SCRATCH_MNT/base > $tmp/base.snap 2>> $seqres.full \
> +		|| _fail "failed: '$@'"
> +	echo "# $BTRFS_UTIL_PROG send -p $SCRATCH_MNT/base\
> +		$SCRATCH_MNT/incr > $tmp/incr.snap" >> $seqres.full
> +	$BTRFS_UTIL_PROG send -p $SCRATCH_MNT/base \
> +		$SCRATCH_MNT/incr > $tmp/incr.snap 2>> $seqres.full \
> +		|| _fail "failed: '$@'"
> +
> +	run_check $FSSUM_PROG -A -f -w $tmp/base.fssum $SCRATCH_MNT/base
> +	run_check $FSSUM_PROG -A -f -w $tmp/incr.fssum -x $SCRATCH_MNT/incr/base \
> +		$SCRATCH_MNT/incr
> +
> +	umount $SCRATCH_DEV >/dev/null 2>&1
> +	echo "*** mkfs -dsize=$fsz"    >>$seqres.full
> +	echo ""                                     >>$seqres.full
> +	_scratch_mkfs_sized $fsz >>$seqres.full 2>&1 \
> +		|| _fail "size=$fsz mkfs failed"
> +	run_check _scratch_mount "-o noatime"
> +
> +	run_check $BTRFS_UTIL_PROG receive $SCRATCH_MNT < $tmp/base.snap
> +	run_check $FSSUM_PROG -r $tmp/base.fssum $SCRATCH_MNT/base
> +
> +	run_check $BTRFS_UTIL_PROG receive $SCRATCH_MNT < $tmp/incr.snap
> +	run_check $FSSUM_PROG -r $tmp/incr.fssum $SCRATCH_MNT/incr
> +}
> +
> +echo "*** test send / receive"
> +
> +fssize=`expr 2000 \* 1024 \* 1024`
> +ops=200
> +
> +workout $fssize $ops
> +
> +echo "*** done"
> +status=0
> +exit
> diff --git a/tests/btrfs/316.out b/tests/btrfs/316.out
> new file mode 100644
> index 0000000..4564c85
> --- /dev/null
> +++ b/tests/btrfs/316.out
> @@ -0,0 +1,4 @@
> +QA output created by 316
> +*** test send / receive
> +*** done
> +*** unmount
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index bc6c256..11d708a 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -9,3 +9,4 @@
>  276 auto rw metadata
>  284 auto
>  307 auto quick
> +316 auto rw metadata

I applied and ran this locally and gave everything a look over, you can add

Reviewed-by: Josef Bacik <jbacik@fusionio.com>

Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
