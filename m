Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4J2fnoM010908 for <xfs@oss.sgi.com>; Wed, 18 May 2011 21:41:49 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5B59DCE4CC6
	for <xfs@oss.sgi.com>; Wed, 18 May 2011 19:41:46 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	8sGd98mUEwhu5qsA for <xfs@oss.sgi.com>;
	Wed, 18 May 2011 19:41:46 -0700 (PDT)
Date: Thu, 19 May 2011 12:41:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [XFS Tests Punch Hole 3/3 v3] XFS TESTS: Add Fallocate Punch
	Hole Test
Message-ID: <20110519024143.GG32466@dastard>
References: <4DD43305.7090508@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DD43305.7090508@linux.vnet.ibm.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Allison Henderson <achender@linux.vnet.ibm.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>, xfs-oss <xfs@oss.sgi.com>

On Wed, May 18, 2011 at 01:58:45PM -0700, Allison Henderson wrote:
> This patch adds punch hole tests that are based off the test scripts that were 
> used to test and develop punch hole for ext4.  The tests use the new common 
> routines in common.punch to run through various corners cases for punching holes.  

It's really just a slightly different set of corner cases to what
252 tests, and there's quite a bit of overlap. What your tests don't
do is test different combinations of extent type conversions and he
splits and merges which, historically, have been the major source of
bugs with hole punching...

Adding your various cases to 252 (generic_test_punch) would be a much
better idea, I think.

With that in mind:

> +# Small Hole Test

Covered by 252, case 2 "into allocated space".

> +# Big Hole and Hole Removal Test

Covered by 252, cases 11, 12 and 13. it doesn't need to write 600MB
files to do this, and in the case of XFS, a 600MB file is still only
a single extent, so the test is behaving according to your desire on
XFS.

> +# also ensure the all of the extents are properly
> +# removed when the file is deleted.

That's covered by the removing of the test file between test
cases in 252.

> +#record how many blocks free blocks the filesystem has after the test
> +fs_used_after_test=`df --block-size=$block_size $TEST_DEV | grep $TEST_DEV | awk '{ print $3 }'`
> +fs_avail_after_test=`df --block-size=$block_size $TEST_DEV | grep $TEST_DEV | awk '{ print $4 }'`
> +
> +if [ $fs_used_before_test != $fs_used_after_test ] || \
> +   [ $fs_avail_before_test != $fs_avail_after_test ]; then
> +
> +	echo Error: File system did not reclaim the correct number of blocks
> +	echo The number of used and available blocks should be the same before and after the test
> +	echo Used blocks before test: $fs_used_before_test
> +	echo Available blocks before test: $fs_avail_before_test
> +	echo Used blocks after test: $fs_used_after_test
> +	echo Available blocks after test: $fs_avail_after_test
> +	status=1 ; exit
> +else
> +	echo Big Hole and Hole Removal Test OK
> +fi

Again, the filesystem free block count tests are simply not
reliable. I'm pretty sure that this simply won't work on btrfs....

> +# Last Block Hole Test

Not directly handled by 252. Easily added, though.

	echo "  14. data -> hole @ EOF"
	rm -f $testfile
	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
		-c "pwrite 0 20k" -c "fsync" \
		-c "$zero_cmd 12k 8k" \
		-c "$map_cmd -v" $testfile | $filter_cmd
	[ $? -ne 0 ] && die_now

> +# First Block Hole Test

Same here

	echo "  15. data -> hole @ 0"
	rm -f $testfile
	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
		-c "pwrite 0 20k" -c "fsync" \
		-c "$zero_cmd 0k 8k" \
		-c "$map_cmd -v" $testfile | $filter_cmd
	[ $? -ne 0 ] && die_now

> +# Cold Cache Hole Test
> +#
> +# This test is similar to the Small Hole Test, but the drive is 
> +# unmounted and remounted before the hole is punched out to make 
> +# sure that there are no pages in the cache. This test verifies
> +# that the hole contains zeros even when the pages are cold.
> +#----------------------------------------------------------------------
> +echo Running Cold Cache Hole Test
> +file_len=40960
> +hole_offset=8180
> +hole_len=8180
> +_hole_test -m -s -c $file_len $testfile $hole_offset $hole_len
> +echo Cold Cache Hole Test OK

Not directly tested in 252, but easily added via:

	echo "  15. data -> cache cold ->hole"
	rm -f $testfile
	rm -f $testfile.2
	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
		-c "pwrite 8k 12k" -c "fsync" $testfile.2
	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
		-c "pwrite 0 20k" -c "fsync" \
		-c "$zero_cmd 0k 8k" \
		-c "fadvise -d" \
		-c "$map_cmd -v" $testfile | $filter_cmd
	diff $testfile $testfile.2
	[ $? -ne 0 ] && die_now
	rm -f $testfile.2


> +# Extended Last Block Hole Test
> +#
> +# This test cases punches a hole in 10K file from bytes 32768 to 45056
> +# resulting in a hole that extends beyond the end of the file.  This 
> +# test verifies that the code appropriately handles punching holes 
> +# that extend beyond the end of the file
> +#----------------------------------------------------------------------
> +echo Running Last Block Hole Test
> +file_len=40960
> +hole_offset=32768
> +hole_len=12288
> +_hole_test -s -c $file_len $testfile $hole_offset $hole_len
> +echo Last Block Hole Test OK

That's effectively a repeat of the "data -> hole @ EOF" test.
Realistically, this test needs to be run with preallocation beyond
EOF to show that it can punch extents beyond EOF....

> +# Off Edge Hole Test

Just using a non-block aligned start hole offset in the above test
will cover this one as well. No need for multiple tests that
effectively do the same thing.

> +# One Block Hole Test

If anyone is doing this in an application, they deserve what they
get :/

	echo "  16. data -> hole in single block file"
	rm -f $testfile
	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 512" \
		-c "pwrite 0 512" -c "fsync" \
		-c "$zero_cmd 128 128" \
		-c "$map_cmd -v" $testfile | $filter_cmd
	[ $? -ne 0 ] && die_now

> +# Delayed Allocation Hole Test
> +#
> +# This test is similar to the Small Hole Test, but the file is not sync'd 
> +# to the disk before the hole is punched out. This will test the codes 
> +# ability to punch holes in delayed extents and also ensure that dirty
> +# pages are zero'd properly
> +#----------------------------------------------------------------------
> +echo Running Delayed Allocation Hole Test
> +file_len=40960
> +hole_offset=8180
> +hole_len=8180
> +_hole_test -c $file_len $testfile $hole_offset $hole_len
> +echo Delayed Allocation Hole Test OK

If you want to test this properly, you need to run all the 252 tests
without the fsync after the data write so the extents are still
delalloc before the other operations are done. i.e. make the fsync
command a variable like map_cmd and zero_cmd.

> +
> +# Pre Allocation Hole Test

Already covered by case 3 "into unwritten space".

> +# Multi Hole Test

Far better to redo the whole punch series without removing the file
in-between the individual tests. That will cover far more edge
conditions that "same hole, 12 bytes lower, 12 bytes higher and 4k
higher." As it is, the last test is already covered by 252.

> +# Multi Hole Test Front

And in doing so would cover this case.

> +# Multi Hole Test Delayed

and this case without needing any extra work.

And the good part about extending 252 (from my persepctive) is that
test 242 (for the XFS_IOC_ZERO_RANGE ioctl) will also get better
coverage. And if I add the fallocate zero-range equivalent, it will
also be easy to test for all these cases, too, just by running
test_generic_punch with a different zero command....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
