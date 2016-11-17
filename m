Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58260 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965086AbcKQRob (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Nov 2016 12:44:31 -0500
Date: Thu, 17 Nov 2016 07:56:58 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] generic/391: check inode metadata on f{data}sync after
 power-cut
Message-ID: <20161117125658.GA49658@bfoster.bfoster>
References: <20161117032753.69315-1-jaegeuk@kernel.org>
 <20161117083527.GY27776@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161117083527.GY27776@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, fstests@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org

On Thu, Nov 17, 2016 at 04:35:27PM +0800, Eryu Guan wrote:
> [cc'ed linux-xfs for inputs on a flush log issue]
> 
> On Wed, Nov 16, 2016 at 07:27:53PM -0800, Jaegeuk Kim wrote:
> > This patch adds tests/generic/391 to test fsync and fdatasync with power-cuts.
> > 
> > The rule to check is:
> > 1) fsync should guarantee all the inode metadata after power-cut,
> > 2) fdatasync should guarantee i_size and i_blocks at least after power-cut.
> > 
> > Suggested-by: Chao Yu <yuchao0@huawei.com>
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > ---
> >  tests/generic/391     | 125 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/391.out |  11 +++++
> >  tests/generic/group   |   1 +
> >  3 files changed, 137 insertions(+)
> >  create mode 100644 tests/generic/391
> >  create mode 100644 tests/generic/391.out
> > 
> > diff --git a/tests/generic/391 b/tests/generic/391
> > new file mode 100644
> > index 0000000..17c3fd3
> > --- /dev/null
> > +++ b/tests/generic/391
> > @@ -0,0 +1,125 @@
> > +#! /bin/bash
> > +# FS QA Test 391
> > +#
> > +# Test inode's metadata after fsync or fdatasync calls.
> > +# In the case of fsync, filesystem should recover all the inode metadata, while
> > +# recovering i_blocks and i_size at least for fdatasync.
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2016 Jaegeuk Kim.  All Rights Reserved.
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
> > +#
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
> 
> Better to follow the template and other tests on how to do cleanup, i.e.
> trap _cleanup on exit and do real cleanups in it. e.g.
> 
> trap "_cleanup; exit \$status" 0 1 2 3 15
> 
> _cleanup()
> {
> 	cd /
> 	rm -f $tmp.*
> }
> 
> Not a big deal, but it's better to maintain consistency :)
> 
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +. ./common/punch
> > +
> > +# real QA test starts here
> > +_supported_fs generic
> > +_supported_os Linux
> > +
> > +rm -f $seqres.full
> > +_require_scratch
> > +_require_scratch_shutdown
> > +_require_xfs_io_command "fpunch"
> > +
> > +_scratch_mkfs >/dev/null 2>&1
> > +_scratch_mount
> > +
> > +testfile=$SCRATCH_MNT/testfile
> > +
> > +# check inode metadata after shutdown
> > +_check_inode_metadata()
> 
> No need to name local functions with the leading "_", that's for global
> helper functions.
> 
> > +{
> > +	src/godown $SCRATCH_MNT >> $seqres.full
> > +	$XFS_IO_PROG -r -c "stat -v" $1 >$tmp.before
> 
> Shouldn't we call godown *after* xfs_io -c stat? I saw EIO on this
> xfs_io command and all sub-tests reported stat diff.
> 

Yeah.. I haven't run the test, but I would expect pretty much anything
to return an error after an fs shutdown.

> And perhaps we need to flush the log on godown for XFS? i.e.
> 
> src/godown -f $SCRATCH_MNT >> $seqres.full
> 

I don't think this is necessary. The semantics of fsync() dictate that
the fs do what is necessary to make the file persistent on disk. This
means it is the fs responsibility to ensure the changes are logged on
disk. Indeed, xfs_file_fsync() calls _xfs_log_force_lsn() to flush the
log up to the most recent LSN that covered the inode in question.

> Otherwise XFS fails all the "1024" & fsync tests (after I fixed the
> godown & xfs_io order locally), fdatasync tests are fine.
> 
> @@ -1,8 +1,16 @@
>  QA output created by 391
>  ==== i_size 1024 test with fsync ====
> +6c6
> +< stat.blocks = 8200
> +---
> +> stat.blocks = 16256
>  ==== i_size 4096 test with fsync ====
>  ==== i_time test with fsync ====
>  ==== fpunch 1024 test with fsync ====
> +6c6
> +< stat.blocks = 8208
> +---
> +> stat.blocks = 24576
>  ==== fpunch 4096 test with fsync ====
> 
> Not sure if this is the expected behavior on XFS. cc'ed xfs list for
> some inputs.
> 

Am I reading this correctly that you're seeing more blocks than
expected? If so, preallocation perhaps?

Brian

> > +	_scratch_cycle_mount
> > +	$XFS_IO_PROG -r -c "stat -v" $1 >$tmp.after
> > +	diff $tmp.before $tmp.after >>$tmp.diff
> 
> I think $tmp.diff should be overwritten on each sub-test.
> 
> > +
> > +	if [ "$2" = "fdatasync" ]; then
> > +		cat $tmp.diff | grep stat.size
> > +		cat $tmp.diff | grep stat.blocks
> > +	else
> > +		cat $tmp.diff
> > +	fi
> > +	cat $tmp.before >> $seqres.full
> > +	cat $tmp.after >> $seqres.full
> > +}
> > +
> > +# append XX KB with f{data}sync, followed by power-cut
> > +_test_i_size()
> > +{
> > +	echo "==== i_size $2 test with $1 ===="
> 
> I find it's much easier to read the $seqres.full log if we append these
> kind of logs to $seqres.full too, e.g.
> 
> 	echo "==== i_size $2 test with $1 ====" | tee -a $seqres.full
> 
> Thanks,
> Eryu
> 
> > +	$XFS_IO_PROG -f -c "pwrite 0 4M"	\
> > +			-c "fsync"		\
> > +			-c "pwrite 4M $2"	\
> > +			-c "$1"			\
> > +			$testfile >/dev/null
> > +	_check_inode_metadata $testfile $1
> > +}
> > +
> > +# update times with f{data}sync, followed by power-cut
> > +_test_i_time()
> > +{
> > +	echo "==== i_time test with $1 ===="
> > +	$XFS_IO_PROG -f -c "pwrite 0 4M"	\
> > +			-c "fsync"		\
> > +			$testfile >/dev/null
> > +	sleep 1
> > +	touch $testfile
> > +	$XFS_IO_PROG -c "$1"			\
> > +			$testfile >/dev/null
> > +	_check_inode_metadata $testfile $1
> > +}
> > +
> > +# punch XX KB with f{data}sync, followed by power-cut
> > +_test_punch()
> > +{
> > +	echo "==== fpunch $2 test with $1 ===="
> > +	$XFS_IO_PROG -f -c "pwrite 0 4202496"	\
> > +			-c "fsync"		\
> > +			-c "fpunch 4194304 $2"\
> > +			-c "$1"			\
> > +			$testfile >/dev/null
> > +
> > +	_check_inode_metadata $testfile $1
> > +}
> > +
> > +for i in fsync fdatasync
> > +do
> > +	_test_i_size $i 1024
> > +	_test_i_size $i 4096
> > +	_test_i_time $i
> > +	_test_punch $i 1024
> > +	_test_punch $i 4096
> > +done
> > +
> > +rm -f $tmp.*
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/391.out b/tests/generic/391.out
> > new file mode 100644
> > index 0000000..7c66776
> > --- /dev/null
> > +++ b/tests/generic/391.out
> > @@ -0,0 +1,11 @@
> > +QA output created by 391
> > +==== i_size 1024 test with fsync ====
> > +==== i_size 4096 test with fsync ====
> > +==== i_time test with fsync ====
> > +==== fpunch 1024 test with fsync ====
> > +==== fpunch 4096 test with fsync ====
> > +==== i_size 1024 test with fdatasync ====
> > +==== i_size 4096 test with fdatasync ====
> > +==== i_time test with fdatasync ====
> > +==== fpunch 1024 test with fdatasync ====
> > +==== fpunch 4096 test with fdatasync ====
> > diff --git a/tests/generic/group b/tests/generic/group
> > index 08007d7..9de3415 100644
> > --- a/tests/generic/group
> > +++ b/tests/generic/group
> > @@ -392,3 +392,4 @@
> >  387 auto clone
> >  388 auto log metadata
> >  389 auto quick acl
> > +391 auto quick metadata
> > -- 
> > 2.8.3
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
