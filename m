Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA8MRtSg028080 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 16:27:55 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	X4QSnSWX6VlaDR7n for <xfs@oss.sgi.com>;
	Thu, 08 Nov 2012 14:29:52 -0800 (PST)
Date: Fri, 9 Nov 2012 09:29:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] xfstests: speculative preallocaction trimming test
Message-ID: <20121108222949.GT6434@dastard>
References: <1352405889-41186-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1352405889-41186-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Nov 08, 2012 at 03:18:09PM -0500, Brian Foster wrote:
> The speculative preallocation trimming test verifies that files
> with post-EOF blocks are trimmed when the scan is invoked.
> Background scans and the various scan filters are tested as well.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Hi all,
> 
> This is my first stab at an xfstests test for the eofblocks patchset.

A good start!

> This
> depends on the xfs_spaceman tool and associated 'prealloc' command. The bits to
> check the latter command are included for brevity, but I could certainly break
> that stuff into a 1/2 patch in subsequent posts if desired. This has been lightly
> tested against the v7 eofblocks set running in a VM. Thoughts appreciated.

I'll have to get a basic version of the spacemen patchset I have
sent out again so that we can get this into xfsprogs ASAP. I think
we might be waiting until after the release is done before that
happens, though....

> 
>  290           |  176 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  290.out       |   55 ++++++++++++++++++
>  common.config |    1 +
>  common.rc     |   10 +++
>  group         |    1 +
>  5 files changed, 243 insertions(+), 0 deletions(-)
>  create mode 100755 290
>  create mode 100644 290.out
> 
> diff --git a/290 b/290
> new file mode 100755
> index 0000000..12ce9c2
> --- /dev/null
> +++ b/290
> @@ -0,0 +1,176 @@
> +#! /bin/bash
> +# FS QA Test No. 290
> +#
> +# Verify speculative preallocation trimming functionality.

A more verbose description of the test is a good habit to get into.

> +# Write a file of specified size after sending a couple 1 byte writes. The
> +# repeated writes triggers the open-write-close optimization that keeps post-EOF
> +# preallocated space around.
> +_write_prealloc_file()

FWIW, the leading _ in the function names is typically used to
indicate a library function. i.e. something sourced from the
common.* includes. That's to avoid namespace clashes with local
functions that otherwise might have the same name. e.g.
filter_xfs_io vs _filter_xfs_io - the former is a local function,
the latter is defined in common.filter....

