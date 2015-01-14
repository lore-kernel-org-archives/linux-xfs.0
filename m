Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B759C7F3F
	for <xfs@oss.sgi.com>; Wed, 14 Jan 2015 14:17:22 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A4CB9304053
	for <xfs@oss.sgi.com>; Wed, 14 Jan 2015 12:17:22 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QzZ010ynNBG5P0tq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 14 Jan 2015 12:17:17 -0800 (PST)
Date: Wed, 14 Jan 2015 15:17:10 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v8 9/11] xfstests: generic/043: Test multiple fallocate
	insert/collapse range calls
Message-ID: <20150114201710.GB49511@bfoster.bfoster>
References: <1421165126-3585-1-git-send-email-linkinjeon@gmail.com>
	<1421165126-3585-10-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1421165126-3585-10-git-send-email-linkinjeon@gmail.com>
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
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Wed, Jan 14, 2015 at 01:05:24AM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> This testcase(043) tries to test finsert range a single alternate block
> mulitiple times and test merge code of collase range.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> Cc: Brian Foster<bfoster@redhat.com>
> ---
> Changelog
> v8:
>  - use MKFS_OPTION to use blocksize in configuration and remove loop.
>  - remove trailing space.
>  - compare original file and test file to check data integrity.
> 
>  tests/generic/043     |  100 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/043.out |    3 ++
>  tests/generic/group   |    1 +
>  3 files changed, 104 insertions(+)
>  create mode 100644 tests/generic/043
>  create mode 100644 tests/generic/043.out
> 
> diff --git a/tests/generic/043 b/tests/generic/043
> new file mode 100644
> index 0000000..a5a2d0b
> --- /dev/null
> +++ b/tests/generic/043
> @@ -0,0 +1,100 @@
> +#! /bin/bash
> +# FS QA Test No. generic/043
> +#
> +# Test multiple fallocate insert/collapse range calls on same file.
> +# Call insert range a single alternate block multiple times until the file
> +# is left with 100 extents and as much number of extents. And Call collapse
> +# range about the previously inserted ranges to test merge code of collapse
> +# range. Also check for data integrity and file system consistency.
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2014 Samsung Electronics.  All Rights Reserved.
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
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +
> +_require_scratch
> +_require_xfs_io_command "fiemap"
> +_require_xfs_io_command "finsert"
> +_require_xfs_io_command "fcollapse"
> +_do_die_on_error=y

What is _do_die_on_error for? Seems like that's only relevant for using
_do()?

> +src=$SCRATCH_MNT/testfile
> +dest=$SCRATCH_MNT/testfile.dest
> +BLOCKS=100
> +BSIZE=`get_block_size $SCRATCH_MNT`
> +

rm -f $seqres.full

... to clear out the old .full file.

> +_scratch_mkfs MKFS_OPTIONS >> $seqres.full 2>&1

You don't need MKFS_OPTIONS here. In fact, this currently causes a mkfs
failure (missing $) that we don't detect because we aren't checking that
the mkfs actually succeeds. All we need to do here is:

_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"

If you dig down into _scratch_mkfs(), you'll see that it already
includes $MKFS_OPTIONS and thus formats the fs as specified by the test
config.

It might also be a good idea to check that the _scratch_mount below
succeeds as well...

> +_scratch_mount >> $seqres.full 2>&1
> +length=$(($BLOCKS * $BSIZE))
> +
> +# Write file
> +$XFS_IO_PROG -f -c "pwrite 0 $length" -c fsync $src > /dev/null
> +cp $src $dest
> +

It seems quite unlikely for this to not create a single extent given the
smallish file size and freshly created fs, but who knows with various fs
types, test configurations, test device sizes, etc. Another option could
be to check the starting extent count and verify the ending extent count
matches, rather than assume hardcoded values of 1.

To be honest, even just including the starting extent count in the
golden output (e.g., add an fiemap command here as well) might be good
enough to distinguish that failure path from something going wrong in
the collapse path, should it ever occur.

> +# Insert alternate blocks
> +for (( j=0; j < $(($BLOCKS/2)); j++ )); do
> +	offset=$((($j*$BSIZE)*2))
> +	$XFS_IO_PROG -c "finsert $offset $BSIZE" $dest > /dev/null
> +done
> +
> +# Check if 100 extents are present
> +$XFS_IO_PROG -c "fiemap -v" $dest | grep "^ *[0-9]*:" |wc -l
> +
> +_check_scratch_fs
> +if [ $? -ne 0 ]; then
> +	status=1
> +	exit
> +fi
> +
> +# Collapse alternate blocks
> +for (( j=0; j < $(($BLOCKS/2)); j++ )); do
> +	offset=$((($j*$BSIZE)))
> +	$XFS_IO_PROG -c "fcollapse $offset $BSIZE" $dest > /dev/null
> +done
> +
> +# Check if 1 extents are present
> +$XFS_IO_PROG -c "fiemap -v" $dest | grep "^ *[0-9]*:" |wc -l
> +
> +# compare original file and test file.
> +cmp $src $dest || _fail "file bytes check failed"
> +
> +_check_scratch_fs
> +if [ $? -ne 0 ]; then
> +	status=1
> +	exit
> +fi
> +
> +umount $SCRATCH_MNT
> +

The scratch device is unmounted and checked after each test that uses it
so the above is unnecessary.

Brian

> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/043.out b/tests/generic/043.out
> new file mode 100644
> index 0000000..47a66aa
> --- /dev/null
> +++ b/tests/generic/043.out
> @@ -0,0 +1,3 @@
> +QA output created by 043
> +100
> +1
> diff --git a/tests/generic/group b/tests/generic/group
> index c0944b3..0a10bdd 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -45,6 +45,7 @@
>  040 auto quick prealloc
>  041 auto quick prealloc
>  042 auto quick prealloc
> +043 auto quick prealloc
>  053 acl repair auto quick
>  062 attr udf auto quick
>  068 other auto freeze dangerous stress
> -- 
> 1.7.9.5
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
