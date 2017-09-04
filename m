Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51110 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752624AbdIDHYd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Sep 2017 03:24:33 -0400
Date: Mon, 4 Sep 2017 15:24:31 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: test the per-inode DAX flag
Message-ID: <20170904072431.GW27835@eguan.usersys.redhat.com>
References: <20170903093325.GA16272@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170903093325.GA16272@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Sun, Sep 03, 2017 at 11:33:25AM +0200, Christoph Hellwig wrote:
> This tests checks that the per-inode DAX flag is either reject
> or sticks around, and that rapidly setting/clearing it will not
> crash the kernel.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Does this test make sense when filesystem was mounted without dax
option? I saw these failures when testing on normal block device without
dax mount option.

    --- tests/xfs/115.out       2017-09-04 11:45:11.628000000 +0800
    +++ /root/workspace/xfstests/results//xfs_4k_crc/xfs/115.out.bad    2017-09-04 15:05:19.433000000 +0800
    @@ -1,4 +1,1004 @@
     QA output created by 115
     checking for DAX flag:
     --------------x- TEST_DIR/test.115
    +xfs_io: cannot set flags on /mnt/testarea/test/test.115: Input/output error
    +./tests/xfs/115: line 82: 15344 Bus error               $here/ltp/fsx -N 1000 $file > $tmp.log 2>&1
    +xfs_io: cannot set flags on /mnt/testarea/test/test.115: Input/output error
    +xfs_io: cannot set flags on /mnt/testarea/test/test.115: Input/output error
    ...

If not, I think we need a new _require_test_dax rule similar to
_require_scratch_dax.

> 
> diff --git a/tests/xfs/115 b/tests/xfs/115
> new file mode 100755
> index 0000000..4b6472f
> --- /dev/null
> +++ b/tests/xfs/115
> @@ -0,0 +1,92 @@
> +#! /bin/bash
> +# FS QA Test 115
> +#
> +# Test that the DAX xflag works, and rapidly setting/clearing it doesn't
> +# crash the kernel
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2017 Christoph Hellwig.  All Rights Reserved.
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
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +file=$TEST_DIR/test.$seq
> +
> +_lets_get_pidst()

Better to name local functions without the leading underscore.

> +{
> +	if [ -n "$pid" ]; then
> +		kill -TERM $pid 2>/dev/null
> +		pid=""
> +		wait 2>/dev/null
> +	fi
> +}
> +
> +_cleanup()
> +{
> +	cd /
> +	_lets_get_pidst
> +	rm -f $tmp.*
> +	rm -f $file*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs xfs
> +_supported_os Linux
> +_require_test
> +
> +# test that the +x flag sticks if we don't get an error
> +touch $file
> +xfs_io -c 'chattr +x' $file > $tmp.log 2>&1
> +if grep -q "Invalid argument" $tmp.log; then
> +    _notrun "file system doesn't support the DAX flag"
> +fi

I think we can add an "chattr" entry in  _require_xfs_io_command, and
actually run chattr command with the given option (-x in this case) to
check the xflag support status. (Then the _require_xfs_io_command usage
in xfs/260 should be fixed.)

> +
> +echo "checking for DAX flag:"
> +xfs_io -c 'lsattr' $file | _filter_test_dir

$XFS_IO_PROG

> +rm -f $file
> +
> +# run fsx racing with setting/clearing the DAX flag
> +$here/ltp/fsx -N 1000 $file > $tmp.log 2>&1 &
> +pid=$!
> +
> +for i in `seq 1 1000`; do
> +    xfs_io -c 'chattr +x' $file
> +    xfs_io -c 'chattr -x' $file
> +done
> +
> +_lets_get_pidst
> +
> +# success, all done
> +echo "*** done"
> +status=0
> +exit
> diff --git a/tests/xfs/115.out b/tests/xfs/115.out
> new file mode 100644
> index 0000000..652276a
> --- /dev/null
> +++ b/tests/xfs/115.out
> @@ -0,0 +1,4 @@
> +QA output created by 115
> +checking for DAX flag:
> +--------------x- TEST_DIR/test.115 
> +*** done
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 5977330..5c02498 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -111,6 +111,7 @@
>  112 fuzzers
>  113 fuzzers
>  114 auto quick clone rmap
> +115 auto rw dangerous

Sometimes test passed for me without triggering any crashes, and it
finished within 10 seconds, can be a 'quick' test too.

Thanks,
Eryu

>  116 quota auto quick
>  117 fuzzers
>  118 auto quick fsr dangerous
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
