Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0BF9E7CBF
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 02:19:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EF60A30408B
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 00:19:05 -0700 (PDT)
Received: from mo-p05-ob.rzone.de (mo-p05-ob.rzone.de [81.169.146.182]) by
	cuda.sgi.com with ESMTP id yRCwrLimHCLMubHX for
	<xfs@oss.sgi.com>; Fri, 07 Jun 2013 00:19:03 -0700 (PDT)
Message-ID: <51B18962.3090504@jan-o-sch.net>
Date: Fri, 07 Jun 2013 09:18:58 +0200
From: Jan Schmidt <list.xfs@jan-o-sch.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests btrfs/314: test send / receive
References: <1370532033-20561-1-git-send-email-list.xfs@jan-o-sch.net>
	<51B0CCC6.2010500@redhat.com>
In-Reply-To: <51B0CCC6.2010500@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Arne Jansen <sensille@gmx.net>, sbehrens@giantdisaster.de, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

(cc Arne for far-progs discussion)

On Thu, June 06, 2013 at 19:54 (+0200), Eric Sandeen wrote:
> On 6/6/13 10:20 AM, Jan Schmidt wrote:
>> Basic send / receive functionality test for btrfs. Requires current
>> version of fsstress built (-x support). Relies on fssum tool, which is
>> not part of the test suite but can skip the test if it is missing.
>>
>> Signed-off-by: Jan Schmidt <list.xfs@jan-o-sch.net>
> 
> w/o commenting on the test itself, I'm a little uneasy about requiring
> some external, not-widely-installed tool for this to run.  The fear is
> that it won't be run as often as it could/should be.

The main purpose is to have it run by developers changing something around btrfs
send / receive and probably the backref walker (while there exists a separate
test not requiring fssum for backrefs). I think we can get them to install fssum.

> Could the same test be done w/o fssum, or should we maybe put a copy
> of fssum into xfstests/src/fssum.c ?

I don't know any adequate replacement for fssum in this case. The purpose is to
build a checksum for a whole file system tree, including data and partly metadata.

I don't feel like copying fssum from far-progs into xfstests, though it probably
won't hurt much. However, I cannot promise we won't make changes to it for
far-progs, probably creating two incompatible versions of fssum in the wild. Arne?

> Or does fssum exist in any standard distro package?

It doesn't. Perhaps Josef can hurry and make a Fedora package for it, if that
prevents a separate copy to xfstests :-)

Thanks,
-Jan