> +{
> +	file=$1
> +	size=$2
> +
> +	for i in "1" "1" "$size"
> +	do
> +		$XFS_IO_PROG -f -c "pwrite -b 4k 0 $i" $file \
> +			>> $seq.full 2>&1 || _fail "failed to write file"

Just dump the xfs_io output into $seq.out though the io filter.
There's no need to check for failure to write - the golden output
check will catch that as the first point of failure in the test.
i.e

		$XFS_IO_PROG -f -c "pwrite -b 4k 0 $i" $file | _filter_xfs_io

As it is, it's  good habit to let a test continue to run even if
something fails - the test should continue to completion gracefully
and not trigger corruption or kernel panics, etc. If the failure
mode is a shutdown, for example, the test then exercises behaviour
on a shutdown filesystem. We don't care about the results after the
first failure, but the test should still run through to the end
without hanging or crashing the kernel. Hence I consider peppering
tests with _fail conditions to be a bad practice....

> +	done
> +}
> +
> +_trim_prealloc()
> +{
> +	file=$1
> +	args=$2
> +
> +	$XFS_SPACEMAN_PROG -c "prealloc $args" $file >> $seq.full 2>&1 \
> +		|| _fail "failed to trim file preallocation"

Same again - leave the output in $seq.out, let the golden image
match fail the test. Essentially this brings the function down to a
single line, and hence no need for a function at all...

> +}
> +
> +_stat_files()
> +{
> +	for i in $SCRATCH_MNT/test.*
> +	do
> +		echo -n "$(basename $i) "
> +		stat -c "%s bytes %b blocks" $i
> +	done

That whole function can be replaced by:

	stat -c "%n %s bytes %b blocks" $SCRATCH_MNT/test.* | _filter_scratch

> +}
> +
> +# Create a set of test.* files that fall under different filters for prealloc
> +# scanning.
> +_create_files()
> +{
> +	rm -f $SCRATCH_MNT/test.*
> +	
> +	_write_prealloc_file $SCRATCH_MNT/test.${qa_user} 6m
> +	chown ${qa_user}:${qa_user} $SCRATCH_MNT/test.${qa_user}
> +
> +	_write_prealloc_file $SCRATCH_MNT/test.${qa_user}.root 6m
> +	chown ${qa_user}:root $SCRATCH_MNT/test.${qa_user}.root
> +
> +	_write_prealloc_file $SCRATCH_MNT/test.prid.42 6m
> +	$XFS_QUOTA_PROG -x -c "project -s -p $SCRATCH_MNT/test.prid.42 42" \
> +		$SCRATCH_MNT >> $seq.full 2>&1 || _fail "failed to set project id"
> +
> +	_write_prealloc_file $SCRATCH_MNT/test.10m 10m
> +
> +	_write_prealloc_file $SCRATCH_MNT/test.falloc 6m
> +	$XFS_IO_PROG -c "falloc 0 1" $SCRATCH_MNT/test.falloc \
> +		>> $seq.full 2>&1 || _fail "failed to fallocate file"
> +}
> +
> +_set_speculative_prealloc_lifetime()
> +{
> +	seconds=$1
> +	echo $seconds > /proc/sys/fs/xfs/speculative_prealloc_lifetime || \
> +		_fail "failed to set speculative_prealloc_lifetime"
> +}

I wouldn't bother with a function for this, and once again just let
errors end up in the $seq.out file for golden image matching to
fail.

> +# real QA test starts here
> +_supported_fs xfs
> +_require_xfs_spaceman_prealloc
> +_require_scratch
> +_require_user
> +_require_xfs_quota
> +
> +_scratch_mkfs_xfs -d size=200m >> $seq.full 2>&1 || _fail "mkfs failed"

_scratch_mkfs_sized 200m >> $seq.full 2>&1

And once again, there's generally no need to check for mkfs failure.

> +_scratch_mount
> +
> +echo "==================="
> +echo -e "speculative preallocation trim"
> +
> +_create_files
> +echo -e "\nfiles"

I can't say I like the extra line output here. "pretty" .out
contents isn't really necessary, especially when it makes the test
code harder to read...

> +_stat_files
> +# trim all files
> +_trim_prealloc $SCRATCH_MNT "-s"
> +echo -e "\nno filter"
> +_stat_files

If you are going to put progress output in the $seq.out file (which
I still think is unnecessary), then put it in the function doing
that work.

> +echo -e "\nuid/gid filter"
> +_stat_files
> +
> +echo -e "\n==================="
> +echo -e "background speculative preallocation trim"
> +
> +# Clean up (unmount), set the lifetime to 5s and remount to ensure that the new
> +# lifetime kicks in immediately.
> +
> +_cleanup
> +_set_speculative_prealloc_lifetime 5

old_lifetime=`cat ....`
echo 5 > ....

> +
> +_scratch_mount

Did I miss an unmount somewhere?

> +_create_files
> +
> +# flush and wait a few scan intervals
> +sync
> +sleep 15
> +echo -e "\nbackground scan"
> +_stat_files
> +
> +_set_speculative_prealloc_lifetime 300

echo $old_lifetime > ....

> diff --git a/group b/group
> index a846b60..675d5b5 100644
> --- a/group
> +++ b/group
> @@ -408,3 +408,4 @@ deprecated
>  287 auto dump quota quick
>  288 auto quick ioctl trim
>  289 auto quick
> +290 auto quick

I'd suggest that the rw and ioctl groups are appropriate here as
well.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
