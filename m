Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753260AbcKUUAb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Nov 2016 15:00:31 -0500
Date: Mon, 21 Nov 2016 12:00:24 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [f2fs-dev] [PATCH v4] generic/391: check inode metadata on
 f{data}sync after power-cut
Message-ID: <20161121200024.GA66875@jaegeuk>
References: <20161117032753.69315-1-jaegeuk@kernel.org>
 <20161117192051.GE74211@jaegeuk>
 <20161118194549.GE31226@jaegeuk>
 <20161119015745.GB45056@jaegeuk>
 <20161120211958.GH28177@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161120211958.GH28177@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: fstests@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org

On Mon, Nov 21, 2016 at 08:19:58AM +1100, Dave Chinner wrote:
> On Fri, Nov 18, 2016 at 05:57:45PM -0800, Jaegeuk Kim wrote:
> > This patch adds tests/generic/391 to test fsync and fdatasync with power-cuts.
> > 
> > The rule to check is:
> > 1) fsync should guarantee all the inode metadata after power-cut,
> > 2) fdatasync should guarantee i_size and i_blocks at least after power-cut.
> > 
> > Note that, in XFS, it allocates more blocks when doing writes, so it should
> > close the file before fsync in order to get actual i_blocks after power-cut.
> > 
> > Suggested-by: Chao Yu <yuchao0@huawei.com>
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > ---
> >  tests/generic/391     | 149 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/391.out |  11 ++++
> >  tests/generic/group   |   1 +
> >  3 files changed, 161 insertions(+)
> >  create mode 100755 tests/generic/391
> >  create mode 100644 tests/generic/391.out
> > 
> > diff --git a/tests/generic/391 b/tests/generic/391
> > new file mode 100755
> > index 0000000..121e01d
> > --- /dev/null
> > +++ b/tests/generic/391
> > @@ -0,0 +1,149 @@
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
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $tmp.*
> > +}
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
> > +f_stat()
> > +{
> > +	$XFS_IO_PROG -r -c "stat -v" $testfile >$tmp.$1
> > +}
> > +
> > +f_sync()
> > +{
> > +	$XFS_IO_PROG -c "$1" $testfile >/dev/null
> > +}
> 
> This is factoring overkill and...
> 
> > +
> > +# check inode metadata after shutdown
> > +check_inode_metadata()
> > +{
> > +	# prepare syncing metadata
> > +	f_sync $1
> > +
> > +	# get inode metadata #1
> > +	f_stat before
> > +
> > +	# shutdown
> > +	src/godown $SCRATCH_MNT >> $seqres.full
> > +	_scratch_cycle_mount
> > +
> > +	# get inode metadata #2
> > +	f_stat after
> > +
> > +	# compare #1 and #2
> > +	diff $tmp.before $tmp.after >$tmp.diff
> > +
> > +	# fdatasync only cares about i_size and i_blocks
> > +	if [ "$1" = "fdatasync" ]; then
> > +		cat $tmp.diff | grep stat.size
> > +		cat $tmp.diff | grep stat.blocks
> > +	else
> > +		cat $tmp.diff
> > +	fi
> 
> .... forces you to do things like this.
> 
> We have the stat binary for getting specific fields from files.  We
> use it all over the place for exactly this sort of thing.  See, for
> example, _defrag(), which also does this "stat before/stat
> after/compare results" for specific metadata.
> 
> i.e.:
> 
> $ stat -c "blocks: %b size: %s" Makefile
> blocks: 8 size: 3069
> $
> 
> check_inode_metadata()
> {
> 	sync_mode=$1
> 
> 	stat_opts=""
> 	if [ $sync_mode = "fdatasync" ]; then
> 		stat_opts='-c "blocks: %b size: %s"'
> 	fi
> 
> 	$XFS_IO_PROG -c "$sync_mode" $testfile | _filter_xfs_io
> 	before=`stat $stat_opts $testfile`
> 	...
> 	after=`stat $stat_opts $testfile`
> 
> 	if [ $before != $after ]; then
> 		echo "Before: $before"
> 		echo "After: $after"
> 		status=1;		# this is a failure!
> 	fi
> 
> > +	cat $tmp.before >> $seqres.full
> > +	cat $tmp.after >> $seqres.full
> > +
> > +	rm $testfile
> > +}
> > +
> > +# append XX KB with f{data}sync, followed by power-cut
> > +test_i_size()
> > +{
> > +	$XFS_IO_PROG -f -c "pwrite 0 4M"	\
> > +			-c "fsync"		\
> > +			-c "pwrite 4M $2"	\
> > +			$testfile >/dev/null
> 
> Make these all truncate to the final size first like this:
> 
> 	 $XFS_IO_PROG -f -c "truncate 4M"	\
> 			 -c "pwrite 0 4M"	\
> 			 -c "fsync"		\
> 			 -c "pwrite 4M $2"	\
> 			$testfile | _filter_xfs_io
> 
> 	check_inode_metadata $1
> 
> And that will make all the problems with XFS preallocation go away,
> because the initial truncate to set the file size will turn off the
> preallocation.
> 
> > +	$XFS_IO_PROG -f -c "pwrite 0 4M"	\
> > +			-c "fsync"		\
> > +			$testfile >/dev/null
> > +	sleep 1
> > +	touch $testfile
> > +	check_inode_metadata $1
> > +}
> > +
> > +# punch XX KB with f{data}sync, followed by power-cut
> > +test_punch()
> > +{
> > +	echo "==== fpunch $2 test with $1 ====" | tee -a $seqres.full
> > +	$XFS_IO_PROG -f -c "pwrite 0 4202496"	\
> > +			-c "fsync"		\
> > +			-c "fpunch 4194304 $2"\
> > +			$testfile >/dev/null
> > +	check_inode_metadata $1
> > +}
> > +
> > +for i in fsync fdatasync
> > +do
> > +	test_i_size $i 1024
> > +	test_i_size $i 4096
> > +	test_i_time $i
> > +	test_punch $i 1024
> > +	test_punch $i 4096
> > +done
> > +
> > +rm -f $tmp.*
> 
> No need for this here.
> 
> > +
> > +# success, all done
> > +status=0
> 
> Set that at the start before we run the test so that if we detect a
> failure we can set status=1 for exit to handle appropriately.

Thank you so much for the review.
Agreed to all, and let me send v5.

Thanks,

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
