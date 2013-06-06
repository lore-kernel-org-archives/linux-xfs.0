Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B54E07F37
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 12:49:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 34B7AAC004
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 10:49:27 -0700 (PDT)
Received: from dkim2.fusionio.com (dkim2.fusionio.com [66.114.96.54]) by
	cuda.sgi.com with ESMTP id 19mI4oN1C54nU8wV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 10:49:26 -0700 (PDT)
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id B68909A0692
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 11:49:25 -0600 (MDT)
Date: Thu, 6 Jun 2013 13:49:22 -0400
From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH] xfstests btrfs/314: test send / receive
Message-ID: <20130606174922.GB29248@localhost.localdomain>
References: <1370532033-20561-1-git-send-email-list.xfs@jan-o-sch.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370532033-20561-1-git-send-email-list.xfs@jan-o-sch.net>
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
Cc: "sbehrens@giantdisaster.de" <sbehrens@giantdisaster.de>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Jun 06, 2013 at 09:20:33AM -0600, Jan Schmidt wrote:
> Basic send / receive functionality test for btrfs. Requires current
> version of fsstress built (-x support). Relies on fssum tool, which is
> not part of the test suite but can skip the test if it is missing.
> 
> Signed-off-by: Jan Schmidt <list.xfs@jan-o-sch.net>
> ---
>  README              |    3 +
>  common/config       |    2 +
>  tests/btrfs/314     |  113 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/314.out |    4 ++
>  tests/btrfs/group   |    1 +
>  5 files changed, 123 insertions(+), 0 deletions(-)
>  create mode 100755 tests/btrfs/314
>  create mode 100644 tests/btrfs/314.out
> 
> diff --git a/README b/README
> index d4d4f31..56b31f0 100644
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
> diff --git a/common/config b/common/config
> index 67c1498..1c11da3 100644
> --- a/common/config
> +++ b/common/config
> @@ -146,6 +146,8 @@ export SED_PROG="`set_prog_path sed`"
>  export BC_PROG="`set_prog_path bc`"
>  [ "$BC_PROG" = "" ] && _fatal "bc not found"
>  
> +export FSSUM_PROG="`set_prog_path fssum`"
> +
>  export PS_ALL_FLAGS="-ef"
>  
>  export DF_PROG="`set_prog_path df`"
> diff --git a/tests/btrfs/314 b/tests/btrfs/314
> new file mode 100755
> index 0000000..2e86428
> --- /dev/null
> +++ b/tests/btrfs/314
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
> diff --git a/tests/btrfs/314.out b/tests/btrfs/314.out
> new file mode 100644
> index 0000000..3d491da
> --- /dev/null
> +++ b/tests/btrfs/314.out
> @@ -0,0 +1,4 @@
> +QA output created by 314
> +*** test send / receive
> +*** done
> +*** unmount
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index bc6c256..3ce34b2 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -9,3 +9,4 @@
>  276 auto rw metadata
>  284 auto
>  307 auto quick
> +314 auto rw metadata
> -- 
> 1.7.2.2
> 

It applys and runs fine with fssum and exits cleanly if it's not there.  The
test itself looks sane, so 

Reviewed-by: Josef Bacik <jbacik@fusionio.com>

Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