> Thanks,
> -Eric
> 
>> ---
>>  README              |    3 +
>>  common/config       |    2 +
>>  tests/btrfs/314     |  113 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/btrfs/314.out |    4 ++
>>  tests/btrfs/group   |    1 +
>>  5 files changed, 123 insertions(+), 0 deletions(-)
>>  create mode 100755 tests/btrfs/314
>>  create mode 100644 tests/btrfs/314.out
>>
>> diff --git a/README b/README
>> index d4d4f31..56b31f0 100644
>> --- a/README
>> +++ b/README
>> @@ -26,6 +26,9 @@ Preparing system for tests (IRIX and Linux):
>>        http://www.extra.research.philips.com/udf/, then copy the udf_test 
>>        binary to xfstests/src/. If you wish to disable UDF verification test
>>        set the environment variable DISABLE_UDF_TEST to 1.
>> +    - If you wish to run the btrfs send / receive components of the suite
>> +      install fssum from
>> +        git://git.kernel.org/pub/scm/linux/kernel/git/arne/far-progs.git
>>  	
>>      
>>      - create one or two partitions to use for testing
>> diff --git a/common/config b/common/config
>> index 67c1498..1c11da3 100644
>> --- a/common/config
>> +++ b/common/config
>> @@ -146,6 +146,8 @@ export SED_PROG="`set_prog_path sed`"
>>  export BC_PROG="`set_prog_path bc`"
>>  [ "$BC_PROG" = "" ] && _fatal "bc not found"
>>  
>> +export FSSUM_PROG="`set_prog_path fssum`"
>> +
>>  export PS_ALL_FLAGS="-ef"
>>  
>>  export DF_PROG="`set_prog_path df`"
>> diff --git a/tests/btrfs/314 b/tests/btrfs/314
>> new file mode 100755
>> index 0000000..2e86428
>> --- /dev/null
>> +++ b/tests/btrfs/314
>> @@ -0,0 +1,113 @@
>> +#! /bin/bash
>> +# FSQA Test No. 314
>> +#
>> +# Run fsstress to create a reasonably strange file system, make a
>> +# snapshot (base) and run more fsstress. Then take another snapshot
>> +# (incr) and send both snapshots to a temp file. Remake the file
>> +# system and receive from the files. Check both states with fssum.
>> +#
>> +#-----------------------------------------------------------------------
>> +# Copyright (C) 2013 STRATO.  All rights reserved.
>> +#
>> +# This program is free software; you can redistribute it and/or
>> +# modify it under the terms of the GNU General Public License as
>> +# published by the Free Software Foundation.
>> +#
>> +# This program is distributed in the hope that it would be useful,
>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> +# GNU General Public License for more details.
>> +#
>> +# You should have received a copy of the GNU General Public License
>> +# along with this program; if not, write the Free Software Foundation,
>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>> +#
>> +#-----------------------------------------------------------------------
>> +#
>> +# creator
>> +owner=list.btrfs@jan-o-sch.net
>> +
>> +seq=`basename $0`
>> +seqres=$RESULT_DIR/$seq
>> +echo "QA output created by $seq"
>> +
>> +here=`pwd`
>> +tmp=`mktemp -d`
>> +status=1
>> +
>> +_cleanup()
>> +{
>> +	echo "*** unmount"
>> +	umount $SCRATCH_MNT 2>/dev/null
>> +	rm -f $tmp.*
>> +}
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +
>> +# real QA test starts here
>> +_need_to_be_root
>> +_supported_fs btrfs
>> +_supported_os Linux
>> +_require_scratch
>> +_require_command $FSSUM_PROG fssum
>> +
>> +rm -f $seqres.full
>> +
>> +workout()
>> +{
>> +	fsz=$1
>> +	ops=$2
>> +
>> +	umount $SCRATCH_DEV >/dev/null 2>&1
>> +	echo "*** mkfs -dsize=$fsz"    >>$seqres.full
>> +	echo ""                                     >>$seqres.full
>> +	_scratch_mkfs_sized $fsz >>$seqres.full 2>&1 \
>> +		|| _fail "size=$fsz mkfs failed"
>> +	run_check _scratch_mount "-o noatime"
>> +
>> +	run_check $FSSTRESS_PROG -d $SCRATCH_MNT -n $ops $FSSTRESS_AVOID -x \
>> +		"$BTRFS_UTIL_PROG subvol snap -r $SCRATCH_MNT $SCRATCH_MNT/base"
>> +
>> +	run_check $BTRFS_UTIL_PROG subvol snap -r $SCRATCH_MNT $SCRATCH_MNT/incr
>> +
>> +	echo "# $BTRFS_UTIL_PROG send $SCRATCH_MNT/base > $tmp/base.snap" \
>> +		>> $seqres.full
>> +	$BTRFS_UTIL_PROG send $SCRATCH_MNT/base > $tmp/base.snap 2>> $seqres.full \
>> +		|| _fail "failed: '$@'"
>> +	echo "# $BTRFS_UTIL_PROG send -p $SCRATCH_MNT/base\
>> +		$SCRATCH_MNT/incr > $tmp/incr.snap" >> $seqres.full
>> +	$BTRFS_UTIL_PROG send -p $SCRATCH_MNT/base \
>> +		$SCRATCH_MNT/incr > $tmp/incr.snap 2>> $seqres.full \
>> +		|| _fail "failed: '$@'"
>> +
>> +	run_check $FSSUM_PROG -A -f -w $tmp/base.fssum $SCRATCH_MNT/base
>> +	run_check $FSSUM_PROG -A -f -w $tmp/incr.fssum -x $SCRATCH_MNT/incr/base \
>> +		$SCRATCH_MNT/incr
>> +
>> +	umount $SCRATCH_DEV >/dev/null 2>&1
>> +	echo "*** mkfs -dsize=$fsz"    >>$seqres.full
>> +	echo ""                                     >>$seqres.full
>> +	_scratch_mkfs_sized $fsz >>$seqres.full 2>&1 \
>> +		|| _fail "size=$fsz mkfs failed"
>> +	run_check _scratch_mount "-o noatime"
>> +
>> +	run_check $BTRFS_UTIL_PROG receive $SCRATCH_MNT < $tmp/base.snap
>> +	run_check $FSSUM_PROG -r $tmp/base.fssum $SCRATCH_MNT/base
>> +
>> +	run_check $BTRFS_UTIL_PROG receive $SCRATCH_MNT < $tmp/incr.snap
>> +	run_check $FSSUM_PROG -r $tmp/incr.fssum $SCRATCH_MNT/incr
>> +}
>> +
>> +echo "*** test send / receive"
>> +
>> +fssize=`expr 2000 \* 1024 \* 1024`
>> +ops=200
>> +
>> +workout $fssize $ops
>> +
>> +echo "*** done"
>> +status=0
>> +exit
>> diff --git a/tests/btrfs/314.out b/tests/btrfs/314.out
>> new file mode 100644
>> index 0000000..3d491da
>> --- /dev/null
>> +++ b/tests/btrfs/314.out
>> @@ -0,0 +1,4 @@
>> +QA output created by 314
>> +*** test send / receive
>> +*** done
>> +*** unmount
>> diff --git a/tests/btrfs/group b/tests/btrfs/group
>> index bc6c256..3ce34b2 100644
>> --- a/tests/btrfs/group
>> +++ b/tests/btrfs/group
>> @@ -9,3 +9,4 @@
>>  276 auto rw metadata
>>  284 auto
>>  307 auto quick
>> +314 auto rw metadata
>>
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
